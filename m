Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5525115F300;
	Tue, 18 Jun 2024 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714988; cv=none; b=otpGubcmjPKFxgu8wjnQ2zCd6mZVqLbLGGpFZf/1hUxEKrvny9Ic/QVSuQ/v8GT/1sThrmAVrAqrWA/zi177GRwC9lNQzvbd5x9tHpR6qG8CaLjQT8olN8ft+r/qCxF4Qx5Y2nKIi7CEaiGXbt2u11LOMGFLs5MV8UIK1+5i9eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714988; c=relaxed/simple;
	bh=tWd+YromDa4dP+j24D4vLLSVvJCAy9PqPLh+KRln8/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z16q0JP50zjaemxnIRW339cFwflEWdNXaBNbuLWo8v0qhIBzmUAouYWJnLqomh3Sj7yz11OsCBcFW48zB6FPxikNU+3m4lOsihDmZzYkgaf0xDvIrY5nydBhTfCUl4nb87nqplco0sHeNN6Dy18Hdjkudolg8khIQQNysTsGkE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqtdUgxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqtdUgxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE507C3277B;
	Tue, 18 Jun 2024 12:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714988;
	bh=tWd+YromDa4dP+j24D4vLLSVvJCAy9PqPLh+KRln8/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqtdUgxVJwX2r+jDpvYWV1j2IZBbfgFD3OhUez7RJknaSG+BLJa8KE0O3op4fUMvi
	 pT2S04iCBbd243Ds2lWWPO21GYMkoEWi/NVFhvFlECW7F+jEhFEiwldvZdXmZp2OOc
	 VFAeyrSGCBldMfUI1ua0LIrrlSZdnzCuaCDEwHf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/770] NFSD: Update WRITE3arg decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:29:52 +0200
Message-ID: <20240618123412.641727248@linuxfoundation.org>
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

[ Upstream commit c43b2f229a01969a7ccf94b033c5085e0ec2040c ]

As part of the update, open code that sanity-checks the size of the
data payload against the length of the RPC Call message has to be
re-implemented to use xdr_stream infrastructure.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 51 +++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 2f32df15a7e87..c06467e8ac829 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -405,52 +405,41 @@ nfs3svc_decode_readargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_writeargs *args = rqstp->rq_argp;
-	unsigned int len, hdr, dlen;
 	u32 max_blocksize = svc_max_payload(rqstp);
 	struct kvec *head = rqstp->rq_arg.head;
 	struct kvec *tail = rqstp->rq_arg.tail;
+	size_t remaining;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
+	if (!svcxdr_decode_nfs_fh3(xdr, &args->fh))
 		return 0;
-	p = xdr_decode_hyper(p, &args->offset);
-
-	args->count = ntohl(*p++);
-	args->stable = ntohl(*p++);
-	len = args->len = ntohl(*p++);
-	if ((void *)p > head->iov_base + head->iov_len)
+	if (xdr_stream_decode_u64(xdr, &args->offset) < 0)
 		return 0;
-	/*
-	 * The count must equal the amount of data passed.
-	 */
-	if (args->count != args->len)
+	if (xdr_stream_decode_u32(xdr, &args->count) < 0)
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->stable) < 0)
 		return 0;
 
-	/*
-	 * Check to make sure that we got the right number of
-	 * bytes.
-	 */
-	hdr = (void*)p - head->iov_base;
-	dlen = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len - hdr;
-	/*
-	 * Round the length of the data which was specified up to
-	 * the next multiple of XDR units and then compare that
-	 * against the length which was actually received.
-	 * Note that when RPCSEC/GSS (for example) is used, the
-	 * data buffer can be padded so dlen might be larger
-	 * than required.  It must never be smaller.
-	 */
-	if (dlen < XDR_QUADLEN(len)*4)
+	/* opaque data */
+	if (xdr_stream_decode_u32(xdr, &args->len) < 0)
 		return 0;
 
+	/* request sanity */
+	if (args->count != args->len)
+		return 0;
+	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
+	remaining -= xdr_stream_pos(xdr);
+	if (remaining < xdr_align_size(args->len))
+		return 0;
 	if (args->count > max_blocksize) {
 		args->count = max_blocksize;
-		len = args->len = max_blocksize;
+		args->len = max_blocksize;
 	}
 
-	args->first.iov_base = (void *)p;
-	args->first.iov_len = head->iov_len - hdr;
+	args->first.iov_base = xdr->p;
+	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
+
 	return 1;
 }
 
-- 
2.43.0



