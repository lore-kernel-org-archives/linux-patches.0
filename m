Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263721D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcqitbXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E52C433C7;
	Wed,  4 Oct 2023 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443771;
	bh=dImIt9dLk9JJ0hxaCweorVtQ1TmBhmxyMZf/Ix36POs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcqitbXnm4r01in/IZOizLw11bQamuoUsEnbx1GUQ41IGVMhERRcOIiUe7xoD9n0T
	 YCuzMuRh25cgl+iEjcdsx+fGrMjb1tgPZBMVuNY2m35tU2uqBU/HVpD4f7TJu/cb75
	 zDKGGC8h/pX39t78H/T4PbsP0WSMVrEe9V5nSgxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 015/321] btrfs: remove BUG() after failure to insert delayed dir index item
Date: Wed,  4 Oct 2023 19:52:40 +0200
Message-ID: <20231004175229.904395270@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 2c58c3931ede7cd08cbecf1f1a4acaf0a04a41a9 ]

Instead of calling BUG() when we fail to insert a delayed dir index item
into the delayed node's tree, we can just release all the resources we
have allocated/acquired before and return the error to the caller. This is
fine because all existing call chains undo anything they have done before
calling btrfs_insert_delayed_dir_index() or BUG_ON (when creating pending
snapshots in the transaction commit path).

So remove the BUG() call and do proper error handling.

This relates to a syzbot report linked below, but does not fix it because
it only prevents hitting a BUG(), it does not fix the issue where somehow
we attempt to use twice the same index number for different index items.

Link: https://lore.kernel.org/linux-btrfs/00000000000036e1290603e097e0@google.com/
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 74 +++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 1a050e48e0e57..b5f684cb4e749 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1426,7 +1426,29 @@ void btrfs_balance_delayed_items(struct btrfs_fs_info *fs_info)
 	btrfs_wq_run_delayed_node(delayed_root, fs_info, BTRFS_DELAYED_BATCH);
 }
 
-/* Will return 0 or -ENOMEM */
+static void btrfs_release_dir_index_item_space(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	const u64 bytes = btrfs_calc_insert_metadata_size(fs_info, 1);
+
+	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
+		return;
+
+	/*
+	 * Adding the new dir index item does not require touching another
+	 * leaf, so we can release 1 unit of metadata that was previously
+	 * reserved when starting the transaction. This applies only to
+	 * the case where we had a transaction start and excludes the
+	 * transaction join case (when replaying log trees).
+	 */
+	trace_btrfs_space_reservation(fs_info, "transaction",
+				      trans->transid, bytes, 0);
+	btrfs_block_rsv_release(fs_info, trans->block_rsv, bytes, NULL);
+	ASSERT(trans->bytes_reserved >= bytes);
+	trans->bytes_reserved -= bytes;
+}
+
+/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpected). */
 int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   const char *name, int name_len,
 				   struct btrfs_inode *dir,
@@ -1468,6 +1490,27 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&delayed_node->mutex);
 
+	/*
+	 * First attempt to insert the delayed item. This is to make the error
+	 * handling path simpler in case we fail (-EEXIST). There's no risk of
+	 * any other task coming in and running the delayed item before we do
+	 * the metadata space reservation below, because we are holding the
+	 * delayed node's mutex and that mutex must also be locked before the
+	 * node's delayed items can be run.
+	 */
+	ret = __btrfs_add_delayed_item(delayed_node, delayed_item);
+	if (unlikely(ret)) {
+		btrfs_err(trans->fs_info,
+"error adding delayed dir index item, name: %.*s, index: %llu, root: %llu, dir: %llu, dir->index_cnt: %llu, delayed_node->index_cnt: %llu, error: %d",
+			  name_len, name, index, btrfs_root_id(delayed_node->root),
+			  delayed_node->inode_id, dir->index_cnt,
+			  delayed_node->index_cnt, ret);
+		btrfs_release_delayed_item(delayed_item);
+		btrfs_release_dir_index_item_space(trans);
+		mutex_unlock(&delayed_node->mutex);
+		goto release_node;
+	}
+
 	if (delayed_node->index_item_leaves == 0 ||
 	    delayed_node->curr_index_batch_size + data_len > leaf_data_size) {
 		delayed_node->curr_index_batch_size = data_len;
@@ -1485,37 +1528,14 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 		 * impossible.
 		 */
 		if (WARN_ON(ret)) {
-			mutex_unlock(&delayed_node->mutex);
 			btrfs_release_delayed_item(delayed_item);
+			mutex_unlock(&delayed_node->mutex);
 			goto release_node;
 		}
 
 		delayed_node->index_item_leaves++;
-	} else if (!test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
-		const u64 bytes = btrfs_calc_insert_metadata_size(fs_info, 1);
-
-		/*
-		 * Adding the new dir index item does not require touching another
-		 * leaf, so we can release 1 unit of metadata that was previously
-		 * reserved when starting the transaction. This applies only to
-		 * the case where we had a transaction start and excludes the
-		 * transaction join case (when replaying log trees).
-		 */
-		trace_btrfs_space_reservation(fs_info, "transaction",
-					      trans->transid, bytes, 0);
-		btrfs_block_rsv_release(fs_info, trans->block_rsv, bytes, NULL);
-		ASSERT(trans->bytes_reserved >= bytes);
-		trans->bytes_reserved -= bytes;
-	}
-
-	ret = __btrfs_add_delayed_item(delayed_node, delayed_item);
-	if (unlikely(ret)) {
-		btrfs_err(trans->fs_info,
-"error adding delayed dir index item, name: %.*s, index: %llu, root: %llu, dir: %llu, dir->index_cnt: %llu, delayed_node->index_cnt: %llu, error: %d",
-			  name_len, name, index, btrfs_root_id(delayed_node->root),
-			  delayed_node->inode_id, dir->index_cnt,
-			  delayed_node->index_cnt, ret);
-		BUG();
+	} else {
+		btrfs_release_dir_index_item_space(trans);
 	}
 	mutex_unlock(&delayed_node->mutex);
 
-- 
2.40.1



