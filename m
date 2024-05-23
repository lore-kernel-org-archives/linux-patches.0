Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547F214BF89;
	Thu, 23 May 2024 13:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470602; cv=none; b=WtdvjpyHoD2b9HLwwdbZ6POWJU30oStrJ8kPjfHxtHWoGKbtzaAM8jS238Nd0IB2NVWvOOdOmsRSAlPkpnRurUoPyUPz3yy5GGpnwxTBMqLcocYhESeL+NZsvPZF/Kq77vTfWV7ASFLVsdIkkjRVkt3KCgWZ5578w3sqeR/gPF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470602; c=relaxed/simple;
	bh=lCHh3CowkY31HaJn6l9iRUCkQs5r3WRKdfcReKf+p7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vl5J+Bv+3NJV72iwnMpZ6jlcuEwUWOlJMOqG65GzEENnd0kF9cDLjLBjCxgh25gPoR+NLIIsWPJAPjVpvgrY9rCALkPaCH+0UGUx/5lH05C2A3w4c2A43ttIaTMle8Hh0FkPFg4GF3wpIcd8x/9vEpCQEtxo9PrCSY5+CeoZuZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B93TDpvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B93TDpvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBB7C32781;
	Thu, 23 May 2024 13:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470601;
	bh=lCHh3CowkY31HaJn6l9iRUCkQs5r3WRKdfcReKf+p7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B93TDpvlHbWGufmbITLs81GTb5nKyMmavEkqUS1x3EULlqkqwNbZb+X//7kWDsUlG
	 4jA4O3/gvbTZKbC+g3XGtPlaHduAcruDQQEhCIXXlercN9t7mQhTaceky+5G12kqg4
	 oe5ljxo0PXmieV4TZG9IpuuVPPFHrC345hZfaIqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/102] smb: client: allow creating symlinks via reparse points
Date: Thu, 23 May 2024 15:12:41 +0200
Message-ID: <20240523130343.077083052@linuxfoundation.org>
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

[ Upstream commit 514d793e27a310eb26b112c1f8f1a160472907e5 ]

Add support for creating symlinks via IO_REPARSE_TAG_SYMLINK reparse
points in SMB2+.

These are fully supported by most SMB servers and documented in
MS-FSCC.  Also have the advantage of requiring fewer roundtrips as
their symlink targets can be parsed directly from CREATE responses on
STATUS_STOPPED_ON_SYMLINK errors.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311260838.nx5mkj1j-lkp@intel.com/
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h |  6 ++++
 fs/smb/client/link.c     | 15 ++++++---
 fs/smb/client/smb2ops.c  | 70 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3e7c3c3d73a73..414648bf816b2 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -577,6 +577,12 @@ struct smb_version_operations {
 	int (*parse_reparse_point)(struct cifs_sb_info *cifs_sb,
 				   struct kvec *rsp_iov,
 				   struct cifs_open_info_data *data);
+	int (*create_reparse_symlink)(const unsigned int xid,
+				      struct inode *inode,
+				      struct dentry *dentry,
+				      struct cifs_tcon *tcon,
+				      const char *full_path,
+				      const char *symname);
 };
 
 struct smb_version_values {
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 691f43a1ec2bc..d86da949a9190 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -569,6 +569,7 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	int rc = -EOPNOTSUPP;
 	unsigned int xid;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct TCP_Server_Info *server;
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
 	const char *full_path;
@@ -590,6 +591,7 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 		goto symlink_exit;
 	}
 	pTcon = tlink_tcon(tlink);
+	server = cifs_pick_channel(pTcon->ses);
 
 	full_path = build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
@@ -601,17 +603,20 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	cifs_dbg(FYI, "symname is %s\n", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
 		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	else if (pTcon->unix_ext)
+	} else if (pTcon->unix_ext) {
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
 					   cifs_sb->local_nls,
 					   cifs_remap(cifs_sb));
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-	/* else
-	   rc = CIFSCreateReparseSymLink(xid, pTcon, fromName, toName,
-					cifs_sb_target->local_nls); */
+	} else if (server->ops->create_reparse_symlink) {
+		rc =  server->ops->create_reparse_symlink(xid, inode, direntry,
+							  pTcon, full_path,
+							  symname);
+		goto symlink_exit;
+	}
 
 	if (rc == 0) {
 		if (pTcon->posix_extensions) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4fed19d5a81d4..c5957deb1a859 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5246,6 +5246,72 @@ static int nfs_make_node(unsigned int xid, struct inode *inode,
 	return rc;
 }
 
+static int smb2_create_reparse_symlink(const unsigned int xid,
+				       struct inode *inode,
+				       struct dentry *dentry,
+				       struct cifs_tcon *tcon,
+				       const char *full_path,
+				       const char *symname)
+{
+	struct reparse_symlink_data_buffer *buf = NULL;
+	struct cifs_open_info_data data;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct inode *new;
+	struct kvec iov;
+	__le16 *path;
+	char *sym;
+	u16 len, plen;
+	int rc = 0;
+
+	sym = kstrdup(symname, GFP_KERNEL);
+	if (!sym)
+		return -ENOMEM;
+
+	data = (struct cifs_open_info_data) {
+		.reparse_point = true,
+		.reparse = { .tag = IO_REPARSE_TAG_SYMLINK, },
+		.symlink_target = sym,
+	};
+
+	path = cifs_convert_path_to_utf16(symname, cifs_sb);
+	if (!path) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	plen = 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
+	len = sizeof(*buf) + plen * 2;
+	buf = kzalloc(len, GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	buf->ReparseTag = cpu_to_le32(IO_REPARSE_TAG_SYMLINK);
+	buf->ReparseDataLength = cpu_to_le16(len - sizeof(struct reparse_data_buffer));
+	buf->SubstituteNameOffset = cpu_to_le16(plen);
+	buf->SubstituteNameLength = cpu_to_le16(plen);
+	memcpy(&buf->PathBuffer[plen], path, plen);
+	buf->PrintNameOffset = 0;
+	buf->PrintNameLength = cpu_to_le16(plen);
+	memcpy(buf->PathBuffer, path, plen);
+	buf->Flags = cpu_to_le32(*symname != '/' ? SYMLINK_FLAG_RELATIVE : 0);
+
+	iov.iov_base = buf;
+	iov.iov_len = len;
+	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+				     tcon, full_path, &iov);
+	if (!IS_ERR(new))
+		d_instantiate(dentry, new);
+	else
+		rc = PTR_ERR(new);
+out:
+	kfree(path);
+	cifs_free_open_info(&data);
+	kfree(buf);
+	return rc;
+}
+
 static int smb2_make_node(unsigned int xid, struct inode *inode,
 			  struct dentry *dentry, struct cifs_tcon *tcon,
 			  const char *full_path, umode_t mode, dev_t dev)
@@ -5322,6 +5388,7 @@ struct smb_version_operations smb20_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5424,6 +5491,7 @@ struct smb_version_operations smb21_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5530,6 +5598,7 @@ struct smb_version_operations smb30_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5645,6 +5714,7 @@ struct smb_version_operations smb311_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
-- 
2.43.0



