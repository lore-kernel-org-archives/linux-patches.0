Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F95F4FD279;
	Tue, 13 Oct 2026 12:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893778; cv=none; b=DcxpdscAWgaiCnaTAAoaHx0Ja4eZPndTdhz9mqUvj8neyLwiXwBcIK9nGlqptOgPEtiFW1A1AQG7yXnp6+fg51LaYzFchUZEp2XAXGofTcIRiUnRryDfba64kp+kb90HBYwTNM/sjialaFcKb/kx1VA4Lp9lXELiVsWGdY7Ol2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893778; c=relaxed/simple;
	bh=OK8YncUDL+nYUfrtxfUWa4fZsqnK0kJyxujfQEl/ytA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBQyye+FnpknxHjkDPiKQdpMBZiKoj6WUnqZSIHuaPLSnInei4gVE5KaJtScWTg6DSvJ/zG6NAmHmduakY+bc5XPRuuLi0IQ5a2ICevZCZYCJ92AcZ0/zvMTYqnYDghCqQ2MFnGGBToTTupC3QFcPN3Rk0izv//R+g0ZVcZ1ehU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiyKNYE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiyKNYE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838961F000FF;
	Tue, 13 Oct 2026 12:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893777;
	bh=GBlx4S1uQR66y1J93qXEyTnP7/Is6wYYBMivwW0CblU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiyKNYE8K6wm5mNRPg/4hm0vt0bGBqOwclANZhGH93PCCZmssV8+HoF9UI7A/XBMs
	 seHrX6L9SUrM8FPUVTLoLjqF3i956ANBz6cmUhpvF9fau1b4o+sl1GCPJ9FVoRmXvU
	 q3cuASdUQ0YZfmfRSy8VIljimOTi/PdAsb255PKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Dongjiang Zhu <zhudongjiang@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 337/621] btrfs: skip global block reserve accounting for rescue mounts
Date: Tue, 13 Oct 2026 13:35:32 +0200
Message-ID: <20261013112928.850456686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fc378d2038a2d..fbe75b7e9511c 100644
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
index b163482f72f14..4cda905bb6308 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3258,15 +3258,6 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
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
@@ -3425,7 +3416,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		WRITE_ONCE(fs_info->fs_error, -EUCLEAN);
 
 	/* If the fs has any rescue options, no transaction is allowed. */
-	if (fs_is_full_ro(fs_info))
+	if (btrfs_is_full_ro(fs_info))
 		WRITE_ONCE(fs_info->fs_error, -EROFS);
 
 	/* Set up fs_info before parsing mount options */
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index a50d11df93f8c..8687cf6952d00 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1096,6 +1096,15 @@ void __btrfs_clear_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag,
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



