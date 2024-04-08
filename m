Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00032524AF;
	Mon,  8 Apr 2024 13:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584381; cv=none; b=oD0FzytVg2wmHf7kuU+Y97Yp4wPM0yA1wmrgbWovG4E10wfy8WgsX/vs6mDQAbYYCeFYjtYlICa5msIFSZe+THQfG2p1qNjcYfnvm/B73itvCCLqXvgd3t5ZFXvBL1DWQ8/rjIhIpPJXJ6TkymRDl0XGmbZ7z2oiHiOB7if/RxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584381; c=relaxed/simple;
	bh=7Z3sLThTzMYdbOLQCchYe4wXWWlu59kNPg1601IwKKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WR1XCoz5b4EX4xtV2DZnCmr4ociEfMP4z6QTzMV+3mH0VGBOVGcXCoxjNHRLSO5xz3XFGc14GNiId30Sl+OiW5NDv1Wof+GJDfAM3Sx5Dxcj38cXDFPL3M/FH7TieOSpl/oTyCaeseSDLh+voW+pYI/yMatWmNAjMkpKkYJc4YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNF6QjPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNF6QjPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2E0C433F1;
	Mon,  8 Apr 2024 13:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584380;
	bh=7Z3sLThTzMYdbOLQCchYe4wXWWlu59kNPg1601IwKKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNF6QjPouphkXUPQk4iuplUCNpTxoEbr/jd8Ozoi8bnJ6/Nvd1SpKQXtpxgcDo50p
	 iQZ9i7OBwyQj8MlExX+LT6IbLUHiUf06lLTkLfkqXGT1yl7keKCNm4lbRS/XxZapZr
	 pGPQUlO9A+rfEaiZUBXRO5PaXx5SxgHGNtUe9YOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 387/690] NFSD: Clean up nfsd4_encode_readlink()
Date: Mon,  8 Apr 2024 14:54:13 +0200
Message-ID: <20240408125413.550489066@linuxfoundation.org>
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

[ Upstream commit 99b002a1fa00d90e66357315757e7277447ce973 ]

Similar changes to nfsd4_encode_readv(), all bundled into a single
patch.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 88e8192f9a75d..a5ab6ea475423 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4016,16 +4016,13 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 static __be32
 nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd4_readlink *readlink)
 {
-	int maxcount;
-	__be32 wire_count;
-	int zero = 0;
+	__be32 *p, *maxcount_p, zero = xdr_zero;
 	struct xdr_stream *xdr = resp->xdr;
 	int length_offset = xdr->buf->len;
-	int status;
-	__be32 *p;
+	int maxcount, status;
 
-	p = xdr_reserve_space(xdr, 4);
-	if (!p)
+	maxcount_p = xdr_reserve_space(xdr, XDR_UNIT);
+	if (!maxcount_p)
 		return nfserr_resource;
 	maxcount = PAGE_SIZE;
 
@@ -4050,14 +4047,11 @@ nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd
 		nfserr = nfserrno(status);
 		goto out_err;
 	}
-
-	wire_count = htonl(maxcount);
-	write_bytes_to_xdr_buf(xdr->buf, length_offset, &wire_count, 4);
-	xdr_truncate_encode(xdr, length_offset + 4 + ALIGN(maxcount, 4));
-	if (maxcount & 3)
-		write_bytes_to_xdr_buf(xdr->buf, length_offset + 4 + maxcount,
-						&zero, 4 - (maxcount&3));
-	return 0;
+	*maxcount_p = cpu_to_be32(maxcount);
+	xdr_truncate_encode(xdr, length_offset + 4 + xdr_align_size(maxcount));
+	write_bytes_to_xdr_buf(xdr->buf, length_offset + 4 + maxcount, &zero,
+			       xdr_pad_size(maxcount));
+	return nfs_ok;
 
 out_err:
 	xdr_truncate_encode(xdr, length_offset);
-- 
2.43.0



