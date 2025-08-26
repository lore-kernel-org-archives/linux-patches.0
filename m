Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E61223DE5;
	Tue, 26 Aug 2025 13:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213796; cv=none; b=cX9pzzO2U8GA3e+LCF+7G+ZxaTHlRiBbnMI9sCbZmaqr1vfEFggFLfH/oQfDFFtgbGrv0bqZr6dXuU/fAtprW3bHAF0tNRNmd/O+Txi2HncW5is+wj5tiKPMLqvJ6D4TipCvbqSGNJF44dqT4/JDoh/BM1x2f9ApghMLLwKQBY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213796; c=relaxed/simple;
	bh=iK4LZosbQTl8P4inROIG+0lSISg+PVe8hklX8+f4lmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs9ZtBqy5jzhwTqGNgQqNpYY9SjJgLlsYLe4xXmo5lAoQOMwxv9YmhS+jZ6/shihbmDoemA2TylVwIW1qyxLNAh6dhPj93KIjLQ3ATmvn50QJki4y9TMxRswqFTfAr68gQ8EI0su8EN/JRL2y/V84By/I69tCtjcp9dvtXm13jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqRXzXJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqRXzXJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA965C4CEF1;
	Tue, 26 Aug 2025 13:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213796;
	bh=iK4LZosbQTl8P4inROIG+0lSISg+PVe8hklX8+f4lmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqRXzXJrlc77YXnPRCetnUTlFTbvCvP1PsXXfMjIOEIfXQYBq7tcQwHOVI+lQf8A3
	 aVyZ9QvFrROqeUGvvgHxeStC9tXqsbSAW0rclc1fJLZxLgahz3Zk2MaWYc3bxOqo0D
	 CIh1ja1o4TkluBmX0vib0FUuP6VvO7NZFD7ga1xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 451/587] btrfs: fix ssd_spread overallocation
Date: Tue, 26 Aug 2025 13:10:00 +0200
Message-ID: <20250826111004.431237547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 807d9023e75fc20bfd6dd2ac0408ce4af53f1648 ]

If the ssd_spread mount option is enabled, then we run the so called
clustered allocator for data block groups. In practice, this results in
creating a btrfs_free_cluster which caches a block_group and borrows its
free extents for allocation.

Since the introduction of allocation size classes in 6.1, there has been
a bug in the interaction between that feature and ssd_spread.
find_free_extent() has a number of nested loops. The loop going over the
allocation stages, stored in ffe_ctl->loop and managed by
find_free_extent_update_loop(), the loop over the raid levels, and the
loop over all the block_groups in a space_info. The size class feature
relies on the block_group loop to ensure it gets a chance to see a
block_group of a given size class.  However, the clustered allocator
uses the cached cluster block_group and breaks that loop. Each call to
do_allocation() will really just go back to the same cached block_group.
Normally, this is OK, as the allocation either succeeds and we don't
want to loop any more or it fails, and we clear the cluster and return
its space to the block_group.

But with size classes, the allocation can succeed, then later fail,
outside of do_allocation() due to size class mismatch. That latter
failure is not properly handled due to the highly complex multi loop
logic. The result is a painful loop where we continue to allocate the
same num_bytes from the cluster in a tight loop until it fails and
releases the cluster and lets us try a new block_group. But by then, we
have skipped great swaths of the available block_groups and are likely
to fail to allocate, looping the outer loop. In pathological cases like
the reproducer below, the cached block_group is often the very last one,
in which case we don't perform this tight bg loop but instead rip
through the ffe stages to LOOP_CHUNK_ALLOC and allocate a chunk, which
is now the last one, and we enter the tight inner loop until an
allocation failure. Then allocation succeeds on the final block_group
and if the next allocation is a size mismatch, the exact same thing
happens again.

Triggering this is as easy as mounting with -o ssd_spread and then
running:

  mount -o ssd_spread $dev $mnt
  dd if=/dev/zero of=$mnt/big bs=16M count=1 &>/dev/null
  dd if=/dev/zero of=$mnt/med bs=4M count=1 &>/dev/null
  sync

if you do the two writes + sync in a loop, you can force btrfs to spin
an excessive amount on semi-successful clustered allocations, before
ultimately failing and advancing to the stage where we force a chunk
allocation. This results in 2G of data allocated per iteration, despite
only using ~20M of data. By using a small size classed extent, the inner
loop takes longer and we can spin for longer.

The simplest, shortest term fix to unbreak this is to make the clustered
allocator size_class aware in the dumbest way, where it fails on size
class mismatch. This may hinder the operation of the clustered
allocator, but better hindered than completely broken and terribly
overallocating.

Further re-design improvements are also in the works.

Fixes: 52bb7a2166af ("btrfs: introduce size class to block group allocator")
CC: stable@vger.kernel.org # 6.1+
Reported-by: David Sterba <dsterba@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3530,6 +3530,21 @@ btrfs_release_block_group(struct btrfs_b
 	btrfs_put_block_group(cache);
 }
 
+static bool find_free_extent_check_size_class(const struct find_free_extent_ctl *ffe_ctl,
+					      const struct btrfs_block_group *bg)
+{
+	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED)
+		return true;
+	if (!btrfs_block_group_should_use_size_class(bg))
+		return true;
+	if (ffe_ctl->loop >= LOOP_WRONG_SIZE_CLASS)
+		return true;
+	if (ffe_ctl->loop >= LOOP_UNSET_SIZE_CLASS &&
+	    bg->size_class == BTRFS_BG_SZ_NONE)
+		return true;
+	return ffe_ctl->size_class == bg->size_class;
+}
+
 /*
  * Helper function for find_free_extent().
  *
@@ -3551,7 +3566,8 @@ static int find_free_extent_clustered(st
 	if (!cluster_bg)
 		goto refill_cluster;
 	if (cluster_bg != bg && (cluster_bg->ro ||
-	    !block_group_bits(cluster_bg, ffe_ctl->flags)))
+	    !block_group_bits(cluster_bg, ffe_ctl->flags) ||
+	    !find_free_extent_check_size_class(ffe_ctl, cluster_bg)))
 		goto release_cluster;
 
 	offset = btrfs_alloc_from_cluster(cluster_bg, last_ptr,
@@ -4107,21 +4123,6 @@ static int find_free_extent_update_loop(
 	return -ENOSPC;
 }
 
-static bool find_free_extent_check_size_class(struct find_free_extent_ctl *ffe_ctl,
-					      struct btrfs_block_group *bg)
-{
-	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED)
-		return true;
-	if (!btrfs_block_group_should_use_size_class(bg))
-		return true;
-	if (ffe_ctl->loop >= LOOP_WRONG_SIZE_CLASS)
-		return true;
-	if (ffe_ctl->loop >= LOOP_UNSET_SIZE_CLASS &&
-	    bg->size_class == BTRFS_BG_SZ_NONE)
-		return true;
-	return ffe_ctl->size_class == bg->size_class;
-}
-
 static int prepare_allocation_clustered(struct btrfs_fs_info *fs_info,
 					struct find_free_extent_ctl *ffe_ctl,
 					struct btrfs_space_info *space_info,


