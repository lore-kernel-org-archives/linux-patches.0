Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207335;
	b=zJ+qvIuymzEcNRJmIC3xO5SzdAbLlvVQanjY1nqoSoEKBdlZmAI+Du/Pq+igZnf/EAkS
	 YQQs4lVPODXdRdB3oCGsnOGIw5seNth9wV4sLqYL1Ur6J3AJXdPkVaN5zyjOGyOf8S0Ch
	 GhQz7rwji/X6yJ+ZtrjPw4vrs35kGzhB5uhDF7XZJT1zlBABvJYbKgqdPSmT4w12N3Gzj
	 o86PwVtpcIlCCkBrN6YDT8iQClgIu0A1HNBxC1czymIqyKkPavTyTxHi9fikwltH4gxrm
	 A6LK/9QA+tTjY99U8VQms173PgdnPkuKVwT8m6ZeWTKpGdsFMruwSwMHqhqtunOjrvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cdiq2rVtLlCp5uTVItimH1WUFZVLZehWiB8aUrqvhmU=;
	b=Fp/BYLsHw1GtXcIqGRNm8JSfFPzylDG74yqisb6IIW/29YVdqOfp67ebHWVYkvslSZsJ
	 kP1yhmO3wWp65kSPFPLiwVuretN+N/nfLjnSm472cyEQdHpWDyl/PQxHiEh6mVtwogaGT
	 BYIWjk86hafDU/0Y/QYd6LVrgqkvGwy1uDqnqMUDpVMUsiLBVUjxLHHNjEJKluQ51jZ0N
	 ShfthgaHqJtIKcYzStOnOYkAStYDub19ZZ5sVA4lzAxIiCxBm7LE17CAgkUoQYhX4JbMW
	 wd1HRl4Yec4QCVsD6ew3qNbyrXhRPW181omdPABML2ZBrDHsfPqM+7V9P5KfkvtnxDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZB6qkoGt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB8E606A31A;
	Wed, 28 Oct 2026 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZB6qkoGt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B591F01825;
	Wed, 28 Oct 2026 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207334;
	bh=cdiq2rVtLlCp5uTVItimH1WUFZVLZehWiB8aUrqvhmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZB6qkoGtFHF7Ax5lX7kPk3H8v2j2HIdhQKHyn6Et6ChRW7ie6WTf9x0oYsTgsZ660
	 dXtCgZUvtnCxwBvQqVCg00Eo8PylrHhWWTwNGISat7NyKIA0lJJxFMrpANO1rN9J7p
	 XM5nug3X33axa0h+UpBrwthi2U+idzbbxorRhs2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 25/88] io_uring/mpscq: disable preemption while pushing
Date: Wed, 28 Oct 2026 17:59:33 +0100
Message-ID: <20261028165942.709752133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 68a95c3968895cd198f42baadb23e635fecc5a66 upstream.

A push makes the node the new tail, and then links it to its predecessor.
In between the queue isn't empty, but mpscq_pop() can't get at the node.
The consumers deal with that by trying again, with a cond_resched() in
the loop to give a preempted producer the chance to finish.

cond_resched() doesn't do that if the consumer has a higher priority than
the producer and both have to use the same CPU:

  producer (SCHED_OTHER)              consumer (SCHED_FIFO), same CPU
  io_req_local_work_add()
    mpscq_push()
      prev = xchg(&q->tail, node)
  <preempted>                         io_cqring_wait()
                                        __io_run_local_work()
                                      again:
                                          cond_resched()  // nothing to do
                                          mpscq_pop()     // NULL
                                          // work pending, no events yet
                                          goto again

The producer can be any task that is able to queue task_work for the
ring: an io-wq worker, or somebody who sends a message with
IORING_OP_MSG_RING. The consumer spins, holding ->uring_lock, until the
scheduler takes pity on the fair class, which takes about a second with
the default settings of the fair server, and forever without it. The
loops in tctx_task_work_run() and io_cancel_local_task_work() have the
same problem.

Don't allow preemption between the two steps. That bounds the time the
window is open on the CPU of the producer by what interrupts take, and a
consumer that waits for that is on another CPU. The cost is a
preempt_disable()/preempt_enable() pair per push.

Fixes: 50cb44bd0d5f ("io_uring/mpscq: add lockless multi-producer, single-consumer FIFO queue")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-9-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/mpscq.h |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/io_uring/mpscq.h
+++ b/io_uring/mpscq.h
@@ -25,9 +25,10 @@
  * its predecessor. In between, the tail end of the queue is not yet reachable
  * from the head. mpscq_pop() detects this and returns NULL, while mpscq_empty()
  * reports false. The consumer must not treat such a NULL as "queue empty" - it
- * should retry later. The window is two instructions wide, but a producer can
- * be preempted inside it, so the consumer must not spin on it while holding
- * resources the producer might need to make progress.
+ * should retry later. The window is two instructions wide and the producer
+ * can't be preempted inside it, but it can be interrupted, so the consumer must
+ * not spin on it while holding resources the producer might need to make
+ * progress.
  *
  * The consumer side only supports a single consumer at a time, callers must
  * provide their own serialization for it. The stub node is what allows the
@@ -70,6 +71,12 @@ static inline bool mpscq_push(struct mps
 
 	node->next = NULL;
 	/*
+	 * All the consumer can do about a node that isn't linked yet is to try
+	 * again. If it is what preempted us, and we don't get to run as long
+	 * as it does, that never ends.
+	 */
+	preempt_disable();
+	/*
 	 * xchg() implies a full barrier, so the initialization of the
 	 * entry (including ->next above) is visible before the node can
 	 * be reached, either via ->tail or via ->next chasing from the
@@ -77,6 +84,7 @@ static inline bool mpscq_push(struct mps
 	 */
 	prev = xchg(&q->tail, node);
 	WRITE_ONCE(prev->next, node);
+	preempt_enable();
 	return prev == &q->stub;
 }
 


