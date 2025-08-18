Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383FD27A44A;
	Mon, 18 Aug 2025 13:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522762; cv=none; b=YPDZqIJ6Q2QC5LVhzp5NvtnaEOoD+2DzVM2hFuj3FkyK+rFySo4WqPxzvQ2rnwzXE8dir4uMeqdPlWxMY+w+r6DrZCdbKg9zKsqzsZ3sIAD7AJGb2vfnvRfWLMJibw6nbUbvgCaRGYzE9CdFKsA/pX5T1jTqcqbDyBE/evtHeSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522762; c=relaxed/simple;
	bh=XNwvBO41ujcDSFx/8F5o7hW1FT2lp71DuDA/Wo6NfLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7lOCjbwdVc8vk+ZSGPJE2IdKFsTtika5mpX8TiZDz6qvBvMPLRtjl8f/UyOHPi9xzfGIec7YmDvLVf1TxU0Eejp4SNgUgNoj5pT53mBWNcIJKj/BQuFmUT7UzYgb9GNqxqJHXZMDNLcuOfYupi787+6EuqQpqQXpRhGQIi0VDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/bzRsV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/bzRsV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEB9C4CEEB;
	Mon, 18 Aug 2025 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522761;
	bh=XNwvBO41ujcDSFx/8F5o7hW1FT2lp71DuDA/Wo6NfLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/bzRsV0JzWf5yCxemSUK2mhp1tyFy7bM64KjMh+ukjwc3t/pKU8fvFuXKcIF59MC
	 XPrXxJjHIgK8JDFySDCwKppgmq3WqAE1p7Aj4xtZBAUnBcoLbj+QAAH8OJjrFzO4VD
	 WSIgBvHq2Gt9HZi6sXR4pdTJQGeYpMP4d/ds7Hwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>
Subject: [PATCH 6.12 396/444] btrfs: fix ssd_spread overallocation
Date: Mon, 18 Aug 2025 14:47:02 +0200
Message-ID: <20250818124503.768639292@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 807d9023e75fc20bfd6dd2ac0408ce4af53f1648 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3654,6 +3654,21 @@ btrfs_release_block_group(struct btrfs_b
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
@@ -3675,7 +3690,8 @@ static int find_free_extent_clustered(st
 	if (!cluster_bg)
 		goto refill_cluster;
 	if (cluster_bg != bg && (cluster_bg->ro ||
-	    !block_group_bits(cluster_bg, ffe_ctl->flags)))
+	    !block_group_bits(cluster_bg, ffe_ctl->flags) ||
+	    !find_free_extent_check_size_class(ffe_ctl, cluster_bg)))
 		goto release_cluster;
 
 	offset = btrfs_alloc_from_cluster(cluster_bg, last_ptr,
@@ -4231,21 +4247,6 @@ static int find_free_extent_update_loop(
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


