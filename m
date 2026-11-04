Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826824;
	b=5g3b9+mv62fMtA4NpK5zmcZKkklHN825+iFbN1GOV3CkzsW9BNpM0Pti0hS0HUrORVEp
	 0KZwW+oPGURUKKlyYREH+tcD+mLMdhZoVLDhb8nuAmTmODDWiwuDXpiq2L31vfiq4vwhR
	 zCXeVYXV2foFHZL54FlkooiS5Oj7hl7czIB+uJx7s0xcAlxlKKgyCHHE1uzHRpdnr3mx/
	 q1NFq7FhaCC09tRDAflfOaJNSjAZMZJQMfF2UYouQXi8d9fuf/5dMh1wM7Vg2M6oPCsot
	 0GMoubWosxGavna3qiQOAhqunwBVC9aGeSbnEZv3hiKtwr7NfV7ontj05ARb/Yz/9yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qpdCzdYvJQgUeURl861a1UdfXkAzIcsWIrDoKpJ99Xs=;
	b=YJfB3pklQQVJ9YXaWuH76RwoTj/uG1pZQKcsfRD9ca8nRQcdz2hQXJfv2po6eQENfOZS
	 f0IHg1cnh6Wxj9mzosUCXLD5zu794oLf9jhD4B/6z+u0Fwn/1GOgSabSuxWnuF+oQkoLy
	 y/xLpFaNuuSMqGEkGWT/tVeZ7NMPSqeKRArJcOSj7rZtrEMjABbjyZa39KCLNzN/6ICxF
	 95CpKutXXtPvtRWJTmkvpPodTrT7rNNNYnLAtOk52ZxJhuuTQ1ynbcryRxTa20d4H9YTw
	 GrFV/uRiCxlJv8nLIxedr4lES8Dl2QpKPsHfST/Xsz49CERMTFC8EOn0k1+KVFYIDkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fCbHGp/+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6687060A3AAF;
	Wed,  4 Nov 2026 21:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fCbHGp/+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0297D1F00A02;
	Wed,  4 Nov 2026 21:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826824;
	bh=qpdCzdYvJQgUeURl861a1UdfXkAzIcsWIrDoKpJ99Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCbHGp/+18lxKTVK0MJl+D/5K37fshqFqtUl44NaI0KMah4PyUf4SA5cV/Nq16IJH
	 cgjfdrqO/WtS2WykeGv66eNLFv64rMWqlQIrfpXFIlSMYdnX5g3lbAgN6sk4O4V+Tw
	 CDPve1cHGIb2Lyv/J1KZGIGxNnDqVzZ923LN2eTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 030/547] io_uring/poll: dont lose a cancel as io-wq arms poll
Date: Wed,  4 Nov 2026 16:03:34 -0500
Message-ID: <20261104211039.205196147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 6d2d4c2530e95ff6ddeb98195d49d99dbca14369 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0ad9c00efdea9..3e443b187eae0 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -626,6 +626,18 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	io_poll_add_hash(req, issue_flags);
 
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
-- 
2.53.0



