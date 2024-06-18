Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44F613DDD2;
	Tue, 18 Jun 2024 12:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714648; cv=none; b=ihT801X6/FlCcvXuGWBVSCvhmrk76heviXv36Nzwne4138BPo+k5oNmJpDP8kj+G7vzXU3fKzb5DtYmMwxbCI0XCCXPeOVYmb8FBtcvqSiWBvEnOiiqQTJ45FrJSZc664XSYbey+UtYc+FgIshDLzHcMfH+pQRIzRxHN3vGMhQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714648; c=relaxed/simple;
	bh=b0e1wNkJJmbq/rwaTkNiySMwiK7b7bQJ5s4nFHvOO+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im6712cjL8Mc8r1rJg5GTtKYrzG5FKlula4Ei5Rx/Omyb9PWHiiBS3Snea5LvPp4zar8QJWAKL8xGmVgfibC2pAhhL379iExl9ylWWZ8xw55W/nYxadfmWgWc9GMVNfbIKYF5Y4slaDSM3f5MDtGli34euZQcGSctiVUnRcpI5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JupQfnx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JupQfnx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A94C3277B;
	Tue, 18 Jun 2024 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714648;
	bh=b0e1wNkJJmbq/rwaTkNiySMwiK7b7bQJ5s4nFHvOO+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JupQfnx5f4pwXd5IM0txPsrAvedctfMYa5P9T+HSavNae3+ADrIo1am6IupzCze6w
	 r/ZfiwZQp3WPuD0Zk5wJzeOkhW44qRia5bzI9PXA8mLLff3b3ekY/9tvLNfuU3NOIK
	 2DU3V/Ceogn+1p+0XFYtGYrHVWK5pvJDwkO8hS9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/770] NFSD: Invoke svc_encode_result_payload() in "read" NFSD encoders
Date: Tue, 18 Jun 2024 14:27:35 +0200
Message-ID: <20240618123407.383582184@linuxfoundation.org>
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

[ Upstream commit 76e5492b161f555c0fb69cad9eb39a7d8467f5fe ]

Have the NFSD encoders annotate the boundaries of every
direct-data-placement eligible result data payload. Then change
svcrdma to use that annotation instead of the xdr->page_len
when handling Write chunks.

For NFSv4 on RDMA, that enables the ability to recognize multiple
result payloads per compound. This is a pre-requisite for supporting
multiple Write chunks per RPC transaction.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c                     |  7 +++++
 fs/nfsd/nfs4xdr.c                     | 41 +++++++++++++++++++--------
 fs/nfsd/nfsxdr.c                      |  6 ++++
 net/sunrpc/xprtrdma/svc_rdma_sendto.c | 24 +++++-----------
 4 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 716566da400e1..27b24823f7c42 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -707,6 +707,7 @@ int
 nfs3svc_encode_readlinkres(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nfsd3_readlinkres *resp = rqstp->rq_resp;
+	struct kvec *head = rqstp->rq_res.head;
 
 	*p++ = resp->status;
 	p = encode_post_op_attr(rqstp, p, &resp->fh);
@@ -720,6 +721,8 @@ nfs3svc_encode_readlinkres(struct svc_rqst *rqstp, __be32 *p)
 			*p = 0;
 			rqstp->rq_res.tail[0].iov_len = 4 - (resp->len&3);
 		}
+		if (svc_encode_result_payload(rqstp, head->iov_len, resp->len))
+			return 0;
 		return 1;
 	} else
 		return xdr_ressize_check(rqstp, p);
@@ -730,6 +733,7 @@ int
 nfs3svc_encode_readres(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nfsd3_readres *resp = rqstp->rq_resp;
+	struct kvec *head = rqstp->rq_res.head;
 
 	*p++ = resp->status;
 	p = encode_post_op_attr(rqstp, p, &resp->fh);
@@ -746,6 +750,9 @@ nfs3svc_encode_readres(struct svc_rqst *rqstp, __be32 *p)
 			*p = 0;
 			rqstp->rq_res.tail[0].iov_len = 4 - (resp->count & 3);
 		}
+		if (svc_encode_result_payload(rqstp, head->iov_len,
+					      resp->count))
+			return 0;
 		return 1;
 	} else
 		return xdr_ressize_check(rqstp, p);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9971d3c295731..4b3344296ed0e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3770,8 +3770,8 @@ static __be32 nfsd4_encode_splice_read(
 {
 	struct xdr_stream *xdr = &resp->xdr;
 	struct xdr_buf *buf = xdr->buf;
+	int status, space_left;
 	u32 eof;
-	int space_left;
 	__be32 nfserr;
 	__be32 *p = xdr->p - 2;
 
@@ -3782,14 +3782,13 @@ static __be32 nfsd4_encode_splice_read(
 	nfserr = nfsd_splice_read(read->rd_rqstp, read->rd_fhp,
 				  file, read->rd_offset, &maxcount, &eof);
 	read->rd_length = maxcount;
-	if (nfserr) {
-		/*
-		 * nfsd_splice_actor may have already messed with the
-		 * page length; reset it so as not to confuse
-		 * xdr_truncate_encode:
-		 */
-		buf->page_len = 0;
-		return nfserr;
+	if (nfserr)
+		goto out_err;
+	status = svc_encode_result_payload(read->rd_rqstp,
+					   buf->head[0].iov_len, maxcount);
+	if (status) {
+		nfserr = nfserrno(status);
+		goto out_err;
 	}
 
 	*(p++) = htonl(eof);
@@ -3820,6 +3819,15 @@ static __be32 nfsd4_encode_splice_read(
 	xdr->end = (__be32 *)((void *)xdr->end + space_left);
 
 	return 0;
+
+out_err:
+	/*
+	 * nfsd_splice_actor may have already messed with the
+	 * page length; reset it so as not to confuse
+	 * xdr_truncate_encode in our caller.
+	 */
+	buf->page_len = 0;
+	return nfserr;
 }
 
 static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
@@ -3911,6 +3919,7 @@ nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd
 	int zero = 0;
 	struct xdr_stream *xdr = &resp->xdr;
 	int length_offset = xdr->buf->len;
+	int status;
 	__be32 *p;
 
 	p = xdr_reserve_space(xdr, 4);
@@ -3931,9 +3940,13 @@ nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd
 						(char *)p, &maxcount);
 	if (nfserr == nfserr_isdir)
 		nfserr = nfserr_inval;
-	if (nfserr) {
-		xdr_truncate_encode(xdr, length_offset);
-		return nfserr;
+	if (nfserr)
+		goto out_err;
+	status = svc_encode_result_payload(readlink->rl_rqstp, length_offset,
+					   maxcount);
+	if (status) {
+		nfserr = nfserrno(status);
+		goto out_err;
 	}
 
 	wire_count = htonl(maxcount);
@@ -3943,6 +3956,10 @@ nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd
 		write_bytes_to_xdr_buf(xdr->buf, length_offset + 4 + maxcount,
 						&zero, 4 - (maxcount&3));
 	return 0;
+
+out_err:
+	xdr_truncate_encode(xdr, length_offset);
+	return nfserr;
 }
 
 static __be32
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 8a288c8fcd57c..9e00a902113e3 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -469,6 +469,7 @@ int
 nfssvc_encode_readlinkres(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nfsd_readlinkres *resp = rqstp->rq_resp;
+	struct kvec *head = rqstp->rq_res.head;
 
 	*p++ = resp->status;
 	if (resp->status != nfs_ok)
@@ -483,6 +484,8 @@ nfssvc_encode_readlinkres(struct svc_rqst *rqstp, __be32 *p)
 		*p = 0;
 		rqstp->rq_res.tail[0].iov_len = 4 - (resp->len&3);
 	}
+	if (svc_encode_result_payload(rqstp, head->iov_len, resp->len))
+		return 0;
 	return 1;
 }
 
@@ -490,6 +493,7 @@ int
 nfssvc_encode_readres(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nfsd_readres *resp = rqstp->rq_resp;
+	struct kvec *head = rqstp->rq_res.head;
 
 	*p++ = resp->status;
 	if (resp->status != nfs_ok)
@@ -507,6 +511,8 @@ nfssvc_encode_readres(struct svc_rqst *rqstp, __be32 *p)
 		*p = 0;
 		rqstp->rq_res.tail[0].iov_len = 4 - (resp->count&3);
 	}
+	if (svc_encode_result_payload(rqstp, head->iov_len, resp->count))
+		return 0;
 	return 1;
 }
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index c8411b4f3492a..d6436c13d5c47 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -448,7 +448,6 @@ static ssize_t svc_rdma_encode_write_chunk(__be32 *src,
  * svc_rdma_encode_write_list - Encode RPC Reply's Write chunk list
  * @rctxt: Reply context with information about the RPC Call
  * @sctxt: Send context for the RPC Reply
- * @length: size in bytes of the payload in the first Write chunk
  *
  * The client provides a Write chunk list in the Call message. Fill
  * in the segments in the first Write chunk in the Reply's transport
@@ -465,12 +464,12 @@ static ssize_t svc_rdma_encode_write_chunk(__be32 *src,
  */
 static ssize_t
 svc_rdma_encode_write_list(const struct svc_rdma_recv_ctxt *rctxt,
-			   struct svc_rdma_send_ctxt *sctxt,
-			   unsigned int length)
+			   struct svc_rdma_send_ctxt *sctxt)
 {
 	ssize_t len, ret;
 
-	ret = svc_rdma_encode_write_chunk(rctxt->rc_write_list, sctxt, length);
+	ret = svc_rdma_encode_write_chunk(rctxt->rc_write_list, sctxt,
+					  rctxt->rc_read_payload_length);
 	if (ret < 0)
 		return ret;
 	len = ret;
@@ -923,21 +922,12 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 		goto err0;
 	if (wr_lst) {
 		/* XXX: Presume the client sent only one Write chunk */
-		unsigned long offset;
-		unsigned int length;
-
-		if (rctxt->rc_read_payload_length) {
-			offset = rctxt->rc_read_payload_offset;
-			length = rctxt->rc_read_payload_length;
-		} else {
-			offset = xdr->head[0].iov_len;
-			length = xdr->page_len;
-		}
-		ret = svc_rdma_send_write_chunk(rdma, wr_lst, xdr, offset,
-						length);
+		ret = svc_rdma_send_write_chunk(rdma, wr_lst, xdr,
+						rctxt->rc_read_payload_offset,
+						rctxt->rc_read_payload_length);
 		if (ret < 0)
 			goto err2;
-		if (svc_rdma_encode_write_list(rctxt, sctxt, length) < 0)
+		if (svc_rdma_encode_write_list(rctxt, sctxt) < 0)
 			goto err0;
 	} else {
 		if (xdr_stream_encode_item_absent(&sctxt->sc_stream) < 0)
-- 
2.43.0



