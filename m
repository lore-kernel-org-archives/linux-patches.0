Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0413C1F46;
	Sat, 12 Sep 2026 09:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204426; cv=none; b=jddGwBt/j2DAPDmqmZZ6yRVLc4BAONRsQb4LJ+JinyBgCphQWCAAYCoSsbMoO2AL4V9JMm2hxo3xw4ktaSSnbX7HnDK1+HaE7ZjUjCsmI8oUvqbkqdqY529+WvQjIgnZNtjuozJg8SBAvvzZzJKlTpxEXVg68hyGVqnzyIPGmpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204426; c=relaxed/simple;
	bh=cAfxYmvGLRF74LcmhPqk6Qo01jD0gp+E11twrdg0ws4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoiUKH6hHpm0uHq5KZvZwec9b+TnglRc1YLQnrLM55hzahr3LP005wvjiPuhHJoqe1YpjGUbOsiJ7PZu2LwdouLyFJSsvN6nlboKQJE7OzXjgDdKnk3i29CvkXqY13MetOMg8r7tgIMLkF2POWiV0cPQivRG0litVVKqlTKSb5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7KS5gD1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7KS5gD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DF61F000FF;
	Sat, 12 Sep 2026 09:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204424;
	bh=Xjltke/Wol1YHhpHFPJFSgG8J7CKGJRwbBQ80uqTCDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7KS5gD1z6MBg/XgXhIRqeWVtqLYlS3xhf+UQbZzZoxhN3l1tVajT7E82k1YfvZDm
	 khChViX5JeNYWswNGUzpMUW6Uzcv3P+lfPfJkmheqTatk77uSy//MXQHUqF0DM+rQk
	 49d27wilujLm8d3Y1KCQWinBaq6jEhI4/g5ort48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1611/1815] ntfs: respect per-file chmod mode over mount masks
Date: Sat, 12 Sep 2026 08:56:01 +0200
Message-ID: <20260912065726.811853027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 4d730a4dd78caa7bf29dda36fa5340a0237a8689 ]

fmask and dmask provide the default permissions for files without WSL
metadata. Once chmod stores a mode in $LXMOD, however, that per-file mode
must take precedence so selected files can retain permissions such as
execute across remounts.

Record whether $LXMOD was found while loading an inode and apply the mount
masks only when it is absent. Do not remask the in-memory mode after
setattr persists it. Continue loading $LXMOD even when optional $LXUID or
$LXGID metadata is missing, since chmod may create only $LXMOD.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c    | 20 +++++++++-----------
 fs/ntfs/ea.h    |  3 ++-
 fs/ntfs/file.c  | 10 ++++------
 fs/ntfs/inode.c | 15 +++++++++------
 fs/ntfs/namei.c |  4 ----
 5 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index d0044c61152af..a1784c0a725fc 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -406,37 +406,35 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
  * Check for the presence of an EA "$LXDEV" (used by WSL)
  * and return its value as a device address
  */
-int ntfs_ea_get_wsl_inode(struct inode *inode, dev_t *rdevp, unsigned int flags)
+int ntfs_ea_get_wsl_inode(struct inode *inode, dev_t *rdevp, unsigned int flags,
+			  bool *has_lxmod)
 {
 	int err;
 	__le32 v;
 
+	*has_lxmod = false;
+
 	if (!(flags & NTFS_VOL_UID)) {
 		/* Load uid to lxuid EA */
 		err = ntfs_get_ea(inode, "$LXUID", sizeof("$LXUID") - 1, &v,
 				sizeof(v));
-		if (err < 0)
-			return err;
-		if (err != sizeof(v))
-			return -EIO;
-		i_uid_write(inode, le32_to_cpu(v));
+		if (err == sizeof(v))
+			i_uid_write(inode, le32_to_cpu(v));
 	}
 
 	if (!(flags & NTFS_VOL_GID)) {
 		/* Load gid to lxgid EA */
 		err = ntfs_get_ea(inode, "$LXGID", sizeof("$LXGID") - 1, &v,
 				sizeof(v));
-		if (err < 0)
-			return err;
-		if (err != sizeof(v))
-			return -EIO;
-		i_gid_write(inode, le32_to_cpu(v));
+		if (err == sizeof(v))
+			i_gid_write(inode, le32_to_cpu(v));
 	}
 
 	/* Load mode to lxmod EA */
 	err = ntfs_get_ea(inode, "$LXMOD", sizeof("$LXMOD") - 1, &v, sizeof(v));
 	if (err == sizeof(v)) {
 		inode->i_mode = le32_to_cpu(v);
+		*has_lxmod = true;
 	} else {
 		/* Everyone gets all permissions. */
 		inode->i_mode |= 0777;
diff --git a/fs/ntfs/ea.h b/fs/ntfs/ea.h
index 1f63bd55e057b..acb39c2a6fbc8 100644
--- a/fs/ntfs/ea.h
+++ b/fs/ntfs/ea.h
@@ -10,7 +10,8 @@
 extern const struct xattr_handler *const ntfs_xattr_handlers[];
 
 int ntfs_ea_set_wsl_not_symlink(struct ntfs_inode *ni, mode_t mode, dev_t dev);
-int ntfs_ea_get_wsl_inode(struct inode *inode, dev_t *rdevp, unsigned int flags);
+int ntfs_ea_get_wsl_inode(struct inode *inode, dev_t *rdevp, unsigned int flags,
+			  bool *has_lxmod);
 int ntfs_ea_set_wsl_inode(struct inode *inode, dev_t rdev, __le16 *ea_size,
 		unsigned int flags);
 ssize_t ntfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 6a7b638e523d9..7c1cf27bcaad8 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -346,14 +346,12 @@ int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		if (ia_valid & ATTR_MODE)
 			flags |= NTFS_EA_MODE;
 
-		if (S_ISDIR(vi->i_mode))
-			vi->i_mode &= ~vol->dmask;
-		else
-			vi->i_mode &= ~vol->fmask;
-
 		mutex_lock(&ni->mrec_lock);
-		ntfs_ea_set_wsl_inode(vi, 0, NULL, flags);
+		err = ntfs_ea_set_wsl_inode(vi, 0, NULL, flags);
 		mutex_unlock(&ni->mrec_lock);
+		if (err)
+			goto out;
+
 	}
 
 	mark_inode_dirty(vi);
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 7381a18cfadd9..1c9f6cf3ea1d8 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -682,6 +682,7 @@ static int ntfs_read_locked_inode(struct inode *vi)
 	unsigned int name_len = 4, flags = 0;
 	int extend_sys = 0;
 	dev_t dev = 0;
+	bool has_lxmod = false;
 	bool vol_err = true;
 
 	ntfs_debug("Entering for i_ino 0x%llx.", ni->mft_no);
@@ -862,7 +863,7 @@ static int ntfs_read_locked_inode(struct inode *vi)
 	err = ntfs_attr_lookup(AT_EA_INFORMATION, NULL, 0, 0, 0, NULL, 0, ctx);
 	if (!err) {
 		NInoSetHasEA(ni);
-		ntfs_ea_get_wsl_inode(vi, &dev, flags);
+		ntfs_ea_get_wsl_inode(vi, &dev, flags, &has_lxmod);
 	}
 
 	if (ni->flags & FILE_ATTR_REPARSE_POINT) {
@@ -886,16 +887,18 @@ static int ntfs_read_locked_inode(struct inode *vi)
 
 	if (S_ISDIR(vi->i_mode)) {
 		/*
-		 * Apply the directory permissions mask set in the mount
-		 * options.
+		 * Apply the directory permissions mask set in the mount options
+		 * when no per-file WSL mode is present.
 		 */
-		vi->i_mode &= ~vol->dmask;
+		if (!has_lxmod)
+			vi->i_mode &= ~vol->dmask;
 		/* Things break without this kludge! */
 		if (vi->i_nlink > 1)
 			set_nlink(vi, 1);
 	} else {
-		/* Apply the file permissions mask set in the mount options. */
-		vi->i_mode &= ~vol->fmask;
+		/* Apply the file permissions mask when no WSL mode is present. */
+		if (!has_lxmod)
+			vi->i_mode &= ~vol->fmask;
 	}
 
 	/*
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index aee7aabaf0598..96045face63f9 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -424,8 +424,6 @@ static struct ntfs_inode *__ntfs_create(struct mnt_idmap *idmap, struct inode *d
 	 * directories, also setup the index values to the defaults.
 	 */
 	if (S_ISDIR(mode)) {
-		mode &= ~vol->dmask;
-
 		NInoSetMstProtected(ni);
 		ni->itype.index.block_size = 4096;
 		ni->itype.index.block_size_bits = ntfs_ffs(4096) - 1;
@@ -439,8 +437,6 @@ static struct ntfs_inode *__ntfs_create(struct mnt_idmap *idmap, struct inode *d
 			ni->itype.index.vcn_size_bits =
 				vol->sector_size_bits;
 		}
-	} else {
-		mode &= ~vol->fmask;
 	}
 
 	if (IS_RDONLY(vi))
-- 
2.53.0



