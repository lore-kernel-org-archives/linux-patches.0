Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209734;
	b=FdK6+0qzldy04pi8X0HsiL03LzNHxF/V1Jo6O5T1Zwpyk5gnjWOfNM0oDH0qedjnPiQh
	 giZwkEspJ521Fm0E3DXluY5+79zF7mp9YDAslRA9VnN6VxOhM3LFNHeNuGHM3KedbSIpQ
	 GfYLgFWU51knK5hnJkyhOB6VTz2Mr+Vkh8r01Zwn94uaJTeP0wVKmPcZzNsob3iXUyTtV
	 h3x/cEAjQdlt/Ay/efOCrJOcq1IMZ8u7Zrdz8YEXv8oq+k1IkzgiIY4OKiNRJLsklomUK
	 uzMt1SZRxFokKri25yq/fol4GsfIBXgI9LL1mj3AgFUVDJpIgUwPvNBgGcPH6yS9I1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cEsye3fpTkVJjg83pxlf94+T41TvL2BqwYNZiDQrj+M=;
	b=yXkTchhOwlCtBS9EHoMHGTlsdXUkrIOj181/hVNTH1R0oZRZJonQnUohhKDDRbH2tmab
	 aPVP3iXbUS2p35ut3rCgKJ0vzmA88XZzRjF7U86AIHx8QZjUgWeOg+6ytfnjDCL4x8IhH
	 ym3YWbYUcjZ4PpdX+zXDtMxpMxCuucXvBGrHui8Gr/qJQi9ab3n08CB+O/RP+NPlIcqTf
	 dzKeRODwcWYra2ZbNDpKA2L8FeJgQGj6jovnq9WcqTdrmbf6qG8I0oWwWSxie0MyUFJ+d
	 tHv6nHsE7zY4QlE7hNx3BbhccRFXBZfnrOA9tvHQi1BlRU/U0GldlHyiIsnKX0ov2oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=blmxyYUo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F078E606A31C;
	Wed, 28 Oct 2026 17:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=blmxyYUo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9511F01825;
	Wed, 28 Oct 2026 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209733;
	bh=cEsye3fpTkVJjg83pxlf94+T41TvL2BqwYNZiDQrj+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blmxyYUo+Qo1X3OljP/0++7ebuoG85GHyVS5/L7HerYJHyEeqGS96WZSm6kcil1GY
	 RxQok6DbmHtDHpOpkCAnMnQKxY8FeRCkfbK73EFrfkodV+I8O2OwRTfQ1pQJGeYFXu
	 o3kmYFvfPUNjLPZtyBr1Mudy5mWv3taVQuPQ3Mww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 058/109] io_uring/cancel: let CANCEL_ALL find parked requests
Date: Wed, 28 Oct 2026 18:00:42 +0100
Message-ID: <20261028165943.726247814@linuxfoundation.org>
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
@@ -73,7 +73,16 @@ static bool io_cancel_cb(struct io_wq_wo
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
@@ -190,6 +199,9 @@ static int __io_async_cancel(struct io_c
 	io_ring_submit_lock(ctx, issue_flags);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		/* has been done above, don't count what is running there */
+		if (all && node->task->io_uring == tctx)
+			continue;
 		ret = io_async_cancel_one(node->task->io_uring, cd);
 		if (ret != -ENOENT) {
 			if (!all)


