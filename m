Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209903;
	b=lU1RQ4p+pnbRY2WLW2qg9GqyxLwqUUPPFgc7g57sxMb9sywtv3W0nLRTuA6tVi1zKV0F
	 dKhjjyImjApj5/AYjr1VM/nlu1sQWq/vvarXu1FBdlP5djNcf5SEh9cs6bC37MoRMuvkD
	 bE3gfKwHFQlqhlE+YcpAC0jfzjFeFecQ+dCoa5Q6Tv7ch/l7q5TDrhu2i733BY1Mr1Usr
	 9fomCgpocBr7AL0UnDVtGb94ADUuR3jLlmYDNeLgE/WzDcav9hmsOSQT0yGXpshYjmrBT
	 1OtmK3IjjM8LqU3FVUzMtDGaeEjN3VsTlAPSqMlv9P9UTDMJlEujs62vWSKYFzPD/UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QU2dpT1PbVvLAcMtVt2d1Nfu3UrTr8ztsKtz1tusRbc=;
	b=ofMX4hB1mgUeJSVtX5qwikv9u7objW0uOpFcFM+GmuUKZlimwvfq1TEysDc7q1iRMnXE
	 UoxCTaRYkRRyxHj+OubNbYmOErTNF2pfyAgp+ayv9nirHB85ne4nd1q+0b+qLHdB+MmAZ
	 XCRcL+4MUqhE+BY3yKgzLESwdRurpqcxdRQ/9a2AZvZomloIhGBq0H6zIONNwOxqXXPLy
	 UEY0CUZZkL/Hyp1yo3BWLqHQXL4oRilEC6NU2XOGWcvKCP/qb6kNXH0ldn7tecmf7zKPi
	 h5tZyyroeoKZ9hrPBmPRkLKDM2J+TR2YYZeoJVhMtoI4krZrGmLUjeBKe1mmhsfpDiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05NAv5wf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6F2606A31A;
	Wed, 28 Oct 2026 17:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05NAv5wf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB5F1F01825;
	Wed, 28 Oct 2026 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209902;
	bh=QU2dpT1PbVvLAcMtVt2d1Nfu3UrTr8ztsKtz1tusRbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05NAv5wfWIQpCtWvS2cNdTYIkH34RhOJZ3mas27PAMaEdYZatpYPy5kyWzuBc0eQ5
	 6ASIkm+r9V96ZR04634GvZ3MQ9eDxwn0ZPoep2iiFK9cOXUE+1xiEOxsjad03owxrw
	 pMxjlMIdXf+Naq+XK/6nCDC2wDcPQSCweyDa34Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austin Schuh <austin.linux@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 087/109] io_uring/wait: wake real-time waiters from hard interrupt context
Date: Wed, 28 Oct 2026 18:01:11 +0100
Message-ID: <20261028165944.404968239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

[ 6.18: the wait code is still in io_uring.c ]
Fixes: cebf123c634a ("io_uring: implement our own schedule timeout handling")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Austin Schuh <austin.linux@gmail.com>
Link: https://patch.msgid.link/20261017171726.601443-1-austin.linux@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -48,6 +48,7 @@
 #include <linux/uio.h>
 #include <linux/bits.h>
 
+#include <linux/sched/rt.h>
 #include <linux/sched/signal.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -2646,23 +2647,32 @@ out_wake:
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


