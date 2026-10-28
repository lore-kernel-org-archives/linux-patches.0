Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210247;
	b=4JVSfwFF/ewEzSvkxe9s9HS9TvitkiNT5e2YT4zpFK/vzi4sAkvGVq9L55uzCvritvu3
	 g1QASV0whTSvAG5D7nyz21qJHztnnBQN11C/8sBiNuctJdMEtf2Uba97OxH83yaxGp7hd
	 JBEeAEZPTyk8IyXcIRG19UowSdy9YQP2L6eTqkZq4HDdQk/QAt3vphMkqXgdSsG3gCBIo
	 80dAWWme8aQ/Gkje6IcgykCInd2QO7qpd0kRicTw00K9GfbZlSqi1bUDDfM+6dq3eap/o
	 VI9R4uL8ptXjd2RdDJs8ne812Z74aUob/EJwWDCBBCG8kg6Z4oN+GBkANcJPnETQZ2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YHmdIjTch5rc/5ZmJT6D8UIr0TrN+e4q/9xfr0xehQ0=;
	b=p85w9CxTZ0VtOp5JhBlLu3xcLI2KKB5MW47W28XEDlBskxXUHQL7Tr2KR6aShvBfWwhW
	 UBqwr9LQrZgpl1EJCHVe1GoFdx3CrZjl67iSlmsudkc5zs/YducFrYRmCIUCwUOs/0rce
	 aoypF7w+/zt2Qep8YuFLHGUAZaCeoCVDnhUJpkiP7YgI6+QdVItT0UzP9kdgOPf5CbPME
	 gzQaLymMTdSFL66dKfDaFoks9/Oee9gp/R3Y955JaDRYJbHhOFN6NEvlXPzr6Rp53YGEL
	 TOOv5zAlzSyQ8j2AoQ8haC4OmPQsnRImXkX4IhPRSztoaswO8CC9RV1PN992VnaAI1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKa2YksO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573EC606A324;
	Wed, 28 Oct 2026 17:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKa2YksO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639E91F031E2;
	Wed, 28 Oct 2026 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210246;
	bh=YHmdIjTch5rc/5ZmJT6D8UIr0TrN+e4q/9xfr0xehQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKa2YksObRsXTkd4uOTzQJE+bTggdNpKfW30PbNx/Cz1PFFcj4fCmfTGiyQzD0Oth
	 MW8/ZyQunrWLJLFoEuiLEfO076SXTOOEtIxhqkyzzrJw3kBK+jItg8lqq+K31Bnx0W
	 xk+2591O3LpmMuaPTr4te2nVk1JF4zxLRVnXBvZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 127/168] io_uring/wait: dont spin on a stuck overflow list
Date: Wed, 28 Oct 2026 18:01:03 +0100
Message-ID: <20261028165946.092166772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ 6.6: io_cqring_wait() lives in io_uring/io_uring.c ]
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
@@ -2641,9 +2641,18 @@ static int io_cqring_wait(struct io_ring
 
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


