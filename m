Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8731B1F9F70;
	Thu, 12 Mar 2026 20:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346720; cv=none; b=TcsjC0OvmTd1ZuG4Yu2bgqoGJPNUcIirOwDrcCsPXkWkHYdLAzu3hk2iPDIpevspCA6XO31rAd29Y0dVJMt9hRf1K0e4wG+dQQkQGjM+wzGsCCBVJHPPt1inl59bNbDC/yMG1Q1BXaQOEzXuWfBO4qZM6LQSthBP1zV/msr6Kco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346720; c=relaxed/simple;
	bh=OW8ruiF9W7VsH9JaSPvgDsq/OJHZ1jzDJzb6uTiCyGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdEYK/unfKPIGrfh74jtJkKbGZ4pESLxVlR9ftZdP900TpPC/Hd0YA8Fd0qG9A38nQDJP1xGyaJQ5fIQZHsnb3UqeiYT23fSH5YoIEyq2zZdZmviuYH4ziUEsBN3Xe41/p9Rz+5hR3+2L/fMqy4RxY3YpcLkWHoPpJKXIB9g9SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpTioGRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpTioGRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EACEC2BC87;
	Thu, 12 Mar 2026 20:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346720;
	bh=OW8ruiF9W7VsH9JaSPvgDsq/OJHZ1jzDJzb6uTiCyGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpTioGRTSVy0llkjTCj0aEar51V16o6OU3vWJXQiE34oiG++TXdxC8g+asRqF0vT4
	 rmaQIRkJhWvDYGZ7A2oM4A3e72qIZJTM7InVvFNVsl5qfS4dkprBxjYMUjKZJ15h95
	 MHVOCQiggrmoDRLTLyOZWYv5rbSf9ketSU6MIgEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/265] btrfs: zoned: fix stripe width calculation
Date: Thu, 12 Mar 2026 21:08:14 +0100
Message-ID: <20260312201022.099383028@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 6a1ab50135ce829b834b448ce49867b5210a1641 ]

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
Stable-dep-of: 52ee9965d09b ("btrfs: zoned: fixup last alloc pointer after extent removal for RAID0/10")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 56 ++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index bf41d9b641f58..f63885c7bedfe 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1521,6 +1521,8 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	u64 stripe_nr = 0, stripe_offset = 0;
+	u32 stripe_index = 0;
 
 	if ((map->type & BTRFS_BLOCK_GROUP_DATA) && !fs_info->stripe_root) {
 		btrfs_err(fs_info, "zoned: data %s needs raid-stripe-tree",
@@ -1528,28 +1530,26 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
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
 
-			stripe_nr = div64_u64(last_alloc, map->stripe_size);
-			stripe_offset = stripe_nr * map->stripe_size;
-			full_stripe_nr = div_u64(stripe_nr, map->num_stripes);
-			div_u64_rem(stripe_nr, map->num_stripes, &stripe_index);
-
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
@@ -1573,6 +1573,8 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 					 u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	u64 stripe_nr = 0, stripe_offset = 0;
+	u32 stripe_index = 0;
 
 	if ((map->type & BTRFS_BLOCK_GROUP_DATA) && !fs_info->stripe_root) {
 		btrfs_err(fs_info, "zoned: data %s needs raid-stripe-tree",
@@ -1580,6 +1582,14 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
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
@@ -1593,26 +1603,12 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
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
-- 
2.51.0



