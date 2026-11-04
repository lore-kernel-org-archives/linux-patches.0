Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826867;
	b=gawkhsGFJr1+495nD9oyVfgY303hl4mkf9pnh1CIJ6+iSvJSEaIhNhBhDbPIutgB6F+c
	 Ww4a1/AynUi9lOLSZn1CFrN7KL1dKBuKyKIWxYPhuc1a+zkgZnXc41/Qlo4I0LeyqNCV/
	 g8mLKsLRrEPDq8H6JFuCcUAij0lWBQP4tPUu3daifaRUoiUy1xSbOXwxWrqfREgHj6UDt
	 Y9a96uUlFcvWyLeLbCIaGyA0dzH0b0lfIootC2yVraqDqqjexgLIVAtDgar+se6FPUjjM
	 pawNQy/p5akURi0KuiVCIu9erNzck7Q6RlEnvQbjygertqY4kJ0dsJ+J6cS8rzGumAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cj7XGRaMRKDaRglhTB/1rzFGMY9clMpehI+qA5y2BBc=;
	b=ZJo6CcVoR1GBBjpuqxaOgpCIrE0nEYDzsT0q1Abj1f00BLhsKJbT2hpkLDulXKFwiTfA
	 /xXiFppSRL7MkKTgSn0blVOeWYVoz3/e0FwtuBrU+7pPcpw6/bOFV0srw9TNzEHDOP/vW
	 hLmvuQMLwKBX8KHnizgxbCzbSGOeQtLa26+GRtxcA429TGWyrEk9zCGsTP/L7fTsjONnB
	 rwBr/c3waKAJB8xDavFwuR9fGwrWmY/FKlL5obE/am+BEoDyDCCgnARWdnhJSXCwCcXB0
	 LwyzDt4mlcypfMUxfz/KtJxUxZKIsySUVKJU4TgdjaPj3JsLH5HrEodgtj7fkbEa7Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbvFNvSA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33918607E4BA;
	Wed,  4 Nov 2026 21:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbvFNvSA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F1C1F000C1;
	Wed,  4 Nov 2026 21:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826867;
	bh=cj7XGRaMRKDaRglhTB/1rzFGMY9clMpehI+qA5y2BBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbvFNvSASeKQCb28SuGYTwuXp9C6jNp0/L/9B03+NM4ilsFJn7sGopMMgbeZIlvQh
	 wklE5IqkhQAI7od/+hBnLNZO2mUvxytUssnQeAyZ+hZX8we9RYmFzqqLkHAv9N2pdH
	 ecQH7F5iT/yWZp8XgbWwP4jz/45CC+ofEl1As2oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 019/547] io_uring/wait: dont spin on a stuck overflow list
Date: Wed,  4 Nov 2026 16:03:23 -0500
Message-ID: <20261104211038.915819553@linuxfoundation.org>
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

[ Upstream commit 34f5a664c34d3cb62f6bec7f4156754594a7d25b ]

As long as IO_CHECK_CQ_OVERFLOW_BIT is set, io_cqring_wait_schedule()
returns right away, before it gets to look at signals or arms the timeout,
for io_cqring_wait() to flush the overflow list. If that doesn't empty the
list, and the CQ ring doesn't hold the number of events the caller wants,
the loop starts over, with the same result. The task spins in the kernel,
and can't be killed.

The assumption is that this can't happen: if CQEs can't be flushed, the
ring is full, and min_events is capped to the size of the ring. But:

- With IORING_SETUP_CQE_MIXED a 32b CQE needs two contiguous entries. It
  is stuck on the list if a single one is free, and then the ring holds
  less than cq_entries events. A single threaded application that asks
  for as many events as the ring has entries never gets out of
  io_uring_enter().

- Whether the ring is full is up to the CQ head, which the application
  can write to. While one thread waits for events on an empty ring,
  another one can move the head back so that the ring looks full and
  have a CQE overflow. The waiter can't be stopped any more, not even by
  SIGKILL.

Only the application can make room in the CQ ring. Return to it if the
list could not be flushed.

Fixes: 3fcf19d592d5 ("io_uring: parse check_cq out of wq waiting")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-3-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/wait.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/io_uring/wait.c b/io_uring/wait.c
index 8fc175f10c545..967be6ee12762 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -301,9 +301,18 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 		check_cq = READ_ONCE(ctx->check_cq);
 		if (unlikely(check_cq)) {
-			/* let the caller flush overflows, retry */
-			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
+			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)) {
 				io_cqring_do_overflow_flush(ctx);
+				/*
+				 * No room for what has overflown. It takes the
+				 * application to change that, so return to it.
+				 */
+				if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT,
+					     &ctx->check_cq)) {
+					ret = 0;
+					break;
+				}
+			}
 			if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)) {
 				ret = -EBADR;
 				break;
-- 
2.53.0



