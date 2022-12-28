Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163771868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A20CC433F1;
	Wed, 28 Dec 2022 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240662;
	bh=fWJpkAd0AO7VPPeA4CRut39wbJSmhU5YwQ1sckF+ZA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/9PgneUUx9FXynpWCre0CA3devfQPKrfZEC9EtkUIWFOaFVyDkN/AsuZiO2NB62K
	 59yhdz1LT4TQoFIrFDwgtS2BlSeOwdTcj5TP1uCd809ZnZobvRz7Du3cXAv3U9MSFm
	 zxmWYCPe+WtdSYmus4S2dTUEhcXDiaQJpz0M35kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0151/1146] NFSD: Finish converting the NFSv2 GETACL result encoder
Date: Wed, 28 Dec 2022 15:28:10 +0100
Message-Id: <20221228144334.255950291@linuxfoundation.org>
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

[ Upstream commit ea5021e911d3479346a75ac9b7d9dcd751b0fb99 ]

The xdr_stream conversion inadvertently left some code that set the
page_len of the send buffer. The XDR stream encoders should handle
this automatically now.

This oversight adds garbage past the end of the Reply message.
Clients typically ignore the garbage, but NFSD does not need to send
it, as it leaks stale memory contents onto the wire.

Fixes: f8cba47344f7 ("NFSD: Update the NFSv2 GETACL result encoder to use struct xdr_stream")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 13e6e6897f6c..65d4511b7af0 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -246,7 +246,6 @@ nfsaclsvc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 	struct nfsd3_getaclres *resp = rqstp->rq_resp;
 	struct dentry *dentry = resp->fh.fh_dentry;
 	struct inode *inode;
-	int w;
 
 	if (!svcxdr_encode_stat(xdr, resp->status))
 		return false;
@@ -260,15 +259,6 @@ nfsaclsvc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 	if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
 		return false;
 
-	rqstp->rq_res.page_len = w = nfsacl_size(
-		(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
-		(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
-	while (w > 0) {
-		if (!*(rqstp->rq_next_page++))
-			return true;
-		w -= PAGE_SIZE;
-	}
-
 	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_access,
 				   resp->mask & NFS_ACL, 0))
 		return false;
-- 
2.35.1



