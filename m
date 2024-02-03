Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF831118F;
	Sat,  3 Feb 2024 04:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933515; cv=none; b=N9/O4+q4SR5H2cBu6P7M6XIiGBBsU4Yumj+w40l8vyNfLCA9nEqbu92xDH88YYu/lMOJpImmkFmOxo+i6NI7P7wMB8vsdeHSlQJ33el7wC6ksJSuHOQ8kGRDIHeYbkS5UdUUR+cHAqhgqqRfPwNAUfDMEJDjM6YJtAVgkMLkA7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933515; c=relaxed/simple;
	bh=24uw4WIm6xaYVaILodCJfN1N6TfjVVCFHHCoL1KTUjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqvN0XkYtgPcEqOAHJZ9YyU9o+0pBviTeb5dqm1RXG3xgWI4vXre8ph5EsMgQkGBKS/8E/+PA2UNaUVJ3eshrc698nwHXO8EQzZ/EKNTaQRv5h9j9jrNWLcQQvyj8i7CuoQuz05EOMQNqKRT8bjaiap5/q64S1YVE+r9s/XY/rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpBXoFjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpBXoFjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3E8C433C7;
	Sat,  3 Feb 2024 04:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933514;
	bh=24uw4WIm6xaYVaILodCJfN1N6TfjVVCFHHCoL1KTUjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpBXoFjjfsJadf5nYWLAHgZEOm4JJp8MYZviC7ltna87+gF1lEDyUcI6LI1McqdUY
	 ZSetF7djj1rKZQKPsxRZX8yTD13vHn7TU6RfKu0W93AkvOV1Xd+mE8k/IIVwsAeOdR
	 TsBjNY0e1v3SnDu8c+6f0zVLosQXPTpq4WS9lJJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/322] smb: client: fix hardlinking of reparse points
Date: Fri,  2 Feb 2024 20:02:29 -0800
Message-ID: <20240203035400.805906522@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 5408990aa662bcfd6ba894734023a023a16e8729 ]

The client was sending an SMB2_CREATE request without setting
OPEN_REPARSE_POINT flag thus failing the entire hardlink operation.

Fix this by setting OPEN_REPARSE_POINT in create options for
SMB2_CREATE request when the source inode is a repase point.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h  |  8 +++++---
 fs/smb/client/cifsproto.h |  8 +++++---
 fs/smb/client/cifssmb.c   |  9 +++++----
 fs/smb/client/link.c      |  4 ++--
 fs/smb/client/smb2inode.c | 33 +++++++++++++++++++++------------
 fs/smb/client/smb2proto.h |  8 +++++---
 6 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 4d07b96038d8..942e6ece56b1 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -405,9 +405,11 @@ struct smb_version_operations {
 		      const char *from_name, const char *to_name,
 		      struct cifs_sb_info *cifs_sb);
 	/* send create hardlink request */
-	int (*create_hardlink)(const unsigned int, struct cifs_tcon *,
-			       const char *, const char *,
-			       struct cifs_sb_info *);
+	int (*create_hardlink)(const unsigned int xid,
+			       struct cifs_tcon *tcon,
+			       struct dentry *source_dentry,
+			       const char *from_name, const char *to_name,
+			       struct cifs_sb_info *cifs_sb);
 	/* query symlink target */
 	int (*query_symlink)(const unsigned int xid,
 			     struct cifs_tcon *tcon,
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f89e6c2a4974..260a6299bddb 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -443,9 +443,11 @@ extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
 				 int netfid, const char *target_name,
 				 const struct nls_table *nls_codepage,
 				 int remap_special_chars);
-extern int CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
-			      const char *from_name, const char *to_name,
-			      struct cifs_sb_info *cifs_sb);
+int CIFSCreateHardLink(const unsigned int xid,
+		       struct cifs_tcon *tcon,
+		       struct dentry *source_dentry,
+		       const char *from_name, const char *to_name,
+		       struct cifs_sb_info *cifs_sb);
 extern int CIFSUnixCreateHardLink(const unsigned int xid,
 			struct cifs_tcon *tcon,
 			const char *fromName, const char *toName,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 5bdea01919e8..e9e33b0b3ac4 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2530,10 +2530,11 @@ CIFSUnixCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-int
-CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
-		   const char *from_name, const char *to_name,
-		   struct cifs_sb_info *cifs_sb)
+int CIFSCreateHardLink(const unsigned int xid,
+		       struct cifs_tcon *tcon,
+		       struct dentry *source_dentry,
+		       const char *from_name, const char *to_name,
+		       struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
 	NT_RENAME_REQ *pSMB = NULL;
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index c66be4904e1f..6c4ae52ddc04 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -522,8 +522,8 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 			rc = -ENOSYS;
 			goto cifs_hl_exit;
 		}
-		rc = server->ops->create_hardlink(xid, tcon, from_name, to_name,
-						  cifs_sb);
+		rc = server->ops->create_hardlink(xid, tcon, old_file,
+						  from_name, to_name, cifs_sb);
 		if ((rc == -EIO) || (rc == -EINVAL))
 			rc = -EOPNOTSUPP;
 	}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c3e28673e0cd..6cac0b107a2d 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -35,6 +35,18 @@ free_set_inf_compound(struct smb_rqst *rqst)
 		SMB2_close_free(&rqst[2]);
 }
 
+static inline __u32 file_create_options(struct dentry *dentry)
+{
+	struct cifsInodeInfo *ci;
+
+	if (dentry) {
+		ci = CIFS_I(d_inode(dentry));
+		if (ci->cifsAttrs & ATTR_REPARSE)
+			return OPEN_REPARSE_POINT;
+	}
+	return 0;
+}
+
 /*
  * note: If cfile is passed, the reference to it is dropped here.
  * So make sure that you do not reuse cfile after return from this func.
@@ -809,15 +821,9 @@ int smb2_rename_path(const unsigned int xid,
 		     const char *from_name, const char *to_name,
 		     struct cifs_sb_info *cifs_sb)
 {
-	struct cifsInodeInfo *ci;
 	struct cifsFileInfo *cfile;
-	__u32 co = 0;
+	__u32 co = file_create_options(source_dentry);
 
-	if (source_dentry) {
-		ci = CIFS_I(d_inode(source_dentry));
-		if (ci->cifsAttrs & ATTR_REPARSE)
-			co |= OPEN_REPARSE_POINT;
-	}
 	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
@@ -825,13 +831,16 @@ int smb2_rename_path(const unsigned int xid,
 				  co, DELETE, SMB2_OP_RENAME, cfile);
 }
 
-int
-smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
-		     const char *from_name, const char *to_name,
-		     struct cifs_sb_info *cifs_sb)
+int smb2_create_hardlink(const unsigned int xid,
+			 struct cifs_tcon *tcon,
+			 struct dentry *source_dentry,
+			 const char *from_name, const char *to_name,
+			 struct cifs_sb_info *cifs_sb)
 {
+	__u32 co = file_create_options(source_dentry);
+
 	return smb2_set_path_attr(xid, tcon, from_name, to_name,
-				  cifs_sb, 0, FILE_READ_ATTRIBUTES,
+				  cifs_sb, co, FILE_READ_ATTRIBUTES,
 				  SMB2_OP_HARDLINK, NULL);
 }
 
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 7cbf1a76b42d..a8084ce7fcbd 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -85,9 +85,11 @@ int smb2_rename_path(const unsigned int xid,
 		     struct dentry *source_dentry,
 		     const char *from_name, const char *to_name,
 		     struct cifs_sb_info *cifs_sb);
-extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
-				const char *from_name, const char *to_name,
-				struct cifs_sb_info *cifs_sb);
+int smb2_create_hardlink(const unsigned int xid,
+			 struct cifs_tcon *tcon,
+			 struct dentry *source_dentry,
+			 const char *from_name, const char *to_name,
+			 struct cifs_sb_info *cifs_sb);
 extern int smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const unsigned char *path,
 			char *pbuf, unsigned int *pbytes_written);
-- 
2.43.0



