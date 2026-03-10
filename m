Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC0937B413;
	Tue, 10 Mar 2026 11:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141993; cv=none; b=P8YPXQ5ZwUUlOoS0e6D+hlxatmLvt8eEwwUvb3wp5lt5mAJ9lKGC4WGlau7jC013a9h+AnSbTBMclUf7v5Czah2Lvy1G/XUfAZUh2u4m8nS9qFfc3f/FJi7nb9FxzyBOcfzwq8D51pQx7wRfFdmThncuBaaUyOAMFOy8bcOWQEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141993; c=relaxed/simple;
	bh=5h7t5h0gIZuNmsiHjyN3MYQ7P9SoDW1oMue0HjChvvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8z9+ibscnhemXD5JpY3kQthsg2pXdO5zyVEIBDzcRzI214d63U78apeVoOzTRwmJquxMA4i15ZMeTYjOciBLKZh5pl3khFzVHg8oFsnAmQIQCAdfoRwqAluE3iNTionWGBDWPaaWqB4eOJq7Vpyaxc/Vde43yBiZYlLb7uHT00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXgebCCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXgebCCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82775C19423;
	Tue, 10 Mar 2026 11:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141993;
	bh=5h7t5h0gIZuNmsiHjyN3MYQ7P9SoDW1oMue0HjChvvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXgebCCOJ8NXaGEoAQpKjj6cr7v2IAuG4nI2tVHKy+gAOHFftNJNN9nm9Ac6IXVhD
	 KLzOAZd1QsLLwmzAmdxaf+5Sj6795gAgcd/ylejbVORHyXrcM3LOL73viUQn+VQKb2
	 nnrs5vXPvP92ZVhAIO4pxVAqER682QPfCX05RZlkrRfgWhnzA56asfo43yTh+wYuWf
	 a9LVpU4YfFevO5JONKJm0y93JdyVqeL+J9QOxuGo1Lydm8nxw/dG3yiu+izIVOiqS5
	 seVDGj1J4cQNpxwfsxcJHqeF8DurulzofClZ5KsOPCseZfePSREbgRN9AeOwgX9RQR
	 xuZWa5nJmHyNg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/314] btrfs: zoned: fixup last alloc pointer after extent removal for RAID0/10
Date: Tue, 10 Mar 2026 07:16:17 -0400
Message-ID: <66c7f719395eb803f9960392f4654c412d209281.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 52ee9965d09b2c56a027613db30d1fb20d623861 ]

When a block group is composed of a sequential write zone and a
conventional zone, we recover the (pseudo) write pointer of the
conventional zone using the end of the last allocated position.

However, if the last extent in a block group is removed, the last extent
position will be smaller than the other real write pointer position.
Then, that will cause an error due to mismatch of the write pointers.

We can fixup this case by moving the alloc_offset to the corresponding
write pointer position.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 194 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 179 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 4cbe1ba7af66d..e14a4234954ba 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1553,7 +1553,9 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 	u64 stripe_nr = 0, stripe_offset = 0;
+	u64 prev_offset = 0;
 	u32 stripe_index = 0;
+	bool has_partial = false, has_conventional = false;
 
 	if ((map->type & BTRFS_BLOCK_GROUP_DATA) && !fs_info->stripe_root) {
 		btrfs_err(fs_info, "zoned: data %s needs raid-stripe-tree",
@@ -1561,6 +1563,35 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 		return -EINVAL;
 	}
 
+	/*
+	 * When the last extent is removed, last_alloc can be smaller than the other write
+	 * pointer. In that case, last_alloc should be moved to the corresponding write
+	 * pointer position.
+	 */
+	for (int i = 0; i < map->num_stripes; i++) {
+		u64 alloc;
+
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV ||
+		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
+			continue;
+
+		stripe_nr = zone_info[i].alloc_offset >> BTRFS_STRIPE_LEN_SHIFT;
+		stripe_offset = zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK;
+		if (stripe_offset == 0 && stripe_nr > 0) {
+			stripe_nr--;
+			stripe_offset = BTRFS_STRIPE_LEN;
+		}
+		alloc = ((stripe_nr * map->num_stripes + i) << BTRFS_STRIPE_LEN_SHIFT) +
+			stripe_offset;
+		last_alloc = max(last_alloc, alloc);
+
+		/* Partially written stripe found. It should be last. */
+		if (zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK)
+			break;
+	}
+	stripe_nr = 0;
+	stripe_offset = 0;
+
 	if (last_alloc) {
 		u32 factor = map->num_stripes;
 
@@ -1574,7 +1605,7 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 			continue;
 
 		if (zone_info[i].alloc_offset == WP_CONVENTIONAL) {
-
+			has_conventional = true;
 			zone_info[i].alloc_offset = btrfs_stripe_nr_to_offset(stripe_nr);
 
 			if (stripe_index > i)
@@ -1583,6 +1614,28 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 				zone_info[i].alloc_offset += stripe_offset;
 		}
 
+		/* Verification */
+		if (i != 0) {
+			if (unlikely(prev_offset < zone_info[i].alloc_offset)) {
+				btrfs_err(fs_info,
+				"zoned: stripe position disorder found in block group %llu",
+					  bg->start);
+				return -EIO;
+			}
+
+			if (unlikely(has_partial &&
+				     (zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK))) {
+				btrfs_err(fs_info,
+				"zoned: multiple partial written stripe found in block group %llu",
+					  bg->start);
+				return -EIO;
+			}
+		}
+		prev_offset = zone_info[i].alloc_offset;
+
+		if ((zone_info[i].alloc_offset & BTRFS_STRIPE_LEN_MASK) != 0)
+			has_partial = true;
+
 		if (test_bit(0, active) != test_bit(i, active)) {
 			if (unlikely(!btrfs_zone_activate(bg)))
 				return -EIO;
@@ -1594,6 +1647,19 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 		bg->alloc_offset += zone_info[i].alloc_offset;
 	}
 
+	/* Check if all devices stay in the same stripe row. */
+	if (unlikely(zone_info[0].alloc_offset -
+		     zone_info[map->num_stripes - 1].alloc_offset > BTRFS_STRIPE_LEN)) {
+		btrfs_err(fs_info, "zoned: stripe gap too large in block group %llu", bg->start);
+		return -EIO;
+	}
+
+	if (unlikely(has_conventional && bg->alloc_offset < last_alloc)) {
+		btrfs_err(fs_info, "zoned: allocated extent stays beyond write pointers %llu %llu",
+			  bg->alloc_offset, last_alloc);
+		return -EIO;
+	}
+
 	return 0;
 }
 
@@ -1604,8 +1670,11 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 					 u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	u64 AUTO_KFREE(raid0_allocs);
 	u64 stripe_nr = 0, stripe_offset = 0;
 	u32 stripe_index = 0;
+	bool has_partial = false, has_conventional = false;
+	u64 prev_offset = 0;
 
 	if ((map->type & BTRFS_BLOCK_GROUP_DATA) && !fs_info->stripe_root) {
 		btrfs_err(fs_info, "zoned: data %s needs raid-stripe-tree",
@@ -1613,6 +1682,60 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 		return -EINVAL;
 	}
 
+	raid0_allocs = kcalloc(map->num_stripes / map->sub_stripes, sizeof(*raid0_allocs),
+			       GFP_NOFS);
+	if (!raid0_allocs)
+		return -ENOMEM;
+
+	/*
+	 * When the last extent is removed, last_alloc can be smaller than the other write
+	 * pointer. In that case, last_alloc should be moved to the corresponding write
+	 * pointer position.
+	 */
+	for (int i = 0; i < map->num_stripes; i += map->sub_stripes) {
+		u64 alloc = zone_info[i].alloc_offset;
+
+		for (int j = 1; j < map->sub_stripes; j++) {
+			int idx = i + j;
+
+			if (zone_info[idx].alloc_offset == WP_MISSING_DEV ||
+			    zone_info[idx].alloc_offset == WP_CONVENTIONAL)
+				continue;
+			if (alloc == WP_MISSING_DEV || alloc == WP_CONVENTIONAL) {
+				alloc = zone_info[idx].alloc_offset;
+			} else if (unlikely(zone_info[idx].alloc_offset != alloc)) {
+				btrfs_err(fs_info,
+				"zoned: write pointer mismatch found in block group %llu",
+					  bg->start);
+				return -EIO;
+			}
+		}
+
+		raid0_allocs[i / map->sub_stripes] = alloc;
+		if (alloc == WP_CONVENTIONAL)
+			continue;
+		if (unlikely(alloc == WP_MISSING_DEV)) {
+			btrfs_err(fs_info,
+			"zoned: cannot recover write pointer of block group %llu due to missing device",
+				  bg->start);
+			return -EIO;
+		}
+
+		stripe_nr = alloc >> BTRFS_STRIPE_LEN_SHIFT;
+		stripe_offset = alloc & BTRFS_STRIPE_LEN_MASK;
+		if (stripe_offset == 0 && stripe_nr > 0) {
+			stripe_nr--;
+			stripe_offset = BTRFS_STRIPE_LEN;
+		}
+
+		alloc = ((stripe_nr * (map->num_stripes / map->sub_stripes) +
+			  (i / map->sub_stripes)) <<
+			 BTRFS_STRIPE_LEN_SHIFT) + stripe_offset;
+		last_alloc = max(last_alloc, alloc);
+	}
+	stripe_nr = 0;
+	stripe_offset = 0;
+
 	if (last_alloc) {
 		u32 factor = map->num_stripes / map->sub_stripes;
 
@@ -1622,24 +1745,51 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 	}
 
 	for (int i = 0; i < map->num_stripes; i++) {
-		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
-			continue;
+		int idx = i / map->sub_stripes;
 
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_zone_activate(bg)))
-				return -EIO;
-		} else {
-			if (test_bit(0, active))
-				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
+		if (raid0_allocs[idx] == WP_CONVENTIONAL) {
+			has_conventional = true;
+			raid0_allocs[idx] = btrfs_stripe_nr_to_offset(stripe_nr);
+
+			if (stripe_index > idx)
+				raid0_allocs[idx] += BTRFS_STRIPE_LEN;
+			else if (stripe_index == idx)
+				raid0_allocs[idx] += stripe_offset;
 		}
 
-		if (zone_info[i].alloc_offset == WP_CONVENTIONAL) {
-			zone_info[i].alloc_offset = btrfs_stripe_nr_to_offset(stripe_nr);
+		if ((i % map->sub_stripes) == 0) {
+			/* Verification */
+			if (i != 0) {
+				if (unlikely(prev_offset < raid0_allocs[idx])) {
+					btrfs_err(fs_info,
+					"zoned: stripe position disorder found in block group %llu",
+						  bg->start);
+					return -EIO;
+				}
 
-			if (stripe_index > (i / map->sub_stripes))
-				zone_info[i].alloc_offset += BTRFS_STRIPE_LEN;
-			else if (stripe_index == (i / map->sub_stripes))
-				zone_info[i].alloc_offset += stripe_offset;
+				if (unlikely(has_partial &&
+					     (raid0_allocs[idx] & BTRFS_STRIPE_LEN_MASK))) {
+					btrfs_err(fs_info,
+					"zoned: multiple partial written stripe found in block group %llu",
+						  bg->start);
+					return -EIO;
+				}
+			}
+			prev_offset = raid0_allocs[idx];
+
+			if ((raid0_allocs[idx] & BTRFS_STRIPE_LEN_MASK) != 0)
+				has_partial = true;
+		}
+
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV ||
+		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
+			zone_info[i].alloc_offset = raid0_allocs[idx];
+
+		if (test_bit(0, active) != test_bit(i, active)) {
+			if (unlikely(!btrfs_zone_activate(bg)))
+				return -EIO;
+		} else if (test_bit(0, active)) {
+			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
 		}
 
 		if ((i % map->sub_stripes) == 0) {
@@ -1648,6 +1798,20 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 		}
 	}
 
+	/* Check if all devices stay in the same stripe row. */
+	if (unlikely(zone_info[0].alloc_offset -
+		     zone_info[map->num_stripes - 1].alloc_offset > BTRFS_STRIPE_LEN)) {
+		btrfs_err(fs_info, "zoned: stripe gap too large in block group %llu",
+			  bg->start);
+		return -EIO;
+	}
+
+	if (unlikely(has_conventional && bg->alloc_offset < last_alloc)) {
+		btrfs_err(fs_info, "zoned: allocated extent stays beyond write pointers %llu %llu",
+			  bg->alloc_offset, last_alloc);
+		return -EIO;
+	}
+
 	return 0;
 }
 
-- 
2.51.0

