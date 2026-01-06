Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A546364041;
	Tue,  6 Jan 2026 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721871; cv=none; b=XLOyalq9vwTTnfTF47JmaUgxOQgua14PBo5Nz61mVvyBCA+CcCYUAEt71Nw4UkPmlblHNG4tF4K49mSUAped6fSWiCN6vPPJ5npwNSnABfC9GvhDgklp4OLt6T6N4hkCd1hGBfs7n4xzi3xgdckzQinfdFR7vF5GS0vYEOBoFR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721871; c=relaxed/simple;
	bh=1xhee6HiUA5R13H1AgvfLuMsxsszTWFEbHGwfI2cKFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMA8QucWD9dSW+RsbC5PiYlc7EzSZG2J8x/D6PQYqJT8hjKxTdIBbXytqDA9y90Pj90ckrdIyeHhjM1XBIMaHDUHSET76TYlywKUrqrmySWItTxOxywgBw7G7D3T7Px67/IDUhunTxzZNEGuEEZ3or5Yv/1NjQyFvAwuPJBLD9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H63YHNsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H63YHNsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954BAC116C6;
	Tue,  6 Jan 2026 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721871;
	bh=1xhee6HiUA5R13H1AgvfLuMsxsszTWFEbHGwfI2cKFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H63YHNsPTdbobxzvI+TYHX80+mJ/HMHe+OQRd3eL4ZvEqhUz0lN7VA5ySKUWi7e9i
	 3wrGayhwK0Lb6O9g3LqlO+uUXaVLrb8+3kQq9ZHJyt60gbM4nFI8mfLXudqQDFYxgl
	 /EQmQ5vISSC7EOb1FhBm94wLg1CZjBeNek5i0YgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 089/312] block: handle zone management operations completions
Date: Tue,  6 Jan 2026 18:02:43 +0100
Message-ID: <20260106170551.055651566@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit efae226c2ef19528ffd81d29ba0eecf1b0896ca2 upstream.

The functions blk_zone_wplug_handle_reset_or_finish() and
blk_zone_wplug_handle_reset_all() both modify the zone write pointer
offset of zone write plugs that are the target of a reset, reset all or
finish zone management operation. However, these functions do this
modification before the BIO is executed. So if the zone operation fails,
the modified zone write pointer offsets become invalid.

Avoid this by modifying the zone write pointer offset of a zone write
plug that is the target of a zone management operation when the
operation completes. To do so, modify blk_zone_bio_endio() to call the
new function blk_zone_mgmt_bio_endio() which in turn calls the functions
blk_zone_reset_all_bio_endio(), blk_zone_reset_bio_endio() or
blk_zone_finish_bio_endio() depending on the operation of the completed
BIO, to modify a zone write plug write pointer offset accordingly.
These functions are called only if the BIO execution was successful.

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |  139 ++++++++++++++++++++++++++++++++++--------------------
 block/blk.h       |   14 +++++
 2 files changed, 104 insertions(+), 49 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -71,6 +71,11 @@ struct blk_zone_wplug {
 	struct gendisk		*disk;
 };
 
+static inline unsigned int disk_zone_wplugs_hash_size(struct gendisk *disk)
+{
+	return 1U << disk->zone_wplugs_hash_bits;
+}
+
 /*
  * Zone write plug flags bits:
  *  - BLK_ZONE_WPLUG_PLUGGED: Indicates that the zone write plug is plugged,
@@ -698,71 +703,91 @@ static int disk_zone_sync_wp_offset(stru
 					disk_report_zones_cb, &args);
 }
 
-static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
-						  unsigned int wp_offset)
+static void blk_zone_reset_bio_endio(struct bio *bio)
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	sector_t sector = bio->bi_iter.bi_sector;
 	struct blk_zone_wplug *zwplug;
-	unsigned long flags;
-
-	/* Conventional zones cannot be reset nor finished. */
-	if (!bdev_zone_is_seq(bio->bi_bdev, sector)) {
-		bio_io_error(bio);
-		return true;
-	}
-
-	/*
-	 * No-wait reset or finish BIOs do not make much sense as the callers
-	 * issue these as blocking operations in most cases. To avoid issues
-	 * the BIO execution potentially failing with BLK_STS_AGAIN, warn about
-	 * REQ_NOWAIT being set and ignore that flag.
-	 */
-	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT))
-		bio->bi_opf &= ~REQ_NOWAIT;
 
 	/*
-	 * If we have a zone write plug, set its write pointer offset to 0
-	 * (reset case) or to the zone size (finish case). This will abort all
-	 * BIOs plugged for the target zone. It is fine as resetting or
-	 * finishing zones while writes are still in-flight will result in the
+	 * If we have a zone write plug, set its write pointer offset to 0.
+	 * This will abort all BIOs plugged for the target zone. It is fine as
+	 * resetting zones while writes are still in-flight will result in the
 	 * writes failing anyway.
 	 */
-	zwplug = disk_get_zone_wplug(disk, sector);
+	zwplug = disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
 	if (zwplug) {
+		unsigned long flags;
+
 		spin_lock_irqsave(&zwplug->lock, flags);
-		disk_zone_wplug_set_wp_offset(disk, zwplug, wp_offset);
+		disk_zone_wplug_set_wp_offset(disk, zwplug, 0);
 		spin_unlock_irqrestore(&zwplug->lock, flags);
 		disk_put_zone_wplug(zwplug);
 	}
-
-	return false;
 }
 
-static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
+static void blk_zone_reset_all_bio_endio(struct bio *bio)
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
 	struct blk_zone_wplug *zwplug;
 	unsigned long flags;
-	sector_t sector;
+	unsigned int i;
 
-	/*
-	 * Set the write pointer offset of all zone write plugs to 0. This will
-	 * abort all plugged BIOs. It is fine as resetting zones while writes
-	 * are still in-flight will result in the writes failing anyway.
-	 */
-	for (sector = 0; sector < get_capacity(disk);
-	     sector += disk->queue->limits.chunk_sectors) {
-		zwplug = disk_get_zone_wplug(disk, sector);
-		if (zwplug) {
+	/* Update the condition of all zone write plugs. */
+	rcu_read_lock();
+	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++) {
+		hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[i],
+					 node) {
 			spin_lock_irqsave(&zwplug->lock, flags);
 			disk_zone_wplug_set_wp_offset(disk, zwplug, 0);
 			spin_unlock_irqrestore(&zwplug->lock, flags);
-			disk_put_zone_wplug(zwplug);
 		}
 	}
+	rcu_read_unlock();
+}
 
-	return false;
+static void blk_zone_finish_bio_endio(struct bio *bio)
+{
+	struct block_device *bdev = bio->bi_bdev;
+	struct gendisk *disk = bdev->bd_disk;
+	struct blk_zone_wplug *zwplug;
+
+	/*
+	 * If we have a zone write plug, set its write pointer offset to the
+	 * zone size. This will abort all BIOs plugged for the target zone. It
+	 * is fine as resetting zones while writes are still in-flight will
+	 * result in the writes failing anyway.
+	 */
+	zwplug = disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
+	if (zwplug) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&zwplug->lock, flags);
+		disk_zone_wplug_set_wp_offset(disk, zwplug,
+					      bdev_zone_sectors(bdev));
+		spin_unlock_irqrestore(&zwplug->lock, flags);
+		disk_put_zone_wplug(zwplug);
+	}
+}
+
+void blk_zone_mgmt_bio_endio(struct bio *bio)
+{
+	/* If the BIO failed, we have nothing to do. */
+	if (bio->bi_status != BLK_STS_OK)
+		return;
+
+	switch (bio_op(bio)) {
+	case REQ_OP_ZONE_RESET:
+		blk_zone_reset_bio_endio(bio);
+		return;
+	case REQ_OP_ZONE_RESET_ALL:
+		blk_zone_reset_all_bio_endio(bio);
+		return;
+	case REQ_OP_ZONE_FINISH:
+		blk_zone_finish_bio_endio(bio);
+		return;
+	default:
+		return;
+	}
 }
 
 static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
@@ -1106,6 +1131,30 @@ static void blk_zone_wplug_handle_native
 	disk_put_zone_wplug(zwplug);
 }
 
+static bool blk_zone_wplug_handle_zone_mgmt(struct bio *bio)
+{
+	if (bio_op(bio) != REQ_OP_ZONE_RESET_ALL &&
+	    !bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
+		/*
+		 * Zone reset and zone finish operations do not apply to
+		 * conventional zones.
+		 */
+		bio_io_error(bio);
+		return true;
+	}
+
+	/*
+	 * No-wait zone management BIOs do not make much sense as the callers
+	 * issue these as blocking operations in most cases. To avoid issues
+	 * with the BIO execution potentially failing with BLK_STS_AGAIN, warn
+	 * about REQ_NOWAIT being set and ignore that flag.
+	 */
+	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT))
+		bio->bi_opf &= ~REQ_NOWAIT;
+
+	return false;
+}
+
 /**
  * blk_zone_plug_bio - Handle a zone write BIO with zone write plugging
  * @bio: The BIO being submitted
@@ -1153,12 +1202,9 @@ bool blk_zone_plug_bio(struct bio *bio,
 	case REQ_OP_WRITE_ZEROES:
 		return blk_zone_wplug_handle_write(bio, nr_segs);
 	case REQ_OP_ZONE_RESET:
-		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
 	case REQ_OP_ZONE_FINISH:
-		return blk_zone_wplug_handle_reset_or_finish(bio,
-						bdev_zone_sectors(bdev));
 	case REQ_OP_ZONE_RESET_ALL:
-		return blk_zone_wplug_handle_reset_all(bio);
+		return blk_zone_wplug_handle_zone_mgmt(bio);
 	default:
 		return false;
 	}
@@ -1332,11 +1378,6 @@ put_zwplug:
 	disk_put_zone_wplug(zwplug);
 }
 
-static inline unsigned int disk_zone_wplugs_hash_size(struct gendisk *disk)
-{
-	return 1U << disk->zone_wplugs_hash_bits;
-}
-
 void disk_init_zone_resources(struct gendisk *disk)
 {
 	spin_lock_init(&disk->zone_wplugs_lock);
--- a/block/blk.h
+++ b/block/blk.h
@@ -488,10 +488,24 @@ static inline bool blk_req_bio_is_zone_a
 void blk_zone_write_plug_bio_merged(struct bio *bio);
 void blk_zone_write_plug_init_request(struct request *rq);
 void blk_zone_append_update_request_bio(struct request *rq, struct bio *bio);
+void blk_zone_mgmt_bio_endio(struct bio *bio);
 void blk_zone_write_plug_bio_endio(struct bio *bio);
 static inline void blk_zone_bio_endio(struct bio *bio)
 {
 	/*
+	 * Zone management BIOs may impact zone write plugs (e.g. a zone reset
+	 * changes a zone write plug zone write pointer offset), but these
+	 * operation do not go through zone write plugging as they may operate
+	 * on zones that do not have a zone write
+	 * plug. blk_zone_mgmt_bio_endio() handles the potential changes to zone
+	 * write plugs that are present.
+	 */
+	if (op_is_zone_mgmt(bio_op(bio))) {
+		blk_zone_mgmt_bio_endio(bio);
+		return;
+	}
+
+	/*
 	 * For write BIOs to zoned devices, signal the completion of the BIO so
 	 * that the next write BIO can be submitted by zone write plugging.
 	 */


