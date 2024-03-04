Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC011EB5A;
	Mon,  4 Mar 2024 21:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588950; cv=none; b=L+0no8uRnfu0u/sCcWbYtTeFfw8jKCL1nneS58fwkH00FFVF2X3M4JIBcv5qroYqM8lCAHLuQEQyRzp1f3ATP8ORF5BJVlmzo/qMmEZ9Zj9pjozTqt1ACFPudYAfc2diYNSB7LLKRace93V1IjMPlJkR0Tt4o5m+z1UJoHMo9Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588950; c=relaxed/simple;
	bh=N3dd2rM/cKvPOQZauELnggUie8oj4i3LhKDZmXgD49k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEO0hJ6qG1xOcziL39cqS+4D7aGF00VZ5rYjRm1GANcENMYG3ZUCtIJQoDYT+4xzew1TvbymhmYTeD8ytYLxt2rmwUw8Nr1Nm0ifqzUYjs+1Xef47Ez/FBWtFv/uuPz4lZ+tIrGuFL1HB0o4QBrVvUNtAXT7uAuMwtTznQrXzLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLwfgj2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLwfgj2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95522C433F1;
	Mon,  4 Mar 2024 21:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588949;
	bh=N3dd2rM/cKvPOQZauELnggUie8oj4i3LhKDZmXgD49k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLwfgj2cmdOlvuC9Gq3dCVF0OExJkseiEW/4FTFUNiptFgeFJZkZB27ZXTOaF6Wkh
	 3O4ccbpyr7RoutX69PQhbdtn7N4rqq6OlEmH7WykNDM6bEPoQkz75cMwOcuQEOKWUa
	 4DDFWUgGU3ApdA3218AIA7/9C12U5Y35zaogecYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 143/215] NFSD: Simplify READ_PLUS
Date: Mon,  4 Mar 2024 21:23:26 +0000
Message-ID: <20240304211601.589301464@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit eeadcb75794516839078c28b3730132aeb700ce6 ]

Chuck had suggested reverting READ_PLUS so it returns a single DATA
segment covering the requested read range. This prepares the server for
a future "sparse read" function so support can easily be added without
needing to rip out the old READ_PLUS code at the same time.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |  139 ++++++++++++------------------------------------------
 1 file changed, 32 insertions(+), 107 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4777,79 +4777,37 @@ nfsd4_encode_offload_status(struct nfsd4
 
 static __be32
 nfsd4_encode_read_plus_data(struct nfsd4_compoundres *resp,
-			    struct nfsd4_read *read,
-			    unsigned long *maxcount, u32 *eof,
-			    loff_t *pos)
+			    struct nfsd4_read *read)
 {
-	struct xdr_stream *xdr = resp->xdr;
+	bool splice_ok = test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags);
 	struct file *file = read->rd_nf->nf_file;
-	int starting_len = xdr->buf->len;
-	loff_t hole_pos;
-	__be32 nfserr;
-	__be32 *p, tmp;
-	__be64 tmp64;
-
-	hole_pos = pos ? *pos : vfs_llseek(file, read->rd_offset, SEEK_HOLE);
-	if (hole_pos > read->rd_offset)
-		*maxcount = min_t(unsigned long, *maxcount, hole_pos - read->rd_offset);
-	*maxcount = min_t(unsigned long, *maxcount, (xdr->buf->buflen - xdr->buf->len));
+	struct xdr_stream *xdr = resp->xdr;
+	unsigned long maxcount;
+	__be32 nfserr, *p;
 
 	/* Content type, offset, byte count */
 	p = xdr_reserve_space(xdr, 4 + 8 + 4);
 	if (!p)
-		return nfserr_resource;
+		return nfserr_io;
+	if (resp->xdr->buf->page_len && splice_ok) {
+		WARN_ON_ONCE(splice_ok);
+		return nfserr_serverfault;
+	}
 
-	read->rd_vlen = xdr_reserve_space_vec(xdr, resp->rqstp->rq_vec, *maxcount);
-	if (read->rd_vlen < 0)
-		return nfserr_resource;
+	maxcount = min_t(unsigned long, read->rd_length,
+			 (xdr->buf->buflen - xdr->buf->len));
 
-	nfserr = nfsd_readv(resp->rqstp, read->rd_fhp, file, read->rd_offset,
-			    resp->rqstp->rq_vec, read->rd_vlen, maxcount, eof);
+	if (file->f_op->splice_read && splice_ok)
+		nfserr = nfsd4_encode_splice_read(resp, read, file, maxcount);
+	else
+		nfserr = nfsd4_encode_readv(resp, read, file, maxcount);
 	if (nfserr)
 		return nfserr;
-	xdr_truncate_encode(xdr, starting_len + 16 + xdr_align_size(*maxcount));
-
-	tmp = htonl(NFS4_CONTENT_DATA);
-	write_bytes_to_xdr_buf(xdr->buf, starting_len,      &tmp,   4);
-	tmp64 = cpu_to_be64(read->rd_offset);
-	write_bytes_to_xdr_buf(xdr->buf, starting_len + 4,  &tmp64, 8);
-	tmp = htonl(*maxcount);
-	write_bytes_to_xdr_buf(xdr->buf, starting_len + 12, &tmp,   4);
-
-	tmp = xdr_zero;
-	write_bytes_to_xdr_buf(xdr->buf, starting_len + 16 + *maxcount, &tmp,
-			       xdr_pad_size(*maxcount));
-	return nfs_ok;
-}
-
-static __be32
-nfsd4_encode_read_plus_hole(struct nfsd4_compoundres *resp,
-			    struct nfsd4_read *read,
-			    unsigned long *maxcount, u32 *eof)
-{
-	struct file *file = read->rd_nf->nf_file;
-	loff_t data_pos = vfs_llseek(file, read->rd_offset, SEEK_DATA);
-	loff_t f_size = i_size_read(file_inode(file));
-	unsigned long count;
-	__be32 *p;
-
-	if (data_pos == -ENXIO)
-		data_pos = f_size;
-	else if (data_pos <= read->rd_offset || (data_pos < f_size && data_pos % PAGE_SIZE))
-		return nfsd4_encode_read_plus_data(resp, read, maxcount, eof, &f_size);
-	count = data_pos - read->rd_offset;
 
-	/* Content type, offset, byte count */
-	p = xdr_reserve_space(resp->xdr, 4 + 8 + 8);
-	if (!p)
-		return nfserr_resource;
-
-	*p++ = htonl(NFS4_CONTENT_HOLE);
+	*p++ = cpu_to_be32(NFS4_CONTENT_DATA);
 	p = xdr_encode_hyper(p, read->rd_offset);
-	p = xdr_encode_hyper(p, count);
+	*p = cpu_to_be32(read->rd_length);
 
-	*eof = (read->rd_offset + count) >= f_size;
-	*maxcount = min_t(unsigned long, count, *maxcount);
 	return nfs_ok;
 }
 
@@ -4857,69 +4815,36 @@ static __be32
 nfsd4_encode_read_plus(struct nfsd4_compoundres *resp, __be32 nfserr,
 		       struct nfsd4_read *read)
 {
-	unsigned long maxcount, count;
+	struct file *file = read->rd_nf->nf_file;
 	struct xdr_stream *xdr = resp->xdr;
-	struct file *file;
 	int starting_len = xdr->buf->len;
-	int last_segment = xdr->buf->len;
-	int segments = 0;
-	__be32 *p, tmp;
-	bool is_data;
-	loff_t pos;
-	u32 eof;
+	u32 segments = 0;
+	__be32 *p;
 
 	if (nfserr)
 		return nfserr;
-	file = read->rd_nf->nf_file;
 
 	/* eof flag, segment count */
 	p = xdr_reserve_space(xdr, 4 + 4);
 	if (!p)
-		return nfserr_resource;
+		return nfserr_io;
 	xdr_commit_encode(xdr);
 
-	maxcount = min_t(unsigned long, read->rd_length,
-			 (xdr->buf->buflen - xdr->buf->len));
-	count    = maxcount;
-
-	eof = read->rd_offset >= i_size_read(file_inode(file));
-	if (eof)
+	read->rd_eof = read->rd_offset >= i_size_read(file_inode(file));
+	if (read->rd_eof)
 		goto out;
 
-	pos = vfs_llseek(file, read->rd_offset, SEEK_HOLE);
-	is_data = pos > read->rd_offset;
-
-	while (count > 0 && !eof) {
-		maxcount = count;
-		if (is_data)
-			nfserr = nfsd4_encode_read_plus_data(resp, read, &maxcount, &eof,
-						segments == 0 ? &pos : NULL);
-		else
-			nfserr = nfsd4_encode_read_plus_hole(resp, read, &maxcount, &eof);
-		if (nfserr)
-			goto out;
-		count -= maxcount;
-		read->rd_offset += maxcount;
-		is_data = !is_data;
-		last_segment = xdr->buf->len;
-		segments++;
-	}
-
-out:
-	if (nfserr && segments == 0)
+	nfserr = nfsd4_encode_read_plus_data(resp, read);
+	if (nfserr) {
 		xdr_truncate_encode(xdr, starting_len);
-	else {
-		if (nfserr) {
-			xdr_truncate_encode(xdr, last_segment);
-			nfserr = nfs_ok;
-			eof = 0;
-		}
-		tmp = htonl(eof);
-		write_bytes_to_xdr_buf(xdr->buf, starting_len,     &tmp, 4);
-		tmp = htonl(segments);
-		write_bytes_to_xdr_buf(xdr->buf, starting_len + 4, &tmp, 4);
+		return nfserr;
 	}
 
+	segments++;
+
+out:
+	p = xdr_encode_bool(p, read->rd_eof);
+	*p = cpu_to_be32(segments);
 	return nfserr;
 }
 


