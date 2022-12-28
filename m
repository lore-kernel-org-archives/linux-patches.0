Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A587B1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1CEC433D2;
	Wed, 28 Dec 2022 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240788;
	bh=KWWH51hY4M1mQbWgPvBmW7kMgGxrNEH8Iswhxd603Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtijqEKbxDm+SIx3xX+kBJd7S8FdpyVcRvhYvZC2fYj3jQxZSTqLtiJJ+1N8kaeKj
	 d8iTFAIW6C5XjmbQXgLQmFnVOISlsquVDq1rBu4znaG7hDa9Hn9xPIBLRs7ni/oXy5
	 wACTqWGtcdxUIMGbByzpBs612vlU9solsheCZofY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0152/1146] NFSD: Finish converting the NFSv3 GETACL result encoder
Date: Wed, 28 Dec 2022 15:28:11 +0100
Message-Id: <20221228144334.283104900@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 2fb9ee356455..a34a22e272ad 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -171,11 +171,7 @@ nfs3svc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
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
@@ -187,26 +183,12 @@ nfs3svc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
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
2.35.1



