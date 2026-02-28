Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C62D37146A;
	Sat, 28 Feb 2026 17:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301467; cv=none; b=n1CWfeEBaR0kSxghrb/NZT0xX9K2e1iEgfEuYpKksPro8pQ3bnAjKqpPQjAexM3E8NmLqY4e4YcDAOliAbqwo3zIrGSEz40iylF8ONww4azsjAn9hEFGYHppV2B82J0Kb3HRF0cy1XVBiQLHtL69Xq/NtdMUxCH5XzLP30tODNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301467; c=relaxed/simple;
	bh=OUbF8EdGwVq5n5WNUjr5zQuEme6GuRXukIBjrgC3cWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiM5iaw40+E11xmzkp3Yy7Tx39uVOJZaR0ZFn2UVxti9xz3s0EXy6cQZzIBoibqIVYjS29AQ29rJlqh7+fEZD/2XSKrOdvboJAkR2gFa/6yf0eiIpXl5FVbo8lr2wTSoGfhH61/aTKWIugcG69kY3QlWkwd8/P94OXH685BxwdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rsIi7NJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rsIi7NJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4315C116D0;
	Sat, 28 Feb 2026 17:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301467;
	bh=OUbF8EdGwVq5n5WNUjr5zQuEme6GuRXukIBjrgC3cWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsIi7NJtukmSG1mmnISej34WGD4uqAX8zIk7JNZrXzVcQwiJ8t1uqJoKlI9mWAt+a
	 YLe5AkY+USfTnlzdnRXx+xIeZ8/RATG2GvYY6Uq5kCdfoLskbZBBOtJGWIQL0vSjZM
	 KGR7cpF6lakquUKeJkLS8q54eOgCoz8i3u7AvBqShXVrI0gF5WX2S53u8mFT8mJVxm
	 XXD1wfLbVPZXSIzN3p1jgkhogAUqnWo50asJ0usSLhw4+mdLUqX9DbiKOgIbMWvtL2
	 9y9S7QED6tir74wh2gdolyed1M/y5bPn7gbh7clqchjnsTfT3NDMuieTyqTIt3rOC0
	 GxeWNQ7daydLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sun YangKai <sunk67188@gmail.com>,
	stable@vger.kernel.org,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 652/752] btrfs: fix periodic reclaim condition
Date: Sat, 28 Feb 2026 12:46:03 -0500
Message-ID: <20260228174750.1542406-652-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index f7f6d8cb33114..4689ef206d0ee 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1877,6 +1877,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 	while (!list_empty(&fs_info->reclaim_bgs)) {
 		u64 used;
 		u64 reserved;
+		u64 old_total;
 		int ret = 0;
 
 		bg = list_first_entry(&fs_info->reclaim_bgs,
@@ -1942,6 +1943,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 		}
 
 		spin_unlock(&bg->lock);
+		old_total = space_info->total_bytes;
 		spin_unlock(&space_info->lock);
 
 		/*
@@ -1994,14 +1996,14 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
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
index 474ed47095ba7..6b64691034de4 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -2074,11 +2074,11 @@ static bool is_reclaim_urgent(struct btrfs_space_info *space_info)
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
@@ -2096,7 +2096,7 @@ static void do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
 		spin_lock(&bg->lock);
 		thresh = mult_perc(bg->length, thresh_pct);
 		if (bg->used < thresh && bg->reclaim_mark) {
-			try_again = false;
+			will_reclaim = true;
 			reclaim = true;
 		}
 		bg->reclaim_mark++;
@@ -2113,12 +2113,13 @@ static void do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
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
@@ -2128,7 +2129,8 @@ void btrfs_space_info_update_reclaimable(struct btrfs_space_info *space_info, s6
 	lockdep_assert_held(&space_info->lock);
 	space_info->reclaimable_bytes += bytes;
 
-	if (space_info->reclaimable_bytes >= chunk_sz)
+	if (space_info->reclaimable_bytes > 0 &&
+	    space_info->reclaimable_bytes >= chunk_sz)
 		btrfs_set_periodic_reclaim_ready(space_info, true);
 }
 
@@ -2155,7 +2157,6 @@ static bool btrfs_should_periodic_reclaim(struct btrfs_space_info *space_info)
 
 	spin_lock(&space_info->lock);
 	ret = space_info->periodic_reclaim_ready;
-	btrfs_set_periodic_reclaim_ready(space_info, false);
 	spin_unlock(&space_info->lock);
 
 	return ret;
@@ -2169,8 +2170,10 @@ void btrfs_reclaim_sweep(const struct btrfs_fs_info *fs_info)
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

