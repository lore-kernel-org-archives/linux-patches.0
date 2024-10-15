Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76781C07E5;
	Tue, 15 Oct 2024 13:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997451; cv=none; b=XXaW+2Xm93/FpE1TClqxSfxn5HjOJh/d0TW/+NSScfMQOl6TCCLrQ/2NMZRDgGNxE2dvd59vQcFcBhbJDc16qehTMgFy4xOp2epbl/IQ3Ex2eu97ivz6/9GKqfXAJQNp2ywOSj8X09n4frCjgBmnNon4IeYrPgOfg7qnuEUTpaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997451; c=relaxed/simple;
	bh=vgy44JlvBj6Y9FpijZZ40cC9DqoEZO/vfgw+Ey66UJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhrteuiCZANfzjTQJcGaFQU/tlJRBS4GWRKBzKaaWKOrms4WNtRDvX+bv1+mGB979c0PBh7PA8DvCZhP5oKGG8hy/kLlnO+mqNSliW/DT0Lphh2saETph7Pm6nBJjKCgo2OzLPtxtVRbBzU1sauXJuOWrmYdR5vnYU9xwa9zW3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+jM1yn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+jM1yn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA32C4CEC6;
	Tue, 15 Oct 2024 13:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997451;
	bh=vgy44JlvBj6Y9FpijZZ40cC9DqoEZO/vfgw+Ey66UJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+jM1yn54tyKxmTTPhXubU3+60uWCK1SOB9W9tTs+EOuI7O0I66Jf5/dfG98pCyQ2
	 /oXVhWFPYvyypIodS72E2vuVIpCeSqBMB7h8p/KizoiMu1CqTWsTq0Z0mzZqe0uk5D
	 4AGY79k+W1JxQxkhBBX3TuylIPasprfwLMXnWWJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/518] f2fs: enhance to update i_mode and acl atomically in f2fs_setattr()
Date: Tue, 15 Oct 2024 14:41:30 +0200
Message-ID: <20241015123924.165560369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index 3064135898276..a89b2b1390e86 100644
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
index 50514962771a1..8f7aa4010bb90 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -980,8 +980,10 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 
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
index dd50b747b671e..4271bcc2738d1 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -673,7 +673,7 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 		}
 
 		if (value && f2fs_xattr_value_same(here, value, size))
-			goto exit;
+			goto same;
 	} else if ((flags & XATTR_REPLACE)) {
 		error = -ENODATA;
 		goto exit;
@@ -753,17 +753,20 @@ static int __f2fs_setxattr(struct inode *inode, int index,
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
 	kfree(base_addr);
 	return error;
-- 
2.43.0



