Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210366;
	b=bJbeNSjBduw+ov221Gq4zfrhovontA+kil0dIuZFjD0f4VIv7l330+Q/pRg7zLXTRWSv
	 9hGotujhKDtFfZn+5OzUfDbG2osmpoUoCfHdn4Ia7ARrGCkanOlh0aTfodsnVLxDp2Fjo
	 aNgLarTc9AAkhHbf1Pf9wpBaQGG5wXiB1O7mzh7zVy8lWtsFbWqs5A/iKD5BUXj5fzrUq
	 glBIzQOfGF6Fu3EdGn43Dzhs0f+dWXpCuYrG6QSaaAbBt9rSHdI7WiAnL+3R7AyI7DJ/c
	 MG7PeVxndI8cTlvy40b9E/19zjFXovXaPh15oNtdmGQmOxORVpp+6nnOnwiqzouZ+Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zWh6kBrQILM8hr5l/4hIXbWwzE5+jgBsI0jB3ATbXLs=;
	b=cJt5aCZBBhSp3TMh8EbWFMEl48wwnFJmsKi3519SWjhmXSY/004GW4pNMl2DJXjzbCRE
	 l34sHgHP4fBqbBVyCYvoYk/3MUhEnLEQRlLEneKykdtiAWeLsaCNNip1imMU1r+JoLl+U
	 nm7jk4wJoc05qgj3Npaz8a0cG+DjyAtAXyl+qBtaNn4snoZmevkKUtDIt0k2Y28Sf+suw
	 YWuWA5Jp9CaPdu+0t7XGzf4n7mK5dQAn1g6W9/y6ZSPIAtPkUN6aYjtD0uoDkwYLb4W2d
	 W7hZG99fCHia8hLcFnTFB4G9vgb645svGNVub4DFvrjaiTcgLC5r/VnWOvIaeVdA9DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i15+YpGu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CECF606A31A;
	Wed, 28 Oct 2026 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i15+YpGu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6651F01825;
	Wed, 28 Oct 2026 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210366;
	bh=zWh6kBrQILM8hr5l/4hIXbWwzE5+jgBsI0jB3ATbXLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i15+YpGuNeT9IXwNHBFTVcWqAgffd+ClTg7wWPXjDjfAwn85rumqpZZuIFcB/ouS9
	 XZeOExd6DdhyV8zr0L4id5kez/PDjZpH9AdeRVZ/Fb/4Rnlwi1Ytk7HyKuh06mMX8r
	 m8tqiOsiiD/ObE9GUbiEkyKhVWFUGVQrFCXjE8Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 149/168] io_uring/timeout: dont put a sequence target behind the last flush
Date: Wed, 28 Oct 2026 18:01:25 +0100
Message-ID: <20261028165946.611194292@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit fdfce905a58edea053ee7b68b5bd4348dd1b36e0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -612,7 +612,6 @@ int io_timeout(struct io_kiocb *req, uns
 	}
 
 	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
-	timeout->target_seq = tail + off;
 
 	/*
 	 * Update the last seq here in case io_flush_timeouts() hasn't, it only
@@ -627,6 +626,15 @@ int io_timeout(struct io_kiocb *req, uns
 	base = ctx->cq_last_tm_flush;
 
 	/*
+	 * A fired timeout bumps ->cq_timeouts before its CQE is posted, which
+	 * leaves the sequence behind the last flush until it is. Nothing else
+	 * separates the two then, so count from the flush.
+	 */
+	if ((s32)(tail - base) < 0)
+		tail = base;
+	timeout->target_seq = tail + off;
+
+	/*
 	 * Insertion sort, ensuring the first entry in the list is always
 	 * the one we need first.
 	 */


