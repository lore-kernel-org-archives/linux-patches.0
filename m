Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046042;
	b=mxyWkyfbWPAIhQkuN7u2VKJSFhly5dhozHln8/D5bC7Tp3uaY6IdpevfqjudcZbo5lwv
	 VDIUeiwBEu+T5HvoDJdkggb5slMGAehLsV+z4JS98PV+D+jr2wqR0KydkPHsnDs7FBfQa
	 0hCy1D3z7aVUvRmMrquX919FACBdVNYWFnLvaBZxr1xljgs1yCB9cwfK83MPZF9MWaPX6
	 jukSy0VBwaiLAkerZDb5fu3jG4bhnFROFbqncNqsnpXm7+XZKCtQOiueq6fa10B1fnaxF
	 tl3bk6CzhYeLm5Jle0slywA6MimI0ZJr7I7B2xUKsA47Mh3q3mGt4uYIwBppDZ7yigw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aJ+ATW8Z8mZhBxf8R1Zcl6myAHrwjunWdV8Pjjzq+p4=;
	b=qkNqQcCSBZPpHUEbS6Wye+Z+Xey+cAaLFgOYvAMPp9xN5vVVvqNHKXzA2Ucp2M5TMJXY
	 HDnknnsHIzM5wDH4tp/UebQdfPjvPkwq1vTsUqSXETKG5STKTziBV5gbAWz2/oMt17JBW
	 siAeRafyN7JK6uLjKn935t8FyCS4ZetZ+r9koHdQdnGudhKg0N41pFMsk8nnwwcMA1qX2
	 8y0/jOuWt4vqJpjtZZn1fYclwobLmA2pXpFzgRtk2+HE+FlHUFQbGY1wHd1RlxxsUwgPE
	 reKghbXMaWas/ToOwx2MrNJkUXaRpp4YyjlKueaZNCb2qfuxuHIqSoCOlzWKF7NJDtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AtikGjAo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E6C606A32A;
	Wed, 18 Nov 2026 23:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AtikGjAo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0410B1F000C4;
	Wed, 18 Nov 2026 23:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046042;
	bh=aJ+ATW8Z8mZhBxf8R1Zcl6myAHrwjunWdV8Pjjzq+p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtikGjAoR8fhKURsWERcZFUYA2pReXcDKhkuNI3Ui525TwDbRyOaT0K7Tcj+vA6cd
	 vNpXbgG+HwPa4Ou7HNhlp2lnWVY7An7zc0LqFcmbGf87I9v7aHUIennvyMp3KN1eQY
	 Gm0WvQWxm9kJ+L4865X+DOAaKixd15+WMG1q+1OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1140/2857] io_uring/sqpoll: dont attach to a thread that is canceling
Date: Wed, 18 Nov 2026 15:36:14 +0100
Message-ID: <20261118150242.636291084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.1 has no io_sq_tw_pending() before the final cancel]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 2cbe580d76afc..a9400233053d3 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -337,6 +337,12 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
+	/*
+	 * Cancelation drops sqd->lock while it waits, and a ring could attach
+	 * to a thread that is on its way out. A fatal signal doesn't set the
+	 * bit, so set it here for io_sq_offload_create() to see.
+	 */
+	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	io_uring_cancel_generic(true, sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
@@ -411,7 +417,10 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
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



