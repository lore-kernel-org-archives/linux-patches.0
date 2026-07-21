Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B74403EA1;
	Tue, 21 Jul 2026 22:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672059; cv=none; b=DP8deCwIVx9GF13CpFj4CNJe31t4XVHQulpBYPdCiLPbA0BH5mcU51jv2g0MkKwbAo+RTg3ISS3AgpI007YTW+eOnQ8UEcs9DkgUN8xUBsVr0SjuNeEAVWjwQY70pwX1p2blzdDQdZTPKwwatqfzgvD6veEhw/suhJYO4bUflbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672059; c=relaxed/simple;
	bh=JzlUmtoVLbNq8y0tGQa1m4vwToljFqldf7xvVEJc4N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMGGGgLeHMcFnkyXtMOBOdPQzkye5njAn64i1ZX5dCdCKP4Dd8OP8Cjbelq3miYUZnPcs6PVFnSntzBRRE6/G7V5gBL86Ozwy9f0IWZ/55aYEeS0q8VMJldYpk1WVVBf0hfot4vmj02E+ZCaMOYg+vsE3nqr8w5I5i/N5N6SP3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wu5bjMBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wu5bjMBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0211F000E9;
	Tue, 21 Jul 2026 22:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672058;
	bh=gjrkymkUdXf2rOAsWsUGfkJzRxWPVTPINO9UchUBULs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wu5bjMBbS/qQoj5pXKfUVDQfZhHei1eaUDXKkTBEMG9r/dxb4HKFHZ4rqe2QyouEl
	 htUDZyIGZNOW+s6/Pu63VvkUf7yuKsOlJ1uU94Co1jE2ZcdCDr1aRlobMOgOZK8Inu
	 zt/OXLh3xj20HKNyq2/g3daCNZLt/3VhGQj4FYCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 480/843] smb/client: preserve errors from smb2_set_sparse()
Date: Tue, 21 Jul 2026 17:21:55 +0200
Message-ID: <20260721152416.831566331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 2a4b3d2db5c6fcdba889baf7b2ae5661b0beac89 ]

smb2_set_sparse() converts every FSCTL_SET_SPARSE failure to false and
marks sparse support as broken for the share. Callers therefore report
EOPNOTSUPP even for errors such as ENOSPC or EACCES, and later sparse
operations remain disabled until the share is unmounted.

Return the SMB2 ioctl error directly. Set broken_sparse_sup only for
EOPNOTSUPP, which indicates that the server does not support the request.

Update smb3_punch_hole() to propagate the error returned by
smb2_set_sparse().

Fixes: 3d1a3745d8ca ("Add sparse file support to SMB2/SMB3 mounts")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c372ab70396513..47dc87af194047 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2047,8 +2047,9 @@ smb2_sync_write(const unsigned int xid, struct cifs_fid *pfid,
 }
 
 /* Set or clear the SPARSE_FILE attribute based on value passed in setsparse */
-static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
-		struct cifsFileInfo *cfile, struct inode *inode, __u8 setsparse)
+static int smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
+			   struct cifsFileInfo *cfile, struct inode *inode,
+			   __u8 setsparse)
 {
 	struct cifsInodeInfo *cifsi;
 	int rc;
@@ -2057,31 +2058,31 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* if file already sparse don't bother setting sparse again */
 	if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && setsparse)
-		return true; /* already sparse */
+		return 0; /* already sparse */
 
 	if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && !setsparse)
-		return true; /* already not sparse */
+		return 0; /* already not sparse */
 
 	/*
 	 * Can't check for sparse support on share the usual way via the
 	 * FS attribute info (FILE_SUPPORTS_SPARSE_FILES) on the share
 	 * since Samba server doesn't set the flag on the share, yet
 	 * supports the set sparse FSCTL and returns sparse correctly
-	 * in the file attributes. If we fail setting sparse though we
-	 * mark that server does not support sparse files for this share
-	 * to avoid repeatedly sending the unsupported fsctl to server
-	 * if the file is repeatedly extended.
+	 * in the file attributes. If the server returns EOPNOTSUPP, mark
+	 * that sparse files are not supported on this share to avoid
+	 * repeatedly sending the unsupported FSCTL.
 	 */
 	if (tcon->broken_sparse_sup)
-		return false;
+		return -EOPNOTSUPP;
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
 			&setsparse, 1, CIFSMaxBufSize, NULL, NULL);
 	if (rc) {
-		tcon->broken_sparse_sup = true;
+		if (rc == -EOPNOTSUPP)
+			tcon->broken_sparse_sup = true;
 		cifs_dbg(FYI, "set sparse rc = %d\n", rc);
-		return false;
+		return rc;
 	}
 
 	if (setsparse)
@@ -2089,7 +2090,7 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 	else
 		cifsi->cifsAttrs &= (~FILE_ATTRIBUTE_SPARSE_FILE);
 
-	return true;
+	return 0;
 }
 
 static int
@@ -3641,10 +3642,9 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	inode_lock(inode);
 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
-	if (!smb2_set_sparse(xid, tcon, cfile, inode, set_sparse)) {
-		rc = -EOPNOTSUPP;
+	rc = smb2_set_sparse(xid, tcon, cfile, inode, set_sparse);
+	if (rc)
 		goto out;
-	}
 
 	filemap_invalidate_lock(inode->i_mapping);
 	/*
-- 
2.53.0



