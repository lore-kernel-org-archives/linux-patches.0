Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037356;
	b=KOgInLdfYcX8H57uT2QeV5iQuwIrVk7vrB3CR5TkrLB8bjDwfSe66781SmY+9F+oHBUY
	 3+mf/y8G61MFB0ugMRtw1vcmavgauoEn27O1hNhuC/LcPjKxsaL4eyaZRDGMBpk+7Sm4C
	 N4oU/U9pFPy5349w8YEclMqL18VDKXHC2VJNBO7uxDpSgiP292zr2R4DJWBUDhdIOK4fh
	 0OZ+I+E1vMQATajyq3/wbejM7eR2LCAMJ3HxJeqmopYy4pgUB17HEyWY1FBNcdH5ac/dn
	 jbIIRyigKaNPHJA0hnzsDaZ5ovdYg4OlALnZsxWJdRX2YbGvc7eZEj4bKU/cPsb+Q1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=60ph/cwjCIaUYwo0VH6JkJRTMMVmnM8/W2iN2KOkXe4=;
	b=JxMYXV2XvvFne4V67g+sGJ55T9OpNHDyi/cuYusOWCVK54VAZH98n+deCsbQcfzyWW1b
	 iiyfeEeD3rIEMP8XiXlx7v0bQbOnSyQbt/c4X4USfYr3pxfaPKWY8xCHPbbWieezxcgmM
	 aMX5p1aK2stmstXbptkaY++vB2JtdxCnsuu42312dUrlxAvUHF3SCqfTw/b082jL8PHnS
	 utuwz0CFtNnh11d34663fWBnDFYD51bBg02awvyobKmmiMDNuKL4D83cM4TZ+GBfPo4AL
	 MSt70wJV1fZ/EslCpdzXdB+pVxf6P1Qy86O4cmr+Zmu6SyEOti7pTzsw2WnW6xDTt3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjzKIQmG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D762760A2636;
	Wed, 18 Nov 2026 21:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjzKIQmG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1CC1F000C4;
	Wed, 18 Nov 2026 21:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037356;
	bh=60ph/cwjCIaUYwo0VH6JkJRTMMVmnM8/W2iN2KOkXe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjzKIQmGF15+r1Sgy0XqMp5qZZQLSxsEyZMZpsCxchrdjS3gPFOswQuD1bU8iXJQq
	 REHvQIDHB8neSGD8iM1Q6hPWwfGFRojHJj0As+Nf3sNluxFh3YHWGdu6kv3JDlaX/j
	 3wjdh8QM93IBeRnp1HHYtqDUehEwv08riABOL1Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1338/3318] io_uring/sqpoll: dont attach to a thread that is canceling
Date: Wed, 18 Nov 2026 15:32:40 +0100
Message-ID: <20261118150400.500630101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
[axboe: 6.6 has no io_sq_tw_pending() before the final cancel]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index f458c1191e2d3..d0f4f05397b13 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -345,6 +345,12 @@ static int io_sq_thread(void *data)
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
@@ -418,7 +424,10 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
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



