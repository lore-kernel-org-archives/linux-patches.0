Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF836403EA5;
	Tue, 21 Jul 2026 21:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669669; cv=none; b=gG0AkLo895LWCmkY7QmLu+FBsHQVD+BIcW9opDjccSA+DAlt88UxRAbCfDWdjIus8/ld+dymJI/M/ftkpncOvQuGmvUIl7qN3ujOgl+Ualy0mdY0SE+ixWXj2PFyoOnBoJPyBuc9LQQ7ofC/9S8Q7xb/v7lOYixLoQMDCmdCO7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669669; c=relaxed/simple;
	bh=UT8WoIGnEVakEczL8itx7hXdTQfIq5DDNVuzbW0rgBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8R+BBS8WF58sKEfpFid1QvWPAP85X2u0/MfM8tIeSnmpV6eMnMsZKRMYqn3LoqH8wsTsN9HwjpRIVSwPwkz0DfBqumf0hbHVH/LMz9mY+fYFXe6OwosimgOVXeyiKyKn6PjSGqnjX/kpHtW6CPbjJoXMptxmBngmtvLEKJKj6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGz0Iwhu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGz0Iwhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB631F00A3D;
	Tue, 21 Jul 2026 21:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669666;
	bh=4eoNoodR0sEM16vT6qI3bBkyntQHu/rVMYMWgY6Ck/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGz0IwhuyBAk4FKt0Eqzl/tCSoEXqvMz8LFPLUMPnDW/cgQkEOwLSvgfCDWTjACam
	 eGj5wHzE62Ozs+idqdLG6yi0O4En0rR6cVZREBA4BUxSqfFIuck+SDR0ef7qOsfG4b
	 J26C0hzFlJVq+6qzTNDcrx0Ppm0FQYzQVYAz2G9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0640/1067] smb/client: preserve errors from smb2_set_sparse()
Date: Tue, 21 Jul 2026 17:20:41 +0200
Message-ID: <20260721152438.909110023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/client/smb2ops.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 353f5ba1022502..65a6bd18a604b3 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1924,8 +1924,9 @@ smb2_sync_write(const unsigned int xid, struct cifs_fid *pfid,
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
@@ -1934,31 +1935,31 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 
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
@@ -1966,7 +1967,7 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 	else
 		cifsi->cifsAttrs &= (~FILE_ATTRIBUTE_SPARSE_FILE);
 
-	return true;
+	return 0;
 }
 
 static int
@@ -3576,10 +3577,9 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
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



