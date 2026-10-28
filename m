Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207284;
	b=ZZb5cFGLfY0C1Www0BB5TxfztS7hoyQAqdYGqXZOIzoehb56BDLwPZCAaoSAo9Vd2AA+
	 vU0kAp0vHsvFr3b17FT/6N/eR23ikmTbUF/iv/umahSKUNTwrFtyRHtxZgoC3TDpQjjp1
	 t7JEfPTbUxLkrt4ZtdxksvxBaXW5kbuCiQzGWjhxNLJayCP5XScwMj43w83ADv69p7yEH
	 PUuvNF5uDI1LDiMnFRCPxO4beQScU221JekuMILL4qkphmzAQ14VBeAoO7RPBnIih2URL
	 ttxXw+jibCNlxPKlmSxGYJukyHW3/ciaPLCPu/fqz7FE273zAb6YFPL1CK5+cctv/fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwJtMThhFrzLCcJcAmKwKSklg7w4KpJm4KEIwRsQ+Q8=;
	b=5Mxbjq8TP56B8fmtN4sUZTSQOYfvj0SYpzlygMmcY5a8eZP3h528klYcxjXUkIaJTYrX
	 4RNAhhgMQqiPaN+juunPej5hev/GRO4xhL7orT38F7hrDDx7+cWXb39JHlje+zDtYSORJ
	 KsXnE7zYtBT0cRZhU6I/SFrbWw6GDofNfqsyBmuZwJ0UxzI7jtPzv/GJTYVdo5DGtYH1z
	 HtVXWpv/qgPsB65VS+aq8aeAI/Jk74R9XEO/kDeGX8TQjcggsClO8urXPG8ohPQTAUGIb
	 rdQDAR6G//PIJCMfFvYl0CRWIzaOv1PrR5WoKNR6aMiFQcyeIzMK0nn+IOXq9Rmklqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KZ4umBKf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A64606A31A;
	Wed, 28 Oct 2026 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KZ4umBKf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DF31F01825;
	Wed, 28 Oct 2026 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207283;
	bh=bwJtMThhFrzLCcJcAmKwKSklg7w4KpJm4KEIwRsQ+Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZ4umBKfJrpsS7hcCskutVCrMf1t8SxcANOaeA0ocJsrWHah5JWOZtHGP/rP62BCQ
	 h/NJh50Y1gCZtPeaQWf7ceE3xY7MARyYHMmqMH/nzhWX5euiI5g3NQwrL5vQNik3l6
	 8hlYWbmWdK2sCEEELCnbLftI39wzS4UdlVtWAphY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 50/88] io_uring/napi: dont busy poll past an expired timeout
Date: Wed, 28 Oct 2026 17:59:58 +0100
Message-ID: <20261028165943.289797505@linuxfoundation.org>
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

Commit 21ed976c12f6b77d7ea028a4fe9a08e69a56179f upstream.

__io_napi_busy_loop() caps the busy poll time to what is left until the
timeout of the wait. The difference is negative if the timeout has passed
already, which is what an application gets if it uses
IORING_ENTER_ABS_TIMER with a time that isn't in the future any more. The
min_t(u64, ...) turns that into a huge value, so the cap has no effect
and the wait, which should return right away, spins for the full busy
poll time first.

Fixes: d5cce407e4f5 ("io_uring/napi: postpone napi timeout adjustment")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-34-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/napi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -378,6 +378,8 @@ void __io_napi_busy_loop(struct io_ring_
 	if (iowq->timeout != KTIME_MAX) {
 		ktime_t dt = ktime_sub(iowq->timeout, io_get_time(ctx));
 
+		/* an absolute timeout may have passed already */
+		dt = max_t(ktime_t, dt, 0);
 		iowq->napi_busy_poll_dt = min_t(u64, iowq->napi_busy_poll_dt, dt);
 	}
 


