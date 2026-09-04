Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5213B2FE4;
	Fri,  4 Sep 2026 05:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498650; cv=none; b=aHsrHzpLCee0/XQ8mrGS71/MPQDSu+m2DJ2P8/eonLWJM1Bc32Ptv+P6LpMwtLbdqBclyOBnSmvmXluo64wTuaxfkV9wg9YZxb6chmHSh7uCRlF4eQ5cGMomxs2dqLyw1TeRgffhPwJirCqmD8iGJKMfVJUblPzVDH5+4W6wLu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498650; c=relaxed/simple;
	bh=NDOZe9eyk2VEBHSxCB4JjT4H+N6einbNgxGWrxzrrfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opXn9xYe3LZiDeQ2PD9U7r6i7bB62AtQTm10fRcfMF2W+czKo/qOQ+5j27d9cNb8x5nIKhNMwqdbmsD9Ag+OuJMEkE7jSnsbc5BCpO+Euf5HfTAez4Q6NuLjWyWg/+TzuUmJmT7dP91iqiE5/Defl+/C8ghStcN1vX2HAQcQrHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMFPe0fQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMFPe0fQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B911F00A3D;
	Fri,  4 Sep 2026 05:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498649;
	bh=RcqJ5J4tl9CUwsxluSbyLR5pBzlU6oZo8J9Vz7jXaZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMFPe0fQoc/ILK1yIiKQ0wrU8KIdjHAwk7N0yD8wjciAv2/BPU4kPMWYDa89pbRtt
	 aDsCQ1/41joAOXEwScF4K9SB/7zemEK9+yjoXtx2utQqJDGZPVwHRv8/aKueD6Cln8
	 Y6nWZENJKdBaTHMsG3SXfGyhAWpPHvyutWhof7FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 139/713] NFSD: Encode only the status in NFS-ACL v2 GETACL error replies
Date: Fri,  4 Sep 2026 06:51:47 +0200
Message-ID: <20260904045806.945603011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


