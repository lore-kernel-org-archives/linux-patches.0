Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209871;
	b=f3PfaPItukzZdVEmXkGJFoj/xqQUlsSoESz0CSkeQY6Ah7YElVSo9q3y0OyFH9fQtqvN
	 KNpdiBndwbHcdq3z+0QIhaJlzE7rw9+ZlWEgPl44NQj7o07RDtxGEqMzlokJON22y1vwM
	 yJUL9Gh14BUBYaLyW57fOKOEsPQ0E9h9pcAXK+6UdUOS926YVSqxJhXmE6NXLlqD59HNo
	 xhFhR/Eo4XijF4mY+velqFSefkgEwWTKponaqZd/FTkJuWW3HohpR8UtgnQkGOo+hX1H3
	 dCQm0ahRLvzc41AT7D2SUWmWih8s6meZmuuJ7F7YiRhXreB9oeLugCoQcNLWUW44jKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RDFRVXKbLgpEvtNbnJ11/04qPejWAjMDewPKYs7XG/A=;
	b=jJPve9O2QAkBQZlv5fWVrIDD6Z/RY1BdJmgRjRjamb5x2iCw51MUnHTaQRKx9jpUC/PS
	 dZp9VA5Loq0XNJvVR34cexrp4XqBysHzlEBNaEpoHaknFsfdjscKSv23YJaZ2FlrHwj6d
	 9nnSjD5J/zYsRYWGB1fTykkep9FwDFKKKtk4cK0BVOODHuRvQtChPkEuyyPGDGtzaxHZZ
	 qlsb+MnYdn+j+a4/X6ndrHbe+Ge3n4tLbvQUXNQyruzGgd49NDN7Wq+B4XM/+mXnyQN3L
	 i+KDae1tIOsLR2urQeAXVXx7n06ap1bmzEp7eCsWYlkuqHbD8XoS6fkTBwhrZct7IfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osfyTwPW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B59B606A31D;
	Wed, 28 Oct 2026 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osfyTwPW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BC71F01825;
	Wed, 28 Oct 2026 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209871;
	bh=RDFRVXKbLgpEvtNbnJ11/04qPejWAjMDewPKYs7XG/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osfyTwPWkBGpwZsIODXpPP2azynAZmZsNvXxlismAKazkh4pN5w7JfO8YvfIH0rKs
	 0+qgZiQRBLBavSq8q54otEdKmFfK9+xmgYy6CYAj8imped0e2+/bhgAkbrpzo5rv14
	 Yk9ArNNsV/yabiUD7CVSF5EL5etORPqTk2JDnVjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Gao <wegao@suse.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 089/109] io_uring: end the drain when the drain request completes
Date: Wed, 28 Oct 2026 18:01:13 +0100
Message-ID: <20261028165944.450697504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

Commit ecb6817b769fd7d71af2c9f446188649020b2e53 upstream.

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
[ 6.18: ->drain_active and ->lockless_cq are bools here ]
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
@@ -450,6 +450,8 @@ struct io_ring_ctx {
 	atomic_t			poll_wq_rcu_pending;
 	struct list_head		defer_list;
 	unsigned			nr_drained;
+	/* drain request dispatched from ->defer_list, until it completes */
+	struct io_kiocb			*drain_req;
 
 	/* protected by ->completion_lock */
 	unsigned			nr_req_allocated;
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -551,6 +551,9 @@ static __cold noinline void io_queue_def
 
 	lockdep_assert_held(&ctx->uring_lock);
 	__io_req_caches_free(ctx);
+	/* nothing outside of ->defer_list is alive */
+	if (ctx->nr_req_allocated == ctx->nr_drained)
+		ctx->drain_req = NULL;
 
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
@@ -562,6 +565,9 @@ static __cold noinline void io_queue_def
 
 		list_del_init(&de->list);
 		ctx->nr_drained -= io_linked_nr(de->req);
+		/* it runs alone, track its completion unless it's a link */
+		if ((de->req->flags & REQ_F_IO_DRAIN) && !de->req->link)
+			ctx->drain_req = de->req;
 		io_req_task_queue(de->req);
 		kfree(de);
 		first = false;
@@ -1011,9 +1017,11 @@ static void io_req_complete_post(struct
 
 	/*
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
-	 * the submitter task context, IOPOLL protects with uring_lock.
+	 * the submitter task context, IOPOLL protects with uring_lock. A drain
+	 * request ends the drain under uring_lock as its CQE is posted.
 	 */
-	if (ctx->lockless_cq || (req->flags & REQ_F_REISSUE)) {
+	if (ctx->lockless_cq ||
+	    (req->flags & (REQ_F_REISSUE | REQ_F_IO_DRAIN))) {
 defer_complete:
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
@@ -1612,11 +1620,33 @@ static void io_free_batch_list(struct io
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
@@ -1638,13 +1668,19 @@ void __io_submit_flush_completions(struc
 	}
 	__io_cq_unlock_post(ctx);
 
+	if (unlikely(ctx->drain_active) && ctx->drain_req)
+		drain_done = io_drain_req_completed(ctx);
+
 	if (!wq_list_empty(&state->compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
 
-	if (unlikely(ctx->drain_active))
+	if (unlikely(ctx->drain_active)) {
 		io_queue_deferred(ctx);
+		if (drain_done && list_empty(&ctx->defer_list))
+			ctx->drain_active = false;
+	}
 
 	ctx->submit_state.cq_flush = false;
 }


