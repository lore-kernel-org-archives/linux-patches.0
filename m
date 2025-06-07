Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85CC15D1;
	Sat,  7 Jun 2025 10:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291047; cv=none; b=d2aen0ud7OrtQMXM7ocG7Swi9Hs4kwn4h3RfdnRqAfZsC7gM7pkV2+xjoF+g2UWk+0scz1tIBsKzpPPfpL6eBmOIhdSzsor0sd5T1iwF+8UNfyd+3ZoUfCHbjL6HOqZTkNo1ZAPuQqhNqJLqMrqI5OjedJ/QlznwJNXGCdM8Ovo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291047; c=relaxed/simple;
	bh=UEIe5FhQKl57+MOXqaB2ZSHcg7d1EUHJSivOSe++zSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSZVAL9/Z/8oT7ErntuWJ3ZL+y0U2H57HjGF6kjAqtk0UV/ZQGD+ATHNGq6uDqZLOP+/RotxYDzR6Tkhz6ShV43oBZi7dvXCJ1QP7AdRleh4R2P7bXHLoWFa3qlDRXwPuXeZKsZkK0LpHRhx+JK5r6CRhIQb0Bc/L/Yc6DJGbSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03eYll5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03eYll5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FC7C4CEE4;
	Sat,  7 Jun 2025 10:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291047;
	bh=UEIe5FhQKl57+MOXqaB2ZSHcg7d1EUHJSivOSe++zSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03eYll5mvxEwfEqb98vzCgUaarAE4aoBzWNK0aZOgXpl3tU+/yYJs+6JhYj1BcfHv
	 CHPj+Tkoqmixz3FuuxpStoUUi0F8hXfpjhqXglPlgZNiqhojrJAwumJjghyb6TOpLH
	 qeWi/pyU8GS2hdQo6ssbu1T/wWsdNeEt0Fm/FoWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.15 17/34] bcachefs: Run may_delete_deleted_inode() checks in bch2_inode_rm()
Date: Sat,  7 Jun 2025 12:07:58 +0200
Message-ID: <20250607100720.394727213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 09fb85ae565645b982e9030dbb2ff6707f2cdddc upstream.

We had a bug where bch2_evict_inode() incorrectly called bch2_inode_rm()
- the journal clearly showed the inode was not unlinked.

We've got checks that we use in recovery when cleaning up deleted
inodes, lift them to bch2_inode_rm() as well.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/errcode.h          |    2 +
 fs/bcachefs/fs.c               |    8 ++++
 fs/bcachefs/inode.c            |   66 +++++++++++++++++++++++++++++++----------
 fs/bcachefs/sb-errors_format.h |    3 +
 4 files changed, 61 insertions(+), 18 deletions(-)

--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -209,6 +209,8 @@
 	x(EINVAL,			remove_would_lose_data)			\
 	x(EINVAL,			no_resize_with_buckets_nouse)		\
 	x(EINVAL,			inode_unpack_error)			\
+	x(EINVAL,			inode_not_unlinked)			\
+	x(EINVAL,			inode_has_child_snapshot)		\
 	x(EINVAL,			varint_decode_error)			\
 	x(EINVAL,			erasure_coding_found_btree_node)	\
 	x(EOPNOTSUPP,			may_not_use_incompat_feature)		\
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -2181,7 +2181,13 @@ static void bch2_evict_inode(struct inod
 				KEY_TYPE_QUOTA_WARN);
 		bch2_quota_acct(c, inode->ei_qid, Q_INO, -1,
 				KEY_TYPE_QUOTA_WARN);
-		bch2_inode_rm(c, inode_inum(inode));
+		int ret = bch2_inode_rm(c, inode_inum(inode));
+		if (ret && !bch2_err_matches(ret, EROFS)) {
+			bch_err_msg(c, ret, "VFS incorrectly tried to delete inode %llu:%llu",
+				    inode->ei_inum.subvol,
+				    inode->ei_inum.inum);
+			bch2_sb_error_count(c, BCH_FSCK_ERR_vfs_bad_inode_rm);
+		}
 
 		/*
 		 * If we are deleting, we need it present in the vfs hash table
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -38,6 +38,7 @@ static const char * const bch2_inode_fla
 #undef  x
 
 static int delete_ancestor_snapshot_inodes(struct btree_trans *, struct bpos);
+static int may_delete_deleted_inum(struct btree_trans *, subvol_inum);
 
 static const u8 byte_table[8] = { 1, 2, 3, 4, 6, 8, 10, 13 };
 
@@ -1048,19 +1049,23 @@ int bch2_inode_rm(struct bch_fs *c, subv
 	u32 snapshot;
 	int ret;
 
+	ret = lockrestart_do(trans, may_delete_deleted_inum(trans, inum));
+	if (ret)
+		goto err2;
+
 	/*
 	 * If this was a directory, there shouldn't be any real dirents left -
 	 * but there could be whiteouts (from hash collisions) that we should
 	 * delete:
 	 *
-	 * XXX: the dirent could ideally would delete whiteouts when they're no
+	 * XXX: the dirent code ideally would delete whiteouts when they're no
 	 * longer needed
 	 */
 	ret   = bch2_inode_delete_keys(trans, inum, BTREE_ID_extents) ?:
 		bch2_inode_delete_keys(trans, inum, BTREE_ID_xattrs) ?:
 		bch2_inode_delete_keys(trans, inum, BTREE_ID_dirents);
 	if (ret)
-		goto err;
+		goto err2;
 retry:
 	bch2_trans_begin(trans);
 
@@ -1342,7 +1347,8 @@ int bch2_inode_rm_snapshot(struct btree_
 		delete_ancestor_snapshot_inodes(trans, SPOS(0, inum, snapshot));
 }
 
-static int may_delete_deleted_inode(struct btree_trans *trans, struct bpos pos)
+static int may_delete_deleted_inode(struct btree_trans *trans, struct bpos pos,
+				    bool from_deleted_inodes)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_iter inode_iter;
@@ -1357,11 +1363,13 @@ static int may_delete_deleted_inode(stru
 		return ret;
 
 	ret = bkey_is_inode(k.k) ? 0 : -BCH_ERR_ENOENT_inode;
-	if (fsck_err_on(!bkey_is_inode(k.k),
+	if (fsck_err_on(from_deleted_inodes && ret,
 			trans, deleted_inode_missing,
 			"nonexistent inode %llu:%u in deleted_inodes btree",
 			pos.offset, pos.snapshot))
 		goto delete;
+	if (ret)
+		goto out;
 
 	ret = bch2_inode_unpack(k, &inode);
 	if (ret)
@@ -1369,7 +1377,8 @@ static int may_delete_deleted_inode(stru
 
 	if (S_ISDIR(inode.bi_mode)) {
 		ret = bch2_empty_dir_snapshot(trans, pos.offset, 0, pos.snapshot);
-		if (fsck_err_on(bch2_err_matches(ret, ENOTEMPTY),
+		if (fsck_err_on(from_deleted_inodes &&
+				bch2_err_matches(ret, ENOTEMPTY),
 				trans, deleted_inode_is_dir,
 				"non empty directory %llu:%u in deleted_inodes btree",
 				pos.offset, pos.snapshot))
@@ -1378,17 +1387,25 @@ static int may_delete_deleted_inode(stru
 			goto out;
 	}
 
-	if (fsck_err_on(!(inode.bi_flags & BCH_INODE_unlinked),
+	ret = inode.bi_flags & BCH_INODE_unlinked ? 0 : -BCH_ERR_inode_not_unlinked;
+	if (fsck_err_on(from_deleted_inodes && ret,
 			trans, deleted_inode_not_unlinked,
 			"non-deleted inode %llu:%u in deleted_inodes btree",
 			pos.offset, pos.snapshot))
 		goto delete;
+	if (ret)
+		goto out;
+
+	ret = !(inode.bi_flags & BCH_INODE_has_child_snapshot)
+		? 0 : -BCH_ERR_inode_has_child_snapshot;
 
-	if (fsck_err_on(inode.bi_flags & BCH_INODE_has_child_snapshot,
+	if (fsck_err_on(from_deleted_inodes && ret,
 			trans, deleted_inode_has_child_snapshots,
 			"inode with child snapshots %llu:%u in deleted_inodes btree",
 			pos.offset, pos.snapshot))
 		goto delete;
+	if (ret)
+		goto out;
 
 	ret = bch2_inode_has_child_snapshots(trans, k.k->p);
 	if (ret < 0)
@@ -1405,19 +1422,28 @@ static int may_delete_deleted_inode(stru
 			if (ret)
 				goto out;
 		}
+
+		if (!from_deleted_inodes) {
+			ret =   bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc) ?:
+				-BCH_ERR_inode_has_child_snapshot;
+			goto out;
+		}
+
 		goto delete;
 
 	}
 
-	if (test_bit(BCH_FS_clean_recovery, &c->flags) &&
-	    !fsck_err(trans, deleted_inode_but_clean,
-		      "filesystem marked as clean but have deleted inode %llu:%u",
-		      pos.offset, pos.snapshot)) {
-		ret = 0;
-		goto out;
-	}
+	if (from_deleted_inodes) {
+		if (test_bit(BCH_FS_clean_recovery, &c->flags) &&
+		    !fsck_err(trans, deleted_inode_but_clean,
+			      "filesystem marked as clean but have deleted inode %llu:%u",
+			      pos.offset, pos.snapshot)) {
+			ret = 0;
+			goto out;
+		}
 
-	ret = 1;
+		ret = 1;
+	}
 out:
 fsck_err:
 	bch2_trans_iter_exit(trans, &inode_iter);
@@ -1428,6 +1454,14 @@ delete:
 	goto out;
 }
 
+static int may_delete_deleted_inum(struct btree_trans *trans, subvol_inum inum)
+{
+	u32 snapshot;
+
+	return bch2_subvolume_get_snapshot(trans, inum.subvol, &snapshot) ?:
+		may_delete_deleted_inode(trans, SPOS(0, inum.inum, snapshot), false);
+}
+
 int bch2_delete_dead_inodes(struct bch_fs *c)
 {
 	struct btree_trans *trans = bch2_trans_get(c);
@@ -1451,7 +1485,7 @@ int bch2_delete_dead_inodes(struct bch_f
 	ret = for_each_btree_key_commit(trans, iter, BTREE_ID_deleted_inodes, POS_MIN,
 					BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
 					NULL, NULL, BCH_TRANS_COMMIT_no_enospc, ({
-		ret = may_delete_deleted_inode(trans, k.k->p);
+		ret = may_delete_deleted_inode(trans, k.k->p, true);
 		if (ret > 0) {
 			bch_verbose_ratelimited(c, "deleting unlinked inode %llu:%u",
 						k.k->p.offset, k.k->p.snapshot);
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -244,6 +244,7 @@ enum bch_fsck_flags {
 	x(inode_parent_has_case_insensitive_not_set,		317,	FSCK_AUTOFIX)	\
 	x(vfs_inode_i_blocks_underflow,				311,	FSCK_AUTOFIX)	\
 	x(vfs_inode_i_blocks_not_zero_at_truncate,		313,	FSCK_AUTOFIX)	\
+	x(vfs_bad_inode_rm,					320,	0)		\
 	x(deleted_inode_but_clean,				211,	FSCK_AUTOFIX)	\
 	x(deleted_inode_missing,				212,	FSCK_AUTOFIX)	\
 	x(deleted_inode_is_dir,					213,	FSCK_AUTOFIX)	\
@@ -329,7 +330,7 @@ enum bch_fsck_flags {
 	x(dirent_stray_data_after_cf_name,			305,	0)		\
 	x(rebalance_work_incorrectly_set,			309,	FSCK_AUTOFIX)	\
 	x(rebalance_work_incorrectly_unset,			310,	FSCK_AUTOFIX)	\
-	x(MAX,							320,	0)
+	x(MAX,							321,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,


