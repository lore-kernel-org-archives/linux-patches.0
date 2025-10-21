Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520E0274B35;
	Tue, 21 Oct 2025 20:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077202; cv=none; b=RmZF344nzP4Tl5ytBTkObAS7LNivySUmJS8sK9PU20MosHd/+8r+CetTuckdDQVzHviEqrnmGGC+oPiQVa+sl2k/NODYBVc6UeRzs8L6px7KzQPvGR02gByE+kYCoz9aW+pXYEPpx/oGyPuq4uvTOioiWW/BSPdPPRlhamG7Muw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077202; c=relaxed/simple;
	bh=TVopHLc2naASHkIQidkn0PjcMdMkQLYSxgIcBC/Pggw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wtbpg0TnPw1IzTCD+vfQ2uwSzGbl/+gL+qkMsCS5rjGjJzjY92RrlPhCFDpx8qwlVHAGyeM/RjCmOFKS0jHX5IpGLnyqdEKRdU4O1M150osF7zQRB9C5uv/mCbGIYF6Y+tVdRpiGEVB7RNl0X/MWheZgPabVd2qLPjwBTcQXxDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUhBtBLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUhBtBLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D322C4CEF1;
	Tue, 21 Oct 2025 20:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077201;
	bh=TVopHLc2naASHkIQidkn0PjcMdMkQLYSxgIcBC/Pggw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUhBtBLT31uQzDoPXwGu0LAY6a0hxT9QxkseIkXpPRaNwLleNLjFRdY7O6IHqvJAb
	 gD7N2aIkdQSi6oTD84x71523gtzF39kvdEz+CQ83WeQGTzrUgXjeQdfxiUdS5oVm2H
	 8o15LJJIBmFhDsf2f1hg4GEJZzEIGAb3uPiMd3zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+884dc4621377ba579a6f@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 030/159] btrfs: do not assert we found block group item when creating free space tree
Date: Tue, 21 Oct 2025 21:50:07 +0200
Message-ID: <20251021195043.920595768@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit a5a51bf4e9b7354ce7cd697e610d72c1b33fd949 upstream.

Currently, when building a free space tree at populate_free_space_tree(),
if we are not using the block group tree feature, we always expect to find
block group items (either extent items or a block group item with key type
BTRFS_BLOCK_GROUP_ITEM_KEY) when we search the extent tree with
btrfs_search_slot_for_read(), so we assert that we found an item. However
this expectation is wrong since we can have a new block group created in
the current transaction which is still empty and for which we still have
not added the block group's item to the extent tree, in which case we do
not have any items in the extent tree associated to the block group.

The insertion of a new block group's block group item in the extent tree
happens at btrfs_create_pending_block_groups() when it calls the helper
insert_block_group_item(). This typically is done when a transaction
handle is released, committed or when running delayed refs (either as
part of a transaction commit or when serving tickets for space reservation
if we are low on free space).

So remove the assertion at populate_free_space_tree() even when the block
group tree feature is not enabled and update the comment to mention this
case.

Syzbot reported this with the following stack trace:

  BTRFS info (device loop3 state M): rebuilding free space tree
  assertion failed: ret == 0 :: 0, in fs/btrfs/free-space-tree.c:1115
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/free-space-tree.c:1115!
  Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
  CPU: 1 UID: 0 PID: 6352 Comm: syz.3.25 Not tainted syzkaller #0 PREEMPT(full)
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
  RIP: 0010:populate_free_space_tree+0x700/0x710 fs/btrfs/free-space-tree.c:1115
  Code: ff ff e8 d3 (...)
  RSP: 0018:ffffc9000430f780 EFLAGS: 00010246
  RAX: 0000000000000043 RBX: ffff88805b709630 RCX: fea61d0e2e79d000
  RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
  RBP: ffffc9000430f8b0 R08: ffffc9000430f4a7 R09: 1ffff92000861e94
  R10: dffffc0000000000 R11: fffff52000861e95 R12: 0000000000000001
  R13: 1ffff92000861f00 R14: dffffc0000000000 R15: 0000000000000000
  FS:  00007f424d9fe6c0(0000) GS:ffff888125afc000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fd78ad212c0 CR3: 0000000076d68000 CR4: 00000000003526f0
  Call Trace:
   <TASK>
   btrfs_rebuild_free_space_tree+0x1ba/0x6d0 fs/btrfs/free-space-tree.c:1364
   btrfs_start_pre_rw_mount+0x128f/0x1bf0 fs/btrfs/disk-io.c:3062
   btrfs_remount_rw fs/btrfs/super.c:1334 [inline]
   btrfs_reconfigure+0xaed/0x2160 fs/btrfs/super.c:1559
   reconfigure_super+0x227/0x890 fs/super.c:1076
   do_remount fs/namespace.c:3279 [inline]
   path_mount+0xd1a/0xfe0 fs/namespace.c:4027
   do_mount fs/namespace.c:4048 [inline]
   __do_sys_mount fs/namespace.c:4236 [inline]
   __se_sys_mount+0x313/0x410 fs/namespace.c:4213
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   RIP: 0033:0x7f424e39066a
  Code: d8 64 89 02 (...)
  RSP: 002b:00007f424d9fde68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
  RAX: ffffffffffffffda RBX: 00007f424d9fdef0 RCX: 00007f424e39066a
  RDX: 0000200000000180 RSI: 0000200000000380 RDI: 0000000000000000
  RBP: 0000200000000180 R08: 00007f424d9fdef0 R09: 0000000000000020
  R10: 0000000000000020 R11: 0000000000000246 R12: 0000200000000380
  R13: 00007f424d9fdeb0 R14: 0000000000000000 R15: 00002000000002c0
   </TASK>
  Modules linked in:
  ---[ end trace 0000000000000000 ]---

Reported-by: syzbot+884dc4621377ba579a6f@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/68dc3dab.a00a0220.102ee.004e.GAE@google.com/
Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
CC: <stable@vger.kernel.org> # 6.1.x: 1961d20f6fa8: btrfs: fix assertion when building free space tree
CC: <stable@vger.kernel.org> # 6.1.x
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-tree.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1106,14 +1106,15 @@ static int populate_free_space_tree(stru
 	 * If ret is 1 (no key found), it means this is an empty block group,
 	 * without any extents allocated from it and there's no block group
 	 * item (key BTRFS_BLOCK_GROUP_ITEM_KEY) located in the extent tree
-	 * because we are using the block group tree feature, so block group
-	 * items are stored in the block group tree. It also means there are no
-	 * extents allocated for block groups with a start offset beyond this
-	 * block group's end offset (this is the last, highest, block group).
+	 * because we are using the block group tree feature (so block group
+	 * items are stored in the block group tree) or this is a new block
+	 * group created in the current transaction and its block group item
+	 * was not yet inserted in the extent tree (that happens in
+	 * btrfs_create_pending_block_groups() -> insert_block_group_item()).
+	 * It also means there are no extents allocated for block groups with a
+	 * start offset beyond this block group's end offset (this is the last,
+	 * highest, block group).
 	 */
-	if (!btrfs_fs_compat_ro(trans->fs_info, BLOCK_GROUP_TREE))
-		ASSERT(ret == 0);
-
 	start = block_group->start;
 	end = block_group->start + block_group->length;
 	while (ret == 0) {


