Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207232;
	b=Cp3dPWA/iX63uMrQhO+E2i0LY/ivOePCO7oMT1WXQ437IpWEvDmGEfBtOXY473x2YE+q
	 fp/+fPQf36XR5rmL+DUcOB93zdGCyjYFco0EMIyIPpBB8i1lIj2lRhJvTSTkPGkTH6nsf
	 QM6I04pxGuleI4gyLMo39okg9e4jgvqtAqUbXBhQ7PgDCQfAQebMCwyaOC5TduW3xYsfV
	 V9OAesn1fJKXgN4YIMCJLgczNXCDww7y1PiTkrb3QT5rjJimwzBpj8Hr4GO/1Wpk2SVOm
	 NHohJ5ZGzXTdOLNk6HWAaS0UMKPnGdUFA6NgoSK+PooLSM5ykuWaxmJGFn2knmusSIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lFFsLHbLO7efjxewXXpoP6ImJ+4Fd9arGeWT1QUCPzU=;
	b=i7k1pg5mQQdVnNLR/ljqoY//rHZCJZAK3XpjXnPR29n8K85y/DBG8M0tfU3F/JkZjJWb
	 kd/RTVJo/OyzmL50yj6dynEd22d/DArDdD4zO7V6C1Kn+OzThVrp5I75bEJ6G6URcKpPh
	 glmAL8U5a+NFOpvSD0dNhBmgZuiEBjfgepyk4qwA75xZwrlJdkyA8jzLBQt859z6YmJFl
	 bwz/XXyrsYI/kvGUNsdHvZwJ5jRvQV9btzmyJdxND33oxw14V7WYEkEdLfprJ5p6Fv7/Q
	 GiOx9HPdYUMRmyAHCsy5qUm6Mu6muMmX00Ddpo946fMwjgaBAefvfVgqTONA0VGT4hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a2ETeEq/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AAE606A31C;
	Wed, 28 Oct 2026 17:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2ETeEq/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5CC1F01825;
	Wed, 28 Oct 2026 17:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207232;
	bh=lFFsLHbLO7efjxewXXpoP6ImJ+4Fd9arGeWT1QUCPzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2ETeEq/A4DPMGMsZGOvNNhvk3nROBSw4sD53ly4TFbUkQNOZ8ZaJIhk75qKTJa1w
	 MKOfFZcrcnBXF0jJsgCPTPRhAzOwF7Y6gJRFXjWORf/3QmFl3hB9R/3J9Xmy0e7miu
	 tRI6Y4y6N0rgZ7obHk91qvh1o8dOP4d2EQIwJegc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 34/88] io_uring/cancel: let CANCEL_ALL find parked requests
Date: Wed, 28 Oct 2026 17:59:42 +0100
Message-ID: <20261028165942.916735343@linuxfoundation.org>
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
@@ -72,7 +72,16 @@ static bool io_cancel_cb(struct io_wq_wo
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
@@ -198,6 +207,9 @@ static int __io_async_cancel(struct io_c
 	mutex_lock(&ctx->tctx_lock);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		/* has been done above, don't count what is running there */
+		if (all && node->task->io_uring == tctx)
+			continue;
 		ret = io_async_cancel_one(node->task->io_uring, cd);
 		if (ret != -ENOENT) {
 			if (!all)


