Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34541C549E;
	Wed, 19 Mar 2025 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394869; cv=none; b=Sbm7SSt4AUxwcBRsq18WLREOXEnAmCm40dLvrQe6IBmje51Atx6UOemT0iZyYO+6Z7Y6MI0BEqaGbvk4LSPkyI4dltpXM6kqNzOWvr8qoVP2LCzfLVTqBi5HXWqhzQH52wX1yBe9zu/E/zIOaFsfLIfAwg0MzmvUTou8SbTLDHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394869; c=relaxed/simple;
	bh=tN6icY64IwBxyikVGg7tzGOQUUa39s857vFPKP23/2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4iEp5P0p5XHmwCpK8gK65mHuS1zSA0G0NmHfbvHbyWxv00AjrwCc0uRX/HQAXWsf0JYfgZK5zXOMP6NHEbUDag+vLcmFbIMzcZ//dQREqKA8R137JPeQHZKI5f9y8WlRIfNvwQ3oIv8M1EDmA/yDvUqcJEcb1HY+XjcQoz8iZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KJlBwG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KJlBwG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2B4C4CEE4;
	Wed, 19 Mar 2025 14:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394869;
	bh=tN6icY64IwBxyikVGg7tzGOQUUa39s857vFPKP23/2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KJlBwG8Eo0rfOAaT6D6RVkMY1bfOVgTg/oiZdBth5nF68cExeaRUnwurKSPp4BIO
	 zmezwuEv65s3q7Ve9lpB8Ml18Xvti0Aa65PvvZ/bTcxx6FEC4CEUPnsoP+MmLnDwda
	 c1BFePFafQM1Jw5R3VKwBNpmg+nThzG90vFDg6qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 061/241] futex: Pass in task to futex_queue()
Date: Wed, 19 Mar 2025 07:28:51 -0700
Message-ID: <20250319143029.238400214@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5e0e02f0d7e52cfc8b1adfc778dd02181d8b47b4 ]

futex_queue() -> __futex_queue() uses 'current' as the task to store in
the struct futex_q->task field. This is fine for synchronous usage of
the futex infrastructure, but it's not always correct when used by
io_uring where the task doing the initial futex_queue() might not be
available later on. This doesn't lead to any issues currently, as the
io_uring side doesn't support PI futexes, but it does leave a
potentially dangling pointer which is never a good idea.

Have futex_queue() take a task_struct argument, and have the regular
callers pass in 'current' for that. Meanwhile io_uring can just pass in
NULL, as the task should never be used off that path. In theory
req->tctx->task could be used here, but there's no point populating it
with a task field that will never be used anyway.

Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/22484a23-542c-4003-b721-400688a0d055@kernel.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/futex.c        |  2 +-
 kernel/futex/core.c     |  5 +++--
 kernel/futex/futex.h    | 11 ++++++++---
 kernel/futex/pi.c       |  2 +-
 kernel/futex/waitwake.c |  4 ++--
 5 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index e29662f039e1a..f108da4ff863c 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -349,7 +349,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
 		io_ring_submit_unlock(ctx, issue_flags);
 
-		futex_queue(&ifd->q, hb);
+		futex_queue(&ifd->q, hb, NULL);
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index ebdd76b4ecbba..3db8567f5a44e 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -532,7 +532,8 @@ void futex_q_unlock(struct futex_hash_bucket *hb)
 	futex_hb_waiters_dec(hb);
 }
 
-void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
+void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+		   struct task_struct *task)
 {
 	int prio;
 
@@ -548,7 +549,7 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
 
 	plist_node_init(&q->list, prio);
 	plist_add(&q->list, &hb->chain);
-	q->task = current;
+	q->task = task;
 }
 
 /**
diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 99b32e728c4ad..6b2f4c7eb720f 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -285,13 +285,15 @@ static inline int futex_get_value_locked(u32 *dest, u32 __user *from)
 }
 
 extern void __futex_unqueue(struct futex_q *q);
-extern void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb);
+extern void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+				struct task_struct *task);
 extern int futex_unqueue(struct futex_q *q);
 
 /**
  * futex_queue() - Enqueue the futex_q on the futex_hash_bucket
  * @q:	The futex_q to enqueue
  * @hb:	The destination hash bucket
+ * @task: Task queueing this futex
  *
  * The hb->lock must be held by the caller, and is released here. A call to
  * futex_queue() is typically paired with exactly one call to futex_unqueue().  The
@@ -299,11 +301,14 @@ extern int futex_unqueue(struct futex_q *q);
  * or nothing if the unqueue is done as part of the wake process and the unqueue
  * state is implicit in the state of woken task (see futex_wait_requeue_pi() for
  * an example).
+ *
+ * Note that @task may be NULL, for async usage of futexes.
  */
-static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
+static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+			       struct task_struct *task)
 	__releases(&hb->lock)
 {
-	__futex_queue(q, hb);
+	__futex_queue(q, hb, task);
 	spin_unlock(&hb->lock);
 }
 
diff --git a/kernel/futex/pi.c b/kernel/futex/pi.c
index d62cca5ed8f4c..635c7d5d42220 100644
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -982,7 +982,7 @@ int futex_lock_pi(u32 __user *uaddr, unsigned int flags, ktime_t *time, int tryl
 	/*
 	 * Only actually queue now that the atomic ops are done:
 	 */
-	__futex_queue(&q, hb);
+	__futex_queue(&q, hb, current);
 
 	if (trylock) {
 		ret = rt_mutex_futex_trylock(&q.pi_state->pi_mutex);
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 3a10375d95218..a9056acb75eef 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -350,7 +350,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
 	 * access to the hash list and forcing another memory barrier.
 	 */
 	set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE);
-	futex_queue(q, hb);
+	futex_queue(q, hb, current);
 
 	/* Arm the timer */
 	if (timeout)
@@ -461,7 +461,7 @@ int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
 			 * next futex. Queue each futex at this moment so hb can
 			 * be unlocked.
 			 */
-			futex_queue(q, hb);
+			futex_queue(q, hb, current);
 			continue;
 		}
 
-- 
2.39.5



