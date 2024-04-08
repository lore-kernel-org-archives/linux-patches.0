Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E6C42046;
	Mon,  8 Apr 2024 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584360; cv=none; b=QcAcj3Vtuzfn2p1RN7cSIWRIdXrHcx3AaW2wEOw9UGLkMao+Qed3PB6HsgOYgL2rboGZX+jTf+ZWVVagANVa+nURorFHOgcYW9TLiYJNAPUHKPKq0Krk3OYW9pdhKRNJIlUtSCqzaDfx/L+ZkR4YvMAGtgPMOAmwyuSglAmU5ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584360; c=relaxed/simple;
	bh=wCctlRfVpMFWvSCbvKtuGHO3z652yzRhIzv8uSEGtzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp1EgIrDZSt7v1OHiFRBjLbuY0tPQF9CMQ3J8u0CsgFtmOKv7DO4W4BtnHh7IBv3LAw001/DedgVGqSXGC7AfrifAuKWYY5RBiy7fPfrS9Pg/a77qoIIMM3Yqnw/JUdQ/UzfluKEV2OEH3CV3fKWU8ijK09h3ORvSeGoyMKjeas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EW7kyC6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EW7kyC6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0416C43390;
	Mon,  8 Apr 2024 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584360;
	bh=wCctlRfVpMFWvSCbvKtuGHO3z652yzRhIzv8uSEGtzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EW7kyC6t2uBLNO6Y3FvUCFYD5lz7Xd1hEtVGmiHYvKXZcijiBXBCM0pu2a2wvKg1U
	 PEG/+9Hy6OC8U4v4m0JQnuOaXN0uGANuGbg23wr91Pi3AEh32Yp4yn7HoiKsqAHw68
	 7JlyI5TDmX0R4l5JT+P5sSYMicFiBy7tjt1mNgOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 384/690] NFSD: Optimize nfsd4_encode_readv()
Date: Mon,  8 Apr 2024 14:54:10 +0200
Message-ID: <20240408125413.454663996@linuxfoundation.org>
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

[ Upstream commit 28d5bc468efe74b790e052f758ce083a5015c665 ]

write_bytes_to_xdr_buf() is pretty expensive to use for inserting
an XDR data item that is always 1 XDR_UNIT at an address that is
always XDR word-aligned.

Since both the readv and splice read paths encode EOF and maxcount
values, move both to a common code path.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b31103221fee9..b7a3c770d436b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3888,7 +3888,6 @@ static __be32 nfsd4_encode_splice_read(
 	struct xdr_buf *buf = xdr->buf;
 	int status, space_left;
 	__be32 nfserr;
-	__be32 *p = xdr->p - 2;
 
 	/* Make sure there will be room for padding if needed */
 	if (xdr->end - xdr->p < 1)
@@ -3907,9 +3906,6 @@ static __be32 nfsd4_encode_splice_read(
 		goto out_err;
 	}
 
-	*(p++) = htonl(read->rd_eof);
-	*(p++) = htonl(maxcount);
-
 	buf->page_len = maxcount;
 	buf->len += maxcount;
 	xdr->page_ptr += (buf->page_base + maxcount + PAGE_SIZE - 1)
@@ -3970,11 +3966,6 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 		return nfserr_io;
 	xdr_truncate_encode(xdr, starting_len + 8 + xdr_align_size(maxcount));
 
-	tmp = htonl(read->rd_eof);
-	write_bytes_to_xdr_buf(xdr->buf, starting_len    , &tmp, 4);
-	tmp = htonl(maxcount);
-	write_bytes_to_xdr_buf(xdr->buf, starting_len + 4, &tmp, 4);
-
 	tmp = xdr_zero;
 	pad = (maxcount&3) ? 4 - (maxcount&3) : 0;
 	write_bytes_to_xdr_buf(xdr->buf, starting_len + 8 + maxcount,
@@ -4016,11 +4007,14 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 		nfserr = nfsd4_encode_splice_read(resp, read, file, maxcount);
 	else
 		nfserr = nfsd4_encode_readv(resp, read, file, maxcount);
-
-	if (nfserr)
+	if (nfserr) {
 		xdr_truncate_encode(xdr, starting_len);
+		return nfserr;
+	}
 
-	return nfserr;
+	p = xdr_encode_bool(p, read->rd_eof);
+	*p = cpu_to_be32(read->rd_length);
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



