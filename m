Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ED41E497;
	Thu, 23 May 2024 13:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470564; cv=none; b=JUybSxc7gG/bAFgNaHJhtjzFTzBFl76HgQyqGD7yk0r5xp4hoEMdZDVDE8g604dP9w3cTTMpqrUKDj1v3FdbpGFN0vvvD2bQlAsM64neG78ieotL09Uq1mjHBfEzyGceMXBdhuziT7owU8y0FamSoHa/Oki8uNpfehFq4SoDNCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470564; c=relaxed/simple;
	bh=CiL0T8Kj8jfy8azRcYJw2HLntzoXoHhZmMoLPdz+BgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2sc/EOs8CHkdeJ7roLlkqtu2E4kh1+AoM0mrI4IYulNu++/XP0eOy3zZi1P6YknFuP+taObOyhU/1bJoaHEhW86Hofcej/ads+Gm+bp0KbbwhLwVcBEMK4kLl6Lrq/PTMVsRR6zuYzxy8d90dpE36VJE3twRkW3OAjtU5HnlQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKlmmZpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKlmmZpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CF5C2BD10;
	Thu, 23 May 2024 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470564;
	bh=CiL0T8Kj8jfy8azRcYJw2HLntzoXoHhZmMoLPdz+BgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKlmmZpP4/nfOrJGN2AmxqzAM2k6IrO3akyl5Op23+Pq1/j5CH7KTm9491N0fZ9mU
	 PxM1OIOnkY29EK/ueaqoKOvnk27r0l+EOMEP+3Rux+8VURZeafGz8+NkLl0UrJE/Vj
	 Tg5FyIO/+wqFXbRBVg4akykM3LKQ0FEizoIDTcwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/102] smb: client: introduce cifs_sfu_make_node()
Date: Thu, 23 May 2024 15:12:36 +0200
Message-ID: <20240523130342.890217658@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit b0348e459c836abdb0f4b967e006d15c77cf1c87 ]

Remove duplicate code and add new helper for creating special files in
SFU (Services for UNIX) format that can be shared by SMB1+ code.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  3 ++
 fs/smb/client/smb1ops.c   | 80 ++++-------------------------------
 fs/smb/client/smb2ops.c   | 89 ++++++++++++++++++---------------------
 3 files changed, 52 insertions(+), 120 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1bdad33580b57..9480cdb9588d5 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -673,6 +673,9 @@ char *extract_sharename(const char *unc);
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			bool unicode, struct cifs_open_info_data *data);
+int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
+		       struct dentry *dentry, struct cifs_tcon *tcon,
+		       const char *full_path, umode_t mode, dev_t dev);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 1aebcf95c1951..212ec6f66ec65 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1041,15 +1041,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct inode *newinode = NULL;
-	int rc = -EPERM;
-	struct cifs_open_info_data buf = {};
-	struct cifs_io_parms io_parms;
-	__u32 oplock = 0;
-	struct cifs_fid fid;
-	struct cifs_open_parms oparms;
-	unsigned int bytes_written;
-	struct win_dev *pdev;
-	struct kvec iov[2];
+	int rc;
 
 	if (tcon->unix_ext) {
 		/*
@@ -1083,74 +1075,18 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 			d_instantiate(dentry, newinode);
 		return rc;
 	}
-
 	/*
-	 * SMB1 SFU emulation: should work with all servers, but only
-	 * support block and char device (no socket & fifo)
+	 * Check if mounted with mount parm 'sfu' mount parm.
+	 * SFU emulation should work with all servers, but only
+	 * supports block and char device (no socket & fifo),
+	 * and was used by default in earlier versions of Windows
 	 */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		return rc;
-
-	if (!S_ISCHR(mode) && !S_ISBLK(mode))
-		return rc;
-
-	cifs_dbg(FYI, "sfu compat create special file\n");
-
-	oparms = (struct cifs_open_parms) {
-		.tcon = tcon,
-		.cifs_sb = cifs_sb,
-		.desired_access = GENERIC_WRITE,
-		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
-						      CREATE_OPTION_SPECIAL),
-		.disposition = FILE_CREATE,
-		.path = full_path,
-		.fid = &fid,
-	};
-
-	if (tcon->ses->server->oplocks)
-		oplock = REQ_OPLOCK;
-	else
-		oplock = 0;
-	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, &buf);
-	if (rc)
-		return rc;
-
-	/*
-	 * BB Do not bother to decode buf since no local inode yet to put
-	 * timestamps in, but we can reuse it safely.
-	 */
-
-	pdev = (struct win_dev *)&buf.fi;
-	io_parms.pid = current->tgid;
-	io_parms.tcon = tcon;
-	io_parms.offset = 0;
-	io_parms.length = sizeof(struct win_dev);
-	iov[1].iov_base = &buf.fi;
-	iov[1].iov_len = sizeof(struct win_dev);
-	if (S_ISCHR(mode)) {
-		memcpy(pdev->type, "IntxCHR", 8);
-		pdev->major = cpu_to_le64(MAJOR(dev));
-		pdev->minor = cpu_to_le64(MINOR(dev));
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
-	} else if (S_ISBLK(mode)) {
-		memcpy(pdev->type, "IntxBLK", 8);
-		pdev->major = cpu_to_le64(MAJOR(dev));
-		pdev->minor = cpu_to_le64(MINOR(dev));
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
-	}
-	tcon->ses->server->ops->close(xid, tcon, &fid);
-	d_drop(dentry);
-
-	/* FIXME: add code here to set EAs */
-
-	cifs_free_open_info(&buf);
-	return rc;
+		return -EPERM;
+	return cifs_sfu_make_node(xid, inode, dentry, tcon,
+				  full_path, mode, dev);
 }
 
-
-
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 04fea874d0a33..2b892a736e5f9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5105,41 +5105,24 @@ static int smb2_next_header(struct TCP_Server_Info *server, char *buf,
 	return 0;
 }
 
-static int
-smb2_make_node(unsigned int xid, struct inode *inode,
-	       struct dentry *dentry, struct cifs_tcon *tcon,
-	       const char *full_path, umode_t mode, dev_t dev)
+int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
+		       struct dentry *dentry, struct cifs_tcon *tcon,
+		       const char *full_path, umode_t mode, dev_t dev)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	int rc = -EPERM;
 	struct cifs_open_info_data buf = {};
-	struct cifs_io_parms io_parms = {0};
-	__u32 oplock = 0;
-	struct cifs_fid fid;
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
+	struct cifs_io_parms io_parms = {};
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_fid fid;
 	unsigned int bytes_written;
 	struct win_dev *pdev;
 	struct kvec iov[2];
-
-	/*
-	 * Check if mounted with mount parm 'sfu' mount parm.
-	 * SFU emulation should work with all servers, but only
-	 * supports block and char device (no socket & fifo),
-	 * and was used by default in earlier versions of Windows
-	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		return rc;
-
-	/*
-	 * TODO: Add ability to create instead via reparse point. Windows (e.g.
-	 * their current NFS server) uses this approach to expose special files
-	 * over SMB2/SMB3 and Samba will do this with SMB3.1.1 POSIX Extensions
-	 */
+	__u32 oplock = server->oplocks ? REQ_OPLOCK : 0;
+	int rc;
 
 	if (!S_ISCHR(mode) && !S_ISBLK(mode) && !S_ISFIFO(mode))
-		return rc;
-
-	cifs_dbg(FYI, "sfu compat create special file\n");
+		return -EPERM;
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -5152,11 +5135,7 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 		.fid = &fid,
 	};
 
-	if (tcon->ses->server->oplocks)
-		oplock = REQ_OPLOCK;
-	else
-		oplock = 0;
-	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, &buf);
+	rc = server->ops->open(xid, &oparms, &oplock, &buf);
 	if (rc)
 		return rc;
 
@@ -5164,42 +5143,56 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 	 * BB Do not bother to decode buf since no local inode yet to put
 	 * timestamps in, but we can reuse it safely.
 	 */
-
 	pdev = (struct win_dev *)&buf.fi;
 	io_parms.pid = current->tgid;
 	io_parms.tcon = tcon;
-	io_parms.offset = 0;
-	io_parms.length = sizeof(struct win_dev);
-	iov[1].iov_base = &buf.fi;
-	iov[1].iov_len = sizeof(struct win_dev);
+	io_parms.length = sizeof(*pdev);
+	iov[1].iov_base = pdev;
+	iov[1].iov_len = sizeof(*pdev);
 	if (S_ISCHR(mode)) {
 		memcpy(pdev->type, "IntxCHR", 8);
 		pdev->major = cpu_to_le64(MAJOR(dev));
 		pdev->minor = cpu_to_le64(MINOR(dev));
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
 	} else if (S_ISBLK(mode)) {
 		memcpy(pdev->type, "IntxBLK", 8);
 		pdev->major = cpu_to_le64(MAJOR(dev));
 		pdev->minor = cpu_to_le64(MINOR(dev));
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
 	} else if (S_ISFIFO(mode)) {
 		memcpy(pdev->type, "LnxFIFO", 8);
-		pdev->major = 0;
-		pdev->minor = 0;
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
 	}
-	tcon->ses->server->ops->close(xid, tcon, &fid);
-	d_drop(dentry);
 
+	rc = server->ops->sync_write(xid, &fid, &io_parms,
+				     &bytes_written, iov, 1);
+	server->ops->close(xid, tcon, &fid);
+	d_drop(dentry);
 	/* FIXME: add code here to set EAs */
-
 	cifs_free_open_info(&buf);
 	return rc;
 }
 
+static int smb2_make_node(unsigned int xid, struct inode *inode,
+			  struct dentry *dentry, struct cifs_tcon *tcon,
+			  const char *full_path, umode_t mode, dev_t dev)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+
+	/*
+	 * Check if mounted with mount parm 'sfu' mount parm.
+	 * SFU emulation should work with all servers, but only
+	 * supports block and char device (no socket & fifo),
+	 * and was used by default in earlier versions of Windows
+	 */
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
+		return -EPERM;
+	/*
+	 * TODO: Add ability to create instead via reparse point. Windows (e.g.
+	 * their current NFS server) uses this approach to expose special files
+	 * over SMB2/SMB3 and Samba will do this with SMB3.1.1 POSIX Extensions
+	 */
+	return cifs_sfu_make_node(xid, inode, dentry, tcon,
+				  full_path, mode, dev);
+}
+
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
-- 
2.43.0



