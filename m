Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A472E49A8;
	Tue,  8 Jul 2025 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992707; cv=none; b=C+EJ5Y3jrm4/qX0UfCXqMGewLZYVBzYGnqp8rB+p4gODZ5B0lS5d0le25ABDb8ncCi16rCkl3H7hqSRXqIW4nCBMNFvY1bIZaD+OeR+B02DsK2lV2EZZWyxX+ZLDCQUk/wjD2VG5IOPDCrovd2Smp8jZnSrf78kAOuMLpGpZG/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992707; c=relaxed/simple;
	bh=iIFirh115oQcIYaxUbye5MlWQpHKqu0J9hNolv2NE7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAI0w8CFewEeGu/Gei7sg1gq2OlXpIQeSpoI7qL90lzBO3kryyXeQmxEHiOxODvamabcGOiFUk2A/NlWGQtwJV0kQp9IQcrz4dVgmw4qG0bI2KQsOh1pym3VELS0ene5KztoNWb3BpZTzWRWpkWZ8XrlGTaVjEFHqIruvaa6RQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7+r6Z8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7+r6Z8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B27DC4CEED;
	Tue,  8 Jul 2025 16:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992706;
	bh=iIFirh115oQcIYaxUbye5MlWQpHKqu0J9hNolv2NE7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7+r6Z8hQOa2M0iIqd7aqzEJqVAcu48P85pPtOqnAW7BMSM8g0EPfvjGVarj/F2WI
	 uumBB89W5OTV0a/Aw3mmVwGhTBkZkvIa9M52nbneX3Gu3p/TRXaE2Q6ZTIaPY+Ual7
	 5TD74yPzU5Up8qLCeR5ULG6mKjMrnFYuMg+q5XGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/232] btrfs: fix inode lookup error handling during log replay
Date: Tue,  8 Jul 2025 18:20:48 +0200
Message-ID: <20250708162242.823793230@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5f61b961599acbd2bed028d3089105a1f7d224b8 ]

When replaying log trees we use read_one_inode() to get an inode, which is
just a wrapper around btrfs_iget_logging(), which in turn is a wrapper for
btrfs_iget(). But read_one_inode() always returns NULL for any error
that btrfs_iget_logging() / btrfs_iget() may return and this is a problem
because:

1) In many callers of read_one_inode() we convert the NULL into -EIO,
   which is not accurate since btrfs_iget() may return -ENOMEM and -ENOENT
   for example, besides -EIO and other errors. So during log replay we
   may end up reporting a false -EIO, which is confusing since we may
   not have had any IO error at all;

2) When replaying directory deletes, at replay_dir_deletes(), we assume
   the NULL returned from read_one_inode() means that the inode doesn't
   exist and then proceed as if no error had happened. This is wrong
   because unless btrfs_iget() returned ERR_PTR(-ENOENT), we had an
   actual error and the target inode may exist in the target subvolume
   root - this may later result in the log replay code failing at a
   later stage (if we are "lucky") or succeed but leaving some
   inconsistency in the filesystem.

So fix this by not ignoring errors from btrfs_iget_logging() and as
a consequence remove the read_one_inode() wrapper and just use
btrfs_iget_logging() directly. Also since btrfs_iget_logging() is
supposed to be called only against subvolume roots, just like
read_one_inode() which had a comment about it, add an assertion to
btrfs_iget_logging() to check that the target root corresponds to a
subvolume root.

Fixes: 5d4f98a28c7d ("Btrfs: Mixed back reference  (FORWARD ROLLING FORMAT CHANGE)")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 127 +++++++++++++++++++++-----------------------
 1 file changed, 62 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f4317fce569b7..97c5dc0ebd9d6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -143,6 +143,9 @@ static struct btrfs_inode *btrfs_iget_logging(u64 objectid, struct btrfs_root *r
 	unsigned int nofs_flag;
 	struct inode *inode;
 
+	/* Only meant to be called for subvolume roots and not for log roots. */
+	ASSERT(is_fstree(btrfs_root_id(root)));
+
 	/*
 	 * We're holding a transaction handle whether we are logging or
 	 * replaying a log tree, so we must make sure NOFS semantics apply
@@ -613,21 +616,6 @@ static int read_alloc_one_name(struct extent_buffer *eb, void *start, int len,
 	return 0;
 }
 
-/*
- * simple helper to read an inode off the disk from a given root
- * This can only be called for subvolume roots and not for the log
- */
-static noinline struct btrfs_inode *read_one_inode(struct btrfs_root *root,
-						   u64 objectid)
-{
-	struct btrfs_inode *inode;
-
-	inode = btrfs_iget_logging(objectid, root);
-	if (IS_ERR(inode))
-		return NULL;
-	return inode;
-}
-
 /* replays a single extent in 'eb' at 'slot' with 'key' into the
  * subvolume 'root'.  path is released on entry and should be released
  * on exit.
@@ -680,9 +668,9 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	inode = read_one_inode(root, key->objectid);
-	if (!inode)
-		return -EIO;
+	inode = btrfs_iget_logging(key->objectid, root);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
 
 	/*
 	 * first check to see if we already have this extent in the
@@ -961,9 +949,10 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 
-	inode = read_one_inode(root, location.objectid);
-	if (!inode) {
-		ret = -EIO;
+	inode = btrfs_iget_logging(location.objectid, root);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		inode = NULL;
 		goto out;
 	}
 
@@ -1182,10 +1171,10 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				kfree(victim_name.name);
 				return ret;
 			} else if (!ret) {
-				ret = -ENOENT;
-				victim_parent = read_one_inode(root,
-						parent_objectid);
-				if (victim_parent) {
+				victim_parent = btrfs_iget_logging(parent_objectid, root);
+				if (IS_ERR(victim_parent)) {
+					ret = PTR_ERR(victim_parent);
+				} else {
 					inc_nlink(&inode->vfs_inode);
 					btrfs_release_path(path);
 
@@ -1330,9 +1319,9 @@ static int unlink_old_inode_refs(struct btrfs_trans_handle *trans,
 			struct btrfs_inode *dir;
 
 			btrfs_release_path(path);
-			dir = read_one_inode(root, parent_id);
-			if (!dir) {
-				ret = -ENOENT;
+			dir = btrfs_iget_logging(parent_id, root);
+			if (IS_ERR(dir)) {
+				ret = PTR_ERR(dir);
 				kfree(name.name);
 				goto out;
 			}
@@ -1404,15 +1393,17 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 	 * copy the back ref in.  The link count fixup code will take
 	 * care of the rest
 	 */
-	dir = read_one_inode(root, parent_objectid);
-	if (!dir) {
-		ret = -ENOENT;
+	dir = btrfs_iget_logging(parent_objectid, root);
+	if (IS_ERR(dir)) {
+		ret = PTR_ERR(dir);
+		dir = NULL;
 		goto out;
 	}
 
-	inode = read_one_inode(root, inode_objectid);
-	if (!inode) {
-		ret = -EIO;
+	inode = btrfs_iget_logging(inode_objectid, root);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		inode = NULL;
 		goto out;
 	}
 
@@ -1424,11 +1415,13 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			 * parent object can change from one array
 			 * item to another.
 			 */
-			if (!dir)
-				dir = read_one_inode(root, parent_objectid);
 			if (!dir) {
-				ret = -ENOENT;
-				goto out;
+				dir = btrfs_iget_logging(parent_objectid, root);
+				if (IS_ERR(dir)) {
+					ret = PTR_ERR(dir);
+					dir = NULL;
+					goto out;
+				}
 			}
 		} else {
 			ret = ref_get_fields(eb, ref_ptr, &name, &ref_index);
@@ -1697,9 +1690,9 @@ static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
 			break;
 
 		btrfs_release_path(path);
-		inode = read_one_inode(root, key.offset);
-		if (!inode) {
-			ret = -EIO;
+		inode = btrfs_iget_logging(key.offset, root);
+		if (IS_ERR(inode)) {
+			ret = PTR_ERR(inode);
 			break;
 		}
 
@@ -1735,9 +1728,9 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 	struct btrfs_inode *inode;
 	struct inode *vfs_inode;
 
-	inode = read_one_inode(root, objectid);
-	if (!inode)
-		return -EIO;
+	inode = btrfs_iget_logging(objectid, root);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
 
 	vfs_inode = &inode->vfs_inode;
 	key.objectid = BTRFS_TREE_LOG_FIXUP_OBJECTID;
@@ -1776,14 +1769,14 @@ static noinline int insert_one_name(struct btrfs_trans_handle *trans,
 	struct btrfs_inode *dir;
 	int ret;
 
-	inode = read_one_inode(root, location->objectid);
-	if (!inode)
-		return -ENOENT;
+	inode = btrfs_iget_logging(location->objectid, root);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
 
-	dir = read_one_inode(root, dirid);
-	if (!dir) {
+	dir = btrfs_iget_logging(dirid, root);
+	if (IS_ERR(dir)) {
 		iput(&inode->vfs_inode);
-		return -EIO;
+		return PTR_ERR(dir);
 	}
 
 	ret = btrfs_add_link(trans, dir, inode, name, 1, index);
@@ -1860,9 +1853,9 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	bool update_size = true;
 	bool name_added = false;
 
-	dir = read_one_inode(root, key->objectid);
-	if (!dir)
-		return -EIO;
+	dir = btrfs_iget_logging(key->objectid, root);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
 
 	ret = read_alloc_one_name(eb, di + 1, btrfs_dir_name_len(eb, di), &name);
 	if (ret)
@@ -2162,9 +2155,10 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 	btrfs_dir_item_key_to_cpu(eb, di, &location);
 	btrfs_release_path(path);
 	btrfs_release_path(log_path);
-	inode = read_one_inode(root, location.objectid);
-	if (!inode) {
-		ret = -EIO;
+	inode = btrfs_iget_logging(location.objectid, root);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		inode = NULL;
 		goto out;
 	}
 
@@ -2316,14 +2310,17 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 	if (!log_path)
 		return -ENOMEM;
 
-	dir = read_one_inode(root, dirid);
-	/* it isn't an error if the inode isn't there, that can happen
-	 * because we replay the deletes before we copy in the inode item
-	 * from the log
+	dir = btrfs_iget_logging(dirid, root);
+	/*
+	 * It isn't an error if the inode isn't there, that can happen because
+	 * we replay the deletes before we copy in the inode item from the log.
 	 */
-	if (!dir) {
+	if (IS_ERR(dir)) {
 		btrfs_free_path(log_path);
-		return 0;
+		ret = PTR_ERR(dir);
+		if (ret == -ENOENT)
+			ret = 0;
+		return ret;
 	}
 
 	range_start = 0;
@@ -2482,9 +2479,9 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 				struct btrfs_inode *inode;
 				u64 from;
 
-				inode = read_one_inode(root, key.objectid);
-				if (!inode) {
-					ret = -EIO;
+				inode = btrfs_iget_logging(key.objectid, root);
+				if (IS_ERR(inode)) {
+					ret = PTR_ERR(inode);
 					break;
 				}
 				from = ALIGN(i_size_read(&inode->vfs_inode),
-- 
2.39.5



