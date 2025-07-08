Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDF21E492;
	Tue,  8 Jul 2025 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994013; cv=none; b=IsuCda7+2+lnGDq+O/LVd6a5CU2AXH+ah99omOWCPHzKT+fHscRWaCYb8DPPLja+xtgOMWZ7GWrJkKPl9az/t2o595qo6hZF2v+S2GlprEEFD3gGSq9BvBcf4pqHp66B0GGB4N/8ebgTsyNEeEhsLSRJY2J5fp9gptBBO8rShf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994013; c=relaxed/simple;
	bh=G6yjQU0QRbqifDc4TYWur3blJ3lBmDezKUv1Ys0MYpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtrvRh6idqTq9RqtOocAT4O65ISsyNOUbYN5tpBShIw7K6IsSFVTVFO5z20tDZcP208YPLheJNbRsB3WqG+bOWf0WPKQ0jZoUeNSquqirhrE2Ab1SiczRLbD+s+xFMTzYoE5KOUs1IMxYqMMzrNKqZC/ahzzy8WRmZ+sqPjfezM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ7sHYa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ7sHYa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF8DC4CEF0;
	Tue,  8 Jul 2025 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994013;
	bh=G6yjQU0QRbqifDc4TYWur3blJ3lBmDezKUv1Ys0MYpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQ7sHYa1hzFHJYMQ93CZWbJn4ssh/Vrwl6O8IDXyOPZU7+LbiXuWiV4hzpQb50RZd
	 N7upRgwSGcaXEYHGI7k4waPfrViVnHRy6sP8Wv/2bzMFWt9f9VsIdQzVbpJfWalzvV
	 AORcD7UeHIBVSOfvVsptnzkkCzanuPFWA6/RlRT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Larry Bassel <larry.bassel@oracle.com>
Subject: [PATCH 5.15 095/160] btrfs: dont drop extent_map for free space inode on write error
Date: Tue,  8 Jul 2025 18:22:12 +0200
Message-ID: <20250708162234.133561100@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 5571e41ec6e56e35f34ae9f5b3a335ef510e0ade upstream.

While running the CI for an unrelated change I hit the following panic
with generic/648 on btrfs_holes_spacecache.

assertion failed: block_start != EXTENT_MAP_HOLE, in fs/btrfs/extent_io.c:1385
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:1385!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 1 PID: 2695096 Comm: fsstress Kdump: loaded Tainted: G        W          6.8.0-rc2+ #1
RIP: 0010:__extent_writepage_io.constprop.0+0x4c1/0x5c0
Call Trace:
 <TASK>
 extent_write_cache_pages+0x2ac/0x8f0
 extent_writepages+0x87/0x110
 do_writepages+0xd5/0x1f0
 filemap_fdatawrite_wbc+0x63/0x90
 __filemap_fdatawrite_range+0x5c/0x80
 btrfs_fdatawrite_range+0x1f/0x50
 btrfs_write_out_cache+0x507/0x560
 btrfs_write_dirty_block_groups+0x32a/0x420
 commit_cowonly_roots+0x21b/0x290
 btrfs_commit_transaction+0x813/0x1360
 btrfs_sync_file+0x51a/0x640
 __x64_sys_fdatasync+0x52/0x90
 do_syscall_64+0x9c/0x190
 entry_SYSCALL_64_after_hwframe+0x6e/0x76

This happens because we fail to write out the free space cache in one
instance, come back around and attempt to write it again.  However on
the second pass through we go to call btrfs_get_extent() on the inode to
get the extent mapping.  Because this is a new block group, and with the
free space inode we always search the commit root to avoid deadlocking
with the tree, we find nothing and return a EXTENT_MAP_HOLE for the
requested range.

This happens because the first time we try to write the space cache out
we hit an error, and on an error we drop the extent mapping.  This is
normal for normal files, but the free space cache inode is special.  We
always expect the extent map to be correct.  Thus the second time
through we end up with a bogus extent map.

Since we're deprecating this feature, the most straightforward way to
fix this is to simply skip dropping the extent map range for this failed
range.

I shortened the test by using error injection to stress the area to make
it easier to reproduce.  With this patch in place we no longer panic
with my error injection test.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ Larry: backport to 5.15.y. Minor conflict resolved due to missing commit 4c0c8cfc8433
  btrfs: move btrfs_drop_extent_cache() to extent_map.c ]
Signed-off-by: Larry Bassel <larry.bassel@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3197,8 +3197,23 @@ out:
 			unwritten_start += logical_len;
 		clear_extent_uptodate(io_tree, unwritten_start, end, NULL);
 
-		/* Drop the cache for the part of the extent we didn't write. */
-		btrfs_drop_extent_cache(inode, unwritten_start, end, 0);
+		/*
+		 * Drop extent maps for the part of the extent we didn't write.
+		 *
+		 * We have an exception here for the free_space_inode, this is
+		 * because when we do btrfs_get_extent() on the free space inode
+		 * we will search the commit root.  If this is a new block group
+		 * we won't find anything, and we will trip over the assert in
+		 * writepage where we do ASSERT(em->block_start !=
+		 * EXTENT_MAP_HOLE).
+		 *
+		 * Theoretically we could also skip this for any NOCOW extent as
+		 * we don't mess with the extent map tree in the NOCOW case, but
+		 * for now simply skip this if we are the free space inode.
+		 */
+		if (!btrfs_is_free_space_inode(inode))
+			btrfs_drop_extent_cache(inode, unwritten_start,
+						    end, 0);
 
 		/*
 		 * If the ordered extent had an IOERR or something else went


