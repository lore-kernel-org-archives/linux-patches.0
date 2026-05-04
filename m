Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52B33DE425;
	Mon,  4 May 2026 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903107; cv=none; b=jby1pbDlzCQIk7cU3lcXIcnq6Y3fPSMLOwzBjOmpp7jejm9tz0n16AQ26IL5OIW04NNVi0QA7WPxxfcCzswwEQnuvcdG92QXWpTw+g7bYcpKhVncD4SSyYQLpvaXvPN8Q7s04HSbwJkL/52vWPBcGuBwDCHXNvwMdQDECM/DvKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903107; c=relaxed/simple;
	bh=TIKV3hkLX7KZabYo25DTu0tX/YVAq97jdt3JYIdgXpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqHxqKIawQNBNC13lZ6c/elURu7ZU7y9ZTurVdxSbgM7oACn1ul9WeXfmtxq4h7/hx8jk4SuZoinXyIlQMY1lSxdWZeIjImvnGG4d66vftBu5NhEBfJ8N02Cyheu8hbw2J3lkOlhMM3h7xG9OBQA4I2dEgGzbqiDEGAiuoAUeuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrC2VBwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrC2VBwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAEDC2BCC4;
	Mon,  4 May 2026 13:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903107;
	bh=TIKV3hkLX7KZabYo25DTu0tX/YVAq97jdt3JYIdgXpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrC2VBwGhsYqcnLqp0hez3OXqMD61oDHKQwqy84u5LR7V+7iE8LTZexC8Ll8gTxcl
	 A4+dH/C79wF1r4Y+U1oank0NtmYfu7gbinTNCBnv82928IeA2mIAIRKDi9DPbkFwSQ
	 M8Q1ggnrJITDc8R7HJuqin0WCSZTWwp99PChbafI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngmin Choi <youngminchoi94@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 107/307] io_uring/zcrx: return back two step unregistration
Date: Mon,  4 May 2026 15:49:52 +0200
Message-ID: <20260504135146.836152201@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit e5361d25e241ac3a23177fa74ae91d049bad00d3 upstream.

There are reports where io_uring instance removal takes too long and an
ifq reallocation by another zcrx instance fails. Split zcrx destruction
into two steps similarly how it was before, first close the queue early
but maintain zcrx alive, and then when all inflight requests are
completed, drop the main zcrx reference. For extra protection, mark
terminated zcrx instances in xarray and warn if we double put them.

Cc: stable@vger.kernel.org # 6.19+
Link: https://github.com/axboe/liburing/issues/1550
Reported-by: Youngmin Choi <youngminchoi94@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/0ce21f0565ab4358668922a28a8a36922dfebf76.1774261953.git.asml.silence@gmail.com
[axboe: NULL ifq before break inside scoped guard]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 ++++
 io_uring/zcrx.c     |   46 +++++++++++++++++++++++++++++++++++++++++++---
 io_uring/zcrx.h     |    4 ++++
 3 files changed, 51 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2308,6 +2308,10 @@ static __cold void io_ring_exit_work(str
 	struct io_tctx_node *node;
 	int ret;
 
+	mutex_lock(&ctx->uring_lock);
+	io_terminate_zcrx(ctx);
+	mutex_unlock(&ctx->uring_lock);
+
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -624,12 +624,17 @@ static void io_zcrx_scrub(struct io_zcrx
 	}
 }
 
-static void zcrx_unregister(struct io_zcrx_ifq *ifq)
+static void zcrx_unregister_user(struct io_zcrx_ifq *ifq)
 {
 	if (refcount_dec_and_test(&ifq->user_refs)) {
 		io_close_queue(ifq);
 		io_zcrx_scrub(ifq);
 	}
+}
+
+static void zcrx_unregister(struct io_zcrx_ifq *ifq)
+{
+	zcrx_unregister_user(ifq);
 	io_put_zcrx_ifq(ifq);
 }
 
@@ -885,6 +890,36 @@ static struct net_iov *__io_zcrx_get_fre
 	return &area->nia.niovs[niov_idx];
 }
 
+static inline bool is_zcrx_entry_marked(struct io_ring_ctx *ctx, unsigned long id)
+{
+	return xa_get_mark(&ctx->zcrx_ctxs, id, XA_MARK_0);
+}
+
+static inline void set_zcrx_entry_mark(struct io_ring_ctx *ctx, unsigned long id)
+{
+	xa_set_mark(&ctx->zcrx_ctxs, id, XA_MARK_0);
+}
+
+void io_terminate_zcrx(struct io_ring_ctx *ctx)
+{
+	struct io_zcrx_ifq *ifq;
+	unsigned long id = 0;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	while (1) {
+		scoped_guard(mutex, &ctx->mmap_lock)
+			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
+		if (!ifq)
+			break;
+		if (WARN_ON_ONCE(is_zcrx_entry_marked(ctx, id)))
+			break;
+		set_zcrx_entry_mark(ctx, id);
+		id++;
+		zcrx_unregister_user(ifq);
+	}
+}
+
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
@@ -896,12 +931,17 @@ void io_unregister_zcrx_ifqs(struct io_r
 			unsigned long id = 0;
 
 			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
-			if (ifq)
+			if (ifq) {
+				if (WARN_ON_ONCE(!is_zcrx_entry_marked(ctx, id))) {
+					ifq = NULL;
+					break;
+				}
 				xa_erase(&ctx->zcrx_ctxs, id);
+			}
 		}
 		if (!ifq)
 			break;
-		zcrx_unregister(ifq);
+		io_put_zcrx_ifq(ifq);
 	}
 
 	xa_destroy(&ctx->zcrx_ctxs);
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -71,6 +71,7 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
+void io_terminate_zcrx(struct io_ring_ctx *ctx);
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
 		 unsigned issue_flags, unsigned int *len);
@@ -85,6 +86,9 @@ static inline int io_register_zcrx_ifq(s
 static inline void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 }
+static inline void io_terminate_zcrx(struct io_ring_ctx *ctx)
+{
+}
 static inline int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			       struct socket *sock, unsigned int flags,
 			       unsigned issue_flags, unsigned int *len)


