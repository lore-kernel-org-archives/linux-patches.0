Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826853;
	b=mwMxcj12s65GR/WHAG6+pIZKhhjfM63Ko8VKFKsMTzTs+Kdn3ZdNNhmEVeBtswz6e3y+
	 kbSx4+cqcGQsWTDqWh1vCtmrXu5DxIrVbCu0sMnFLgorpXqZthpfHbNCLKGelYjE/WZkC
	 neSyyCoK7qn/a+3ko2f+It30XjOstyUTvhHnQbONSHUJpCO5U9309sq4lkc4XGbbfP+8r
	 +2HwesFirDecKLPOaatU+mkhA8mkCjbYeezbroaFNo1x4xObcnyLPAxMwwPSE44FiY35I
	 eHuJ4cth3fiDicw0l0ZY8kXOAwMWOT7ndZcuKIg+nY5eQJe1gddPOPIQOjehFTITrEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IRVXp6GGEAty8elTCZgmufjrZbL4ZdMA/7MdvKtkCLY=;
	b=ErpV8oGfJIVDgxXMhLuctPNP8a9fxmpQiCutTNAYrsmBkrihLf3LJiBZC792SO5kf56v
	 C8SzbnQMwmi5VEwlDI7IAIEPQO3P3jbj3ab//YU6427bIFa2CTCwbHLu7fu9w3+3WKpWh
	 T/vpmCsfrZ8SiU5P4GYxorPOMEtH81vjpHXDfPh2TiVhmF+QWM3YeN30J1R0J0GwKoLfm
	 imuu72OCv0ndqcOE+1CsV8sQv3qTHGdflw2zyu9csnoy6j/JBOyL7WFEp8ztrdrl0CEJy
	 oIfm+WDYuGm43exGheKTtump2zsiquKf9pSN7RU2l0p7AJrcZ/VkL7sFHFVjnPJl2YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ek45PpA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C554607E132;
	Wed,  4 Nov 2026 21:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ek45PpA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CB11F00A15;
	Wed,  4 Nov 2026 21:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826852;
	bh=IRVXp6GGEAty8elTCZgmufjrZbL4ZdMA/7MdvKtkCLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ek45PpAqFByEVwWjiyIjQ7gvYnt2zEZK+gaH6NcmQvnRNAaHclDrnGzyxxcGepqR
	 6dTwQJTnH2MLYpopv2iFW2MMUb00cUSn7Y5XJ8YyqoHJqVueab+AqQVNiIQEL8Ghpg
	 zEw4exdG4dG0YYp+HCMucp1j0Eb5r0kGiVv6t9N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 045/547] io_uring/timeout: dont skip over reached sequences
Date: Wed,  4 Nov 2026 16:03:49 -0500
Message-ID: <20261104211039.597722280@linuxfoundation.org>
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

[ Upstream commit c6c0b3eba88c3b13ca11ea112404982e86d58f7a ]

io_flush_timeouts() copes with the wrap of the CQ sequence by looking at
the distance from ->cq_last_tm_flush. That relies on the target of each
pending timeout being at or ahead of the last flush.

io_timeout() breaks that. It sets ->cq_last_tm_flush to the current
sequence, on the assumption that nothing has been posted since the last
flush. That isn't true. A multishot request posts its CQEs right when it
is issued or retried, but they are committed, and the timeouts flushed,
at the end of the submission or task_work run:

  X: IORING_OP_TIMEOUT, off == 1       target_seq == N + 1
  io_submit_sqes()
    multishot recv, posts two CQEs     sequence == N + 2
    Y: IORING_OP_TIMEOUT, off == 100   ->cq_last_tm_flush = N + 2
  io_flush_timeouts()
    X: events_needed = N + 1 - (N + 2) // 0xffffffff
       events_got = 0                  // not yet

X isn't completed although the completions it was waiting for have
happened, only its timer can end it now. And as the list is sorted and
the walk ends at the first timeout that isn't due, it gets in the way of
the ones behind it. The insertion sort has the same problem, it measures
the distance of the pending targets from the current sequence.

->cq_last_tm_flush only needs to be brought up to date if no timeout is
waiting for a sequence, as io_flush_timeouts() isn't called before the
first one is set up. Otherwise it is current enough. Timeouts with a
sequence come first in the list, so looking at the first entry will do.
Use the last flush as the base for the insertion sort as well.

Fixes: f010505b78a4 ("io_uring: flush timeouts that should already have expired")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-29-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index c4dd26cf342da..fbf0ba1ba7f9f 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -645,8 +645,9 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data = req->async_data;
+	struct io_timeout *first;
 	struct list_head *entry;
-	u32 tail, off = timeout->off;
+	u32 tail, base, off = timeout->off;
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
 
@@ -663,11 +664,17 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 	timeout->target_seq = tail + off;
 
-	/* Update the last seq here in case io_flush_timeouts() hasn't.
-	 * This is safe because ->completion_lock is held, and submissions
-	 * and completions are never mixed in the same ->completion_lock section.
+	/*
+	 * Update the last seq here in case io_flush_timeouts() hasn't, it only
+	 * gets called once sequences are in use. Leave it alone if there are
+	 * timeouts waiting for one. CQEs may have been posted since the last
+	 * flush, and a target that has been reached must not fall behind it.
 	 */
-	ctx->cq_last_tm_flush = tail;
+	first = list_first_entry_or_null(&ctx->timeout_list, struct io_timeout,
+					 list);
+	if (!first || io_is_timeout_noseq(cmd_to_io_kiocb(first)))
+		ctx->cq_last_tm_flush = tail;
+	base = ctx->cq_last_tm_flush;
 
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
@@ -679,8 +686,8 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 
 		if (io_is_timeout_noseq(nxt))
 			continue;
-		/* nxt.seq is behind @tail, otherwise would've been completed */
-		if (off >= nextt->target_seq - tail)
+		/* no target is behind the last flush, see io_flush_timeouts() */
+		if (timeout->target_seq - base >= nextt->target_seq - base)
 			break;
 	}
 add:
-- 
2.53.0



