Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D2A1F8699;
	Tue, 17 Dec 2024 17:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456404; cv=none; b=JAVWogb81XLqnmEHAXcsy8Gep0aG8k92dXzS/YRZdMRiggrFjMNhjHZdq60NmUe1MUKqwMR/lqItTzKIBBMGgNM8GvenF+VF+nidyXcVu2/r3TSmhgJr11fP2ggIYuSy6A53g0Aw6Dg4l9b2ujN7EcelHEA5poy05w8sfL7UQKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456404; c=relaxed/simple;
	bh=h5cxc4Roue7K6HMrHmmT4vEYI9/raittNC3GiB06PMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odOZD+WKq9mbVsVku+e6FOzo5URlojDGKi5vmtHP1ZOmpoSsqEF0aQXYTwIv+QqBP4dJkAkoEG67Jyve5yIKz9A6U9GT70A1e1Zt3xAHmIJ98w1/7NNuQtEzB90Cd3rn0RAEIplNSnueV3qACiDijaiy2IzbOVNNOe3M3C2IYag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HW62UZlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HW62UZlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AD2C4CED3;
	Tue, 17 Dec 2024 17:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456403;
	bh=h5cxc4Roue7K6HMrHmmT4vEYI9/raittNC3GiB06PMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HW62UZlJqm+YXFNnYlQztMxXLwst4eW7oPJj9OhwAnN5wbFAZjl5wPr1NV79aB5QQ
	 0FBqA33SZVHxDn6Jm/O4jPdIzaKcF25iXwrCundOpUlH4xLvLrtC+fl+KM2gyvgBGE
	 24MeS7lwx4ECPA1E96ybZLuYiZdMrqJ5w20Xb9vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 019/172] dm: Fix dm-zoned-reclaim zone write pointer alignment
Date: Tue, 17 Dec 2024 18:06:15 +0100
Message-ID: <20241217170547.054829616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit b76b840fd93374240b59825f1ab8e2f5c9907acb upstream.

The zone reclaim processing of the dm-zoned device mapper uses
blkdev_issue_zeroout() to align the write pointer of a zone being used
for reclaiming another zone, to write the valid data blocks from the
zone being reclaimed at the same position relative to the zone start in
the reclaim target zone.

The first call to blkdev_issue_zeroout() will try to use hardware
offload using a REQ_OP_WRITE_ZEROES operation if the device reports a
non-zero max_write_zeroes_sectors queue limit. If this operation fails
because of the lack of hardware support, blkdev_issue_zeroout() falls
back to using a regular write operation with the zero-page as buffer.
Currently, such REQ_OP_WRITE_ZEROES failure is automatically handled by
the block layer zone write plugging code which will execute a report
zones operation to ensure that the write pointer of the target zone of
the failed operation has not changed and to "rewind" the zone write
pointer offset of the target zone as it was advanced when the write zero
operation was submitted. So the REQ_OP_WRITE_ZEROES failure does not
cause any issue and blkdev_issue_zeroout() works as expected.

However, since the automatic recovery of zone write pointers by the zone
write plugging code can potentially cause deadlocks with queue freeze
operations, a different recovery must be implemented in preparation for
the removal of zone write plugging report zones based recovery.

Do this by introducing the new function blk_zone_issue_zeroout(). This
function first calls blkdev_issue_zeroout() with the flag
BLKDEV_ZERO_NOFALLBACK to intercept failures on the first execution
which attempt to use the device hardware offload with the
REQ_OP_WRITE_ZEROES operation. If this attempt fails, a report zone
operation is issued to restore the zone write pointer offset of the
target zone to the correct position and blkdev_issue_zeroout() is called
again without the BLKDEV_ZERO_NOFALLBACK flag. The report zones
operation performing this recovery is implemented using the helper
function disk_zone_sync_wp_offset() which calls the gendisk report_zones
file operation with the callback disk_report_zones_cb(). This callback
updates the target write pointer offset of the target zone using the new
function disk_zone_wplug_sync_wp_offset().

dmz_reclaim_align_wp() is modified to change its call to
blkdev_issue_zeroout() to a call to blk_zone_issue_zeroout() without any
other change needed as the two functions are functionnally equivalent.

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20241209122357.47838-4-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c             |  141 +++++++++++++++++++++++++++++++++++-------
 drivers/md/dm-zoned-reclaim.c |    6 -
 include/linux/blkdev.h        |    3 
 3 files changed, 124 insertions(+), 26 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -115,6 +115,30 @@ const char *blk_zone_cond_str(enum blk_z
 }
 EXPORT_SYMBOL_GPL(blk_zone_cond_str);
 
+struct disk_report_zones_cb_args {
+	struct gendisk	*disk;
+	report_zones_cb	user_cb;
+	void		*user_data;
+};
+
+static void disk_zone_wplug_sync_wp_offset(struct gendisk *disk,
+					   struct blk_zone *zone);
+
+static int disk_report_zones_cb(struct blk_zone *zone, unsigned int idx,
+				void *data)
+{
+	struct disk_report_zones_cb_args *args = data;
+	struct gendisk *disk = args->disk;
+
+	if (disk->zone_wplugs_hash)
+		disk_zone_wplug_sync_wp_offset(disk, zone);
+
+	if (!args->user_cb)
+		return 0;
+
+	return args->user_cb(zone, idx, args->user_data);
+}
+
 /**
  * blkdev_report_zones - Get zones information
  * @bdev:	Target block device
@@ -707,6 +731,58 @@ static void disk_zone_wplug_set_wp_offse
 	spin_unlock_irqrestore(&zwplug->lock, flags);
 }
 
+static unsigned int blk_zone_wp_offset(struct blk_zone *zone)
+{
+	switch (zone->cond) {
+	case BLK_ZONE_COND_IMP_OPEN:
+	case BLK_ZONE_COND_EXP_OPEN:
+	case BLK_ZONE_COND_CLOSED:
+		return zone->wp - zone->start;
+	case BLK_ZONE_COND_FULL:
+		return zone->len;
+	case BLK_ZONE_COND_EMPTY:
+		return 0;
+	case BLK_ZONE_COND_NOT_WP:
+	case BLK_ZONE_COND_OFFLINE:
+	case BLK_ZONE_COND_READONLY:
+	default:
+		/*
+		 * Conventional, offline and read-only zones do not have a valid
+		 * write pointer.
+		 */
+		return UINT_MAX;
+	}
+}
+
+static void disk_zone_wplug_sync_wp_offset(struct gendisk *disk,
+					   struct blk_zone *zone)
+{
+	struct blk_zone_wplug *zwplug;
+	unsigned long flags;
+
+	zwplug = disk_get_zone_wplug(disk, zone->start);
+	if (!zwplug)
+		return;
+
+	spin_lock_irqsave(&zwplug->lock, flags);
+	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
+		disk_zone_wplug_set_wp_offset(disk, zwplug,
+					      blk_zone_wp_offset(zone));
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+
+	disk_put_zone_wplug(zwplug);
+}
+
+static int disk_zone_sync_wp_offset(struct gendisk *disk, sector_t sector)
+{
+	struct disk_report_zones_cb_args args = {
+		.disk = disk,
+	};
+
+	return disk->fops->report_zones(disk, sector, 1,
+					disk_report_zones_cb, &args);
+}
+
 static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
 						  unsigned int wp_offset)
 {
@@ -1284,29 +1360,6 @@ put_zwplug:
 	disk_put_zone_wplug(zwplug);
 }
 
-static unsigned int blk_zone_wp_offset(struct blk_zone *zone)
-{
-	switch (zone->cond) {
-	case BLK_ZONE_COND_IMP_OPEN:
-	case BLK_ZONE_COND_EXP_OPEN:
-	case BLK_ZONE_COND_CLOSED:
-		return zone->wp - zone->start;
-	case BLK_ZONE_COND_FULL:
-		return zone->len;
-	case BLK_ZONE_COND_EMPTY:
-		return 0;
-	case BLK_ZONE_COND_NOT_WP:
-	case BLK_ZONE_COND_OFFLINE:
-	case BLK_ZONE_COND_READONLY:
-	default:
-		/*
-		 * Conventional, offline and read-only zones do not have a valid
-		 * write pointer.
-		 */
-		return UINT_MAX;
-	}
-}
-
 static int blk_zone_wplug_report_zone_cb(struct blk_zone *zone,
 					 unsigned int idx, void *data)
 {
@@ -1876,6 +1929,48 @@ int blk_revalidate_disk_zones(struct gen
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
 
+/**
+ * blk_zone_issue_zeroout - zero-fill a block range in a zone
+ * @bdev:	blockdev to write
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to write
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *  Zero-fill a block range in a zone (@sector must be equal to the zone write
+ *  pointer), handling potential errors due to the (initially unknown) lack of
+ *  hardware offload (See blkdev_issue_zeroout()).
+ */
+int blk_zone_issue_zeroout(struct block_device *bdev, sector_t sector,
+			   sector_t nr_sects, gfp_t gfp_mask)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(!bdev_is_zoned(bdev)))
+		return -EIO;
+
+	ret = blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask,
+				   BLKDEV_ZERO_NOFALLBACK);
+	if (ret != -EOPNOTSUPP)
+		return ret;
+
+	/*
+	 * The failed call to blkdev_issue_zeroout() advanced the zone write
+	 * pointer. Undo this using a report zone to update the zone write
+	 * pointer to the correct current value.
+	 */
+	ret = disk_zone_sync_wp_offset(bdev->bd_disk, sector);
+	if (ret != 1)
+		return ret < 0 ? ret : -EIO;
+
+	/*
+	 * Retry without BLKDEV_ZERO_NOFALLBACK to force the fallback to a
+	 * regular write with zero-pages.
+	 */
+	return blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask, 0);
+}
+EXPORT_SYMBOL_GPL(blk_zone_issue_zeroout);
+
 #ifdef CONFIG_BLK_DEBUG_FS
 
 int queue_zone_wplugs_show(void *data, struct seq_file *m)
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -76,9 +76,9 @@ static int dmz_reclaim_align_wp(struct d
 	 * pointer and the requested position.
 	 */
 	nr_blocks = block - wp_block;
-	ret = blkdev_issue_zeroout(dev->bdev,
-				   dmz_start_sect(zmd, zone) + dmz_blk2sect(wp_block),
-				   dmz_blk2sect(nr_blocks), GFP_NOIO, 0);
+	ret = blk_zone_issue_zeroout(dev->bdev,
+			dmz_start_sect(zmd, zone) + dmz_blk2sect(wp_block),
+			dmz_blk2sect(nr_blocks), GFP_NOIO);
 	if (ret) {
 		dmz_dev_err(dev,
 			    "Align zone %u wp %llu to %llu (wp+%u) blocks failed %d",
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1386,6 +1386,9 @@ static inline bool bdev_is_zone_start(st
 	return bdev_offset_from_zone_start(bdev, sector) == 0;
 }
 
+int blk_zone_issue_zeroout(struct block_device *bdev, sector_t sector,
+			   sector_t nr_sects, gfp_t gfp_mask);
+
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q->limits.dma_alignment;


