Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5344EBACB;
	Fri,  9 Oct 2026 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557137; cv=none; b=eRYZYnXTxDUqo06JJN0RKzI/WXcnpt1aB8yBzmFqWZGUfQM2LhRY9nu5ZWDabCDnpMvEYizUExbpnTb+XvA13JlAWPxxM13OW0pE0LCCP371yTV6rYSBCkHioW0fiKe8ay23rT0U5juqiWccu8KPVKcG0Ef7cEYUJPqvJArQrnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557137; c=relaxed/simple;
	bh=CYoGtrtBuQ4JRUD1/HqL6mq4l9p0Bh0fqTBKPTNUU4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV69iEYW8Nz8TwANTKw6GaQ0iVb0Z337rA9SHfbLUSBm5cyWY2YAotYYc/ET9SyE0B5TOitwLMQi0YRJu0rYBzU5kb2xSvOVMHBdWbGLKQ/P3YPmP7UiF59127gZVJJrnCcgzwYHHaM1YfRJOR5AxdIbcEbgSu5TdQ7opiDovDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZQ/NFGf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZQ/NFGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4905F1F000FF;
	Fri,  9 Oct 2026 14:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557135;
	bh=B8Y8UljH/PdMLmUm6lYzDuErCrHNlydMZLUmM4XOrHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZQ/NFGfzMeiMRT3j4wDx4cnqQqEJEeexr1xZfGko0vADIuZNDgJ7kzNZCXczPXwT
	 0VlkuFiXUAmxRWLO/NUfF6yTax/EPlEQbFLWxj7SHu34MT8XWTiEAYwNjS8/Qiq6oS
	 75mBQaITDRvJ6jRbNRcCNXGHHAP1cDRZtSjAvh0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 352/403] fs,fsverity: reject size changes on fsverity files in setattr_prepare
Date: Fri,  9 Oct 2026 16:11:53 +0200
Message-ID: <20261009141000.508511127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c                |   12 +++++++++++-
 fs/ext4/inode.c          |    4 ----
 fs/f2fs/file.c           |    4 ----
 fs/verity/open.c         |    8 --------
 include/linux/fsverity.h |   25 -------------------------
 5 files changed, 11 insertions(+), 42 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -169,7 +169,17 @@ int setattr_prepare(struct mnt_idmap *id
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
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5898,10 +5898,6 @@ int ext4_setattr(struct mnt_idmap *idmap
 	if (error)
 		return error;
 
-	error = fsverity_prepare_setattr(dentry, attr);
-	if (error)
-		return error;
-
 	if (is_quota_modification(idmap, inode, attr)) {
 		error = dquot_initialize(inode);
 		if (error)
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1123,10 +1123,6 @@ int f2fs_setattr(struct mnt_idmap *idmap
 	if (err)
 		return err;
 
-	err = fsverity_prepare_setattr(dentry, attr);
-	if (err)
-		return err;
-
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -384,14 +384,6 @@ int __fsverity_file_open(struct inode *i
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
 	struct fsverity_info **vi_addr = fsverity_info_addr(inode);
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -179,7 +179,6 @@ int fsverity_get_digest(struct inode *in
 /* open.c */
 
 int __fsverity_file_open(struct inode *inode, struct file *filp);
-int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 void __fsverity_cleanup_inode(struct inode *inode);
 
 /**
@@ -251,12 +250,6 @@ static inline int __fsverity_file_open(s
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
@@ -338,22 +331,4 @@ static inline int fsverity_file_open(str
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


