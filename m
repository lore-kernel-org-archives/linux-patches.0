Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590020;
	b=XMZCLvwXZofnSP4AV3Hx6plEABugiJBcZ/Bw9oxnl4sXkdxOZ84CdkYuBguoYR4l3n+g
	 +sdRfpeXL/KN4CkQJTkWiYt06bHkcZvSNn4ZHX7piMjiOvGWKlF1asbpV/yzMGAmoypaB
	 afHFinQElPSr9bW+DObUCreddfTEIgtausSqW+iPEipvUbULXsuaWEVBzK3j4Fyl68M8/
	 HvL+Z71Oq8tc1tIzdUtVUT+/BdTQQZwoiQcIKUym6xROWKv1NTPdaZ2oraNfl0YRNy0NC
	 XmqGKo9oNt7LrPcBz3I2E348rhMMojY5lw5SyGa01W7pJe6gxXEzJV0VK0YnQ5KRLEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EU0LGRsQPkJiK1Uxfj/UQjWddIBka0ybqXMcNVMnkPg=;
	b=fOA7SublFgPCtCqrZP/MU+VDVKwXj3dNXHZiXHw0at99XVd77XojXTOBp6TDia3iYUvd
	 On+NavcPan0oUdGZJF4Gfhl4EZjE5fKMaENomTiNE7P/KTX9Y0QEDdXGQ3ZoxcSdVElnX
	 Z+rZWMThepaXXpsBdWzkzx6xbGeVush+Cp+oS7T6pYchaeHoTHt2o2GpMmct4lzRn7dhS
	 rM2/wj9LLWrrSBezU1ziMv4A9cL0OqgNCcPQKmlfICBTwJ5XYiPYjiyA+eVkrxbG4NZkQ
	 fAd+etAwZmOEaf0Wjw5qct3bBt2dVgkBhR+bzyVoEbV1pYG/qqaajVjmAj29wkP3X0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/F6nyrT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD85606A8AC;
	Fri, 13 Nov 2026 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/F6nyrT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CF11F000C4;
	Fri, 13 Nov 2026 17:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590020;
	bh=EU0LGRsQPkJiK1Uxfj/UQjWddIBka0ybqXMcNVMnkPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/F6nyrTRoFGqOwf07JuJLa4+yLATbm8ZbldCsvjyqpTm+qHZuX8v3qRq8295nCeB
	 ban55psTkYTd18G0NqnekonU2r32+nBRyojKXQGbr92unr8zDjO4EhewlImiP7D0IT
	 UQoTxECi2FWHRNGQvvKTlkeRYNFmapP9nm1Eimjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/686] io_uring/sqpoll: dont attach to a thread that is canceling
Date: Fri, 13 Nov 2026 10:43:14 -0500
Message-ID: <20261113153823.005398912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 406029c14fbce..1c7f84192c0af 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -438,6 +438,12 @@ static int io_sq_thread(void *data)
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
@@ -506,7 +512,10 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
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



