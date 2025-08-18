Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5003731B139;
	Mon, 18 Aug 2025 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526217; cv=none; b=PxhFoLSkfrXt2eZq2GG/c0i8k8eCO1giA7oHAl1bLfwQxaAI1KmPHjBtxY5l+U7Cz/qE4GQaZK6tGFNeGOSPDPJEcABWayNH1tgcVsaf5rcb13h7fcADnxYSe5500eM+wmZJAgK/zzPEoruLJ56FidwZCC7bKzkyBd084arpvPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526217; c=relaxed/simple;
	bh=vFuEsjN1Hrf1VYZ7NGPgWUF2/lCQbvsSmC08BvcTS54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnWo5MqW1Po06HqITgl79CKI3ozzFMJdNRQfc9I7zv6I2iiXxw/qpBXejK7HemNjoIErWYoeP2wQHSptDclLx7ms/FWRxjIIcc/iwOKh43q6oU90E655WUP5x/6RwXnKTnKJ++fYiySUni5XSUE3BooiShKkA8JBQcoSG9k6c3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDmt62Cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDmt62Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1F5C4CEEB;
	Mon, 18 Aug 2025 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526216;
	bh=vFuEsjN1Hrf1VYZ7NGPgWUF2/lCQbvsSmC08BvcTS54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDmt62CrZ5ummJie8dmmyNibE8V5xWuSgD7sOSnA3V7BNHAcQTx6fUuSinL1FekYX
	 /0I1CJvAd8hqgnIxcahy0gJPlSZ0b6KnRYBNwixsfvtv1x3JRMGH0SU/FxZ0UwUU7E
	 QVc6iJwvb1eKMxNtTPKyt0D7Q0mMg1so2DiaCHMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 492/570] block: Introduce bio_needs_zone_write_plugging()
Date: Mon, 18 Aug 2025 14:47:59 +0200
Message-ID: <20250818124524.827714846@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit f70291411ba20d50008db90a6f0731efac27872c upstream.

In preparation for fixing device mapper zone write handling, introduce
the inline helper function bio_needs_zone_write_plugging() to test if a
BIO requires handling through zone write plugging using the function
blk_zone_plug_bio(). This function returns true for any write
(op_is_write(bio) == true) operation directed at a zoned block device
using zone write plugging, that is, a block device with a disk that has
a zone write plug hash table.

This helper allows simplifying the check on entry to blk_zone_plug_bio()
and used in to protect calls to it for blk-mq devices and DM devices.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250625093327.548866-3-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c         |    6 +++--
 block/blk-zoned.c      |   20 -----------------
 drivers/md/dm.c        |    4 ++-
 include/linux/blkdev.h |   55 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 22 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3169,8 +3169,10 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
 
-	if (blk_queue_is_zoned(q) && blk_zone_plug_bio(bio, nr_segs))
-		goto queue_exit;
+	if (bio_needs_zone_write_plugging(bio)) {
+		if (blk_zone_plug_bio(bio, nr_segs))
+			goto queue_exit;
+	}
 
 new_request:
 	if (rq) {
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1116,25 +1116,7 @@ bool blk_zone_plug_bio(struct bio *bio,
 {
 	struct block_device *bdev = bio->bi_bdev;
 
-	if (!bdev->bd_disk->zone_wplugs_hash)
-		return false;
-
-	/*
-	 * If the BIO already has the plugging flag set, then it was already
-	 * handled through this path and this is a submission from the zone
-	 * plug bio submit work.
-	 */
-	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
-		return false;
-
-	/*
-	 * We do not need to do anything special for empty flush BIOs, e.g
-	 * BIOs such as issued by blkdev_issue_flush(). The is because it is
-	 * the responsibility of the user to first wait for the completion of
-	 * write operations for flush to have any effect on the persistence of
-	 * the written data.
-	 */
-	if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
+	if (WARN_ON_ONCE(!bdev->bd_disk->zone_wplugs_hash))
 		return false;
 
 	/*
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1788,7 +1788,9 @@ static inline bool dm_zone_bio_needs_spl
 }
 static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio *bio)
 {
-	return dm_emulate_zone_append(md) && blk_zone_plug_bio(bio, 0);
+	if (!bio_needs_zone_write_plugging(bio))
+		return false;
+	return blk_zone_plug_bio(bio, 0);
 }
 
 static blk_status_t __send_zone_reset_all_emulated(struct clone_info *ci,
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -842,6 +842,55 @@ static inline unsigned int disk_nr_zones
 {
 	return disk->nr_zones;
 }
+
+/**
+ * bio_needs_zone_write_plugging - Check if a BIO needs to be handled with zone
+ *				   write plugging
+ * @bio: The BIO being submitted
+ *
+ * Return true whenever @bio execution needs to be handled through zone
+ * write plugging (using blk_zone_plug_bio()). Return false otherwise.
+ */
+static inline bool bio_needs_zone_write_plugging(struct bio *bio)
+{
+	enum req_op op = bio_op(bio);
+
+	/*
+	 * Only zoned block devices have a zone write plug hash table. But not
+	 * all of them have one (e.g. DM devices may not need one).
+	 */
+	if (!bio->bi_bdev->bd_disk->zone_wplugs_hash)
+		return false;
+
+	/* Only write operations need zone write plugging. */
+	if (!op_is_write(op))
+		return false;
+
+	/* Ignore empty flush */
+	if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
+		return false;
+
+	/* Ignore BIOs that already have been handled by zone write plugging. */
+	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
+		return false;
+
+	/*
+	 * All zone write operations must be handled through zone write plugging
+	 * using blk_zone_plug_bio().
+	 */
+	switch (op) {
+	case REQ_OP_ZONE_APPEND:
+	case REQ_OP_WRITE:
+	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_ZONE_FINISH:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
+		return true;
+	default:
+		return false;
+	}
+}
+
 bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
 
 /**
@@ -871,6 +920,12 @@ static inline unsigned int disk_nr_zones
 {
 	return 0;
 }
+
+static inline bool bio_needs_zone_write_plugging(struct bio *bio)
+{
+	return false;
+}
+
 static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
 {
 	return false;


