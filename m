Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670A236F90C;
	Sat, 17 Oct 2026 17:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259010; cv=none; b=R9SeVMcYqZNX5qZ6MOuat9eP1L13SWgCO8DsA1aG4oCxwoC0CLOZ9fd0OEY8qMUH0BJ73OrteKNd8j7pQQQ82lRsMBd03kR27AbP/1sYniA4HxJmZMmPz+wah7HcPA78AtCTymGHRUcxr+uM0y0+7pMu7oFP8yqGWG4SqnMrMvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259010; c=relaxed/simple;
	bh=IvqXDQMmmZ4xqdwZSbCWUp095VCEViBal0BxjpLzLIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJYeTJOqVOWiT/ZiUkkBZZDCRaU/PEjilmiKUdzdx0Gwef9JxGvBaxHtQbffJV0Ae8uqyCvkOSwJ/T/oi+fpWnp10gaapmlTZMzDVH4hMIAuGnhQFbOxPFAB6TNaiNOtDyS2WHGEY7ClBYHrFDjxRBR5nbFvleMp8tyXn+xCArg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2oQ5CL6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2oQ5CL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23981F000C4;
	Sat, 17 Oct 2026 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259009;
	bh=zGVNfznNJkZkYJF4wxHSgOkbE/hSbOS5cEUoFN37tw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2oQ5CL6z8xVnFPDk5Mg7Vgad/k8KiRMifFboMu4ygNhbylkCPEQvEUfwEjgkFBkB
	 w2IFMUJjzSS2E5HhXp6jvmlStNLmksbqOogJQOUfLVMeG8kNy6m+h8BHbyyYicBI6i
	 qvGhXn47lTnABBksevkMejbwZPNUYTgH9I1UCSW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1073/1674] ksmbd: fix path resolution in ksmbd_vfs_kern_path_create
Date: Sat, 17 Oct 2026 17:55:45 +0200
Message-ID: <20261017160458.661129156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/misc.c | 33 ---------------------------------
 fs/smb/server/misc.h |  1 -
 fs/smb/server/vfs.c  | 36 ++++++++++++++++++++++++++++++------
 3 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 7cc4b84a49b30..79de46a0283ab 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -285,39 +285,6 @@ char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename)
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
-	new_name = kmalloc(path_len + name_len + 2, GFP_KERNEL);
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
diff --git a/fs/smb/server/misc.h b/fs/smb/server/misc.h
index 1facfcd21200f..53282a6d2436c 100644
--- a/fs/smb/server/misc.h
+++ b/fs/smb/server/misc.h
@@ -22,7 +22,6 @@ void ksmbd_strip_last_slash(char *path);
 void ksmbd_conv_path_to_windows(char *path);
 char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name);
 char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
-char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
 
 #define KSMBD_DIR_INFO_ALIGNMENT	8
 struct ksmbd_dir_info;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 642323a6aff6f..fd1697c2d6655 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1324,15 +1324,39 @@ struct dentry *ksmbd_vfs_kern_path_create(struct ksmbd_work *work,
 					  unsigned int flags,
 					  struct path *path)
 {
-	char *abs_name;
+	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
+	struct filename *filename;
+	struct qstr last;
 	struct dentry *dent;
+	int err;
 
-	abs_name = convert_to_unix_name(work->tcon->share_conf, name);
-	if (!abs_name)
-		return ERR_PTR(-ENOMEM);
+	/* resolve the name beneath the share root so ".." cannot escape */
+	filename = getname_kernel(name);
+	if (IS_ERR(filename))
+		return ERR_CAST(filename);
+
+	err = vfs_path_parent_lookup(filename, flags | LOOKUP_BENEATH,
+				     path, &last, &share_conf->vfs_path);
+	if (err) {
+		putname(filename);
+		return ERR_PTR(err);
+	}
 
-	dent = kern_path_create(AT_FDCWD, abs_name, path, flags);
-	kfree(abs_name);
+	err = mnt_want_write(path->mnt);
+	if (err) {
+		path_put(path);
+		putname(filename);
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
+	putname(filename);
 	return dent;
 }
 
-- 
2.53.0



