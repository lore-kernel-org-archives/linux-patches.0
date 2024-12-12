Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A91F2153F8;
	Thu, 12 Dec 2024 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016508; cv=none; b=s+WF582NzgLqYfbkNBq3UFQdXeRLCVdcap4NmwjJwMdWQkhUj7kw8kKgb5qB4xA0GJtRmXWOoPpddXf6/rCluIY2l8nmnCwQHlc03K0MgL3nstj5XKUFMq1Uq4Xh0driQiaVfrX4lFK7wzcefBBVSG4F8jxfSzNC3KAROAYqjHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016508; c=relaxed/simple;
	bh=t0PzaepkKjFuXT2WoX2oMDIOHnS9Xs7PUZ/YRXhrYMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB1+1oYS4FDvN1uLa/rWji6nsG9c+FWFyZhZHtMF7PuehVl1mGP3+GduYHIQ+WuBaD4G2BM2YEdFhgp8sFL9mJ3BzcpItsH5w3PmxzMDY8oYQnSzC/edGewFwKGccgsjDNhZ6MTYEd7ZvVQCJ2t1X3JAg+7zDcCD+OgfK72GAH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lCwdHUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lCwdHUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F326AC4CECE;
	Thu, 12 Dec 2024 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016508;
	bh=t0PzaepkKjFuXT2WoX2oMDIOHnS9Xs7PUZ/YRXhrYMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lCwdHUZ/mhyd2cF3dVMdrqcQD6b+vimbLvIYp/0gns7REzY/ivw+z5Pakug/OSqg
	 vNL/+jpRMeVsAjZuOMrl6GMk9LA2Xhz4RbAtfog7ICsZHaHe8HsuL13G9kBM/6ZuNc
	 FkaI0ejc0MQBuRNwemCUe3J1bFt70vzmC2akeq4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/466] block: RCU protect disk->conv_zones_bitmap
Date: Thu, 12 Dec 2024 15:56:27 +0100
Message-ID: <20241212144315.399646667@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

[ Upstream commit d7cb6d7414ea1b33536fa6d11805cb8dceec1f97 ]

Ensure that a disk revalidation changing the conventional zones bitmap
of a disk does not cause invalid memory references when using the
disk_zone_is_conv() helper by RCU protecting the disk->conv_zones_bitmap
pointer.

disk_zone_is_conv() is modified to operate under the RCU read lock and
the function disk_set_conv_zones_bitmap() is added to update a disk
conv_zones_bitmap pointer using rcu_replace_pointer() with the disk
zone_wplugs_lock spinlock held.

disk_free_zone_resources() is modified to call
disk_update_zone_resources() with a NULL bitmap pointer to free the disk
conv_zones_bitmap. disk_set_conv_zones_bitmap() is also used in
disk_update_zone_resources() to set the new (revalidated) bitmap and
free the old one.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20241107064300.227731-2-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c      | 43 ++++++++++++++++++++++++++++++------------
 include/linux/blkdev.h |  2 +-
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 95e517723db3e..0b1184176ce77 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -350,9 +350,15 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 static inline bool disk_zone_is_conv(struct gendisk *disk, sector_t sector)
 {
-	if (!disk->conv_zones_bitmap)
-		return false;
-	return test_bit(disk_zone_no(disk, sector), disk->conv_zones_bitmap);
+	unsigned long *bitmap;
+	bool is_conv;
+
+	rcu_read_lock();
+	bitmap = rcu_dereference(disk->conv_zones_bitmap);
+	is_conv = bitmap && test_bit(disk_zone_no(disk, sector), bitmap);
+	rcu_read_unlock();
+
+	return is_conv;
 }
 
 static bool disk_zone_is_last(struct gendisk *disk, struct blk_zone *zone)
@@ -1455,6 +1461,24 @@ static void disk_destroy_zone_wplugs_hash_table(struct gendisk *disk)
 	disk->zone_wplugs_hash_bits = 0;
 }
 
+static unsigned int disk_set_conv_zones_bitmap(struct gendisk *disk,
+					       unsigned long *bitmap)
+{
+	unsigned int nr_conv_zones = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	if (bitmap)
+		nr_conv_zones = bitmap_weight(bitmap, disk->nr_zones);
+	bitmap = rcu_replace_pointer(disk->conv_zones_bitmap, bitmap,
+				     lockdep_is_held(&disk->zone_wplugs_lock));
+	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+
+	kfree_rcu_mightsleep(bitmap);
+
+	return nr_conv_zones;
+}
+
 void disk_free_zone_resources(struct gendisk *disk)
 {
 	if (!disk->zone_wplugs_pool)
@@ -1478,8 +1502,7 @@ void disk_free_zone_resources(struct gendisk *disk)
 	mempool_destroy(disk->zone_wplugs_pool);
 	disk->zone_wplugs_pool = NULL;
 
-	bitmap_free(disk->conv_zones_bitmap);
-	disk->conv_zones_bitmap = NULL;
+	disk_set_conv_zones_bitmap(disk, NULL);
 	disk->zone_capacity = 0;
 	disk->last_zone_capacity = 0;
 	disk->nr_zones = 0;
@@ -1538,7 +1561,7 @@ static int disk_update_zone_resources(struct gendisk *disk,
 				      struct blk_revalidate_zone_args *args)
 {
 	struct request_queue *q = disk->queue;
-	unsigned int nr_seq_zones, nr_conv_zones = 0;
+	unsigned int nr_seq_zones, nr_conv_zones;
 	unsigned int pool_size;
 	struct queue_limits lim;
 	int ret;
@@ -1546,10 +1569,8 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	disk->nr_zones = args->nr_zones;
 	disk->zone_capacity = args->zone_capacity;
 	disk->last_zone_capacity = args->last_zone_capacity;
-	swap(disk->conv_zones_bitmap, args->conv_zones_bitmap);
-	if (disk->conv_zones_bitmap)
-		nr_conv_zones = bitmap_weight(disk->conv_zones_bitmap,
-					      disk->nr_zones);
+	nr_conv_zones =
+		disk_set_conv_zones_bitmap(disk, args->conv_zones_bitmap);
 	if (nr_conv_zones >= disk->nr_zones) {
 		pr_warn("%s: Invalid number of conventional zones %u / %u\n",
 			disk->disk_name, nr_conv_zones, disk->nr_zones);
@@ -1829,8 +1850,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 		blk_mq_unfreeze_queue(q);
 	}
 
-	kfree(args.conv_zones_bitmap);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e84a93c401320..6b4bc85f4999b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -195,7 +195,7 @@ struct gendisk {
 	unsigned int		nr_zones;
 	unsigned int		zone_capacity;
 	unsigned int		last_zone_capacity;
-	unsigned long		*conv_zones_bitmap;
+	unsigned long __rcu	*conv_zones_bitmap;
 	unsigned int            zone_wplugs_hash_bits;
 	spinlock_t              zone_wplugs_lock;
 	struct mempool_s	*zone_wplugs_pool;
-- 
2.43.0



