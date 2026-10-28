Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207078;
	b=TUqVr6hywIeLWp8cFC40kGcG64vfjTP0LSp/wN89NifrFUXUsmLg0ZJFL+CSgS3cOHt+
	 eDhLkzJUhAfjw9WNYcO/W66PdCKUmtH0h0JeY+BqC949SAQGAs/GlN1WFptqNb4m3v5Qk
	 KqMWa7+yPpUGj1+6RAdu40EWtVnTF6xyr7wetLJdF9wN9AS7w7hc2+mcZd0T7FM7aWr07
	 9S6yEEwtjM43D6tIL0rXEDm2HnepHFcyLeCE9AV+vS9dvBXru5I51Marc1bVDfFPnZoPL
	 MIOHM1XpBWNMIe66GnRBziGqbkE/c2H1TjGvwNjJEPlL30oB3YohhkwMu260m8OXApA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TNVAR/9/mLQWe/3mwIk9ac1b8ncYChpVdVnqKLRUsCI=;
	b=uul7SNdel67G5ayBh+CMFLLgkjBuZOep7rUk7adHtZakILq9OSzDcAgwo2F9UuOutaWM
	 Axq234QS8+yw2N5gKCBXPsDkA0lLxowjL92vQQwnd/lsE/6EBoLSB88bgx7KjhnkjKUcB
	 3JyDbZwcxr0q8JGwdDEDOcfCHfbIoyt6f7ZoG4DoAxTZsb6ZuWLdW9XJU9qR9ynQacYiY
	 uRpuBZnspEBuTQHqZywrV2Y7vXQIbXwk96LmjWIT503Yp6UZrg4bjEeEYN8rBFhv+N8jR
	 W9+w72yTfZtc1bBH+qzwoq2bVph1Z2CSjTPT7M3gXuGZLiPO6ilpynEXxB6d4xXRRCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QdocSiVW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9800606A31D;
	Wed, 28 Oct 2026 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QdocSiVW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAC41F01825;
	Wed, 28 Oct 2026 17:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207077;
	bh=TNVAR/9/mLQWe/3mwIk9ac1b8ncYChpVdVnqKLRUsCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdocSiVWgzwmb9RNhp9aYJH4R74CUFMO3L/eoYzud3GhP+dmZECKRYGlpkUO6QVfV
	 9bn7VOwVcFMtPXmly5yztuSsfIMHfShYkR5Ka59gQtGg71b54qes8AJSPohkzjTn/+
	 mBKp+nNO8X/bUO+zP+NBcHnSDsazFsh5//1/YfE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Gao <wegao@suse.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 18/38] io_uring: end the drain when the drain request completes
Date: Wed, 28 Oct 2026 18:00:05 +0100
Message-ID: <20261028165940.861225633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit ecb6817b769fd7d71af2c9f446188649020b2e53 upstream.

Since requests are drained based on allocated requests, the drain stays
active after the drain request has posted its CQE, until it is freed and
a new request finds the defer list empty. A drain request run by io-wq
is freed only after the worker drops its reference, so a request
submitted after the drain completed can still be deferred behind it,
and get issued much later than the application expects.

A drain request dispatched from the defer list runs alone. Track it,
and end the drain when its CQE is flushed and nothing else is deferred.
Have io-wq complete drain requests through task_work, so that this
happens under ->uring_lock before the CQE is visible. Linked drain
requests keep waiting until the link is freed.

Reported-by: Wei Gao <wegao@suse.com>
Link: https://lore.kernel.org/io-uring/20261018070154.16944-1-wegao@suse.com/
Fixes: 8fb7aee05591 ("io_uring: drain based on allocates reqs")
Cc: stable@vger.kernel.org
Tested-by: Wei Gao <wegao@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    2 +
 io_uring/io_uring.c            |   42 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -521,6 +521,8 @@ struct io_ring_ctx {
 	struct callback_head		poll_wq_task_work;
 	struct list_head		defer_list;
 	unsigned			nr_drained;
+	/* drain request dispatched from ->defer_list, until it completes */
+	struct io_kiocb			*drain_req;
 
 	/* protected by ->completion_lock */
 	unsigned			nr_req_allocated;
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -451,6 +451,9 @@ static __cold noinline void io_queue_def
 
 	lockdep_assert_held(&ctx->uring_lock);
 	__io_req_caches_free(ctx);
+	/* nothing outside of ->defer_list is alive */
+	if (ctx->nr_req_allocated == ctx->nr_drained)
+		ctx->drain_req = NULL;
 
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
@@ -462,6 +465,9 @@ static __cold noinline void io_queue_def
 
 		list_del_init(&de->list);
 		ctx->nr_drained -= io_linked_nr(de->req);
+		/* it runs alone, track its completion unless it's a link */
+		if ((de->req->flags & REQ_F_IO_DRAIN) && !de->req->link)
+			ctx->drain_req = de->req;
 		io_req_task_queue(de->req);
 		kfree(de);
 		first = false;
@@ -923,9 +929,11 @@ static void io_req_complete_post(struct
 
 	/*
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
-	 * the submitter task context, IOPOLL protects with uring_lock.
+	 * the submitter task context, IOPOLL protects with uring_lock. A drain
+	 * request ends the drain under uring_lock as its CQE is posted.
 	 */
-	if ((ctx->int_flags & IO_RING_F_LOCKLESS_CQ) || (req->flags & REQ_F_REISSUE)) {
+	if ((ctx->int_flags & IO_RING_F_LOCKLESS_CQ) ||
+	    (req->flags & (REQ_F_REISSUE | REQ_F_IO_DRAIN))) {
 defer_complete:
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
@@ -1126,11 +1134,33 @@ static void io_free_batch_list(struct io
 	} while (node);
 }
 
+/*
+ * The dispatched drain request ran alone, and anything submitted after it was
+ * deferred. Once it completed, new requests may run if nothing is waiting.
+ */
+static __cold bool io_drain_req_completed(struct io_ring_ctx *ctx)
+{
+	struct io_wq_work_node *node;
+
+	__wq_list_for_each(node, &ctx->submit_state.compl_reqs) {
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+					    comp_list);
+
+		/* a requeued request hasn't completed */
+		if (req == ctx->drain_req && !(req->flags & REQ_F_REISSUE)) {
+			ctx->drain_req = NULL;
+			return true;
+		}
+	}
+	return false;
+}
+
 void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	struct io_wq_work_node *node;
+	bool drain_done = false;
 
 	__io_cq_lock(ctx);
 	__wq_list_for_each(node, &state->compl_reqs) {
@@ -1152,13 +1182,19 @@ void __io_submit_flush_completions(struc
 	}
 	__io_cq_unlock_post(ctx);
 
+	if (unlikely(ctx->int_flags & IO_RING_F_DRAIN_ACTIVE) && ctx->drain_req)
+		drain_done = io_drain_req_completed(ctx);
+
 	if (!wq_list_empty(&state->compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
 
-	if (unlikely(ctx->int_flags & IO_RING_F_DRAIN_ACTIVE))
+	if (unlikely(ctx->int_flags & IO_RING_F_DRAIN_ACTIVE)) {
 		io_queue_deferred(ctx);
+		if (drain_done && list_empty(&ctx->defer_list))
+			ctx->int_flags &= ~IO_RING_F_DRAIN_ACTIVE;
+	}
 
 	ctx->submit_state.cq_flush = false;
 }


