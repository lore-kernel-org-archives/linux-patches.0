Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCED437847;
	Thu, 30 Jul 2026 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426865; cv=none; b=fqEvanv5BZW6reLRpxC3swpckH92qiVE4ht97+KgNA4UaIVZCxzeWiARCro5OfT39sa2OEDdSIp4RIlWzeUAmEWZlEGSzuDwaI4bszTElRiOPRRwsgvlg9a079xMcIRSD1hfqaw9Yihf8PrxZHMVB0k8JkrMETCS5/5KkOn2+l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426865; c=relaxed/simple;
	bh=VOeVkuIjl/rpGSOGCMsjWLLyOZAG4Y0nUPDMT5ZZDLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrLglFC0Iq6wi2ymPwuUlrnskiestutczZMEfez9c7k6nUqrsZ3zwmS/+wGEo/Yr8M7gQ1+ghmV7wIl6i0KiAQp3TAuZfcTjWyc6X5piMLYtNm3lqGnAA+inDEZCMbSLNtrblGCWYH2c57d1v4U1x7pc/pehujjBBrBnqJeDWtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqwUDSW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqwUDSW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D521F000E9;
	Thu, 30 Jul 2026 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426864;
	bh=4yD6j+LYJCGK7RZmfy/BzfSY62D0aOs4Av360DVaNcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqwUDSW4hHfbg7Yf9ClQhFteZGkyCG9OsRIq8ErGCXmu3VLhH3gXW8zHchCCYu2b4
	 86aAiqq8UDi+yxXmnwgaqgrKTIOvAI0Eynnv19oHVqm664wlq2cJMwqRJCR17yGKSM
	 kQBW+utocF5yqCkJOOZoXzU7p+p+Rmrq5xdTujOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 515/602] SUNRPC: Return an error from xdr_buf_to_bvec() on overflow
Date: Thu, 30 Jul 2026 16:15:07 +0200
Message-ID: <20260730141446.825373834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 18c1cc69886192e33536498289d26dba6894e3d5 ]

xdr_buf_to_bvec() returns a slot count even when the caller's bvec
budget is exhausted partway through the xdr_buf. Callers feed that
count into iov_iter_bvec() and continue as if the conversion had
succeeded, silently sending or writing fewer bytes than the data
length declares. For an NFS WRITE the server reports the truncated
transfer to the client as full success.

The overflow represents an internal invariant violation: a higher
layer reserved a bvec budget too small for the xdr_buf it then
asked the encoder to convert. That is a server-side fault, not a
media I/O failure and not a malformed client argument.

Change xdr_buf_to_bvec() to return a signed int and have the
overflow label return -ESERVERFAULT. Update the three callers to
detect the negative return and fail the request: nfsd_vfs_write()
folds the error into host_err, which nfserrno() translates to
nfserr_serverfault for the WRITE reply; svc_udp_sendto() and
svc_tcp_sendmsg() propagate the error out of the send path.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 2eb2b9358181 ("SUNRPC: Convert svc_tcp_sendmsg to use bio_vecs directly")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/xdr.h |    4 ++--
 net/sunrpc/svcsock.c       |   14 ++++++++++++--
 net/sunrpc/xdr.c           |   11 ++++++-----
 3 files changed, 20 insertions(+), 9 deletions(-)

--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -139,8 +139,8 @@ void	xdr_terminate_string(const struct x
 size_t	xdr_buf_pagecount(const struct xdr_buf *buf);
 int	xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp);
 void	xdr_free_bvec(struct xdr_buf *buf);
-unsigned int xdr_buf_to_bvec(struct bio_vec *bvec, unsigned int bvec_size,
-			     const struct xdr_buf *xdr);
+int xdr_buf_to_bvec(struct bio_vec *bvec, unsigned int bvec_size,
+		    const struct xdr_buf *xdr);
 int xdr_buf_to_sg(const struct xdr_buf *buf, unsigned int offset,
 		  unsigned int len, struct scatterlist *sg, unsigned int nsg);
 int xdr_buf_to_sg_alloc(const struct xdr_buf *buf, unsigned int offset,
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -748,7 +748,7 @@ static int svc_udp_sendto(struct svc_rqs
 		.msg_flags	= MSG_SPLICE_PAGES,
 		.msg_controllen	= sizeof(buffer),
 	};
-	unsigned int count;
+	int count;
 	int err;
 
 	svc_udp_release_ctxt(xprt, rqstp->rq_xprt_ctxt);
@@ -762,6 +762,10 @@ static int svc_udp_sendto(struct svc_rqs
 		goto out_notconn;
 
 	count = xdr_buf_to_bvec(svsk->sk_bvec, SUNRPC_MAX_UDP_SENDPAGES, xdr);
+	if (count < 0) {
+		err = count;
+		goto out_trace;
+	}
 
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, svsk->sk_bvec,
 		      count, rqstp->rq_res.len);
@@ -773,6 +777,7 @@ static int svc_udp_sendto(struct svc_rqs
 		err = sock_sendmsg(svsk->sk_sock, &msg);
 	}
 
+out_trace:
 	trace_svcsock_udp_send(xprt, err);
 
 	mutex_unlock(&xprt->xpt_mutex);
@@ -1251,7 +1256,7 @@ static int svc_tcp_sendmsg(struct svc_so
 	struct msghdr msg = {
 		.msg_flags	= MSG_SPLICE_PAGES,
 	};
-	unsigned int count;
+	int count;
 	void *buf;
 	int ret;
 
@@ -1269,10 +1274,15 @@ static int svc_tcp_sendmsg(struct svc_so
 
 	count = xdr_buf_to_bvec(svsk->sk_bvec + 1, RPCSVC_MAXPAGES,
 				&rqstp->rq_res);
+	if (count < 0) {
+		ret = count;
+		goto out;
+	}
 
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, svsk->sk_bvec,
 		      1 + count, sizeof(marker) + rqstp->rq_res.len);
 	ret = sock_sendmsg(svsk->sk_sock, &msg);
+out:
 	page_frag_free(buf);
 	if (ret < 0)
 		return ret;
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -167,13 +167,14 @@ xdr_free_bvec(struct xdr_buf *buf)
 /**
  * xdr_buf_to_bvec - Copy components of an xdr_buf into a bio_vec array
  * @bvec: bio_vec array to populate
- * @bvec_size: element count of @bio_vec
+ * @bvec_size: element count of @bvec
  * @xdr: xdr_buf to be copied
  *
- * Returns the number of entries consumed in @bvec.
+ * Returns the number of entries consumed in @bvec on success, or
+ * -ESERVERFAULT when @xdr does not fit within @bvec_size entries.
  */
-unsigned int xdr_buf_to_bvec(struct bio_vec *bvec, unsigned int bvec_size,
-			     const struct xdr_buf *xdr)
+int xdr_buf_to_bvec(struct bio_vec *bvec, unsigned int bvec_size,
+		    const struct xdr_buf *xdr)
 {
 	const struct kvec *head = xdr->head;
 	const struct kvec *tail = xdr->tail;
@@ -215,7 +216,7 @@ unsigned int xdr_buf_to_bvec(struct bio_
 
 bvec_overflow:
 	pr_warn_once("%s: bio_vec array overflow\n", __func__);
-	return count;
+	return -ESERVERFAULT;
 }
 
 /**


