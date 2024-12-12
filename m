Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F6D23ED76;
	Thu, 12 Dec 2024 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020005; cv=none; b=aY51y0KGgCV718at/I+oNK5Q7UFABdZbkFV4eZ0Z9R1xJ3QUC3pCFnHbYa1VwNDCRzd0QMVE9d5OBo3jLmo/xkUlZUmFzs/l6xaBx21PuLlWYBBz0yKSa1ZYJUJvSocIdBxmpIt2qdT88gMWNVqkDJ8nQ1mVE7icidKBf+sJpcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020005; c=relaxed/simple;
	bh=V/38ft5fw0gL/J69i1rSAj0mVNlJ2Ub2DhN5R0xdTE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgTzWhGZH/h2DxsGk7U3FzOcm3cV1S0ePG54FrE+s8Nza5q3CpTAO+jgSrjMR7YtZ/AhCbAE8FsAu3Gnhav5eAyBltlN8BZ+YZ0dWYtY+8d6dyqGpcTTyPv5UnCCEXBf93J0etoyQ1udfTxfjRsQDNU3kbMHy8DTIgwdp8/tzXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZXABNPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZXABNPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D1EC4CECE;
	Thu, 12 Dec 2024 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020005;
	bh=V/38ft5fw0gL/J69i1rSAj0mVNlJ2Ub2DhN5R0xdTE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZXABNPPwh5uf3mcM0yV4qD8PRlY8F2y7avB9sgZttnoqgpIzcT7R46wc22+U7Udm
	 Qv0hcaeFoXwNGW0fOQjTwPmT5bSXYXFF9/uWcS6xcOsmwQviMo+0cipgMylJJC4c1x
	 FxUDpZkWVom1VKKLPtPAVYN1Du1o87nll9lE7RF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 352/772] btrfs: qgroup: fix qgroup prealloc rsv leak in subvolume operations
Date: Thu, 12 Dec 2024 15:54:57 +0100
Message-ID: <20241212144404.453071226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 74e97958121aa1f5854da6effba70143f051b0cd upstream.

Create subvolume, create snapshot and delete subvolume all use
btrfs_subvolume_reserve_metadata() to reserve metadata for the changes
done to the parent subvolume's fs tree, which cannot be mediated in the
normal way via start_transaction. When quota groups (squota or qgroups)
are enabled, this reserves qgroup metadata of type PREALLOC. Once the
operation is associated to a transaction, we convert PREALLOC to
PERTRANS, which gets cleared in bulk at the end of the transaction.

However, the error paths of these three operations were not implementing
this lifecycle correctly. They unconditionally converted the PREALLOC to
PERTRANS in a generic cleanup step regardless of errors or whether the
operation was fully associated to a transaction or not. This resulted in
error paths occasionally converting this rsv to PERTRANS without calling
record_root_in_trans successfully, which meant that unless that root got
recorded in the transaction by some other thread, the end of the
transaction would not free that root's PERTRANS, leaking it. Ultimately,
this resulted in hitting a WARN in CONFIG_BTRFS_DEBUG builds at unmount
for the leaked reservation.

The fix is to ensure that every qgroup PREALLOC reservation observes the
following properties:

1. any failure before record_root_in_trans is called successfully
   results in freeing the PREALLOC reservation.
2. after record_root_in_trans, we convert to PERTRANS, and now the
   transaction owns freeing the reservation.

This patch enforces those properties on the three operations. Without
it, generic/269 with squotas enabled at mkfs time would fail in ~5-10
runs on my system. With this patch, it ran successfully 1000 times in a
row.

Fixes: e85fde5162bf ("btrfs: qgroup: fix qgroup meta rsv leak for subvolume operations")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
[Xiangyu: BP to fix CVE-2024-35956, due to 6.1 btrfs_subvolume_release_metadata()
defined in ctree.h, modified the header file name from root-tree.h to ctree.h]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h     |    2 --
 fs/btrfs/inode.c     |   13 ++++++++++++-
 fs/btrfs/ioctl.c     |   36 ++++++++++++++++++++++++++++--------
 fs/btrfs/root-tree.c |   10 ----------
 4 files changed, 40 insertions(+), 21 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2987,8 +2987,6 @@ enum btrfs_flush_state {
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int nitems, bool use_global_rsv);
-void btrfs_subvolume_release_metadata(struct btrfs_root *root,
-				      struct btrfs_block_rsv *rsv);
 void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
 
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4707,6 +4707,7 @@ int btrfs_delete_subvolume(struct inode
 	struct btrfs_trans_handle *trans;
 	struct btrfs_block_rsv block_rsv;
 	u64 root_flags;
+	u64 qgroup_reserved = 0;
 	int ret;
 
 	down_write(&fs_info->subvol_sem);
@@ -4751,12 +4752,20 @@ int btrfs_delete_subvolume(struct inode
 	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv, 5, true);
 	if (ret)
 		goto out_undead;
+	qgroup_reserved = block_rsv.qgroup_rsv_reserved;
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_release;
 	}
+	ret = btrfs_record_root_in_trans(trans, root);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto out_end_trans;
+	}
+	btrfs_qgroup_convert_reserved_meta(root, qgroup_reserved);
+	qgroup_reserved = 0;
 	trans->block_rsv = &block_rsv;
 	trans->bytes_reserved = block_rsv.size;
 
@@ -4815,7 +4824,9 @@ out_end_trans:
 	ret = btrfs_end_transaction(trans);
 	inode->i_flags |= S_DEAD;
 out_release:
-	btrfs_subvolume_release_metadata(root, &block_rsv);
+	btrfs_block_rsv_release(fs_info, &block_rsv, (u64)-1, NULL);
+	if (qgroup_reserved)
+		btrfs_qgroup_free_meta_prealloc(root, qgroup_reserved);
 out_undead:
 	if (ret) {
 		spin_lock(&dest->root_item_lock);
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -592,6 +592,7 @@ static noinline int create_subvol(struct
 	int ret;
 	dev_t anon_dev;
 	u64 objectid;
+	u64 qgroup_reserved = 0;
 
 	root_item = kzalloc(sizeof(*root_item), GFP_KERNEL);
 	if (!root_item)
@@ -629,13 +630,18 @@ static noinline int create_subvol(struct
 					       trans_num_items, false);
 	if (ret)
 		goto out_new_inode_args;
+	qgroup_reserved = block_rsv.qgroup_rsv_reserved;
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		btrfs_subvolume_release_metadata(root, &block_rsv);
-		goto out_new_inode_args;
+		goto out_release_rsv;
 	}
+	ret = btrfs_record_root_in_trans(trans, BTRFS_I(dir)->root);
+	if (ret)
+		goto out;
+	btrfs_qgroup_convert_reserved_meta(root, qgroup_reserved);
+	qgroup_reserved = 0;
 	trans->block_rsv = &block_rsv;
 	trans->bytes_reserved = block_rsv.size;
 
@@ -744,12 +750,15 @@ static noinline int create_subvol(struct
 out:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
-	btrfs_subvolume_release_metadata(root, &block_rsv);
 
 	if (ret)
 		btrfs_end_transaction(trans);
 	else
 		ret = btrfs_commit_transaction(trans);
+out_release_rsv:
+	btrfs_block_rsv_release(fs_info, &block_rsv, (u64)-1, NULL);
+	if (qgroup_reserved)
+		btrfs_qgroup_free_meta_prealloc(root, qgroup_reserved);
 out_new_inode_args:
 	btrfs_new_inode_args_destroy(&new_inode_args);
 out_inode:
@@ -771,6 +780,8 @@ static int create_snapshot(struct btrfs_
 	struct btrfs_pending_snapshot *pending_snapshot;
 	unsigned int trans_num_items;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_block_rsv *block_rsv;
+	u64 qgroup_reserved = 0;
 	int ret;
 
 	/* We do not support snapshotting right now. */
@@ -807,19 +818,19 @@ static int create_snapshot(struct btrfs_
 		goto free_pending;
 	}
 
-	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
-			     BTRFS_BLOCK_RSV_TEMP);
+	block_rsv = &pending_snapshot->block_rsv;
+	btrfs_init_block_rsv(block_rsv, BTRFS_BLOCK_RSV_TEMP);
 	/*
 	 * 1 to add dir item
 	 * 1 to add dir index
 	 * 1 to update parent inode item
 	 */
 	trans_num_items = create_subvol_num_items(inherit) + 3;
-	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
-					       &pending_snapshot->block_rsv,
+	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root, block_rsv,
 					       trans_num_items, false);
 	if (ret)
 		goto free_pending;
+	qgroup_reserved = block_rsv->qgroup_rsv_reserved;
 
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
@@ -832,6 +843,13 @@ static int create_snapshot(struct btrfs_
 		ret = PTR_ERR(trans);
 		goto fail;
 	}
+	ret = btrfs_record_root_in_trans(trans, BTRFS_I(dir)->root);
+	if (ret) {
+		btrfs_end_transaction(trans);
+		goto fail;
+	}
+	btrfs_qgroup_convert_reserved_meta(root, qgroup_reserved);
+	qgroup_reserved = 0;
 
 	trans->pending_snapshot = pending_snapshot;
 
@@ -861,7 +879,9 @@ fail:
 	if (ret && pending_snapshot->snap)
 		pending_snapshot->snap->anon_dev = 0;
 	btrfs_put_root(pending_snapshot->snap);
-	btrfs_subvolume_release_metadata(root, &pending_snapshot->block_rsv);
+	btrfs_block_rsv_release(fs_info, block_rsv, (u64)-1, NULL);
+	if (qgroup_reserved)
+		btrfs_qgroup_free_meta_prealloc(root, qgroup_reserved);
 free_pending:
 	if (pending_snapshot->anon_dev)
 		free_anon_bdev(pending_snapshot->anon_dev);
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -532,13 +532,3 @@ int btrfs_subvolume_reserve_metadata(str
 	}
 	return ret;
 }
-
-void btrfs_subvolume_release_metadata(struct btrfs_root *root,
-				      struct btrfs_block_rsv *rsv)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	u64 qgroup_to_release;
-
-	btrfs_block_rsv_release(fs_info, rsv, (u64)-1, &qgroup_to_release);
-	btrfs_qgroup_convert_reserved_meta(root, qgroup_to_release);
-}


