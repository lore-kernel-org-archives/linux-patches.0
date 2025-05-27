Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F11E89C;
	Tue, 27 May 2025 17:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366459; cv=none; b=D4W3LQS/WXr8B/+5sNEkeidkCYvFkYBAeoM2F4oBp+Lvcv+C+silGT2Xni7g1RHgcJ8Q0/uXBp5R0xSihffXJNob4B7Kui+jz2BXvzTUOquAbicdXnBT7JPjjwbpBAAJWeoBB3AngsNjDSJIOdu/+2mCxhX/ZA+K8depM03H1c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366459; c=relaxed/simple;
	bh=QMEvCTuGi/JB7dyPBdZF1WJghJuC5fEfQAZQaO57h4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1Ih2LvFl7fdb+JCJKXdOJkLDyzIUbQK7LAGD0mG7w6MqGPaZ2zLrdmIpdIkJTytSyHq0uoLere/cnJ8J9XaIAVeCkJTyba679vAqBDOKmy3w29ZObOAFJLRhqeT+MxGO6LkaZMCizxp4HztX6vuzzE8e4ouml3/02FEIaWwNbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tD7ifQSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tD7ifQSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD0BC4CEE9;
	Tue, 27 May 2025 17:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366459;
	bh=QMEvCTuGi/JB7dyPBdZF1WJghJuC5fEfQAZQaO57h4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tD7ifQSbjUqLqOOFebJul3Ik6SgAuw4PTi/lSfkEKlii1cfowcVw7OITEmmynq/nV
	 j4NnYbS6YdVClYCvly6125MRZr7BIZhkZ88tfPeS5g4lJb8ScvQw7Fpruq7bGUEqzl
	 Qf3jufpVadnRLS37BAxzgrlfuhBHTECA07OpJtw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 074/783] cifs: Check if server supports reparse points before using them
Date: Tue, 27 May 2025 18:17:51 +0200
Message-ID: <20250527162516.144613903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 6c06be908ca190e2d8feae1cf452d78598cd0b94 ]

Do not attempt to query or create reparse point when server fs does not
support it. This will prevent creating unusable empty object on the server.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c   | 3 +++
 fs/smb/client/link.c      | 3 ++-
 fs/smb/client/smb2inode.c | 8 ++++++++
 fs/smb/client/smb2ops.c   | 4 ++--
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index e90811f321944..53e3e8282cb2a 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2725,6 +2725,9 @@ int cifs_query_reparse_point(const unsigned int xid,
 	if (cap_unix(tcon->ses))
 		return -EOPNOTSUPP;
 
+	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
+		return -EOPNOTSUPP;
+
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 34a026243287f..769752ad2c5ce 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -643,7 +643,8 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	case CIFS_SYMLINK_TYPE_NATIVE:
 	case CIFS_SYMLINK_TYPE_NFS:
 	case CIFS_SYMLINK_TYPE_WSL:
-		if (server->ops->create_reparse_symlink) {
+		if (server->ops->create_reparse_symlink &&
+		    (le32_to_cpu(pTcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS)) {
 			rc = server->ops->create_reparse_symlink(xid, inode,
 								 direntry,
 								 pTcon,
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 826b57a5a2a8d..e9fd3e204a6f4 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1273,6 +1273,14 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	int rc;
 	int i;
 
+	/*
+	 * If server filesystem does not support reparse points then do not
+	 * attempt to create reparse point. This will prevent creating unusable
+	 * empty object on the server.
+	 */
+	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     SYNCHRONIZE | DELETE |
 			     FILE_READ_ATTRIBUTES |
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6795970d4de6e..fbb3686292134 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5237,7 +5237,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 			  const char *full_path, umode_t mode, dev_t dev)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	int rc;
+	int rc = -EOPNOTSUPP;
 
 	/*
 	 * Check if mounted with mount parm 'sfu' mount parm.
@@ -5248,7 +5248,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
 		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
 					full_path, mode, dev);
-	} else {
+	} else if (le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS) {
 		rc = smb2_mknod_reparse(xid, inode, dentry, tcon,
 					full_path, mode, dev);
 	}
-- 
2.39.5



