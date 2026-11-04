Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826942;
	b=nOJHaqrG93nQSAWe5afxhCkvG6KaqwpES//XGbR5jlnpy7+DZv/Wu16302rL4cy5QutL
	 OdNHCfuKutwzJ0GDM7FAZgtYYuYO8kf4m2U9XOXkdLgNX1/Yf/vyac5z0+P/VWgCy9RWr
	 pl4vPZR18nUTcdJTnlbV8YKUZuuVKzP0uTClQvWgdBgGeauYPRHpjB6QuyJ+zU1vRCWEM
	 28shGU+FsdOXvyQm9KO4eG5UUh6kpdqBbpi9nr4mqQTvfsUq79PK0rKxlSx+qAnYb2rz4
	 OeWJhCVOwYk6+MKrD74A+BSYBf+onBwpqvIGkmjZZke2zXMCx2WlO7qjxkbneB5ruZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XDric5MQ2y8Zmyi0g7Y9p79Ka3cU0oT9sgrKWaN+/sw=;
	b=bUpdR8jzn5JMbBAYjJIivJW1VSNoFHRjgcy+iHkjI4Ea5Zs6RANLkIw5AvNgy21ISjhE
	 j/yio0eGd8b/ST8ao/sbjJGMfOHV6u8v1+IFXgxHEuns8wVbucOZALbKoWm6u8eEU30ZS
	 6tG1aaClqiXpzxk7RfuXmifobAR5k3jfPepLeR/iDoWmstzrqn7VvRZ5F6Nq/QnwpmxOz
	 wWjQk2qtlq2tGaFlPVfLrviczr9sGoUv0S3DNnCnYQMvcoZYGvysDttk9xZCv1BbjKviD
	 lSpVVoTVi8//a/0zkSjpY315dEFECt2r2SUv9tKQGAkBPkecr0EI7Zg9SQqXBBDTLtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stFIG6pF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427676073515;
	Wed,  4 Nov 2026 21:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stFIG6pF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49421F000C1;
	Wed,  4 Nov 2026 21:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826942;
	bh=XDric5MQ2y8Zmyi0g7Y9p79Ka3cU0oT9sgrKWaN+/sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stFIG6pFQ/eT2BEYGc7gBbKMfgQ1Ku9hRnbErEwMjCoI2qYayqs+n9MbpUge3+0/P
	 EE8Vp23ZbG8PL+s76e0wXRaX5tKSCR3YLqZSwH50tTJjS0G/zaqcfngM/VeiivRQ4t
	 +ljzPI1ZzsQ62hvG17c5tU8S7jZIMxfYx3fi/5iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 060/547] io_uring/timeout: dont put a sequence target behind the last flush
Date: Wed,  4 Nov 2026 16:04:04 -0500
Message-ID: <20261104211039.984904376@linuxfoundation.org>
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

[ Upstream commit fdfce905a58edea053ee7b68b5bd4348dd1b36e0 ]

io_timeout_fn() and io_kill_timeout() bump ->cq_timeouts when a timeout
fires, but its CQE is only posted later from task_work. Until then the
sequence io_timeout() computes is one below the last flush per fired
timeout. Now that ->cq_last_tm_flush is kept while sequence timeouts are
pending, a timeout armed in that window with a small offset gets a target
behind the base. Its distance from the base wraps, and it's never
completed by events, only by its timer. With DEFER_TASKRUN that window
is as wide as the application makes it, as submission runs before the
local task_work.

Nothing but those in flight CQEs separates the two, so use the last
flush as the base for the target when the sequence is behind it.

Fixes: c6c0b3eba88c ("io_uring/timeout: don't skip over reached sequences")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 43a40bda7735c..05e6c07c98b53 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -690,7 +690,6 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
-	timeout->target_seq = tail + off;
 
 	/*
 	 * Update the last seq here in case io_flush_timeouts() hasn't, it only
@@ -704,6 +703,15 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 		ctx->cq_last_tm_flush = tail;
 	base = ctx->cq_last_tm_flush;
 
+	/*
+	 * A fired timeout bumps ->cq_timeouts before its CQE is posted, which
+	 * leaves the sequence behind the last flush until it is. Nothing else
+	 * separates the two then, so count from the flush.
+	 */
+	if ((s32)(tail - base) < 0)
+		tail = base;
+	timeout->target_seq = tail + off;
+
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
 	 * the one we need first.
-- 
2.53.0



