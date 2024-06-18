Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F735156C7C;
	Tue, 18 Jun 2024 13:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715689; cv=none; b=FHyb366B70BzEL2dyq35gpTRKv2NZupA7/YypcpgTw3yMx24iPKHEGUlzvhSx0EEU2r93TrT5Gsz/Sy6syPC5dNh0HSfNFiMXzVGIi+/Mr1XSycoXpZezcuB/lcRef0Yn6KXa5NjV6ssr3jKghBBisaTKXAPPrulHbxt8Pfu5QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715689; c=relaxed/simple;
	bh=1Y6KfMbGTgUwmHRs+QqTmX36JtuLI30tqx9xQk+bXXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtYI2So04WwwYY2HELoe9npuo0J+Ys02ohfBmU0Lj1+5Oqaq8e7oUed6wkIOfw9vpCDp+mvomc1kWUxfDOni4pRrIfrnzwyTB8QXrgdUg+Qk1NllU0SYXBS24mbh3BB+ouOzKkp8xEfPO9aNA3Zj5tjmoWP+v37hnuXhCQ0rupo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nv9lz41r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nv9lz41r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B776C3277B;
	Tue, 18 Jun 2024 13:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715689;
	bh=1Y6KfMbGTgUwmHRs+QqTmX36JtuLI30tqx9xQk+bXXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nv9lz41rsRMUrNYcPpLwp+mgWZufmPLxStkNndf0/x15BH3PSKgHU+reQsZBhNE6X
	 pU5Y23SfnmTEek5K9oL/fltG8Oj/cxN+mUn21B2K99n/akWxJ9r5P+oQtjh18d2rbU
	 oKrnQSJI69kaQTHccV2hppzDpvLh1kXn2C4QC29s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 394/770] NFSD: Have legacy NFSD WRITE decoders use xdr_stream_subsegment()
Date: Tue, 18 Jun 2024 14:34:07 +0200
Message-ID: <20240618123422.486612759@linuxfoundation.org>
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

[ Upstream commit dae9a6cab8009e526570e7477ce858dcdfeb256e ]

Refactor.

Now that the NFSv2 and NFSv3 XDR decoders have been converted to
use xdr_streams, the WRITE decoder functions can use
xdr_stream_subsegment() to extract the WRITE payload into its own
xdr_buf, just as the NFSv4 WRITE XDR decoder currently does.

That makes it possible to pass the first kvec, pages array + length,
page_base, and total payload length via a single function parameter.

The payload's page_base is not yet assigned or used, but will be in
subsequent patches.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c         |  3 +--
 fs/nfsd/nfs3xdr.c          | 12 ++----------
 fs/nfsd/nfs4proc.c         |  3 +--
 fs/nfsd/nfsproc.c          |  3 +--
 fs/nfsd/nfsxdr.c           |  9 +--------
 fs/nfsd/xdr.h              |  2 +-
 fs/nfsd/xdr3.h             |  2 +-
 include/linux/sunrpc/svc.h |  3 +--
 net/sunrpc/svc.c           | 11 ++++++-----
 9 files changed, 15 insertions(+), 33 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index be1ed33e424e0..5abb5c8e2cd21 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -206,8 +206,7 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 
 	fh_copy(&resp->fh, &argp->fh);
 	resp->committed = argp->stable;
-	nvecs = svc_fill_write_vector(rqstp, rqstp->rq_arg.pages,
-				      &argp->first, cnt);
+	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
 	if (!nvecs) {
 		resp->status = nfserr_io;
 		goto out;
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 3d37923afb06c..267e56f218af7 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -621,9 +621,6 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_writeargs *args = rqstp->rq_argp;
 	u32 max_blocksize = svc_max_payload(rqstp);
-	struct kvec *head = rqstp->rq_arg.head;
-	struct kvec *tail = rqstp->rq_arg.tail;
-	size_t remaining;
 
 	if (!svcxdr_decode_nfs_fh3(xdr, &args->fh))
 		return 0;
@@ -641,17 +638,12 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 	/* request sanity */
 	if (args->count != args->len)
 		return 0;
-	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
-	remaining -= xdr_stream_pos(xdr);
-	if (remaining < xdr_align_size(args->len))
-		return 0;
 	if (args->count > max_blocksize) {
 		args->count = max_blocksize;
 		args->len = max_blocksize;
 	}
-
-	args->first.iov_base = xdr->p;
-	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
+	if (!xdr_stream_subsegment(xdr, &args->payload, args->count))
+		return 0;
 
 	return 1;
 }
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index ebb6d8471e8d7..d2ee1ba7ddc65 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1034,8 +1034,7 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	write->wr_how_written = write->wr_stable_how;
 
-	nvecs = svc_fill_write_vector(rqstp, write->wr_payload.pages,
-				      write->wr_payload.head, write->wr_buflen);
+	nvecs = svc_fill_write_vector(rqstp, &write->wr_payload);
 	WARN_ON_ONCE(nvecs > ARRAY_SIZE(rqstp->rq_vec));
 
 	status = nfsd_vfs_write(rqstp, &cstate->current_fh, nf,
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 78bdfdc253fd3..5a84aed17e705 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -234,8 +234,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		SVCFH_fmt(&argp->fh),
 		argp->len, argp->offset);
 
-	nvecs = svc_fill_write_vector(rqstp, rqstp->rq_arg.pages,
-				      &argp->first, cnt);
+	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
 	if (!nvecs) {
 		resp->status = nfserr_io;
 		goto out;
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 082449c7d0dbf..ddcc18adfeb1a 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -325,10 +325,7 @@ nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_writeargs *args = rqstp->rq_argp;
-	struct kvec *head = rqstp->rq_arg.head;
-	struct kvec *tail = rqstp->rq_arg.tail;
 	u32 beginoffset, totalcount;
-	size_t remaining;
 
 	if (!svcxdr_decode_fhandle(xdr, &args->fh))
 		return 0;
@@ -346,12 +343,8 @@ nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 		return 0;
 	if (args->len > NFSSVC_MAXBLKSIZE_V2)
 		return 0;
-	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
-	remaining -= xdr_stream_pos(xdr);
-	if (remaining < xdr_align_size(args->len))
+	if (!xdr_stream_subsegment(xdr, &args->payload, args->len))
 		return 0;
-	args->first.iov_base = xdr->p;
-	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
 
 	return 1;
 }
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index c67ad02b9a028..863a35f24910a 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -33,7 +33,7 @@ struct nfsd_writeargs {
 	svc_fh			fh;
 	__u32			offset;
 	__u32			len;
-	struct kvec		first;
+	struct xdr_buf		payload;
 };
 
 struct nfsd_createargs {
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 933008382bbeb..712c117300cb7 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -40,7 +40,7 @@ struct nfsd3_writeargs {
 	__u32			count;
 	int			stable;
 	__u32			len;
-	struct kvec		first;
+	struct xdr_buf		payload;
 };
 
 struct nfsd3_createargs {
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index dd3daadbc0e5c..b0986e969c2f4 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -531,8 +531,7 @@ int		   svc_encode_result_payload(struct svc_rqst *rqstp,
 					     unsigned int offset,
 					     unsigned int length);
 unsigned int	   svc_fill_write_vector(struct svc_rqst *rqstp,
-					 struct page **pages,
-					 struct kvec *first, size_t total);
+					 struct xdr_buf *payload);
 char		  *svc_fill_symlink_pathname(struct svc_rqst *rqstp,
 					     struct kvec *first, void *p,
 					     size_t total);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 0d3c3ca2830a8..54f66f66beb59 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1654,16 +1654,17 @@ EXPORT_SYMBOL_GPL(svc_encode_result_payload);
 /**
  * svc_fill_write_vector - Construct data argument for VFS write call
  * @rqstp: svc_rqst to operate on
- * @pages: list of pages containing data payload
- * @first: buffer containing first section of write payload
- * @total: total number of bytes of write payload
+ * @payload: xdr_buf containing only the write data payload
  *
  * Fills in rqstp::rq_vec, and returns the number of elements.
  */
-unsigned int svc_fill_write_vector(struct svc_rqst *rqstp, struct page **pages,
-				   struct kvec *first, size_t total)
+unsigned int svc_fill_write_vector(struct svc_rqst *rqstp,
+				   struct xdr_buf *payload)
 {
+	struct page **pages = payload->pages;
+	struct kvec *first = payload->head;
 	struct kvec *vec = rqstp->rq_vec;
+	size_t total = payload->len;
 	unsigned int i;
 
 	/* Some types of transport can present the write payload
-- 
2.43.0



