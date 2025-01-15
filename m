Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEEA248BD1;
	Wed, 15 Jan 2025 10:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938560; cv=none; b=CiV5B7uYPL45AfjkjAxuektSX5rV0a3KhSI+KBZVQDd9KGf0XEmG/0Qhtu4CtWJ07mALChX/QGKPWuweO4I026TLUCBu43xbKjFkTYyr7FiIHH353/ZgpBC16qbX2+wThLeQWITYAbELxeivpba2ADYTG/rY4uGjSfcoRt84WqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938560; c=relaxed/simple;
	bh=6VTsGb7oshLBdQCGYVmI1KhVlcE3w35RzixBWnlEG60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ichaVCFaXtAsIC0H+zk2KgN8tBd6OGLCz7vQL1igBipV4XebRxe7zHepYMxaAT900Wxi8W284g2aiBlegjsk1spGF+EiXABqemw4xyzIqVbz3T2wMH2z+PRQjgskuwe635IG+xO+VICOgJ+CR6cNHQ4y2+M4sV8kTG2TUCHj6AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kepcVJ+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kepcVJ+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5908AC4CEDF;
	Wed, 15 Jan 2025 10:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938559;
	bh=6VTsGb7oshLBdQCGYVmI1KhVlcE3w35RzixBWnlEG60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kepcVJ+6RwTc9evhT0PNOfJf9XFCjWQFsBzCqIXe2hAdmwKynipQwFqB7RM4Wtj5M
	 /u31KLj10kYOkuSBfj6YoKkkPwm+h6zKxMbDHg3sCPUNekO5lSShkyc0jFBuO9ygWE
	 mCHDqSEYkYOFgSrmh95t0g59HKdMdaAJPCUMwFhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/129] ovl: do not encode lower fh with upper sb_writers held
Date: Wed, 15 Jan 2025 11:36:25 +0100
Message-ID: <20250115103554.776405922@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 5b02bfc1e7e3811c5bf7f0fa626a0694d0dbbd77 ]

When lower fs is a nested overlayfs, calling encode_fh() on a lower
directory dentry may trigger copy up and take sb_writers on the upper fs
of the lower nested overlayfs.

The lower nested overlayfs may have the same upper fs as this overlayfs,
so nested sb_writers lock is illegal.

Move all the callers that encode lower fh to before ovl_want_write().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Stable-dep-of: c45beebfde34 ("ovl: support encoding fid from inode with no alias")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c   | 53 +++++++++++++++++++++++++---------------
 fs/overlayfs/namei.c     | 37 +++++++++++++++++++++-------
 fs/overlayfs/overlayfs.h | 26 ++++++++++++++------
 fs/overlayfs/super.c     | 20 ++++++++++-----
 fs/overlayfs/util.c      | 10 ++++++++
 5 files changed, 104 insertions(+), 42 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ada3fcc9c6d5..5c9af24bae4a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -426,29 +426,29 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 	return ERR_PTR(err);
 }
 
-int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
-		   struct dentry *upper)
+struct ovl_fh *ovl_get_origin_fh(struct ovl_fs *ofs, struct dentry *origin)
 {
-	const struct ovl_fh *fh = NULL;
-	int err;
-
 	/*
 	 * When lower layer doesn't support export operations store a 'null' fh,
 	 * so we can use the overlay.origin xattr to distignuish between a copy
 	 * up and a pure upper inode.
 	 */
-	if (ovl_can_decode_fh(lower->d_sb)) {
-		fh = ovl_encode_real_fh(ofs, lower, false);
-		if (IS_ERR(fh))
-			return PTR_ERR(fh);
-	}
+	if (!ovl_can_decode_fh(origin->d_sb))
+		return NULL;
+
+	return ovl_encode_real_fh(ofs, origin, false);
+}
+
+int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
+		      struct dentry *upper)
+{
+	int err;
 
 	/*
 	 * Do not fail when upper doesn't support xattrs.
 	 */
 	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
 				 fh ? fh->fb.len : 0, 0);
-	kfree(fh);
 
 	/* Ignore -EPERM from setting "user.*" on symlink/special */
 	return err == -EPERM ? 0 : err;
@@ -476,7 +476,7 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
  *
  * Caller must hold i_mutex on indexdir.
  */
-static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
+static int ovl_create_index(struct dentry *dentry, const struct ovl_fh *fh,
 			    struct dentry *upper)
 {
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
@@ -502,7 +502,7 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 	if (WARN_ON(ovl_test_flag(OVL_INDEX, d_inode(dentry))))
 		return -EIO;
 
-	err = ovl_get_index_name(ofs, origin, &name);
+	err = ovl_get_index_name_fh(fh, &name);
 	if (err)
 		return err;
 
@@ -541,6 +541,7 @@ struct ovl_copy_up_ctx {
 	struct dentry *destdir;
 	struct qstr destname;
 	struct dentry *workdir;
+	const struct ovl_fh *origin_fh;
 	bool origin;
 	bool indexed;
 	bool metacopy;
@@ -637,7 +638,7 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	 * hard link.
 	 */
 	if (c->origin) {
-		err = ovl_set_origin(ofs, c->lowerpath.dentry, temp);
+		err = ovl_set_origin_fh(ofs, c->origin_fh, temp);
 		if (err)
 			return err;
 	}
@@ -749,7 +750,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 		goto cleanup;
 
 	if (S_ISDIR(c->stat.mode) && c->indexed) {
-		err = ovl_create_index(c->dentry, c->lowerpath.dentry, temp);
+		err = ovl_create_index(c->dentry, c->origin_fh, temp);
 		if (err)
 			goto cleanup;
 	}
@@ -861,6 +862,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 {
 	int err;
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
+	struct dentry *origin = c->lowerpath.dentry;
+	struct ovl_fh *fh = NULL;
 	bool to_index = false;
 
 	/*
@@ -877,17 +880,25 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 			to_index = true;
 	}
 
-	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || to_index)
+	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || to_index) {
+		fh = ovl_get_origin_fh(ofs, origin);
+		if (IS_ERR(fh))
+			return PTR_ERR(fh);
+
+		/* origin_fh may be NULL */
+		c->origin_fh = fh;
 		c->origin = true;
+	}
 
 	if (to_index) {
 		c->destdir = ovl_indexdir(c->dentry->d_sb);
-		err = ovl_get_index_name(ofs, c->lowerpath.dentry, &c->destname);
+		err = ovl_get_index_name(ofs, origin, &c->destname);
 		if (err)
-			return err;
+			goto out_free_fh;
 	} else if (WARN_ON(!c->parent)) {
 		/* Disconnected dentry must be copied up to index dir */
-		return -EIO;
+		err = -EIO;
+		goto out_free_fh;
 	} else {
 		/*
 		 * Mark parent "impure" because it may now contain non-pure
@@ -895,7 +906,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		 */
 		err = ovl_set_impure(c->parent, c->destdir);
 		if (err)
-			return err;
+			goto out_free_fh;
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
@@ -927,6 +938,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 out:
 	if (to_index)
 		kfree(c->destname.name);
+out_free_fh:
+	kfree(fh);
 	return err;
 }
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 80391c687c2a..f10ac4ae35f0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -507,6 +507,19 @@ static int ovl_verify_fh(struct ovl_fs *ofs, struct dentry *dentry,
 	return err;
 }
 
+int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
+		      enum ovl_xattr ox, const struct ovl_fh *fh,
+		      bool is_upper, bool set)
+{
+	int err;
+
+	err = ovl_verify_fh(ofs, dentry, ox, fh);
+	if (set && err == -ENODATA)
+		err = ovl_setxattr(ofs, dentry, ox, fh->buf, fh->fb.len);
+
+	return err;
+}
+
 /*
  * Verify that @real dentry matches the file handle stored in xattr @name.
  *
@@ -515,9 +528,9 @@ static int ovl_verify_fh(struct ovl_fs *ofs, struct dentry *dentry,
  *
  * Return 0 on match, -ESTALE on mismatch, -ENODATA on no xattr, < 0 on error.
  */
-int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
-		      enum ovl_xattr ox, struct dentry *real, bool is_upper,
-		      bool set)
+int ovl_verify_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry,
+			    enum ovl_xattr ox, struct dentry *real,
+			    bool is_upper, bool set)
 {
 	struct inode *inode;
 	struct ovl_fh *fh;
@@ -530,9 +543,7 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
 		goto fail;
 	}
 
-	err = ovl_verify_fh(ofs, dentry, ox, fh);
-	if (set && err == -ENODATA)
-		err = ovl_setxattr(ofs, dentry, ox, fh->buf, fh->fb.len);
+	err = ovl_verify_set_fh(ofs, dentry, ox, fh, is_upper, set);
 	if (err)
 		goto fail;
 
@@ -548,6 +559,7 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
 	goto out;
 }
 
+
 /* Get upper dentry from index */
 struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index,
 			       bool connected)
@@ -684,7 +696,7 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	goto out;
 }
 
-static int ovl_get_index_name_fh(struct ovl_fh *fh, struct qstr *name)
+int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr *name)
 {
 	char *n, *s;
 
@@ -873,20 +885,27 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 			  struct dentry *lower, struct dentry *upper)
 {
+	const struct ovl_fh *fh;
 	int err;
 
 	if (ovl_check_origin_xattr(ofs, upper))
 		return 0;
 
+	fh = ovl_get_origin_fh(ofs, lower);
+	if (IS_ERR(fh))
+		return PTR_ERR(fh);
+
 	err = ovl_want_write(dentry);
 	if (err)
-		return err;
+		goto out;
 
-	err = ovl_set_origin(ofs, lower, upper);
+	err = ovl_set_origin_fh(ofs, fh, upper);
 	if (!err)
 		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
 
 	ovl_drop_write(dentry);
+out:
+	kfree(fh);
 	return err;
 }
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 09ca82ed0f8c..61e03d664d7d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -632,11 +632,15 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
 int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 			struct dentry *upperdentry, struct ovl_path **stackp);
 int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
-		      enum ovl_xattr ox, struct dentry *real, bool is_upper,
-		      bool set);
+		      enum ovl_xattr ox, const struct ovl_fh *fh,
+		      bool is_upper, bool set);
+int ovl_verify_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry,
+			    enum ovl_xattr ox, struct dentry *real,
+			    bool is_upper, bool set);
 struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index,
 			       bool connected);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
+int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr *name);
 int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
 		       struct qstr *name);
 struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
@@ -648,17 +652,24 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
 
+static inline int ovl_verify_origin_fh(struct ovl_fs *ofs, struct dentry *upper,
+				       const struct ovl_fh *fh, bool set)
+{
+	return ovl_verify_set_fh(ofs, upper, OVL_XATTR_ORIGIN, fh, false, set);
+}
+
 static inline int ovl_verify_origin(struct ovl_fs *ofs, struct dentry *upper,
 				    struct dentry *origin, bool set)
 {
-	return ovl_verify_set_fh(ofs, upper, OVL_XATTR_ORIGIN, origin,
-				 false, set);
+	return ovl_verify_origin_xattr(ofs, upper, OVL_XATTR_ORIGIN, origin,
+				       false, set);
 }
 
 static inline int ovl_verify_upper(struct ovl_fs *ofs, struct dentry *index,
 				   struct dentry *upper, bool set)
 {
-	return ovl_verify_set_fh(ofs, index, OVL_XATTR_UPPER, upper, true, set);
+	return ovl_verify_origin_xattr(ofs, index, OVL_XATTR_UPPER, upper,
+				       true, set);
 }
 
 /* readdir.c */
@@ -823,8 +834,9 @@ int ovl_copy_xattr(struct super_block *sb, const struct path *path, struct dentr
 int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 				  bool is_upper);
-int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
-		   struct dentry *upper);
+struct ovl_fh *ovl_get_origin_fh(struct ovl_fs *ofs, struct dentry *origin);
+int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
+		      struct dentry *upper);
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2c056d737c27..e2574034c3fa 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -879,15 +879,20 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 {
 	struct vfsmount *mnt = ovl_upper_mnt(ofs);
 	struct dentry *indexdir;
+	struct dentry *origin = ovl_lowerstack(oe)->dentry;
+	const struct ovl_fh *fh;
 	int err;
 
+	fh = ovl_get_origin_fh(ofs, origin);
+	if (IS_ERR(fh))
+		return PTR_ERR(fh);
+
 	err = mnt_want_write(mnt);
 	if (err)
-		return err;
+		goto out_free_fh;
 
 	/* Verify lower root is upper root origin */
-	err = ovl_verify_origin(ofs, upperpath->dentry,
-				ovl_lowerstack(oe)->dentry, true);
+	err = ovl_verify_origin_fh(ofs, upperpath->dentry, fh, true);
 	if (err) {
 		pr_err("failed to verify upper root origin\n");
 		goto out;
@@ -919,9 +924,10 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 		 * directory entries.
 		 */
 		if (ovl_check_origin_xattr(ofs, ofs->indexdir)) {
-			err = ovl_verify_set_fh(ofs, ofs->indexdir,
-						OVL_XATTR_ORIGIN,
-						upperpath->dentry, true, false);
+			err = ovl_verify_origin_xattr(ofs, ofs->indexdir,
+						      OVL_XATTR_ORIGIN,
+						      upperpath->dentry, true,
+						      false);
 			if (err)
 				pr_err("failed to verify index dir 'origin' xattr\n");
 		}
@@ -939,6 +945,8 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 
 out:
 	mnt_drop_write(mnt);
+out_free_fh:
+	kfree(fh);
 	return err;
 }
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0bf3ffcd072f..4e6b747e0f2e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -976,12 +976,18 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	struct dentry *index = NULL;
 	struct inode *inode;
 	struct qstr name = { };
+	bool got_write = false;
 	int err;
 
 	err = ovl_get_index_name(ofs, lowerdentry, &name);
 	if (err)
 		goto fail;
 
+	err = ovl_want_write(dentry);
+	if (err)
+		goto fail;
+
+	got_write = true;
 	inode = d_inode(upperdentry);
 	if (!S_ISDIR(inode->i_mode) && inode->i_nlink != 1) {
 		pr_warn_ratelimited("cleanup linked index (%pd2, ino=%lu, nlink=%u)\n",
@@ -1019,6 +1025,8 @@ static void ovl_cleanup_index(struct dentry *dentry)
 		goto fail;
 
 out:
+	if (got_write)
+		ovl_drop_write(dentry);
 	kfree(name.name);
 	dput(index);
 	return;
@@ -1089,6 +1097,8 @@ void ovl_nlink_end(struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 
+	ovl_drop_write(dentry);
+
 	if (ovl_test_flag(OVL_INDEX, inode) && inode->i_nlink == 0) {
 		const struct cred *old_cred;
 
-- 
2.39.5



