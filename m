Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65FB3AFAEC;
	Tue, 21 Jul 2026 20:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666722; cv=none; b=VUr3RHBHJlyd1rkp7XxPC7CcjZxMv6dXV9Ocwc2eIH6BgW6seaE80sro4MJmAxZULkjeywWhQ3B4ma1BB1QSDWQo9oaq75fg9+KWUYNKKs+XVIyRmD/IfOAOfSjKEF3pQe/qDrLTnKAsl7kobPsE/ZFGMBJENu1ldcIRci+jozA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666722; c=relaxed/simple;
	bh=GdWAehr/ls7vU/lGxY06ZMTR67eyl5A6BqHuK5pykeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGye44fOdCybM4vXTErGND+2TpYLtbtIREO1nCpXiAhIhh1V+cCPtH6seQ5eBygRaxx5J+mt4C7gH/vgDVKD/U91nxwf58DTI4krSFGmu+kXDtLANhrDBtFz5AD9JdB8RGoaqLSYgXXVPK7WLGiIVyN1cbKsYaRuqwH/OQp4iC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrTDjLgS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrTDjLgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274531F000E9;
	Tue, 21 Jul 2026 20:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666720;
	bh=wlLyXiFwS5thL2LCHrHJKnAXKEyGuIspLGAZ61A6qoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrTDjLgSBijYDEDahj6eQsu3PCDAdsblAz+KUvOWiZCw+sRZjZZa9LWSsc+9OwM/e
	 uNfNr3j3TvChiytQc6qJHaZMIR80rcJ9HTcc+cXuHGbQ5YXyKXX9KQaigDNGIOT0xb
	 G4uPCe21ZYWK84wMeyj/dSMFQiw+JDmAxh0Pch6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0791/1266] smb/client: preserve errors from smb2_set_sparse()
Date: Tue, 21 Jul 2026 17:20:28 +0200
Message-ID: <20260721152459.561209495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 44b3796318d42a..084804bab5cfc7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1967,8 +1967,9 @@ smb2_sync_write(const unsigned int xid, struct cifs_fid *pfid,
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
@@ -1977,31 +1978,31 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 
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
@@ -2009,7 +2010,7 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 	else
 		cifsi->cifsAttrs &= (~FILE_ATTRIBUTE_SPARSE_FILE);
 
-	return true;
+	return 0;
 }
 
 static int
@@ -3322,10 +3323,9 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
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



