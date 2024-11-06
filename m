Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A1F1DEFF5;
	Wed,  6 Nov 2024 12:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895178; cv=none; b=PWYP36zWxR/mzqtst6VMXynAJM2eeRPXVVIYmNZfjuTCdH/2hc+l21UajBM7N/JQlnwGzrsKYJtOF8z06yHy9lJ3I7yQw0yE/lrKvzrJCyDBiNx/sY55t57OZWC1F8N8LZCx6+LhPzNMhLml645v3EIJ+vbXdWiE7jgxBTwAkbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895178; c=relaxed/simple;
	bh=WZ/GpjUDnb6yOCpuQEGtPWd29AYJyZ6D15S4h98PvbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CN3i7JkwoRlnqhopVgwr08ryufRcA751WixvN2fKvQZm9daksHUVM4b0ag99RwYxxLTnKMRYMjdxFdynbuNg85LZAla562zRKIZ5maWuVBM6Bs8AdZnI/GExebDzwu6NcKKLU+Z2HwmCuqnK0Y3/q1GHbl27N63/40R8KvzzOR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiKNOiJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiKNOiJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228C6C4CED3;
	Wed,  6 Nov 2024 12:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895178;
	bh=WZ/GpjUDnb6yOCpuQEGtPWd29AYJyZ6D15S4h98PvbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiKNOiJk3nVKvgALHT1/LZNnQ8hPW1RUmORJiu9clpqFufjxWhZpxjyJZEmYw+5fK
	 AZCEZ4qAKn+y/ww4MgrN5QIaX8zEhlrBXxkSoPo/0sU8C9vLd5U7Hu6qb3NqMO0dGy
	 Gzkdy4rKtMJyMRVBpaFzR9Ucf1ozCuZUvF7jcKag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/350] f2fs: enhance to update i_mode and acl atomically in f2fs_setattr()
Date: Wed,  6 Nov 2024 13:00:22 +0100
Message-ID: <20241106120323.222611023@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b9fe937a3c701..cc53d4c80b0a9 100644
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
index 043ce96ac1270..e44cb6bf68b9e 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -839,8 +839,10 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 
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
index db3e76b35607b..496a9e70cb091 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -651,7 +651,7 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 		}
 
 		if (value && f2fs_xattr_value_same(here, value, size))
-			goto exit;
+			goto same;
 	} else if ((flags & XATTR_REPLACE)) {
 		error = -ENODATA;
 		goto exit;
@@ -729,17 +729,20 @@ static int __f2fs_setxattr(struct inode *inode, int index,
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
 	kzfree(base_addr);
 	return error;
-- 
2.43.0



