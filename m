Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADDA14F100;
	Tue, 18 Jun 2024 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714982; cv=none; b=rNMrxrYb7NewnZWiGX7wCYfSN5zqJZ0jZUXBTspEoASz59r7pujYRx4+LWe/VdleVkwygsTswUrvojI6u2pbSyu4UOLZY2NxIEkrVSZpV3AQ/R+TABrHzR8wgeOCCpJZhn5kn2+0BtT6mnU9lUrXAodiTnm5hoR0npLo6TNofnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714982; c=relaxed/simple;
	bh=qlS6BCXRHaiXMjbCpNAtoBYePcfxIpipW3lkX1GlUqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftO8qZ8tAryHWqN0E1HeBTj/QVDaWYoMId1TqhrBWWC5imGNbipOk7MQQFAmJcpsYC4ipGaQ/qkLBe0JOKGVNhicqPZOACXeI5zL/DqwRs4ImoS1/f5t94orvJvmlCx6ecyi5tDM4euPIC+TXPyQlaxvouJGzpoic2u0xEps2V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Huc+ZYf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Huc+ZYf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9241C3277B;
	Tue, 18 Jun 2024 12:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714982;
	bh=qlS6BCXRHaiXMjbCpNAtoBYePcfxIpipW3lkX1GlUqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Huc+ZYf5wNlPllLZkTTvCqOYVznr6Ww19AQsALOGuqKScm7Memb8GbcfbuMfTtF/H
	 0reoTGNgnhh9fjaUfiwhDlOOIJ/oUftxOVHIcuzC5IkruEXN306Ydmv+xQ3VzCEE6K
	 hqFnQpyw3tNHt90ZggXlLd2Sl6+Uj9gP42zE3QaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/770] NFSD: Update the NFSv2 WRITE argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:08 +0200
Message-ID: <20240618123413.259861253@linuxfoundation.org>
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

[ Upstream commit a51b5b737a0be93fae6ea2a18df03ab2359a3f4b ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 52 +++++++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 1eacaa2c13a95..11d27b219cff2 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -266,46 +266,36 @@ nfssvc_decode_readargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_writeargs *args = rqstp->rq_argp;
-	unsigned int len, hdr, dlen;
 	struct kvec *head = rqstp->rq_arg.head;
+	struct kvec *tail = rqstp->rq_arg.tail;
+	u32 beginoffset, totalcount;
+	size_t remaining;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
+	if (!svcxdr_decode_fhandle(xdr, &args->fh))
 		return 0;
-
-	p++;				/* beginoffset */
-	args->offset = ntohl(*p++);	/* offset */
-	p++;				/* totalcount */
-	len = args->len = ntohl(*p++);
-	/*
-	 * The protocol specifies a maximum of 8192 bytes.
-	 */
-	if (len > NFSSVC_MAXBLKSIZE_V2)
+	/* beginoffset is ignored */
+	if (xdr_stream_decode_u32(xdr, &beginoffset) < 0)
 		return 0;
-
-	/*
-	 * Check to make sure that we got the right number of
-	 * bytes.
-	 */
-	hdr = (void*)p - head->iov_base;
-	if (hdr > head->iov_len)
+	if (xdr_stream_decode_u32(xdr, &args->offset) < 0)
+		return 0;
+	/* totalcount is ignored */
+	if (xdr_stream_decode_u32(xdr, &totalcount) < 0)
 		return 0;
-	dlen = head->iov_len + rqstp->rq_arg.page_len - hdr;
 
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
+		return 0;
+	if (args->len > NFSSVC_MAXBLKSIZE_V2)
+		return 0;
+	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
+	remaining -= xdr_stream_pos(xdr);
+	if (remaining < xdr_align_size(args->len))
 		return 0;
+	args->first.iov_base = xdr->p;
+	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
 
-	args->first.iov_base = (void *)p;
-	args->first.iov_len = head->iov_len - hdr;
 	return 1;
 }
 
-- 
2.43.0



