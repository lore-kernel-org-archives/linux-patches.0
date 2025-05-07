Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A68F24E4CE;
	Wed,  7 May 2025 18:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644267; cv=none; b=E/ltx6emzTrxk27bl5ZaPS1KxQ4teSjN5UMCT1Tciye7Zk+qTCmViqF4SHweOU4nD0J5QHki9Z0Da4ALPbz/oixbSapq/uT4CVVkmw4qnOQ35ZNqHTUs6ew1ezvm/hwluLDcxbylTnmBHP7/PvqQW/YSAeGGZkiMIy1ypJqyhME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644267; c=relaxed/simple;
	bh=MzmC0pim/TZJgoNTrv1crcXzH4CNG5gLp+lKe+qBgXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+iErG7inVFn1vWBN6dHiDJiXD1I6EwuPtybTFlT8+14BD1Rix5pWxL7Yuh8/vQ9RGc7QpKvVmce1itb2OXFkNvu8l5vgPxNHuRiwJDCot4QswZMzu5JSuQXkqdMFmlJg48UEO/mDK4YdIPxza+5ybmFBkbdAaLNB+4w9Lqkdh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dX/Ggr8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dX/Ggr8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6474C4CEE2;
	Wed,  7 May 2025 18:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644267;
	bh=MzmC0pim/TZJgoNTrv1crcXzH4CNG5gLp+lKe+qBgXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dX/Ggr8W7eavQwYE+c+iyMOInrCdpba6bJDjpvAcz5ddWDwp0BoOeV0RnULb1A6MJ
	 HupHymyTOm7sv35FrLEeZKd8zoDjh/i4L1JOZoRMB4nR0Fw4UdIysu7Orvkka4mvnZ
	 OFGTqw6sGUKFVOulXnYobRTWxeawds4LmOfOCKj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 172/183] block: introduce zone capacity helper
Date: Wed,  7 May 2025 20:40:17 +0200
Message-ID: <20250507183831.827140197@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit c1a79b1a583654f24b17da81ba868b0064077243 ]

{bdev,disk}_zone_capacity() takes block_device or gendisk and sector position
and returns the zone capacity of the corresponding zone.

With that, move disk_nr_zones() and blk_zone_plug_bio() to consolidate them in
the same #ifdef block.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 866bafae59ec ("btrfs: zoned: skip reporting zone for new block group")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 67 ++++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6aa67e9b2ec08..0fec27d6b986c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -691,23 +691,6 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
 		(q->limits.features & BLK_FEAT_ZONED);
 }
 
-#ifdef CONFIG_BLK_DEV_ZONED
-static inline unsigned int disk_nr_zones(struct gendisk *disk)
-{
-	return disk->nr_zones;
-}
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
-#else /* CONFIG_BLK_DEV_ZONED */
-static inline unsigned int disk_nr_zones(struct gendisk *disk)
-{
-	return 0;
-}
-static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
-{
-	return false;
-}
-#endif /* CONFIG_BLK_DEV_ZONED */
-
 static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 {
 	if (!blk_queue_is_zoned(disk->queue))
@@ -715,11 +698,6 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 	return sector >> ilog2(disk->queue->limits.chunk_sectors);
 }
 
-static inline unsigned int bdev_nr_zones(struct block_device *bdev)
-{
-	return disk_nr_zones(bdev->bd_disk);
-}
-
 static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 {
 	return bdev->bd_disk->queue->limits.max_open_zones;
@@ -826,6 +804,51 @@ static inline u64 sb_bdev_nr_blocks(struct super_block *sb)
 		(sb->s_blocksize_bits - SECTOR_SHIFT);
 }
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static inline unsigned int disk_nr_zones(struct gendisk *disk)
+{
+	return disk->nr_zones;
+}
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
+
+/**
+ * disk_zone_capacity - returns the zone capacity of zone containing @sector
+ * @disk:	disk to work with
+ * @sector:	sector number within the querying zone
+ *
+ * Returns the zone capacity of a zone containing @sector. @sector can be any
+ * sector in the zone.
+ */
+static inline unsigned int disk_zone_capacity(struct gendisk *disk,
+					      sector_t sector)
+{
+	sector_t zone_sectors = disk->queue->limits.chunk_sectors;
+
+	if (sector + zone_sectors >= get_capacity(disk))
+		return disk->last_zone_capacity;
+	return disk->zone_capacity;
+}
+static inline unsigned int bdev_zone_capacity(struct block_device *bdev,
+					      sector_t pos)
+{
+	return disk_zone_capacity(bdev->bd_disk, pos);
+}
+#else /* CONFIG_BLK_DEV_ZONED */
+static inline unsigned int disk_nr_zones(struct gendisk *disk)
+{
+	return 0;
+}
+static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
+{
+	return false;
+}
+#endif /* CONFIG_BLK_DEV_ZONED */
+
+static inline unsigned int bdev_nr_zones(struct block_device *bdev)
+{
+	return disk_nr_zones(bdev->bd_disk);
+}
+
 int bdev_disk_changed(struct gendisk *disk, bool invalidate);
 
 void put_disk(struct gendisk *disk);
-- 
2.39.5



