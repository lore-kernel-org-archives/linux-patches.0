Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3E312FB31;
	Wed, 19 Jun 2024 13:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802615; cv=none; b=NENyImWpHAX6bcUv6AYXuLWPzcgXBZcMnh5KxEUoT67diyX405XJYWveTtHIL7EhzM9QiT1KsGTYH5GLxrTpaCLXgY5c9WcYHXdoCQMmm8toJNNZDnzJSz7KFsDMd9I9nf07HbmZlNUfey0IJwGdwcy9FZeAxsL2woQUj5jr6kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802615; c=relaxed/simple;
	bh=hLFZ0V53/YVWkso+vrYu5vKK2v7zqjE+V3lRLLc/7X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rekc2Vnlg+3CiI852UlYPBRF79LckkYYKGHDFXv/fdtIsdc8Ei9x4VaAMT1k76JEv2873uds1wquWLrzEXgZ3h1aHLrvbw5nHJoYBUYn8vIiYJIt2/PP8WbDLo7svO9+RXi+ydPjJfl1sWiiR2Kem8un9AbBbNJorhMmtyabs68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxBSsw3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxBSsw3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859B2C2BBFC;
	Wed, 19 Jun 2024 13:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802614;
	bh=hLFZ0V53/YVWkso+vrYu5vKK2v7zqjE+V3lRLLc/7X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxBSsw3szEKEcsQHc7iDWUirm1Aqe9bS62gwa+ZSaU0mRudCU3uY3z0mUqkAEQXr5
	 RiygTQ7UjK5WV4mMQe/UtcLLe/qJ4PSwa1ZPKIuE4daqSptwUZuV4xbyq1+0oVH1yH
	 7aT/6t49gFP3FXZJLE0T/678xmLRAoqaYkgLOqKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 225/267] btrfs: zoned: introduce a zone_info struct in btrfs_load_block_group_zone_info
Date: Wed, 19 Jun 2024 14:56:16 +0200
Message-ID: <20240619125614.960962582@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 15c12fcc50a1b12a747f8b6ec05cdb18c537a4d1 upstream.

Add a new zone_info structure to hold per-zone information in
btrfs_load_block_group_zone_info and prepare for breaking out helpers
from it.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   84 ++++++++++++++++++++++++-------------------------------
 1 file changed, 37 insertions(+), 47 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1282,6 +1282,12 @@ out:
 	return ret;
 }
 
+struct zone_info {
+	u64 physical;
+	u64 capacity;
+	u64 alloc_offset;
+};
+
 int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
@@ -1291,12 +1297,10 @@ int btrfs_load_block_group_zone_info(str
 	struct btrfs_device *device;
 	u64 logical = cache->start;
 	u64 length = cache->length;
+	struct zone_info *zone_info = NULL;
 	int ret;
 	int i;
 	unsigned int nofs_flag;
-	u64 *alloc_offsets = NULL;
-	u64 *caps = NULL;
-	u64 *physical = NULL;
 	unsigned long *active = NULL;
 	u64 last_alloc = 0;
 	u32 num_sequential = 0, num_conventional = 0;
@@ -1328,20 +1332,8 @@ int btrfs_load_block_group_zone_info(str
 		goto out;
 	}
 
-	alloc_offsets = kcalloc(map->num_stripes, sizeof(*alloc_offsets), GFP_NOFS);
-	if (!alloc_offsets) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	caps = kcalloc(map->num_stripes, sizeof(*caps), GFP_NOFS);
-	if (!caps) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	physical = kcalloc(map->num_stripes, sizeof(*physical), GFP_NOFS);
-	if (!physical) {
+	zone_info = kcalloc(map->num_stripes, sizeof(*zone_info), GFP_NOFS);
+	if (!zone_info) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1353,20 +1345,21 @@ int btrfs_load_block_group_zone_info(str
 	}
 
 	for (i = 0; i < map->num_stripes; i++) {
+		struct zone_info *info = &zone_info[i];
 		bool is_sequential;
 		struct blk_zone zone;
 		struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 		int dev_replace_is_ongoing = 0;
 
 		device = map->stripes[i].dev;
-		physical[i] = map->stripes[i].physical;
+		info->physical = map->stripes[i].physical;
 
 		if (device->bdev == NULL) {
-			alloc_offsets[i] = WP_MISSING_DEV;
+			info->alloc_offset = WP_MISSING_DEV;
 			continue;
 		}
 
-		is_sequential = btrfs_dev_is_sequential(device, physical[i]);
+		is_sequential = btrfs_dev_is_sequential(device, info->physical);
 		if (is_sequential)
 			num_sequential++;
 		else
@@ -1380,7 +1373,7 @@ int btrfs_load_block_group_zone_info(str
 			__set_bit(i, active);
 
 		if (!is_sequential) {
-			alloc_offsets[i] = WP_CONVENTIONAL;
+			info->alloc_offset = WP_CONVENTIONAL;
 			continue;
 		}
 
@@ -1388,25 +1381,25 @@ int btrfs_load_block_group_zone_info(str
 		 * This zone will be used for allocation, so mark this zone
 		 * non-empty.
 		 */
-		btrfs_dev_clear_zone_empty(device, physical[i]);
+		btrfs_dev_clear_zone_empty(device, info->physical);
 
 		down_read(&dev_replace->rwsem);
 		dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(dev_replace);
 		if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL)
-			btrfs_dev_clear_zone_empty(dev_replace->tgtdev, physical[i]);
+			btrfs_dev_clear_zone_empty(dev_replace->tgtdev, info->physical);
 		up_read(&dev_replace->rwsem);
 
 		/*
 		 * The group is mapped to a sequential zone. Get the zone write
 		 * pointer to determine the allocation offset within the zone.
 		 */
-		WARN_ON(!IS_ALIGNED(physical[i], fs_info->zone_size));
+		WARN_ON(!IS_ALIGNED(info->physical, fs_info->zone_size));
 		nofs_flag = memalloc_nofs_save();
-		ret = btrfs_get_dev_zone(device, physical[i], &zone);
+		ret = btrfs_get_dev_zone(device, info->physical, &zone);
 		memalloc_nofs_restore(nofs_flag);
 		if (ret == -EIO || ret == -EOPNOTSUPP) {
 			ret = 0;
-			alloc_offsets[i] = WP_MISSING_DEV;
+			info->alloc_offset = WP_MISSING_DEV;
 			continue;
 		} else if (ret) {
 			goto out;
@@ -1421,27 +1414,26 @@ int btrfs_load_block_group_zone_info(str
 			goto out;
 		}
 
-		caps[i] = (zone.capacity << SECTOR_SHIFT);
+		info->capacity = (zone.capacity << SECTOR_SHIFT);
 
 		switch (zone.cond) {
 		case BLK_ZONE_COND_OFFLINE:
 		case BLK_ZONE_COND_READONLY:
 			btrfs_err(fs_info,
 		"zoned: offline/readonly zone %llu on device %s (devid %llu)",
-				  physical[i] >> device->zone_info->zone_size_shift,
+				  info->physical >> device->zone_info->zone_size_shift,
 				  rcu_str_deref(device->name), device->devid);
-			alloc_offsets[i] = WP_MISSING_DEV;
+			info->alloc_offset = WP_MISSING_DEV;
 			break;
 		case BLK_ZONE_COND_EMPTY:
-			alloc_offsets[i] = 0;
+			info->alloc_offset = 0;
 			break;
 		case BLK_ZONE_COND_FULL:
-			alloc_offsets[i] = caps[i];
+			info->alloc_offset = info->capacity;
 			break;
 		default:
 			/* Partially used zone */
-			alloc_offsets[i] =
-					((zone.wp - zone.start) << SECTOR_SHIFT);
+			info->alloc_offset = ((zone.wp - zone.start) << SECTOR_SHIFT);
 			__set_bit(i, active);
 			break;
 		}
@@ -1468,15 +1460,15 @@ int btrfs_load_block_group_zone_info(str
 
 	switch (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
 	case 0: /* single */
-		if (alloc_offsets[0] == WP_MISSING_DEV) {
+		if (zone_info[0].alloc_offset == WP_MISSING_DEV) {
 			btrfs_err(fs_info,
 			"zoned: cannot recover write pointer for zone %llu",
-				physical[0]);
+				zone_info[0].physical);
 			ret = -EIO;
 			goto out;
 		}
-		cache->alloc_offset = alloc_offsets[0];
-		cache->zone_capacity = caps[0];
+		cache->alloc_offset = zone_info[0].alloc_offset;
+		cache->zone_capacity = zone_info[0].capacity;
 		if (test_bit(0, active))
 			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags);
 		break;
@@ -1486,21 +1478,21 @@ int btrfs_load_block_group_zone_info(str
 			ret = -EINVAL;
 			goto out;
 		}
-		if (alloc_offsets[0] == WP_MISSING_DEV) {
+		if (zone_info[0].alloc_offset == WP_MISSING_DEV) {
 			btrfs_err(fs_info,
 			"zoned: cannot recover write pointer for zone %llu",
-				physical[0]);
+				zone_info[0].physical);
 			ret = -EIO;
 			goto out;
 		}
-		if (alloc_offsets[1] == WP_MISSING_DEV) {
+		if (zone_info[1].alloc_offset == WP_MISSING_DEV) {
 			btrfs_err(fs_info,
 			"zoned: cannot recover write pointer for zone %llu",
-				physical[1]);
+				zone_info[1].physical);
 			ret = -EIO;
 			goto out;
 		}
-		if (alloc_offsets[0] != alloc_offsets[1]) {
+		if (zone_info[0].alloc_offset != zone_info[1].alloc_offset) {
 			btrfs_err(fs_info,
 			"zoned: write pointer offset mismatch of zones in DUP profile");
 			ret = -EIO;
@@ -1516,8 +1508,8 @@ int btrfs_load_block_group_zone_info(str
 				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
 					&cache->runtime_flags);
 		}
-		cache->alloc_offset = alloc_offsets[0];
-		cache->zone_capacity = min(caps[0], caps[1]);
+		cache->alloc_offset = zone_info[0].alloc_offset;
+		cache->zone_capacity = min(zone_info[0].capacity, zone_info[1].capacity);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID1:
 	case BTRFS_BLOCK_GROUP_RAID0:
@@ -1570,9 +1562,7 @@ out:
 		cache->physical_map = NULL;
 	}
 	bitmap_free(active);
-	kfree(physical);
-	kfree(caps);
-	kfree(alloc_offsets);
+	kfree(zone_info);
 	free_extent_map(em);
 
 	return ret;


