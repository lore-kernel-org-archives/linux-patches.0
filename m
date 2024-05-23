Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5046D1E497;
	Thu, 23 May 2024 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470654; cv=none; b=ea8qZdE2bbGrg+swlJ1Sdgh4b5WKIl//I8HuavV279egRiqymp01XGBKgdU8OdFEUp591Oyly6FzbNSqTBQEE9yJ198l4fsO127ffeJ0Zd6o52gN7xgkzihHvaarb3x1VPFQjo4b3h53QLHCTILouaZdmfaxpN9Q8j7MbP9w2Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470654; c=relaxed/simple;
	bh=XMYMEKkNuvgzDZSH7hgey4JLAZTZubP28YwI1EImEjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngRxwXqFh76dBJnKAphnLrCs0DbgbWJN8omXXpadAjC3ZyDn4d1PaAtXq2jhd7ISdNSI6maQhZIIprXFNWbSV/8gvgu+aaG1G41ApwLW35TDYmchkC4A00ib49ie1sFgSzUuAncGjoD9HlKj69TiPYJ4K2vgCWHzcuzrs+ILyPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CE+/DwcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CE+/DwcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C28C2BD10;
	Thu, 23 May 2024 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470653;
	bh=XMYMEKkNuvgzDZSH7hgey4JLAZTZubP28YwI1EImEjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CE+/DwcJcaB8SkRwluJV+9Jnc3adDn/DYq9Yh/4f97PkuQaZ9gl/cTylmg6K8dRqr
	 diAIbnvjubsNX9fPxABgOuPrRcdvyo+Yg3cQ1Hais8auFtLgckIFxGNyu3o5rhKfuX
	 AzaRGoBTfLSPP08g3LxofmgjB3oH4YMuiN0cwXYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/102] smb: client: get rid of smb311_posix_query_path_info()
Date: Thu, 23 May 2024 15:13:06 +0200
Message-ID: <20240523130344.014795261@linuxfoundation.org>
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

[ Upstream commit f83709b9e0eb7048d74ba4515f268c6eacbce9c9 ]

Merge smb311_posix_query_path_info into ->query_path_info() to get rid
of duplicate code.

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c     |   4 +-
 fs/smb/client/smb2inode.c | 115 +++++++++++---------------------------
 2 files changed, 36 insertions(+), 83 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0110589acb853..d7e3da8489a0b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1313,6 +1313,7 @@ static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 				  const unsigned int xid)
 {
 	struct cifs_open_info_data tmp_data = {};
+	struct TCP_Server_Info *server;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
@@ -1323,12 +1324,13 @@ static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
 
 	/*
 	 * 1. Fetch file metadata if not provided (data)
 	 */
 	if (!data) {
-		rc = smb311_posix_query_path_info(xid, tcon, cifs_sb,
+		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
 						  full_path, &tmp_data);
 		data = &tmp_data;
 	}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 4cd4b8a63316d..dfa4e5362213f 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -699,7 +699,7 @@ int smb2_query_path_info(const unsigned int xid,
 	struct smb2_hdr *hdr;
 	struct kvec in_iov[2], out_iov[3] = {};
 	int out_buftype[3] = {};
-	int cmds[2] = { SMB2_OP_QUERY_INFO,  };
+	int cmds[2];
 	bool islink;
 	int i, num_cmds;
 	int rc, rc2;
@@ -707,20 +707,36 @@ int smb2_query_path_info(const unsigned int xid,
 	data->adjust_tz = false;
 	data->reparse_point = false;
 
-	if (strcmp(full_path, ""))
-		rc = -ENOENT;
-	else
-		rc = open_cached_dir(xid, tcon, full_path, cifs_sb, false, &cfid);
-	/* If it is a root and its handle is cached then use it */
-	if (!rc) {
-		if (cfid->file_all_info_is_valid) {
-			memcpy(&data->fi, &cfid->file_all_info, sizeof(data->fi));
+	/*
+	 * BB TODO: Add support for using cached root handle in SMB3.1.1 POSIX.
+	 * Create SMB2_query_posix_info worker function to do non-compounded
+	 * query when we already have an open file handle for this. For now this
+	 * is fast enough (always using the compounded version).
+	 */
+	if (!tcon->posix_extensions) {
+		if (*full_path) {
+			rc = -ENOENT;
 		} else {
-			rc = SMB2_query_info(xid, tcon, cfid->fid.persistent_fid,
-					     cfid->fid.volatile_fid, &data->fi);
+			rc = open_cached_dir(xid, tcon, full_path,
+					     cifs_sb, false, &cfid);
 		}
-		close_cached_dir(cfid);
-		return rc;
+		/* If it is a root and its handle is cached then use it */
+		if (!rc) {
+			if (cfid->file_all_info_is_valid) {
+				memcpy(&data->fi, &cfid->file_all_info,
+				       sizeof(data->fi));
+			} else {
+				rc = SMB2_query_info(xid, tcon,
+						     cfid->fid.persistent_fid,
+						     cfid->fid.volatile_fid,
+						     &data->fi);
+			}
+			close_cached_dir(cfid);
+			return rc;
+		}
+		cmds[0] = SMB2_OP_QUERY_INFO;
+	} else {
+		cmds[0] = SMB2_OP_POSIX_QUERY_INFO;
 	}
 
 	in_iov[0].iov_base = data;
@@ -743,6 +759,10 @@ int smb2_query_path_info(const unsigned int xid,
 	switch (rc) {
 	case 0:
 	case -EOPNOTSUPP:
+		/*
+		 * BB TODO: When support for special files added to Samba
+		 * re-verify this path.
+		 */
 		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
 		if (rc || !data->reparse_point)
 			goto out;
@@ -782,75 +802,6 @@ int smb2_query_path_info(const unsigned int xid,
 	return rc;
 }
 
-int smb311_posix_query_path_info(const unsigned int xid,
-				 struct cifs_tcon *tcon,
-				 struct cifs_sb_info *cifs_sb,
-				 const char *full_path,
-				 struct cifs_open_info_data *data)
-{
-	int rc;
-	__u32 create_options = 0;
-	struct cifsFileInfo *cfile;
-	struct kvec in_iov[2], out_iov[3] = {};
-	int out_buftype[3] = {};
-	int cmds[2] = { SMB2_OP_POSIX_QUERY_INFO,  };
-	int i, num_cmds;
-
-	data->adjust_tz = false;
-	data->reparse_point = false;
-
-	/*
-	 * BB TODO: Add support for using the cached root handle.
-	 * Create SMB2_query_posix_info worker function to do non-compounded query
-	 * when we already have an open file handle for this. For now this is fast enough
-	 * (always using the compounded version).
-	 */
-	in_iov[0].iov_base = data;
-	in_iov[0].iov_len = sizeof(*data);
-	in_iov[1] = in_iov[0];
-
-	cifs_get_readable_path(tcon, full_path, &cfile);
-	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-			      FILE_READ_ATTRIBUTES, FILE_OPEN,
-			      create_options, ACL_NO_MODE, in_iov,
-			      cmds, 1, cfile, out_iov, out_buftype);
-	/*
-	 * If first iov is unset, then SMB session was dropped or we've got a
-	 * cached open file (@cfile).
-	 */
-	if (!out_iov[0].iov_base || out_buftype[0] == CIFS_NO_BUFFER)
-		goto out;
-
-	switch (rc) {
-	case 0:
-	case -EOPNOTSUPP:
-		/* BB TODO: When support for special files added to Samba re-verify this path */
-		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
-		if (rc || !data->reparse_point)
-			goto out;
-
-		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK) {
-			/* symlink already parsed in create response */
-			num_cmds = 1;
-		} else {
-			cmds[1] = SMB2_OP_GET_REPARSE;
-			num_cmds = 2;
-		}
-		create_options |= OPEN_REPARSE_POINT;
-		cifs_get_readable_path(tcon, full_path, &cfile);
-		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-				      FILE_READ_ATTRIBUTES, FILE_OPEN,
-				      create_options, ACL_NO_MODE, in_iov,
-				      cmds, num_cmds, cfile, NULL, NULL);
-		break;
-	}
-
-out:
-	for (i = 0; i < ARRAY_SIZE(out_buftype); i++)
-		free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
-	return rc;
-}
-
 int
 smb2_mkdir(const unsigned int xid, struct inode *parent_inode, umode_t mode,
 	   struct cifs_tcon *tcon, const char *name,
-- 
2.43.0



