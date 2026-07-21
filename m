Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6087F46AA92;
	Tue, 21 Jul 2026 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649523; cv=none; b=N3wEAFBDsVU9nCjZNBMOTLveD3+W0FaA+H7T90fuJ7/lBuX3dW2rIWOjoKZuvoolZp6obfqWE1VCiayD9Yu2RxKc6UYd/GO1BhbHWn5uISs0FdVQWZjDOVK0C81iV8bxzkxq/Ib3bZUwRqChiSzCE9gncrV4oXoSylqkA6Jnn/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649523; c=relaxed/simple;
	bh=cB0O6JmhM9sNnptKEa0xRqO08RIaZSXIFmR5ikoGvlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ll6zXvdV7mzwPQJrZSuIfhmRcE3OgSMVr5ECzm/xXxwtl66MT8T79hXH+nRC6DZb2A/TnYyr0gApmX1ShdrbVZ6V+EsihvUgY7My6S2Sz6wOk35mhK1rE4l4cI1bvefmkTHTW3qLTv0jjxVINmvmgPiFjbd6t+heVp9PQEavkN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Peu2qk6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Peu2qk6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827351F000E9;
	Tue, 21 Jul 2026 15:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649522;
	bh=v05gezc2m467qFuKxcghkhBUJfkrGlG+IIodFolMCuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Peu2qk6E4H891g5RPYSCiMiYWNH3jA9fSFtZ/DSxSG1Oi0MYG4eS8UohVlQU/T2Mj
	 EFL76K4w/Nco2cRHp1ICM3iskEnzaE/OzaSpwyZNqoUL3jBSRUpPnXmFR767paLgvf
	 QlQJMdGUIdTucFrubmklfW1bT9Q7mhkNt5Bxz+H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0611/2077] btrfs: zoned: always set max_active_zones for zoned devices
Date: Tue, 21 Jul 2026 17:04:44 +0200
Message-ID: <20260721152607.217508086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 21a3533b99b8a53a026cc9f5041b10795c1f3ae8 ]

When a block device does not report a maximum number of open or active
zones,  currently assign BTRFS_DEFAULT_MAX_ACTIVE_ZONES (128) to
the internal limit, if the device has more than
BTRFS_DEFAULT_MAX_ACTIVE_ZONES zones.

But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
internal max_active_zones limit will stay at 0, even if the device has
zone resource limits. Furthermore, if the device has a total number of
zones that is less than BTRFS_DEFAULT_MAX_ACTIVE_ZONE, max_active_zones
should be set to at most the number of zones.

Also move the max_active_zone calculation and setting into a dedicated
helper, to shrink btrfs_get_dev_zone_info().

Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 64 +++++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 16dd87aa06f20c..0d590e81f3259b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -354,12 +354,33 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+static int btrfs_get_max_active_zones(struct btrfs_device *device,
+				      struct btrfs_zoned_device_info *zone_info)
+{
+	struct block_device *bdev = device->bdev;
+	int max_active_zones;
+
+	if (unlikely(zone_info->nr_zones < BTRFS_MIN_ACTIVE_ZONES)) {
+		btrfs_err(device->fs_info, "zoned: not enough zones to mount filesystem: %u < %d",
+			  zone_info->nr_zones, BTRFS_MIN_ACTIVE_ZONES);
+		return -EINVAL;
+	}
+
+	max_active_zones = min_not_zero(bdev_max_active_zones(bdev),
+					bdev_max_open_zones(bdev));
+	if (max_active_zones == 0)
+		max_active_zones = min(zone_info->nr_zones / 4,
+				       BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
+
+	zone_info->max_active_zones = max(max_active_zones, BTRFS_MIN_ACTIVE_ZONES);
+	return 0;
+}
+
 int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_zoned_device_info *zone_info = NULL;
 	struct block_device *bdev = device->bdev;
-	unsigned int max_active_zones;
 	unsigned int nactive;
 	sector_t nr_sectors;
 	sector_t sector = 0;
@@ -424,19 +445,9 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
-	max_active_zones = min_not_zero(bdev_max_active_zones(bdev),
-					bdev_max_open_zones(bdev));
-	if (!max_active_zones && zone_info->nr_zones > BTRFS_DEFAULT_MAX_ACTIVE_ZONES)
-		max_active_zones = BTRFS_DEFAULT_MAX_ACTIVE_ZONES;
-	if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES) {
-		btrfs_err(fs_info,
-"zoned: %s: max active zones %u is too small, need at least %u active zones",
-				 rcu_dereference(device->name), max_active_zones,
-				 BTRFS_MIN_ACTIVE_ZONES);
-		ret = -EINVAL;
+	ret = btrfs_get_max_active_zones(device, zone_info);
+	if (ret)
 		goto out;
-	}
-	zone_info->max_active_zones = max_active_zones;
 
 	zone_info->seq_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
 	if (!zone_info->seq_zones) {
@@ -517,26 +528,29 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		goto out;
 	}
 
-	if (max_active_zones) {
-		if (unlikely(nactive > max_active_zones)) {
-			if (bdev_max_active_zones(bdev) == 0) {
-				max_active_zones = 0;
-				zone_info->max_active_zones = 0;
-				goto validate;
-			}
+	if (unlikely(nactive > zone_info->max_active_zones)) {
+		if (bdev_max_active_zones(bdev) > 0) {
 			btrfs_err(device->fs_info,
-			"zoned: %u active zones on %s exceeds max_active_zones %u",
-					 nactive, rcu_dereference(device->name),
-					 max_active_zones);
+					"zoned: %u active zones on %s exceeds max_active_zones %u",
+					nactive, rcu_dereference(device->name),
+					zone_info->max_active_zones);
 			ret = -EIO;
 			goto out;
 		}
+
+		/*
+		 * This is for backward compatibility with old filesystems that
+		 * have a lot of active zones because the device doesn't report
+		 * a maximum number of zones and we previously didn't care for
+		 * the limit.
+		 */
+		zone_info->max_active_zones = 0;
+	} else {
 		atomic_set(&zone_info->active_zones_left,
-			   max_active_zones - nactive);
+				zone_info->max_active_zones - nactive);
 		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
 	}
 
-validate:
 	/* Validate superblock log */
 	nr_zones = BTRFS_NR_SB_LOG_ZONES;
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-- 
2.53.0



