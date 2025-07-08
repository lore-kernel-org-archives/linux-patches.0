Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355008F5E;
	Tue,  8 Jul 2025 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993411; cv=none; b=G/zTjOJ65L0kejBh3n87qGLMK+8eDFVduvhjUBQhD0oKpmhCAWdZdF9HhdrQgybSGvl9vyI7hwstWdKs8mfxMSyVbhA7dQEhEaXWTfpglqdevMQRn3QEAlIlVQufRL5blIzZBLUjp9ilGGRVfg6qli+7JxZownojv/y7xGEsOz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993411; c=relaxed/simple;
	bh=nO6rz5PbF/EQWqRXxzFonNWZdDW2UY2wD9nExyAZfhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7ZX4FSbQBehWRqvkUAD5hCkV7ADH8nlzDEGL6JaII7I+mWSSNsEJpSG2stBNHeDsmNh7NiC2BDx0GjYZnTIncH8shkuZGIzMvkuvOAjv5OztQv5G883EgvqqMd5Qx/o8sBTFwRYjQZIQy6+tI35tJJJw7c5+fiepHJB1yPMpDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOCyCNlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOCyCNlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F0AC4CEED;
	Tue,  8 Jul 2025 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993410;
	bh=nO6rz5PbF/EQWqRXxzFonNWZdDW2UY2wD9nExyAZfhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOCyCNlV69ru71x4BMtj0Mk16U3WgMU7Kz8N6AXbRcEnm+SXHUYVGV7HauREeld9H
	 7fYc6qCkVvHuWtpLWUiFv6lU9+/viegjrSfpek8FLnSaSkbDXnmF0MXKJR8LFq5iA+
	 H4jQ3EqpEUvWEJu8bJoYDuOF7CmzoB2rHI985ppM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d0014fb0fc39c5487ae5@syzkaller.appspotmail.com,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 064/178] btrfs: fix failure to rebuild free space tree using multiple transactions
Date: Tue,  8 Jul 2025 18:21:41 +0200
Message-ID: <20250708162238.349107127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1e6ed33cabba8f06f532f2e5851a102602823734 ]

If we are rebuilding a free space tree, while modifying the free space
tree we may need to allocate a new metadata block group.
If we end up using multiple transactions for the rebuild, when we call
btrfs_end_transaction() we enter btrfs_create_pending_block_groups()
which calls add_block_group_free_space() to add items to the free space
tree for the block group.

Then later during the free space tree rebuild, at
btrfs_rebuild_free_space_tree(), we may find such new block groups
and call populate_free_space_tree() for them, which fails with -EEXIST
because there are already items in the free space tree. Then we abort the
transaction with -EEXIST at btrfs_rebuild_free_space_tree().
Notice that we say "may find" the new block groups because a new block
group may be inserted in the block groups rbtree, which is being iterated
by the rebuild process, before or after the current node where the rebuild
process is currently at.

Syzbot recently reported such case which produces a trace like the
following:

  ------------[ cut here ]------------
  BTRFS: Transaction aborted (error -17)
  WARNING: CPU: 1 PID: 7626 at fs/btrfs/free-space-tree.c:1341 btrfs_rebuild_free_space_tree+0x470/0x54c fs/btrfs/free-space-tree.c:1341
  Modules linked in:
  CPU: 1 UID: 0 PID: 7626 Comm: syz.2.25 Not tainted 6.15.0-rc7-syzkaller-00085-gd7fa1af5b33e-dirty #0 PREEMPT
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
  pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : btrfs_rebuild_free_space_tree+0x470/0x54c fs/btrfs/free-space-tree.c:1341
  lr : btrfs_rebuild_free_space_tree+0x470/0x54c fs/btrfs/free-space-tree.c:1341
  sp : ffff80009c4f7740
  x29: ffff80009c4f77b0 x28: ffff0000d4c3f400 x27: 0000000000000000
  x26: dfff800000000000 x25: ffff70001389eee8 x24: 0000000000000003
  x23: 1fffe000182b6e7b x22: 0000000000000000 x21: ffff0000c15b73d8
  x20: 00000000ffffffef x19: ffff0000c15b7378 x18: 1fffe0003386f276
  x17: ffff80008f31e000 x16: ffff80008adbe98c x15: 0000000000000001
  x14: 1fffe0001b281550 x13: 0000000000000000 x12: 0000000000000000
  x11: ffff60001b281551 x10: 0000000000000003 x9 : 1c8922000a902c00
  x8 : 1c8922000a902c00 x7 : ffff800080485878 x6 : 0000000000000000
  x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff80008047843c
  x2 : 0000000000000001 x1 : ffff80008b3ebc40 x0 : 0000000000000001
  Call trace:
   btrfs_rebuild_free_space_tree+0x470/0x54c fs/btrfs/free-space-tree.c:1341 (P)
   btrfs_start_pre_rw_mount+0xa78/0xe10 fs/btrfs/disk-io.c:3074
   btrfs_remount_rw fs/btrfs/super.c:1319 [inline]
   btrfs_reconfigure+0x828/0x2418 fs/btrfs/super.c:1543
   reconfigure_super+0x1d4/0x6f0 fs/super.c:1083
   do_remount fs/namespace.c:3365 [inline]
   path_mount+0xb34/0xde0 fs/namespace.c:4200
   do_mount fs/namespace.c:4221 [inline]
   __do_sys_mount fs/namespace.c:4432 [inline]
   __se_sys_mount fs/namespace.c:4409 [inline]
   __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4409
   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
   invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
   el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
   do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
   el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
   el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
   el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
  irq event stamp: 330
  hardirqs last  enabled at (329): [<ffff80008048590c>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1525 [inline]
  hardirqs last  enabled at (329): [<ffff80008048590c>] finish_lock_switch+0xb0/0x1c0 kernel/sched/core.c:5130
  hardirqs last disabled at (330): [<ffff80008adb9e60>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:511
  softirqs last  enabled at (10): [<ffff8000801fbf10>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
  softirqs last disabled at (8): [<ffff8000801fbedc>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
  ---[ end trace 0000000000000000 ]---

Fix this by flagging new block groups which had their free space tree
entries already added and then skip them in the rebuild process. Also,
since the rebuild may be triggered when doing a remount, make sure that
when we clear an existing free space tree that we clear such flag from
every existing block group, otherwise we would skip those block groups
during the rebuild.

Reported-by: syzbot+d0014fb0fc39c5487ae5@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/68460a54.050a0220.daf97.0af5.GAE@google.com/
Fixes: 882af9f13e83 ("btrfs: handle free space tree rebuild in multiple transactions")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.h     |  2 ++
 fs/btrfs/free-space-tree.c | 40 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 36937eeab9b8a..08548b0b5ea1d 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -83,6 +83,8 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
 	/* Does the block group need to be added to the free space tree? */
 	BLOCK_GROUP_FLAG_NEEDS_FREE_SPACE,
+	/* Set after we add a new block group to the free space tree. */
+	BLOCK_GROUP_FLAG_FREE_SPACE_ADDED,
 	/* Indicate that the block group is placed on a sequential zone */
 	BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE,
 	/*
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 39c6b96a4c25a..b65a20fd519ba 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1217,6 +1217,7 @@ static int clear_free_space_tree(struct btrfs_trans_handle *trans,
 {
 	BTRFS_PATH_AUTO_FREE(path);
 	struct btrfs_key key;
+	struct rb_node *node;
 	int nr;
 	int ret;
 
@@ -1245,6 +1246,16 @@ static int clear_free_space_tree(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 	}
 
+	node = rb_first_cached(&trans->fs_info->block_group_cache_tree);
+	while (node) {
+		struct btrfs_block_group *bg;
+
+		bg = rb_entry(node, struct btrfs_block_group, cache_node);
+		clear_bit(BLOCK_GROUP_FLAG_FREE_SPACE_ADDED, &bg->runtime_flags);
+		node = rb_next(node);
+		cond_resched();
+	}
+
 	return 0;
 }
 
@@ -1334,12 +1345,18 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
 
 		block_group = rb_entry(node, struct btrfs_block_group,
 				       cache_node);
+
+		if (test_bit(BLOCK_GROUP_FLAG_FREE_SPACE_ADDED,
+			     &block_group->runtime_flags))
+			goto next;
+
 		ret = populate_free_space_tree(trans, block_group);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			btrfs_end_transaction(trans);
 			return ret;
 		}
+next:
 		if (btrfs_should_end_transaction(trans)) {
 			btrfs_end_transaction(trans);
 			trans = btrfs_start_transaction(free_space_root, 1);
@@ -1366,6 +1383,29 @@ static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
 
 	clear_bit(BLOCK_GROUP_FLAG_NEEDS_FREE_SPACE, &block_group->runtime_flags);
 
+	/*
+	 * While rebuilding the free space tree we may allocate new metadata
+	 * block groups while modifying the free space tree.
+	 *
+	 * Because during the rebuild (at btrfs_rebuild_free_space_tree()) we
+	 * can use multiple transactions, every time btrfs_end_transaction() is
+	 * called at btrfs_rebuild_free_space_tree() we finish the creation of
+	 * new block groups by calling btrfs_create_pending_block_groups(), and
+	 * that in turn calls us, through add_block_group_free_space(), to add
+	 * a free space info item and a free space extent item for the block
+	 * group.
+	 *
+	 * Then later btrfs_rebuild_free_space_tree() may find such new block
+	 * groups and processes them with populate_free_space_tree(), which can
+	 * fail with EEXIST since there are already items for the block group in
+	 * the free space tree. Notice that we say "may find" because a new
+	 * block group may be added to the block groups rbtree in a node before
+	 * or after the block group currently being processed by the rebuild
+	 * process. So signal the rebuild process to skip such new block groups
+	 * if it finds them.
+	 */
+	set_bit(BLOCK_GROUP_FLAG_FREE_SPACE_ADDED, &block_group->runtime_flags);
+
 	ret = add_new_free_space_info(trans, block_group, path);
 	if (ret)
 		return ret;
-- 
2.39.5



