Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF6C429008;
	Sat, 12 Sep 2026 08:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202541; cv=none; b=A6WbcOiOtNe/BVPsv9Aj3h7al3sCNvTCXPOD09p7liUJLq7Fme9Pl2zSghDkj74tBffV1/qF+89HUxSs5GJvrgfCj62MTOO7Sy+e6cT0AvC7mliQkosEpRpV+WWbvmAqQgfbGfBmrb6do+VnZ1jBqLLpMci5pCdoJaH5tUGQto4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202541; c=relaxed/simple;
	bh=O8eYVJjZyAnix/e5iFaTO7QNEOAMhCtPK15LZ3sRqKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlXIm5r7aLRUGQeEDhKw/sTzZ3ShbWz+M6hbKIQo5LgUxAWvjN49VCuFQi6KDHUj72cKu2thSd+/EuZZh62deRfg9NDgGyr7ceMxANRfMK77Ni1Vxx2gmaDZI9baIy80Ew+1fCncu2U1ld6+YJh+veTjRhbbbXu8rmVihqNQ0Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNF6dWwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNF6dWwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D9C1F000FF;
	Sat, 12 Sep 2026 08:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202540;
	bh=ivgbP2i5xy+tkJ3l5crPvQnkRslKV5u/1bA/8PYkmHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNF6dWwtVq1GYu6bsSmjGesH+DcDgYOTMLCg/SAc/YIIIzLUS1GOh/TdeOVpG/NQh
	 uWJubaLR/BMxWY92XOOmRfh/87LuRpDe8CHVhJaSNmN5O/9Kum35i/PdlU3CThoCr7
	 CuOwicx9O7/pRZkxT5TpDJ9kIxWu13xSbHGHwDkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1223/1815] btrfs: zoned: dont force read-only on transient -EAGAIN from reloc merge
Date: Sat, 12 Sep 2026 08:49:33 +0200
Message-ID: <20260912065717.720777710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit e549093c11a2fff8430df3dfbdb45eb9811a69a5 ]

On a zoned FS, btrfs_delayed_refs_rsv_refill() returns -EAGAIN whenever
the over-committed metadata plus the zone_unusable bytes exceeds the
usable size in a metadata block-group to avoid heavy over-commit of
metadata and early ENOSPC in one transaction.

If this happens while doing reclaim, the transaction is getting aborted.

Treat -EAGAIN as a soft, retryable condition in case of block-group
reclaim.

Reported-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c |  8 ++++++-
 fs/btrfs/relocation.c  | 49 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8def7abb728f7..c5bcd3c03d247 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2047,6 +2047,11 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 
 	trace_btrfs_reclaim_block_group(bg);
 	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
+	if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
+		btrfs_dec_block_group_ro(bg);
+		btrfs_debug(fs_info, "deferring reclaim of chunk %llu", bg->start);
+		return ret;
+	}
 	if (ret) {
 		btrfs_dec_block_group_ro(bg);
 		btrfs_err(fs_info, "error relocating chunk %llu",
@@ -2113,7 +2118,8 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 		spin_unlock(&fs_info->unused_bgs_lock);
 		ret = btrfs_reclaim_block_group(bg, &reclaimed);
 
-		if (ret && !READ_ONCE(space_info->periodic_reclaim))
+		if ((btrfs_is_zoned(fs_info) && ret == -EAGAIN) ||
+		    (ret && !READ_ONCE(space_info->periodic_reclaim)))
 			btrfs_link_bg_list(bg, &retry_list);
 		btrfs_put_block_group(bg);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4eca2b5e4a924..e4b259717c251 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1537,6 +1537,33 @@ static void clear_reloc_root(struct btrfs_root *root)
 	clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
 }
 
+/* Drop the reloc trees of a relocation that is being deferred and retried. */
+static void abort_reloc_roots(struct reloc_control *rc, struct list_head *list)
+{
+	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
+	struct btrfs_root *reloc_root, *tmp;
+
+	list_for_each_entry_safe(reloc_root, tmp, list, root_list) {
+		struct btrfs_root *root;
+
+		root = btrfs_get_fs_root(fs_info, reloc_root->root_key.offset, false);
+		if (!IS_ERR(root)) {
+			if (root->reloc_root == reloc_root) {
+				clear_reloc_root(root);
+				btrfs_put_root(reloc_root);
+			}
+			btrfs_put_root(root);
+		}
+
+		btrfs_set_root_refs(&reloc_root->root_item, 0);
+		memset(&reloc_root->root_item.drop_progress, 0, sizeof(struct btrfs_disk_key));
+		btrfs_set_root_drop_level(&reloc_root->root_item, 0);
+
+		list_del_init(&reloc_root->root_list);
+		list_add_tail(&reloc_root->reloc_dirty_list, &rc->dirty_subvol_roots);
+	}
+}
+
 static int clean_dirty_subvols(struct reloc_control *rc)
 {
 	struct btrfs_root *root;
@@ -1876,8 +1903,7 @@ int prepare_to_merge(struct reloc_control *rc, int err)
 	return err;
 }
 
-static noinline_for_stack
-void merge_reloc_roots(struct reloc_control *rc)
+static noinline_for_stack int merge_reloc_roots(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
 	struct btrfs_root *root;
@@ -1975,7 +2001,15 @@ void merge_reloc_roots(struct reloc_control *rc)
 		goto again;
 	}
 out:
-	if (ret) {
+	if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
+		abort_reloc_roots(rc, &reloc_roots);
+
+		/* New reloc root may be added. */
+		mutex_lock(&fs_info->reloc_mutex);
+		list_splice_init(&rc->reloc_roots, &reloc_roots);
+		mutex_unlock(&fs_info->reloc_mutex);
+		abort_reloc_roots(rc, &reloc_roots);
+	} else if (ret) {
 		btrfs_handle_fs_error(fs_info, ret, NULL);
 		free_reloc_roots(&reloc_roots);
 
@@ -2001,6 +2035,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 	 *
 	 * The remaining nodes will be cleaned up by put_reloc_control().
 	 */
+	return ret;
 }
 
 static void free_block_list(struct rb_root *blocks)
@@ -3730,7 +3765,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	 */
 	err = prepare_to_merge(rc, err);
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret && !err)
+		err = ret;
 
 	rc->merge_reloc_tree = false;
 	unset_reloc_control(rc);
@@ -5720,7 +5757,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 		goto out_drop_reloc_refs;
 	release_recovered_fs_roots(&recovered_roots, false);
 
-	merge_reloc_roots(rc);
+	ret = merge_reloc_roots(rc);
+	if (ret)
+		goto out_unset;
 
 	unset_reloc_control(rc);
 
-- 
2.53.0



