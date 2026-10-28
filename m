Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207213;
	b=ukcgH2EkRFdkRIvyUup0PSwS6YpJjEpOQ77wzhPBb85rSIlxfzTXOYo/uX9iUyV84XCB
	 1iSe9YjUTYKkmYqlWUbB+o6Jq0AanzaKvJZ8js914YEgqawJkSVIxoFPF6BsUO7bC3LQc
	 uHrdC7hD+hAGSmVDBrmkC+ze0Yn9uIjGuDF7t6FdO1Gkfru9vAT7ihnHy93ZVAIHDXdRK
	 fuVILuv2I2c4EnriU4IZdkL04wTBwQ5GcgA42qKmaTilGTzCv0Kt+t/jvaM3jEu8aCJeQ
	 Y5+ECz35glhej4K+wcdx0F4jE+l2YURNDga3sS1cHFt5JE7FQCG+1BByLyolRyDdVPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FjULzLg1OkDfM7owT5+tzgtrG0bOOJecnMb87OE8c2E=;
	b=VmyW4XF60I+zsp1Kz3rlN4TTk+rAscCm446R4Cx6t4ANpBggsMSu1vjviV9fIaFGhdud
	 TWtvL8F0PLKbauGWzuhr3xoHVLhlfaTRs8KXgurbVSZgciwv3Bz0+v2NhBf7phpdj1vYX
	 XS0EqEO8BK1r9QfSPHhp+XnR/fJ0K++GVMLwJNi/TNXJi97qX8rpHpLA8/ByBD5JNeFdu
	 0Sskn2YepENSZVI1MG5zyeSNeobTE/lROS6kEVduc/FcATjEbCWDbr/camFAkxWFhi4fV
	 YKQtrbrVdS/TxH2d/LrviXLqHHDz6gtE6oOY+bGKp0H+K8KGayA8JVGVlJJXFDi9DxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QgamOsDN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DD7606A322;
	Wed, 28 Oct 2026 17:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QgamOsDN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2455E1F031E1;
	Wed, 28 Oct 2026 17:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207212;
	bh=FjULzLg1OkDfM7owT5+tzgtrG0bOOJecnMb87OE8c2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgamOsDNzsASrBwRLmYLfAJKnpDvFsbW214cGq0OFDdJhDko6Tr4RvlCEEzEwNO7g
	 1gFzjFAF37WboHcDX8vfTOrJcoUwUO8X6XaLRuQY6v/YEfj45seMiWVxzuio04u+fZ
	 fHBfouyl9BuEKtjgN9d+5uoyZ5dPFpByjavcktlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 19/88] io_uring/wait: dont spin on a stuck overflow list
Date: Wed, 28 Oct 2026 17:59:27 +0100
Message-ID: <20261028165942.569304368@linuxfoundation.org>
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

Fixes: 3fcf19d592d5 ("io_uring: parse check_cq out of wq waiting")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-3-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/wait.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -291,9 +291,18 @@ int io_cqring_wait(struct io_ring_ctx *c
 
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


