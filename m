Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D848B3B9616;
	Sat, 17 Oct 2026 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259418; cv=none; b=Lr3R17wbEucCjBmaXvwwDvA8vjsvd5pmKdxRIN/4C3lMYMPnsSW3WyFRoPozomQ5odOVuWr3P5Sgq6YSOAG88J9B4vXfbb5OF6IVm/V9KAA0t+UJQdwlNREXee7VgHilmsFwe0oogTIrBAVguGZS6iywiD38MFXupvGNXR8Q8m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259418; c=relaxed/simple;
	bh=fdtHsUOJEmGAzdBG4FNTzNkK0dMHdAiSnolRtpH0e50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk9tB13nf/k+x+if/WUEN09ziWKxKi2gu2iZctId5si+vJVLRIeqk1ANrowlvtDSUB3rEyAv3PZN1PiTAG99EFujLq06Vv7A++Q6HhpJE1W8h6ERJKGk1unIrmmRobtD/yOjc04QRjSODnMd/kSWCkcjRAXDM98BE1n7JEW0OcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5FebINd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5FebINd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1BC1F000C4;
	Sat, 17 Oct 2026 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259416;
	bh=V2ITvSBNeisbXZYvw7VOGnPMItTi0kfq+4N3WGpF4hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5FebINdekkJ4GJYPjOucbr/Zhfce8K4kfwapQdAWTrEaxQTeb+awCgo2lPjgMCgS
	 oTR2UOTACczaUBVviu5bgX3pXPQhORFCNwYausGNHE6AvrqwlKgQqoo3kEk5hfQ9zz
	 lCLTfj+32IVwiM0qRkYOfeqBVN1nYzQlOs663p6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Dongjiang Zhu <zhudongjiang@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1190/1674] btrfs: skip global block reserve accounting for rescue mounts
Date: Sat, 17 Oct 2026 17:57:42 +0200
Message-ID: <20261017160501.686896523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 07bf07431a7f4..14530d436d6ef 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -324,10 +324,25 @@ void btrfs_block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
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
index e025399abce97..20253e3e5f820 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3155,15 +3155,6 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
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
 int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices,
 		      char *options)
 {
@@ -3308,7 +3299,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		goto fail_alloc;
 
 	/* If the fs has any rescue options, no transaction is allowed. */
-	if (fs_is_full_ro(fs_info))
+	if (btrfs_is_full_ro(fs_info))
 		WRITE_ONCE(fs_info->fs_error, -EROFS);
 
 	ret = btrfs_check_features(fs_info, !sb_rdonly(sb));
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 415f867dd1252..88c779635483f 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -948,6 +948,15 @@ do {									\
 	btrfs_clear_opt(fs_info->mount_opt, opt);			\
 } while (0)
 
+static inline bool btrfs_is_full_ro(const struct btrfs_fs_info *fs_info)
+{
+	if (!sb_rdonly(fs_info->sb))
+		return false;
+	if (unlikely(fs_info->mount_opt & BTRFS_MOUNT_FULL_RO_MASK))
+		return true;
+	return false;
+}
+
 static inline int btrfs_fs_closing(struct btrfs_fs_info *fs_info)
 {
 	/* Do it this way so we only ever do one test_bit in the normal case. */
-- 
2.53.0



