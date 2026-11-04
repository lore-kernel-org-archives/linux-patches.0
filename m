Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826833;
	b=2djpyEUKRE0agqPF1E1tmdftMZVoqgfFyhWcpjVeKAeoYTTzNa1dPG3+uuM/4ddCYgP2
	 S8s9Uxi/qQnZB1GHiuYNPOErNrw119inMR0IMAVbzZIiwmUYmbH7xOSJmoV6LJF8FY8Yl
	 V1WDyDhK1Fk1qUWZsSRUaO5fK+g/Km5qMR63sYYT3HbvCwPiE724nkfEhYeQOKHkiGKsm
	 6RcEXT5SgDRtKtlQZo2TLzKKBD4mWEoaOHPBQEiT90sHpEvl5elKHwjjpFRc5hXA7ok+b
	 9k7YBXMp0FNWWuCSQ4tUCW7Rt8snMkJX4q4wwIIewHZp+4mn+OGCpQsiUbPzPquuElg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M1G1NkavJepIsAakIHYcZJZrbibBrbeeA+9OqdC76I8=;
	b=ldAEtP5JoVfqdiHTcBcvdnxZMgYDAOe9QQWHFHtfvkqyBMR/DHkiVPj8sFw0RxMvi80R
	 2lNQxDpwq07ENHM6DkiwK1OJmJE+Tk5jvOVTqoUlg2hhrjZts740xf+vOnxgi8wM7DiIo
	 saGmO1jxI2Z2rdV+UPxu2GLFb7kCCNvyflbaNaBoWVKOMJ4CTaPi3PcPtNywaapsg1d0q
	 ecESP26uzvaIdZp2C4J7Aq58WjXEO/4TSSlbD8CTTwwFfFLdDM46L2DZHxX1XZKtNXL+X
	 8/Il/hLJIn1sM/FbaMbh+9XL284TCNfhK4RLUMuZ5jRpfCKkL3Lnf0jJE8p9RmOfeMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYRg0+jV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2798B6072F76;
	Wed,  4 Nov 2026 21:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYRg0+jV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB1A1F00919;
	Wed,  4 Nov 2026 21:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826832;
	bh=M1G1NkavJepIsAakIHYcZJZrbibBrbeeA+9OqdC76I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYRg0+jVAD3fi/elEGr+Vhz5beaxCCKP8Fqtu4t0P0ijgsKp635o2SBBbFkg7kpTj
	 qg7lxxbNK/rT5bSdwgYolxHH3/HMumw7rkwrkqqMtIDIDTwtEuB/7xgSPFi7L47iHT
	 eUhjm3TF56H76k0mRO8hHt0fxN04jzhC6e6sNEow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 034/547] io_uring/cancel: let CANCEL_ALL find parked requests
Date: Wed,  4 Nov 2026 16:03:38 -0500
Message-ID: <20261104211039.311081838@linuxfoundation.org>
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

[ Upstream commit fe6ca13c98b1223f6005f32913ebd32e4df64b77 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 9732002449b94..75a21ecfe69c8 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -72,7 +72,16 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
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
@@ -198,6 +207,9 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 	mutex_lock(&ctx->tctx_lock);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		/* has been done above, don't count what is running there */
+		if (all && node->task->io_uring == tctx)
+			continue;
 		ret = io_async_cancel_one(node->task->io_uring, cd);
 		if (ret != -ENOENT) {
 			if (!all)
-- 
2.53.0



