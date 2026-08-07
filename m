Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DEA33E355;
	Fri,  7 Aug 2026 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116610; cv=none; b=JAGd9LuA5cGgj3RuqqwC31PycZbKdyGOjv5B0sCPKMm4MxvFw5BHfLDbNb3puZ4t2sFWSQ/4ga5xqPu8zCYQe4DU2hn05iaurPWCAZkOh5Eln9R257h22QE7dzbmwnI1eAZvS+GSzlEsuFGdHyqoXXP7DPHkvPfnm5WR41hLL9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116610; c=relaxed/simple;
	bh=y4VXtUv2YLIgvAz8WmRw1hIwEZQT/5zss0F1lVb9u5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umOc4+itDY04LQxF0dvXs/IdoJtMZUScpg4bUkXMQX003L5HW2zRjgpnik2pWWH7rHBrR8JEh1fJPhOCU4qSVdXc4Do8zPH0OBPnsh4l1hOVqKbyf4OO/sJ0UBhF/DVCUq2NqEzK470xQ4/hXdTSBDLabgflnrsRaXPCz26rLVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwGD6G35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwGD6G35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492771F000E9;
	Fri,  7 Aug 2026 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116608;
	bh=KaBATgEw06IXn0SPwVzJUEbcV5qIXb2uMHa3DrnZqNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwGD6G35+N1nKFarKoQeZCfywje8CocLIR7vq7ADlj+IMbbAxq/QDqATf82cdDnFN
	 lvfdVFq4gTPss+UNMMZZbzN+cLY1GH610wMWbXqruhheq7/wCU8m/yCKaenFpecNvi
	 W8A39zCmmlhFMUbsbdliWb8F4EsBsh6AUqa4YXAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Dongjiang Zhu <zhudongjiang@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 029/438] btrfs: skip global block reserve accounting for rescue mounts
Date: Fri,  7 Aug 2026 16:33:45 +0200
Message-ID: <20260807143428.629690462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongjiang Zhu <zhudongjiang@fnnas.com>

[ Upstream commit 51a0e8399858621442807a26057bcd1cd3ced046 ]

[BUG]
Mounting with rescue=ibadroots after corrupting the block group tree
root triggers a NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000100
  RIP: 0010:btrfs_update_global_block_rsv+0x9d/0x1c0 [btrfs]
  Call Trace:
   fill_dummy_bgs+0xd4/0x120 [btrfs]
   open_ctree+0xc6e/0x1ca0 [btrfs]
   btrfs_get_tree+0x50d/0xa40 [btrfs]

The same crash occurs with a corrupted raid stripe tree root, via
btrfs_read_block_groups() instead of fill_dummy_bgs().

[CAUSE]
With rescue=ibadroots, btrfs_read_roots() allows the mount to continue
when either root cannot be read, leaving the corresponding root pointer
NULL while its on-disk feature bit remains set.

btrfs_update_global_block_rsv() then dereferences the missing root based
on the feature bit alone.

[FIX]
Rescue mounts are fully read-only and cannot start transactions, so the
global reserve is never consumed. Under btrfs_is_full_ro(), mark the
reserve as full and return before performing the accounting.

And since we need to check if the fs is mount fully RO, export
fs_is_full_ro() as btrfs_is_full_ro(), and move it to fs.h.

Fixes: 8dbfc14fc736 ("btrfs: account block group tree when calculating global reserve size")
Fixes: 515020900d44 ("btrfs: read raid stripe tree from disk")
Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
[ Squash the fs_is_full_ro() export commit into this one. ]
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-rsv.c | 19 +++++++++++++++++--
 fs/btrfs/disk-io.c   | 11 +----------
 fs/btrfs/fs.h        |  9 +++++++++
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 9efb3016ef116..c68a8f4b7d19c 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -322,10 +322,25 @@ void btrfs_block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
 void btrfs_update_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
-	struct btrfs_space_info *sinfo = block_rsv->space_info;
+	struct btrfs_space_info *sinfo;
 	struct btrfs_root *root, *tmp;
-	u64 num_bytes = btrfs_root_used(&fs_info->tree_root->root_item);
 	unsigned int min_items = 1;
+	u64 num_bytes;
+
+	/*
+	 * A full read-only mount (rescue options) cannot start transactions,
+	 * so the global reserve is never consumed. Mark it as full and skip
+	 * the accounting.
+	 */
+	if (btrfs_is_full_ro(fs_info)) {
+		spin_lock(&block_rsv->lock);
+		block_rsv->full = true;
+		spin_unlock(&block_rsv->lock);
+		return;
+	}
+
+	sinfo = block_rsv->space_info;
+	num_bytes = btrfs_root_used(&fs_info->tree_root->root_item);
 
 	/*
 	 * The global block rsv is based on the size of the extent tree, the
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 833965b06f90e..7ca64f79451cb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3267,15 +3267,6 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	return 0;
 }
 
-static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
-{
-	if (!sb_rdonly(fs_info->sb))
-		return false;
-	if (unlikely(fs_info->mount_opt & BTRFS_MOUNT_FULL_RO_MASK))
-		return true;
-	return false;
-}
-
 /*
  * Try to wait for any metadata readahead, and invalidate all btree folios.
  *
@@ -3432,7 +3423,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		WRITE_ONCE(fs_info->fs_error, -EUCLEAN);
 
 	/* If the fs has any rescue options, no transaction is allowed. */
-	if (fs_is_full_ro(fs_info))
+	if (btrfs_is_full_ro(fs_info))
 		WRITE_ONCE(fs_info->fs_error, -EROFS);
 
 	/* Set up fs_info before parsing mount options */
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index a8aa086a4df86..0292246db614d 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1146,6 +1146,15 @@ void __btrfs_clear_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag,
 #define btrfs_test_opt(fs_info, opt)	((fs_info)->mount_opt & \
 					 BTRFS_MOUNT_##opt)
 
+static inline bool btrfs_is_full_ro(const struct btrfs_fs_info *fs_info)
+{
+	if (!sb_rdonly(fs_info->sb))
+		return false;
+	if (unlikely(fs_info->mount_opt & BTRFS_MOUNT_FULL_RO_MASK))
+		return true;
+	return false;
+}
+
 static inline bool btrfs_fs_closing(const struct btrfs_fs_info *fs_info)
 {
 	return unlikely(test_bit(BTRFS_FS_CLOSING_START, &fs_info->flags));
-- 
2.53.0



