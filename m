Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C134E36E9;
	Wed, 30 Sep 2026 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787951; cv=none; b=icJocv1uHWOO/DS8cmYKneBO11J2kziZiiIY6EsQaW67g8srUthnLeurqYtNY5ZxBiI/dNecPN/TC4aJpLvIrSzIqhTxbSZl+8XbkpU0rIW29YnURHCFly05vo0UIbBqCfUk26+1TinrSQLNAubMf+FBcYvnGlooFnhVu2csXrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787951; c=relaxed/simple;
	bh=5VIk4Rev+pfGcl9lI/f6WVCd8i50kEtsE4pfHUowew8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwpE0rvc0uCXMFywDVwFor/Iq2oo/JIjrbY10QrMjbcLQwOZuna4D7Jj2XHVDDDMgioV5klrVF/YhWR2e/gRgnjKOoSfXBsAj9iu13RlTooItjG9Cb88GMNoWvLGrsESUW250epxtBWQ2uOAhN7ccNpWLj5fBPQ8YZsHSpHnvvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w48ip3n+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w48ip3n+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A571A1F000FF;
	Wed, 30 Sep 2026 17:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787950;
	bh=aTcmTYmdHVtTihBqGFTzZODzDbxFGcgfl8qMAU+5Uuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w48ip3n+3isCVIk3k4BjHKn426x+GCWEaF1f+2jga8NTGZaW34e50dbY0QHkBi7yX
	 l8+VHJuXlY7DiFftPC2vMgOVRlj5Z0m450iLIHVapO1Id+bH9QQaWUQ4dGaFEKzI21
	 hKwKCAwkAdyCFgiQztHHlWxATv/57wiX/vdKCV4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 412/457] smb: client: use finish_no_open() for non-regular inodes
Date: Wed, 30 Sep 2026 17:28:37 +0200
Message-ID: <20260930152354.880584246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

commit e66cf1625ec4a3fe68346119f371def713fd0a4d upstream.

An O_CREAT open can find an existing symlink or another non-regular
inode. cifs_atomic_open() calls finish_open() on it and attaches a
cifsFileInfo. Symlink inodes have no CIFS release operation, so the
dentry reference held by cifsFileInfo is leaked. FMODE_OPENED also
prevents the VFS from following the symlink.

Track whether cifs_do_create() returned an open server handle. For
non-regular inodes, close the handle if present, remove the pending
open, and call finish_no_open() so the VFS can continue the lookup.
Do not set FMODE_CREATED unless a regular file was opened. For
O_NOFOLLOW with __O_REGULAR, return -ELOOP before the VFS's
-EFTYPE check.

Defer closing a legacy POSIX handle on a non-regular inode until
after inode lookup. This avoids closing it again if lookup fails.

Fixes: d2c127197dfc ("cifs: implement i_op->atomic_open()")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dir.c |   52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -203,7 +203,7 @@ static int __cifs_do_create(struct inode
 			    struct tcon_link *tlink, unsigned int oflags,
 			    umode_t mode, __u32 *oplock, struct cifs_fid *fid,
 			    struct cifs_open_info_data *buf,
-			    struct inode **inode)
+			    struct inode **inode, bool *opened)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
@@ -220,6 +220,7 @@ static int __cifs_do_create(struct inode
 	__le32 lease_flags = 0;
 
 	*inode = NULL;
+	*opened = false;
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
 		*oplock = REQ_OPLOCK;
@@ -236,6 +237,7 @@ static int __cifs_do_create(struct inode
 				     oflags, oplock, &fid->netfid, xid);
 		switch (rc) {
 		case 0:
+			*opened = true;
 			if (newinode == NULL) {
 				/* query inode info */
 				goto cifs_create_get_file_info;
@@ -257,11 +259,9 @@ static int __cifs_do_create(struct inode
 				/*
 				 * The server may allow us to open things like
 				 * FIFOs, but the client isn't set up to deal
-				 * with that. If it's not a regular file, just
-				 * close it and proceed as if it were a normal
-				 * lookup.
+				 * with that. Keep the handle until the caller
+				 * can finish the lookup.
 				 */
-				CIFSSMBClose(xid, tcon, fid->netfid);
 				goto cifs_create_get_file_info;
 			}
 			/* success, no need to query */
@@ -388,6 +388,7 @@ retry_open:
 		}
 		return rc;
 	}
+	*opened = true;
 	if (rdwr_for_fscache == 2)
 		cifs_invalidate_cache(dir, FSCACHE_INVAL_DIO_WRITE);
 
@@ -479,7 +480,7 @@ cifs_create_set_dentry:
 	return rc;
 
 out_err:
-	if (server->ops->close)
+	if (*opened && server->ops->close)
 		server->ops->close(xid, tcon, fid);
 	if (newinode)
 		iput(newinode);
@@ -491,7 +492,7 @@ static int cifs_do_create(struct inode *
 			  unsigned int oflags, umode_t mode,
 			  __u32 *oplock, struct cifs_fid *fid,
 			  struct cifs_open_info_data *buf,
-			  struct inode **inode)
+			  struct inode **inode, bool *opened)
 {
 	void *page = alloc_dentry_path();
 	const char *full_path;
@@ -500,10 +501,11 @@ static int cifs_do_create(struct inode *
 	full_path = build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
 		rc = PTR_ERR(full_path);
+		*opened = false;
 	} else {
 		rc = __cifs_do_create(dir, direntry, full_path, xid,
 				      tlink, oflags, mode, oplock,
-				      fid, buf, inode);
+				      fid, buf, inode, opened);
 	}
 	free_dentry_path(page);
 	return rc;
@@ -533,6 +535,8 @@ int cifs_atomic_open(struct inode *dir,
 	struct inode *inode;
 	unsigned int xid;
 	__u32 oplock;
+	bool is_regular;
+	bool opened;
 	int rc;
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
@@ -585,12 +589,26 @@ int cifs_atomic_open(struct inode *dir,
 	cifs_add_pending_open(&fid, tlink, &open);
 
 	rc = cifs_do_create(dir, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid, &buf, &inode);
+			    &oplock, &fid, &buf, &inode, &opened);
 	if (rc) {
 		cifs_del_pending_open(&open);
 		goto out;
 	}
 
+	is_regular = S_ISREG(inode->i_mode);
+	if (!is_regular || !opened) {
+		if (opened && server->ops->close)
+			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
+		if (S_ISLNK(inode->i_mode) &&
+		    (oflags & (O_NOFOLLOW | __O_REGULAR)) ==
+		    (O_NOFOLLOW | __O_REGULAR) && !(oflags & O_EXCL)) {
+			iput(inode);
+			rc = -ELOOP;
+			goto out;
+		}
+	}
+
 	if (d_in_lookup(direntry)) {
 		alias = d_splice_alias(inode, direntry);
 		if (!IS_ERR_OR_NULL(alias))
@@ -599,9 +617,15 @@ int cifs_atomic_open(struct inode *dir,
 		d_instantiate(direntry, inode);
 	}
 
-	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+	if (is_regular && opened &&
+	    (oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
 		file->f_mode |= FMODE_CREATED;
 
+	if (!is_regular || !opened) {
+		rc = finish_no_open(file, NULL);
+		goto out;
+	}
+
 	rc = finish_open(file, direntry, generic_file_open);
 	if (rc) {
 		if (server->ops->close)
@@ -664,6 +688,7 @@ int cifs_create(struct mnt_idmap *idmap,
 	struct inode *inode;
 	struct cifs_fid fid;
 	__u32 oplock;
+	bool opened;
 	struct cifs_open_info_data buf = {};
 
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
@@ -686,10 +711,10 @@ int cifs_create(struct mnt_idmap *idmap,
 		server->ops->new_lease_key(&fid);
 
 	rc = cifs_do_create(dir, direntry, xid, tlink, oflags,
-			    mode, &oplock, &fid, &buf, &inode);
+			    mode, &oplock, &fid, &buf, &inode, &opened);
 	if (!rc) {
 		d_instantiate(direntry, inode);
-		if (server->ops->close)
+		if (opened && server->ops->close)
 			server->ops->close(xid, tcon, &fid);
 	}
 
@@ -1082,6 +1107,7 @@ int cifs_tmpfile(struct mnt_idmap *idmap
 	struct inode *inode;
 	unsigned int xid;
 	__u32 oplock;
+	bool opened;
 	int namelen;
 	int rc;
 
@@ -1120,7 +1146,7 @@ int cifs_tmpfile(struct mnt_idmap *idmap
 		namelen = scnprintf(name, namesize, CIFS_TMPNAME_PREFIX "%x",
 				    atomic_inc_return(&cifs_tmpcounter));
 		rc = __cifs_do_create(dir, dentry, path, xid, tlink, oflags,
-				      mode, &oplock, &fid, NULL, &inode);
+				      mode, &oplock, &fid, NULL, &inode, &opened);
 		if (!rc) {
 			rc = d_mark_tmpfile_name(file, &QSTR_LEN(name, namelen));
 			if (rc) {


