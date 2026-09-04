Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C5417BF8;
	Fri,  4 Sep 2026 06:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502046; cv=none; b=uZJYdG/EozbVhikr2gtcMegwrxW/m5XcCoisSNXUv+PxXG1PXdLihaGGrTis4fft5SIvnxaRsHTsTNyDIrh3y2vQS3EXclFqjVpgIZz6lwd1madlJ4fmhZAr+Cg1bVXhs6FzkBgI1JV9UI4f89+T0KCuRGkrrOo+8nh9pIJPFQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502046; c=relaxed/simple;
	bh=w7j4DxVucjol79ywPOYLGGFzxTk8bf2jbrYWMe7axoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTm2u0x0DredpyMlGQIy1iY7RykJ/5daATo7nA15hlv6UnaCzyAbd2fbtMCjXM7TiYMfF0eJk3AQ3ucalu3wcI4ceaS4DQm/G2EHViVrV5YGLpQyxIhBVxORaMII7xVSNr7LkIP1g9m3olKBBBq2LVfb+Ja28IuBQ3bq281LYKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCX0jSbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCX0jSbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13001F00A3D;
	Fri,  4 Sep 2026 06:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502045;
	bh=Rn9xsSxX4/Hdf+cRZi1moz7WtTNud3Xa5F9Qm/WTsxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCX0jSbZGh8BxpAiWM3ZWBr6c/UFq0k2900I3hS9KBKChvtGshh6x8TbUoSzrKdiX
	 2X6YHCMKZIr4iqUqReSpjIVudra1qORyhx2n/4ouTbgh/pWrcqecLTjD398UhQ1S8i
	 /koV8jMAqohRspN+NAAdQiVE+vOOXlZWdtre8ofw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 069/403] NFSD: Encode only the status in NFS-ACL v2 GETACL error replies
Date: Fri,  4 Sep 2026 06:57:52 +0200
Message-ID: <20260904045736.407814586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit ed4edddad19babf76b56882ad9600f5646b167a0 upstream.

The NFSv2 ACL GETACL reply is a union that carries file attributes
and ACL data only when the status is NFS_OK. All error cases are
void results. However, currently the NFSv2 ACL GETACL result encoder
decides whether to append the "OK" body by testing only whether the
file handle resolved to a positive dentry, not the actual reply
status.

A GETACL request that resolves its file handle but then fails for
another reason (an unsupported mask value, a getattr failure, or an
ACL retrieval error) therefore appends file attributes and ACL data
after the error status on the wire. Worse, when the mask is
rejected, fh_getattr() hasn't been called at all, so those
attributes are serialized from a zero-filled kstat and are junk.

The logic before the xdr_stream conversion used the reply status.
Revert to that approach (but keep the xdr_stream conversion in
place).

Fixes: f8cba47344f7 ("NFSD: Update the NFSv2 GETACL result encoder to use struct xdr_stream")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260712150911.48461-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs2acl.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -248,22 +248,21 @@ nfsaclsvc_encode_getaclres(struct svc_rq
 
 	if (!svcxdr_encode_stat(xdr, resp->status))
 		return false;
-
-	if (dentry == NULL || d_really_is_negative(dentry))
-		return true;
-	inode = d_inode(dentry);
-
-	if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
-		return false;
-	if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
-		return false;
-
-	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_access,
-				   resp->mask & NFS_ACL, 0))
-		return false;
-	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_default,
-				   resp->mask & NFS_DFACL, NFS_ACL_DEFAULT))
-		return false;
+	switch (resp->status) {
+	case nfs_ok:
+		inode = d_inode(dentry);
+		if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
+			return false;
+		if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
+			return false;
+		if (!nfs_stream_encode_acl(xdr, inode, resp->acl_access,
+					   resp->mask & NFS_ACL, 0))
+			return false;
+		if (!nfs_stream_encode_acl(xdr, inode, resp->acl_default,
+					   resp->mask & NFS_DFACL, NFS_ACL_DEFAULT))
+			return false;
+		break;
+	}
 
 	return true;
 }


