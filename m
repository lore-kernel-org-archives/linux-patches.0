Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE046EB72;
	Mon,  8 Apr 2024 13:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584439; cv=none; b=BDqsqKaLclIWhv3imtXCXPy8ANp3kSj3KWdWKg/Gi2241H0oaqThVZDvYW6U5PT6tXtV+iLYo+KIgQKC0s0sn2O188MVuYsoi3QJTQP2CVfNuEw/vzWheTjE7TZGGugEE89wcpxsKvfysk5cHsQEaAcsPPxVmnRC9MkQyyVEpQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584439; c=relaxed/simple;
	bh=K6ybJAY8vexWxJAr0VVpPcEHGgcQe0iSSPj25Tt0APs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1V9EI/+Byvt1dMUAN9p03qNPHYBAt7sziNB0JX2m7Sec1wVNinB08TaVdS/XgVO9qfst9beK51fsUmIAqRTsk5t34gHYc6ILYjrdYkCMi3TcsIsL+1qHZRcXoUDnWEIyu+xYRWHuBz+uF9sAnrwO6gY3EyYiQWoYDpZqALRXRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2A9s5nfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2A9s5nfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B13C433C7;
	Mon,  8 Apr 2024 13:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584439;
	bh=K6ybJAY8vexWxJAr0VVpPcEHGgcQe0iSSPj25Tt0APs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2A9s5nfSa4J3MAu64gdmvuCeYopUsTFPrOEdeh9phE03kWgTw/S4fBMAkGhb6L8Rg
	 FDNcHR5c5t2ZLceUo5NGZlzhH/lDNs//W6hAXpJ/cGiBQC6tp8WM2YnhMVPTQuo42G
	 oy1E2ROFwBMOhZJr6Z6V3s2FPKUAQfCUgcgWt/s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 438/690] NFSD: Refactor common code out of dirlist helpers
Date: Mon,  8 Apr 2024 14:55:04 +0200
Message-ID: <20240408125415.501029528@linuxfoundation.org>
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

[ Upstream commit 98124f5bd6c76699d514fbe491dd95265369cc99 ]

The dust has settled a bit and it's become obvious what code is
totally common between nfsd_init_dirlist_pages() and
nfsd3_init_dirlist_pages(). Move that common code to SUNRPC.

The new helper brackets the existing xdr_init_decode_pages() API.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs3proc.c         | 10 +---------
 fs/nfsd/nfsproc.c          | 10 +---------
 include/linux/sunrpc/xdr.h |  2 ++
 net/sunrpc/xdr.c           | 22 ++++++++++++++++++++++
 4 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 58695e4e18b46..923d9a80df92c 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -574,15 +574,7 @@ static void nfsd3_init_dirlist_pages(struct svc_rqst *rqstp,
 	buf->pages = rqstp->rq_next_page;
 	rqstp->rq_next_page += (buf->buflen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-	/* This is xdr_init_encode(), but it assumes that
-	 * the head kvec has already been consumed. */
-	xdr_set_scratch_buffer(xdr, NULL, 0);
-	xdr->buf = buf;
-	xdr->page_ptr = buf->pages;
-	xdr->iov = NULL;
-	xdr->p = page_address(*buf->pages);
-	xdr->end = (void *)xdr->p + min_t(u32, buf->buflen, PAGE_SIZE);
-	xdr->rqst = NULL;
+	xdr_init_encode_pages(xdr, buf, buf->pages,  NULL);
 }
 
 /*
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 49778ff410e32..82b3ddeacc338 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -575,15 +575,7 @@ static void nfsd_init_dirlist_pages(struct svc_rqst *rqstp,
 	buf->pages = rqstp->rq_next_page;
 	rqstp->rq_next_page++;
 
-	/* This is xdr_init_encode(), but it assumes that
-	 * the head kvec has already been consumed. */
-	xdr_set_scratch_buffer(xdr, NULL, 0);
-	xdr->buf = buf;
-	xdr->page_ptr = buf->pages;
-	xdr->iov = NULL;
-	xdr->p = page_address(*buf->pages);
-	xdr->end = (void *)xdr->p + min_t(u32, buf->buflen, PAGE_SIZE);
-	xdr->rqst = NULL;
+	xdr_init_encode_pages(xdr, buf, buf->pages,  NULL);
 }
 
 /*
diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 3a2c714d6b629..98e197376a0d9 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -240,6 +240,8 @@ typedef int	(*kxdrdproc_t)(struct rpc_rqst *rqstp, struct xdr_stream *xdr,
 
 extern void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf,
 			    __be32 *p, struct rpc_rqst *rqst);
+extern void xdr_init_encode_pages(struct xdr_stream *xdr, struct xdr_buf *buf,
+			   struct page **pages, struct rpc_rqst *rqst);
 extern __be32 *xdr_reserve_space(struct xdr_stream *xdr, size_t nbytes);
 extern int xdr_reserve_space_vec(struct xdr_stream *xdr, struct kvec *vec,
 		size_t nbytes);
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index f0a0a4ad6d525..b227d0c8471ff 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -918,6 +918,28 @@ void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p,
 }
 EXPORT_SYMBOL_GPL(xdr_init_encode);
 
+/**
+ * xdr_init_encode_pages - Initialize an xdr_stream for encoding into pages
+ * @xdr: pointer to xdr_stream struct
+ * @buf: pointer to XDR buffer into which to encode data
+ * @pages: list of pages to decode into
+ * @rqst: pointer to controlling rpc_rqst, for debugging
+ *
+ */
+void xdr_init_encode_pages(struct xdr_stream *xdr, struct xdr_buf *buf,
+			   struct page **pages, struct rpc_rqst *rqst)
+{
+	xdr_reset_scratch_buffer(xdr);
+
+	xdr->buf = buf;
+	xdr->page_ptr = pages;
+	xdr->iov = NULL;
+	xdr->p = page_address(*pages);
+	xdr->end = (void *)xdr->p + min_t(u32, buf->buflen, PAGE_SIZE);
+	xdr->rqst = rqst;
+}
+EXPORT_SYMBOL_GPL(xdr_init_encode_pages);
+
 /**
  * xdr_commit_encode - Ensure all data is written to buffer
  * @xdr: pointer to xdr_stream
-- 
2.43.0



