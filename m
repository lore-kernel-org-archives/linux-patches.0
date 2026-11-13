Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590852;
	b=5Nf3N86HjfW3aySM1dvfuAhXmWg4HrcAHSUG5w+y5wcSSNQFbhKwr6gTIYhwlrN4LxZ0
	 h04c+rIItNI279OVdDvEbVOQqkZAGsU1ULJxEkH942b7y/UaV+X1NjKNIqyp497AtWD1Y
	 Z/zCqCDghLgWczZhVVCq3f3Sdye96CfY1AHbudQ5fpw9gPX7YOx+JG4iApLzV0rvQZU6h
	 MtN78Nop5ElOZVmyAcJ8xwODfUw3vdzBFirE/R0hNguIQU5/BxQ/4GCGCCRh/NeB91qrq
	 DGM+BuLqUF2yW0qgCXuyltNWA56/kL/MKL+kbWMFBFGwJYVEQ/sg5c87Plg9xhsI05Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UG/TIcuSgnwWH+6kmhb7wJfZe6rqQLL6phuCI++aNvM=;
	b=PPy1+lkEdopjAk4f3vVVgFJmYUwLawC9tzLMlSbVXm96rDiHPu1bhgsCiuKZ6nKvrhQn
	 AqqECD8ZPCnVCAncogrz/U9AwFhIgeSd2lrDHMH+K8sY1Wj+a0JzF4fH5e/3jN+Xp085D
	 1mkNrGWxLCn+cPNhfwpnvVhmC4Z1b/4mLJsysqi3JweXCj1eCk3KoPaklLfHz8FZL8zpP
	 VJSeyZaqEANnDM9i5NcsPzEyfFLY0yQ5GX1X+onXe5MIE+qs1JJ49vTEt+Ah1wijaGDjI
	 Ar0jO0H1EOq6e/5RK8gFIkgh3g3BcTT6yjxXhe4PD33XGtybqZ3JyO9MYKpY9dL3a2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LE/l5j+i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A11606D482;
	Fri, 13 Nov 2026 17:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LE/l5j+i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06FC1F000C4;
	Fri, 13 Nov 2026 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590851;
	bh=UG/TIcuSgnwWH+6kmhb7wJfZe6rqQLL6phuCI++aNvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LE/l5j+il5PR1zSJa9rkpnDHurncibAWYpwCaxBEm15cxO3cU/qjilAQMVSt6+kK3
	 83VU10bcm/BneWihj0QWNKfywdT7q0xRgti2NK8dqKPhFAsWbT09u6qk1bqViJHtGJ
	 vJPShokNqVwGHhA/IqYaR1b/QuCrbM0HEIB/ummA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/670] io_uring/cancel: drop sqd->lock while SQPOLL waits
Date: Fri, 13 Nov 2026 10:43:34 -0500
Message-ID: <20261113153813.101034947@linuxfoundation.org>
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
[axboe: io_uring_cancel_generic() is in io_uring.c in 6.12, and uses a
schedule() based wait loop]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 52759ee3bd6c9..09551e3907f91 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3282,7 +3282,16 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
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
 
@@ -3300,8 +3309,20 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
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



