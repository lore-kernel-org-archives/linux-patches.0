Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806874DD6FD;
	Tue, 21 Jul 2026 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659516; cv=none; b=eC6ZuV+QUsUmDxNR13k6msaMGKJFv7r4/VjEJ6gLuUsnV4G2Vaz4JMBxjjkJWZwx3whlJi5iQqg43dkD7M4gHeWtvLHNq/tj2E2KbQvY2N4pwnmssOJabmcgUAX7zuGBEp3flVFUoROZ/MDvBY/FKz1xniO5kZ2vGT+dI70CCS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659516; c=relaxed/simple;
	bh=vGd2I432EPPD6jyMHXr2av98twMQSdT2LTQ855Gyk2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmCfHFca9QVr63mOqKjtLSWjkRjHqQGqEDJBc4Aaoea9O5k5PpohcEulBTe67ZKjbBeWQPqja7OP0lENxeW3+pYigywnXRsKtMPkXW7E3EzR61akEvB5Plgd4wE68HS+5MdOp5PGVrkYTB3JGWD+PuY21x8Zwt9CztkuErsEtPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km4NMaTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km4NMaTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E689B1F000E9;
	Tue, 21 Jul 2026 18:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659515;
	bh=NXDCZXAo+LiSbB5khcvpHkDaxEgNg2RJS9T3ao4vIk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=km4NMaTycJTJE3C7XKcqy8fSB++X0NL5ygw3dJLB+UoDC9j3qf8nPjfgKn5Rfz18V
	 891wBR3aW0ElZzukoskVFETsnqLZGKJZ7NCdi/L9pBTpKursMHsjEnSHGsYUvf5dfO
	 HN8MZ6oX8/5lzxh7fHDWc6KqZQChuQu2XLL5FJ0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1550/1611] ksmbd: fix path resolution in ksmbd_vfs_kern_path_create
Date: Tue, 21 Jul 2026 17:27:46 +0200
Message-ID: <20260721152550.317430261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Davide Ornaghi <d.ornaghi97@gmail.com>

[ Upstream commit 1c8951963d8ed357f70f59e0ad4ddce2199d2016 ]

The SMB2 open lookup is rooted at the share with LOOKUP_BENEATH, but the
create/mkdir/hardlink sink is not: ksmbd_vfs_kern_path_create() builds an
absolute path with convert_to_unix_name() and resolves it from AT_FDCWD
via start_creating_path(), so a ".." component is walked from the real
filesystem root and escapes the export.

An authenticated client races a missing path component so the rooted open
lookup returns -ENOENT (taking the create branch) while the same component
is present (a directory) when the create walk runs; the create then
resolves ".." out of the share.

Root the create walk at the share like the lookup and rename paths already
are: resolve the parent with vfs_path_parent_lookup(..., LOOKUP_BENEATH,
&share_conf->vfs_path) and create the final component with
start_creating_noperm(). convert_to_unix_name() then has no callers and is
removed.

Fixes: 265fd1991c1d ("ksmbd: use LOOKUP_BENEATH to prevent the out of share access")
Cc: stable@vger.kernel.org
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ replaced start_creating_noperm() and CLASS(filename_kernel) with open-coded getname_kernel()/inode_lock_nested()/lookup_one_qstr_excl() equivalents absent in 6.18 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/misc.c |   33 ---------------------------------
 fs/smb/server/misc.h |    1 -
 fs/smb/server/vfs.c  |   38 ++++++++++++++++++++++++++++++++------
 3 files changed, 32 insertions(+), 40 deletions(-)

--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -278,39 +278,6 @@ char *ksmbd_extract_sharename(struct uni
 	return ksmbd_casefold_sharename(um, name);
 }
 
-/**
- * convert_to_unix_name() - convert windows name to unix format
- * @share:	ksmbd_share_config pointer
- * @name:	file name that is relative to share
- *
- * Return:	converted name on success, otherwise NULL
- */
-char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name)
-{
-	int no_slash = 0, name_len, path_len;
-	char *new_name;
-
-	if (name[0] == '/')
-		name++;
-
-	path_len = share->path_sz;
-	name_len = strlen(name);
-	new_name = kmalloc(path_len + name_len + 2, KSMBD_DEFAULT_GFP);
-	if (!new_name)
-		return new_name;
-
-	memcpy(new_name, share->path, path_len);
-	if (new_name[path_len - 1] != '/') {
-		new_name[path_len] = '/';
-		no_slash = 1;
-	}
-
-	memcpy(new_name + path_len + no_slash, name, name_len);
-	path_len += name_len + no_slash;
-	new_name[path_len] = 0x00;
-	return new_name;
-}
-
 char *ksmbd_convert_dir_info_name(struct ksmbd_dir_info *d_info,
 				  const struct nls_table *local_nls,
 				  int *conv_len)
--- a/fs/smb/server/misc.h
+++ b/fs/smb/server/misc.h
@@ -22,7 +22,6 @@ void ksmbd_strip_last_slash(char *path);
 void ksmbd_conv_path_to_windows(char *path);
 char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name);
 char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
-char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
 
 #define KSMBD_DIR_INFO_ALIGNMENT	8
 struct ksmbd_dir_info;
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1338,15 +1338,41 @@ struct dentry *ksmbd_vfs_kern_path_creat
 					  unsigned int flags,
 					  struct path *path)
 {
-	char *abs_name;
+	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
+	struct filename *filename __free(putname) = NULL;
+	struct qstr last;
 	struct dentry *dent;
+	int err, type;
 
-	abs_name = convert_to_unix_name(work->tcon->share_conf, name);
-	if (!abs_name)
-		return ERR_PTR(-ENOMEM);
+	/* resolve the name beneath the share root so ".." cannot escape */
+	filename = getname_kernel(name);
+	if (IS_ERR(filename))
+		return ERR_CAST(filename);
 
-	dent = start_creating_path(AT_FDCWD, abs_name, path, flags);
-	kfree(abs_name);
+	err = vfs_path_parent_lookup(filename, flags | LOOKUP_BENEATH,
+				     path, &last, &type,
+				     &share_conf->vfs_path);
+	if (err)
+		return ERR_PTR(err);
+
+	if (unlikely(type != LAST_NORM)) {
+		path_put(path);
+		return ERR_PTR(-EINVAL);
+	}
+
+	err = mnt_want_write(path->mnt);
+	if (err) {
+		path_put(path);
+		return ERR_PTR(err);
+	}
+
+	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
+	dent = lookup_one_qstr_excl(&last, path->dentry, LOOKUP_CREATE);
+	if (IS_ERR(dent)) {
+		inode_unlock(path->dentry->d_inode);
+		mnt_drop_write(path->mnt);
+		path_put(path);
+	}
 	return dent;
 }
 


