Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B20FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24BFC4339E;
	Mon, 15 May 2023 16:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169673;
	bh=93OV4NHXoPHQsRvQuAk2WGp2RKxQ1x6J9afqZ2vhHRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxn05+pJu6YyRb2SHIrvkl2Z85ZOS4ANgZxfHaAPqFVpL6CgA7eSKEs3ZbvWBTSS9
	 KaoVstidiu3MESztMnyFiqAQuznbFfdsWZdEjiDWdvCXOfawC2UaVnztToXlKpKP2J
	 DGVs63GtL+xyvFKLwEu6UtDF8AaF6EDQfWMBkx3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.3 134/246] btrfs: make clear_cache mount option to rebuild FST without disabling it
Date: Mon, 15 May 2023 18:25:46 +0200
Message-Id: <20230515161726.586700018@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

commit 1d6a4fc85717677e00fefffd847a50fc5928ce69 upstream.

Previously clear_cache mount option would simply disable free-space-tree
feature temporarily then re-enable it to rebuild the whole free space
tree.

But this is problematic for block-group-tree feature, as we have an
artificial dependency on free-space-tree feature.

If we go the existing method, after clearing the free-space-tree
feature, we would flip the filesystem to read-only mode, as we detect a
super block write with block-group-tree but no free-space-tree feature.

This patch would change the behavior by properly rebuilding the free
space tree without disabling this feature, thus allowing clear_cache
mount option to work with block group tree.

Now we can mount a filesystem with block-group-tree feature and
clear_mount option:

  $ mkfs.btrfs  -O block-group-tree /dev/test/scratch1  -f
  $ sudo mount /dev/test/scratch1 /mnt/btrfs -o clear_cache
  $ sudo dmesg -t | head -n 5
  BTRFS info (device dm-1): force clearing of disk cache
  BTRFS info (device dm-1): using free space tree
  BTRFS info (device dm-1): auto enabling async discard
  BTRFS info (device dm-1): rebuilding free space tree
  BTRFS info (device dm-1): checking UUID tree

CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c         |   25 ++++++++++++++++------
 fs/btrfs/free-space-tree.c |   50 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/free-space-tree.h |    3 +-
 fs/btrfs/super.c           |    3 --
 4 files changed, 70 insertions(+), 11 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3123,23 +3123,34 @@ int btrfs_start_pre_rw_mount(struct btrf
 {
 	int ret;
 	const bool cache_opt = btrfs_test_opt(fs_info, SPACE_CACHE);
-	bool clear_free_space_tree = false;
+	bool rebuild_free_space_tree = false;
 
 	if (btrfs_test_opt(fs_info, CLEAR_CACHE) &&
 	    btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
-		clear_free_space_tree = true;
+		rebuild_free_space_tree = true;
 	} else if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
 		   !btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID)) {
 		btrfs_warn(fs_info, "free space tree is invalid");
-		clear_free_space_tree = true;
+		rebuild_free_space_tree = true;
 	}
 
-	if (clear_free_space_tree) {
-		btrfs_info(fs_info, "clearing free space tree");
-		ret = btrfs_clear_free_space_tree(fs_info);
+	if (rebuild_free_space_tree) {
+		btrfs_info(fs_info, "rebuilding free space tree");
+		ret = btrfs_rebuild_free_space_tree(fs_info);
 		if (ret) {
 			btrfs_warn(fs_info,
-				   "failed to clear free space tree: %d", ret);
+				   "failed to rebuild free space tree: %d", ret);
+			goto out;
+		}
+	}
+
+	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
+	    !btrfs_test_opt(fs_info, FREE_SPACE_TREE)) {
+		btrfs_info(fs_info, "disabling free space tree");
+		ret = btrfs_delete_free_space_tree(fs_info);
+		if (ret) {
+			btrfs_warn(fs_info,
+				   "failed to disable free space tree: %d", ret);
 			goto out;
 		}
 	}
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1252,7 +1252,7 @@ out:
 	return ret;
 }
 
-int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
+int btrfs_delete_free_space_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *tree_root = fs_info->tree_root;
@@ -1295,6 +1295,54 @@ int btrfs_clear_free_space_tree(struct b
 abort:
 	btrfs_abort_transaction(trans, ret);
 	btrfs_end_transaction(trans);
+	return ret;
+}
+
+int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key = {
+		.objectid = BTRFS_FREE_SPACE_TREE_OBJECTID,
+		.type = BTRFS_ROOT_ITEM_KEY,
+		.offset = 0,
+	};
+	struct btrfs_root *free_space_root = btrfs_global_root(fs_info, &key);
+	struct rb_node *node;
+	int ret;
+
+	trans = btrfs_start_transaction(free_space_root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	set_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	set_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
+
+	ret = clear_free_space_tree(trans, free_space_root);
+	if (ret)
+		goto abort;
+
+	node = rb_first_cached(&fs_info->block_group_cache_tree);
+	while (node) {
+		struct btrfs_block_group *block_group;
+
+		block_group = rb_entry(node, struct btrfs_block_group,
+				       cache_node);
+		ret = populate_free_space_tree(trans, block_group);
+		if (ret)
+			goto abort;
+		node = rb_next(node);
+	}
+
+	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
+	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
+	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+
+	ret = btrfs_commit_transaction(trans);
+	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
+	return ret;
+abort:
+	btrfs_abort_transaction(trans, ret);
+	btrfs_end_transaction(trans);
 	return ret;
 }
 
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -18,7 +18,8 @@ struct btrfs_caching_control;
 
 void set_free_space_tree_thresholds(struct btrfs_block_group *block_group);
 int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info);
-int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info);
+int btrfs_delete_free_space_tree(struct btrfs_fs_info *fs_info);
+int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info);
 int load_free_space_tree(struct btrfs_caching_control *caching_ctl);
 int add_block_group_free_space(struct btrfs_trans_handle *trans,
 			       struct btrfs_block_group *block_group);
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -828,8 +828,7 @@ out:
 		ret = -EINVAL;
 	}
 	if (btrfs_fs_compat_ro(info, BLOCK_GROUP_TREE) &&
-	    (btrfs_test_opt(info, CLEAR_CACHE) ||
-	     !btrfs_test_opt(info, FREE_SPACE_TREE))) {
+	     !btrfs_test_opt(info, FREE_SPACE_TREE)) {
 		btrfs_err(info, "cannot disable free space tree with block-group-tree feature");
 		ret = -EINVAL;
 	}


