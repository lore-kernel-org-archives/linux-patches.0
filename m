Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE06309F08;
	Sat, 12 Sep 2026 15:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226739; cv=none; b=rnQrD8TCPLM+pvjVYml4ygGB2vMnDpWWUxWHAvlbXFRY0xgAyN86tCTppNLrABz8rYk+gpjKZY2CWhst8ovY5SkUGeCNybtZbInpgPUIQ+GR0sEZimfQNbHevNcaLyd0awVRUsYuaOzAADlNB33wC1Dj1+qDsxIY8verQlU1VqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226739; c=relaxed/simple;
	bh=65kakry55aPgJJBOlynhfOSa+fpKwji16kKevUKgrzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cotlTorhJq/Y+Os8OS8w3EcywH0uktyiO1+b52nnbURSavA/q4kzyX/CvPkjIFI00AIky87RqwUy0XiKVxSL+CQm1THvB85S6/srvJP5NAoXgn7594Um1M+kYPrhwATLZMnwv4pPvzf3Ky1YirxopPHFH/yUU6BgTZ+om+qYGto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y8hD9xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y8hD9xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3F11F000FF;
	Sat, 12 Sep 2026 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226737;
	bh=h61kvX1VvQ7QKjeofRvbVxMp83J2V/IKPru8Pkhpp7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Y8hD9xPYSeaG17NOrmC8w/UD3DJBZg9rY9csFRCNSH4Ox/wkQ3v6o/+0P9bDhFym
	 tbNkya3B4rFz3YryrfuOMNMXYh3x90bT9NbGet/a2i1jV+lKyRRmot9utaOoM9aYq9
	 qtwfNYeDkV97iSpjesLfpQBH+zKj85nhonwA3Rlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0038/1191] NFSD: Encode only the status in NFS-ACL v2 GETACL error replies
Date: Sat, 12 Sep 2026 08:46:06 +0200
Message-ID: <20260912065548.986910351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


