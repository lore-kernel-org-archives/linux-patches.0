Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826878;
	b=vPZRR5uGQ4tdBzVkQ8lgMJITc0y8ouUGVgKXwvXUbHMQtTcAejgAyuGhWfDgDCaPrDQN
	 O7zWe0OKzQO1FR29fs2/7ZsHqe2RRnB8t0DA4iePBo5g+XNJx0Kphyto8lcKOR2gf+D3q
	 /58KAa8ehwk98/TBW5YHOejoWm5OXO6pW2uGOm4G/xHKqtR7RkocZbdTa8rYQWd7MbHXW
	 xtuUeNE6MmoQMsDbuimvWV6Ianm3k6ImuqZplO5mDFYrtg497FmyDso0hhlEyXcS/ODT4
	 EW0n1zv0IUyO0IVX2oxufPL2prcpwfyPu5Ej8G38eF905wE0Tz5ckWNuFS+5i8P8QAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SbpA1jxHS8L6WDT5LaMOH9oUx0zha4h7ALiuBHOzXJc=;
	b=IkrpYiHExTAwlootIwT3yNq6pQXcqrETqc4SDL5SMivC0nbrftE+kd4Moc9CUwCFaAvk
	 mcxCgatMGPaaWKaizjvB166WzmeCSVEDeQP32U7HYXv/y07nvvQWJBxUCK87uk8/BTjrt
	 ne+3r1n551KNzko1k3hZNgwAxIcC0DreYt1lyCqK7CNizc266Ky2/KwQM0FUI6Iy2Yckz
	 klZ119HVHpErRSm93aOEVYVbL/T0dUeHXI2uUoYZ6FAwUoAkTK+MH5+C0/yJyakZZeb0N
	 Q/9GfyRodWOFOTUCpETx8EnWVgOQ4/JiPfqMZefvPXYXvJjfGmINIoefLKQqQfTFNgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tillmXJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D7A60B3338;
	Wed,  4 Nov 2026 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tillmXJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119F81F00919;
	Wed,  4 Nov 2026 21:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826878;
	bh=SbpA1jxHS8L6WDT5LaMOH9oUx0zha4h7ALiuBHOzXJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tillmXJZlljVy9RjbJws4eoyF/3zD+y0M3iVHP6fAPNKn+EibjCz0B4Kc86Chu/pn
	 deLhUmlXMLkG9ORHja9AqAQP1ExS4sodgeI4Z++bWQnAF1vTpHBUvyrtFVjSVoSQBU
	 AJq7divmBqkXjw6ppLFZkfdJi5/rSu7xsBXxj27A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 061/547] io_uring/timeout: dont flush with the sequence behind the last flush
Date: Wed,  4 Nov 2026 16:04:05 -0500
Message-ID: <20261104211040.013259251@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 85f85d573ffa7772e1ad4504d0cec5113a5c5cf1 ]

io_flush_timeouts() measures the events since the last flush as the
distance of the current sequence from ->cq_last_tm_flush. A fired
timeout bumps ->cq_timeouts before its CQE is posted, so until it is
the sequence can be behind the last flush, and the distance wraps:

  last flush: seq 100, cq_last_tm_flush = 100
  Y: IORING_OP_TIMEOUT, off 50, target_seq 150
  pure timeout A fires, cq_timeouts = 1
  task_work posts A's CQE, cached_cq_tail = 101
  pure timeout B fires before the flush, cq_timeouts = 2
  io_flush_timeouts(): seq = 99, events_got = 0xffffffff

Y, and every sequence timeout behind it, is ended with -ETIME although
no event happened. Two timeouts expiring close together is all it takes,
a completion with IOSQE_CQE_SKIP_SUCCESS after a single one does it too.

Nothing but those in flight CQEs separates the two, so count from the
last flush when the sequence is behind it, as io_timeout() does.

Fixes: f010505b78a4 ("io_uring: flush timeouts that should already have expired")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 05e6c07c98b53..0eb0e64e3081b 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -171,6 +171,14 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	raw_spin_lock_irq(&ctx->timeout_lock);
 	seq = READ_ONCE(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 
+	/*
+	 * A fired timeout bumps ->cq_timeouts before its CQE is posted, which
+	 * leaves the sequence behind the last flush until it is. No event has
+	 * happened then, see io_timeout().
+	 */
+	if ((s32)(seq - ctx->cq_last_tm_flush) < 0)
+		seq = ctx->cq_last_tm_flush;
+
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 		u32 events_needed, events_got;
-- 
2.53.0



