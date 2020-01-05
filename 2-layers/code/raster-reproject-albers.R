### This code should reproject a raster to a custom Albers Conic Equal Area CRS for the North Atlantic

library(raster)
library(rgdal)
library(sp)


## Load the raster
atlantic_wgs84 <- raster(file.choose()) 

## Define Albers Conic Equal CRS
albers <-"+proj=aea +x_0=0 +y_0=0 +lon_0=-30 +lat_0=30 +lat_1=43 +lat_2=62 +units=m +ellps=WGS84 +datum=WGS84 +no_defs"

## Now transform!
atlantic_albers <- projectRaster(atlantic_wgs84, crs=albers)

## Now write
writeRaster(atlantic_albers, "test.tif", format="GTiff", overwrite=TRUE)

## OPTIONAL: changing the cell size
horizontal <- 125/52.3 #new cell width/old cell width
vertical <- 125/114  #new cell height/ old cell height

atlantic_albers_aggregated <- aggregate(atlantic_albers, fact=c(horizontal, vertical), fun=mean, filename="iceland_albers_emodnet_resampled.tif")

## OPTIONAL calculate slope 

raster_slope <- terrain(atlantic_albers, opt="slope", unit="degrees", neighbors=8, filename="iceland_bathymetry_slope.tif")

## OPTIONAL calculate aspect

raster_aspect <- terrain(atlantic_albers, opt="aspect", unit="degrees", neighbors=8, filename="iceland_bathymetry_aspect.tif")
