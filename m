Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216000;
	b=4TYM5szt65iIFjGbgJnYQRwA3FAoc9rXP2UjxklTLondvrcKqbDMQ28gDcqiLOr4fW21
	 ekhWny5m4asu8K7BF4+WR7iZX237mIbKTsefCCYxrHhYV8EmB8bEd4UuFxJ7C1UnmbBQi
	 2hEP477WAbs1zn19YH0YxZ0oFLBTELbGEFitcqgN+OnxM3NfkjDdl8y/RIVFid9oyP7iZ
	 8lcdib93IzTiVl7oVk3Af+VbbF32vWQNAkFw6uXlBefCNt6VGQ+nW6dJo2iRqob/teMIg
	 xiQ0CrydER4KS5Gl0kl2oZmdTX1UU65r6UXHgSeztW1ic8XscaEdZE1v08bkQVVzX8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PijzemJw9WnfzXfBkNWNWucIosmtXDcAYjGIuBSingw=;
	b=blB/tcg+pUKDOxTawlICKYzzjQv4kZYAdz6b5UKd1IejyTAuh+ewI/ecHhat26X9vZ1x
	 RG1bODwLHQoN0fHyg1XNqG8iNq1bWeAd0oEJSuqdfEDyu6q80Q/Yk5uS1oO7FS+UgnXdT
	 9+lF0y3Ygx4WbU8nUJBZPDMKO7KGuXeCcqRVs1BjIRY7G0bXmEFDy4FJsE25y0C6em0OO
	 FccmBRi9XTjoh7OJhyRzz58ASX7zPwFHhTE0qgMRelbvsTEG7frhrgCLYe98eaGjLhEPl
	 qY+nh0neAqCWMB+2NQLPmeHzhiQOu34iIyFjCwTJYoRFjZLrfUf0cTiGD0mH78Du0YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xe1AJU5W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A185A606A31C;
	Wed, 28 Oct 2026 19:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xe1AJU5W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BFD1F01825;
	Wed, 28 Oct 2026 19:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215999;
	bh=PijzemJw9WnfzXfBkNWNWucIosmtXDcAYjGIuBSingw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xe1AJU5WtsQfwO6iadIjFEU2SiyX2gEQiOGJg5sYll6+bUZq7fqIs4cE1yhekxvGh
	 xeFsan9JEIKR/pQSGpidTpYy6p0wNQ1K/QAIGDvLYpsfu3WEndVPVOLj1zrgt7bYAw
	 7J99gLMWumnjs/+8jgLN5WQebjwE6VdzhdoDO8WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1404/1887] SUNRPC: Convert unwrap_priv_data() to use xdr_stream
Date: Wed, 28 Oct 2026 17:58:20 +0100
Message-ID: <20261028170531.402774180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 42140718ea26c47fb06c679451a6aa6703545136 ]

Done as part of hardening the server-side RPC header decoding path.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: a919c5c88769 ("SUNRPC: svcauth_gss: enforce krb5 token minimum length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xdr.h        |  1 -
 net/sunrpc/auth_gss/svcauth_gss.c | 64 ++++++++++---------------------
 net/sunrpc/xdr.c                  |  7 ----
 3 files changed, 21 insertions(+), 51 deletions(-)

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index f84e2a1358e17..f7e2850c8638f 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -188,7 +188,6 @@ xdr_adjust_iovec(struct kvec *iov, __be32 *p)
 /*
  * XDR buffer helper functions
  */
-extern void xdr_shift_buf(struct xdr_buf *, size_t);
 extern void xdr_buf_from_iov(const struct kvec *, struct xdr_buf *);
 extern int xdr_buf_subsegment(const struct xdr_buf *, struct xdr_buf *, unsigned int, unsigned int);
 extern void xdr_buf_trim(struct xdr_buf *, unsigned int);
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 07e6b8c5dbe1a..7d15429dfd7ab 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -972,17 +972,6 @@ total_buf_len(struct xdr_buf *buf)
 	return buf->head[0].iov_len + buf->page_len + buf->tail[0].iov_len;
 }
 
-static void
-fix_priv_head(struct xdr_buf *buf, int pad)
-{
-	if (buf->page_len == 0) {
-		/* We need to adjust head and buf->len in tandem in this
-		 * case to make svc_defer() work--it finds the original
-		 * buffer start using buf->len - buf->head[0].iov_len. */
-		buf->head[0].iov_len -= pad;
-	}
-}
-
 /*
  * RFC 2203, Section 5.3.2.3
  *
@@ -995,49 +984,37 @@ fix_priv_head(struct xdr_buf *buf, int pad)
  *		proc_req_arg_t arg;
  *	};
  */
-static int
-svcauth_gss_unwrap_priv(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq,
-			struct gss_ctx *ctx)
+static noinline_for_stack int
+svcauth_gss_unwrap_priv(struct svc_rqst *rqstp, u32 seq, struct gss_ctx *ctx)
 {
-	u32 len, seq_num, maj_stat;
-	int pad, remaining_len, offset;
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	u32 len, maj_stat, seq_num, offset;
+	struct xdr_buf *buf = xdr->buf;
+	unsigned int saved_len;
 
 	clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
-	len = svc_getnl(&buf->head[0]);
+	if (xdr_stream_decode_u32(xdr, &len) < 0)
+		goto unwrap_failed;
 	if (rqstp->rq_deferred) {
 		/* Already decrypted last time through! The sequence number
 		 * check at out_seq is unnecessary but harmless: */
 		goto out_seq;
 	}
-	/* buf->len is the number of bytes from the original start of the
-	 * request to the end, where head[0].iov_len is just the bytes
-	 * not yet read from the head, so these two values are different: */
-	remaining_len = total_buf_len(buf);
-	if (len > remaining_len)
+	if (len > xdr_stream_remaining(xdr))
 		goto unwrap_failed;
-	pad = remaining_len - len;
-	buf->len -= pad;
-	fix_priv_head(buf, pad);
-
-	maj_stat = gss_unwrap(ctx, 0, len, buf);
-	pad = len - buf->len;
-	/* The upper layers assume the buffer is aligned on 4-byte boundaries.
-	 * In the krb5p case, at least, the data ends up offset, so we need to
-	 * move it around. */
-	/* XXX: This is very inefficient.  It would be better to either do
-	 * this while we encrypt, or maybe in the receive code, if we can peak
-	 * ahead and work out the service and mechanism there. */
-	offset = xdr_pad_size(buf->head[0].iov_len);
-	if (offset) {
-		buf->buflen = RPCSVC_MAXPAYLOAD;
-		xdr_shift_buf(buf, offset);
-		fix_priv_head(buf, pad);
-	}
+	offset = xdr_stream_pos(xdr);
+
+	saved_len = buf->len;
+	maj_stat = gss_unwrap(ctx, offset, offset + len, buf);
 	if (maj_stat != GSS_S_COMPLETE)
 		goto bad_unwrap;
+	xdr->nwords -= XDR_QUADLEN(saved_len - buf->len);
+
 out_seq:
-	seq_num = svc_getnl(&buf->head[0]);
+	/* gss_unwrap() decrypted the sequence number. */
+	if (xdr_stream_decode_u32(xdr, &seq_num) < 0)
+		goto unwrap_failed;
 	if (seq_num != seq)
 		goto bad_seqno;
 	return 0;
@@ -1664,8 +1641,9 @@ svcauth_gss_accept(struct svc_rqst *rqstp)
 			/* placeholders for length and seq. number: */
 			svc_putnl(resv, 0);
 			svc_putnl(resv, 0);
-			if (svcauth_gss_unwrap_priv(rqstp, &rqstp->rq_arg,
-						    gc->gc_seq, rsci->mechctx))
+			svcxdr_init_decode(rqstp);
+			if (svcauth_gss_unwrap_priv(rqstp, gc->gc_seq,
+						    rsci->mechctx))
 				goto garbage_args;
 			rqstp->rq_auth_slack = RPC_MAX_AUTH_SIZE * 2;
 			break;
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 612b1a5572ebc..7c4e966a6aad2 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -863,13 +863,6 @@ static unsigned int xdr_shrink_pagelen(struct xdr_buf *buf, unsigned int len)
 	return shift;
 }
 
-void
-xdr_shift_buf(struct xdr_buf *buf, size_t len)
-{
-	xdr_shrink_bufhead(buf, buf->head->iov_len - len);
-}
-EXPORT_SYMBOL_GPL(xdr_shift_buf);
-
 /**
  * xdr_stream_pos - Return the current offset from the start of the xdr_stream
  * @xdr: pointer to struct xdr_stream
-- 
2.53.0



