Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208457;
	b=CqEZNv/rp4PglNqeE+XscBqPfKbxRaqZVDlrGX6m3GKlG5x5PVxiacdHcDv4iv9XhHSg
	 h5njuBAMA+LuwyqsWATjwhzbVcJxdwHbLnVsM/9A8rbObFyy4899GEtzMbncbvk3DwGIh
	 GmBcdUuBvNORjm2m1V2O4yIaDwiVsc3sKXG1Xd7ChxupsFe6hTiS/WAN7YiYut90rqCMR
	 KfUduMNQkF/o/RUGaTe2LPt8hyJytjQZ8SK8S74anbeZ6lTrCBmN6I8j4qR1kvzaCiABz
	 YOmlPF0JzFMhsdIgl1/WqDAtEBh9LvcncxSXI9RhQknR77aFJMw77rsqMyi68kNEIZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GJWkUTyKpgRw3O9r30fdQL1OaTYYWC0hYABO6Pssw0U=;
	b=XuBjbfvk5ts4O57ogAzGvQIrcn/eQLzP4cxTNG9f14vDgKngbHkqPysQDi5aQq7tiJk5
	 gm4Tz6EpPLElwGUaHUYDBLTLHmzFA09/Bog6jlT/0+J9v+QgrXpDUdom0P7K2uEOQEXGX
	 jPTmpDiBT6IXGajeezxrBzePi/1/F37ZQO1vLhPPjbraUk2ZrPNYt4Nx2JsT9gvdETDTV
	 j1vh9uQ2/NE9WsUQxU9oaugt6C3hMT0Pfkmh3GZkYOmN1qewt3sQcAjxZxPH5mO/xfXxu
	 IDQ6fZcoiVeKNSGTJKu3RuT+QVp4EBLz7UPo/zQLUbQTkErnp1McgTDM1h+gYahdAZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKshQASl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279CB606A31A;
	Wed, 28 Oct 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKshQASl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796F31F01825;
	Wed, 28 Oct 2026 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208457;
	bh=GJWkUTyKpgRw3O9r30fdQL1OaTYYWC0hYABO6Pssw0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKshQASlzbJbI0DnIbSHcQEZ+5B6cO+UcW02X9ZRso9/YEF7LGtuyPg+kDMLF9+1E
	 iL1EVU1Zem2dMs1MgzRMeTjczAEZaNV2ZjVp/CzcIk5Lg+sihVyn10imnaTaXvXQGG
	 yoFYSrI5Ucwx9lab/rBlhgaKFWpc9aHSoAxuxvL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/516] smb: client: use finish_no_open() for non-regular inodes
Date: Wed, 28 Oct 2026 17:54:37 +0100
Message-ID: <20261028170006.475163655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e66cf1625ec4a3fe68346119f371def713fd0a4d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dir.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 73d43d8911aa5..0366ac28ff07c 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -225,7 +225,7 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 static int
 cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	       struct tcon_link *tlink, unsigned oflags, umode_t mode,
-	       __u32 *oplock, struct cifs_fid *fid)
+	       __u32 *oplock, struct cifs_fid *fid, bool *opened)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
@@ -239,6 +239,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
 
+	*opened = false;
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
 		*oplock = REQ_OPLOCK;
@@ -254,6 +255,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 				     oflags, oplock, &fid->netfid, xid);
 		switch (rc) {
 		case 0:
+			*opened = true;
 			if (newinode == NULL) {
 				/* query inode info */
 				goto cifs_create_get_file_info;
@@ -270,11 +272,9 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
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
@@ -370,6 +370,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
 		goto out;
 	}
+	*opened = true;
 
 	/*
 	 * If Open reported that we actually created a file then we now have to
@@ -452,7 +453,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	return rc;
 
 out_err:
-	if (server->ops->close)
+	if (*opened && server->ops->close)
 		server->ops->close(xid, tcon, fid);
 	if (newinode)
 		iput(newinode);
@@ -472,6 +473,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	struct cifs_pending_open open;
 	__u32 oplock;
 	struct cifsFileInfo *file_info;
+	bool is_regular;
+	bool opened;
 
 	/*
 	 * Posix open is only called (at lookup time) for file create now. For
@@ -526,16 +529,29 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	cifs_add_pending_open(&fid, tlink, &open);
 
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid);
+			    &oplock, &fid, &opened);
 
 	if (rc) {
 		cifs_del_pending_open(&open);
 		goto out;
 	}
 
-	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+	is_regular = d_is_reg(direntry);
+	if (!is_regular || !opened) {
+		if (opened && server->ops->close)
+			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
+	}
+
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
@@ -585,6 +601,7 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	struct TCP_Server_Info *server;
 	struct cifs_fid fid;
 	__u32 oplock;
+	bool opened;
 
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
 		 inode, direntry, direntry);
@@ -601,8 +618,8 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 		server->ops->new_lease_key(&fid);
 
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid);
-	if (!rc && server->ops->close)
+			    &oplock, &fid, &opened);
+	if (!rc && opened && server->ops->close)
 		server->ops->close(xid, tcon, &fid);
 
 	cifs_put_tlink(tlink);
-- 
2.53.0



