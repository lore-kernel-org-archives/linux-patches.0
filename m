Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046039;
	b=voIthPM+VOUi5hCUqNrcJVMqo0SXkeyPw4VpEOsDaGGlllmt8duxix6FdFLZ8yEjqxDV
	 5y8+Y6lDSqjxtA+e22PQbkKxDCD+nvJfg0ocTFamTPVTmIg1VuI1gzHsuStj4uj4NozfV
	 CMfPusc5IlvlaZYkmcJqJhfGpwqYOyzl3bEpEKuMphCivdcwqvt6oy79asHh3HuSr2/t/
	 kMqEKiqqN7cpiapUIgHaTEGA6jGpjN9ErtO0KSEGoCarzxVrkPqLiY8uN+fYfDfSy9Kp6
	 mcBDX2COm5ombaHDd5DzpCkAYvgdZdj4dNPfX1tfp44+QAdeDiKfjswwXyZLWlO7how==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9aGor6WZG9vdMr6hy0UqSQ0eXQje8W+Kg1biuZEje7o=;
	b=Fj4D6BsnwNfUuuMvsnr9R9al7Vu0i0vuJrVZ0X7OXtMoDgi8Lu16XVeNIHg/XzeuaHkr
	 QqarwWPx7eiKSPgyWuYSBCkVduOE4rVAQi8zHTL5TkE6Vud/kO0DG7LchPYaNl3qeExXm
	 xJ4mGF0aVDJumE/bOm4rZBPY1RsRik/xHHPX6uotZecLXVOcB+APJnjtQ6XA/bNqT7KZO
	 dvnorjjjdHUy1+66KThT4g2Wldeg0CX91Ougpyt+dIpnmkbO47yHaOYwM5/M2MemysHXz
	 lNqILK0BEAUG9OjCZSi0BAwzkhkWA69lnqc7ADp/RRxaYl7sZOQvn7s6ERCPSt3n0Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VODySanZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD630606A325;
	Wed, 18 Nov 2026 23:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VODySanZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B0C1F000C4;
	Wed, 18 Nov 2026 23:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046039;
	bh=9aGor6WZG9vdMr6hy0UqSQ0eXQje8W+Kg1biuZEje7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VODySanZYI01UnPigTCUPK7Sn9+47kz99ODy34uS1T50jS2pCw46G/Ua9CXCoaAv7
	 zCowpJBLRX/3tYr7ej0BY1fmw7gDAM3LkjObO3kZGRLdRN1za9Ll/p0HjSNSem4YNV
	 wQqFVUcIYuEyu9+snyygkpG7Zq5dDB2xNUZiJ99I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1139/2857] io_uring/cancel: drop sqd->lock while SQPOLL waits
Date: Wed, 18 Nov 2026 15:36:13 +0100
Message-ID: <20261118150242.602082139@linuxfoundation.org>
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
[axboe: io_uring_cancel_generic() is in io_uring.c in 6.1, and uses a
schedule() based wait loop]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3392218887d91..866c6ad29e4c9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3182,7 +3182,16 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
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
 
@@ -3195,8 +3204,20 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
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
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
-- 
2.53.0



