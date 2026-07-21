Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1862146EF81;
	Tue, 21 Jul 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656654; cv=none; b=LTxigv+nyFrKPLaXmkoWA4jndQ+MuHL654djGdk7eQ7dcwDESLKXbPNW9DgHG5UspAnLC8iuZ+bw6CxhdKkCHfHA4xSoCfcyvRYMX+e4vb8HQKmaALSAv0Y/aN2A8Bk69LZzedtlBTeEwskwFyJQky/IjuCdCmIoX9fwdiMKQV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656654; c=relaxed/simple;
	bh=ldOSO2q/EbI4pb1SXgdSXeSnwBlAUHUdWhOPx7i63a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOUaQ4GD8Tl6ETdkyUH9MTwKY9GXRzu9Exf/xH/nmljm+CGNso9vKizzxy3wxls5XFu8ThXf4fRKsTVCp4GA4O/3d7oRvXx+UE/+5ksjuq5B9dBlEbwQ1mqKXFjT/zhslTW+qt85OoK+RXM3D6N8ZcBW1TpE9YB/Y3N5imQGJB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bJN6l3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bJN6l3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407FA1F000E9;
	Tue, 21 Jul 2026 17:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656652;
	bh=MGruPL2MwBpfBikL2EYBsePWS28tHSMiYYRCs2xGT/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bJN6l3Jw0Zlyob+NOCB2zGsPizxTvPpPOfkBwslwGvFj/AM9D+KbzO41A58ss6mI
	 gdKMzYb534wybmSZCbOFQ/NIv4vhZzHFb7JuvpQmDajkHl4zBc+CvNKjH3gvvne0Vw
	 vUwTNQwOfcEHnDCz1Hnmobkh4KfhOT1JeyExABn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0425/1611] btrfs: zoned: always set max_active_zones for zoned devices
Date: Tue, 21 Jul 2026 17:09:01 +0200
Message-ID: <20260721152524.828161909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 16818dbf48a464..b8fc97e33009bf 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -352,12 +352,33 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
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
@@ -422,19 +443,9 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
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
@@ -514,26 +525,29 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
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



