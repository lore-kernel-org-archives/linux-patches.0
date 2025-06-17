Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BB61E8332;
	Tue, 17 Jun 2025 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174368; cv=none; b=VKZJCrSvsz+a9Fz6o/sbgEAozigSHgta6qwi2+G//KFbLg6B6LtYYjUQLZKE2eBZ8bRqSXi7EZbpvnjzXBdD90mbLPBjzIc8bekmA+cFABsnZyupMZipz4Pk9xY6Bn3wfAtOqttxLfR+kwjHjIIAKWn2cMbunnBHw87VFSZRS0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174368; c=relaxed/simple;
	bh=IOIky2Vz3PwyvIQUK8tOkM69Kpcd4wdKB2qsPQokVM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/EP834dGlG8yYUrW10pmrd/AhlPa0jUEfcZIJ4yUVwPuxXMBL9E6er7F0VCAvJQk4/rZ43aAJ/PuDdI6pxun6K6NcfMxNERmFCEUhn2d31yB8u1OiuiK90Sm3ICPSFfcx3kT3/kidabjiUgsiUqeVZhmcJbAWLkS0VivZlzn3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUINDsYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUINDsYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E84C4CEF2;
	Tue, 17 Jun 2025 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174368;
	bh=IOIky2Vz3PwyvIQUK8tOkM69Kpcd4wdKB2qsPQokVM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUINDsYP2YM4WAolHnqepXvRUclmqM3SALCkhMq60KIHZ+MLlXN6jHLVG+m710zPq
	 KM6F3fUaWiKWWOoWSV9S0LlgFrOQDFDoTl6fxRfOPEk4QaVttL7wa2x+QWhZbdI0yL
	 FCL59+K4iofzZLvMsyYCJMVrG5emytnyeiwIr/8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/356] btrfs: scrub: update device stats when an error is detected
Date: Tue, 17 Jun 2025 17:22:26 +0200
Message-ID: <20250617152339.481170731@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit ec1f3a207cdf314eae4d4ae145f1ffdb829f0652 ]

[BUG]
Since the migration to the new scrub_stripe interface, scrub no longer
updates the device stats when hitting an error, no matter if it's a read
or checksum mismatch error. E.g:

  BTRFS info (device dm-2): scrub: started on devid 1
  BTRFS error (device dm-2): unable to fixup (regular) error at logical 13631488 on dev /dev/mapper/test-scratch1 physical 13631488
  BTRFS warning (device dm-2): checksum error at logical 13631488 on dev /dev/mapper/test-scratch1, physical 13631488, root 5, inode 257, offset 0, length 4096, links 1 (path: file)
  BTRFS error (device dm-2): unable to fixup (regular) error at logical 13631488 on dev /dev/mapper/test-scratch1 physical 13631488
  BTRFS warning (device dm-2): checksum error at logical 13631488 on dev /dev/mapper/test-scratch1, physical 13631488, root 5, inode 257, offset 0, length 4096, links 1 (path: file)
  BTRFS info (device dm-2): scrub: finished on devid 1 with status: 0

Note there is no line showing the device stats error update.

[CAUSE]
In the migration to the new scrub_stripe interface, we no longer call
btrfs_dev_stat_inc_and_print().

[FIX]
- Introduce a new bitmap for metadata generation errors
  * A new bitmap
    @meta_gen_error_bitmap is introduced to record which blocks have
    metadata generation mismatch errors.

  * A new counter for that bitmap
    @init_nr_meta_gen_errors, is also introduced to store the number of
    generation mismatch errors that are found during the initial read.

    This is for the error reporting at scrub_stripe_report_errors().

  * New dedicated error message for unrepaired generation mismatches

  * Update @meta_gen_error_bitmap if a transid mismatch is hit

- Add btrfs_dev_stat_inc_and_print() calls to the following call sites
  * scrub_stripe_report_errors()
  * scrub_write_endio()
    This is only for the write errors.

This means there is a minor behavior change:

- The timing of device stats error message
  Since we concentrate the error messages at
  scrub_stripe_report_errors(), the device stats error messages will all
  show up in one go, after the detailed scrub error messages:

   BTRFS error (device dm-2): unable to fixup (regular) error at logical 13631488 on dev /dev/mapper/test-scratch1 physical 13631488
   BTRFS warning (device dm-2): checksum error at logical 13631488 on dev /dev/mapper/test-scratch1, physical 13631488, root 5, inode 257, offset 0, length 4096, links 1 (path: file)
   BTRFS error (device dm-2): unable to fixup (regular) error at logical 13631488 on dev /dev/mapper/test-scratch1 physical 13631488
   BTRFS warning (device dm-2): checksum error at logical 13631488 on dev /dev/mapper/test-scratch1, physical 13631488, root 5, inode 257, offset 0, length 4096, links 1 (path: file)
   BTRFS error (device dm-2): bdev /dev/mapper/test-scratch1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
   BTRFS error (device dm-2): bdev /dev/mapper/test-scratch1 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0

Fixes: e02ee89baa66 ("btrfs: scrub: switch scrub_simple_mirror() to scrub_stripe infrastructure")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index da49bdb70375b..97c17025b31e6 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -153,12 +153,14 @@ struct scrub_stripe {
 	unsigned int init_nr_io_errors;
 	unsigned int init_nr_csum_errors;
 	unsigned int init_nr_meta_errors;
+	unsigned int init_nr_meta_gen_errors;
 
 	/*
 	 * The following error bitmaps are all for the current status.
 	 * Every time we submit a new read, these bitmaps may be updated.
 	 *
-	 * error_bitmap = io_error_bitmap | csum_error_bitmap | meta_error_bitmap;
+	 * error_bitmap = io_error_bitmap | csum_error_bitmap |
+	 *		  meta_error_bitmap | meta_generation_bitmap;
 	 *
 	 * IO and csum errors can happen for both metadata and data.
 	 */
@@ -166,6 +168,7 @@ struct scrub_stripe {
 	unsigned long io_error_bitmap;
 	unsigned long csum_error_bitmap;
 	unsigned long meta_error_bitmap;
+	unsigned long meta_gen_error_bitmap;
 
 	/* For writeback (repair or replace) error reporting. */
 	unsigned long write_error_bitmap;
@@ -673,7 +676,7 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
 	}
 	if (stripe->sectors[sector_nr].generation !=
 	    btrfs_stack_header_generation(header)) {
-		bitmap_set(&stripe->meta_error_bitmap, sector_nr, sectors_per_tree);
+		bitmap_set(&stripe->meta_gen_error_bitmap, sector_nr, sectors_per_tree);
 		bitmap_set(&stripe->error_bitmap, sector_nr, sectors_per_tree);
 		btrfs_warn_rl(fs_info,
 		"tree block %llu mirror %u has bad generation, has %llu want %llu",
@@ -685,6 +688,7 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
 	bitmap_clear(&stripe->error_bitmap, sector_nr, sectors_per_tree);
 	bitmap_clear(&stripe->csum_error_bitmap, sector_nr, sectors_per_tree);
 	bitmap_clear(&stripe->meta_error_bitmap, sector_nr, sectors_per_tree);
+	bitmap_clear(&stripe->meta_gen_error_bitmap, sector_nr, sectors_per_tree);
 }
 
 static void scrub_verify_one_sector(struct scrub_stripe *stripe, int sector_nr)
@@ -973,8 +977,22 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
 			if (__ratelimit(&rs) && dev)
 				scrub_print_common_warning("header error", dev, false,
 						     stripe->logical, physical);
+		if (test_bit(sector_nr, &stripe->meta_gen_error_bitmap))
+			if (__ratelimit(&rs) && dev)
+				scrub_print_common_warning("generation error", dev, false,
+						     stripe->logical, physical);
 	}
 
+	/* Update the device stats. */
+	for (int i = 0; i < stripe->init_nr_io_errors; i++)
+		btrfs_dev_stat_inc_and_print(stripe->dev, BTRFS_DEV_STAT_READ_ERRS);
+	for (int i = 0; i < stripe->init_nr_csum_errors; i++)
+		btrfs_dev_stat_inc_and_print(stripe->dev, BTRFS_DEV_STAT_CORRUPTION_ERRS);
+	/* Generation mismatch error is based on each metadata, not each block. */
+	for (int i = 0; i < stripe->init_nr_meta_gen_errors;
+	     i += (fs_info->nodesize >> fs_info->sectorsize_bits))
+		btrfs_dev_stat_inc_and_print(stripe->dev, BTRFS_DEV_STAT_GENERATION_ERRS);
+
 	spin_lock(&sctx->stat_lock);
 	sctx->stat.data_extents_scrubbed += stripe->nr_data_extents;
 	sctx->stat.tree_extents_scrubbed += stripe->nr_meta_extents;
@@ -983,7 +1001,8 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
 	sctx->stat.no_csum += nr_nodatacsum_sectors;
 	sctx->stat.read_errors += stripe->init_nr_io_errors;
 	sctx->stat.csum_errors += stripe->init_nr_csum_errors;
-	sctx->stat.verify_errors += stripe->init_nr_meta_errors;
+	sctx->stat.verify_errors += stripe->init_nr_meta_errors +
+				    stripe->init_nr_meta_gen_errors;
 	sctx->stat.uncorrectable_errors +=
 		bitmap_weight(&stripe->error_bitmap, stripe->nr_sectors);
 	sctx->stat.corrected_errors += nr_repaired_sectors;
@@ -1029,6 +1048,8 @@ static void scrub_stripe_read_repair_worker(struct work_struct *work)
 						    stripe->nr_sectors);
 	stripe->init_nr_meta_errors = bitmap_weight(&stripe->meta_error_bitmap,
 						    stripe->nr_sectors);
+	stripe->init_nr_meta_gen_errors = bitmap_weight(&stripe->meta_gen_error_bitmap,
+							stripe->nr_sectors);
 
 	if (bitmap_empty(&stripe->init_error_bitmap, stripe->nr_sectors))
 		goto out;
@@ -1143,6 +1164,9 @@ static void scrub_write_endio(struct btrfs_bio *bbio)
 		bitmap_set(&stripe->write_error_bitmap, sector_nr,
 			   bio_size >> fs_info->sectorsize_bits);
 		spin_unlock_irqrestore(&stripe->write_error_lock, flags);
+		for (int i = 0; i < (bio_size >> fs_info->sectorsize_bits); i++)
+			btrfs_dev_stat_inc_and_print(stripe->dev,
+						     BTRFS_DEV_STAT_WRITE_ERRS);
 	}
 	bio_put(&bbio->bio);
 
@@ -1505,10 +1529,12 @@ static void scrub_stripe_reset_bitmaps(struct scrub_stripe *stripe)
 	stripe->init_nr_io_errors = 0;
 	stripe->init_nr_csum_errors = 0;
 	stripe->init_nr_meta_errors = 0;
+	stripe->init_nr_meta_gen_errors = 0;
 	stripe->error_bitmap = 0;
 	stripe->io_error_bitmap = 0;
 	stripe->csum_error_bitmap = 0;
 	stripe->meta_error_bitmap = 0;
+	stripe->meta_gen_error_bitmap = 0;
 }
 
 /*
-- 
2.39.5



