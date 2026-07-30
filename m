Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CD032B116;
	Thu, 30 Jul 2026 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423286; cv=none; b=J6iD0XnYkzXxOjDLV2Mc48yXjbqCxJKAgziOHAdGv9B0+T57KWIu1C8850KNZxswKp7L3WgVlk9CxuI1QLbXDwl+siP7Hbwmpiw3zVJservnURRrewPlnmUoXubiqFXksgmWlMnrBPDnwcRIfx7tu9nwveIw7/o5ya+n6p+K1kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423286; c=relaxed/simple;
	bh=B42w6ne8HwhgGKMPEEspR8Ez1b+Q7aywdD7CTLHn1EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+ikxDlDzGhjWjdZAnaT3po3USFqIbzev/bOPNsIt9FkqHFNCDTPqy5yF7fWbK+24tA9jnCOh+8mSonv6oYasbx8RsF0HkeoXh6wGaCu6dWgRbeGjxX3N7hgvTXgqPl2iVVolxbqM4ZUmsCnGGqYqsj5PvNoKTR8W5xPKws/GPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2e7oBqF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2e7oBqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C781F000E9;
	Thu, 30 Jul 2026 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423284;
	bh=qQEiCvXkCofqDa1D91hx7NrslwscKDt62X0cs3bzfOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2e7oBqFFyRfabE3dls0e/660zRyU1ti+8MflH/eca5a9kmY6HqPUq08AKNDplOVX
	 Z5iIa7yIl4sKWLamuAi0/YyvZz0iVwSafzw7LGHFM02C+Zx8P933nq2AhVX57QdFpR
	 Eoa7IbT/hH2g2XCZwBhMb2Qq0FdqtLoDaNxhVL2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 730/744] SUNRPC: Return an error from xdr_buf_to_bvec() on overflow
Date: Thu, 30 Jul 2026 16:16:43 +0200
Message-ID: <20260730141459.816424689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfsd/vfs.c              |    6 +++++-
 include/linux/sunrpc/xdr.h |    4 ++--
 net/sunrpc/svcsock.c       |   14 ++++++++++++--
 net/sunrpc/xdr.c           |   11 ++++++-----
 4 files changed, 25 insertions(+), 10 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1439,7 +1439,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	unsigned long		exp_op_flags = 0;
 	unsigned int		pflags = current->flags;
 	bool			restore_flags = false;
-	unsigned int		nvecs;
+	int			nvecs;
 
 	trace_nfsd_write_opened(rqstp, fhp, offset, *cnt);
 
@@ -1479,6 +1479,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	}
 
 	nvecs = xdr_buf_to_bvec(rqstp->rq_bvec, rqstp->rq_maxpages, payload);
+	if (nvecs < 0) {
+		host_err = nvecs;
+		goto out_nfserr;
+	}
 
 	since = READ_ONCE(file->f_wb_err);
 	if (verf)
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -138,8 +138,8 @@ void	xdr_terminate_string(const struct x
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
@@ -742,7 +742,7 @@ static int svc_udp_sendto(struct svc_rqs
 		.msg_flags	= MSG_SPLICE_PAGES,
 		.msg_controllen	= sizeof(buffer),
 	};
-	unsigned int count;
+	int count;
 	int err;
 
 	svc_udp_release_ctxt(xprt, rqstp->rq_xprt_ctxt);
@@ -756,6 +756,10 @@ static int svc_udp_sendto(struct svc_rqs
 		goto out_notconn;
 
 	count = xdr_buf_to_bvec(svsk->sk_bvec, SUNRPC_MAX_UDP_SENDPAGES, xdr);
+	if (count < 0) {
+		err = count;
+		goto out_trace;
+	}
 
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, svsk->sk_bvec,
 		      count, rqstp->rq_res.len);
@@ -767,6 +771,7 @@ static int svc_udp_sendto(struct svc_rqs
 		err = sock_sendmsg(svsk->sk_sock, &msg);
 	}
 
+out_trace:
 	trace_svcsock_udp_send(xprt, err);
 
 	mutex_unlock(&xprt->xpt_mutex);
@@ -1247,7 +1252,7 @@ static int svc_tcp_sendmsg(struct svc_so
 	struct msghdr msg = {
 		.msg_flags	= MSG_SPLICE_PAGES,
 	};
-	unsigned int count;
+	int count;
 	void *buf;
 	int ret;
 
@@ -1263,10 +1268,15 @@ static int svc_tcp_sendmsg(struct svc_so
 
 	count = xdr_buf_to_bvec(svsk->sk_bvec + 1, rqstp->rq_maxpages,
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
 	return ret;
 }
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -139,13 +139,14 @@ xdr_free_bvec(struct xdr_buf *buf)
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
@@ -187,7 +188,7 @@ unsigned int xdr_buf_to_bvec(struct bio_
 
 bvec_overflow:
 	pr_warn_once("%s: bio_vec array overflow\n", __func__);
-	return count;
+	return -ESERVERFAULT;
 }
 EXPORT_SYMBOL_GPL(xdr_buf_to_bvec);
 


