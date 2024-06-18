Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531F616A946;
	Tue, 18 Jun 2024 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715224; cv=none; b=NiSm17mJWywx8AryQzTD77eO/wlPyCyHxWIKIx2yN48LtH14oxnXzG688M5GSZIG6iVi7d/6DFrvqYv/huONzzrFsUyFC0XbTphc5WZ6EkhLsO5TIVZ3Ae08elT3o20D2Tj6fOnbImdG3mURilbbZHzFGVarZ71LmfHQ1IqzKuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715224; c=relaxed/simple;
	bh=AgK36lRhMW4AXZ8x6qkYUDRtWtSN+cYuY+Tb2KW2N4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2cLu78DwKFH5kUJRjUrEJSodAZw2QbJc7D7HMaVG61Bx8JyHq5i1tzDp3/H0fvKPiZ75ZF+7G0wQ2YCrbBSa6y18h00I5c1O8ZH8ie57benxbCHxpQEnYUG+ayNeKpFmWc8iIWrEOoOIYOQH51mXIPuyZ1gxc5AzujOW4vrSDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLIw7Luh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLIw7Luh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C39C3277B;
	Tue, 18 Jun 2024 12:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715224;
	bh=AgK36lRhMW4AXZ8x6qkYUDRtWtSN+cYuY+Tb2KW2N4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLIw7LuhqezpX/8bnlTPc9qv/7BfX+hVbPJKrYOrorh3k6XVFKUyBxFqkiwoNnAuN
	 OqOJ5Mx4aTPVWrj3FeZf+Q4jZdCbbBDDbI84ns2Y43aGyQAVJ9pjJ5WTwQJijvy6IE
	 lmfrdh7O3FZdmxFEDFZYPZVcaMgGCxoadK0ZoC/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/770] NFSD: Update the NFSv3 FSINFO3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:02 +0200
Message-ID: <20240618123415.343514512@linuxfoundation.org>
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

[ Upstream commit 0a139d1b7f327010acc36e8162936d3108c7addb ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 62 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index e4a569e7216d5..514f53ad73020 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -24,6 +24,15 @@ static const struct svc_fh nfs3svc_null_fh = {
 	.fh_no_wcc	= true,
 };
 
+/*
+ * time_delta. {1, 0} means the server is accurate only
+ * to the nearest second.
+ */
+static const struct timespec64 nfs3svc_time_delta = {
+	.tv_sec		= 1,
+	.tv_nsec	= 0,
+};
+
 /*
  * Mapping of S_IF* types to NFS file types
  */
@@ -1445,30 +1454,51 @@ nfs3svc_encode_fsstatres(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+static bool
+svcxdr_encode_fsinfo3resok(struct xdr_stream *xdr,
+			   const struct nfsd3_fsinfores *resp)
+{
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT * 12);
+	if (!p)
+		return false;
+	*p++ = cpu_to_be32(resp->f_rtmax);
+	*p++ = cpu_to_be32(resp->f_rtpref);
+	*p++ = cpu_to_be32(resp->f_rtmult);
+	*p++ = cpu_to_be32(resp->f_wtmax);
+	*p++ = cpu_to_be32(resp->f_wtpref);
+	*p++ = cpu_to_be32(resp->f_wtmult);
+	*p++ = cpu_to_be32(resp->f_dtpref);
+	p = xdr_encode_hyper(p, resp->f_maxfilesize);
+	p = encode_nfstime3(p, &nfs3svc_time_delta);
+	*p = cpu_to_be32(resp->f_properties);
+
+	return true;
+}
+
 /* FSINFO */
 int
 nfs3svc_encode_fsinfores(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_fsinfores *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	*p++ = xdr_zero;	/* no post_op_attr */
-
-	if (resp->status == 0) {
-		*p++ = htonl(resp->f_rtmax);
-		*p++ = htonl(resp->f_rtpref);
-		*p++ = htonl(resp->f_rtmult);
-		*p++ = htonl(resp->f_wtmax);
-		*p++ = htonl(resp->f_wtpref);
-		*p++ = htonl(resp->f_wtmult);
-		*p++ = htonl(resp->f_dtpref);
-		p = xdr_encode_hyper(p, resp->f_maxfilesize);
-		*p++ = xdr_one;
-		*p++ = xdr_zero;
-		*p++ = htonl(resp->f_properties);
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &nfs3svc_null_fh))
+			return 0;
+		if (!svcxdr_encode_fsinfo3resok(xdr, resp))
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &nfs3svc_null_fh))
+			return 0;
 	}
 
-	return xdr_ressize_check(rqstp, p);
+	return 1;
 }
 
 /* PATHCONF */
-- 
2.43.0



