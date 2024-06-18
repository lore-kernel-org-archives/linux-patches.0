Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B115414EC71;
	Tue, 18 Jun 2024 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714970; cv=none; b=KXhY6gwdHSgViR4heiUCOmaUkAqPMMYTuWTbljgIOeA4/JhGDngDQXiKRiUAjPez+9nH25gkx5w8se/rj9R6ZYaF0Onj1c+VmiUeHbMDvaX5o5l1RtphnDGTkoMCvz6O6/UGiTLJoL6vV/6UyQ0y/GutPOAqERsoNLTddTfWkqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714970; c=relaxed/simple;
	bh=LunDi6JcfhfrnlIDje8nfRJmQsJi9hGmhJYXq8iTaz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5KSCCizDI1Bwfu1o/6i5f1mJ7VpuJFJizzKaXTfxEXZVUzo48jG9YwMAl9ZLExRUqa0jJ+Fd4Mf8Z+gcoUHgfMCqPWni91VpBpr4polEN7IUBQ+afaA1WmxwPsVbOCu+PKBuNd/pL4+fRgkKipZcLEHwLpMtdzfa5bUT4V5RQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9wEq3Ta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9wEq3Ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F2BC3277B;
	Tue, 18 Jun 2024 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714970;
	bh=LunDi6JcfhfrnlIDje8nfRJmQsJi9hGmhJYXq8iTaz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9wEq3TapfyblNv/8lmrelDVHyDosmhnSN55OLPbNvxYvgYimQW3xPLslaeSCHLz6
	 iA2XYMlcyJ9JV9jnW4PSwGlNXo9TcXmRMaFRzfpW6CbFuqObWiZ7mHi4YDqGANc6qB
	 EmGwMpib93afyVjYklnx7gMBw3/Kw8sk171i80SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/770] NFSD: Update the SYMLINK3args decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:04 +0200
Message-ID: <20240618123413.102657974@linuxfoundation.org>
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

[ Upstream commit da39201637297460c13134c29286a00f3a1c92fe ]

Similar to the WRITE decoder, code that checks the sanity of the
payload size is re-wired to work with xdr_stream infrastructure.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index b4071cda1d652..eb17231ab1661 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -616,25 +616,28 @@ nfs3svc_decode_mkdirargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_symlinkargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_symlinkargs *args = rqstp->rq_argp;
-	char *base = (char *)p;
-	size_t dlen;
+	struct kvec *head = rqstp->rq_arg.head;
+	struct kvec *tail = rqstp->rq_arg.tail;
+	size_t remaining;
 
-	if (!(p = decode_fh(p, &args->ffh)) ||
-	    !(p = decode_filename(p, &args->fname, &args->flen)))
+	if (!svcxdr_decode_diropargs3(xdr, &args->ffh, &args->fname, &args->flen))
+		return 0;
+	if (!svcxdr_decode_sattr3(rqstp, xdr, &args->attrs))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->tlen) < 0)
 		return 0;
-	p = decode_sattr3(p, &args->attrs, nfsd_user_namespace(rqstp));
 
-	args->tlen = ntohl(*p++);
+	/* request sanity */
+	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
+	remaining -= xdr_stream_pos(xdr);
+	if (remaining < xdr_align_size(args->tlen))
+		return 0;
 
-	args->first.iov_base = p;
-	args->first.iov_len = rqstp->rq_arg.head[0].iov_len;
-	args->first.iov_len -= (char *)p - base;
+	args->first.iov_base = xdr->p;
+	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
 
-	dlen = args->first.iov_len + rqstp->rq_arg.page_len +
-	       rqstp->rq_arg.tail[0].iov_len;
-	if (dlen < XDR_QUADLEN(args->tlen) << 2)
-		return 0;
 	return 1;
 }
 
-- 
2.43.0



