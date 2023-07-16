Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBB68F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08EAC433C8;
	Sun, 16 Jul 2023 20:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539526;
	bh=4rTdc/T2DNXWxcPuwMno5T5ZJrQ9yC3prMiN+PNcexQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C61IgJ2RPi/alOgMUvq/Pwp81CMRTALG9zzyxE98/R3/25AHbmzGQyNKgNg3caS3r
	 L8sNDZeUegaUSnEyyj8E9HRTLY5i+GVOHoleEJSlXDeSb9230m3hBJ6KYwmoemGQCK
	 sf1XpBqF40JesCjBK0jgJt7A5NnqNiindHIvkXeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/591] posix-timers: Prevent RT livelock in itimer_delete()
Date: Sun, 16 Jul 2023 21:42:57 +0200
Message-ID: <20230716194924.866071599@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 9d9e522010eb5685d8b53e8a24320653d9d4cbbf ]

itimer_delete() has a retry loop when the timer is concurrently expired. On
non-RT kernels this just spin-waits until the timer callback has completed,
except for posix CPU timers which have HAVE_POSIX_CPU_TIMERS_TASK_WORK
enabled.

In that case and on RT kernels the existing task could live lock when
preempting the task which does the timer delivery.

Replace spin_unlock() with an invocation of timer_wait_running() to handle
it the same way as the other retry loops in the posix timer code.

Fixes: ec8f954a40da ("posix-timers: Use a callback for cancel synchronization on PREEMPT_RT")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/87v8g7c50d.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 43 +++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 808a247205a9a..ed3c4a9543982 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1037,27 +1037,52 @@ SYSCALL_DEFINE1(timer_delete, timer_t, timer_id)
 }
 
 /*
- * return timer owned by the process, used by exit_itimers
+ * Delete a timer if it is armed, remove it from the hash and schedule it
+ * for RCU freeing.
  */
 static void itimer_delete(struct k_itimer *timer)
 {
-retry_delete:
-	spin_lock_irq(&timer->it_lock);
+	unsigned long flags;
+
+	/*
+	 * irqsave is required to make timer_wait_running() work.
+	 */
+	spin_lock_irqsave(&timer->it_lock, flags);
 
+retry_delete:
+	/*
+	 * Even if the timer is not longer accessible from other tasks
+	 * it still might be armed and queued in the underlying timer
+	 * mechanism. Worse, that timer mechanism might run the expiry
+	 * function concurrently.
+	 */
 	if (timer_delete_hook(timer) == TIMER_RETRY) {
-		spin_unlock_irq(&timer->it_lock);
+		/*
+		 * Timer is expired concurrently, prevent livelocks
+		 * and pointless spinning on RT.
+		 *
+		 * timer_wait_running() drops timer::it_lock, which opens
+		 * the possibility for another task to delete the timer.
+		 *
+		 * That's not possible here because this is invoked from
+		 * do_exit() only for the last thread of the thread group.
+		 * So no other task can access and delete that timer.
+		 */
+		if (WARN_ON_ONCE(timer_wait_running(timer, &flags) != timer))
+			return;
+
 		goto retry_delete;
 	}
 	list_del(&timer->list);
 
-	spin_unlock_irq(&timer->it_lock);
+	spin_unlock_irqrestore(&timer->it_lock, flags);
 	release_posix_timer(timer, IT_ID_SET);
 }
 
 /*
- * This is called by do_exit or de_thread, only when nobody else can
- * modify the signal->posix_timers list. Yet we need sighand->siglock
- * to prevent the race with /proc/pid/timers.
+ * Invoked from do_exit() when the last thread of a thread group exits.
+ * At that point no other task can access the timers of the dying
+ * task anymore.
  */
 void exit_itimers(struct task_struct *tsk)
 {
@@ -1067,10 +1092,12 @@ void exit_itimers(struct task_struct *tsk)
 	if (list_empty(&tsk->signal->posix_timers))
 		return;
 
+	/* Protect against concurrent read via /proc/$PID/timers */
 	spin_lock_irq(&tsk->sighand->siglock);
 	list_replace_init(&tsk->signal->posix_timers, &timers);
 	spin_unlock_irq(&tsk->sighand->siglock);
 
+	/* The timers are not longer accessible via tsk::signal */
 	while (!list_empty(&timers)) {
 		tmr = list_first_entry(&timers, struct k_itimer, list);
 		itimer_delete(tmr);
-- 
2.39.2



