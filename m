Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210718;
	b=0lJvne4YMigRyPlYPjaYnmtyWcYznUnURX/EBRPLon2Gn0Z95Nsz+5MOJtboHPJFhwQM
	 zhuAujvrrhdDcrRXxd9D4vRH0Iho2UhP2JvF+ceLbEl0zPD/ExYwy5goa7YK5n7/KX0KN
	 HxvJYmI/7MgrGF9QEuz3MJgdliwxtxSrT2TGaYtODT/10775Ln7osZ8Fix9Zl5sFP1LEf
	 axiXvBuBlLUXq3h3k4oQue/qYoh3WzXEUIhp2g8cjrayOM412x54/xwKrrH8pkEbsXPPp
	 joUXc0bilif8NhnOI8l6U4BSsUq8gNVzDRSwVBJUKlrXsuHIRQV59MNMZFYEJwjP/Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iz+zjNyplD9UeNxlOB9sD/TDUKhCVBaNFGAWM9c671Y=;
	b=XRV/Amgy4RWP2Hv7fdQpGPGcGfFe35al74YlBrmhfXq2TDYcudFYgZoeHb9DT17IKjNY
	 pIwiayRhk58sXF35BMPKfreHSqjkVc0k/Mmca6a6rWOVw26+3N1qHVWBnpUbnVA33DN5D
	 MzOa/NcRKXMsaheE6XFUViSuCqPe1rMGRnoMixbvMHFgF6Y1AxOrnyDrpC2SqbpEhshvl
	 KsG4aYi7+6TX9PqEWIlg4E6g0c1APmz4wHf9qW/1ZHRKv8Pmf/EzoRVdoijbiTec+AsbI
	 ZWzjxqEpO7d3D2NUdhsFaNbAWCYQun7JTUJnJbitXz0AYCEM6IYSTwZtguagS0gYZXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LjRr/yIm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC2A606A31A;
	Wed, 28 Oct 2026 18:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LjRr/yIm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BE11F01825;
	Wed, 28 Oct 2026 18:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210717;
	bh=iz+zjNyplD9UeNxlOB9sD/TDUKhCVBaNFGAWM9c671Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LjRr/yImpd7zeYZNWgxvA8rPoGLnn4EZmbyjOOCWKtKqlALMa25eE3tbqMqj63LzU
	 8M3hwg7vDj9MfpLVBSMqUFxGbLd7pZH53KL/TsopAkxf9TJFnlDbfXh8kxaoC7AF5G
	 hit2iF1tPAJuwp1nMP1JvzGCAl7XkHv9kRijgtwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/571] smb: client: use finish_no_open() for non-regular inodes
Date: Wed, 28 Oct 2026 17:54:29 +0100
Message-ID: <20261028170010.913230053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ used d_is_reg(direntry) because the older cifs_do_create() already attaches the inode. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dir.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 83c929dd6ed59..5b7d419a81862 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -167,7 +167,7 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 static int
 cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	       struct tcon_link *tlink, unsigned oflags, umode_t mode,
-	       __u32 *oplock, struct cifs_fid *fid)
+	       __u32 *oplock, struct cifs_fid *fid, bool *opened)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
@@ -182,6 +182,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
 
+	*opened = false;
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
 		*oplock = REQ_OPLOCK;
@@ -199,6 +200,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 				     oflags, oplock, &fid->netfid, xid);
 		switch (rc) {
 		case 0:
+			*opened = true;
 			if (newinode == NULL) {
 				/* query inode info */
 				goto cifs_create_get_file_info;
@@ -215,11 +217,9 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
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
@@ -314,6 +314,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
 		goto out;
 	}
+	*opened = true;
 
 	/*
 	 * If Open reported that we actually created a file then we now have to
@@ -398,7 +399,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	return rc;
 
 out_err:
-	if (server->ops->close)
+	if (*opened && server->ops->close)
 		server->ops->close(xid, tcon, fid);
 	if (newinode)
 		iput(newinode);
@@ -418,6 +419,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	struct cifs_pending_open open;
 	__u32 oplock;
 	struct cifsFileInfo *file_info;
+	bool is_regular;
+	bool opened;
 
 	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
 		return -EIO;
@@ -475,16 +478,29 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
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
@@ -534,6 +550,7 @@ int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
 	struct TCP_Server_Info *server;
 	struct cifs_fid fid;
 	__u32 oplock;
+	bool opened;
 
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
 		 inode, direntry, direntry);
@@ -555,8 +572,8 @@ int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
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



