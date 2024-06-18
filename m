Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076CA13792B;
	Tue, 18 Jun 2024 13:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716538; cv=none; b=Rhql8YgnMCbBh/qr0HkcrwB3IPeyBd6L6pmBgZoIaHa0XBGaCiTzcn5SyMzg8Y41Bz2sZmVQBVrWyXrh/WGKbQGk3aAz97JNp2LUdwdZjT5YA6692deq15VBFSRUKawTGyt5ddvQh2L4yDnzl/VptLcbvTEqCsI7db/cX6An3f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716538; c=relaxed/simple;
	bh=5P9u2HN5ayZ3wRDzFi+hmSDDOqBgYT9E/STIW2mCUBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYSFGLGJcNMa/uBSM7hiEOobIjdZoI8DPCcaK39311el6hopGV1sNF2VCLWkzZ+pOYWhb/oA8cEM2BtvnbtkOS92XEiw6of4cm40eboCaSkHjrFZ9xIeQDXonwyXwcxl6ItC/Vcbx+Rswr4GsXx/rT2ezHdapb6Px818LK9TWKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eror7B6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eror7B6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9B4C3277B;
	Tue, 18 Jun 2024 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716537;
	bh=5P9u2HN5ayZ3wRDzFi+hmSDDOqBgYT9E/STIW2mCUBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eror7B6cxpuhosHgGsbmxQjb3RVgN3Sp3XxMazFgg1qDlMwuNop6UKlujS+nPcwPG
	 +NXeC7hreAsk37ngHvzD8QE0fLbgrT+0pGy7mHBpC3FbxOkZHfwM5xojst7aZXEKZK
	 M2FP9Apl42fwHoHg/j/cbyQStlywj9VNKqeSbeEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 651/770] NFSD: Refactor common code out of dirlist helpers
Date: Tue, 18 Jun 2024 14:38:24 +0200
Message-ID: <20240618123432.417657086@linuxfoundation.org>
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

[ Upstream commit 98124f5bd6c76699d514fbe491dd95265369cc99 ]

The dust has settled a bit and it's become obvious what code is
totally common between nfsd_init_dirlist_pages() and
nfsd3_init_dirlist_pages(). Move that common code to SUNRPC.

The new helper brackets the existing xdr_init_decode_pages() API.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c         | 10 +---------
 fs/nfsd/nfsproc.c          | 10 +---------
 include/linux/sunrpc/xdr.h |  2 ++
 net/sunrpc/xdr.c           | 22 ++++++++++++++++++++++
 4 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 5c2e2b5e5945f..a9bf455aee821 100644
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
index 3509331a66504..78fa5a9edf277 100644
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
index 59d99ff31c1a9..c1c50eaae4726 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -239,6 +239,8 @@ typedef int	(*kxdrdproc_t)(struct rpc_rqst *rqstp, struct xdr_stream *xdr,
 
 extern void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf,
 			    __be32 *p, struct rpc_rqst *rqst);
+extern void xdr_init_encode_pages(struct xdr_stream *xdr, struct xdr_buf *buf,
+			   struct page **pages, struct rpc_rqst *rqst);
 extern __be32 *xdr_reserve_space(struct xdr_stream *xdr, size_t nbytes);
 extern int xdr_reserve_space_vec(struct xdr_stream *xdr, struct kvec *vec,
 		size_t nbytes);
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index f66e2de7cd279..e2bd0cd391142 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -690,6 +690,28 @@ void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p,
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
  * __xdr_commit_encode - Ensure all data is written to buffer
  * @xdr: pointer to xdr_stream
-- 
2.43.0



