Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207946;
	b=V2cKW5KaoKklGpuhRBRqlz3odEbuLSq3/PKmf2MMvymb4AjtjmdbJMp7AiFfo4pw7YPL
	 DISqdzDhM1IZa7rKF/RsvwVSFA5YWuZ/LSWWEawu781B0V6VJ2i2Byr2wAMKdsxId5dU5
	 tDfFOh/BcpqilEoP6hNMudwOIunrQ+KvxZ381dyugQFJrey8ocynMv6dbyQ0YI8p4mqbv
	 sIfNjfKOu1lKWayV3ZTg7PjUdWkLjfW2j7QzyK0YzvgSn4VzaetaaxeKrjVo7nrKtGy7S
	 7pYByqxAuROIpMwrrQvI8pwaF8OkfIXP7qT1av5U7nvC4QaqkhfXH0Krv7oWuQ7ntdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jfo1Azg0nB3TyupyhDPVg+r1F9tr5tn0e31sJiDLdyA=;
	b=Bofd+FL5H6DAKBBUJbsqvlHbfesqbVx4gGRiIg/TQyBHiMxOi+MRMwtvyP8NFvjZvz1z
	 IQ9Brlv+fGnqOJFYsau+3JqzCkSzR1wzDrNrL567npw2igeNHWFBj4wYPC/Cu/mJEso+Y
	 9AaTSVa1YeMiFk3pt3SvwDeC+fY4Qa7o7hFDsA/YilUJdPZTEviP6zlDAxDoOZ851/8z3
	 I21bxWQnVpTehbO4nFh+LRatJFBk4pjtIDwua8DwnaLQE4KztzGuHT5/ryvcLAm8e5/Gv
	 OMTonI6WrfGWFx07F/NIfr9P4R7xUJKemdnxbK93ry8BiveSIhgZXF01AWPuOHXreSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC2anByZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F303606A326;
	Wed, 28 Oct 2026 17:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC2anByZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00261F01829;
	Wed, 28 Oct 2026 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207946;
	bh=Jfo1Azg0nB3TyupyhDPVg+r1F9tr5tn0e31sJiDLdyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hC2anByZW1och8KUfGDxa1MBM+pmCgYlliAX29I8+OQJEiK8sp8d2dDQ82y5YlV4r
	 j7aM1qmKqDVzXcOjgIjIv07+vUMML9dCCZF6vismYdKE5uYksOeIaadp7m6ffjojX5
	 y4Hu+gpjB2L5s04nvBMUhFvNO0+oqp6B9qnsA/8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.12 195/247] io_uring/wait: dont spin on a stuck overflow list
Date: Wed, 28 Oct 2026 17:59:58 +0100
Message-ID: <20261028165952.035500050@linuxfoundation.org>
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

Commit 34f5a664c34d3cb62f6bec7f4156754594a7d25b upstream.

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

[ 6.12: io_cqring_wait() is in io_uring.c ]
Fixes: 3fcf19d592d5 ("io_uring: parse check_cq out of wq waiting")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-3-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2608,9 +2608,18 @@ static int io_cqring_wait(struct io_ring
 
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


