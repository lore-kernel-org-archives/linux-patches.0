Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207966;
	b=5fPkyaB6XjTC571IZb9roP8Nn3WO4trN+WCybbRb3pue0lzfzo0+PbYLrutjiLPeXFi/
	 uEZTWkdPAyLd+x/zuLa73D7BIO1MuyoyUK2iFKnJ+jHWeaTJUillVx+QWaavemrLfQp3l
	 MH/yCUlDonn7I2AOURg91Nv9MmGaqWiUJDJjOyza52DLmJJNkdaqNbbLSR4kTXBWlCeik
	 PZnNLZhrJdGpCurF7Q1zu2ys/w5+lXFQAav6ry4kSVVM1UFBU1iE95zhUM5UNXOZ+BI6O
	 79zmvckeRMg7YBALYpiE+U1tS4dRsQPQW4cJa1KJQjPgWnEVFe6VR4ymwu2CpufsXQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SGnR+FILBBz5papwOqQbOIimsKg0ssS0i1FvMzAZurk=;
	b=R/e4IzV9t1DDsUxOl4fvaYOMAboi9DJo1cCv29VP8CC1R0ClxxKLtMXVHCj9CNV/oEHP
	 eZ63m/ofFbazF29qHv/+vN94iiJV7OLnpp9u5nRNOCdyQp1oXi1Rxu9vyABoZ5xK7Jxtc
	 v67adkyfKwUehhY/blexDWiS09myD4Qx0V1YS5t9tP7pJlP23Gvsls9pdXIhMttkNnB+i
	 fYn3ZOiuZsXPyAMo+n48CesRs0WQhv1orDF1bSft/PDiJJNdvvSxHd6vZP+6h35FhdcSO
	 17AprwlbNwCWiR/cjtqUvdTMq0iHr347rJWZN3xUpeBstYw5CwYxUJCv0StmZquOAug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQ3is9S1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E7A606A31F;
	Wed, 28 Oct 2026 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQ3is9S1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6981F01825;
	Wed, 28 Oct 2026 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207966;
	bh=SGnR+FILBBz5papwOqQbOIimsKg0ssS0i1FvMzAZurk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQ3is9S1VcmY4tbufMSxaMQA0847qgDPwpWMpTZDB2HGZN+CiGXqOWeEw9S73Q2Xp
	 Kh/pcpmXx0lQnaNNuyENlw/kmbdbFlxkhkE5ks7iYQ9WVMkKH9E7CSaVlNiyGKwjvw
	 0f4t9oUeYe5btCp3tsjvBrt/A2YW6Th6fQOY2na4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 202/247] io_uring/poll: dont lose a cancel as io-wq arms poll
Date: Wed, 28 Oct 2026 18:00:05 +0100
Message-ID: <20261028165952.203826802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 6d2d4c2530e95ff6ddeb98195d49d99dbca14369 upstream.

A request on a pollable file that was forced to io-wq is issued without
blocking there. If that ends in -EAGAIN, io_wq_submit_work() arms poll
for it and returns. It looks at IO_WQ_WORK_CANCEL once, before it issues
the request.

Somebody who wants to cancel the request in between finds it running:

  io-wq worker                          io_try_cancel()
  io_wq_submit_work()
    IO_WQ_WORK_CANCEL isn't set
    io_issue_sqe() = -EAGAIN
                                        io_async_cancel_one()
                                          sets IO_WQ_WORK_CANCEL
                                          signals the worker
                                          = -EALREADY
                                        io_poll_cancel() = -ENOENT
                                        ...
                                        = -ENOENT
    io_arm_poll_handler() = IO_APOLL_OK
    return

Nobody looks at the flag again, and the signal doesn't matter to a
worker that doesn't sleep. The request is armed as if nothing had
happened:

 - a linked timeout completes with -ENOENT, and the request it was
   meant to limit waits for as long as it takes.
 - IORING_OP_ASYNC_CANCEL returns -EALREADY, and the request stays.
 - IORING_REGISTER_SYNC_CANCEL waits for the request to complete if it
   gets -EALREADY. Since commit 5623eb1ed035 ("io_uring/tctx: add
   separate lock for list of tctx's in ctx") it doesn't sleep but spins,
   so its next attempt finds the armed poll.

The same goes for a multishot poll, recv or accept that is armed from
io-wq.

With a read of an empty pipe, IOSQE_ASYNC, and a linked timeout of 5ms
or a cancel in the same submission, in a guest that is slow enough (TCG,
KASAN), the request is lost in 21 of 24 rounds of 40 or 100 attempts.

While it arms poll from io-wq, __io_arm_poll_handler() owns the request.
Look at the flag once the request is in the hash table. The table is
searched and the request is added with ->uring_lock held, and the flag is
set before the search. So either the search finds the request, or it
came first and the flag is seen. With the request marked as cancelled, the
task work that is queued, right away or because ownership can't be
released, fails it with -ECANCELED.

What the canceller is told doesn't change. In this window a linked timeout
still completes with -ENOENT rather than -ETIME, a cancel request with
-EALREADY, and one with IORING_ASYNC_CANCEL_ALL or _ANY with a count that
doesn't include the request. But the request is cancelled, so what is new
is a request that completes with -ECANCELED after such a result.

This doesn't help in two cases:

 - IORING_ASYNC_CANCEL_ALL and _ANY, if the work is flagged after the
   test added here, while io-wq still has it as the current work of the
   worker. io_cancel_cb() stamps it with the sequence of the cancel, so the
   search of the hash table on behalf of the same cancel takes it for
   done and skips it.
 - requests that are parked elsewhere by io-wq, like IORING_OP_FUTEX_WAIT
   and IORING_OP_WAITID. They have the same problem.

Fixes: 90fa02883f06 ("io_uring: implement async hybrid mode for pollable requests")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-14-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -656,6 +656,18 @@ static int __io_arm_poll_handler(struct
 
 	io_poll_add_hash(req);
 
+	/*
+	 * Whoever tried to cancel the request while io-wq was running it has
+	 * flagged the work item. If it searched the hash table before the
+	 * request got there it found nothing, and it won't come back. Both
+	 * the search and the insertion are done with ->uring_lock held, and
+	 * the flag is set before the search. If the search came first,
+	 * the flag is visible by now.
+	 */
+	if (ipt->owning &&
+	    (atomic_read(&req->work.flags) & IO_WQ_WORK_CANCEL))
+		io_poll_mark_cancelled(req);
+
 	if (mask && (poll->events & EPOLLET) &&
 	    io_poll_can_finish_inline(req, ipt)) {
 		__io_poll_execute(req, mask, 0);


