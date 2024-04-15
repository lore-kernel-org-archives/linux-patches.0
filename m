Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC54C71B51;
	Mon, 15 Apr 2024 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191773; cv=none; b=qUSY8502AlPWVouQl5BYJ08OyME4eD3tdSSPkx/Hpkm8ZGk8R0Qpyv+eo4ZlZQeycHd+5qSCOlxz9Toj/rgtvcwFHnAHJVohthkhJnLKlfMnOYsPKrw45q5MEX8ibEPSMfHUFVGneicq5UXO0Ke1vhLCy9+YSjlcj0k0UWKp6xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191773; c=relaxed/simple;
	bh=CU5pzDr4+VeSzj+Lu04Z06SWpur60BnpWh01URTohe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K64gL/Y0G37dHD+2cYfyZyLHgnH5rpBRTbzHHOE4qr7nujPJCRy2zR/RbxSa9YLZXPfJmV6AJ9sXJ0R7So4Djw35+0OvBed7p2N0+OpSfQQB9CrK6Xxj7KVhb5AUw6HvEPVvjkpzkcOo73aF2pqkVULcLS2tIdJP2PHEFMZ0Ne8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+i3Wq3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+i3Wq3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6385EC113CC;
	Mon, 15 Apr 2024 14:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191772;
	bh=CU5pzDr4+VeSzj+Lu04Z06SWpur60BnpWh01URTohe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+i3Wq3V7z1lACZon2o1sDLPD1VNkJ5PXG80Bl89gwK9vUHQtvu32l/+P7y65RVVP
	 pm6TIuWKiABJYUy4jjGmYroB3SWR4U3Ua5QA2iMcRHRNZynn51vJs+fAA1cekohfv4
	 G7gXlTpB8POqtc+Q8lKDdcS6qt/rbdj3IVBmlFbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 080/122] btrfs: qgroup: fix qgroup prealloc rsv leak in subvolume operations
Date: Mon, 15 Apr 2024 16:20:45 +0200
Message-ID: <20240415141955.776790744@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c     |   13 ++++++++++++-
 fs/btrfs/ioctl.c     |   37 ++++++++++++++++++++++++++++---------
 fs/btrfs/root-tree.c |   10 ----------
 fs/btrfs/root-tree.h |    2 --
 4 files changed, 40 insertions(+), 22 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4460,6 +4460,7 @@ int btrfs_delete_subvolume(struct btrfs_
 	struct btrfs_trans_handle *trans;
 	struct btrfs_block_rsv block_rsv;
 	u64 root_flags;
+	u64 qgroup_reserved = 0;
 	int ret;
 
 	down_write(&fs_info->subvol_sem);
@@ -4504,12 +4505,20 @@ int btrfs_delete_subvolume(struct btrfs_
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
 
@@ -4568,7 +4577,9 @@ out_end_trans:
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
@@ -603,6 +603,7 @@ static noinline int create_subvol(struct
 	int ret;
 	dev_t anon_dev;
 	u64 objectid;
+	u64 qgroup_reserved = 0;
 
 	root_item = kzalloc(sizeof(*root_item), GFP_KERNEL);
 	if (!root_item)
@@ -640,13 +641,18 @@ static noinline int create_subvol(struct
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
 	/* Tree log can't currently deal with an inode which is a new root. */
@@ -757,9 +763,11 @@ static noinline int create_subvol(struct
 out:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
-	btrfs_subvolume_release_metadata(root, &block_rsv);
-
 	btrfs_end_transaction(trans);
+out_release_rsv:
+	btrfs_block_rsv_release(fs_info, &block_rsv, (u64)-1, NULL);
+	if (qgroup_reserved)
+		btrfs_qgroup_free_meta_prealloc(root, qgroup_reserved);
 out_new_inode_args:
 	btrfs_new_inode_args_destroy(&new_inode_args);
 out_inode:
@@ -781,6 +789,8 @@ static int create_snapshot(struct btrfs_
 	struct btrfs_pending_snapshot *pending_snapshot;
 	unsigned int trans_num_items;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_block_rsv *block_rsv;
+	u64 qgroup_reserved = 0;
 	int ret;
 
 	/* We do not support snapshotting right now. */
@@ -817,19 +827,19 @@ static int create_snapshot(struct btrfs_
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
@@ -842,6 +852,13 @@ static int create_snapshot(struct btrfs_
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
 
@@ -871,7 +888,9 @@ fail:
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
@@ -537,13 +537,3 @@ int btrfs_subvolume_reserve_metadata(str
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
--- a/fs/btrfs/root-tree.h
+++ b/fs/btrfs/root-tree.h
@@ -6,8 +6,6 @@
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int nitems, bool use_global_rsv);
-void btrfs_subvolume_release_metadata(struct btrfs_root *root,
-				      struct btrfs_block_rsv *rsv);
 int btrfs_add_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 sequence,
 		       const struct fscrypt_str *name);


