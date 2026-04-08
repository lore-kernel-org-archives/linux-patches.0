Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B07B67E;
	Wed,  8 Apr 2026 18:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673652; cv=none; b=Wp6Hb0vjyCkgdcQ7umR6QvB8GGmmPM4NmmZe4vlfhVcNne+pFid3FYZRRz/tUxLpfiPok22yewDoNUKey39VNcUEPve7auu+NnKOAj+fxmhLP0A8nS1YQYcw9sdMF03is6hM4uKBa+BtikHhQYNEHQ1uu2zOi29xuVNiHF7oQKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673652; c=relaxed/simple;
	bh=yk33URUNA8uMOwslGqi2mp+IxMqc9bMD8pAX1Sk+l+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHr3ySKWTa+2t0W+lT6p3SvqYWphGBSdEY5b4PY7gjByXEGVdgQcwAXzCrgPfyTGTpnzChpGgWDBz2aqhoe2TZwO2Kal2P2+VFjWyuzpbVJuag/r6Tv1zZzWo0l+KXYZli3D/q30q3oXkrnJiAmR0CiAAyxktYbOznS6W8lfYI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLZwVQaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLZwVQaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B22EC19421;
	Wed,  8 Apr 2026 18:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673652;
	bh=yk33URUNA8uMOwslGqi2mp+IxMqc9bMD8pAX1Sk+l+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLZwVQaD5DMk9WlejbSMIHj+budc/MyDrkuqCBoq+LsbSufD7BKHkdjZnxVYWA6ce
	 pdXA1mnNm+Q9Og9jmid6f50oNd8A/eiGu+Q0U6nhspFjQRjX/CBgQxdzOKiJjH2UfA
	 STdISpR0Ei+KXqeYsRdLmZhCw3v3QKuO21B1b1eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 006/242] io_uring/kbuf: introduce io_kbuf_drop_legacy()
Date: Wed,  8 Apr 2026 20:00:46 +0200
Message-ID: <20260408175927.310037283@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

Commit 54e00d9a612ab93f37f612a5ccd7c0c4f8a31cea upstream.

io_kbuf_drop() is only used for legacy provided buffers, and so
__io_put_kbuf_list() is never called for REQ_F_BUFFER_RING. Remove the
dead branch out of __io_put_kbuf_list(), rename it into
io_kbuf_drop_legacy() and use it directly instead of io_kbuf_drop().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c8cc73e2272f09a86ecbdad9ebdd8304f8e583c0.1738724373.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 ++---
 io_uring/kbuf.c     |   10 ++++++++++
 io_uring/kbuf.h     |   24 ++----------------------
 3 files changed, 14 insertions(+), 25 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -382,9 +382,8 @@ static bool req_need_defer(struct io_kio
 
 static void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		io_kbuf_drop(req);
-	}
+	if (unlikely(req->flags & REQ_F_BUFFER_SELECTED))
+		io_kbuf_drop_legacy(req);
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
 		const struct io_cold_def *def = &io_cold_defs[req->opcode];
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -50,6 +50,16 @@ static int io_buffer_add_list(struct io_
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
+void io_kbuf_drop_legacy(struct io_kiocb *req)
+{
+	if (WARN_ON_ONCE(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return;
+	req->buf_index = req->kbuf->bgid;
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	kfree(req->kbuf);
+	req->kbuf = NULL;
+}
+
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -82,6 +82,7 @@ int io_unregister_pbuf_ring(struct io_ri
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
+void io_kbuf_drop_legacy(struct io_kiocb *req);
 
 void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
 struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
@@ -169,27 +170,6 @@ static inline bool __io_put_kbuf_ring(st
 	return ret;
 }
 
-static inline void __io_put_kbuf_list(struct io_kiocb *req, int len)
-{
-	if (req->flags & REQ_F_BUFFER_RING) {
-		__io_put_kbuf_ring(req, len, 1);
-	} else {
-		req->buf_index = req->kbuf->bgid;
-		req->flags &= ~REQ_F_BUFFER_SELECTED;
-		kfree(req->kbuf);
-		req->kbuf = NULL;
-	}
-}
-
-static inline void io_kbuf_drop(struct io_kiocb *req)
-{
-	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
-		return;
-
-	/* len == 0 is fine here, non-ring will always drop all of it */
-	__io_put_kbuf_list(req, 0);
-}
-
 static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
 					  int nbufs, unsigned issue_flags)
 {
@@ -203,7 +183,7 @@ static inline unsigned int __io_put_kbuf
 		if (!__io_put_kbuf_ring(req, len, nbufs))
 			ret |= IORING_CQE_F_BUF_MORE;
 	} else {
-		__io_put_kbuf_list(req, len);
+		io_kbuf_drop_legacy(req);
 	}
 	return ret;
 }


