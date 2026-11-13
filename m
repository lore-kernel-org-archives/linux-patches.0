Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590853;
	b=JbrRRvbUtlrhbD93RNEBjVCIo3zdHNy9adMXWhhJ680j/bZyxUSCNu5DDkbYru1cejvK
	 Zaw/OIVqG6YVgT2j0UKaIfwZVZUyeu5Yg/jOxMzBxsNE09S85slqb2SwaylpLnasn1NxC
	 y9vJmi6ac9iLaERh8le1WJaWflgcx7B6MhIYe4MA0mzXGthzmegOOEaqQIlxNNczksU3+
	 h9idcaiVZEVnfwqjdHumy+g9Wr0SokPtZ+1InSCJeGCSCwEPgVxm0zrz5U7owdRhILznd
	 L9fO2P4+LtG5NJBQxpZ2PubelYbbAZXRFYiOVHECFOpaMs8tfJLrDkSneK34KjdUXjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LgQSb+cE3FF6Y+2RpIrRxaya6dn+YogNANKh0grhPUA=;
	b=5ikaIP8pmDyFGrTXkC+YFFqxUERVCy071mq9+f6yWsbhp7Bm6RLRRIybHbD/OL4C521C
	 7wtGEMXlqOV6H0WiEbHMrryAR/G/W+bRd+VKVTxjP3I2Y2a0oD18I8G4kT4LNi6HRL1JW
	 PWqXFb1OqZZ/0csQYGcJ21+5Bcf85z1jeUPL+ED8lRsysXhx3qMeU/A/sTvf8g4hTNXta
	 ZJmDNys7Q3+eoHGDHYg0WQ1XXKINA9pl06bQVLi8NCBtJlpepDQRWY1lGMh7UWr1ry01I
	 upMnBYJVM0EcXCSAcNm/u6LHHBVlKfAsjB1M95mtQY0ZkJbJ+dpvhxXNDjLAMwrirCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEIuNuMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39636606D497;
	Fri, 13 Nov 2026 17:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEIuNuMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84251F000C4;
	Fri, 13 Nov 2026 17:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590853;
	bh=LgQSb+cE3FF6Y+2RpIrRxaya6dn+YogNANKh0grhPUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEIuNuMcAWyj4SQFGICstqwqPxIganL6uHOVbmIKBrGtlHeROFxnbQMEp//WWGIED
	 ASQxS0tJhDdgUmNnw6CuXMI0xLzyerTLcgNXMGblGLbNv97g1qy8GfG3L+H7gFqWmI
	 bBVmMQPzzxe/kS0i4BjyViJ+toZ3JpD7ecThTXUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/670] io_uring/sqpoll: dont attach to a thread that is canceling
Date: Fri, 13 Nov 2026 10:43:35 -0500
Message-ID: <20261113153813.155030909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

Commit 22d9db9fd64a493525d692b32c556875b7254665 upstream.

io_sq_offload_create() refuses to attach a ring to an SQPOLL thread
that has already gone, by checking sqd->thread under sqd->lock. Since
the thread drops the lock while io_uring_cancel_generic() waits for its
requests, that check can run while the thread is on its way out and
still see it. The new ring is then added to ctx_list, io_uring_setup()
succeeds, the thread finishes canceling and exits without ever having
looked at the ring, and io_uring_enter() fails with -EOWNERDEAD.

Only a thread that exits on a fatal signal can be caught like this, as
the stop bit is set once the last ring has let go of the sqd, when no fd
is left to attach through. A fatal signal is group wide and attaching
needs the same thread group, so the attacher is on its way out as well.
Still, make the check see it: set the stop bit before canceling,
whatever the reason for the exit, and test it when attaching.

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Fixes: cb0306c52ffa ("io_uring/cancel: drop sqd->lock while SQPOLL waits")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 696aba6bbf81d..6ce73c93a721a 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -435,6 +435,12 @@ static int io_sq_thread(void *data)
 	if (retry_list)
 		io_sq_tw(&retry_list, UINT_MAX);
 
+	/*
+	 * Cancelation drops sqd->lock while it waits, and a ring could attach
+	 * to a thread that is on its way out. A fatal signal doesn't set the
+	 * bit, so set it here for io_sq_offload_create() to see.
+	 */
+	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	io_uring_cancel_generic(true, sqd);
 	rcu_assign_pointer(sqd->thread, NULL);
 	put_task_struct(current);
@@ -503,7 +509,10 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 		list_add(&ctx->sqd_list, &sqd->ctx_list);
 		io_sqd_update_thread_idle(sqd);
 		/* don't attach to a dying SQPOLL thread, would be racy */
-		ret = (attached && !sqd->thread) ? -ENXIO : 0;
+		ret = 0;
+		if (attached && (!sqd->thread ||
+		    test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)))
+			ret = -ENXIO;
 		io_sq_thread_unpark(sqd);
 
 		if (ret < 0)
-- 
2.53.0



