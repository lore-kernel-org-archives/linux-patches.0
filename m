Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10B214C5B5;
	Tue, 18 Jun 2024 12:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714955; cv=none; b=tC1zJ5cAbuKMn9Y87D6N/SEI1ce4xGoU8hhNL/Tia9qbkd0VZXTwyWfOl74JXEOcyS41OGcYoIVN6q//enDGYcvDEITedGgLmj8aK5oKjD5fC7piIm0gJr1mjcl/Pc37Lovl12HBLM4JqYK3A+ACuJE+ZD9/gSdyO8aALFQ9rM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714955; c=relaxed/simple;
	bh=kd2NZ79KQXvNNg5ODSFdREOfk2OvMA751jgkBFnli4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kt9LCNpDVBkVZ6dNSKA+dKu1NA4cyg81UTrewgX/Zz2F9JfnPZ/YavtbJstZ0lP4q6baQB0zIP90arlK0MZKCtMY5lca1mbYv1xavMO9FZ9G5q2YYnGnMNZX7fIa1TPGOoJNK9Yfazx5ETRgkAPhvo7OIl/hHqR2HbhS+dyT7tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkXtQ9gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkXtQ9gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C05C3277B;
	Tue, 18 Jun 2024 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714955;
	bh=kd2NZ79KQXvNNg5ODSFdREOfk2OvMA751jgkBFnli4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkXtQ9glmkHu9fZLlzoINusbwBjK/G5RyAjSclju74uEMyLtGQ3BafINGVIqtY59N
	 hnU7fYyeqGxuMZmM5mklAJiAEWbWcSZraSBwH1dPmjtInIsopy9eZcets9qLhlQIHo
	 EkCuPIYBBR4Bf8acIHjRO5x+98yMhpf1Ba5Vpkog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/770] NFSD: Update READ3arg decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:29:51 +0200
Message-ID: <20240618123412.604103250@linuxfoundation.org>
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

[ Upstream commit be63bd2ac6bbf8c065a0ef6dfbea76934326c352 ]

The code that sets up rq_vec is refactored so that it is now
adjacent to the nfsd_read() call site where it is used.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 23 ++++++++++++++++++-----
 fs/nfsd/nfs3xdr.c  | 28 +++++++---------------------
 fs/nfsd/xdr3.h     |  1 -
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index a1d743bbb837d..2e477cd870913 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -144,25 +144,38 @@ nfsd3_proc_read(struct svc_rqst *rqstp)
 {
 	struct nfsd3_readargs *argp = rqstp->rq_argp;
 	struct nfsd3_readres *resp = rqstp->rq_resp;
-	u32	max_blocksize = svc_max_payload(rqstp);
-	unsigned long cnt = min(argp->count, max_blocksize);
+	u32 max_blocksize = svc_max_payload(rqstp);
+	unsigned int len;
+	int v;
+
+	argp->count = min_t(u32, argp->count, max_blocksize);
 
 	dprintk("nfsd: READ(3) %s %lu bytes at %Lu\n",
 				SVCFH_fmt(&argp->fh),
 				(unsigned long) argp->count,
 				(unsigned long long) argp->offset);
 
+	v = 0;
+	len = argp->count;
+	while (len > 0) {
+		struct page *page = *(rqstp->rq_next_page++);
+
+		rqstp->rq_vec[v].iov_base = page_address(page);
+		rqstp->rq_vec[v].iov_len = min_t(unsigned int, len, PAGE_SIZE);
+		len -= rqstp->rq_vec[v].iov_len;
+		v++;
+	}
+
 	/* Obtain buffer pointer for payload.
 	 * 1 (status) + 22 (post_op_attr) + 1 (count) + 1 (eof)
 	 * + 1 (xdr opaque byte count) = 26
 	 */
-	resp->count = cnt;
+	resp->count = argp->count;
 	svc_reserve_auth(rqstp, ((1 + NFS3_POST_OP_ATTR_WORDS + 3)<<2) + resp->count +4);
 
 	fh_copy(&resp->fh, &argp->fh);
 	resp->status = nfsd_read(rqstp, &resp->fh, argp->offset,
-				 rqstp->rq_vec, argp->vlen, &resp->count,
-				 &resp->eof);
+				 rqstp->rq_vec, v, &resp->count, &resp->eof);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index e07cebd80ef7f..2f32df15a7e87 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -389,31 +389,17 @@ nfs3svc_decode_accessargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_readargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_readargs *args = rqstp->rq_argp;
-	unsigned int len;
-	int v;
-	u32 max_blocksize = svc_max_payload(rqstp);
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
+	if (!svcxdr_decode_nfs_fh3(xdr, &args->fh))
+		return 0;
+	if (xdr_stream_decode_u64(xdr, &args->offset) < 0)
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->count) < 0)
 		return 0;
-	p = xdr_decode_hyper(p, &args->offset);
-
-	args->count = ntohl(*p++);
-	len = min(args->count, max_blocksize);
-
-	/* set up the kvec */
-	v=0;
-	while (len > 0) {
-		struct page *p = *(rqstp->rq_next_page++);
 
-		rqstp->rq_vec[v].iov_base = page_address(p);
-		rqstp->rq_vec[v].iov_len = min_t(unsigned int, len, PAGE_SIZE);
-		len -= rqstp->rq_vec[v].iov_len;
-		v++;
-	}
-	args->vlen = v;
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
 int
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index a4dce4baec7c3..7dfeeaa4e1dfc 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -32,7 +32,6 @@ struct nfsd3_readargs {
 	struct svc_fh		fh;
 	__u64			offset;
 	__u32			count;
-	int			vlen;
 };
 
 struct nfsd3_writeargs {
-- 
2.43.0



