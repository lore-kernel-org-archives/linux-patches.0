Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB4714B946;
	Thu, 23 May 2024 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470633; cv=none; b=Yp0HoaG2cdP0+lI0q81s4fVZ+87XTIjxvIwsjVZPEjUPx+WwsZqbXYXYolxG1RbCWA83X2rpChQkhjLGUKJM1o+FOv36E5dtkxCPl+uBgY6+GeSfMyTWfzy/KEdaZTVJim+iwhy+2Nqn4kzhctb9QOBeBl9TbhfmgsN+iZA1iII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470633; c=relaxed/simple;
	bh=uF6TTukbnSZQYew432n/SOk1271WZMFrs20NHdNHOAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEGJeW2epINzFANuIFTjmeZHlRKqbZCJmtnmVZkthwmeT9l1f/kd5B5UfxaZvyJcPcfTszFrVOmphWDAo842N505Fbv8uwJpha9/3SYYewuqps1cqG9FjYAgeT3wzgpETR7uVw7CzgzvVOn1cCZfWsv5jEvUlmLj5NcPq7zmK40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4rJCmuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4rJCmuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDE9C2BD10;
	Thu, 23 May 2024 13:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470633;
	bh=uF6TTukbnSZQYew432n/SOk1271WZMFrs20NHdNHOAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4rJCmuvEDbtDy6GlnsqUIDCwpzZyOD3a6c91Ql47msxLuZqZ7jtVVTfijXJDPgaR
	 PzIKFXX09JzG2TV4N1ij+akrwFE1m4dZBx1kZnXuDLBr2aSKpLVZiFJKN/ytvC0wem
	 gWslydlO7B/FD2U3fCGDrKXT5ZnNkT0EkI3nrERU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/102] smb: client: cleanup smb2_query_reparse_point()
Date: Thu, 23 May 2024 15:12:42 +0200
Message-ID: <20240523130343.114562470@linuxfoundation.org>
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

[ Upstream commit 3ded18a9e9d22a9cba8acad24b77a87851f9c9fa ]

Use smb2_compound_op() with SMB2_OP_GET_REPARSE to get reparse point.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c |  33 +++++++++
 fs/smb/client/smb2ops.c   | 139 --------------------------------------
 fs/smb/client/smb2proto.h |   6 ++
 3 files changed, 39 insertions(+), 139 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 11c1e06ab5417..1388ce5421a89 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1054,3 +1054,36 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	}
 	return rc ? ERR_PTR(rc) : new;
 }
+
+int smb2_query_reparse_point(const unsigned int xid,
+			     struct cifs_tcon *tcon,
+			     struct cifs_sb_info *cifs_sb,
+			     const char *full_path,
+			     u32 *tag, struct kvec *rsp,
+			     int *rsp_buftype)
+{
+	struct cifs_open_info_data data = {};
+	struct cifsFileInfo *cfile;
+	struct kvec in_iov = { .iov_base = &data, .iov_len = sizeof(data), };
+	int rc;
+
+	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
+
+	cifs_get_readable_path(tcon, full_path, &cfile);
+	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+			      FILE_READ_ATTRIBUTES, FILE_OPEN,
+			      OPEN_REPARSE_POINT, ACL_NO_MODE, &in_iov,
+			      &(int){SMB2_OP_GET_REPARSE}, 1, cfile,
+			      NULL, NULL, NULL, NULL);
+	if (rc)
+		goto out;
+
+	*tag = data.reparse.tag;
+	*rsp = data.reparse.io.iov;
+	*rsp_buftype = data.reparse.io.buftype;
+	memset(&data.reparse.io.iov, 0, sizeof(data.reparse.io.iov));
+	data.reparse.io.buftype = CIFS_NO_BUFFER;
+out:
+	cifs_free_open_info(&data);
+	return rc;
+}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c5957deb1a859..a623a720db9e0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2996,145 +2996,6 @@ static int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
 	return parse_reparse_point(buf, plen, cifs_sb, true, data);
 }
 
-static int smb2_query_reparse_point(const unsigned int xid,
-				    struct cifs_tcon *tcon,
-				    struct cifs_sb_info *cifs_sb,
-				    const char *full_path,
-				    u32 *tag, struct kvec *rsp,
-				    int *rsp_buftype)
-{
-	struct smb2_compound_vars *vars;
-	int rc;
-	__le16 *utf16_path = NULL;
-	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct cifs_open_parms oparms;
-	struct cifs_fid fid;
-	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
-	int flags = CIFS_CP_CREATE_CLOSE_OP;
-	struct smb_rqst *rqst;
-	int resp_buftype[3];
-	struct kvec *rsp_iov;
-	struct smb2_ioctl_rsp *ioctl_rsp;
-	struct reparse_data_buffer *reparse_buf;
-	u32 off, count, len;
-
-	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
-
-	if (smb3_encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
-	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
-	if (!utf16_path)
-		return -ENOMEM;
-
-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
-	if (!vars) {
-		rc = -ENOMEM;
-		goto out_free_path;
-	}
-	rqst = vars->rqst;
-	rsp_iov = vars->rsp_iov;
-
-	/*
-	 * setup smb2open - TODO add optimization to call cifs_get_readable_path
-	 * to see if there is a handle already open that we can use
-	 */
-	rqst[0].rq_iov = vars->open_iov;
-	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
-
-	oparms = (struct cifs_open_parms) {
-		.tcon = tcon,
-		.path = full_path,
-		.desired_access = FILE_READ_ATTRIBUTES,
-		.disposition = FILE_OPEN,
-		.create_options = cifs_create_options(cifs_sb, OPEN_REPARSE_POINT),
-		.fid = &fid,
-	};
-
-	rc = SMB2_open_init(tcon, server,
-			    &rqst[0], &oplock, &oparms, utf16_path);
-	if (rc)
-		goto query_rp_exit;
-	smb2_set_next_command(tcon, &rqst[0]);
-
-
-	/* IOCTL */
-	rqst[1].rq_iov = vars->io_iov;
-	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
-
-	rc = SMB2_ioctl_init(tcon, server,
-			     &rqst[1], COMPOUND_FID,
-			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT, NULL, 0,
-			     CIFSMaxBufSize -
-			     MAX_SMB2_CREATE_RESPONSE_SIZE -
-			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
-	if (rc)
-		goto query_rp_exit;
-
-	smb2_set_next_command(tcon, &rqst[1]);
-	smb2_set_related(&rqst[1]);
-
-	/* Close */
-	rqst[2].rq_iov = &vars->close_iov;
-	rqst[2].rq_nvec = 1;
-
-	rc = SMB2_close_init(tcon, server,
-			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
-	if (rc)
-		goto query_rp_exit;
-
-	smb2_set_related(&rqst[2]);
-
-	rc = compound_send_recv(xid, tcon->ses, server,
-				flags, 3, rqst,
-				resp_buftype, rsp_iov);
-
-	ioctl_rsp = rsp_iov[1].iov_base;
-
-	/*
-	 * Open was successful and we got an ioctl response.
-	 */
-	if (rc == 0) {
-		/* See MS-FSCC 2.3.23 */
-		off = le32_to_cpu(ioctl_rsp->OutputOffset);
-		count = le32_to_cpu(ioctl_rsp->OutputCount);
-		if (check_add_overflow(off, count, &len) ||
-		    len > rsp_iov[1].iov_len) {
-			cifs_tcon_dbg(VFS, "%s: invalid ioctl: off=%d count=%d\n",
-				      __func__, off, count);
-			rc = -EIO;
-			goto query_rp_exit;
-		}
-
-		reparse_buf = (void *)((u8 *)ioctl_rsp + off);
-		len = sizeof(*reparse_buf);
-		if (count < len ||
-		    count < le16_to_cpu(reparse_buf->ReparseDataLength) + len) {
-			cifs_tcon_dbg(VFS, "%s: invalid ioctl: off=%d count=%d\n",
-				      __func__, off, count);
-			rc = -EIO;
-			goto query_rp_exit;
-		}
-		*tag = le32_to_cpu(reparse_buf->ReparseTag);
-		*rsp = rsp_iov[1];
-		*rsp_buftype = resp_buftype[1];
-		resp_buftype[1] = CIFS_NO_BUFFER;
-	}
-
- query_rp_exit:
-	SMB2_open_free(&rqst[0]);
-	SMB2_ioctl_free(&rqst[1]);
-	SMB2_close_free(&rqst[2]);
-	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
-	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
-	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
-	kfree(vars);
-out_free_path:
-	kfree(utf16_path);
-	return rc;
-}
-
 static struct cifs_ntsd *
 get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
 		    const struct cifs_fid *cifsfid, u32 *pacllen, u32 info)
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index efa2f8fe23449..1e20f87a5f584 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -62,6 +62,12 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 				     struct cifs_tcon *tcon,
 				     const char *full_path,
 				     struct kvec *iov);
+int smb2_query_reparse_point(const unsigned int xid,
+			     struct cifs_tcon *tcon,
+			     struct cifs_sb_info *cifs_sb,
+			     const char *full_path,
+			     u32 *tag, struct kvec *rsp,
+			     int *rsp_buftype);
 int smb2_query_path_info(const unsigned int xid,
 			 struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb,
-- 
2.43.0



