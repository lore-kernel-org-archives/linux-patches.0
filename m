Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774315;
	b=qgIbzGlBS1w2agBcJv77Z6hdSv9IabwdY0bLTYKX/8f2phTD5giNhhLze1qnEN4LRBfI
	 XJpLtjm+IbLo2uzsq8k4u68/PiPXi0shjslZhZPL9iwp6M1gDjrqMCDsGxYtExUT6OBjR
	 S1oiUPCM0WO3dVbIj1pkZFJhE8GcHdXPLQRLCDexHXezIclQUz1rECOPURqB0dHIvun1X
	 /cZ8bh/pfPSVso3OZ9kP0ULpa8xbaA1HG0w3nspzh4qxIAKVu0X4zOPWXRPq8ivz8FmJh
	 u/QtPT4Yg3SmfkE1ZveaiEskVgI60kIquO0kwTZvgJwSEfTGHfCUAFWJ8iq1tBLpu7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FIPs0wZYT/EukkHklrnwWguaatQsdtAqHx7idejNQe8=;
	b=aZc29Q2g3b/imgrDXcyg6ZzLbhQxL0HbO7RJPD3qQ25IAo/b6/B6Rz8fCZnvUKPD4mD1
	 t2lfQ1e1k+4Vp1Lt8Oz8gRFyiGs1xx5Th4RT0taW/dTv/tV50YO4Od4jYhwpP1IBFBIQ5
	 8dCLMpqdZVKok5R04+hNWSaCaJMJ7QqRc+E3uRZ0bRBTfVtqO8q8nTEVH94ir2CtwZtl9
	 UwI+59FRQsBZ/rALK9BF7j+3e99o7nInHeJjqu3heZgI7D1Gvaf1vAOLX/ozinAb4Sg3P
	 6BqJWzS0A+fVI7Vngornc5UR4PF/PYFkoJ/FTQJiXBOwFbL/CSyrWEpxL4zYR3+EVnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUIDLAYg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EAC606A31A;
	Fri, 23 Oct 2026 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUIDLAYg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348691F01825;
	Fri, 23 Oct 2026 16:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774314;
	bh=FIPs0wZYT/EukkHklrnwWguaatQsdtAqHx7idejNQe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUIDLAYgTetkNtyFQtzSB284Tq98j9iQCtxipxFQFA8zSjqxDdbg5Y9Hq16izbOdT
	 y9xwyhdoNIC3onZK3VfK9AyWAObJA1zVgCvxUMyWLKKb6J7IEqOGb/TcTjm2CbELtG
	 ZtUPryYiV4d9vuwpd6v8ojyBAs80LufYeaoW2OtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/193] io_uring/cancel: move request/task cancelation logic into cancel.c
Date: Fri, 23 Oct 2026 18:37:34 +0200
Message-ID: <20261023163718.404527383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 0d677936d67774f1b4ebfb3b26f207320f0fe3c6 ]

Move io_match_task_safe() and helpers into cancel.c, where it belongs.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: fddcf4c5321b ("io_uring/cancel: don't spin on local work the task can't run")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c   |   38 ++++++++++++++++++++++++++++++++++++++
 io_uring/cancel.h   |    2 ++
 io_uring/io_uring.c |   38 --------------------------------------
 io_uring/io_uring.h |    3 ---
 4 files changed, 40 insertions(+), 41 deletions(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -384,3 +384,41 @@ int io_cancel_remove(struct io_ring_ctx
 	io_ring_submit_unlock(ctx, issue_flags);
 	return nr ?: -ENOENT;
 }
+
+static bool io_match_linked(struct io_kiocb *head)
+{
+	struct io_kiocb *req;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+/*
+ * As io_match_task() but protected against racing with linked timeouts.
+ * User must not hold timeout_lock.
+ */
+bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
+			bool cancel_all)
+{
+	bool matched;
+
+	if (tctx && head->tctx != tctx)
+		return false;
+	if (cancel_all)
+		return true;
+
+	if (head->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = head->ctx;
+
+		/* protect against races with linked timeouts */
+		raw_spin_lock_irq(&ctx->timeout_lock);
+		matched = io_match_linked(head);
+		raw_spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		matched = io_match_linked(head);
+	}
+	return matched;
+}
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -21,6 +21,8 @@ int io_try_cancel(struct io_uring_task *
 
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
+bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
+			bool cancel_all);
 
 bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  struct hlist_head *list, bool cancel_all,
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -210,44 +210,6 @@ static inline unsigned int __io_cqring_e
 	return READ_ONCE(rings->cq.tail) - READ_ONCE(rings->cq.head);
 }
 
-static bool io_match_linked(struct io_kiocb *head)
-{
-	struct io_kiocb *req;
-
-	io_for_each_link(req, head) {
-		if (req->flags & REQ_F_INFLIGHT)
-			return true;
-	}
-	return false;
-}
-
-/*
- * As io_match_task() but protected against racing with linked timeouts.
- * User must not hold timeout_lock.
- */
-bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
-			bool cancel_all)
-{
-	bool matched;
-
-	if (tctx && head->tctx != tctx)
-		return false;
-	if (cancel_all)
-		return true;
-
-	if (head->flags & REQ_F_LINK_TIMEOUT) {
-		struct io_ring_ctx *ctx = head->ctx;
-
-		/* protect against races with linked timeouts */
-		raw_spin_lock_irq(&ctx->timeout_lock);
-		matched = io_match_linked(head);
-		raw_spin_unlock_irq(&ctx->timeout_lock);
-	} else {
-		matched = io_match_linked(head);
-	}
-	return matched;
-}
-
 static inline void req_fail_link_node(struct io_kiocb *req, int res)
 {
 	req_set_fail(req);
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -185,9 +185,6 @@ void io_queue_next(struct io_kiocb *req)
 void io_task_refs_refill(struct io_uring_task *tctx);
 bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
-bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
-			bool cancel_all);
-
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)


