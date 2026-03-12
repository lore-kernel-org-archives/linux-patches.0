Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D031F9F70;
	Thu, 12 Mar 2026 20:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346704; cv=none; b=Wg5BxJb/fl5iUWHBFTp8oGak8JPp6herEhSMpwPPn4T3eOJNKGkjjRPqE6TvQcfvuSmkL8I88HuI6L/FNT5o5C7h27W16h1Ia4BVwd0FvpLhwgEy/sPpVHNqVOu1uJ9bumj47IIhH4FizRwmbZ6JzatdzSkbxe2LPKUHUofMqdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346704; c=relaxed/simple;
	bh=ZLxCnez/LvgGgIBioQKIyaM0rxU8EYfV4ALRijcLgKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5V1XxI0mlIqf1nw2J/DwRF3UHnZ4WD2dU+6XdpV4hG2HfxwyV5y1JwCGJ4jwSR0CAMmVB0HkkpTwRsmSp5LvbtyhElAJaEaV/vNpa+k43HCl7AcJWd4fFVDUTN56AHsiOsAe+SZlESr4N87M1Fsx8nsv3GdGKcXVqbmyF4uPKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKC63G8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKC63G8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41593C4CEF7;
	Thu, 12 Mar 2026 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346703;
	bh=ZLxCnez/LvgGgIBioQKIyaM0rxU8EYfV4ALRijcLgKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKC63G8t/fM/jUHIeaZQlZ8Mtoc8/j4EzhJackcTYHkrHojgWP6rfhWuLPW7Q0y12
	 Np7gzYd0iKj/lFc79hqmkBT0kuLVmCDrI3t4gbRmOnlZd1fwViUWh0/0CCYVgn3kQb
	 RKZA3yN30euwhg//RZQu17WU/lcvJP7i5PxIguxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Sun YangKai <sunk67188@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/265] btrfs: fix periodic reclaim condition
Date: Thu, 12 Mar 2026 21:08:10 +0100
Message-ID: <20260312201021.951421526@linuxfoundation.org>
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

From: Sun YangKai <sunk67188@gmail.com>

[ Upstream commit 19eff93dc738e8afaa59cb374b44bb5a162e6c2d ]

Problems with current implementation:

1. reclaimable_bytes is signed while chunk_sz is unsigned, causing
   negative reclaimable_bytes to trigger reclaim unexpectedly

2. The "space must be freed between scans" assumption breaks the
   two-scan requirement: first scan marks block groups, second scan
   reclaims them. Without the second scan, no reclamation occurs.

Instead, track actual reclaim progress: pause reclaim when block groups
will be reclaimed, and resume only when progress is made. This ensures
reclaim continues until no further progress can be made. And resume
periodic reclaim when there's enough free space.

And we take care if reclaim is making any progress now, so it's
unnecessary to set periodic_reclaim_ready to false when failed to reclaim
a block group.

Fixes: 813d4c6422516 ("btrfs: prevent pathological periodic reclaim loops")
CC: stable@vger.kernel.org # 6.12+
Suggested-by: Boris Burkov <boris@bur.io>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Sun YangKai <sunk67188@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c |  6 ++++--
 fs/btrfs/space-info.c  | 21 ++++++++++++---------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a29dc0a15d128..c579713e9899c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1879,6 +1879,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 		u64 zone_unusable;
 		u64 used;
 		u64 reserved;
+		u64 old_total;
 		int ret = 0;
 
 		bg = list_first_entry(&fs_info->reclaim_bgs,
@@ -1954,6 +1955,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 		zone_unusable = bg->zone_unusable;
 
 		spin_unlock(&bg->lock);
+		old_total = space_info->total_bytes;
 		spin_unlock(&space_info->lock);
 
 		/*
@@ -2012,14 +2014,14 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 			reserved = 0;
 			spin_lock(&space_info->lock);
 			space_info->reclaim_errors++;
-			if (READ_ONCE(space_info->periodic_reclaim))
-				space_info->periodic_reclaim_ready = false;
 			spin_unlock(&space_info->lock);
 		}
 		spin_lock(&space_info->lock);
 		space_info->reclaim_count++;
 		space_info->reclaim_bytes += used;
 		space_info->reclaim_bytes += reserved;
+		if (space_info->total_bytes < old_total)
+			btrfs_set_periodic_reclaim_ready(space_info, true);
 		spin_unlock(&space_info->lock);
 
 next:
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 0470e041aba16..af19f7a3e74a4 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -2031,11 +2031,11 @@ static bool is_reclaim_urgent(struct btrfs_space_info *space_info)
 	return unalloc < data_chunk_size;
 }
 
-static void do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
+static bool do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
 {
 	struct btrfs_block_group *bg;
 	int thresh_pct;
-	bool try_again = true;
+	bool will_reclaim = false;
 	bool urgent;
 
 	spin_lock(&space_info->lock);
@@ -2053,7 +2053,7 @@ static void do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
 		spin_lock(&bg->lock);
 		thresh = mult_perc(bg->length, thresh_pct);
 		if (bg->used < thresh && bg->reclaim_mark) {
-			try_again = false;
+			will_reclaim = true;
 			reclaim = true;
 		}
 		bg->reclaim_mark++;
@@ -2070,12 +2070,13 @@ static void do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
 	 * If we have any staler groups, we don't touch the fresher ones, but if we
 	 * really need a block group, do take a fresh one.
 	 */
-	if (try_again && urgent) {
-		try_again = false;
+	if (!will_reclaim && urgent) {
+		urgent = false;
 		goto again;
 	}
 
 	up_read(&space_info->groups_sem);
+	return will_reclaim;
 }
 
 void btrfs_space_info_update_reclaimable(struct btrfs_space_info *space_info, s64 bytes)
@@ -2085,7 +2086,8 @@ void btrfs_space_info_update_reclaimable(struct btrfs_space_info *space_info, s6
 	lockdep_assert_held(&space_info->lock);
 	space_info->reclaimable_bytes += bytes;
 
-	if (space_info->reclaimable_bytes >= chunk_sz)
+	if (space_info->reclaimable_bytes > 0 &&
+	    space_info->reclaimable_bytes >= chunk_sz)
 		btrfs_set_periodic_reclaim_ready(space_info, true);
 }
 
@@ -2112,7 +2114,6 @@ bool btrfs_should_periodic_reclaim(struct btrfs_space_info *space_info)
 
 	spin_lock(&space_info->lock);
 	ret = space_info->periodic_reclaim_ready;
-	btrfs_set_periodic_reclaim_ready(space_info, false);
 	spin_unlock(&space_info->lock);
 
 	return ret;
@@ -2126,7 +2127,9 @@ void btrfs_reclaim_sweep(const struct btrfs_fs_info *fs_info)
 	list_for_each_entry(space_info, &fs_info->space_info, list) {
 		if (!btrfs_should_periodic_reclaim(space_info))
 			continue;
-		for (raid = 0; raid < BTRFS_NR_RAID_TYPES; raid++)
-			do_reclaim_sweep(space_info, raid);
+		for (raid = 0; raid < BTRFS_NR_RAID_TYPES; raid++) {
+			if (do_reclaim_sweep(space_info, raid))
+				btrfs_set_periodic_reclaim_ready(space_info, false);
+		}
 	}
 }
-- 
2.51.0



