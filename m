Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1732542046;
	Mon,  8 Apr 2024 13:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584378; cv=none; b=XeCPornKSYy1ogmnQ4MdXpXhluEYzlt0XRj+1/iQt2vW+AdTvyQpPBcNT5cCsScVXBkmJARQ7e8qNepNyArjt8EHMP9BAXdhsmIpXgfsemfnDeWg8Ov52h/KZ3IVHeboWKHltZ57aJ9KFA+PlJnPu8P60nYo/n8thaGkrJA6WyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584378; c=relaxed/simple;
	bh=mChsyrO8TxFwyIhHujirOaRuMlKgZW3p6pGT4KpWCsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkI8sFPLrKQodEH1K621iEvTPQmtWnWBlQIwU9Pban/pPOlbQnDpPfPkZiCU5CJHYOgLFs2Qeu15nMiQzpBRqTdfgFWVCi1OdQGhYxstZe/ZiHipbDDda3RQeohxEqufKz0cJMTnX2RDncPEtE6b/O10ysY8MfvbE6cJGnVLlvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cK6Po9Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cK6Po9Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F417C433F1;
	Mon,  8 Apr 2024 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584378;
	bh=mChsyrO8TxFwyIhHujirOaRuMlKgZW3p6pGT4KpWCsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cK6Po9HvFBFRFnspSzsifnKV11UhcqPrCobDvS/mjHpTLwj4l8ob2/Psij2iT+ivW
	 tN3KuURKq+fW0Jwhqd0zsiCQV/UYr4XK0Y3SJM67gJBtx54nT2bn6PmmkRepcoq0uo
	 7VNcBy+ZnT5j2k4T5Namu07+jcSmsY4110PKd5ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 386/690] NFSD: Use xdr_pad_size()
Date: Mon,  8 Apr 2024 14:54:12 +0200
Message-ID: <20240408125413.520357922@linuxfoundation.org>
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

[ Upstream commit 5e64d85c7d0c59cfcd61d899720b8ccfe895d743 ]

Clean up: Use a helper instead of open-coding the calculation of
the XDR pad size.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 310321b9b94cd..88e8192f9a75d 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3948,9 +3948,8 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 {
 	struct xdr_stream *xdr = resp->xdr;
 	unsigned int starting_len = xdr->buf->len;
+	__be32 zero = xdr_zero;
 	__be32 nfserr;
-	__be32 tmp;
-	int pad;
 
 	read->rd_vlen = xdr_reserve_space_vec(xdr, resp->rqstp->rq_vec, maxcount);
 	if (read->rd_vlen < 0)
@@ -3966,11 +3965,9 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 		return nfserr_io;
 	xdr_truncate_encode(xdr, starting_len + xdr_align_size(maxcount));
 
-	tmp = xdr_zero;
-	pad = (maxcount&3) ? 4 - (maxcount&3) : 0;
-	write_bytes_to_xdr_buf(xdr->buf, starting_len + maxcount, &tmp, pad);
-	return 0;
-
+	write_bytes_to_xdr_buf(xdr->buf, starting_len + maxcount, &zero,
+			       xdr_pad_size(maxcount));
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



