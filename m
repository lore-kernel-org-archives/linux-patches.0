Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624085;
	b=DVN9TFLTbLYlCdi2WkDECSyQpEhmui0ewRcc6Gqv65Z6S5IV8pXa+lYSLelevh/wz8pQ
	 5PYqdHjRv0EKuMcuaV1N3Fd39OZqNosXurzTez9cYf86SRhSqcA90J0c9eRZfy03iNwoc
	 u016TEdRBNCsM6USzvyg3hPUNH3+DW21gT9ub5A9bCHnYNV21SL6LXxiAYQ0gbLVcub7E
	 vtyAlfzvL8eve7Iwj54Y5cB6iH35+aYDNzs1Km8ieTc/8/j/h0BnuknXES09jATiPwc66
	 yIlNKxb8b6TTfDFYs+GwQhjPu7e5ZTPDMLXWT+SQEbksIiEx88vqsHjR8YPWU74awpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K/e1XsPU+lNbrUcTJ38LNZfiaaQcXvhBbHVT1CRRwqY=;
	b=cHb5si0PNdKMHsx9TRMGYhZOX3OxyuUnsD2FWu0GNoe7cJ5+7zHPG1l9TK37+IAagBqq
	 oJd1VRB1qvvl6o2AlwJOr4oURVPWVmLV28YVqwFY/pxXb7j1G7Wi5T98ehfXjh6e0aK1F
	 T0NvS4W4gYun5A5cG8m1O03n90b8jAp1THdU+VXk1QnOMjZC03cHm7GPiTdf6Gu3gIdd2
	 Qp/L8KciYJwG358tr1gZZzBCcQPgaNhb15yTWNKhg5fc8NUyujV01VCAkLwpsaRnijsFc
	 XQ/n8eYvqZ7qNF+TtqLmH0c8dw400ZVcXOYYysJoDbkM3CXxBKMFStoyAq5xWa/RSbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FmlKWsJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5EC606A329;
	Wed, 25 Nov 2026 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmlKWsJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036841F000D1;
	Wed, 25 Nov 2026 16:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624085;
	bh=K/e1XsPU+lNbrUcTJ38LNZfiaaQcXvhBbHVT1CRRwqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmlKWsJ/wKgT6wL1OHpj4UCit74rL6iZIwPWl452u3P4hUCUmqnFV2TJ00dUcX2FZ
	 iarrT8WofyZY0tTggGGdidHLM9cRUhQdjPmHseVLPZKKin3Ulhd6Fe1V7V7CLvkulU
	 Qq5kbO+BavNuSK8UsLRPVdnxMDGHrFSEFg6fT02E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/816] io_uring/timeout: dont rearm a multishot timeout on cancel
Date: Wed, 25 Nov 2026 15:26:24 +0100
Message-ID: <20261125143850.056859513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

Commit 97d4a585db2b91d855f957be0a9f126068c5be93 upstream.

io_timeout_complete() does not check tw.cancel. When it runs from
io_cancel_local_task_work(), a multishot timeout that has not reached
its count still posts an IORING_CQE_F_MORE completion and rearms its
timer. With a zero interval the timer expires again right away and
queues new task work, so the drain keeps running it until posting a
CQE fails.

Normally the CQ fills up quickly and the request then completes. But
if userspace moves the CQ head far ahead of the tail, for example to
cq.tail + 0x7fffffff, posting keeps succeeding and ring teardown is
delayed for a long time.

Don't post another CQE or rearm the timer when tw.cancel is set, so
the request completes through io_req_task_complete(), like the poll and
linked timeout task work does when cancelled.

Fixes: ea97f6c8558e ("io_uring: add support for multishot timeouts")
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/20261116044519.281756-1-teel4res@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.12 has no tw.cancel, use io_should_terminate_tw() like
io_req_task_link_timeout() does]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index d71b0fdbb0663..e99709c4089db 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -72,7 +72,8 @@ static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!io_timeout_finish(timeout, data)) {
-		if (io_req_post_cqe(req, -ETIME, IORING_CQE_F_MORE)) {
+		if (!io_should_terminate_tw(ctx) &&
+		    io_req_post_cqe(req, -ETIME, IORING_CQE_F_MORE)) {
 			/* re-arm timer */
 			spin_lock_irq(&ctx->timeout_lock);
 			list_add(&timeout->list, ctx->timeout_list.prev);
-- 
2.53.0



