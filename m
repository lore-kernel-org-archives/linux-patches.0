Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3EE2AF07;
	Mon, 28 Oct 2024 06:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098534; cv=none; b=JxFxepNrrB+Zl0bNEImrDDNb9Q6ASYzJRqgCmlLJT2iandwBviuuPao95Xp0U/O1JmcgycxTin68RzQLlxJ96nIYQb7gq+IdWZyOcc/VgBxqbhtNQX9V+rfYACBhm8O8yYLCo+5PEJ9fko8dn0+0QlyheWgC6eg5Rvqn3rWNleg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098534; c=relaxed/simple;
	bh=+NQmCE20NmaE2HQj8OffZcePwLLY4cAxxVb/k/XIODk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPlDYmdy93o7OCP1aKCm73y3NmpUa+/erRTTcBUMWYcwL5Wm966EsFwQj+KoqVqj2XKAHWg28lBLvzW8CPakWjcNOjvZolqiPFAaaQeh/qyi35w3bIi0KlNYh3feNHV/I4NqOXefxUz1PPDc0HqdRzK4boVvdgAVRxDaAH2pMJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKBHLd2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKBHLd2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB5DC4CEC3;
	Mon, 28 Oct 2024 06:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098534;
	bh=+NQmCE20NmaE2HQj8OffZcePwLLY4cAxxVb/k/XIODk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKBHLd2QJjs57L2yL2BoQALE9eR2PVARLms7RGgNNkQTUfg5GVbDwfhdTMDCyxt6v
	 eTCAzPvRBNZ6ObRm3oLbPYGVP1BaenNJa3+6qEEwfvQGTb1kMAjh3b4FFD0EPAt2zq
	 qbf4WNzMf2BMzrda2eecDeoYSR4P83aMyGR+fC7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.11 251/261] Revert " fs/9p: mitigate inode collisions"
Date: Mon, 28 Oct 2024 07:26:33 +0100
Message-ID: <20241028062318.399053077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

commit f69999b5f9b444a2443ca2b9e5976e78bb5b7c69 upstream.

This reverts commit d05dcfdf5e1659b2949d13060284eff3888b644e.

This is a requirement to revert commit 724a08450f74 ("fs/9p: simplify
iget to remove unnecessary paths"), see that revert for details.

Fixes: 724a08450f74 ("fs/9p: simplify iget to remove unnecessary paths")
Reported-by: Will Deacon <will@kernel.org>
Link: https://lkml.kernel.org/r/20240923100508.GA32066@willie-the-truck
Cc: stable@vger.kernel.org # v6.9+
Message-ID: <20241024-revert_iget-v1-1-4cac63d25f72@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/v9fs.h           |   11 +++++------
 fs/9p/vfs_inode.c      |   37 ++++++++-----------------------------
 fs/9p/vfs_inode_dotl.c |   28 ++++++++--------------------
 fs/9p/vfs_super.c      |    2 +-
 4 files changed, 22 insertions(+), 56 deletions(-)

--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -179,14 +179,13 @@ extern int v9fs_vfs_rename(struct mnt_id
 			   struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry,
 			   unsigned int flags);
-extern struct inode *v9fs_fid_iget(struct super_block *sb, struct p9_fid *fid,
-						bool new);
+extern struct inode *v9fs_fid_iget(struct super_block *sb, struct p9_fid *fid);
 extern const struct inode_operations v9fs_dir_inode_operations_dotl;
 extern const struct inode_operations v9fs_file_inode_operations_dotl;
 extern const struct inode_operations v9fs_symlink_inode_operations_dotl;
 extern const struct netfs_request_ops v9fs_req_ops;
 extern struct inode *v9fs_fid_iget_dotl(struct super_block *sb,
-						struct p9_fid *fid, bool new);
+					struct p9_fid *fid);
 
 /* other default globals */
 #define V9FS_PORT	564
@@ -225,12 +224,12 @@ static inline int v9fs_proto_dotl(struct
  */
 static inline struct inode *
 v9fs_get_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
-			struct super_block *sb, bool new)
+			struct super_block *sb)
 {
 	if (v9fs_proto_dotl(v9ses))
-		return v9fs_fid_iget_dotl(sb, fid, new);
+		return v9fs_fid_iget_dotl(sb, fid);
 	else
-		return v9fs_fid_iget(sb, fid, new);
+		return v9fs_fid_iget(sb, fid);
 }
 
 #endif
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -365,8 +365,7 @@ void v9fs_evict_inode(struct inode *inod
 		clear_inode(inode);
 }
 
-struct inode *
-v9fs_fid_iget(struct super_block *sb, struct p9_fid *fid, bool new)
+struct inode *v9fs_fid_iget(struct super_block *sb, struct p9_fid *fid)
 {
 	dev_t rdev;
 	int retval;
@@ -378,18 +377,8 @@ v9fs_fid_iget(struct super_block *sb, st
 	inode = iget_locked(sb, QID2INO(&fid->qid));
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW)) {
-		if (!new) {
-			goto done;
-		} else {
-			p9_debug(P9_DEBUG_VFS, "WARNING: Inode collision %ld\n",
-						inode->i_ino);
-			iput(inode);
-			remove_inode_hash(inode);
-			inode = iget_locked(sb, QID2INO(&fid->qid));
-			WARN_ON(!(inode->i_state & I_NEW));
-		}
-	}
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	/*
 	 * initialize the inode with the stat info
@@ -413,11 +402,11 @@ v9fs_fid_iget(struct super_block *sb, st
 	v9fs_set_netfs_context(inode);
 	v9fs_cache_inode_get_cookie(inode);
 	unlock_new_inode(inode);
-done:
 	return inode;
 error:
 	iget_failed(inode);
 	return ERR_PTR(retval);
+
 }
 
 /**
@@ -449,15 +438,8 @@ static int v9fs_at_to_dotl_flags(int fla
  */
 static void v9fs_dec_count(struct inode *inode)
 {
-	if (!S_ISDIR(inode->i_mode) || inode->i_nlink > 2) {
-		if (inode->i_nlink) {
-			drop_nlink(inode);
-		} else {
-			p9_debug(P9_DEBUG_VFS,
-						"WARNING: unexpected i_nlink zero %d inode %ld\n",
-						inode->i_nlink, inode->i_ino);
-		}
-	}
+	if (!S_ISDIR(inode->i_mode) || inode->i_nlink > 2)
+		drop_nlink(inode);
 }
 
 /**
@@ -508,9 +490,6 @@ static int v9fs_remove(struct inode *dir
 		} else
 			v9fs_dec_count(inode);
 
-		if (inode->i_nlink <= 0)	/* no more refs unhash it */
-			remove_inode_hash(inode);
-
 		v9fs_invalidate_inode_attr(inode);
 		v9fs_invalidate_inode_attr(dir);
 
@@ -576,7 +555,7 @@ v9fs_create(struct v9fs_session_info *v9
 		/*
 		 * instantiate inode and assign the unopened fid to the dentry
 		 */
-		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb, true);
+		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			p9_debug(P9_DEBUG_VFS,
@@ -705,7 +684,7 @@ struct dentry *v9fs_vfs_lookup(struct in
 	else if (IS_ERR(fid))
 		inode = ERR_CAST(fid);
 	else
-		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb, false);
+		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
 	/*
 	 * If we had a rename on the server and a parallel lookup
 	 * for the new name, then make sure we instantiate with
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -52,10 +52,7 @@ static kgid_t v9fs_get_fsgid_for_create(
 	return current_fsgid();
 }
 
-
-
-struct inode *
-v9fs_fid_iget_dotl(struct super_block *sb, struct p9_fid *fid, bool new)
+struct inode *v9fs_fid_iget_dotl(struct super_block *sb, struct p9_fid *fid)
 {
 	int retval;
 	struct inode *inode;
@@ -65,18 +62,8 @@ v9fs_fid_iget_dotl(struct super_block *s
 	inode = iget_locked(sb, QID2INO(&fid->qid));
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW)) {
-		if (!new) {
-			goto done;
-		} else { /* deal with race condition in inode number reuse */
-			p9_debug(P9_DEBUG_ERROR, "WARNING: Inode collision %lx\n",
-						inode->i_ino);
-			iput(inode);
-			remove_inode_hash(inode);
-			inode = iget_locked(sb, QID2INO(&fid->qid));
-			WARN_ON(!(inode->i_state & I_NEW));
-		}
-	}
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	/*
 	 * initialize the inode with the stat info
@@ -103,11 +90,12 @@ v9fs_fid_iget_dotl(struct super_block *s
 		goto error;
 
 	unlock_new_inode(inode);
-done:
+
 	return inode;
 error:
 	iget_failed(inode);
 	return ERR_PTR(retval);
+
 }
 
 struct dotl_openflag_map {
@@ -259,7 +247,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
 		goto out;
 	}
-	inode = v9fs_fid_iget_dotl(dir->i_sb, fid, true);
+	inode = v9fs_fid_iget_dotl(dir->i_sb, fid);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		p9_debug(P9_DEBUG_VFS, "inode creation failed %d\n", err);
@@ -352,7 +340,7 @@ static int v9fs_vfs_mkdir_dotl(struct mn
 	}
 
 	/* instantiate inode and assign the unopened fid to the dentry */
-	inode = v9fs_fid_iget_dotl(dir->i_sb, fid, true);
+	inode = v9fs_fid_iget_dotl(dir->i_sb, fid);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		p9_debug(P9_DEBUG_VFS, "inode creation failed %d\n",
@@ -788,7 +776,7 @@ v9fs_vfs_mknod_dotl(struct mnt_idmap *id
 			 err);
 		goto error;
 	}
-	inode = v9fs_fid_iget_dotl(dir->i_sb, fid, true);
+	inode = v9fs_fid_iget_dotl(dir->i_sb, fid);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		p9_debug(P9_DEBUG_VFS, "inode creation failed %d\n",
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -139,7 +139,7 @@ static struct dentry *v9fs_mount(struct
 	else
 		sb->s_d_op = &v9fs_dentry_operations;
 
-	inode = v9fs_get_inode_from_fid(v9ses, fid, sb, true);
+	inode = v9fs_get_inode_from_fid(v9ses, fid, sb);
 	if (IS_ERR(inode)) {
 		retval = PTR_ERR(inode);
 		goto release_sb;


