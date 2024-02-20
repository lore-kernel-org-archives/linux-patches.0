Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF087152DEF;
	Tue, 20 Feb 2024 21:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464449; cv=none; b=hCYTChJsDZY9GgwjiocBn9wMtd0m5lnJAMZ2onYkQwh5wN8cGjeOH0x2YSneq6ZRHql1/CV002EqEonzVTYzNGt72pbTCf2LxNDhVIqBKQqf+SnunZco3Ti7M1Lkso10ptVl2egeN9keg56ERLNz/sJQt2dP3p/TVnDq0wRDnQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464449; c=relaxed/simple;
	bh=z+8wLOByRzgw/DEsPyslI1d1TiA437ki8rn8F9YISQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7wie/HzGnhl4jaJUUAJYHtC3NkqS8MNnHntp5GoarWVqKCdlx7o1fTnRmR4ph75RRP/ZmwIYSg26XRfWsKB8bVhqDsWJAfwZ84GS0oEto/fsYtcVpb7pkE/DV6MMerVyduGi+ULIUBB4RPpgaEv10f6sAjZ+2vEp2PPMoA7A1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2+dskrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2+dskrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5002DC43394;
	Tue, 20 Feb 2024 21:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464448;
	bh=z+8wLOByRzgw/DEsPyslI1d1TiA437ki8rn8F9YISQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2+dskrPdEzov8WonG0zhbq3u3s/UkiWbA6a0hkVJIgqKO6bJOA5uZ4ISxs8bd3K2
	 rjybFJo6l7R29MNTWaPmb00HgspJaVuu7IwZ9jUjbrQpwAp8ctOudYqT3ZuFTQylo6
	 EwXty59vVAuh5vObgjWhWQ7k0bcWV4LcajPbZWlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 006/309] btrfs: do not delete unused block group if it may be used soon
Date: Tue, 20 Feb 2024 21:52:45 +0100
Message-ID: <20240220205633.328327926@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit f4a9f219411f318ae60d6ff7f129082a75686c6c upstream.

Before deleting a block group that is in the list of unused block groups
(fs_info->unused_bgs), we check if the block group became used before
deleting it, as extents from it may have been allocated after it was added
to the list.

However even if the block group was not yet used, there may be tasks that
have only reserved space and have not yet allocated extents, and they
might be relying on the availability of the unused block group in order
to allocate extents. The reservation works first by increasing the
"bytes_may_use" field of the corresponding space_info object (which may
first require flushing delayed items, allocating a new block group, etc),
and only later a task does the actual allocation of extents.

For metadata we usually don't end up using all reserved space, as we are
pessimistic and typically account for the worst cases (need to COW every
single node in a path of a tree at maximum possible height, etc). For
data we usually reserve the exact amount of space we're going to allocate
later, except when using compression where we always reserve space based
on the uncompressed size, as compression is only triggered when writeback
starts so we don't know in advance how much space we'll actually need, or
if the data is compressible.

So don't delete an unused block group if the total size of its space_info
object minus the block group's size is less then the sum of used space and
space that may be used (space_info->bytes_may_use), as that means we have
tasks that reserved space and may need to allocate extents from the block
group. In this case, besides skipping the deletion, re-add the block group
to the list of unused block groups so that it may be reconsidered later,
in case the tasks that reserved space end up not needing to allocate
extents from it.

Allowing the deletion of the block group while we have reserved space, can
result in tasks failing to allocate metadata extents (-ENOSPC) while under
a transaction handle, resulting in a transaction abort, or failure during
writeback for the case of data extents.

CC: stable@vger.kernel.org # 6.0+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1467,6 +1467,7 @@ out:
  */
 void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 {
+	LIST_HEAD(retry_list);
 	struct btrfs_block_group *block_group;
 	struct btrfs_space_info *space_info;
 	struct btrfs_trans_handle *trans;
@@ -1488,6 +1489,7 @@ void btrfs_delete_unused_bgs(struct btrf
 
 	spin_lock(&fs_info->unused_bgs_lock);
 	while (!list_empty(&fs_info->unused_bgs)) {
+		u64 used;
 		int trimming;
 
 		block_group = list_first_entry(&fs_info->unused_bgs,
@@ -1523,6 +1525,7 @@ void btrfs_delete_unused_bgs(struct btrf
 			goto next;
 		}
 
+		spin_lock(&space_info->lock);
 		spin_lock(&block_group->lock);
 		if (btrfs_is_block_group_used(block_group) || block_group->ro ||
 		    list_is_singular(&block_group->list)) {
@@ -1534,10 +1537,49 @@ void btrfs_delete_unused_bgs(struct btrf
 			 */
 			trace_btrfs_skip_unused_block_group(block_group);
 			spin_unlock(&block_group->lock);
+			spin_unlock(&space_info->lock);
 			up_write(&space_info->groups_sem);
 			goto next;
 		}
+
+		/*
+		 * The block group may be unused but there may be space reserved
+		 * accounting with the existence of that block group, that is,
+		 * space_info->bytes_may_use was incremented by a task but no
+		 * space was yet allocated from the block group by the task.
+		 * That space may or may not be allocated, as we are generally
+		 * pessimistic about space reservation for metadata as well as
+		 * for data when using compression (as we reserve space based on
+		 * the worst case, when data can't be compressed, and before
+		 * actually attempting compression, before starting writeback).
+		 *
+		 * So check if the total space of the space_info minus the size
+		 * of this block group is less than the used space of the
+		 * space_info - if that's the case, then it means we have tasks
+		 * that might be relying on the block group in order to allocate
+		 * extents, and add back the block group to the unused list when
+		 * we finish, so that we retry later in case no tasks ended up
+		 * needing to allocate extents from the block group.
+		 */
+		used = btrfs_space_info_used(space_info, true);
+		if (space_info->total_bytes - block_group->length < used) {
+			/*
+			 * Add a reference for the list, compensate for the ref
+			 * drop under the "next" label for the
+			 * fs_info->unused_bgs list.
+			 */
+			btrfs_get_block_group(block_group);
+			list_add_tail(&block_group->bg_list, &retry_list);
+
+			trace_btrfs_skip_unused_block_group(block_group);
+			spin_unlock(&block_group->lock);
+			spin_unlock(&space_info->lock);
+			up_write(&space_info->groups_sem);
+			goto next;
+		}
+
 		spin_unlock(&block_group->lock);
+		spin_unlock(&space_info->lock);
 
 		/* We don't want to force the issue, only flip if it's ok. */
 		ret = inc_block_group_ro(block_group, 0);
@@ -1661,12 +1703,16 @@ next:
 		btrfs_put_block_group(block_group);
 		spin_lock(&fs_info->unused_bgs_lock);
 	}
+	list_splice_tail(&retry_list, &fs_info->unused_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 	return;
 
 flip_async:
 	btrfs_end_transaction(trans);
+	spin_lock(&fs_info->unused_bgs_lock);
+	list_splice_tail(&retry_list, &fs_info->unused_bgs);
+	spin_unlock(&fs_info->unused_bgs_lock);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 	btrfs_put_block_group(block_group);
 	btrfs_discard_punt_unused_bgs_list(fs_info);


