Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207068;
	b=Y1UzCmFjzKXMHk4ffchHkmXxUn64RZcFB2cTAbsIatDvoSeReMUpZ2a97CI3i+RF7iyI
	 J0x6YOlhuFPOiGudyhRviP/JofdHxOrpsn9Nnly9ZDO4AkrYQ/ZVyQgy/fAYF58OLoCtk
	 v6zN/NPs1B10AkmP7ddBe2rmXCdfqgIExuvtYCebVYK0Mwzm6cWVADat0vfu+ZvFsqkAH
	 oZR7ZP97MehkxaWkuerTdfmpyxhGgAr+p+llgPKesVhHCyDMmssFA/zxdPKDKNbFXEe2A
	 OAucm1A6qqsy3oyFyImzEQBqizZLgi/qaEo8K0ZhaugYFzmfOx4emsXlSOIPFrCejNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RwI8FZX+87vXHtnnmkCKZFPPsw+oidQ6ZCi7c7FOuwk=;
	b=PKqjPGMQAKK/5OIr0aLdSt7ID4XpuXNtXaorGHuhjgzh1rjTHjLCsHiiyKh777wEi0dQ
	 iPVw0ukZK8u0FI7I6fFpEYbpzXIoZlmycJyAG3rJYRoYNLCZbqoRibhjtomOHfZA3duq/
	 tq25z77VX2uH8uQnBL9jrniE+4TIKq1sYQT/3JEy9oep/ctKQCIOHQOSVeKj0UZRJY/FA
	 p88D+SM2D+TbWLcvMMyU9VuhKw0DqTToYGtseh469KBhxrYoAcAlkHnr3ZeTROTk1JkMN
	 NTXuUC3mMEek4WJDR/BlY8MT1oJ48oB7pCo8h1ZudLbGI5SSECKb64Ha5K0k/lDqSbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJrm6T5B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40710606A31D;
	Wed, 28 Oct 2026 17:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJrm6T5B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544FA1F01825;
	Wed, 28 Oct 2026 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207067;
	bh=RwI8FZX+87vXHtnnmkCKZFPPsw+oidQ6ZCi7c7FOuwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJrm6T5BNbt/bpoHPYZ62JMnN1tgJRB00SoZ7Kj2RJMTOaGNVj8nJoghjYvp3cuBv
	 Hjl6bWyf3TozdPGq4//t3EqZ3mOu0nbPHnQ32vWN6ZLkNmVx1qD1Y3MoKaogm0bf6Z
	 BPya6Vyjcr4ym8jrZSKhEW0+Ukz28F576qCPHJI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austin Schuh <austin.linux@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 15/38] io_uring/wait: wake real-time waiters from hard interrupt context
Date: Wed, 28 Oct 2026 18:00:02 +0100
Message-ID: <20261028165940.784349460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

From: Austin Schuh <austin.linux@gmail.com>

commit 5b01d5955ac206e38097f777eff6ab2a8b948c41 upstream.

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
@@ -112,23 +113,32 @@ out_wake:
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


