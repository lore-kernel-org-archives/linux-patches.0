Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CB11AB917;
	Tue, 18 Jun 2024 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716608; cv=none; b=CAp6RQRMEtolgAYvxlan0eD1cBC0K1eMxZQOrMKlSuWYy+cfb95cVlw9gUIbaBj7VluE9uZe2pNxLn+ZNDmcYy1YwhB+uoWqfMAUN5k6Gx50QV0wChtQ3vD4zR9ZgFiMyKOMsO/lADnlhigaVEpEuZsOtz6ioWoCbymm0/lSBA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716608; c=relaxed/simple;
	bh=xrErU2XmYxjJaLQu1qoXiPbXvQXzaHkxmQXElIVU4kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEisVbJRrnmhtlYi/rc4k2wZ36cCV8smzpU3ugAjbRdKga0yvkR1qaXEMwq8dE4oAvXfQIWxl7gqZYEU5JE3pV+8ZucTOIe3qHvbx3tXB1XWfqQAOqXhIyngQsRVcOQebRez3O+/hHaB+6350l8zejX/IzVx6653pFTWiKnCCF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcU2+2y+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcU2+2y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888D3C32786;
	Tue, 18 Jun 2024 13:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716607;
	bh=xrErU2XmYxjJaLQu1qoXiPbXvQXzaHkxmQXElIVU4kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcU2+2y+5/fp4ToSMLIiXW/qPELPOWNeLCQnee6UUgYbmJGU7VCopNWzZ7UIGghxn
	 USRrBbx2ezWgCG51QrvefkrBHf1Jt6A1TglYhRoMSp61s2fDa3Qvl4DCtf8WFh9FSi
	 gAR9KkIhg3VwAJXp2kiKanhaAP+7Wy8TcDIe6//w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 685/770] NFSD: Finish converting the NFSv3 GETACL result encoder
Date: Tue, 18 Jun 2024 14:38:58 +0200
Message-ID: <20240618123433.720686645@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 841fd0a3cb490eae5dfd262eccb8c8b11d57f8b8 ]

For some reason, the NFSv2 GETACL result encoder was fully converted
to use the new nfs_stream_encode_acl(), but the NFSv3 equivalent was
not similarly converted.

Fixes: 20798dfe249a ("NFSD: Update the NFSv3 GETACL result encoder to use struct xdr_stream")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3acl.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index 2c451fcd5a3cc..161f831b3a1b7 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -169,11 +169,7 @@ nfs3svc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 {
 	struct nfsd3_getaclres *resp = rqstp->rq_resp;
 	struct dentry *dentry = resp->fh.fh_dentry;
-	struct kvec *head = rqstp->rq_res.head;
 	struct inode *inode;
-	unsigned int base;
-	int n;
-	int w;
 
 	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
 		return false;
@@ -185,26 +181,12 @@ nfs3svc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 		if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
 			return false;
 
-		base = (char *)xdr->p - (char *)head->iov_base;
-
-		rqstp->rq_res.page_len = w = nfsacl_size(
-			(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
-			(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
-		while (w > 0) {
-			if (!*(rqstp->rq_next_page++))
-				return false;
-			w -= PAGE_SIZE;
-		}
-
-		n = nfsacl_encode(&rqstp->rq_res, base, inode,
-				  resp->acl_access,
-				  resp->mask & NFS_ACL, 0);
-		if (n > 0)
-			n = nfsacl_encode(&rqstp->rq_res, base + n, inode,
-					  resp->acl_default,
-					  resp->mask & NFS_DFACL,
-					  NFS_ACL_DEFAULT);
-		if (n <= 0)
+		if (!nfs_stream_encode_acl(xdr, inode, resp->acl_access,
+					   resp->mask & NFS_ACL, 0))
+			return false;
+		if (!nfs_stream_encode_acl(xdr, inode, resp->acl_default,
+					   resp->mask & NFS_DFACL,
+					   NFS_ACL_DEFAULT))
 			return false;
 		break;
 	default:
-- 
2.43.0



