Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F442571AC;
	Tue, 25 Mar 2025 12:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906228; cv=none; b=n9sf01wKQCkTOsD6OSdv+3Xhs34Bu9TYevpA/7FwGiHViNWl/r2gmw8+u7YWBQwoTElqzwo/qTJnn0uQ3G9rOlhHqVt5zVKu8B5FX/9JHWJX/vYtiwGee7yTBJfoLzmDNQ32msLfq2BF+u1h4HT1qcDCSeSiMsY1LO0Quk8HhcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906228; c=relaxed/simple;
	bh=tde1+79mArFYMlN0jkb6Al7nQBXPJhdz83krGpbDxDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6RpO2srXq+08TiQ+TBKGJQdRMfCbzazN3ynrz5yvK0hW8yA5us8nRAcyrMthZWkpYuWWD6zY2ikFPt9pAC5VcymBmBSjiIucRGscry+s1DtvM7x/KEemTIINEBz6xEg4dl6J/+2LCM2pHikAe+8m8CrnOht5gGTXJmDBNIyUh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdoa6bl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdoa6bl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D97C4CEEE;
	Tue, 25 Mar 2025 12:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906228;
	bh=tde1+79mArFYMlN0jkb6Al7nQBXPJhdz83krGpbDxDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdoa6bl8dIU4SXAoKrYGvWeBU7BaeWoZFCUhPQmtyO5aGEMBAlx/16xLskVQayGiA
	 hQPQ+8L1H3RZJarzx8CHuIwwS9khzcQ6riG+YCWvQ8sVBGgJfskRgN8KJXeEGXD3kf
	 FXgL3fbbYnH4BLpgPYtpWgBxnOugJfrFwMtsDX9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 73/77] btrfs: make sure that WRITTEN is set on all metadata blocks
Date: Tue, 25 Mar 2025 08:23:08 -0400
Message-ID: <20250325122146.335803761@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit e03418abde871314e1a3a550f4c8afb7b89cb273 upstream.

We previously would call btrfs_check_leaf() if we had the check
integrity code enabled, which meant that we could only run the extended
leaf checks if we had WRITTEN set on the header flags.

This leaves a gap in our checking, because we could end up with
corruption on disk where WRITTEN isn't set on the leaf, and then the
extended leaf checks don't get run which we rely on to validate all of
the item pointers to make sure we don't access memory outside of the
extent buffer.

However, since 732fab95abe2 ("btrfs: check-integrity: remove
CONFIG_BTRFS_FS_CHECK_INTEGRITY option") we no longer call
btrfs_check_leaf() from btrfs_mark_buffer_dirty(), which means we only
ever call it on blocks that are being written out, and thus have WRITTEN
set, or that are being read in, which should have WRITTEN set.

Add checks to make sure we have WRITTEN set appropriately, and then make
sure __btrfs_check_leaf() always does the item checking.  This will
protect us from file systems that have been corrupted and no longer have
WRITTEN set on some of the blocks.

This was hit on a crafted image tweaking the WRITTEN bit and reported by
KASAN as out-of-bound access in the eb accessors. The example is a dir
item at the end of an eb.

  [2.042] BTRFS warning (device loop1): bad eb member start: ptr 0x3fff start 30572544 member offset 16410 size 2
  [2.040] general protection fault, probably for non-canonical address 0xe0009d1000000003: 0000 [#1] PREEMPT SMP KASAN NOPTI
  [2.537] KASAN: maybe wild-memory-access in range [0x0005088000000018-0x000508800000001f]
  [2.729] CPU: 0 PID: 2587 Comm: mount Not tainted 6.8.2 #1
  [2.729] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  [2.621] RIP: 0010:btrfs_get_16+0x34b/0x6d0
  [2.621] RSP: 0018:ffff88810871fab8 EFLAGS: 00000206
  [2.621] RAX: 0000a11000000003 RBX: ffff888104ff8720 RCX: ffff88811b2288c0
  [2.621] RDX: dffffc0000000000 RSI: ffffffff81dd8aca RDI: ffff88810871f748
  [2.621] RBP: 000000000000401a R08: 0000000000000001 R09: ffffed10210e3ee9
  [2.621] R10: ffff88810871f74f R11: 205d323430333737 R12: 000000000000001a
  [2.621] R13: 000508800000001a R14: 1ffff110210e3f5d R15: ffffffff850011e8
  [2.621] FS:  00007f56ea275840(0000) GS:ffff88811b200000(0000) knlGS:0000000000000000
  [2.621] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [2.621] CR2: 00007febd13b75c0 CR3: 000000010bb50000 CR4: 00000000000006f0
  [2.621] Call Trace:
  [2.621]  <TASK>
  [2.621]  ? show_regs+0x74/0x80
  [2.621]  ? die_addr+0x46/0xc0
  [2.621]  ? exc_general_protection+0x161/0x2a0
  [2.621]  ? asm_exc_general_protection+0x26/0x30
  [2.621]  ? btrfs_get_16+0x33a/0x6d0
  [2.621]  ? btrfs_get_16+0x34b/0x6d0
  [2.621]  ? btrfs_get_16+0x33a/0x6d0
  [2.621]  ? __pfx_btrfs_get_16+0x10/0x10
  [2.621]  ? __pfx_mutex_unlock+0x10/0x10
  [2.621]  btrfs_match_dir_item_name+0x101/0x1a0
  [2.621]  btrfs_lookup_dir_item+0x1f3/0x280
  [2.621]  ? __pfx_btrfs_lookup_dir_item+0x10/0x10
  [2.621]  btrfs_get_tree+0xd25/0x1910

Reported-by: lei lu <llfamsec@gmail.com>
CC: stable@vger.kernel.org # 6.7+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ copy more details from report ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |   30 +++++++++++++++---------------
 fs/btrfs/tree-checker.h |    1 +
 2 files changed, 16 insertions(+), 15 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1889,6 +1889,11 @@ enum btrfs_tree_block_status __btrfs_che
 		return BTRFS_TREE_BLOCK_INVALID_LEVEL;
 	}
 
+	if (unlikely(!btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_WRITTEN))) {
+		generic_err(leaf, 0, "invalid flag for leaf, WRITTEN not set");
+		return BTRFS_TREE_BLOCK_WRITTEN_NOT_SET;
+	}
+
 	/*
 	 * Extent buffers from a relocation tree have a owner field that
 	 * corresponds to the subvolume tree they are based on. So just from an
@@ -1950,6 +1955,7 @@ enum btrfs_tree_block_status __btrfs_che
 	for (slot = 0; slot < nritems; slot++) {
 		u32 item_end_expected;
 		u64 item_data_end;
+		enum btrfs_tree_block_status ret;
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 
@@ -2005,21 +2011,10 @@ enum btrfs_tree_block_status __btrfs_che
 			return BTRFS_TREE_BLOCK_INVALID_OFFSETS;
 		}
 
-		/*
-		 * We only want to do this if WRITTEN is set, otherwise the leaf
-		 * may be in some intermediate state and won't appear valid.
-		 */
-		if (btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_WRITTEN)) {
-			enum btrfs_tree_block_status ret;
-
-			/*
-			 * Check if the item size and content meet other
-			 * criteria
-			 */
-			ret = check_leaf_item(leaf, &key, slot, &prev_key);
-			if (unlikely(ret != BTRFS_TREE_BLOCK_CLEAN))
-				return ret;
-		}
+		/* Check if the item size and content meet other criteria. */
+		ret = check_leaf_item(leaf, &key, slot, &prev_key);
+		if (unlikely(ret != BTRFS_TREE_BLOCK_CLEAN))
+			return ret;
 
 		prev_key.objectid = key.objectid;
 		prev_key.type = key.type;
@@ -2049,6 +2044,11 @@ enum btrfs_tree_block_status __btrfs_che
 	int level = btrfs_header_level(node);
 	u64 bytenr;
 
+	if (unlikely(!btrfs_header_flag(node, BTRFS_HEADER_FLAG_WRITTEN))) {
+		generic_err(node, 0, "invalid flag for node, WRITTEN not set");
+		return BTRFS_TREE_BLOCK_WRITTEN_NOT_SET;
+	}
+
 	if (unlikely(level <= 0 || level >= BTRFS_MAX_LEVEL)) {
 		generic_err(node, 0,
 			"invalid level for node, have %d expect [1, %d]",
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -51,6 +51,7 @@ enum btrfs_tree_block_status {
 	BTRFS_TREE_BLOCK_INVALID_BLOCKPTR,
 	BTRFS_TREE_BLOCK_INVALID_ITEM,
 	BTRFS_TREE_BLOCK_INVALID_OWNER,
+	BTRFS_TREE_BLOCK_WRITTEN_NOT_SET,
 };
 
 /*


