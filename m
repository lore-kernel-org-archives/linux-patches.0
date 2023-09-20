Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A81168A9
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF16C433C8;
	Wed, 20 Sep 2023 12:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214055;
	bh=Kn4ZZQtZ0HWfu4rEvFTo5+2DoVExhlzyE/pOv/FWp8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGIrWoZul/XD4/yBXiHvxt/4TPucUtI/p4we8CcRFq32Ub8Ohk14d+JB0iqd5ZPYb
	 xIoX7mL1C4vSaC2XsmkyBuo4lE80M3zbjxgFELZcoHefsJaQ6aZMaDT/F2dKtSFtV2
	 Bzscphg/lnVhjt/ICZVI49SbOHWpjfF5n55+lQ+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bf66ad948981797d2f1d@syzkaller.appspotmail.com,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 096/110] btrfs: release path before inode lookup during the ino lookup ioctl
Date: Wed, 20 Sep 2023 13:32:34 +0200
Message-ID: <20230920112834.028690646@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit ee34a82e890a7babb5585daf1a6dd7d4d1cf142a upstream.

During the ino lookup ioctl we can end up calling btrfs_iget() to get an
inode reference while we are holding on a root's btree. If btrfs_iget()
needs to lookup the inode from the root's btree, because it's not
currently loaded in memory, then it will need to lock another or the
same path in the same root btree. This may result in a deadlock and
trigger the following lockdep splat:

  WARNING: possible circular locking dependency detected
  6.5.0-rc7-syzkaller-00004-gf7757129e3de #0 Not tainted
  ------------------------------------------------------
  syz-executor277/5012 is trying to acquire lock:
  ffff88802df41710 (btrfs-tree-01){++++}-{3:3}, at: __btrfs_tree_read_lock+0x2f/0x220 fs/btrfs/locking.c:136

  but task is already holding lock:
  ffff88802df418e8 (btrfs-tree-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x2f/0x220 fs/btrfs/locking.c:136

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (btrfs-tree-00){++++}-{3:3}:
         down_read_nested+0x49/0x2f0 kernel/locking/rwsem.c:1645
         __btrfs_tree_read_lock+0x2f/0x220 fs/btrfs/locking.c:136
         btrfs_search_slot+0x13a4/0x2f80 fs/btrfs/ctree.c:2302
         btrfs_init_root_free_objectid+0x148/0x320 fs/btrfs/disk-io.c:4955
         btrfs_init_fs_root fs/btrfs/disk-io.c:1128 [inline]
         btrfs_get_root_ref+0x5ae/0xae0 fs/btrfs/disk-io.c:1338
         btrfs_get_fs_root fs/btrfs/disk-io.c:1390 [inline]
         open_ctree+0x29c8/0x3030 fs/btrfs/disk-io.c:3494
         btrfs_fill_super+0x1c7/0x2f0 fs/btrfs/super.c:1154
         btrfs_mount_root+0x7e0/0x910 fs/btrfs/super.c:1519
         legacy_get_tree+0xef/0x190 fs/fs_context.c:611
         vfs_get_tree+0x8c/0x270 fs/super.c:1519
         fc_mount fs/namespace.c:1112 [inline]
         vfs_kern_mount+0xbc/0x150 fs/namespace.c:1142
         btrfs_mount+0x39f/0xb50 fs/btrfs/super.c:1579
         legacy_get_tree+0xef/0x190 fs/fs_context.c:611
         vfs_get_tree+0x8c/0x270 fs/super.c:1519
         do_new_mount+0x28f/0xae0 fs/namespace.c:3335
         do_mount fs/namespace.c:3675 [inline]
         __do_sys_mount fs/namespace.c:3884 [inline]
         __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3861
         do_syscall_x64 arch/x86/entry/common.c:50 [inline]
         do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
         entry_SYSCALL_64_after_hwframe+0x63/0xcd

  -> #0 (btrfs-tree-01){++++}-{3:3}:
         check_prev_add kernel/locking/lockdep.c:3142 [inline]
         check_prevs_add kernel/locking/lockdep.c:3261 [inline]
         validate_chain kernel/locking/lockdep.c:3876 [inline]
         __lock_acquire+0x39ff/0x7f70 kernel/locking/lockdep.c:5144
         lock_acquire+0x1e3/0x520 kernel/locking/lockdep.c:5761
         down_read_nested+0x49/0x2f0 kernel/locking/rwsem.c:1645
         __btrfs_tree_read_lock+0x2f/0x220 fs/btrfs/locking.c:136
         btrfs_tree_read_lock fs/btrfs/locking.c:142 [inline]
         btrfs_read_lock_root_node+0x292/0x3c0 fs/btrfs/locking.c:281
         btrfs_search_slot_get_root fs/btrfs/ctree.c:1832 [inline]
         btrfs_search_slot+0x4ff/0x2f80 fs/btrfs/ctree.c:2154
         btrfs_lookup_inode+0xdc/0x480 fs/btrfs/inode-item.c:412
         btrfs_read_locked_inode fs/btrfs/inode.c:3892 [inline]
         btrfs_iget_path+0x2d9/0x1520 fs/btrfs/inode.c:5716
         btrfs_search_path_in_tree_user fs/btrfs/ioctl.c:1961 [inline]
         btrfs_ioctl_ino_lookup_user+0x77a/0xf50 fs/btrfs/ioctl.c:2105
         btrfs_ioctl+0xb0b/0xd40 fs/btrfs/ioctl.c:4683
         vfs_ioctl fs/ioctl.c:51 [inline]
         __do_sys_ioctl fs/ioctl.c:870 [inline]
         __se_sys_ioctl+0xf8/0x170 fs/ioctl.c:856
         do_syscall_x64 arch/x86/entry/common.c:50 [inline]
         do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
         entry_SYSCALL_64_after_hwframe+0x63/0xcd

  other info that might help us debug this:

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    rlock(btrfs-tree-00);
                                 lock(btrfs-tree-01);
                                 lock(btrfs-tree-00);
    rlock(btrfs-tree-01);

   *** DEADLOCK ***

  1 lock held by syz-executor277/5012:
   #0: ffff88802df418e8 (btrfs-tree-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x2f/0x220 fs/btrfs/locking.c:136

  stack backtrace:
  CPU: 1 PID: 5012 Comm: syz-executor277 Not tainted 6.5.0-rc7-syzkaller-00004-gf7757129e3de #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023
  Call Trace:
   <TASK>
   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
   check_noncircular+0x375/0x4a0 kernel/locking/lockdep.c:2195
   check_prev_add kernel/locking/lockdep.c:3142 [inline]
   check_prevs_add kernel/locking/lockdep.c:3261 [inline]
   validate_chain kernel/locking/lockdep.c:3876 [inline]
   __lock_acquire+0x39ff/0x7f70 kernel/locking/lockdep.c:5144
   lock_acquire+0x1e3/0x520 kernel/locking/lockdep.c:5761
   down_read_nested+0x49/0x2f0 kernel/locking/rwsem.c:1645
   __btrfs_tree_read_lock+0x2f/0x220 fs/btrfs/locking.c:136
   btrfs_tree_read_lock fs/btrfs/locking.c:142 [inline]
   btrfs_read_lock_root_node+0x292/0x3c0 fs/btrfs/locking.c:281
   btrfs_search_slot_get_root fs/btrfs/ctree.c:1832 [inline]
   btrfs_search_slot+0x4ff/0x2f80 fs/btrfs/ctree.c:2154
   btrfs_lookup_inode+0xdc/0x480 fs/btrfs/inode-item.c:412
   btrfs_read_locked_inode fs/btrfs/inode.c:3892 [inline]
   btrfs_iget_path+0x2d9/0x1520 fs/btrfs/inode.c:5716
   btrfs_search_path_in_tree_user fs/btrfs/ioctl.c:1961 [inline]
   btrfs_ioctl_ino_lookup_user+0x77a/0xf50 fs/btrfs/ioctl.c:2105
   btrfs_ioctl+0xb0b/0xd40 fs/btrfs/ioctl.c:4683
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:870 [inline]
   __se_sys_ioctl+0xf8/0x170 fs/ioctl.c:856
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
  RIP: 0033:0x7f0bec94ea39

Fix this simply by releasing the path before calling btrfs_iget() as at
point we don't need the path anymore.

Reported-by: syzbot+bf66ad948981797d2f1d@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/00000000000045fa140603c4a969@google.com/
Fixes: 23d0b79dfaed ("btrfs: Add unprivileged version of ino_lookup ioctl")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2526,6 +2526,13 @@ static int btrfs_search_path_in_tree_use
 				goto out_put;
 			}
 
+			/*
+			 * We don't need the path anymore, so release it and
+			 * avoid deadlocks and lockdep warnings in case
+			 * btrfs_iget() needs to lookup the inode from its root
+			 * btree and lock the same leaf.
+			 */
+			btrfs_release_path(path);
 			temp_inode = btrfs_iget(sb, key2.objectid, root);
 			if (IS_ERR(temp_inode)) {
 				ret = PTR_ERR(temp_inode);
@@ -2546,7 +2553,6 @@ static int btrfs_search_path_in_tree_use
 				goto out_put;
 			}
 
-			btrfs_release_path(path);
 			key.objectid = key.offset;
 			key.offset = (u64)-1;
 			dirid = key.objectid;


