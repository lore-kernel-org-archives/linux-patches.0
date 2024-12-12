Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F722215799;
	Thu, 12 Dec 2024 15:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018085; cv=none; b=O64LRB5UMYvV/XBfcPTNhzafMgVpj+/Uv/HZimYbm9mqWFbYNqc4lI5fVwbhdAcknNbY0WXlQY85OMw12H6tAbQMZUxKM5ELSWGFgMQEX7O4nThAgzl+PfV1HgAlWjKM+K/vZkFiwCcRsV/T/ShvYO+CeZeyFCiY0HQFKF72NPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018085; c=relaxed/simple;
	bh=064OqJX2HnleE9cTkZQ18ZMZ8gwVL7qh4XH7VUsE3vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkpTrapsb3xW8CjNX5Yj2I0Gx9u+UbmWxjdpayctqQ/ikyRl5fMFkHRnh+KatxBVjU1Bfg2JNPRzfZHL4AsiKxYxEvUM84hQjfuYRQcBevvMivy812BuRM+EnN83QVHZ82vu3n2y08ieO9DznJ7AhZh1WVzMrJt7ZqXd0jaiZQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvkZxvOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvkZxvOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFE9C4CECE;
	Thu, 12 Dec 2024 15:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018085;
	bh=064OqJX2HnleE9cTkZQ18ZMZ8gwVL7qh4XH7VUsE3vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvkZxvOqTquJJILoQSefZ+wJPHw0eADX99CUie73MZmjt1IHL83TEMPqGYMDQO9SI
	 nZgX4vgBCiH1WtCbiG9gI9yxJKCbwxQNXY/9hrKLdibeDI46E0zCCgQBKMLVq+f2F8
	 Y2nsPovblgo44pXkryqkvSuafIURtF7V9lxiSGBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 163/356] smb3.1.1: fix posix mounts to older servers
Date: Thu, 12 Dec 2024 15:58:02 +0100
Message-ID: <20241212144251.076182847@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

commit ddca5023091588eb303e3c0097d95c325992d05f upstream.

Some servers which implement the SMB3.1.1 POSIX extensions did not
set the file type in the mode in the infolevel 100 response.
With the recent changes for checking the file type via the mode field,
this can cause the root directory to be reported incorrectly and
mounts (e.g. to ksmbd) to fail.

Fixes: 6a832bc8bbb2 ("fs/smb/client: Implement new SMB3 POSIX type")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Cc: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsproto.h |    2 +-
 fs/smb/client/inode.c     |   11 ++++++++---
 fs/smb/client/readdir.c   |    3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -684,7 +684,7 @@ int parse_reparse_point(struct reparse_d
 int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev);
-umode_t wire_mode_to_posix(u32 wire);
+umode_t wire_mode_to_posix(u32 wire, bool is_dir);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -731,13 +731,17 @@ static u32 wire_filetype_to_posix(u32 wi
 	return posix_filetypes[wire_type];
 }
 
-umode_t wire_mode_to_posix(u32 wire)
+umode_t wire_mode_to_posix(u32 wire, bool is_dir)
 {
 	u32 wire_type;
 	u32 mode;
 
 	wire_type = (wire & POSIX_FILETYPE_MASK) >> POSIX_FILETYPE_SHIFT;
-	mode = (wire_perms_to_posix(wire) | wire_filetype_to_posix(wire_type));
+	/* older servers do not set POSIX file type in the mode field in the response */
+	if ((wire_type == 0) && is_dir)
+		mode = wire_perms_to_posix(wire) | S_IFDIR;
+	else
+		mode = (wire_perms_to_posix(wire) | wire_filetype_to_posix(wire_type));
 	return (umode_t)mode;
 }
 
@@ -777,7 +781,8 @@ static void smb311_posix_info_to_fattr(s
 	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
 	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
 	fattr->cf_nlink = le32_to_cpu(info->HardLinks);
-	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->Mode));
+	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->Mode),
+					    fattr->cf_cifsattrs & ATTR_DIRECTORY);
 
 	if (cifs_open_data_reparse(data) &&
 	    cifs_reparse_point_to_fattr(cifs_sb, fattr, data))
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -261,7 +261,8 @@ cifs_posix_to_fattr(struct cifs_fattr *f
 		fattr->cf_cifstag = le32_to_cpu(info->ReparseTag);
 
 	/* The Mode field in the response can now include the file type as well */
-	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->Mode));
+	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->Mode),
+					    fattr->cf_cifsattrs & ATTR_DIRECTORY);
 	fattr->cf_dtype = S_DT(le32_to_cpu(info->Mode));
 
 	switch (fattr->cf_mode & S_IFMT) {


