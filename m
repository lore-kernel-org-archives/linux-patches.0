Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585338;
	b=Gze+DM0Z2jZTpDaVNmrCFsS0xUuRiGQ+kb9HNyqPJNxGMTqIAX4qh880FJUmJP+AHMal
	 8/oQmO1/HEiaNwW/hxsdHEQt1fCQ680YkmgO7GjjSx7tu7KoP3gsXLJroeHP0FrqN8zl6
	 Y1CDs8/u9z+Gen++zO19WsJn2l4iDv5sKy9mCp3kr1qAy1SanIE37cuaqibGgOJmykhZQ
	 a9uw9G+wUA+G4Y7WEUq81ML9ZmPI2zaZIIA0QlNDPSTYoAuGqsz1ZapcVqMROBp4E/hNa
	 ycVse2b/fv5Kpns676j4ZAl5Mxe8viLkHaS+ONX3Mmvb/TRHtjH7/V8ZcR6BY2MEvKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wWIFQ6Cb/RIHIEptubDWDiFbx6XUSKbvReg7XW1F/Og=;
	b=0SbgcOoJGzUT5qOfdEhf/BRUFXkTiXxgZJ+GyO3kvTAJ6T5gIvnMNp6LU29KXNu3/DWx
	 tGgwrUXuLsNbfmSpV4TmASWVQByiPShFkAgh9vTp0MdWAF4/21xDajj2xD68ig8MbwRO8
	 l694jCdrc61qARx8UHSfMoe/5bIQnq1/CEUnLVI2iRrH+b3pDIykNG/3Ph6DOs9gl+mOP
	 4uRixMh5rhuEeqnWtrloO/5tlpsBD/QXhLbtCB0wPUTz1ZAHbK7DibjbWfBLwWiUxy2Oz
	 ULV7s8/hrXz8aTqsjcjzxCIAwpgw/xPMT3snLmuy5r3l/ETiDKrEpWJtVjqLW5f+PlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYdBy9t4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772A560A2622;
	Fri, 13 Nov 2026 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYdBy9t4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D931F000C5;
	Fri, 13 Nov 2026 15:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585338;
	bh=wWIFQ6Cb/RIHIEptubDWDiFbx6XUSKbvReg7XW1F/Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYdBy9t4ZKU5W2yHj6hdPO1FNQmVI5PObnNphEiBZnAiN3hEz2DBwtZ/adAozQWnR
	 zKfvBev0SaEk6D6Q9CYBculKUCwbnhRiA3gqu4LBfKbx8isvBs8iwouz3rUbRsLy5E
	 2lRQEOp1+NegUl1V563wHUKv3H+LpbWYrddFX8eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 023/507] io_uring/sqpoll: dont attach to a thread that is canceling
Date: Fri, 13 Nov 2026 10:45:27 -0500
Message-ID: <20261113153754.177456051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 49c52284ecdde..c833e776320d4 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -433,6 +433,12 @@ static int io_sq_thread(void *data)
 	if (io_sq_tw_pending())
 		io_sq_tw(UINT_MAX);
 
+	/*
+	 * Cancelation drops sqd->lock while it waits, and a ring could attach
+	 * to a thread that is on its way out. A fatal signal doesn't set the
+	 * bit, so set it here for io_sq_offload_create() to see.
+	 */
+	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	io_uring_cancel_generic(true, sqd);
 	rcu_assign_pointer(sqd->thread, NULL);
 	put_task_struct(current);
@@ -502,7 +508,10 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
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



