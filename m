Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA6C1E0083;
	Wed,  6 Nov 2024 13:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898101; cv=none; b=i9mGUCZNt0oabvMPFAEk8sx/6mhH1SAhRdh/XgEMD6MDdVvvO4JNnq9q7C4tr2zbIBhyw9/n8yp1+UlPCBZBU8F3ZPRDRBk+fXqmTxGromgLXFu/8/6AxbGtiq3PbJmsS01FZebXhLWeOTLmLgDNJqrj5sxC8IU3EWtGNTrO8OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898101; c=relaxed/simple;
	bh=/IHjhv9JaV9VSodPH4XDGbg5pSF9agdc8TP3+x37Do0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+hx2JhGS7VMGKyRqGbj0Q7c8+L0yLt3gYXKwYQLA3ZUxuOphgzHBUdEyFMrtlVmAkQHD5cBjmfBJXnOaFV4lfQTEH6HuLIf8kEZ+aFPgHCHdDhRpXDFutTOsHo5lFPBKsyzRb6vx0lnL0fK7trBE/SlRtlaFl46GbbZv30fv5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfnTB3Gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfnTB3Gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB43C4CECD;
	Wed,  6 Nov 2024 13:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898101;
	bh=/IHjhv9JaV9VSodPH4XDGbg5pSF9agdc8TP3+x37Do0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfnTB3GiLI8YHerOcm+vxvNHD9wuIV4zBMktOs2RmaPIHeGM7Kp6xEop2f8Xv6wya
	 5DkNNr8gg9XLIH/atCWabeus+8kw9B83Zs5Kz9DNKkn79u3DwFhxfiQqIyANNxVm93
	 uWa9eZYZGQF4KimjPas+6MakAPl67obLPM5cAlSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/462] f2fs: enhance to update i_mode and acl atomically in f2fs_setattr()
Date: Wed,  6 Nov 2024 13:00:18 +0100
Message-ID: <20241106120334.594611952@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 17232e830afb800acdcc22ae8980bf9d330393ef ]

Previously, in f2fs_setattr(), we don't update S_ISUID|S_ISGID|S_ISVTX
bits with S_IRWXUGO bits and acl entries atomically, so in error path,
chmod() may partially success, this patch enhances to make chmod() flow
being atomical.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aaf8c0b9ae04 ("f2fs: reduce expensive checkpoint trigger frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/acl.c   | 23 ++++++++++++++++++++++-
 fs/f2fs/file.c  |  6 ++++--
 fs/f2fs/xattr.c | 15 +++++++++------
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 217b290ae3a55..51313fe36d018 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -200,6 +200,27 @@ struct posix_acl *f2fs_get_acl(struct inode *inode, int type)
 	return __f2fs_get_acl(inode, type, NULL);
 }
 
+static int f2fs_acl_update_mode(struct inode *inode, umode_t *mode_p,
+			  struct posix_acl **acl)
+{
+	umode_t mode = inode->i_mode;
+	int error;
+
+	if (is_inode_flag_set(inode, FI_ACL_MODE))
+		mode = F2FS_I(inode)->i_acl_mode;
+
+	error = posix_acl_equiv_mode(*acl, &mode);
+	if (error < 0)
+		return error;
+	if (error == 0)
+		*acl = NULL;
+	if (!in_group_p(inode->i_gid) &&
+	    !capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		mode &= ~S_ISGID;
+	*mode_p = mode;
+	return 0;
+}
+
 static int __f2fs_set_acl(struct inode *inode, int type,
 			struct posix_acl *acl, struct page *ipage)
 {
@@ -213,7 +234,7 @@ static int __f2fs_set_acl(struct inode *inode, int type,
 	case ACL_TYPE_ACCESS:
 		name_index = F2FS_XATTR_INDEX_POSIX_ACL_ACCESS;
 		if (acl && !ipage) {
-			error = posix_acl_update_mode(inode, &mode, &acl);
+			error = f2fs_acl_update_mode(inode, &mode, &acl);
 			if (error)
 				return error;
 			set_acl_inode(inode, mode);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2330600dbe02e..ce17f39268598 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -863,8 +863,10 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (attr->ia_valid & ATTR_MODE) {
 		err = posix_acl_chmod(inode, f2fs_get_inode_mode(inode));
-		if (err || is_inode_flag_set(inode, FI_ACL_MODE)) {
-			inode->i_mode = F2FS_I(inode)->i_acl_mode;
+
+		if (is_inode_flag_set(inode, FI_ACL_MODE)) {
+			if (!err)
+				inode->i_mode = F2FS_I(inode)->i_acl_mode;
 			clear_inode_flag(inode, FI_ACL_MODE);
 		}
 	}
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index cef2825ff069b..95b2c05a7035d 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -654,7 +654,7 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 		}
 
 		if (value && f2fs_xattr_value_same(here, value, size))
-			goto exit;
+			goto same;
 	} else if ((flags & XATTR_REPLACE)) {
 		error = -ENODATA;
 		goto exit;
@@ -734,17 +734,20 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	if (error)
 		goto exit;
 
-	if (is_inode_flag_set(inode, FI_ACL_MODE)) {
-		inode->i_mode = F2FS_I(inode)->i_acl_mode;
-		inode->i_ctime = current_time(inode);
-		clear_inode_flag(inode, FI_ACL_MODE);
-	}
 	if (index == F2FS_XATTR_INDEX_ENCRYPTION &&
 			!strcmp(name, F2FS_XATTR_NAME_ENCRYPTION_CONTEXT))
 		f2fs_set_encrypted_inode(inode);
 	f2fs_mark_inode_dirty_sync(inode, true);
 	if (!error && S_ISDIR(inode->i_mode))
 		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_CP);
+
+same:
+	if (is_inode_flag_set(inode, FI_ACL_MODE)) {
+		inode->i_mode = F2FS_I(inode)->i_acl_mode;
+		inode->i_ctime = current_time(inode);
+		clear_inode_flag(inode, FI_ACL_MODE);
+	}
+
 exit:
 	kvfree(base_addr);
 	return error;
-- 
2.43.0



