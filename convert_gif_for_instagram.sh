#!/bin/bash

# Check if the input file is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input.gif>"
    exit 1
fi

# Input GIF file
input_file=$1

# Extract filename without extension
filename=$(basename -- "$input_file")
filename_no_ext="${filename%.*}"

# Step 1: Convert input.gif to output.mp4 with scaling
ffmpeg -i "$input_file" -vf "scale=1280:1280:force_original_aspect_ratio=decrease,pad=1280:1280:(ow-iw)/2:(oh-ih)/2" "output_$filename_no_ext.mp4"

# Step 2: Create a text file listing output.mp4 four times
echo -e "file 'output_$filename_no_ext.mp4'\nfile 'output_$filename_no_ext.mp4'\nfile 'output_$filename_no_ext.mp4'\nfile 'output_$filename_no_ext.mp4'" > list.txt

# Step 3: Concatenate output.mp4 with itself four times to create final.mp4
ffmpeg -f concat -i list.txt -c copy "$filename_no_ext.mp4"

# Step 4: Cleanup temporary files
rm "output_$filename_no_ext.mp4" list.txt

echo "Processing complete. $filename_no_ext.mp4 has been created."
