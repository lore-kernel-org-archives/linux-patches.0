Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207980;
	b=woV/F56ttMN3ea/RHtYvvnVtqqb11iLFOFB33G4wzroezI4Es6IoW2YFLFo+MnausL42
	 +RbPAFlMYwwitMOk+1qboUtkl2XpMQogCUm5DctQmjnw7aDcMBMfSVSSA9cZ/c9sXMey9
	 EI+Bxk78L1ywTZcar6rSskBL+pkI0hIC9God1o4+VLLqpS7LJDoy/xdV73ptOHaGxXG1O
	 gAe0rFqvt3StoOGsXw1fmemxM3WiCMVHCWviTonCA3zlHiMKDGmjo1DFRO2+uQLjyPAFV
	 OUxYe/OQmYh7FBE6fYOdAFm5ZOVSKYzgu5weyu19CgCBtKvvhvUmocMW5QcUZbib4/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APl2yUgj4anKBVgG5PefclvUxR97/mShdHUVAt9rzqA=;
	b=Iqssy6bppLdZgokaQeuFjYHesiOIdLbW5jjGm3FAqk+SIQjF7OiPDs783AnaKZQ7u7ld
	 cqDitvhrKPv/ZUFz4OokXm7Kp6IRp4+gtjziLCIL0DV5KNahCrRe3i0BA8pa7v02RKn0Q
	 K8rpjoLOnvFFlo6D6gIJ9iX5mBWfuZu1sIwE/M4/LvGxZgD+t9sX1P6J3cWOFQtWYKa2Z
	 xK5z11tVcVc1lKg0FpXGaquUIDbKd3v/SFQejvHVdg2688jBxjAf9yjkn4TY5G2/axw9I
	 crAT+8ZANH8bYaa4/XPIVAGmOl6g9W8cqs/tBCeBJsba226tdPcsbXIEuwIryBY69CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=REFzaJ7F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920B3606A320;
	Wed, 28 Oct 2026 17:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=REFzaJ7F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB3F1F031E1;
	Wed, 28 Oct 2026 17:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207980;
	bh=APl2yUgj4anKBVgG5PefclvUxR97/mShdHUVAt9rzqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REFzaJ7FFNpQtDH96k46lNwrgSmEjZ2h2mD5qEkJWapH2uo5M834fPNHGAXFLXGi2
	 33OwCzI7LYqYJQSR3SC8rT0xbGTdgTTovZlMZo07r1s//98KWmKb7v2dv9sk+FQTjP
	 ysKuZk70Kr+P8P4tOKSzACSPseBKPnBE3hk8ajrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 206/247] io_uring/cancel: let CANCEL_ALL find parked requests
Date: Wed, 28 Oct 2026 18:00:09 +0100
Message-ID: <20261028165952.298589117@linuxfoundation.org>
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

Commit fe6ca13c98b1223f6005f32913ebd32e4df64b77 upstream.

A cancellation with IORING_ASYNC_CANCEL_ALL or _ANY goes on until it finds
nothing more. A request may stay where it was found for a while after it
has been cancelled, so each one that matches is stamped with the sequence
number of the cancellation, and is skipped from then on.

io_cancel_cb() does so for io-wq work as well. There is no need to:
pending work is taken off the list, and the workers are looked at once per
call. And it does harm. A request that is run by io-wq may be parked
while it still is the current work of the worker: poll gets armed for it,
or it is put on ->futex_list or ->waitid_list.

  io-wq worker                       io_try_cancel()
  io_wq_submit_work()
    io_arm_poll_handler()
      io_poll_add_hash()
                                       io_async_cancel_one()
                                         io_cancel_cb()
                                           stamps the request
                                         sets IO_WQ_WORK_CANCEL
                                         = -EALREADY
                                       io_poll_cancel()
                                         skips the request
                                       = -ENOENT
  io_assign_current_work(NULL)

The flag comes too late for the worker to see it, and the search that
would have found the request takes it for done. The cancellation returns,
and the request stays.

With a multishot poll, IOSQE_ASYNC, and IORING_OP_ASYNC_CANCEL with
IORING_ASYNC_CANCEL_ALL up to 63us later, that happens to 4 of 1,000
requests (4 CPUs, KVM).

Take the stamp off again if the work matches. If the request is found
on one of the lists it gets a new one, and io_cancel_cb() doesn't match it
a second time.

__io_async_cancel() tries the io-wq of the caller twice. So far the stamp
has kept it from counting work that is running there the second time.
Skip it instead, so that the number that is returned stays the same.

Fixes: 8e29da69fead ("io_uring: add support for IORING_ASYNC_CANCEL_ALL")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-18-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -70,7 +70,16 @@ static bool io_cancel_cb(struct io_wq_wo
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_cancel_data *cd = data;
 
-	return io_cancel_req_match(req, cd);
+	if (!io_cancel_req_match(req, cd))
+		return false;
+	/*
+	 * Pending work is gone once it has matched. Work that is running may
+	 * park the request where the same cancellation looks next. Don't make
+	 * it skip the request as one that it has dealt with.
+	 */
+	if (cd->flags & (IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_ANY))
+		req->cancel_seq_set = false;
+	return true;
 }
 
 static int io_async_cancel_one(struct io_uring_task *tctx,
@@ -187,6 +196,9 @@ static int __io_async_cancel(struct io_c
 	io_ring_submit_lock(ctx, issue_flags);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		/* has been done above, don't count what is running there */
+		if (all && node->task->io_uring == tctx)
+			continue;
 		ret = io_async_cancel_one(node->task->io_uring, cd);
 		if (ret != -ENOENT) {
 			if (!all)


