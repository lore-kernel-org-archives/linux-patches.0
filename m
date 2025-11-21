Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018383446CD;
	Fri, 21 Nov 2025 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731460; cv=none; b=tzVJOvtFFbJPxXWn+pi4CknghqHH1GCA+l3EXSDKhlzXbCTHKF0I1FYz1C5pEAlbgAP4+9LNCW6RMK45AVQLpMOSKYTYrPPgQdv+h0DVj1s6BdYtSRQfFvhDG91wTAZx3qHNPnb3QLeuoL483OZOuadzAzaDabsDwvJ+RDTmFuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731460; c=relaxed/simple;
	bh=ltbFZdaC8/2dcFcYgQd5hywcCgm/xDtykvNRmoDG2W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIuQhRBdb9TkcmERBo/K68mv6qXRkhxn9ql60BSyAkTS14u4sXOomcB9hxfbBo4kvzNKPDaxqm2ITDVJLz4kjAlxAJFpuK5fRKwPY/5HcvvvvIYEA8yMR+ihk+PFlqo1ocgkSYK6YWUmDRBRP7LbRmMWiH9rMWiUnwJ7/StbW1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCUSr01F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCUSr01F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0C6C4CEFB;
	Fri, 21 Nov 2025 13:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731459;
	bh=ltbFZdaC8/2dcFcYgQd5hywcCgm/xDtykvNRmoDG2W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCUSr01FERCdkgHrkNUJ4BoXno/doeXXHBkgpPM4TMhxiw78gxltS3ybgeXtCRoK6
	 dvV8xpzIavlil9uzDha4nNN2aGzOC7VlTAHe99a0iZe1B5Bi0gPs7W8qLIk8bqH6ii
	 9eJDaPZvvfN4YcszJOJnD24FM+gsw4UQ5BRVJSeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 215/247] btrfs: zoned: fix stripe width calculation
Date: Fri, 21 Nov 2025 14:12:42 +0100
Message-ID: <20251121130202.447673666@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 6a1ab50135ce829b834b448ce49867b5210a1641 upstream.

The stripe offset calculation in the zoned code for raid0 and raid10
wrongly uses map->stripe_size to calculate it. In fact, map->stripe_size is
the size of the device extent composing the block group, which always is
the zone_size on the zoned setup.

Fix it by using BTRFS_STRIPE_LEN and BTRFS_STRIPE_LEN_SHIFT. Also, optimize
the calculation a bit by doing the common calculation only once.

Fixes: c0d90a79e8e6 ("btrfs: zoned: fix alloc_offset calculation for partly conventional block groups")
CC: stable@vger.kernel.org # 6.17+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   56 +++++++++++++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1523,6 +1523,8 @@ static int btrfs_load_block_group_raid0(
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	u64 stripe_nr = 0, stripe_offset = 0;
+	u32 stripe_index = 0;
 
 	if ((map->type & BTRFS_BLOCK_GROUP_DATA) && !fs_info->stripe_root) {
 		btrfs_err(fs_info, "zoned: data %s needs raid-stripe-tree",
@@ -1530,28 +1532,26 @@ static int btrfs_load_block_group_raid0(
 		return -EINVAL;
 	}
 
+	if (last_alloc) {
+		u32 factor = map->num_stripes;
+
+		stripe_nr = last_alloc >> BTRFS_STRIPE_LEN_SHIFT;
+		stripe_offset = last_alloc & BTRFS_STRIPE_LEN_MASK;
+		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
+	}
+
 	for (int i = 0; i < map->num_stripes; i++) {
 		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
 			continue;
 
 		if (zone_info[i].alloc_offset == WP_CONVENTIONAL) {
-			u64 stripe_nr, full_stripe_nr;
-			u64 stripe_offset;
-			int stripe_index;
-
-			stripe_nr = div64_u64(last_alloc, map->stripe_size);
-			stripe_offset = stripe_nr * map->stripe_size;
-			full_stripe_nr = div_u64(stripe_nr, map->num_stripes);
-			div_u64_rem(stripe_nr, map->num_stripes, &stripe_index);
 
-			zone_info[i].alloc_offset =
-				full_stripe_nr * map->stripe_size;
+			zone_info[i].alloc_offset = btrfs_stripe_nr_to_offset(stripe_nr);
 
 			if (stripe_index > i)
-				zone_info[i].alloc_offset += map->stripe_size;
+				zone_info[i].alloc_offset += BTRFS_STRIPE_LEN;
 			else if (stripe_index == i)
-				zone_info[i].alloc_offset +=
-					(last_alloc - stripe_offset);
+				zone_info[i].alloc_offset += stripe_offset;
 		}
 
 		if (test_bit(0, active) != test_bit(i, active)) {
@@ -1575,6 +1575,8 @@ static int btrfs_load_block_group_raid10
 					 u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	u64 stripe_nr = 0, stripe_offset = 0;
+	u32 stripe_index = 0;
 
 	if ((map->type & BTRFS_BLOCK_GROUP_DATA) && !fs_info->stripe_root) {
 		btrfs_err(fs_info, "zoned: data %s needs raid-stripe-tree",
@@ -1582,6 +1584,14 @@ static int btrfs_load_block_group_raid10
 		return -EINVAL;
 	}
 
+	if (last_alloc) {
+		u32 factor = map->num_stripes / map->sub_stripes;
+
+		stripe_nr = last_alloc >> BTRFS_STRIPE_LEN_SHIFT;
+		stripe_offset = last_alloc & BTRFS_STRIPE_LEN_MASK;
+		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
+	}
+
 	for (int i = 0; i < map->num_stripes; i++) {
 		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
 			continue;
@@ -1595,26 +1605,12 @@ static int btrfs_load_block_group_raid10
 		}
 
 		if (zone_info[i].alloc_offset == WP_CONVENTIONAL) {
-			u64 stripe_nr, full_stripe_nr;
-			u64 stripe_offset;
-			int stripe_index;
-
-			stripe_nr = div64_u64(last_alloc, map->stripe_size);
-			stripe_offset = stripe_nr * map->stripe_size;
-			full_stripe_nr = div_u64(stripe_nr,
-					 map->num_stripes / map->sub_stripes);
-			div_u64_rem(stripe_nr,
-				    (map->num_stripes / map->sub_stripes),
-				    &stripe_index);
-
-			zone_info[i].alloc_offset =
-				full_stripe_nr * map->stripe_size;
+			zone_info[i].alloc_offset = btrfs_stripe_nr_to_offset(stripe_nr);
 
 			if (stripe_index > (i / map->sub_stripes))
-				zone_info[i].alloc_offset += map->stripe_size;
+				zone_info[i].alloc_offset += BTRFS_STRIPE_LEN;
 			else if (stripe_index == (i / map->sub_stripes))
-				zone_info[i].alloc_offset +=
-					(last_alloc - stripe_offset);
+				zone_info[i].alloc_offset += stripe_offset;
 		}
 
 		if ((i % map->sub_stripes) == 0) {


