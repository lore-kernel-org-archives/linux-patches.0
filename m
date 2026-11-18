Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037320;
	b=e+u20IfRTk7W3tiiaVQMrfb5M3137w47Cw65qrL1IlrriqdQgl1H2THX3fnVEPPbNWGw
	 Y8puuT9Vu0GuQrWZABo+X9+inNua5ZKrU/NSX2O7TktItCurQ7a1UJvYnY7WdxzFrGa9v
	 LmjVCpPUX4tk9HBLtdxAXQoPmLWYDyO841aXk1Ud2MO3a5FoHKO3t8Wxo4IJFkxazwQUi
	 Pe8lbVNdWDeC7NUHjZABfqvTbSn2HBKrCBFSTpwr+UfacASRujjEZWy7Unp0XEQpN9wYH
	 kTHjrepQngcHBgZW1cqbpUzCXAAxFKKViBZRHhlHjvscH8QpS/9dbVBrw8QC4kqzf0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K40jbtNKrGY11ax4Xc8PnB4e9peugsUw1IJYBkW3NG8=;
	b=rzcvwvf9ShiTakFHg1+QhvkfFNUaYGTF36rA46hKIT0W/C7mO2DJbrpsL7N/t1oSBlbj
	 uwktx7FcptOl+eH1KGnw6zQ7eH6GAcR3aIrBAHhREF9g92mK+kE/iSqpD/Vr9ExiCyauV
	 DLnMRgdLy5I7RVGriWz0dk1fUl4+tvfHOcRLh/zC/RlK+zRX9Wh/o6Qnsg2Cmdg3auJMx
	 aCYiqOUBnbnW7FqbZcjvwo+h+2t6Mp/WTVTii7eQnPunWKUr7oEDe5g0MHAm3mHZkydjj
	 13yN5Za3y7Al9pLgarXO0KKbr0FaN3tK7YFGUrI89ku7kYgFbYjyD11iNMzwXYKgnuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGFUOnjK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0A3606A320;
	Wed, 18 Nov 2026 21:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGFUOnjK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C111F000C4;
	Wed, 18 Nov 2026 21:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037320;
	bh=K40jbtNKrGY11ax4Xc8PnB4e9peugsUw1IJYBkW3NG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGFUOnjKwn/O71DBXgtqjyybfOcnpAoCcdahnJfsgQDgEPnUPF4jfMByDvkFkPFvT
	 h1p7IC66znMbeNCMUB8xMXoo3V20JZRIjltDNwF5SBqJi64bt1RXoodTOqQukHAyT8
	 eLsrHH5wrWF2X+pA7NvVyNOPHfcuo7oVbf2WN6Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1337/3318] io_uring/cancel: drop sqd->lock while SQPOLL waits
Date: Wed, 18 Nov 2026 15:32:39 +0100
Message-ID: <20261118150400.468041434@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

Commit cb0306c52ffae083a86fb283de67875ae7a9500e upstream.

An exiting SQPOLL thread calls io_uring_cancel_generic() with sqd->lock
held, and keeps it across cond_resched() and the sleep until nothing is
in flight anymore. A zero-copy send notification can't be canceled and
stays pending as long as the peer doesn't read, so the lock is held for
as long as a user cares to. io_ring_exit_work() needs it to park the
thread, and so do IORING_REGISTER_IOWQ_AFF and IOWQ_MAX_WORKERS. With
64 such rings sharing the thread, every iou_exit slot sleeps on the lock
and no ring gets freed for anyone.

Drop the lock around cond_resched() and the sleep, like the main loop of
the thread does. Each walk of ctx_list is still under one hold, and
nothing is kept across the unlock. The thread drops its io-wq, frees its
tctx and clears sqd->thread under one hold after the loop, so whoever
holds the lock and finds sqd->thread set can still use them.

Fixes: 63809137ebb5 ("io_uring: flush notifiers after sendzc")
Signed-off-by: Chris Mason <mason@kernel.org>
[axboe: adapted to the schedule_timeout() based loop]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: io_uring_cancel_generic() is in io_uring.c in 6.6, and uses a
schedule() based wait loop]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index af349afeb4cb0..43860048d2bf3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3566,7 +3566,16 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		}
 
 		if (loop) {
+			/*
+			 * A request that runs in io-wq and doesn't end makes
+			 * each round come here. Don't hold sqd->lock for that
+			 * long either.
+			 */
+			if (sqd)
+				mutex_unlock(&sqd->lock);
 			cond_resched();
+			if (sqd)
+				mutex_lock(&sqd->lock);
 			continue;
 		}
 
@@ -3584,8 +3593,20 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		 * avoids a race where a completion comes in before we did
 		 * prepare_to_wait().
 		 */
-		if (inflight == tctx_inflight(tctx, !cancel_all))
+		if (inflight == tctx_inflight(tctx, !cancel_all)) {
+			/*
+			 * A zero-copy notification can't be canceled, and a
+			 * peer that doesn't read keeps it pending. Don't hold
+			 * sqd->lock while waiting for it, or whoever wants the
+			 * lock sleeps as long. No ring is used across this,
+			 * the next round walks ->ctx_list anew.
+			 */
+			if (sqd)
+				mutex_unlock(&sqd->lock);
 			schedule();
+			if (sqd)
+				mutex_lock(&sqd->lock);
+		}
 end_wait:
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-- 
2.53.0



