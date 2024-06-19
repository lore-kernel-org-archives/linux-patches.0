Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C9D13AA40;
	Wed, 19 Jun 2024 13:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802373; cv=none; b=Knbq+6G4ZwtCBpIC5vPvI1vkLRA1rJWy+iWaeG7IfAFa6SB5wkh4xij+Sze1LcdaJlSMXWn48Rs3KcOKh0Ddkex850tEBFtUQjq/qPWEbxk5dNHbVfNlIS4PAGT4jARiHOPwPTIy07Hu+3uLjucdA71+Svo7DKy5CwwPDy54N7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802373; c=relaxed/simple;
	bh=3+xFgaNhOsiAgwNt1bN7SVgR0HPjqr5BBLK7UbtBLOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N26OpaaMmStvsNsb4ZA1lZzhhYyDG9+xnFeuOTI0Ks/bRMuj4Aqp0MPUYy6nuUins6WY2UxXqGM6vp58rjrP++CanmGTo5U/Kgie2nN7QNy+NmRP7DO0my32lrjSRSFa2ccZ11W5azSm50eF9V8z1MAXUBFv9E2Ma3DVl4mhKUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSD0Ez3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSD0Ez3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0122EC4AF1A;
	Wed, 19 Jun 2024 13:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802373;
	bh=3+xFgaNhOsiAgwNt1bN7SVgR0HPjqr5BBLK7UbtBLOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSD0Ez3uieAnZ7aYoX8S3sQF3JMpwx2BYDuyI1myVFwF9OLRtSCAC0AwggXLtJmwq
	 hr/OOwcu6CVcd00PntWwC0j1+WlC/h2+NJ2AhjglE/Nb0OJhNS5EdsC0FGAG497ZBl
	 sD+x7CHiBdJE9TcKu0ODAmWDdSXBOzMPUgBHKwY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 174/267] ksmbd: fix missing use of get_write in in smb2_set_ea()
Date: Wed, 19 Jun 2024 14:55:25 +0200
Message-ID: <20240619125613.020649614@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 2bfc4214c69c62da13a9da8e3c3db5539da2ccd3 upstream.

Fix an issue where get_write is not used in smb2_set_ea().

Fixes: 6fc0a265e1b9 ("ksmbd: fix potential circular locking issue in smb2_set_ea()")
Cc: stable@vger.kernel.org
Reported-by: Wang Zhaolong <wangzhaolong1@huawei.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c   |    7 ++++---
 fs/smb/server/vfs.c       |   17 +++++++++++------
 fs/smb/server/vfs.h       |    3 ++-
 fs/smb/server/vfs_cache.c |    3 ++-
 4 files changed, 19 insertions(+), 11 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2367,7 +2367,8 @@ static int smb2_set_ea(struct smb2_ea_in
 			if (rc > 0) {
 				rc = ksmbd_vfs_remove_xattr(idmap,
 							    path,
-							    attr_name);
+							    attr_name,
+							    get_write);
 
 				if (rc < 0) {
 					ksmbd_debug(SMB,
@@ -2382,7 +2383,7 @@ static int smb2_set_ea(struct smb2_ea_in
 		} else {
 			rc = ksmbd_vfs_setxattr(idmap, path, attr_name, value,
 						le16_to_cpu(eabuf->EaValueLength),
-						0, true);
+						0, get_write);
 			if (rc < 0) {
 				ksmbd_debug(SMB,
 					    "ksmbd_vfs_setxattr is failed(%d)\n",
@@ -2474,7 +2475,7 @@ static int smb2_remove_smb_xattrs(const
 		    !strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
 			     STREAM_PREFIX_LEN)) {
 			err = ksmbd_vfs_remove_xattr(idmap, path,
-						     name);
+						     name, true);
 			if (err)
 				ksmbd_debug(SMB, "remove xattr failed : %s\n",
 					    name);
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1053,16 +1053,21 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_fi
 }
 
 int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
-			   const struct path *path, char *attr_name)
+			   const struct path *path, char *attr_name,
+			   bool get_write)
 {
 	int err;
 
-	err = mnt_want_write(path->mnt);
-	if (err)
-		return err;
+	if (get_write == true) {
+		err = mnt_want_write(path->mnt);
+		if (err)
+			return err;
+	}
 
 	err = vfs_removexattr(idmap, path->dentry, attr_name);
-	mnt_drop_write(path->mnt);
+
+	if (get_write == true)
+		mnt_drop_write(path->mnt);
 
 	return err;
 }
@@ -1375,7 +1380,7 @@ int ksmbd_vfs_remove_sd_xattrs(struct mn
 		ksmbd_debug(SMB, "%s, len %zd\n", name, strlen(name));
 
 		if (!strncmp(name, XATTR_NAME_SD, XATTR_NAME_SD_LEN)) {
-			err = ksmbd_vfs_remove_xattr(idmap, path, name);
+			err = ksmbd_vfs_remove_xattr(idmap, path, name, true);
 			if (err)
 				ksmbd_debug(SMB, "remove xattr failed : %s\n", name);
 		}
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -114,7 +114,8 @@ int ksmbd_vfs_setxattr(struct mnt_idmap
 int ksmbd_vfs_xattr_stream_name(char *stream_name, char **xattr_stream_name,
 				size_t *xattr_stream_name_size, int s_type);
 int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
-			   const struct path *path, char *attr_name);
+			   const struct path *path, char *attr_name,
+			   bool get_write);
 int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 			       unsigned int flags, struct path *parent_path,
 			       struct path *path, bool caseless);
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -254,7 +254,8 @@ static void __ksmbd_inode_close(struct k
 		ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
 		err = ksmbd_vfs_remove_xattr(file_mnt_idmap(filp),
 					     &filp->f_path,
-					     fp->stream.name);
+					     fp->stream.name,
+					     true);
 		if (err)
 			pr_err("remove xattr failed : %s\n",
 			       fp->stream.name);


