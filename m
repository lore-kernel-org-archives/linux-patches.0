Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215295;
	b=UI8wMBeOJrXl9ePgUq7wmqljrUKTaokYvl+X8uyLnE38a2HVIVNtVoGig/oIytKBOR5l
	 qDtiynvpXD2NhDcpY24IauhZ9OSu2Vr5/88LkF59ychsodAp1Y3xjsDYh6Agl2tALJdVg
	 BZrIPCncB5lKqUMIthIkF3zGpeyRf+c0zEKYAKH/Zqo/qPwaIUXqj9+FUivFZzsWsvy5X
	 bBn9vGoKaJxlJq2PYnmByDJID361pcWc9RlnHjI0je5sVcWd+hStz8wnomcsyVABcPX3x
	 conuCEIV4WwCogjVtYNxddzQsVgapapNf3pmqCXEc+Ql6U+wOqMyYbBUNJGwSl0GmsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q0xbhZp/JywKVzltoP93OH2p93hUGUHvgfD74Wk9N/8=;
	b=RN7zyDFhxbg6R/aHeZLFFcw3F6/cNVf3ZDSSP32tCa+lYnaqqDMMv4uZqyJFsWyqH92k
	 ZZOAlbgdXWsqjGebxOZZ/PQBHhX5xwqS7FxZ+qQo690KmM53YNz+Pn/a0GFhLkYs2ZRWH
	 ma1zuKWNJyKr0eV55X/jM9YyqB6r0QagdgDLSIc/HIlZ/kQL1BYYDtsB8TpaNUcdGoLXo
	 JeOtOGEoANK75f+Ri8efOABJAl4qzSRiPBGO4+p0dzDb+ZV3o91FVpjJCAjicIrFjL168
	 ys0CekJLTFpuZDZkgw6uI9rBzLBIo3DZaU2ECCn4uHSiryNwrZ9GQM+jstRxf+kAG0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZmadR0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90191606A326;
	Wed, 28 Oct 2026 19:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZmadR0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9571F01825;
	Wed, 28 Oct 2026 19:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215295;
	bh=q0xbhZp/JywKVzltoP93OH2p93hUGUHvgfD74Wk9N/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZmadR0CGygkLGpqCZbeYl+w9k1xRJx+PbCekjhUM39cczzBn4XLW1QZwNmN4ZirE
	 +XBi9fIrFFKD6lNrAo7V0QkGNi+S+mMT/oE1oYUsgORWx7LtE/5zuEBWNTmWK8N8av
	 FQhq9lVrGOyER5F16rxGuYraZWqhRGcJvgH3w4uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1161/1887] ksmbd: fix path resolution in ksmbd_vfs_kern_path_create
Date: Wed, 28 Oct 2026 17:54:17 +0100
Message-ID: <20261028170525.824848415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/misc.c | 33 -------------------------------
 fs/smb/server/misc.h |  1 -
 fs/smb/server/vfs.c  | 47 ++++++++++++++++++++++++++++++++++++++------
 3 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 11314f7c622a6..98da57bb5fd29 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -284,39 +284,6 @@ char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename)
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
index 29247726d9d27..67989d577aeda 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1321,15 +1321,50 @@ struct dentry *ksmbd_vfs_kern_path_create(struct ksmbd_work *work,
 					  unsigned int flags,
 					  struct path *path)
 {
-	char *abs_name;
+	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
+	struct filename *filename;
+	struct qstr last;
 	struct dentry *dent;
+	int err, type;
+
+	/* resolve the name beneath the share root so ".." cannot escape */
+	filename = getname_kernel(name);
+	if (IS_ERR(filename))
+		return ERR_CAST(filename);
+
+	err = vfs_path_parent_lookup(filename, flags | LOOKUP_BENEATH,
+				     path, &last, &type, &share_conf->vfs_path);
+	if (err) {
+		putname(filename);
+		return ERR_PTR(err);
+	}
+
+	if (unlikely(type != LAST_NORM)) {
+		path_put(path);
+		putname(filename);
+		return ERR_PTR(-EEXIST);
+	}
 
-	abs_name = convert_to_unix_name(work->tcon->share_conf, name);
-	if (!abs_name)
-		return ERR_PTR(-ENOMEM);
+	err = mnt_want_write(path->mnt);
+	if (err) {
+		path_put(path);
+		putname(filename);
+		return ERR_PTR(err);
+	}
 
-	dent = kern_path_create(AT_FDCWD, abs_name, path, flags);
-	kfree(abs_name);
+	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
+	dent = lookup_one_qstr_excl(&last, path->dentry,
+				    LOOKUP_CREATE | LOOKUP_EXCL);
+	if (!IS_ERR(dent) && d_is_positive(dent)) {
+		dput(dent);
+		dent = ERR_PTR(-EEXIST);
+	}
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



