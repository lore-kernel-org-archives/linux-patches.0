Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F354FD789;
	Tue, 13 Oct 2026 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895520; cv=none; b=Bt60ymx3r0/fdBe0Gn7XqhrOtORbD98nXctgedY0TlCRJEexD75yVi7kvbZEMlD2+Cv2UCNPTKmO+z4cOrjkg4YFL+u7gvWhIC1H5vFGB6IH97FIC/JBv7rCD8PQPa2cjRcaBGFqMd3fhP9IimW61CUp+FS5jY9D2rqs4lTmtYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895520; c=relaxed/simple;
	bh=k3+7xWlx0wB55sDzTSfDBHh6ZZA6tsMUCe5qpyZxBLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XP2OFlk+oz0c15vp8p7E14G9sQ3l1zDz+H3iavksKd+cVeIcj1XCElz56F+g9qD1cKVj3d09mEapabcj+Pp9sc2DnAgtEb+kJqRvyn1r2OWufGzVR5HRxZ6SjFXdokYHt9cJLyTmxpUafHAOpNZ9oykz9KuFvE5DcOlmFHH42fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyMMXBJj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyMMXBJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB10D1F000FF;
	Tue, 13 Oct 2026 12:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895519;
	bh=QjIbii84zsatVvu3WR0XEqhXKgZNnijhO7mOcbLLrYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pyMMXBJj6cAl0j+0WFXp/nq8RQJtk4U16TeGpToMo32cqtR4xHY/O2tAd+qDyb1+U
	 ZAvErknWiVfWlDMOpLbXMEUG+SXoF6Fr6WxTqzMhAsLP1GQaoa0tIG8bOJpfNfeu4c
	 Px68MW+C5BUUEGiyUNTYKbE2LEIhF31qAoud10Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/497] fs,fsverity: reject size changes on fsverity files in setattr_prepare
Date: Tue, 13 Oct 2026 13:37:22 +0200
Message-ID: <20261013112914.420717273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit e9734653c523c744f03333ece6ae7a315187f05c upstream.

Add the check to reject truncates of fsverity files directly to
setattr_prepare instead of requiring the file system to handle it.
Besides removing boilerplate code, this also fixes the complete lack of
such check in btrfs.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://lore.kernel.org/r/20260128152630.627409-2-hch@lst.de
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/attr.c                | 12 +++++++++++-
 fs/ext4/inode.c          |  4 ----
 fs/f2fs/file.c           |  4 ----
 fs/verity/open.c         |  8 --------
 include/linux/fsverity.h | 25 -------------------------
 5 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index c04d19b58f122..714f159d58ea3 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -169,7 +169,17 @@ int setattr_prepare(struct mnt_idmap *idmap, struct dentry *dentry,
 	 * ATTR_FORCE.
 	 */
 	if (ia_valid & ATTR_SIZE) {
-		int error = inode_newsize_ok(inode, attr->ia_size);
+		int error;
+
+		/*
+		 * Verity files are immutable, so deny truncates.  This isn't
+		 * covered by the open-time check because sys_truncate() takes a
+		 * path, not an open file.
+		 */
+		if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode))
+			return -EPERM;
+
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fa303effb18a0..24b5925a7c7ef 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5444,10 +5444,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (error)
 		return error;
 
-	error = fsverity_prepare_setattr(dentry, attr);
-	if (error)
-		return error;
-
 	if (is_quota_modification(idmap, inode, attr)) {
 		error = dquot_initialize(inode);
 		if (error)
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index a7ad5e02433c5..b4bd73648a014 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1078,10 +1078,6 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (err)
 		return err;
 
-	err = fsverity_prepare_setattr(dentry, attr);
-	if (err)
-		return err;
-
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
diff --git a/fs/verity/open.c b/fs/verity/open.c
index fdeb95eca3af3..bd0497da5cea3 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -392,14 +392,6 @@ int __fsverity_file_open(struct inode *inode, struct file *filp)
 }
 EXPORT_SYMBOL_GPL(__fsverity_file_open);
 
-int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr)
-{
-	if (attr->ia_valid & ATTR_SIZE)
-		return -EPERM;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__fsverity_prepare_setattr);
-
 void __fsverity_cleanup_inode(struct inode *inode)
 {
 	fsverity_free_info(inode->i_verity_info);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 1eb7eae580be7..139a6f5c62171 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -149,7 +149,6 @@ int fsverity_get_digest(struct inode *inode,
 /* open.c */
 
 int __fsverity_file_open(struct inode *inode, struct file *filp);
-int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 void __fsverity_cleanup_inode(struct inode *inode);
 
 /**
@@ -214,12 +213,6 @@ static inline int __fsverity_file_open(struct inode *inode, struct file *filp)
 	return -EOPNOTSUPP;
 }
 
-static inline int __fsverity_prepare_setattr(struct dentry *dentry,
-					     struct iattr *attr)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline void fsverity_cleanup_inode(struct inode *inode)
 {
 }
@@ -301,22 +294,4 @@ static inline int fsverity_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-/**
- * fsverity_prepare_setattr() - prepare to change a verity inode's attributes
- * @dentry: dentry through which the inode is being changed
- * @attr: attributes to change
- *
- * Verity files are immutable, so deny truncates.  This isn't covered by the
- * open-time check because sys_truncate() takes a path, not a file descriptor.
- *
- * Return: 0 on success, -errno on failure
- */
-static inline int fsverity_prepare_setattr(struct dentry *dentry,
-					   struct iattr *attr)
-{
-	if (IS_VERITY(d_inode(dentry)))
-		return __fsverity_prepare_setattr(dentry, attr);
-	return 0;
-}
-
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.53.0



