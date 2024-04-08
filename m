Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7776EB72;
	Mon,  8 Apr 2024 13:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584539; cv=none; b=feYyl1obAim+g9p1jxM7i1W7XvhtdmSe/3ifV/R6taIli9qOhswB4LHPiJASVWgH3Pj8F4iktG4JlPKTsyzevTClFY5wExb3UISPpTT021M6RsOTUVfzxjD1whwhvzOb3jC7Yjzi5xDWsrg0ZC1c+/f4qPv5HqNaMbcEHn2kQPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584539; c=relaxed/simple;
	bh=EPdeUnJ2a8e1BgDO9ErqsZFuF+RMdFx5Tc7uufLTl7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoL4zVTH7WVQCFo/f6nKmhWKeFAY1bwCaLUi2uWq/8e115q3XKU9zES2JPxq0LLaZbL72wvLYhJRNMe9hXBcQRHPlByvJVaqficMD/EYuB6wADfjq7r2G8v+g2iT0g5wVIVpwSi5js0guRwk6kfq4ktX8Zwgg3K6rg3cb/boyF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQfhgThQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQfhgThQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2CEC433F1;
	Mon,  8 Apr 2024 13:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584538;
	bh=EPdeUnJ2a8e1BgDO9ErqsZFuF+RMdFx5Tc7uufLTl7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQfhgThQUVpvB46wgOJdTtX7scYBx/H+46pSXC4x80O4ygndhrrR/UYtba9EBYmz5
	 /hgtHYOYWQ1rs648ZWrh6BXhfS+ChegGwR4jVV5PnuQvaTDuS3enqq4xURAAtSKsoR
	 jKkN/9GE9WM/mLs2NpqkNokmsu1bBgYL4CE22OBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 472/690] NFSD: Finish converting the NFSv3 GETACL result encoder
Date: Mon,  8 Apr 2024 14:55:38 +0200
Message-ID: <20240408125416.702131260@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 841fd0a3cb490eae5dfd262eccb8c8b11d57f8b8 ]

For some reason, the NFSv2 GETACL result encoder was fully converted
to use the new nfs_stream_encode_acl(), but the NFSv3 equivalent was
not similarly converted.

Fixes: 20798dfe249a ("NFSD: Update the NFSv3 GETACL result encoder to use struct xdr_stream")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs3acl.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index 2fb9ee3564558..a34a22e272ad5 100644
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
2.43.0



