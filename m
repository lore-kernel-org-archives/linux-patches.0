Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882941A3029;
	Tue, 21 Oct 2025 20:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077164; cv=none; b=IfkDC/B0geO6NzGQ60r2zBbrdp2P1HE6DCkupQ3M0Pfgn3nUPu5fut1gG6D16v/wZo416APU5BKiiLHgcUeqdUbiVLroj5WAyA5ZFe7zPLtzJpYcGLDgotCH8tGDgU8ftZxYPndsUjaqPPq2CcuNHgCZ5BTAXl2JqQoJfRj5XrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077164; c=relaxed/simple;
	bh=h/VbPAvq1GeJ1X8j6wOe1oGh1r/P1NJauQxKsz+99Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRazg95DUpFnn6wo7OwxWeL9QHeXgySHj58BEyudDNDVzNZ9bP4mTb3mQbMbprHQ7Hv4tE2KKw11B4tMkch0aDi79q7R20yRJCVy5q5GKOvS35hArwxLznpClH4Wji9jJsNtSDwfOWQ8MhZbW40fuaEyuIH/y6zixRtbpsJ/NN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pba0+XIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pba0+XIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18318C4CEF1;
	Tue, 21 Oct 2025 20:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077164;
	bh=h/VbPAvq1GeJ1X8j6wOe1oGh1r/P1NJauQxKsz+99Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pba0+XIU6Vwrhtngrl5qR1QL8WsrkRZCsC0iwFh0RyRTurs4PRhwr9d/a2Ziq+lwT
	 47rclGzUGB5Qjmrhf0mkwH7VeM8vqqs33mbDm5179eNmTvXc2G3iysw7L1JtFn9YKr
	 p0xjkhs9P1Y+In5eZZf+nG8f7/RngU7b/hsFQLWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.17 002/159] Revert "fs: make vfs_fileattr_[get|set] return -EOPNOTSUPP"
Date: Tue, 21 Oct 2025 21:49:39 +0200
Message-ID: <20251021195043.243572726@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Albershteyn <aalbersh@redhat.com>

commit 4dd5b5ac089bb6ea719b7ffb748707ac9cbce4e4 upstream.

This reverts commit 474b155adf3927d2c944423045757b54aa1ca4de.

This patch caused regression in ioctl_setflags(). Underlying filesystems
use EOPNOTSUPP to indicate that flag is not supported. This error is
also gets converted in ioctl_setflags(). Therefore, for unsupported
flags error changed from EOPNOSUPP to ENOIOCTLCMD.

Link: https://lore.kernel.org/linux-xfs/a622643f-1585-40b0-9441-cf7ece176e83@kernel.org/
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file_attr.c         | 12 ++----------
 fs/fuse/ioctl.c        |  4 ----
 fs/overlayfs/copy_up.c |  2 +-
 fs/overlayfs/inode.c   |  5 ++++-
 4 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 12424d4945d0..460b2dd21a85 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -84,7 +84,7 @@ int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	int error;
 
 	if (!inode->i_op->fileattr_get)
-		return -EOPNOTSUPP;
+		return -ENOIOCTLCMD;
 
 	error = security_inode_file_getattr(dentry, fa);
 	if (error)
@@ -270,7 +270,7 @@ int vfs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
 	int err;
 
 	if (!inode->i_op->fileattr_set)
-		return -EOPNOTSUPP;
+		return -ENOIOCTLCMD;
 
 	if (!inode_owner_or_capable(idmap, inode))
 		return -EPERM;
@@ -312,8 +312,6 @@ int ioctl_getflags(struct file *file, unsigned int __user *argp)
 	int err;
 
 	err = vfs_fileattr_get(file->f_path.dentry, &fa);
-	if (err == -EOPNOTSUPP)
-		err = -ENOIOCTLCMD;
 	if (!err)
 		err = put_user(fa.flags, argp);
 	return err;
@@ -335,8 +333,6 @@ int ioctl_setflags(struct file *file, unsigned int __user *argp)
 			fileattr_fill_flags(&fa, flags);
 			err = vfs_fileattr_set(idmap, dentry, &fa);
 			mnt_drop_write_file(file);
-			if (err == -EOPNOTSUPP)
-				err = -ENOIOCTLCMD;
 		}
 	}
 	return err;
@@ -349,8 +345,6 @@ int ioctl_fsgetxattr(struct file *file, void __user *argp)
 	int err;
 
 	err = vfs_fileattr_get(file->f_path.dentry, &fa);
-	if (err == -EOPNOTSUPP)
-		err = -ENOIOCTLCMD;
 	if (!err)
 		err = copy_fsxattr_to_user(&fa, argp);
 
@@ -371,8 +365,6 @@ int ioctl_fssetxattr(struct file *file, void __user *argp)
 		if (!err) {
 			err = vfs_fileattr_set(idmap, dentry, &fa);
 			mnt_drop_write_file(file);
-			if (err == -EOPNOTSUPP)
-				err = -ENOIOCTLCMD;
 		}
 	}
 	return err;
diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index 57032eadca6c..fdc175e93f74 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -536,8 +536,6 @@ int fuse_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 cleanup:
 	fuse_priv_ioctl_cleanup(inode, ff);
 
-	if (err == -ENOTTY)
-		err = -EOPNOTSUPP;
 	return err;
 }
 
@@ -574,7 +572,5 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
 cleanup:
 	fuse_priv_ioctl_cleanup(inode, ff);
 
-	if (err == -ENOTTY)
-		err = -EOPNOTSUPP;
 	return err;
 }
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index aac7e34f56c1..604a82acd164 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -178,7 +178,7 @@ static int ovl_copy_fileattr(struct inode *inode, const struct path *old,
 	err = ovl_real_fileattr_get(old, &oldfa);
 	if (err) {
 		/* Ntfs-3g returns -EINVAL for "no fileattr support" */
-		if (err == -EOPNOTSUPP || err == -EINVAL)
+		if (err == -ENOTTY || err == -EINVAL)
 			return 0;
 		pr_warn("failed to retrieve lower fileattr (%pd2, err=%i)\n",
 			old->dentry, err);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index aaa4cf579561..e11f310ce092 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -720,7 +720,10 @@ int ovl_real_fileattr_get(const struct path *realpath, struct file_kattr *fa)
 	if (err)
 		return err;
 
-	return vfs_fileattr_get(realpath->dentry, fa);
+	err = vfs_fileattr_get(realpath->dentry, fa);
+	if (err == -ENOIOCTLCMD)
+		err = -ENOTTY;
+	return err;
 }
 
 int ovl_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
-- 
2.51.1.dirty



