Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F4D1487F1;
	Thu, 11 Apr 2024 10:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831609; cv=none; b=El+79uvawN8zelviVCJo4Gb38URD0i+RhUbX0Dtz4NHCoPkTefPTBoysGH9AkEBsEioUX2nrjeZv6WdKKcPsoH3CdMzr+AludDDAmPC7/o3EjECrzi7rbXVq7mPgTum09YPDy3Nbcy82IzYR7tQ5flPBGCFAfCwLLKdCaoPy3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831609; c=relaxed/simple;
	bh=2maOuE0zzos+AnpGGi3GKqO9zWoqtxL/RKCKx35J2sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2goO7t0d2tbV15go0VgHz7L2E+Ma6oDe7clmtq4e1TF4VTpss0GsOo691buKsKc2Xcsld/5lJkuG8ujBKR/QVVsla2plVJGGdHo7l3RtcgXDUpqx38H6lKdwcUH5958LnsMCijVhkrcu2KakmuoIB0RCXPOrqdSvi/N4mpzp4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkZ0Jya0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkZ0Jya0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395BEC433C7;
	Thu, 11 Apr 2024 10:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831609;
	bh=2maOuE0zzos+AnpGGi3GKqO9zWoqtxL/RKCKx35J2sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkZ0Jya012ZuPf/ocQ+Kja2g0WY6GgPpLgHI208kz2O4jRYjF/aha09CmU1GBg0l5
	 jtY+7k321sg20GHWYVj56C/uA/5fJignSYL+i3PIZPgkmZes7LplZZGTZ2d18mr6zM
	 czVRFX6ErmvVByMVXtXbwmTH8ZquX1lXZMs7NX7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@edc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/294] block: introduce zone_write_granularity limit
Date: Thu, 11 Apr 2024 11:53:10 +0200
Message-ID: <20240411095436.454515502@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit a805a4fa4fa376bbc145762bb8b09caa2fa8af48 ]

Per ZBC and ZAC specifications, host-managed SMR hard-disks mandate that
all writes into sequential write required zones be aligned to the device
physical block size. However, NVMe ZNS does not have this constraint and
allows write operations into sequential zones to be aligned to the
device logical block size. This inconsistency does not help with
software portability across device types.

To solve this, introduce the zone_write_granularity queue limit to
indicate the alignment constraint, in bytes, of write operations into
zones of a zoned block device. This new limit is exported as a
read-only sysfs queue attribute and the helper
blk_queue_zone_write_granularity() introduced for drivers to set this
limit.

The function blk_queue_set_zoned() is modified to set this new limit to
the device logical block size by default. NVMe ZNS devices as well as
zoned nullb devices use this default value as is. The scsi disk driver
is modified to execute the blk_queue_zone_write_granularity() helper to
set the zone write granularity of host-managed SMR disks to the disk
physical block size.

The accessor functions queue_zone_write_granularity() and
bdev_zone_write_granularity() are also introduced.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@edc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c8f6f88d2592 ("block: Clear zone limits for a non-zoned stacked queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/block/queue-sysfs.rst |  7 ++++++
 block/blk-settings.c                | 37 ++++++++++++++++++++++++++++-
 block/blk-sysfs.c                   |  8 +++++++
 drivers/scsi/sd_zbc.c               |  8 +++++++
 include/linux/blkdev.h              | 15 ++++++++++++
 5 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 2638d3446b794..c8bf8bc3c03af 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -273,4 +273,11 @@ devices are described in the ZBC (Zoned Block Commands) and ZAC
 do not support zone commands, they will be treated as regular block devices
 and zoned will report "none".
 
+zone_write_granularity (RO)
+---------------------------
+This indicates the alignment constraint, in bytes, for write operations in
+sequential zones of zoned block devices (devices with a zoned attributed
+that reports "host-managed" or "host-aware"). This value is always 0 for
+regular block devices.
+
 Jens Axboe <jens.axboe@oracle.com>, February 2009
diff --git a/block/blk-settings.c b/block/blk-settings.c
index c3aa7f8ee3883..ab39169aa2b28 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -60,6 +60,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->io_opt = 0;
 	lim->misaligned = 0;
 	lim->zoned = BLK_ZONED_NONE;
+	lim->zone_write_granularity = 0;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -353,6 +354,28 @@ void blk_queue_physical_block_size(struct request_queue *q, unsigned int size)
 }
 EXPORT_SYMBOL(blk_queue_physical_block_size);
 
+/**
+ * blk_queue_zone_write_granularity - set zone write granularity for the queue
+ * @q:  the request queue for the zoned device
+ * @size:  the zone write granularity size, in bytes
+ *
+ * Description:
+ *   This should be set to the lowest possible size allowing to write in
+ *   sequential zones of a zoned block device.
+ */
+void blk_queue_zone_write_granularity(struct request_queue *q,
+				      unsigned int size)
+{
+	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
+		return;
+
+	q->limits.zone_write_granularity = size;
+
+	if (q->limits.zone_write_granularity < q->limits.logical_block_size)
+		q->limits.zone_write_granularity = q->limits.logical_block_size;
+}
+EXPORT_SYMBOL_GPL(blk_queue_zone_write_granularity);
+
 /**
  * blk_queue_alignment_offset - set physical block alignment offset
  * @q:	the request queue for the device
@@ -630,6 +653,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			t->discard_granularity;
 	}
 
+	t->zone_write_granularity = max(t->zone_write_granularity,
+					b->zone_write_granularity);
 	t->zoned = max(t->zoned, b->zoned);
 	return ret;
 }
@@ -846,6 +871,8 @@ EXPORT_SYMBOL_GPL(blk_queue_can_use_dma_map_merging);
  */
 void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 {
+	struct request_queue *q = disk->queue;
+
 	switch (model) {
 	case BLK_ZONED_HM:
 		/*
@@ -874,7 +901,15 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		break;
 	}
 
-	disk->queue->limits.zoned = model;
+	q->limits.zoned = model;
+	if (model != BLK_ZONED_NONE) {
+		/*
+		 * Set the zone write granularity to the device logical block
+		 * size by default. The driver can change this value if needed.
+		 */
+		blk_queue_zone_write_granularity(q,
+						queue_logical_block_size(q));
+	}
 }
 EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9174137a913c4..ddf23bf3e0f1d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -219,6 +219,12 @@ static ssize_t queue_write_zeroes_max_show(struct request_queue *q, char *page)
 		(unsigned long long)q->limits.max_write_zeroes_sectors << 9);
 }
 
+static ssize_t queue_zone_write_granularity_show(struct request_queue *q,
+						 char *page)
+{
+	return queue_var_show(queue_zone_write_granularity(q), page);
+}
+
 static ssize_t queue_zone_append_max_show(struct request_queue *q, char *page)
 {
 	unsigned long long max_sectors = q->limits.max_zone_append_sectors;
@@ -585,6 +591,7 @@ QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
 QUEUE_RO_ENTRY(queue_write_same_max, "write_same_max_bytes");
 QUEUE_RO_ENTRY(queue_write_zeroes_max, "write_zeroes_max_bytes");
 QUEUE_RO_ENTRY(queue_zone_append_max, "zone_append_max_bytes");
+QUEUE_RO_ENTRY(queue_zone_write_granularity, "zone_write_granularity");
 
 QUEUE_RO_ENTRY(queue_zoned, "zoned");
 QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
@@ -639,6 +646,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
+	&queue_zone_write_granularity_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_zoned_entry.attr,
 	&queue_nr_zones_entry.attr,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 01088f333dbc4..f9cd41703d99b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -793,6 +793,14 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	blk_queue_max_active_zones(q, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
+	/*
+	 * Per ZBC and ZAC specifications, writes in sequential write required
+	 * zones of host-managed devices must be aligned to the device physical
+	 * block size.
+	 */
+	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
+		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
+
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw = 1;
 	sdkp->device->use_10_for_rw = 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 583824f111079..a47e1aebaff24 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -345,6 +345,7 @@ struct queue_limits {
 	unsigned int		max_zone_append_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
+	unsigned int		zone_write_granularity;
 
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
@@ -1169,6 +1170,8 @@ extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_zone_append_sectors(struct request_queue *q,
 		unsigned int max_zone_append_sectors);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
+void blk_queue_zone_write_granularity(struct request_queue *q,
+				      unsigned int size);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
 void blk_queue_update_readahead(struct request_queue *q);
@@ -1480,6 +1483,18 @@ static inline int bdev_io_opt(struct block_device *bdev)
 	return queue_io_opt(bdev_get_queue(bdev));
 }
 
+static inline unsigned int
+queue_zone_write_granularity(const struct request_queue *q)
+{
+	return q->limits.zone_write_granularity;
+}
+
+static inline unsigned int
+bdev_zone_write_granularity(struct block_device *bdev)
+{
+	return queue_zone_write_granularity(bdev_get_queue(bdev));
+}
+
 static inline int queue_alignment_offset(const struct request_queue *q)
 {
 	if (q->limits.misaligned)
-- 
2.43.0



