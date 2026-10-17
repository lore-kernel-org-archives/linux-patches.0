Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CCC391E51;
	Sat, 17 Oct 2026 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254608; cv=none; b=ZlXewdigOeSsTfr5SnPLzufxd2R3Fj3FldacYJIVwkw3J2MG36nHyskyuwBNLLSU10tLmt+uC40QfJIDFGjgQ02eqNBLliG41KFVgcpF5yreaTP1U+ZVfCnoT3xtKvyJXXTQq2QwyJLDNxQlgxINqZrT1Wt75fW4GV9DW9UqrBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254608; c=relaxed/simple;
	bh=/5HhOAw02Lz4poCr/HKMk5t/dBP2iNE6M1vhp6FdPho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuqLizrfumGLHABu4OuxBtkg89dXe+y68xi2DqsdKrW6iUdez6Y6pOjQmmG9M4pDl7QSSyt0gjq1yXdbUvQfpPLg7wdIa3PevPx5htC7N2+9YA/gSUFLFI8Z3h93hMlavRAlx2GxtFiwJVA8qWW/BfVyyk3jeBlGE4hY6LehOZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFrjNoM4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFrjNoM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156D41F000C5;
	Sat, 17 Oct 2026 16:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254607;
	bh=myF1WhvFLXtfWM0OFtqj/Xe1jex51tlhg4J1KC85/e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFrjNoM4wgrTs7AO3SFmIvpIObk4Hg/hV/F+eKTaWnnqi7449ynbsPOlouo2laqKD
	 yykKKGM/7qbku1CTH1xuE+lwwDv7shATOWQBCwQ1+vP/+KpWcB2LmM7ZhJ8vvYxrMF
	 +AvyJr+c/+GXg99XbOgJwWtMO4cWPQW6/dCdmKew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Dongjiang Zhu <zhudongjiang@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 502/869] btrfs: skip global block reserve accounting for rescue mounts
Date: Sat, 17 Oct 2026 17:55:43 +0200
Message-ID: <20261017160049.977731258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a578bd3b32bb0..f111500a2c46e 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -326,10 +326,25 @@ void btrfs_block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
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
index 2c98dd8c126e8..74af70897bcb0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3169,15 +3169,6 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
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
 int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
 {
 	u32 sectorsize;
@@ -3287,7 +3278,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		WRITE_ONCE(fs_info->fs_error, -EUCLEAN);
 
 	/* If the fs has any rescue options, no transaction is allowed. */
-	if (fs_is_full_ro(fs_info))
+	if (btrfs_is_full_ro(fs_info))
 		WRITE_ONCE(fs_info->fs_error, -EROFS);
 
 	/* Set up fs_info before parsing mount options */
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 90b104dd38c23..de10a95707c85 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1044,6 +1044,15 @@ void __btrfs_clear_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag,
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
 static inline int btrfs_fs_closing(const struct btrfs_fs_info *fs_info)
 {
 	/* Do it this way so we only ever do one test_bit in the normal case. */
-- 
2.53.0



