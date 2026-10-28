Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208115;
	b=p7MtzLZdTMeg125UsQP5Gok+3IGXVBu1F1lcxU899FVLs15TpszwJdU+4qkF2EYZY7PT
	 kAKMHy410yqi1PJsYdW3ejmdvrXs0OA1xO7ntphBIrSX/t7cfJXk2PjHdbSKe4g80/fZW
	 6gDdr8cuSVKwuktC/jlLhzHdgMtPnyry6v0dp3+qAfuqeUpQeHVihmnUwkm41yo5HiKqy
	 jjr+uT8v7tdx56ifJ9tMVKDh51gLR7tjNe2QghueC8kTdrsFsXZeL1wGleWqqH0Yngz17
	 zhu/7vbFIMtGz6PQxEZXGPP+KIKifTUQPzIjkCmXU2McxJB/1B4ROi703XjMPRU9NeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jq0PYz3Uisx3S/jBae3QMRb3Tg3CDR6dbUNz8TrBZV0=;
	b=s02yJYg9dqKydxMawHOWyYigCZ2BO7LLczyIvxfG4lbVfzAPoUjaAm2IMM0fmQQFwmbp
	 hMZ0Lhj4OB7sHhigvLFXMhx5JJSjK2PCUkzU/E7uCmR1q3EIwy6bdqdnefiZB6hfvWh7p
	 V4ZyIi7wVeUHXZtNT2w79cYo7+YtkOLlGQSn27hcIxd8ABMtRg+P/HB7X/dxRIQtAmTiS
	 6iA5d8/ewW/VDukjfdKNIfgezXMq8cfrHiyxQ2Ypgfo3ASQ914ZYSkCvzAFVAt1JDVIn6
	 97PHFX7ns79ieBpDL6fR0tsirPe2ReU649Qe5Thd848mRE0q+mW27shFPaN/b8KLGZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDgJUiMd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296D6606A334;
	Wed, 28 Oct 2026 17:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDgJUiMd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5831F01825;
	Wed, 28 Oct 2026 17:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208114;
	bh=Jq0PYz3Uisx3S/jBae3QMRb3Tg3CDR6dbUNz8TrBZV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDgJUiMdPq6KbYsczyicWx7BegtG2eTIgZCwPhpQePzKg5osGTveDLznabPxL0gW1
	 zAzAzkuqVH0ipZ3E2pFWYTuCM6mk6AZWoij9raC+p5+PemodWQagVUE2lNWwzZj1vX
	 6p8vQnIZ13amnOFgwNkKy6xiwvaMLlYOHTA432YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austin Schuh <austin.linux@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 228/247] io_uring/wait: wake real-time waiters from hard interrupt context
Date: Wed, 28 Oct 2026 18:00:31 +0100
Message-ID: <20261028165952.820099300@linuxfoundation.org>
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

From: Austin Schuh <austin.linux@gmail.com>

Commit 5b01d5955ac206e38097f777eff6ab2a8b948c41 upstream.

Since commit cebf123c634a ("io_uring: implement our own schedule timeout
handling"), a CQ wait with a timeout sleeps on io_uring's own hrtimer
instead of an hrtimer sleeper.  On PREEMPT_RT, an hrtimer that isn't
marked for hard interrupt expiry expires in the per-CPU ktimers thread,
which runs at SCHED_FIFO 1.  A real-time task waiting in io_uring_enter()
is therefore not woken at its deadline while any other real-time task is
runnable on its CPU: the wakeup waits until every one of them has blocked.

hrtimer sleepers, which schedule_hrtimeout_range_clock() used to give
io_uring, don't have this problem: __hrtimer_setup_sleeper() marks the
timer hard when the sleeping task is in a real-time or deadline class.
Both of io_uring's callbacks are fine in hard interrupt context:
io_cqring_timer_wakeup() sets a flag and calls wake_up_process(), and
io_cqring_min_timer_wakeup() only reads ring state, under RCU, before
doing the same or re-arming the timer.  Apply the sleeper rule to them.

Measured on a Jetson Orin Nano running 6.18.39-rt with this change
backported: a SCHED_FIFO 40 task waits in io_uring_enter() for 40,000
deadlines 500us apart, while a SCHED_FIFO 20 task runs bursts of up to
1ms on the same CPU.  Before, 6,647 wakeups were more than 100us late,
the latest by 1,040us, and 2,758 deadlines passed without a wakeup at
all.  After, none were more than 100us late and the latest was 18us.

This mirrors epoll: epoll_pwait2() waits on an hrtimer sleeper, so its
timeout is already hard for real-time tasks, and on the same setup it
was never more than 17us late.

[ 6.12: the wait code is still in io_uring.c, hrtimer_init_on_stack() API ]
Fixes: cebf123c634a ("io_uring: implement our own schedule timeout handling")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Austin Schuh <austin.linux@gmail.com>
Link: https://patch.msgid.link/20261017171726.601443-1-austin.linux@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -48,6 +48,7 @@
 #include <linux/uio.h>
 #include <linux/bits.h>
 
+#include <linux/sched/rt.h>
 #include <linux/sched/signal.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -2495,12 +2496,21 @@ out_wake:
 	return io_cqring_timer_wakeup(timer);
 }
 
+/* Same policy as for hrtimer sleepers, see __hrtimer_setup_sleeper(). */
+static enum hrtimer_mode io_cqring_timer_mode(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && rt_or_dl_task_policy(current))
+		return HRTIMER_MODE_ABS_HARD;
+	return HRTIMER_MODE_ABS;
+}
+
 static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
 				      clockid_t clock_id, ktime_t start_time)
 {
+	enum hrtimer_mode mode = io_cqring_timer_mode();
 	ktime_t timeout;
 
-	hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
+	hrtimer_init_on_stack(&iowq->t, clock_id, mode);
 	if (iowq->min_timeout) {
 		timeout = ktime_add_ns(iowq->min_timeout, start_time);
 		iowq->t.function = io_cqring_min_timer_wakeup;
@@ -2510,7 +2520,7 @@ static int io_cqring_schedule_timeout(st
 	}
 
 	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);
-	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
+	hrtimer_start_expires(&iowq->t, mode);
 
 	if (!READ_ONCE(iowq->hit_timeout))
 		schedule();


