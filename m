Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E0E1DDC22;
	Thu, 30 Jan 2025 14:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246534; cv=none; b=Ma+OkecJxPNPm9PNL1rPB/+jk7kJTGk3lpCcpc8KdTQ8IvLbju6zg9ar84U7YIGRpgxmCVB7dE7P3E5X262rmFT696FWZuBEhPL0UkKSRI+JFKEXQAOtn1S4SyVisT0SBi+vpzuji/Y4TByKKU6/mlsNBQSzXXyj4CG/+gPHGBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246534; c=relaxed/simple;
	bh=6VX2MZ5lU0sXcWpOfkeEOONmO0PeRvNakE2QqU30WNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HvmG5yl4iajXWrU3zaTe6JBog605BmK+gKFwzIVDWukLuBD841hO3k1/FxCknow9GjoLR198/13Jz0UK5H1l+XBEigkjuahCu+i2Sx3hWXvcHq8wyZTm5DvWODMblL/RceOkjxR8RcUmgTB7itZu8Un8CNxgSqmbatBhGm2AobE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yg623zG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yg623zG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DDAC4CED2;
	Thu, 30 Jan 2025 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246534;
	bh=6VX2MZ5lU0sXcWpOfkeEOONmO0PeRvNakE2QqU30WNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yg623zG9DpVD3KZnVyiG+s2TiN7aeCP7dYTy4F+Yfa1W+jeCXQVpCRmKyDUP1QrYR
	 LEC89HEy0fQJlVEEWtnySXBc8+5isjN3snXr47PaiUmhQCOYdj0ZbQ+YjOAOLKUBx2
	 ZNoU/1u+eqdjp6487R6KU0QHwG/L7dBgrPZ9/WTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 25/43] smb: client: handle lack of EA support in smb2_query_path_info()
Date: Thu, 30 Jan 2025 14:59:32 +0100
Message-ID: <20250130133459.917144190@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 3681c74d342db75b0d641ba60de27bf73e16e66b upstream.

If the server doesn't support both EAs and reparse point in a file,
the SMB2_QUERY_INFO request will fail with either
STATUS_NO_EAS_ON_FILE or STATUS_EAS_NOT_SUPPORT in the compound chain,
so ignore it as long as reparse point isn't
IO_REPARSE_TAG_LX_(CHR|BLK), which would require the EAs to know about
major/minor numbers.

Reported-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |   92 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 69 insertions(+), 23 deletions(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -176,27 +176,27 @@ static int smb2_compound_op(const unsign
 			    struct kvec *out_iov, int *out_buftype, struct dentry *dentry)
 {
 
-	struct reparse_data_buffer *rbuf;
+	struct smb2_query_info_rsp *qi_rsp = NULL;
 	struct smb2_compound_vars *vars = NULL;
-	struct kvec *rsp_iov, *iov;
-	struct smb_rqst *rqst;
-	int rc;
-	__le16 *utf16_path = NULL;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct cifs_fid fid;
+	struct cifs_open_info_data *idata;
 	struct cifs_ses *ses = tcon->ses;
+	struct reparse_data_buffer *rbuf;
 	struct TCP_Server_Info *server;
-	int num_rqst = 0, i;
 	int resp_buftype[MAX_COMPOUND];
-	struct smb2_query_info_rsp *qi_rsp = NULL;
-	struct cifs_open_info_data *idata;
+	int retries = 0, cur_sleep = 1;
+	__u8 delete_pending[8] = {1,};
+	struct kvec *rsp_iov, *iov;
 	struct inode *inode = NULL;
-	int flags = 0;
-	__u8 delete_pending[8] = {1, 0, 0, 0, 0, 0, 0, 0};
+	__le16 *utf16_path = NULL;
+	struct smb_rqst *rqst;
 	unsigned int size[2];
-	void *data[2];
+	struct cifs_fid fid;
+	int num_rqst = 0, i;
 	unsigned int len;
-	int retries = 0, cur_sleep = 1;
+	int tmp_rc, rc;
+	int flags = 0;
+	void *data[2];
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -637,7 +637,14 @@ finished:
 		tcon->need_reconnect = true;
 	}
 
+	tmp_rc = rc;
 	for (i = 0; i < num_cmds; i++) {
+		char *buf = rsp_iov[i + i].iov_base;
+
+		if (buf && resp_buftype[i + 1] != CIFS_NO_BUFFER)
+			rc = server->ops->map_error(buf, false);
+		else
+			rc = tmp_rc;
 		switch (cmds[i]) {
 		case SMB2_OP_QUERY_INFO:
 			idata = in_iov[i].iov_base;
@@ -803,6 +810,7 @@ finished:
 		}
 	}
 	SMB2_close_free(&rqst[num_rqst]);
+	rc = tmp_rc;
 
 	num_cmds += 2;
 	if (out_iov && out_buftype) {
@@ -858,22 +866,52 @@ static int parse_create_response(struct
 	return rc;
 }
 
+/* Check only if SMB2_OP_QUERY_WSL_EA command failed in the compound chain */
+static bool ea_unsupported(int *cmds, int num_cmds,
+			   struct kvec *out_iov, int *out_buftype)
+{
+	int i;
+
+	if (cmds[num_cmds - 1] != SMB2_OP_QUERY_WSL_EA)
+		return false;
+
+	for (i = 1; i < num_cmds - 1; i++) {
+		struct smb2_hdr *hdr = out_iov[i].iov_base;
+
+		if (out_buftype[i] == CIFS_NO_BUFFER || !hdr ||
+		    hdr->Status != STATUS_SUCCESS)
+			return false;
+	}
+	return true;
+}
+
+static inline void free_rsp_iov(struct kvec *iovs, int *buftype, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		free_rsp_buf(buftype[i], iovs[i].iov_base);
+		memset(&iovs[i], 0, sizeof(*iovs));
+		buftype[i] = CIFS_NO_BUFFER;
+	}
+}
+
 int smb2_query_path_info(const unsigned int xid,
 			 struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb,
 			 const char *full_path,
 			 struct cifs_open_info_data *data)
 {
+	struct kvec in_iov[3], out_iov[5] = {};
+	struct cached_fid *cfid = NULL;
 	struct cifs_open_parms oparms;
-	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
-	struct cached_fid *cfid = NULL;
+	__u32 create_options = 0;
+	int out_buftype[5] = {};
 	struct smb2_hdr *hdr;
-	struct kvec in_iov[3], out_iov[3] = {};
-	int out_buftype[3] = {};
+	int num_cmds = 0;
 	int cmds[3];
 	bool islink;
-	int i, num_cmds = 0;
 	int rc, rc2;
 
 	data->adjust_tz = false;
@@ -943,14 +981,14 @@ int smb2_query_path_info(const unsigned
 		if (rc || !data->reparse_point)
 			goto out;
 
-		if (!tcon->posix_extensions)
-			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
 		/*
 		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
 		 * response.
 		 */
 		if (data->reparse.tag != IO_REPARSE_TAG_SYMLINK)
 			cmds[num_cmds++] = SMB2_OP_GET_REPARSE;
+		if (!tcon->posix_extensions)
+			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
 
 		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 				     FILE_READ_ATTRIBUTES |
@@ -958,9 +996,18 @@ int smb2_query_path_info(const unsigned
 				     FILE_OPEN, create_options |
 				     OPEN_REPARSE_POINT, ACL_NO_MODE);
 		cifs_get_readable_path(tcon, full_path, &cfile);
+		free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(out_iov));
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      &oparms, in_iov, cmds, num_cmds,
-				      cfile, NULL, NULL, NULL);
+				      cfile, out_iov, out_buftype, NULL);
+		if (rc && ea_unsupported(cmds, num_cmds,
+					 out_iov, out_buftype)) {
+			if (data->reparse.tag != IO_REPARSE_TAG_LX_BLK &&
+			    data->reparse.tag != IO_REPARSE_TAG_LX_CHR)
+				rc = 0;
+			else
+				rc = -EOPNOTSUPP;
+		}
 		break;
 	case -EREMOTE:
 		break;
@@ -978,8 +1025,7 @@ int smb2_query_path_info(const unsigned
 	}
 
 out:
-	for (i = 0; i < ARRAY_SIZE(out_buftype); i++)
-		free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
+	free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(out_iov));
 	return rc;
 }
 


