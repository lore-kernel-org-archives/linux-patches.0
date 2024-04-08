Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C647442A;
	Mon,  8 Apr 2024 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584328; cv=none; b=o6HF0aQ3rzDyWLA6E6MHOf2vrUNQGjwSpi/udxMX5INpLNY86XM8+yDC6eCmR8qEQKCy/xmA6Gdt8SO+48i/2dqlnixppi45bRWf1A7/KtGJ/OhTw3wp8IZf3c20yRPsulc4Ya6hutgoSp5IuOgOocrh27/wWbpTCtHzHgjqaMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584328; c=relaxed/simple;
	bh=YgULHvBrwj8BUGFWFtSwbchX2USkIgVoG0JS3tOSFCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nD6MFeUK6E95v//UyASX1QuHQ6EcpEU09E9tOBJQWwbWpJRSBwwpG7zRP1vh093zvpepcAW29m8wRvtPoAmOIjgZMjpkMY96NNUOmz5+iEZ3eEW3Hv6yvHwgGyZHQlO9kzPBf5b7oGKwriGVYnF1PVukDEqwlD4m9qTvOSqQv0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itPa7Hko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itPa7Hko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA92C433C7;
	Mon,  8 Apr 2024 13:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584327;
	bh=YgULHvBrwj8BUGFWFtSwbchX2USkIgVoG0JS3tOSFCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itPa7HkoDEgqg1X4GecCeQHwVQJhIjQX3IcG0OI0Z1WOcz86bmAGv3od2WoOlatI8
	 ST9KOz11bZT9sZhuYs6oF3rUH/g5YXlBK9Dt8JINzYTReFVBgB/n7T/rFGu/ZrAyB2
	 IgY2tcubWwNqP+itDmo4WjJyz9pPnYkH7OMijnD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 383/690] NFSD: Add an nfsd4_read::rd_eof field
Date: Mon,  8 Apr 2024 14:54:09 +0200
Message-ID: <20240408125413.424318205@linuxfoundation.org>
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

[ Upstream commit 24c7fb85498eda1d4c6b42cc4886328429814990 ]

Refactor: Make the EOF result available in the entire NFSv4 READ
path.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 11 +++++------
 fs/nfsd/xdr4.h    |  5 +++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index afc8a51cf60f1..b31103221fee9 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3887,7 +3887,6 @@ static __be32 nfsd4_encode_splice_read(
 	struct xdr_stream *xdr = resp->xdr;
 	struct xdr_buf *buf = xdr->buf;
 	int status, space_left;
-	u32 eof;
 	__be32 nfserr;
 	__be32 *p = xdr->p - 2;
 
@@ -3896,7 +3895,8 @@ static __be32 nfsd4_encode_splice_read(
 		return nfserr_resource;
 
 	nfserr = nfsd_splice_read(read->rd_rqstp, read->rd_fhp,
-				  file, read->rd_offset, &maxcount, &eof);
+				  file, read->rd_offset, &maxcount,
+				  &read->rd_eof);
 	read->rd_length = maxcount;
 	if (nfserr)
 		goto out_err;
@@ -3907,7 +3907,7 @@ static __be32 nfsd4_encode_splice_read(
 		goto out_err;
 	}
 
-	*(p++) = htonl(eof);
+	*(p++) = htonl(read->rd_eof);
 	*(p++) = htonl(maxcount);
 
 	buf->page_len = maxcount;
@@ -3951,7 +3951,6 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 				 struct file *file, unsigned long maxcount)
 {
 	struct xdr_stream *xdr = resp->xdr;
-	u32 eof;
 	int starting_len = xdr->buf->len - 8;
 	__be32 nfserr;
 	__be32 tmp;
@@ -3963,7 +3962,7 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 
 	nfserr = nfsd_readv(resp->rqstp, read->rd_fhp, file, read->rd_offset,
 			    resp->rqstp->rq_vec, read->rd_vlen, &maxcount,
-			    &eof);
+			    &read->rd_eof);
 	read->rd_length = maxcount;
 	if (nfserr)
 		return nfserr;
@@ -3971,7 +3970,7 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 		return nfserr_io;
 	xdr_truncate_encode(xdr, starting_len + 8 + xdr_align_size(maxcount));
 
-	tmp = htonl(eof);
+	tmp = htonl(read->rd_eof);
 	write_bytes_to_xdr_buf(xdr->buf, starting_len    , &tmp, 4);
 	tmp = htonl(maxcount);
 	write_bytes_to_xdr_buf(xdr->buf, starting_len + 4, &tmp, 4);
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 77286e8c9ab02..0737f81c1004e 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -302,9 +302,10 @@ struct nfsd4_read {
 	u32			rd_length;          /* request */
 	int			rd_vlen;
 	struct nfsd_file	*rd_nf;
-	
+
 	struct svc_rqst		*rd_rqstp;          /* response */
-	struct svc_fh		*rd_fhp;             /* response */
+	struct svc_fh		*rd_fhp;            /* response */
+	u32			rd_eof;             /* response */
 };
 
 struct nfsd4_readdir {
-- 
2.43.0



