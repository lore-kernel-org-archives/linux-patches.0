Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207346;
	b=J3k+YkGrjc/nS5UdW19snOVcU0FK2YviZiAm7kVmOb7hvRkvsphb69cwkUwkK+v3u6Us
	 zt7Ds15beAFMTsH73bADI8W/ibO9tZOZgGGssqh8Z69OYm9CzZsFBc/Lg0cE7XtzKqNvb
	 FQCkGRrD1XCrtKcDTGe0glNSB7qIY8/q9pTY7a1Rf+B/BN1t8cxV0Bd1OjsPn11JgUsaK
	 HKUbyuKDyE+0U3Me2BuyOjlKT9T0G+tknIEBHxaX9rpIT77PlgdJy8GPB5a8ah59DRb5p
	 6XGFXZPcl4teNd1QpcRYAX83COA1ag7e7T6dJF0L84OApf2GWDuDY2KNF/K062uWoEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pJO5pjcEsR6Gbn9aIk+eaRT/erK2XXB4jSsTidEqal8=;
	b=bcmngfkgxqYTNYjBUolnzLn08174KUD8ggog8J2LB/WIhuAFIP00b7myUf3AM8m534rF
	 XINcjts4HL9T6Vgvt0iwd3ss7NuR1iRchGguyvPhFuhUG1BKlXKmgXxc1bi6CfY27Bb4I
	 eUZT3F1zl/arMfhC3xGrxsTxCjrbZ9rkvInWu1WoZy+7UDYWknT1Efr6U0poik0kU2YGc
	 TpCk7kwVWLHCL+PzI9i4pDlJxHHgZwJTrEn1ZtlCLWGwaliE2ADyrUBFxl2+/OHVukNi2
	 XoXi3e+uQXlLdjZu4eKAlEOZGv4d4AG8ieX0fELLAwqcOvJcV9TdIfumqxTUcAIFG/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muLq8KHv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39677606A31F;
	Wed, 28 Oct 2026 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muLq8KHv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C741F01825;
	Wed, 28 Oct 2026 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207346;
	bh=pJO5pjcEsR6Gbn9aIk+eaRT/erK2XXB4jSsTidEqal8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muLq8KHvbGPOfbO9FWyFKfZIzxJXiBZhf9EwGP2CnTKbZrzsCDzG6P5dpSmCtOPvm
	 Uab6USKzGxooqbi/SH6+e4v4UN+1LtLGuK7hCVc3UOcvL8gSdhQyN9Dmv/8K7UklE4
	 t3V4jM2fWILYTIqnOId43unWgdVaFslVUCTD5kvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austin Schuh <austin.linux@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 66/88] io_uring/wait: wake real-time waiters from hard interrupt context
Date: Wed, 28 Oct 2026 18:00:14 +0100
Message-ID: <20261028165943.668702739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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

Fixes: cebf123c634a ("io_uring: implement our own schedule timeout handling")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Austin Schuh <austin.linux@gmail.com>
Link: https://patch.msgid.link/20261017171726.601443-1-austin.linux@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/wait.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -3,6 +3,7 @@
  * Waiting for completion events
  */
 #include <linux/kernel.h>
+#include <linux/sched/rt.h>
 #include <linux/sched/signal.h>
 #include <linux/io_uring.h>
 #include <linux/time_namespace.h>
@@ -120,23 +121,32 @@ out_wake:
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
 
 	if (iowq->min_timeout) {
 		timeout = ktime_add_ns(iowq->min_timeout, start_time);
 		hrtimer_setup_on_stack(&iowq->t, io_cqring_min_timer_wakeup, clock_id,
-				       HRTIMER_MODE_ABS);
+				       mode);
 	} else {
 		timeout = iowq->timeout;
 		hrtimer_setup_on_stack(&iowq->t, io_cqring_timer_wakeup, clock_id,
-				       HRTIMER_MODE_ABS);
+				       mode);
 	}
 
 	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);
-	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
+	hrtimer_start_expires(&iowq->t, mode);
 
 	if (!READ_ONCE(iowq->hit_timeout))
 		schedule();


