Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51337F314;
	Sat, 12 Sep 2026 19:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240915; cv=none; b=JgAqt4g8x+wa6mPD4TGr6pXyuKVp3MJWwTWb+UA9I7Idf2nUrYlsAhagE/MHucoHWDv5kzmyMyGOhT7z6/s5t50tSCcUliIxIjuOZHpkKAkRZJ0GDzgoiVr/2n2r/3IhswHCUPtj35qXds2Ij3G8Urn6/FKGXQCHquxP9DDG7fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240915; c=relaxed/simple;
	bh=lMjnXyFdqF7fqghjSz2LCWpP5jMK7N7cNVvV1elWXSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8TASFBcRhyFIWcaQ3eZYYBXqire797318A1gm9jTk6M0Nl3U+q7jL3aK+9S28RbQD17q6u2R45+RJuo6ofrDtlDT695IcEeB3BWUfrZum9IBZJc7dt2RDnUo+2sfgZYO0YKsoY830Rfx4TnNYf0nqjikBvF52id0QCorxNthJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDis2SjD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDis2SjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4181F000FF;
	Sat, 12 Sep 2026 19:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240905;
	bh=tyoq0Qw0tB40JDDSjMQ7yGrb5J4rzIaJT1IyLNzKLG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDis2SjD7g8ArK8iN0PlnHoJuRhy9UXyfZaQ2wLamEhV2d/oZAthGMYZXvY12xm1s
	 eJ7C8YkEE/ygtpDVZDqkQvU+H4Rv/AN8D2uf8aJ4b4TQq2PoB6wDXe0s9Tx0MsE5j1
	 kZ1h5GDVkHUT/GJDxqO/eHiGv1y6JJc9ctylTJzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 028/798] NFSD: Encode only the status in NFS-ACL v2 GETACL error replies
Date: Sat, 12 Sep 2026 08:54:16 +0200
Message-ID: <20260912065517.605431171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -246,22 +246,21 @@ nfsaclsvc_encode_getaclres(struct svc_rq
 
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


