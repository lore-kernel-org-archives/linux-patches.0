Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208100;
	b=REMZSodotksuJOuV7pU29jDbYVQMjuco72BJXVZwGjK/U0AK4P0pXZ8WZf+bdfGCHuV+
	 qn2kVw81m2uftY4lPAddxlOjHaEAXsd6TCT1NGycl/SOrJ0RS11VAgvER4r2JnJ0/Tvt/
	 0Gp0USpgZQne25dbSonG/XFn2lq0zEpQ+/ik3wGxbv9lZ49D9i16LQfVH1RyDlx0DQ8ij
	 JpyPGhsCqaiv/ul+3d23ULeNvkU1bnBYYAKrMG5poE3KWok4yl0v/B8V0p7nk4sXOtvaV
	 hufAxbUjCMo7cVCOsvG6+VXArpwbYcLz7UwPQz+UuqWZFrHavLcZ/3jdb51Myvs0h7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PO0zbdJVbAhZqudOfVUYPE2vyO96NC2jmuTYVN/vBxk=;
	b=vj5ulTU5sWjAbd7YYqdg66v6UV1Mnz/t47tZXGg+Iu01XXVAOpMMQ3/haygToDbF7bv2
	 WafsVCd5KrAxTKfHSDf9lgFOeQYoJp1VXXCWQ27wXGDUPrCXMR2zHLMzOisqVyRWeG1e0
	 WmOYSKND4UkHKbhLmMcdVxDPIp7XfxF2/YbqcbbWG2JqjcIFz3gRsYBJ39c/wKeS/CGcs
	 HIMSIRTfuLoZNaMySDoSsO4iKJ1I9isDRgJSsPflDDSz9v3Hafvo6BRzRweoS/n+T5aH5
	 vxIFjS1UfZtLo6z+MU1UiIhJnIs2a1d1mTzWLOOGotuS+H0jn4/XQ2T6yoPgJu64upg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUEueWKc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A327C606A31A;
	Wed, 28 Oct 2026 17:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUEueWKc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36E71F01825;
	Wed, 28 Oct 2026 17:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208100;
	bh=PO0zbdJVbAhZqudOfVUYPE2vyO96NC2jmuTYVN/vBxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUEueWKcVWECvG4S0XBLJ13rF4GNPldaodH3687am225fZXaIIoSRkKXN0GFSPZ0B
	 GXFxDO10ed+m82Kp+McQiF99Ds0YABlSJy0YmAR41ygPZ8LLtfE/4TGwGM5aEB/M+x
	 DqsASDggb5gXzCnaZMGuYW1ghWgXuyohgmk9kP/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 223/247] io_uring/timeout: dont put a sequence target behind the last flush
Date: Wed, 28 Oct 2026 18:00:26 +0100
Message-ID: <20261028165952.702492918@linuxfoundation.org>
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
@@ -610,7 +610,6 @@ int io_timeout(struct io_kiocb *req, uns
 	}
 
 	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
-	timeout->target_seq = tail + off;
 
 	/*
 	 * Update the last seq here in case io_flush_timeouts() hasn't, it only
@@ -625,6 +624,15 @@ int io_timeout(struct io_kiocb *req, uns
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


