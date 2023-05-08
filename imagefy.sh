#!/bin/bash

# Check if input file name is provided as argument
if [ $# -eq 0 ]
  then
    echo "Please provide input file name as argument"
    exit 1
fi

# Set input and output file names
INPUT="$1"
OUTPUT="$1"

# Convert input file to PNG format with specified options
convert -density 300 "$INPUT" -depth 8 -strip -background white -alpha off -scene 1 imagefy_output_%03d.png

# Get the total number of pages
NUM_PAGES=$(ls imagefy_output_*.png | wc -l)

# Pad the page numbers with zeros
for i in $(seq -f "%03g" 1 $NUM_PAGES)
do
  if [ -e "imagefy_output_$i.png" ]
  then
    continue
  else
    mv "imagefy_output$i.png" "imagefy_output_$i.png"
  fi
done

# Convert the processed PNG to the desired output format with maximum quality
convert -quality 100 $(for i in $(seq -f "%03g" 1 $NUM_PAGES); do echo -n "imagefy_output_$i.png "; done) "$OUTPUT"

# Clean up temporary PNG files
rm imagefy_output_*.png

