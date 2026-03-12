Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67871F9F70;
	Thu, 12 Mar 2026 20:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346707; cv=none; b=DCdOZfj5dR+BMfyowjxaHkRQ7D/WFAtxHtH/fhnDLieic+sTpHqRHheXPe4SIy6rqNXKhJ6GwUKNZP8COPsDsC7t58CIK68sRtPfQsV/0bVumjn8k9tUAxwz45fy9adGzP8LixmsZbV+ojzDJ7ihOk6hQ5R+X3DUNayOtWPf/oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346707; c=relaxed/simple;
	bh=7Y11V8dDgcI4zD+xgFGaN2p200JCBF7TVwtgqo7IKwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPpwfPRScJ7mpq9wxn7Hn0qddjQVVjDgMh5ps1pyANg0tiPV8O0yXWABH1UnY7MqTnwICH2JhTJokWaZFfVGEopGrHt++XZFhCXtgQR7XrYBgpD3UT1PsXDiJ74+n7c0mbXS1Pa0NhCBfRHrkILvuA2d4+cQPDpOsC+Rwm9lOa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ejz1ejps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ejz1ejps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09558C4CEF7;
	Thu, 12 Mar 2026 20:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346707;
	bh=7Y11V8dDgcI4zD+xgFGaN2p200JCBF7TVwtgqo7IKwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ejz1ejpsQzLQlQD071PUhjG3wZqEnsJh3XZbNkjVLBS6KAHlXQf53CJErepVXLVvH
	 kiPOXIGWvD1nbqUXQpGDgRn6FUTjF3nuWXJHXACwV63zjQzDW6KMNovTj6YbPGqMAh
	 DP/5aBMQer4fuUGQ3Qo6B1n44kTJcWpYtd2sCyus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/265] btrfs: zoned: fix alloc_offset calculation for partly conventional block groups
Date: Thu, 12 Mar 2026 21:08:11 +0100
Message-ID: <20260312201021.988557777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit c0d90a79e8e65b89037508276b2b31f41a1b3783 ]

When one of two zones composing a DUP block group is a conventional zone,
we have the zone_info[i]->alloc_offset = WP_CONVENTIONAL. That will, of
course, not match the write pointer of the other zone, and fails that
block group.

This commit solves that issue by properly recovering the emulated write
pointer from the last allocated extent. The offset for the SINGLE, DUP,
and RAID1 are straight-forward: it is same as the end of last allocated
extent. The RAID0 and RAID10 are a bit tricky that we need to do the math
of striping.

This is the kernel equivalent of Naohiro's user-space commit:
"btrfs-progs: zoned: fix alloc_offset calculation for partly
conventional block groups".

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: dda3ec9ee6b3 ("btrfs: zoned: fixup last alloc pointer after extent removal for RAID1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 86 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 72 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 181cb3f56ab41..b757377d9331e 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1386,7 +1386,8 @@ static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 				      struct btrfs_chunk_map *map,
 				      struct zone_info *zone_info,
-				      unsigned long *active)
+				      unsigned long *active,
+				      u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 
@@ -1409,6 +1410,13 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 			  zone_info[1].physical);
 		return -EIO;
 	}
+
+	if (zone_info[0].alloc_offset == WP_CONVENTIONAL)
+		zone_info[0].alloc_offset = last_alloc;
+
+	if (zone_info[1].alloc_offset == WP_CONVENTIONAL)
+		zone_info[1].alloc_offset = last_alloc;
+
 	if (zone_info[0].alloc_offset != zone_info[1].alloc_offset) {
 		btrfs_err(bg->fs_info,
 			  "zoned: write pointer offset mismatch of zones in DUP profile");
@@ -1429,7 +1437,8 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active)
+					unsigned long *active,
+					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 	int i;
@@ -1444,10 +1453,12 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 	bg->zone_capacity = min_not_zero(zone_info[0].capacity, zone_info[1].capacity);
 
 	for (i = 0; i < map->num_stripes; i++) {
-		if (zone_info[i].alloc_offset == WP_MISSING_DEV ||
-		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
 			continue;
 
+		if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+			zone_info[i].alloc_offset = last_alloc;
+
 		if ((zone_info[0].alloc_offset != zone_info[i].alloc_offset) &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_err(fs_info,
@@ -1477,7 +1488,8 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active)
+					unsigned long *active,
+					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 
@@ -1488,10 +1500,29 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 	}
 
 	for (int i = 0; i < map->num_stripes; i++) {
-		if (zone_info[i].alloc_offset == WP_MISSING_DEV ||
-		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
 			continue;
 
+		if (zone_info[i].alloc_offset == WP_CONVENTIONAL) {
+			u64 stripe_nr, full_stripe_nr;
+			u64 stripe_offset;
+			int stripe_index;
+
+			stripe_nr = div64_u64(last_alloc, map->stripe_size);
+			stripe_offset = stripe_nr * map->stripe_size;
+			full_stripe_nr = div_u64(stripe_nr, map->num_stripes);
+			div_u64_rem(stripe_nr, map->num_stripes, &stripe_index);
+
+			zone_info[i].alloc_offset =
+				full_stripe_nr * map->stripe_size;
+
+			if (stripe_index > i)
+				zone_info[i].alloc_offset += map->stripe_size;
+			else if (stripe_index == i)
+				zone_info[i].alloc_offset +=
+					(last_alloc - stripe_offset);
+		}
+
 		if (test_bit(0, active) != test_bit(i, active)) {
 			if (!btrfs_zone_activate(bg))
 				return -EIO;
@@ -1509,7 +1540,8 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 					 struct btrfs_chunk_map *map,
 					 struct zone_info *zone_info,
-					 unsigned long *active)
+					 unsigned long *active,
+					 u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 
@@ -1520,8 +1552,7 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 	}
 
 	for (int i = 0; i < map->num_stripes; i++) {
-		if (zone_info[i].alloc_offset == WP_MISSING_DEV ||
-		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
 			continue;
 
 		if (test_bit(0, active) != test_bit(i, active)) {
@@ -1532,6 +1563,29 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
 		}
 
+		if (zone_info[i].alloc_offset == WP_CONVENTIONAL) {
+			u64 stripe_nr, full_stripe_nr;
+			u64 stripe_offset;
+			int stripe_index;
+
+			stripe_nr = div64_u64(last_alloc, map->stripe_size);
+			stripe_offset = stripe_nr * map->stripe_size;
+			full_stripe_nr = div_u64(stripe_nr,
+					 map->num_stripes / map->sub_stripes);
+			div_u64_rem(stripe_nr,
+				    (map->num_stripes / map->sub_stripes),
+				    &stripe_index);
+
+			zone_info[i].alloc_offset =
+				full_stripe_nr * map->stripe_size;
+
+			if (stripe_index > (i / map->sub_stripes))
+				zone_info[i].alloc_offset += map->stripe_size;
+			else if (stripe_index == (i / map->sub_stripes))
+				zone_info[i].alloc_offset +=
+					(last_alloc - stripe_offset);
+		}
+
 		if ((i % map->sub_stripes) == 0) {
 			bg->zone_capacity += zone_info[i].capacity;
 			bg->alloc_offset += zone_info[i].alloc_offset;
@@ -1619,18 +1673,22 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 		ret = btrfs_load_block_group_single(cache, &zone_info[0], active);
 		break;
 	case BTRFS_BLOCK_GROUP_DUP:
-		ret = btrfs_load_block_group_dup(cache, map, zone_info, active);
+		ret = btrfs_load_block_group_dup(cache, map, zone_info, active,
+						 last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID1:
 	case BTRFS_BLOCK_GROUP_RAID1C3:
 	case BTRFS_BLOCK_GROUP_RAID1C4:
-		ret = btrfs_load_block_group_raid1(cache, map, zone_info, active);
+		ret = btrfs_load_block_group_raid1(cache, map, zone_info,
+						   active, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID0:
-		ret = btrfs_load_block_group_raid0(cache, map, zone_info, active);
+		ret = btrfs_load_block_group_raid0(cache, map, zone_info,
+						   active, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID10:
-		ret = btrfs_load_block_group_raid10(cache, map, zone_info, active);
+		ret = btrfs_load_block_group_raid10(cache, map, zone_info,
+						    active, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID5:
 	case BTRFS_BLOCK_GROUP_RAID6:
-- 
2.51.0



