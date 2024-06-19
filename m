Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D7913DDC0;
	Wed, 19 Jun 2024 13:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804060; cv=none; b=dBuHK6NCTIetwY5zdIoEOKLR+qvcvPuzzW8X7XKvmQWuNaXfs/zi4Q+PrPUSdUfE+ermcRoKnEmwU3/DkT26TnEyeKF8KOJRO+P+jW7tR4/7T6bjtLF6w3MmSzpTpZ7kYPAyp8XnWsWVuobIkE2qHuspCj4dZvHRXPwMQQfw+7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804060; c=relaxed/simple;
	bh=fxuiVHqqec+s2NcHJYIrDN7XgpFsToOK33Y2ikn+rdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgdY8W2wnXnEXpc0dMZY5cWAcacM6OC2t1iHG4LT8svOM5QACR/Kh0+KQx34ZXzMoObNu1Wp3Icc8kUSH25F/EuYu74+IJq5c7dqlQ4kICh8UGIK5hEaQF3hJk7S5R05ESavv7/Th/scHlLrqxcCZ1AgdIwaupMYYph6mwqJ8C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRTZefp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRTZefp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666D3C2BBFC;
	Wed, 19 Jun 2024 13:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804059;
	bh=fxuiVHqqec+s2NcHJYIrDN7XgpFsToOK33Y2ikn+rdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRTZefp87WZVGjtT1izrEu81pF2VhNcEbQmLv9TI5XkgpOCu6Ty7lXo7VSLKK3C1m
	 dodAfx83bPTaHu6XgbwKDVCM3yDEB6QuO0NHXR2OdvVpJEjGGNiQpEgvranQlFMvd1
	 6ZmR+lLJ/41o7a3uaO0WbZDKLMf7Iq+t9tf2DZXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 195/217] btrfs: zoned: factor out per-zone logic from btrfs_load_block_group_zone_info
Date: Wed, 19 Jun 2024 14:57:18 +0200
Message-ID: <20240619125604.209202617@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 09a46725cc84165af452d978a3532d6b97a28796 upstream.

Split out a helper for the body of the per-zone loop in
btrfs_load_block_group_zone_info to make the function easier to read and
modify.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |  184 +++++++++++++++++++++++++++----------------------------
 1 file changed, 92 insertions(+), 92 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1276,19 +1276,103 @@ struct zone_info {
 	u64 alloc_offset;
 };
 
+static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
+				struct zone_info *info, unsigned long *active,
+				struct map_lookup *map)
+{
+	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	struct btrfs_device *device = map->stripes[zone_idx].dev;
+	int dev_replace_is_ongoing = 0;
+	unsigned int nofs_flag;
+	struct blk_zone zone;
+	int ret;
+
+	info->physical = map->stripes[zone_idx].physical;
+
+	if (!device->bdev) {
+		info->alloc_offset = WP_MISSING_DEV;
+		return 0;
+	}
+
+	/* Consider a zone as active if we can allow any number of active zones. */
+	if (!device->zone_info->max_active_zones)
+		__set_bit(zone_idx, active);
+
+	if (!btrfs_dev_is_sequential(device, info->physical)) {
+		info->alloc_offset = WP_CONVENTIONAL;
+		return 0;
+	}
+
+	/* This zone will be used for allocation, so mark this zone non-empty. */
+	btrfs_dev_clear_zone_empty(device, info->physical);
+
+	down_read(&dev_replace->rwsem);
+	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(dev_replace);
+	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL)
+		btrfs_dev_clear_zone_empty(dev_replace->tgtdev, info->physical);
+	up_read(&dev_replace->rwsem);
+
+	/*
+	 * The group is mapped to a sequential zone. Get the zone write pointer
+	 * to determine the allocation offset within the zone.
+	 */
+	WARN_ON(!IS_ALIGNED(info->physical, fs_info->zone_size));
+	nofs_flag = memalloc_nofs_save();
+	ret = btrfs_get_dev_zone(device, info->physical, &zone);
+	memalloc_nofs_restore(nofs_flag);
+	if (ret) {
+		if (ret != -EIO && ret != -EOPNOTSUPP)
+			return ret;
+		info->alloc_offset = WP_MISSING_DEV;
+		return 0;
+	}
+
+	if (zone.type == BLK_ZONE_TYPE_CONVENTIONAL) {
+		btrfs_err_in_rcu(fs_info,
+		"zoned: unexpected conventional zone %llu on device %s (devid %llu)",
+			zone.start << SECTOR_SHIFT, rcu_str_deref(device->name),
+			device->devid);
+		return -EIO;
+	}
+
+	info->capacity = (zone.capacity << SECTOR_SHIFT);
+
+	switch (zone.cond) {
+	case BLK_ZONE_COND_OFFLINE:
+	case BLK_ZONE_COND_READONLY:
+		btrfs_err(fs_info,
+		"zoned: offline/readonly zone %llu on device %s (devid %llu)",
+			  (info->physical >> device->zone_info->zone_size_shift),
+			  rcu_str_deref(device->name), device->devid);
+		info->alloc_offset = WP_MISSING_DEV;
+		break;
+	case BLK_ZONE_COND_EMPTY:
+		info->alloc_offset = 0;
+		break;
+	case BLK_ZONE_COND_FULL:
+		info->alloc_offset = info->capacity;
+		break;
+	default:
+		/* Partially used zone. */
+		info->alloc_offset = ((zone.wp - zone.start) << SECTOR_SHIFT);
+		__set_bit(zone_idx, active);
+		break;
+	}
+
+	return 0;
+}
+
 int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
 	struct extent_map_tree *em_tree = &fs_info->mapping_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
-	struct btrfs_device *device;
 	u64 logical = cache->start;
 	u64 length = cache->length;
 	struct zone_info *zone_info = NULL;
 	int ret;
 	int i;
-	unsigned int nofs_flag;
 	unsigned long *active = NULL;
 	u64 last_alloc = 0;
 	u32 num_sequential = 0, num_conventional = 0;
@@ -1333,98 +1417,14 @@ int btrfs_load_block_group_zone_info(str
 	}
 
 	for (i = 0; i < map->num_stripes; i++) {
-		struct zone_info *info = &zone_info[i];
-		bool is_sequential;
-		struct blk_zone zone;
-		struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
-		int dev_replace_is_ongoing = 0;
-
-		device = map->stripes[i].dev;
-		info->physical = map->stripes[i].physical;
-
-		if (device->bdev == NULL) {
-			info->alloc_offset = WP_MISSING_DEV;
-			continue;
-		}
-
-		is_sequential = btrfs_dev_is_sequential(device, info->physical);
-		if (is_sequential)
-			num_sequential++;
-		else
-			num_conventional++;
-
-		/*
-		 * Consider a zone as active if we can allow any number of
-		 * active zones.
-		 */
-		if (!device->zone_info->max_active_zones)
-			__set_bit(i, active);
-
-		if (!is_sequential) {
-			info->alloc_offset = WP_CONVENTIONAL;
-			continue;
-		}
-
-		/*
-		 * This zone will be used for allocation, so mark this zone
-		 * non-empty.
-		 */
-		btrfs_dev_clear_zone_empty(device, info->physical);
-
-		down_read(&dev_replace->rwsem);
-		dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(dev_replace);
-		if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL)
-			btrfs_dev_clear_zone_empty(dev_replace->tgtdev, info->physical);
-		up_read(&dev_replace->rwsem);
-
-		/*
-		 * The group is mapped to a sequential zone. Get the zone write
-		 * pointer to determine the allocation offset within the zone.
-		 */
-		WARN_ON(!IS_ALIGNED(info->physical, fs_info->zone_size));
-		nofs_flag = memalloc_nofs_save();
-		ret = btrfs_get_dev_zone(device, info->physical, &zone);
-		memalloc_nofs_restore(nofs_flag);
-		if (ret == -EIO || ret == -EOPNOTSUPP) {
-			ret = 0;
-			info->alloc_offset = WP_MISSING_DEV;
-			continue;
-		} else if (ret) {
+		ret = btrfs_load_zone_info(fs_info, i, &zone_info[i], active, map);
+		if (ret)
 			goto out;
-		}
-
-		if (zone.type == BLK_ZONE_TYPE_CONVENTIONAL) {
-			btrfs_err_in_rcu(fs_info,
-	"zoned: unexpected conventional zone %llu on device %s (devid %llu)",
-				zone.start << SECTOR_SHIFT,
-				rcu_str_deref(device->name), device->devid);
-			ret = -EIO;
-			goto out;
-		}
-
-		info->capacity = (zone.capacity << SECTOR_SHIFT);
 
-		switch (zone.cond) {
-		case BLK_ZONE_COND_OFFLINE:
-		case BLK_ZONE_COND_READONLY:
-			btrfs_err(fs_info,
-		"zoned: offline/readonly zone %llu on device %s (devid %llu)",
-				  info->physical >> device->zone_info->zone_size_shift,
-				  rcu_str_deref(device->name), device->devid);
-			info->alloc_offset = WP_MISSING_DEV;
-			break;
-		case BLK_ZONE_COND_EMPTY:
-			info->alloc_offset = 0;
-			break;
-		case BLK_ZONE_COND_FULL:
-			info->alloc_offset = info->capacity;
-			break;
-		default:
-			/* Partially used zone */
-			info->alloc_offset = ((zone.wp - zone.start) << SECTOR_SHIFT);
-			__set_bit(i, active);
-			break;
-		}
+		if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+			num_conventional++;
+		else
+			num_sequential++;
 	}
 
 	if (num_sequential > 0)


