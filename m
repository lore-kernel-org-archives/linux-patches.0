Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C104D1779B1;
	Tue,  8 Oct 2024 12:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390914; cv=none; b=JHXJr5pdq2q1kV+55ImD5TNj4eoDYb+RuHjAQO77if//SK+9rLvhd+YTm9XT8CNP+FF9RnNHgaqJCgdgqt3hJTpb3AGGrJ4Y0T88LtlP5c+nxKzS7w6fRynsxEb7KAeGsraqqGwPR5XJrQuSCmoftrBX3dIGes1PC0eygHyvisM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390914; c=relaxed/simple;
	bh=UmGshN0ubdruZROWqGQahL4MYx3yrM2d8lNnTBx1n4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7mEvT0EtPAmCSWqwj5pmudFD3f26nS28avqk7Lj57o3eQkF2W1dWYOXnLn7jo2aGTmv/XWqSLmO8rxIve/G9cK3BPwOHrOeb/ro3aPLjpoUrTCxNpm0vccTHjTDw8ZcSJ/E/0g5SysFQnFjHaljPCEA+vMz3CreE5+GFUU0/Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T26rFIW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T26rFIW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360DCC4CEC7;
	Tue,  8 Oct 2024 12:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390914;
	bh=UmGshN0ubdruZROWqGQahL4MYx3yrM2d8lNnTBx1n4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T26rFIW1Fl3LKhtcrU49YzHEITqBgJZe13Xsa+K7zgb406WXQXZmJv3dSiEa1gnse
	 z5K9efDmYT9LDtW1LANudiyeFYKlQdtFHTChxmI4EZoqi6oH8MoPl4ViFO5x4NsCos
	 aBS0fwLPkry72NFk35yZ2cnViqxEJoHJ0GpLoXLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangrong <wangrong@uniontech.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 400/482] smb: client: use actual path when queryfs
Date: Tue,  8 Oct 2024 14:07:43 +0200
Message-ID: <20241008115704.150921976@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangrong <wangrong@uniontech.com>

commit a421e3fe0e6abe27395078f4f0cec5daf466caea upstream.

Due to server permission control, the client does not have access to
the shared root directory, but can access subdirectories normally, so
users usually mount the shared subdirectories directly. In this case,
queryfs should use the actual path instead of the root directory to
avoid the call returning an error (EACCES).

Signed-off-by: wangrong <wangrong@uniontech.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c   |   13 ++++++++++++-
 fs/smb/client/cifsglob.h |    2 +-
 fs/smb/client/smb1ops.c  |    2 +-
 fs/smb/client/smb2ops.c  |   19 ++++++++++++-------
 4 files changed, 26 insertions(+), 10 deletions(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -313,8 +313,17 @@ cifs_statfs(struct dentry *dentry, struc
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int xid;
 	int rc = 0;
+	const char *full_path;
+	void *page;
 
 	xid = get_xid();
+	page = alloc_dentry_path();
+
+	full_path = build_path_from_dentry(dentry, page);
+	if (IS_ERR(full_path)) {
+		rc = PTR_ERR(full_path);
+		goto statfs_out;
+	}
 
 	if (le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength) > 0)
 		buf->f_namelen =
@@ -330,8 +339,10 @@ cifs_statfs(struct dentry *dentry, struc
 	buf->f_ffree = 0;	/* unlimited */
 
 	if (server->ops->queryfs)
-		rc = server->ops->queryfs(xid, tcon, cifs_sb, buf);
+		rc = server->ops->queryfs(xid, tcon, full_path, cifs_sb, buf);
 
+statfs_out:
+	free_dentry_path(page);
 	free_xid(xid);
 	return rc;
 }
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -482,7 +482,7 @@ struct smb_version_operations {
 			__u16 net_fid, struct cifsInodeInfo *cifs_inode);
 	/* query remote filesystem */
 	int (*queryfs)(const unsigned int, struct cifs_tcon *,
-		       struct cifs_sb_info *, struct kstatfs *);
+		       const char *, struct cifs_sb_info *, struct kstatfs *);
 	/* send mandatory brlock to the server */
 	int (*mand_lock)(const unsigned int, struct cifsFileInfo *, __u64,
 			 __u64, __u32, int, int, bool);
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -909,7 +909,7 @@ cifs_oplock_response(struct cifs_tcon *t
 
 static int
 cifs_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
-	     struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
+	     const char *path, struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
 {
 	int rc = -EOPNOTSUPP;
 
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2816,7 +2816,7 @@ out_free_path:
 
 static int
 smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
-	     struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
+	     const char *path, struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
 {
 	struct smb2_query_info_rsp *rsp;
 	struct smb2_fs_full_size_info *info = NULL;
@@ -2825,7 +2825,7 @@ smb2_queryfs(const unsigned int xid, str
 	int rc;
 
 
-	rc = smb2_query_info_compound(xid, tcon, "",
+	rc = smb2_query_info_compound(xid, tcon, path,
 				      FILE_READ_ATTRIBUTES,
 				      FS_FULL_SIZE_INFORMATION,
 				      SMB2_O_INFO_FILESYSTEM,
@@ -2853,28 +2853,33 @@ qfs_exit:
 
 static int
 smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
-	       struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
+	       const char *path, struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
 {
 	int rc;
-	__le16 srch_path = 0; /* Null - open root of share */
+	__le16 *utf16_path = NULL;
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 
 	if (!tcon->posix_extensions)
-		return smb2_queryfs(xid, tcon, cifs_sb, buf);
+		return smb2_queryfs(xid, tcon, path, cifs_sb, buf);
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
-		.path = "",
+		.path = path,
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
 		.fid = &fid,
 	};
 
-	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (utf16_path == NULL)
+		return -ENOMEM;
+
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
+	kfree(utf16_path);
 	if (rc)
 		return rc;
 


