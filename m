Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC77E1F9F70;
	Thu, 12 Mar 2026 20:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346700; cv=none; b=ghMPfT7fNDKckRislYnNgzixBJmoK+aJ+A6p0T3elvDVyNcyB9MQBAGKe6V0ypmSndu3BCwsZB/Khvqk5ighP4sIA6oD5ebT1RuX83cCm9rvQlPWZFxnPbdpxGMwvtdXrlR8kWgKavizUsM9xc6ogUKCQf8bSerBJ2sV4FCMnL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346700; c=relaxed/simple;
	bh=W03EoJd6lTazuM+h7LlHcPEx+9Jsx00arJeLeO2WUI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVOuLA+DvKeYAa/7szyu5xkBOhC4/faoh4DgpFCzx49Cy7PWRu2etzemeQ81mcAH/9NQjdUgC9xqOhW+IIyyKuoedhZ+reEjleX+JPO16wDD/603LjRX1ifrg6G/0ifXRuOfdgbebpuhpJCuaXREX0fxgqIqlzMr9/LFf6V3+RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSulVKdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSulVKdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7F0C4CEF7;
	Thu, 12 Mar 2026 20:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346699;
	bh=W03EoJd6lTazuM+h7LlHcPEx+9Jsx00arJeLeO2WUI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSulVKdcAO3WjarOCZnWolT2qSS+NpSnNLUTpfNGxGp0NQnJ2H52814WdOoMd0/mU
	 8Z4F9HWh3fz9mZcES6dcTZWjGUe3PXXdeIJb3W/qLSXhQI4ugL1rQ2vjIAe3ih9jns
	 5zjDmQFzDXIfM4/b9HbLvYuAlalaXuanIZfhR8l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/265] btrfs: fix reclaimed bytes accounting after automatic block group reclaim
Date: Thu, 12 Mar 2026 21:08:09 +0100
Message-ID: <20260312201021.914107878@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 620768704326c9a71ea9c8324ffda8748d8d4f10 ]

We are considering the used bytes counter of a block group as the amount
to update the space info's reclaim bytes counter after relocating the
block group, but this value alone is often not enough. This is because we
may have a reserved extent (or more) and in that case its size is
reflected in the reserved counter of the block group - the size of the
extent is only transferred from the reserved counter to the used counter
of the block group when the delayed ref for the extent is run - typically
when committing the transaction (or when flushing delayed refs due to
ENOSPC on space reservation). Such call chain for data extents is:

   btrfs_run_delayed_refs_for_head()
       run_one_delayed_ref()
           run_delayed_data_ref()
               alloc_reserved_file_extent()
                   alloc_reserved_extent()
                       btrfs_update_block_group()
                          -> transfers the extent size from the reserved
                             counter to the used counter

For metadata extents:

   btrfs_run_delayed_refs_for_head()
       run_one_delayed_ref()
           run_delayed_tree_ref()
               alloc_reserved_tree_block()
                   alloc_reserved_extent()
                       btrfs_update_block_group()
                           -> transfers the extent size from the reserved
                              counter to the used counter

Since relocation flushes delalloc, waits for ordered extent completion
and commits the current transaction before doing the actual relocation
work, the correct amount of reclaimed space is therefore the sum of the
"used" and "reserved" counters of the block group before we call
btrfs_relocate_chunk() at btrfs_reclaim_bgs_work().

So fix this by taking the "reserved" counter into consideration.

Fixes: 243192b67649 ("btrfs: report reclaim stats in sysfs")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 19eff93dc738 ("btrfs: fix periodic reclaim condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 2316be6ee41db..a29dc0a15d128 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1878,6 +1878,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 	while (!list_empty(&fs_info->reclaim_bgs)) {
 		u64 zone_unusable;
 		u64 used;
+		u64 reserved;
 		int ret = 0;
 
 		bg = list_first_entry(&fs_info->reclaim_bgs,
@@ -1974,21 +1975,32 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 			goto next;
 
 		/*
-		 * Grab the used bytes counter while holding the block group's
-		 * spinlock to prevent races with tasks concurrently updating it
-		 * due to extent allocation and deallocation (running
-		 * btrfs_update_block_group()) - we have set the block group to
-		 * RO but that only prevents extent reservation, allocation
-		 * happens after reservation.
+		 * The amount of bytes reclaimed corresponds to the sum of the
+		 * "used" and "reserved" counters. We have set the block group
+		 * to RO above, which prevents reservations from happening but
+		 * we may have existing reservations for which allocation has
+		 * not yet been done - btrfs_update_block_group() was not yet
+		 * called, which is where we will transfer a reserved extent's
+		 * size from the "reserved" counter to the "used" counter - this
+		 * happens when running delayed references. When we relocate the
+		 * chunk below, relocation first flushes dellaloc, waits for
+		 * ordered extent completion (which is where we create delayed
+		 * references for data extents) and commits the current
+		 * transaction (which runs delayed references), and only after
+		 * it does the actual work to move extents out of the block
+		 * group. So the reported amount of reclaimed bytes is
+		 * effectively the sum of the 'used' and 'reserved' counters.
 		 */
 		spin_lock(&bg->lock);
 		used = bg->used;
+		reserved = bg->reserved;
 		spin_unlock(&bg->lock);
 
 		btrfs_info(fs_info,
-			"reclaiming chunk %llu with %llu%% used %llu%% unusable",
+	"reclaiming chunk %llu with %llu%% used %llu%% reserved %llu%% unusable",
 				bg->start,
 				div64_u64(used * 100, bg->length),
+				div64_u64(reserved * 100, bg->length),
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
@@ -1997,6 +2009,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 			btrfs_err(fs_info, "error relocating chunk %llu",
 				  bg->start);
 			used = 0;
+			reserved = 0;
 			spin_lock(&space_info->lock);
 			space_info->reclaim_errors++;
 			if (READ_ONCE(space_info->periodic_reclaim))
@@ -2006,6 +2019,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 		spin_lock(&space_info->lock);
 		space_info->reclaim_count++;
 		space_info->reclaim_bytes += used;
+		space_info->reclaim_bytes += reserved;
 		spin_unlock(&space_info->lock);
 
 next:
-- 
2.51.0



