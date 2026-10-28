Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215646;
	b=TbKxOqkvXKQNYdw7wxxq/n/IJQkHo3+CSZj1GdRi1/qu0b2Jm/uDEPknNSk4S7ycK8xr
	 xtZBkLapgDpbNfC/raWGHd8VmIQ3H9wkFVwsfFpXghSXlI8A4eG8O/hKhCmxSXjn1A5qI
	 uD+FzGRpybpW9XWYvnDsOwRqtdIfm9ahy3bYnfnVYyiaxloU51JeXXP8Dm4j3sKTyk5es
	 ofAFHjMtpZmraejwgZv0tYcsNGSuFdPyZvWV3zdJ5I2QSVNbSHIgEhoBndthQrcZDnYTf
	 cdBahBAlH39WVuiTLG+sloCNxBreJGMTnyqo9Bm3M+mw2t7qNIi5c4z8Z4YID3GuqFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6rmzAFkwPvkw71HaOQHSQSxe1Hljr260sy+YqnqJzXw=;
	b=UA7YwiywQaRhVK1HAIB0orKF7eYxSdfVZzgiriDmsxLszJzx3zbhN0enSIqllf7/cIyP
	 86+afUARucslQQ17glMEdZNoew3rf3jmTL9cun4ZDhQWLe0p80Dt/bqmyXutrRtK1pS5h
	 oBmjBz4oGyuaT2G+uUnBqjLJrL0OlKXAGiQZVo5qdf4RqXiyUXAWd1c56G/5EPyg2jOQH
	 7pA2yBVVZiidw8Vew9ouFagQDuUUfIx8T+923kdP4iIJ1qoBobK96pHa4fYYjkaBnTWHX
	 Bm7NSjrzp7PkRhCbF3aDjJqf/ADC2j919kmvnlsFTFI78V8+2PlcfOBmYR++HwogoVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfMY6fDm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DA6606A31D;
	Wed, 28 Oct 2026 19:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfMY6fDm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9909E1F01825;
	Wed, 28 Oct 2026 19:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215646;
	bh=6rmzAFkwPvkw71HaOQHSQSxe1Hljr260sy+YqnqJzXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfMY6fDmdKjklvTieIYPpe5HRBCDH34tWhVwKtiwuH5GZKvkJNoUrMwgGdiDumH2W
	 gWcjXDL8QWTMi++aqn5yxe1ERAso7cgf8Hlbiv5Ui4N4IRT2SkB6QCpTmts8P3N67s
	 68aEo5lJwMoRvTbSpR1FjykEL0igdzXfG0q9R10Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Dongjiang Zhu <zhudongjiang@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1284/1887] btrfs: skip global block reserve accounting for rescue mounts
Date: Wed, 28 Oct 2026 17:56:20 +0100
Message-ID: <20261028170528.647045615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/btrfs/ctree.h     |  9 +++++++++
 fs/btrfs/disk-io.c   | 11 +----------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index a47c8b4509969..a3fe0ef899a2e 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -352,10 +352,25 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
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
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e115ba97dd44a..c1cfc03fefbe9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1641,6 +1641,15 @@ enum {
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
 #define btrfs_set_and_info(fs_info, opt, fmt, args...)			\
 do {									\
 	if (!btrfs_test_opt(fs_info, opt))				\
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7916dbd138554..a71d773d0c3bc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3417,15 +3417,6 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
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
@@ -3808,7 +3799,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	}
 
 	/* If the fs has any rescue options, no transaction is allowed. */
-	if (fs_is_full_ro(fs_info))
+	if (btrfs_is_full_ro(fs_info))
 		set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
 
 	fs_info->fs_root = btrfs_get_fs_root(fs_info, BTRFS_FS_TREE_OBJECTID, true);
-- 
2.53.0



