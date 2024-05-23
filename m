Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FC913B7AE;
	Thu, 23 May 2024 13:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470677; cv=none; b=YFnWA1dzCbYK5er05tL6mealtXo2E1I2Q5G4vVNAn/FQ/oG9EgJqvoGNN3osQwv4oSnwSV3SdYV09Y+jjenlnJ0PPSKcM/weX/DiaatbgkZjDYzNy+aCSaqb/nhj8r6j2wvdj3nhVn19fC10uxAo/zXnVQ5fkiN6X1bRAGKl9rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470677; c=relaxed/simple;
	bh=dK/NLWktSZ1xOkOUox/nqdhRqLatd9u4bwW5/RBJTfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDey378wypTIMsTjylklM9ly+Tdw7UWqv3fkchtF+Gjf9Za/45/beNXe2V51wyGGTXCEVoiSL58VPGRQk7vaduf9BD0ZJYIJgkTh1AHFH+yerHONX33dU8Rsjz6HRnLqipPOFASWkLH+zKOAd0mmNdEYJbobkd7OQetU2M+5n/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BAD5OZ0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAD5OZ0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5D3C2BD10;
	Thu, 23 May 2024 13:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470677;
	bh=dK/NLWktSZ1xOkOUox/nqdhRqLatd9u4bwW5/RBJTfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAD5OZ0kIqrxxe1XNAvd2Ir+dJIh0lGEMVVWLMUql27JcvXBoba6bMBOj4HAyrYwq
	 +YhqzOIH1/6T/KsuInHYBe+br/VflXYVYQzBaep1h4p5Yr9js5gd0+32bdgReRJO9H
	 jZLLI97MKIQ3WbOW1BZs0Cuog7TLcqJ1a9orP464=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/102] smb: client: reduce number of parameters in smb2_compound_op()
Date: Thu, 23 May 2024 15:13:13 +0200
Message-ID: <20240523130344.277135019@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit fa792d8d235c20df5f422e4bd172db1efde55ab9 ]

Replace @desired_access, @create_disposition, @create_options and
@mode parameters with a single @oparms.

No functional changes.

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h  |  11 +++
 fs/smb/client/smb2inode.c | 153 +++++++++++++++++++++-----------------
 2 files changed, 95 insertions(+), 69 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 296ed556be0e2..5a902fb20ac96 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2281,6 +2281,17 @@ static inline void cifs_sg_set_buf(struct sg_table *sgtable,
 	}
 }
 
+#define CIFS_OPARMS(_cifs_sb, _tcon, _path, _da, _cd, _co, _mode) \
+	((struct cifs_open_parms) { \
+		.tcon = _tcon, \
+		.path = _path, \
+		.desired_access = (_da), \
+		.disposition = (_cd), \
+		.create_options = cifs_create_options(_cifs_sb, (_co)), \
+		.mode = (_mode), \
+		.cifs_sb = _cifs_sb, \
+	})
+
 struct smb2_compound_vars {
 	struct cifs_open_parms oparms;
 	struct kvec rsp_iov[MAX_COMPOUND];
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 33f3fffcb8277..e1ad54b27b63e 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -95,8 +95,7 @@ static int parse_posix_sids(struct cifs_open_info_data *data,
  */
 static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			    struct cifs_sb_info *cifs_sb, const char *full_path,
-			    __u32 desired_access, __u32 create_disposition,
-			    __u32 create_options, umode_t mode, struct kvec *in_iov,
+			    struct cifs_open_parms *oparms, struct kvec *in_iov,
 			    int *cmds, int num_cmds, struct cifsFileInfo *cfile,
 			    struct kvec *out_iov, int *out_buftype, struct dentry *dentry)
 {
@@ -173,16 +172,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 	}
 
-	vars->oparms = (struct cifs_open_parms) {
-		.tcon = tcon,
-		.path = full_path,
-		.desired_access = desired_access,
-		.disposition = create_disposition,
-		.create_options = cifs_create_options(cifs_sb, create_options),
-		.fid = &fid,
-		.mode = mode,
-		.cifs_sb = cifs_sb,
-	};
+	vars->oparms = *oparms;
+	vars->oparms.fid = &fid;
 
 	rqst[num_rqst].rq_iov = &vars->open_iov[0];
 	rqst[num_rqst].rq_nvec = SMB2_CREATE_IOV_SIZE;
@@ -741,6 +732,7 @@ int smb2_query_path_info(const unsigned int xid,
 			 const char *full_path,
 			 struct cifs_open_info_data *data)
 {
+	struct cifs_open_parms oparms;
 	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
 	struct cached_fid *cfid = NULL;
@@ -792,10 +784,11 @@ int smb2_query_path_info(const unsigned int xid,
 	in_iov[1] = in_iov[0];
 
 	cifs_get_readable_path(tcon, full_path, &cfile);
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_ATTRIBUTES,
+			     FILE_OPEN, create_options, ACL_NO_MODE);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-			      FILE_READ_ATTRIBUTES, FILE_OPEN,
-			      create_options, ACL_NO_MODE, in_iov,
-			      cmds, 1, cfile, out_iov, out_buftype, NULL);
+			      &oparms, in_iov, cmds, 1, cfile,
+			      out_iov, out_buftype, NULL);
 	hdr = out_iov[0].iov_base;
 	/*
 	 * If first iov is unset, then SMB session was dropped or we've got a
@@ -822,12 +815,14 @@ int smb2_query_path_info(const unsigned int xid,
 			cmds[1] = SMB2_OP_GET_REPARSE;
 			num_cmds = 2;
 		}
-		create_options |= OPEN_REPARSE_POINT;
+		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
+				     FILE_READ_ATTRIBUTES, FILE_OPEN,
+				     create_options | OPEN_REPARSE_POINT,
+				     ACL_NO_MODE);
 		cifs_get_readable_path(tcon, full_path, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-				      FILE_READ_ATTRIBUTES, FILE_OPEN,
-				      create_options, ACL_NO_MODE, in_iov,
-				      cmds, num_cmds, cfile, NULL, NULL, NULL);
+				      &oparms, in_iov, cmds, num_cmds,
+				      cfile, NULL, NULL, NULL);
 		break;
 	case -EREMOTE:
 		break;
@@ -855,10 +850,13 @@ smb2_mkdir(const unsigned int xid, struct inode *parent_inode, umode_t mode,
 	   struct cifs_tcon *tcon, const char *name,
 	   struct cifs_sb_info *cifs_sb)
 {
-	return smb2_compound_op(xid, tcon, cifs_sb, name,
-				FILE_WRITE_ATTRIBUTES, FILE_CREATE,
-				CREATE_NOT_FILE, mode,
-				NULL, &(int){SMB2_OP_MKDIR}, 1,
+	struct cifs_open_parms oparms;
+
+	oparms = CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES,
+			     FILE_CREATE, CREATE_NOT_FILE, mode);
+	return smb2_compound_op(xid, tcon, cifs_sb,
+				name, &oparms, NULL,
+				&(int){SMB2_OP_MKDIR}, 1,
 				NULL, NULL, NULL, NULL);
 }
 
@@ -867,6 +865,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 		   struct cifs_sb_info *cifs_sb, struct cifs_tcon *tcon,
 		   const unsigned int xid)
 {
+	struct cifs_open_parms oparms;
 	FILE_BASIC_INFO data = {};
 	struct cifsInodeInfo *cifs_i;
 	struct cifsFileInfo *cfile;
@@ -880,9 +879,10 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 	dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
 	data.Attributes = cpu_to_le32(dosattrs);
 	cifs_get_writable_path(tcon, name, FIND_WR_ANY, &cfile);
+	oparms = CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES,
+			     FILE_CREATE, CREATE_NOT_FILE, ACL_NO_MODE);
 	tmprc = smb2_compound_op(xid, tcon, cifs_sb, name,
-				 FILE_WRITE_ATTRIBUTES, FILE_CREATE,
-				 CREATE_NOT_FILE, ACL_NO_MODE, &in_iov,
+				 &oparms, &in_iov,
 				 &(int){SMB2_OP_SET_INFO}, 1,
 				 cfile, NULL, NULL, NULL);
 	if (tmprc == 0)
@@ -893,10 +893,13 @@ int
 smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	   struct cifs_sb_info *cifs_sb)
 {
+	struct cifs_open_parms oparms;
+
 	drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
-	return smb2_compound_op(xid, tcon, cifs_sb, name,
-				DELETE, FILE_OPEN, CREATE_NOT_FILE,
-				ACL_NO_MODE, NULL,
+	oparms = CIFS_OPARMS(cifs_sb, tcon, name, DELETE,
+			     FILE_OPEN, CREATE_NOT_FILE, ACL_NO_MODE);
+	return smb2_compound_op(xid, tcon, cifs_sb,
+				name, &oparms, NULL,
 				&(int){SMB2_OP_RMDIR}, 1,
 				NULL, NULL, NULL, NULL);
 }
@@ -905,18 +908,20 @@ int
 smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	    struct cifs_sb_info *cifs_sb, struct dentry *dentry)
 {
-	int rc = smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
-				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
-				ACL_NO_MODE, NULL,
-				&(int){SMB2_OP_DELETE}, 1,
-				NULL, NULL, NULL, dentry);
+	struct cifs_open_parms oparms;
+
+	oparms = CIFS_OPARMS(cifs_sb, tcon, name,
+			     DELETE, FILE_OPEN,
+			     CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
+			     ACL_NO_MODE);
+	int rc = smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
+				  NULL, &(int){SMB2_OP_DELETE}, 1,
+				  NULL, NULL, NULL, dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
-		rc = smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
-				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
-				ACL_NO_MODE, NULL,
-				&(int){SMB2_OP_DELETE}, 1,
-				NULL, NULL, NULL, NULL);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
+				      NULL, &(int){SMB2_OP_DELETE}, 1,
+				      NULL, NULL, NULL, NULL);
 	}
 	return rc;
 }
@@ -928,6 +933,7 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 			      int command, struct cifsFileInfo *cfile,
 				  struct dentry *dentry)
 {
+	struct cifs_open_parms oparms;
 	struct kvec in_iov;
 	__le16 *smb2_to_name = NULL;
 	int rc;
@@ -939,9 +945,11 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 	in_iov.iov_base = smb2_to_name;
 	in_iov.iov_len = 2 * UniStrnlen((wchar_t *)smb2_to_name, PATH_MAX);
-	rc = smb2_compound_op(xid, tcon, cifs_sb, from_name, access,
-			      FILE_OPEN, create_options, ACL_NO_MODE,
-			      &in_iov, &command, 1, cfile, NULL, NULL, dentry);
+	oparms = CIFS_OPARMS(cifs_sb, tcon, from_name, access, FILE_OPEN,
+			     create_options, ACL_NO_MODE);
+	rc = smb2_compound_op(xid, tcon, cifs_sb, from_name,
+			      &oparms, &in_iov, &command, 1,
+			      cfile, NULL, NULL, dentry);
 smb2_rename_path:
 	kfree(smb2_to_name);
 	return rc;
@@ -988,25 +996,28 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, bool set_alloc,
 		   struct dentry *dentry)
 {
+	struct cifs_open_parms oparms;
 	struct cifsFileInfo *cfile;
 	struct kvec in_iov;
 	__le64 eof = cpu_to_le64(size);
+	int rc;
 
 	in_iov.iov_base = &eof;
 	in_iov.iov_len = sizeof(eof);
 	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
-	int rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-				FILE_WRITE_DATA, FILE_OPEN,
-				0, ACL_NO_MODE, &in_iov,
-				&(int){SMB2_OP_SET_EOF}, 1,
-				cfile, NULL, NULL, dentry);
+
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_DATA,
+			     FILE_OPEN, 0, ACL_NO_MODE);
+	rc = smb2_compound_op(xid, tcon, cifs_sb,
+			      full_path, &oparms, &in_iov,
+			      &(int){SMB2_OP_SET_EOF}, 1,
+			      cfile, NULL, NULL, dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
-		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-				FILE_WRITE_DATA, FILE_OPEN,
-				0, ACL_NO_MODE, &in_iov,
-				&(int){SMB2_OP_SET_EOF}, 1,
-				cfile, NULL, NULL, NULL);
+		rc = smb2_compound_op(xid, tcon, cifs_sb,
+				      full_path, &oparms, &in_iov,
+				      &(int){SMB2_OP_SET_EOF}, 1,
+				      cfile, NULL, NULL, NULL);
 	}
 	return rc;
 }
@@ -1015,6 +1026,7 @@ int
 smb2_set_file_info(struct inode *inode, const char *full_path,
 		   FILE_BASIC_INFO *buf, const unsigned int xid)
 {
+	struct cifs_open_parms oparms;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
@@ -1033,9 +1045,10 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	tcon = tlink_tcon(tlink);
 
 	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
-	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-			      FILE_WRITE_ATTRIBUTES, FILE_OPEN,
-			      0, ACL_NO_MODE, &in_iov,
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_ATTRIBUTES,
+			     FILE_OPEN, 0, ACL_NO_MODE);
+	rc = smb2_compound_op(xid, tcon, cifs_sb,
+			      full_path, &oparms, &in_iov,
 			      &(int){SMB2_OP_SET_INFO}, 1,
 			      cfile, NULL, NULL, NULL);
 	cifs_put_tlink(tlink);
@@ -1049,19 +1062,21 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 				     const char *full_path,
 				     struct kvec *iov)
 {
+	struct cifs_open_parms oparms;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsFileInfo *cfile;
 	struct inode *new = NULL;
 	struct kvec in_iov[2];
 	int cmds[2];
-	int da, co, cd;
 	int rc;
 
-	da = SYNCHRONIZE | DELETE |
-		FILE_READ_ATTRIBUTES |
-		FILE_WRITE_ATTRIBUTES;
-	co = CREATE_NOT_DIR | OPEN_REPARSE_POINT;
-	cd = FILE_CREATE;
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
+			     SYNCHRONIZE | DELETE |
+			     FILE_READ_ATTRIBUTES |
+			     FILE_WRITE_ATTRIBUTES,
+			     FILE_CREATE,
+			     CREATE_NOT_DIR | OPEN_REPARSE_POINT,
+			     ACL_NO_MODE);
 	cmds[0] = SMB2_OP_SET_REPARSE;
 	in_iov[0] = *iov;
 	in_iov[1].iov_base = data;
@@ -1070,9 +1085,8 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	if (tcon->posix_extensions) {
 		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
 		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
-		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-				      da, cd, co, ACL_NO_MODE, in_iov,
-				      cmds, 2, cfile, NULL, NULL, NULL);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
+				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
 		if (!rc) {
 			rc = smb311_posix_get_inode_info(&new, full_path,
 							 data, sb, xid);
@@ -1080,9 +1094,8 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	} else {
 		cmds[1] = SMB2_OP_QUERY_INFO;
 		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
-		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-				      da, cd, co, ACL_NO_MODE, in_iov,
-				      cmds, 2, cfile, NULL, NULL, NULL);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
+				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
 		if (!rc) {
 			rc = cifs_get_inode_info(&new, full_path,
 						 data, sb, xid, NULL);
@@ -1098,6 +1111,7 @@ int smb2_query_reparse_point(const unsigned int xid,
 			     u32 *tag, struct kvec *rsp,
 			     int *rsp_buftype)
 {
+	struct cifs_open_parms oparms;
 	struct cifs_open_info_data data = {};
 	struct cifsFileInfo *cfile;
 	struct kvec in_iov = { .iov_base = &data, .iov_len = sizeof(data), };
@@ -1106,9 +1120,10 @@ int smb2_query_reparse_point(const unsigned int xid,
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
 
 	cifs_get_readable_path(tcon, full_path, &cfile);
-	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-			      FILE_READ_ATTRIBUTES, FILE_OPEN,
-			      OPEN_REPARSE_POINT, ACL_NO_MODE, &in_iov,
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_ATTRIBUTES,
+			     FILE_OPEN, OPEN_REPARSE_POINT, ACL_NO_MODE);
+	rc = smb2_compound_op(xid, tcon, cifs_sb,
+			      full_path, &oparms, &in_iov,
 			      &(int){SMB2_OP_GET_REPARSE}, 1,
 			      cfile, NULL, NULL, NULL);
 	if (rc)
-- 
2.43.0



