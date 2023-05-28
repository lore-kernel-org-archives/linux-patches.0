Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4C9611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1853CC433D2;
	Sun, 28 May 2023 19:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301640;
	bh=YIYuWSkVrx5HTq1PSTXsDmqNNAItd/pyfszMtfdaa6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KznGpwgltFTc2t2vOXrxtAXWlSwwHzYuAPCwpIPwFKlFr5XJvXG5z6iB8nqCxaH8M
	 nSE1r2UMFV8GBv2o1rdAKF3qeJWJDGv5HzvOycfxHBUbBDGTislZp5kBV9TQkTVBb1
	 g0CZnSs7GePEJ3AQ4TA1u33i1+yBd5IJymAV3r3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 109/132] btrfs: use nofs when cleaning up aborted transactions
Date: Sun, 28 May 2023 20:10:48 +0100
Message-Id: <20230528190837.087328186@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josef Bacik <josef@toxicpanda.com>

commit 597441b3436a43011f31ce71dc0a6c0bf5ce958a upstream.

Our CI system caught a lockdep splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  6.3.0-rc7+ #1167 Not tainted
  ------------------------------------------------------
  kswapd0/46 is trying to acquire lock:
  ffff8c6543abd650 (sb_internal#2){++++}-{0:0}, at: btrfs_commit_inode_delayed_inode+0x5f/0x120

  but task is already holding lock:
  ffffffffabe61b40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x4aa/0x7a0

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (fs_reclaim){+.+.}-{0:0}:
	 fs_reclaim_acquire+0xa5/0xe0
	 kmem_cache_alloc+0x31/0x2c0
	 alloc_extent_state+0x1d/0xd0
	 __clear_extent_bit+0x2e0/0x4f0
	 try_release_extent_mapping+0x216/0x280
	 btrfs_release_folio+0x2e/0x90
	 invalidate_inode_pages2_range+0x397/0x470
	 btrfs_cleanup_dirty_bgs+0x9e/0x210
	 btrfs_cleanup_one_transaction+0x22/0x760
	 btrfs_commit_transaction+0x3b7/0x13a0
	 create_subvol+0x59b/0x970
	 btrfs_mksubvol+0x435/0x4f0
	 __btrfs_ioctl_snap_create+0x11e/0x1b0
	 btrfs_ioctl_snap_create_v2+0xbf/0x140
	 btrfs_ioctl+0xa45/0x28f0
	 __x64_sys_ioctl+0x88/0xc0
	 do_syscall_64+0x38/0x90
	 entry_SYSCALL_64_after_hwframe+0x72/0xdc

  -> #0 (sb_internal#2){++++}-{0:0}:
	 __lock_acquire+0x1435/0x21a0
	 lock_acquire+0xc2/0x2b0
	 start_transaction+0x401/0x730
	 btrfs_commit_inode_delayed_inode+0x5f/0x120
	 btrfs_evict_inode+0x292/0x3d0
	 evict+0xcc/0x1d0
	 inode_lru_isolate+0x14d/0x1e0
	 __list_lru_walk_one+0xbe/0x1c0
	 list_lru_walk_one+0x58/0x80
	 prune_icache_sb+0x39/0x60
	 super_cache_scan+0x161/0x1f0
	 do_shrink_slab+0x163/0x340
	 shrink_slab+0x1d3/0x290
	 shrink_node+0x300/0x720
	 balance_pgdat+0x35c/0x7a0
	 kswapd+0x205/0x410
	 kthread+0xf0/0x120
	 ret_from_fork+0x29/0x50

  other info that might help us debug this:

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(fs_reclaim);
				 lock(sb_internal#2);
				 lock(fs_reclaim);
    lock(sb_internal#2);

   *** DEADLOCK ***

  3 locks held by kswapd0/46:
   #0: ffffffffabe61b40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x4aa/0x7a0
   #1: ffffffffabe50270 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x113/0x290
   #2: ffff8c6543abd0e0 (&type->s_umount_key#44){++++}-{3:3}, at: super_cache_scan+0x38/0x1f0

  stack backtrace:
  CPU: 0 PID: 46 Comm: kswapd0 Not tainted 6.3.0-rc7+ #1167
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x58/0x90
   check_noncircular+0xd6/0x100
   ? save_trace+0x3f/0x310
   ? add_lock_to_list+0x97/0x120
   __lock_acquire+0x1435/0x21a0
   lock_acquire+0xc2/0x2b0
   ? btrfs_commit_inode_delayed_inode+0x5f/0x120
   start_transaction+0x401/0x730
   ? btrfs_commit_inode_delayed_inode+0x5f/0x120
   btrfs_commit_inode_delayed_inode+0x5f/0x120
   btrfs_evict_inode+0x292/0x3d0
   ? lock_release+0x134/0x270
   ? __pfx_wake_bit_function+0x10/0x10
   evict+0xcc/0x1d0
   inode_lru_isolate+0x14d/0x1e0
   __list_lru_walk_one+0xbe/0x1c0
   ? __pfx_inode_lru_isolate+0x10/0x10
   ? __pfx_inode_lru_isolate+0x10/0x10
   list_lru_walk_one+0x58/0x80
   prune_icache_sb+0x39/0x60
   super_cache_scan+0x161/0x1f0
   do_shrink_slab+0x163/0x340
   shrink_slab+0x1d3/0x290
   shrink_node+0x300/0x720
   balance_pgdat+0x35c/0x7a0
   kswapd+0x205/0x410
   ? __pfx_autoremove_wake_function+0x10/0x10
   ? __pfx_kswapd+0x10/0x10
   kthread+0xf0/0x120
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x29/0x50
   </TASK>

This happens because when we abort the transaction in the transaction
commit path we call invalidate_inode_pages2_range on our block group
cache inodes (if we have space cache v1) and any delalloc inodes we may
have.  The plain invalidate_inode_pages2_range() call passes through
GFP_KERNEL, which makes sense in most cases, but not here.  Wrap these
two invalidate callees with memalloc_nofs_save/memalloc_nofs_restore to
make sure we don't end up with the fs reclaim dependency under the
transaction dependency.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4348,7 +4348,11 @@ static void btrfs_destroy_delalloc_inode
 		 */
 		inode = igrab(&btrfs_inode->vfs_inode);
 		if (inode) {
+			unsigned int nofs_flag;
+
+			nofs_flag = memalloc_nofs_save();
 			invalidate_inode_pages2(inode->i_mapping);
+			memalloc_nofs_restore(nofs_flag);
 			iput(inode);
 		}
 		spin_lock(&root->delalloc_lock);
@@ -4466,7 +4470,12 @@ static void btrfs_cleanup_bg_io(struct b
 
 	inode = cache->io_ctl.inode;
 	if (inode) {
+		unsigned int nofs_flag;
+
+		nofs_flag = memalloc_nofs_save();
 		invalidate_inode_pages2(inode->i_mapping);
+		memalloc_nofs_restore(nofs_flag);
+
 		BTRFS_I(inode)->generation = 0;
 		cache->io_ctl.inode = NULL;
 		iput(inode);


