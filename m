Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3C0216E1D;
	Thu, 12 Dec 2024 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016359; cv=none; b=qfSWuAe5Orl8q+Wqn2HNBdLgyB06FyjsXalRLAHoJejBBtxSWk4L0Z+Qdi39/bzsmThROyYQgv5neQIwqVpF4C++UkK8m9+LfWOVHERAWTkn34xeLTcL+jbW3WYqvB6gZ+gX902YqnUdqqpeQ8lD4Nfzpr4JDUHEROntPJ5yIWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016359; c=relaxed/simple;
	bh=tp95/vOeh0YtnTrE0nMclVDfcm98Dnz9BsnFiLRP/rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJVsC1fI4U3k+LBFJhrT1CivgHVJwrNe1IeacymPIKik5myikxGNUk1ZUCJsMh9vDFe+mqv4e/KM00jy85DulIUXG8jf1GSPjQ7BiUDlwcb8p+gYUs/eCTytTiQy0pSn/u36q4YphVJTIe0yIjpU15hAUy4ByOEuABNReUOGUEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKSBDpkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKSBDpkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD4DC4AF09;
	Thu, 12 Dec 2024 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016359;
	bh=tp95/vOeh0YtnTrE0nMclVDfcm98Dnz9BsnFiLRP/rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKSBDpkMrxgQdxNEqZoKRl+7dLSrzYe5819D68vjswV8bAAZ8K5OprpssgmdjcsVD
	 YGNPKyvSwRmSMT5P7Zp6rhH7J08jaQ72aTSNNE8oyg7Vp4oMWevxwN9mpUGyNyhw3d
	 UkM7Tvj7hRVMoxsuCbA5OGTnt+J5aNA/lzqhq7tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 159/466] smb3.1.1: fix posix mounts to older servers
Date: Thu, 12 Dec 2024 15:55:28 +0100
Message-ID: <20241212144313.076429403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -677,7 +677,7 @@ int __cifs_sfu_make_node(unsigned int xi
 int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev);
-umode_t wire_mode_to_posix(u32 wire);
+umode_t wire_mode_to_posix(u32 wire, bool is_dir);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -792,13 +792,17 @@ static u32 wire_filetype_to_posix(u32 wi
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
 
@@ -838,7 +842,8 @@ static void smb311_posix_info_to_fattr(s
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


