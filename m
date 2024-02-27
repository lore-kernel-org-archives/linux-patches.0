Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B4613EFEC;
	Tue, 27 Feb 2024 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044103; cv=none; b=mrMTtD0QCC0gSISTW7hFGJg3T/8pjqCO+6i2UV3gvdIykxhWoKOb7yr8LcH2oOF5/zcVtzilTiKtOE5UFDThCnjIM3ELxg5Wf2m4oTDd1HzzJgMHlOR9UiOxaJrzXh0J3TOfZwALoCHIOMfT6uq0ce0msP/88Hgl4ndBEazhe5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044103; c=relaxed/simple;
	bh=RBnUZuqjR8rT5LmhmG7PZb7quB815bLTlR5KD04YRqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fi8gJfVPTVzXS+OytTEza0xFowzwqO1Q5eTr9C4l6K2foWj273CCFr8hEUnXl79Ws13Z5snkHChSVqu6LNtm5UdsIxFKZ2bST4LonzPtMTktNLbIcqG47+wvpns/khkv9CXwxlkiiFYTHwFIbpUzYSaesue7aPYm1Y9GMSqCt5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6rCYpBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6rCYpBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE369C433C7;
	Tue, 27 Feb 2024 14:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044103;
	bh=RBnUZuqjR8rT5LmhmG7PZb7quB815bLTlR5KD04YRqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6rCYpBVVEHINZxFA4GGB51SoVEBUG3AT2qrYk7yKhx7tBbobD+J1lHAZGDKlW0+a
	 uPFwwfvOVGREx2EUkGeSpDAExN/eJYESismqqhJdLyZcGcTEFlbKXVieBmMgBwNMar
	 0N7yKEGegH5L4iAYOWhN1qmHsybNWiIgPT9PGqf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/122] btrfs: unify lookup return value when dir entry is missing
Date: Tue, 27 Feb 2024 14:27:04 +0100
Message-ID: <20240227131600.765973346@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 8dcbc26194eb872cc3430550fb70bb461424d267 ]

btrfs_lookup_dir_index_item() and btrfs_lookup_dir_item() lookup for dir
entries and both are used during log replay or when updating a log tree
during an unlink.

However when the dir item does not exists, btrfs_lookup_dir_item() returns
NULL while btrfs_lookup_dir_index_item() returns PTR_ERR(-ENOENT), and if
the dir item exists but there is no matching entry for a given name or
index, both return NULL. This makes the call sites during log replay to
be more verbose than necessary and it makes it easy to miss this slight
difference. Since we don't need to distinguish between those two cases,
make btrfs_lookup_dir_index_item() always return NULL when there is no
matching directory entry - either because there isn't any dir entry or
because there is one but it does not match the given name and index.

Also rename the argument 'objectid' of btrfs_lookup_dir_index_item() to
'index' since it is supposed to match an index number, and the name
'objectid' is not very good because it can easily be confused with an
inode number (like the inode number a dir entry points to).

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h    |  2 +-
 fs/btrfs/dir-item.c | 48 ++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/tree-log.c | 14 ++++---------
 3 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 67831868ef0de..3ddb09f2b1685 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2879,7 +2879,7 @@ struct btrfs_dir_item *
 btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dir,
-			    u64 objectid, const char *name, int name_len,
+			    u64 index, const char *name, int name_len,
 			    int mod);
 struct btrfs_dir_item *
 btrfs_search_dir_index_item(struct btrfs_root *root,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 1c0a7cd6b9b0a..98c6faa8ce15b 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -191,9 +191,20 @@ static struct btrfs_dir_item *btrfs_lookup_match_dir(
 }
 
 /*
- * lookup a directory item based on name.  'dir' is the objectid
- * we're searching in, and 'mod' tells us if you plan on deleting the
- * item (use mod < 0) or changing the options (use mod > 0)
+ * Lookup for a directory item by name.
+ *
+ * @trans:	The transaction handle to use. Can be NULL if @mod is 0.
+ * @root:	The root of the target tree.
+ * @path:	Path to use for the search.
+ * @dir:	The inode number (objectid) of the directory.
+ * @name:	The name associated to the directory entry we are looking for.
+ * @name_len:	The length of the name.
+ * @mod:	Used to indicate if the tree search is meant for a read only
+ *		lookup, for a modification lookup or for a deletion lookup, so
+ *		its value should be 0, 1 or -1, respectively.
+ *
+ * Returns: NULL if the dir item does not exists, an error pointer if an error
+ * happened, or a pointer to a dir item if a dir item exists for the given name.
  */
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
@@ -274,27 +285,42 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 }
 
 /*
- * lookup a directory item based on index.  'dir' is the objectid
- * we're searching in, and 'mod' tells us if you plan on deleting the
- * item (use mod < 0) or changing the options (use mod > 0)
+ * Lookup for a directory index item by name and index number.
  *
- * The name is used to make sure the index really points to the name you were
- * looking for.
+ * @trans:	The transaction handle to use. Can be NULL if @mod is 0.
+ * @root:	The root of the target tree.
+ * @path:	Path to use for the search.
+ * @dir:	The inode number (objectid) of the directory.
+ * @index:	The index number.
+ * @name:	The name associated to the directory entry we are looking for.
+ * @name_len:	The length of the name.
+ * @mod:	Used to indicate if the tree search is meant for a read only
+ *		lookup, for a modification lookup or for a deletion lookup, so
+ *		its value should be 0, 1 or -1, respectively.
+ *
+ * Returns: NULL if the dir index item does not exists, an error pointer if an
+ * error happened, or a pointer to a dir item if the dir index item exists and
+ * matches the criteria (name and index number).
  */
 struct btrfs_dir_item *
 btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dir,
-			    u64 objectid, const char *name, int name_len,
+			    u64 index, const char *name, int name_len,
 			    int mod)
 {
+	struct btrfs_dir_item *di;
 	struct btrfs_key key;
 
 	key.objectid = dir;
 	key.type = BTRFS_DIR_INDEX_KEY;
-	key.offset = objectid;
+	key.offset = index;
 
-	return btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
+	di = btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
+	if (di == ERR_PTR(-ENOENT))
+		return NULL;
+
+	return di;
 }
 
 struct btrfs_dir_item *
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 10a0913ffb492..34e9eb5010cda 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -912,8 +912,7 @@ static noinline int inode_in_dir(struct btrfs_root *root,
 	di = btrfs_lookup_dir_index_item(NULL, root, path, dirid,
 					 index, name, name_len, 0);
 	if (IS_ERR(di)) {
-		if (PTR_ERR(di) != -ENOENT)
-			ret = PTR_ERR(di);
+		ret = PTR_ERR(di);
 		goto out;
 	} else if (di) {
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
@@ -1149,8 +1148,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
 					 ref_index, name, namelen, 0);
 	if (IS_ERR(di)) {
-		if (PTR_ERR(di) != -ENOENT)
-			return PTR_ERR(di);
+		return PTR_ERR(di);
 	} else if (di) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
 		if (ret)
@@ -1976,9 +1974,6 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	if (dst_di == ERR_PTR(-ENOENT))
-		dst_di = NULL;
-
 	if (IS_ERR(dst_di)) {
 		ret = PTR_ERR(dst_di);
 		goto out;
@@ -2286,7 +2281,7 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 						     dir_key->offset,
 						     name, name_len, 0);
 		}
-		if (!log_di || log_di == ERR_PTR(-ENOENT)) {
+		if (!log_di) {
 			btrfs_dir_item_key_to_cpu(eb, di, &location);
 			btrfs_release_path(path);
 			btrfs_release_path(log_path);
@@ -3495,8 +3490,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	if (err == -ENOSPC) {
 		btrfs_set_log_full_commit(trans);
 		err = 0;
-	} else if (err < 0 && err != -ENOENT) {
-		/* ENOENT can be returned if the entry hasn't been fsynced yet */
+	} else if (err < 0) {
 		btrfs_abort_transaction(trans, err);
 	}
 
-- 
2.43.0



