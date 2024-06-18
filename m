Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009F4158A12;
	Tue, 18 Jun 2024 13:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716118; cv=none; b=Bn3rewWx6T4gUmLhMEDQrKc6Mu5s8oTsG5p+v7nWoM1Mbv01tl0b6LSC+OBMzTnEAcPGGzwmfvn3QMwAQ1dggWbps46POUrnPUlPZGkXdYUXKWtIZ5ULS+72+bv0WVVuENkf37V3dGyKKxQz4fY0QMjnC0DZ4PI9pe3/LRkodqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716118; c=relaxed/simple;
	bh=y1fEfVxu2tiMSLESZUIqMYSuGSZUeQ04616+i0NTJ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPbW7CReAYF2uBTNLo/Wr/L+0UfAvisa//SrSk9pLpm4Knaweda20qch3X4wq/+28SPEOOwLLvbr6H31C9sAE7Y2NhFjMWKJQAgT+0Tmfh/Q0bXV4N+WJPqYrlcuJv1BsKFun4hAGJT059S4bTmxeq8idssxcgYgPkibYM9ZxsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0Ny8k8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0Ny8k8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CE2C3277B;
	Tue, 18 Jun 2024 13:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716117;
	bh=y1fEfVxu2tiMSLESZUIqMYSuGSZUeQ04616+i0NTJ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0Ny8k8lnlx72+S52D52DhUV00IpMdBrbYmVri/xPYF2ZgRn8fC9qruV2ywUgb+Bc
	 0q0seHdpP/vACk7Fnmt2+ZWVwQ8XHZ/pFWpLUEihj79yJtBgDOZjlJYqdcLwZIPIY/
	 UtR+ctKHWfr43R4Vhtg8Po8BMmXFa2lcUa7lt0Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 538/770] SUNRPC: Optimize xdr_reserve_space()
Date: Tue, 18 Jun 2024 14:36:31 +0200
Message-ID: <20240618123428.074891625@linuxfoundation.org>
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

[ Upstream commit 62ed448cc53b654036f7d7f3c99f299d79ad14c3 ]

Transitioning between encode buffers is quite infrequent. It happens
about 1 time in 400 calls to xdr_reserve_space(), measured on NFSD
with a typical build/test workload.

Force the compiler to remove that code from xdr_reserve_space(),
which is a hot path on both the server and the client. This change
reduces the size of xdr_reserve_space() from 10 cache lines to 2
when compiled with -Os.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xdr.h | 16 +++++++++++++++-
 net/sunrpc/xdr.c           | 17 ++++++++++-------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 927f1458bcab9..b8fb866e1fd32 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -242,7 +242,7 @@ extern void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf,
 extern __be32 *xdr_reserve_space(struct xdr_stream *xdr, size_t nbytes);
 extern int xdr_reserve_space_vec(struct xdr_stream *xdr, struct kvec *vec,
 		size_t nbytes);
-extern void xdr_commit_encode(struct xdr_stream *xdr);
+extern void __xdr_commit_encode(struct xdr_stream *xdr);
 extern void xdr_truncate_encode(struct xdr_stream *xdr, size_t len);
 extern int xdr_restrict_buflen(struct xdr_stream *xdr, int newbuflen);
 extern void xdr_write_pages(struct xdr_stream *xdr, struct page **pages,
@@ -305,6 +305,20 @@ xdr_reset_scratch_buffer(struct xdr_stream *xdr)
 	xdr_set_scratch_buffer(xdr, NULL, 0);
 }
 
+/**
+ * xdr_commit_encode - Ensure all data is written to xdr->buf
+ * @xdr: pointer to xdr_stream
+ *
+ * Handle encoding across page boundaries by giving the caller a
+ * temporary location to write to, then later copying the data into
+ * place. __xdr_commit_encode() does that copying.
+ */
+static inline void xdr_commit_encode(struct xdr_stream *xdr)
+{
+	if (unlikely(xdr->scratch.iov_len))
+		__xdr_commit_encode(xdr);
+}
+
 /**
  * xdr_stream_remaining - Return the number of bytes remaining in the stream
  * @xdr: pointer to struct xdr_stream
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 722586696fade..f66e2de7cd279 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -691,7 +691,7 @@ void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p,
 EXPORT_SYMBOL_GPL(xdr_init_encode);
 
 /**
- * xdr_commit_encode - Ensure all data is written to buffer
+ * __xdr_commit_encode - Ensure all data is written to buffer
  * @xdr: pointer to xdr_stream
  *
  * We handle encoding across page boundaries by giving the caller a
@@ -703,22 +703,25 @@ EXPORT_SYMBOL_GPL(xdr_init_encode);
  * required at the end of encoding, or any other time when the xdr_buf
  * data might be read.
  */
-inline void xdr_commit_encode(struct xdr_stream *xdr)
+void __xdr_commit_encode(struct xdr_stream *xdr)
 {
 	int shift = xdr->scratch.iov_len;
 	void *page;
 
-	if (shift == 0)
-		return;
 	page = page_address(*xdr->page_ptr);
 	memcpy(xdr->scratch.iov_base, page, shift);
 	memmove(page, page + shift, (void *)xdr->p - page);
 	xdr_reset_scratch_buffer(xdr);
 }
-EXPORT_SYMBOL_GPL(xdr_commit_encode);
+EXPORT_SYMBOL_GPL(__xdr_commit_encode);
 
-static __be32 *xdr_get_next_encode_buffer(struct xdr_stream *xdr,
-		size_t nbytes)
+/*
+ * The buffer space to be reserved crosses the boundary between
+ * xdr->buf->head and xdr->buf->pages, or between two pages
+ * in xdr->buf->pages.
+ */
+static noinline __be32 *xdr_get_next_encode_buffer(struct xdr_stream *xdr,
+						   size_t nbytes)
 {
 	__be32 *p;
 	int space_left;
-- 
2.43.0



