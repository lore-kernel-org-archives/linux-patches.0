Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABC913D525;
	Wed, 19 Jun 2024 13:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802532; cv=none; b=IJONQkDZA52ygKWT29kNVW/TEe4YY3J/HkgTBooVK3iD6ZbOo9J7ML0CO9Nh12QFAW8uRgWY4mVrW1Lpg3l5VelwH3xp2+/BfoNsVUvyaW0xHRq7iJdOmqzY30HNetYA3XGV+B8nqtYhKtlKtJ2MYn/Sq8dmJFkfS5fqQo/G/EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802532; c=relaxed/simple;
	bh=D0MDu98dp7c5Nv1deaEIBoHW13VwK1al5W60OWllevE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPIPG17jGr2ypJH9CQXp7SKR3BJLoY9koWe+7SmCPLDbufQfmIQOjF6zdOk2vpkw+KlXI4B80mKrTTn5kY4vrbQ1Laj0fDbhd4uZN65bx9bIusygEND06jftbgV95gURXH0FXDMevsdITs7JbmWOrB56Piar4zQlxJg/P3TluEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nMTgSoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nMTgSoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E354BC2BBFC;
	Wed, 19 Jun 2024 13:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802532;
	bh=D0MDu98dp7c5Nv1deaEIBoHW13VwK1al5W60OWllevE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nMTgSoJSxk1dvbyrp5M/Ukdrl1jXGhyWWBgCKSHqL/vB1OCO4QsqhtWHPOHbfWLB
	 GDnWWiqPv1vBBMT+HoxjLI7J/fuPSK0A1/LOfZ6sPaMSwAMyaCOpw3H0C8LiWt6qqJ
	 MzTXsZG9pVa0bu72TsmeSm67iqvPvpb5MafkFBvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 229/267] btrfs: zoned: fix use-after-free due to race with dev replace
Date: Wed, 19 Jun 2024 14:56:20 +0200
Message-ID: <20240619125615.114663613@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 0090d6e1b210551e63cf43958dc7a1ec942cdde9 upstream.

While loading a zone's info during creation of a block group, we can race
with a device replace operation and then trigger a use-after-free on the
device that was just replaced (source device of the replace operation).

This happens because at btrfs_load_zone_info() we extract a device from
the chunk map into a local variable and then use the device while not
under the protection of the device replace rwsem. So if there's a device
replace operation happening when we extract the device and that device
is the source of the replace operation, we will trigger a use-after-free
if before we finish using the device the replace operation finishes and
frees the device.

Fix this by enlarging the critical section under the protection of the
device replace rwsem so that all uses of the device are done inside the
critical section.

CC: stable@vger.kernel.org # 6.1.x: 15c12fcc50a1: btrfs: zoned: introduce a zone_info struct in btrfs_load_block_group_zone_info
CC: stable@vger.kernel.org # 6.1.x: 09a46725cc84: btrfs: zoned: factor out per-zone logic from btrfs_load_block_group_zone_info
CC: stable@vger.kernel.org # 6.1.x: 9e0e3e74dc69: btrfs: zoned: factor out single bg handling from btrfs_load_block_group_zone_info
CC: stable@vger.kernel.org # 6.1.x: 87463f7e0250: btrfs: zoned: factor out DUP bg handling from btrfs_load_block_group_zone_info
CC: stable@vger.kernel.org # 6.1.x
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1293,7 +1293,7 @@ static int btrfs_load_zone_info(struct b
 				struct map_lookup *map)
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
-	struct btrfs_device *device = map->stripes[zone_idx].dev;
+	struct btrfs_device *device;
 	int dev_replace_is_ongoing = 0;
 	unsigned int nofs_flag;
 	struct blk_zone zone;
@@ -1301,7 +1301,11 @@ static int btrfs_load_zone_info(struct b
 
 	info->physical = map->stripes[zone_idx].physical;
 
+	down_read(&dev_replace->rwsem);
+	device = map->stripes[zone_idx].dev;
+
 	if (!device->bdev) {
+		up_read(&dev_replace->rwsem);
 		info->alloc_offset = WP_MISSING_DEV;
 		return 0;
 	}
@@ -1311,6 +1315,7 @@ static int btrfs_load_zone_info(struct b
 		__set_bit(zone_idx, active);
 
 	if (!btrfs_dev_is_sequential(device, info->physical)) {
+		up_read(&dev_replace->rwsem);
 		info->alloc_offset = WP_CONVENTIONAL;
 		return 0;
 	}
@@ -1318,11 +1323,9 @@ static int btrfs_load_zone_info(struct b
 	/* This zone will be used for allocation, so mark this zone non-empty. */
 	btrfs_dev_clear_zone_empty(device, info->physical);
 
-	down_read(&dev_replace->rwsem);
 	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(dev_replace);
 	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL)
 		btrfs_dev_clear_zone_empty(dev_replace->tgtdev, info->physical);
-	up_read(&dev_replace->rwsem);
 
 	/*
 	 * The group is mapped to a sequential zone. Get the zone write pointer
@@ -1333,6 +1336,7 @@ static int btrfs_load_zone_info(struct b
 	ret = btrfs_get_dev_zone(device, info->physical, &zone);
 	memalloc_nofs_restore(nofs_flag);
 	if (ret) {
+		up_read(&dev_replace->rwsem);
 		if (ret != -EIO && ret != -EOPNOTSUPP)
 			return ret;
 		info->alloc_offset = WP_MISSING_DEV;
@@ -1344,6 +1348,7 @@ static int btrfs_load_zone_info(struct b
 		"zoned: unexpected conventional zone %llu on device %s (devid %llu)",
 			zone.start << SECTOR_SHIFT, rcu_str_deref(device->name),
 			device->devid);
+		up_read(&dev_replace->rwsem);
 		return -EIO;
 	}
 
@@ -1371,6 +1376,8 @@ static int btrfs_load_zone_info(struct b
 		break;
 	}
 
+	up_read(&dev_replace->rwsem);
+
 	return 0;
 }
 


