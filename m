Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F7128312F;
	Mon,  9 Feb 2026 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648789; cv=none; b=EWZX/JjaTk7AXTjm2j94+gAruAV81pO+zO36L3OPbcda4nGRrjAOOM14hXvT9uDvcvjmrUGFD4GrDAbQ+pJcdYpgWD2Ojh6JI0hTn/KTWzqtm+7Iq0TRCb3Nx+/LJIMmvbYpkHmEUpHv2M/NV69ujcz1Jhp7wWTU7Cvd1y7o0RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648789; c=relaxed/simple;
	bh=Bir9FChIjviexzRaB8A+SZKt/T8txJKq5p2yHplAAjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TShnbcpPr9Wl8ALHBMxgpPkVcUrp9dyz3A5rMGrAiIVwIdcW1LtgacsOnAgIYJ0SyrLoxRqOhLIVg0R6slri7sYltw3myAsiWPr9luXdktdnRTm2rir1LALb3TpBHjRHguLwgxmUrOSB1R+iyD6KK4qRg66Pv+yO2jk8jJde2Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVZh6lWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVZh6lWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09540C116C6;
	Mon,  9 Feb 2026 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648789;
	bh=Bir9FChIjviexzRaB8A+SZKt/T8txJKq5p2yHplAAjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVZh6lWfQq3Nybd05fq1pm96/ukFz60XefPI5bglCME3yr8Wsl9TWtVaH4/3KLXkS
	 kY+u4wwhjNWZ/VeHL5waRh7sp/xPqehre1GseiQoKi5GTRI4yYgOtXgp2AsD3TY8y2
	 MVs7A1MjHupGxxGjZS3De8b/c29IWCeQS5IjStU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 5.15 16/75] timers: Silently ignore timers with a NULL function
Date: Mon,  9 Feb 2026 15:24:13 +0100
Message-ID: <20260209142302.428829118@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit d02e382cef06cc73561dd32dfdc171c00dcc416d ]

Tearing down timers which have circular dependencies to other
functionality, e.g. workqueues, where the timer can schedule work and work
can arm timers, is not trivial.

In those cases it is desired to shutdown the timer in a way which prevents
rearming of the timer. The mechanism to do so is to set timer->function to
NULL and use this as an indicator for the timer arming functions to ignore
the (re)arm request.

In preparation for that replace the warnings in the relevant code paths
with checks for timer->function == NULL. If the pointer is NULL, then
discard the rearm request silently.

Add debug_assert_init() instead of the WARN_ON_ONCE(!timer->function)
checks so that debug objects can warn about non-initialized timers.

The warning of debug objects does not warn if timer->function == NULL.  It
warns when timer was not initialized using timer_setup[_on_stack]() or via
DEFINE_TIMER(). If developers fail to enable debug objects and then waste
lots of time to figure out why their non-initialized timer is not firing,
they deserve it. Same for initializing a timer with a NULL function.

Co-developed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
Link: https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
Link: https://lore.kernel.org/r/87wn7kdann.ffs@tglx
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timer.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 5 deletions(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -964,7 +964,7 @@ __mod_timer(struct timer_list *timer, un
 	unsigned int idx = UINT_MAX;
 	int ret = 0;
 
-	BUG_ON(!timer->function);
+	debug_assert_init(timer);
 
 	/*
 	 * This is a common optimization triggered by the networking code - if
@@ -991,6 +991,14 @@ __mod_timer(struct timer_list *timer, un
 		 * dequeue/enqueue dance.
 		 */
 		base = lock_timer_base(timer, &flags);
+		/*
+		 * Has @timer been shutdown? This needs to be evaluated
+		 * while holding base lock to prevent a race against the
+		 * shutdown code.
+		 */
+		if (!timer->function)
+			goto out_unlock;
+
 		forward_timer_base(base);
 
 		if (timer_pending(timer) && (options & MOD_TIMER_REDUCE) &&
@@ -1017,6 +1025,14 @@ __mod_timer(struct timer_list *timer, un
 		}
 	} else {
 		base = lock_timer_base(timer, &flags);
+		/*
+		 * Has @timer been shutdown? This needs to be evaluated
+		 * while holding base lock to prevent a race against the
+		 * shutdown code.
+		 */
+		if (!timer->function)
+			goto out_unlock;
+
 		forward_timer_base(base);
 	}
 
@@ -1075,8 +1091,12 @@ out_unlock:
  * mod_timer_pending() is the same for pending timers as mod_timer(), but
  * will not activate inactive timers.
  *
+ * If @timer->function == NULL then the start operation is silently
+ * discarded.
+ *
  * Return:
- * * %0 - The timer was inactive and not modified
+ * * %0 - The timer was inactive and not modified or was in
+ *	  shutdown state and the operation was discarded
  * * %1 - The timer was active and requeued to expire at @expires
  */
 int mod_timer_pending(struct timer_list *timer, unsigned long expires)
@@ -1102,8 +1122,12 @@ EXPORT_SYMBOL(mod_timer_pending);
  * same timer, then mod_timer() is the only safe way to modify the timeout,
  * since add_timer() cannot modify an already running timer.
  *
+ * If @timer->function == NULL then the start operation is silently
+ * discarded. In this case the return value is 0 and meaningless.
+ *
  * Return:
- * * %0 - The timer was inactive and started
+ * * %0 - The timer was inactive and started or was in shutdown
+ *	  state and the operation was discarded
  * * %1 - The timer was active and requeued to expire at @expires or
  *	  the timer was active and not modified because @expires did
  *	  not change the effective expiry time
@@ -1123,8 +1147,12 @@ EXPORT_SYMBOL(mod_timer);
  * modify an enqueued timer if that would reduce the expiration time. If
  * @timer is not enqueued it starts the timer.
  *
+ * If @timer->function == NULL then the start operation is silently
+ * discarded.
+ *
  * Return:
- * * %0 - The timer was inactive and started
+ * * %0 - The timer was inactive and started or was in shutdown
+ *	  state and the operation was discarded
  * * %1 - The timer was active and requeued to expire at @expires or
  *	  the timer was active and not modified because @expires
  *	  did not change the effective expiry time such that the
@@ -1147,6 +1175,9 @@ EXPORT_SYMBOL(timer_reduce);
  * The @timer->expires and @timer->function fields must be set prior
  * to calling this function.
  *
+ * If @timer->function == NULL then the start operation is silently
+ * discarded.
+ *
  * If @timer->expires is already in the past @timer will be queued to
  * expire at the next timer tick.
  *
@@ -1175,7 +1206,9 @@ void add_timer_on(struct timer_list *tim
 	struct timer_base *new_base, *base;
 	unsigned long flags;
 
-	if (WARN_ON_ONCE(timer_pending(timer) || !timer->function))
+	debug_assert_init(timer);
+
+	if (WARN_ON_ONCE(timer_pending(timer)))
 		return;
 
 	new_base = get_timer_cpu_base(timer->flags, cpu);
@@ -1186,6 +1219,13 @@ void add_timer_on(struct timer_list *tim
 	 * wrong base locked.  See lock_timer_base().
 	 */
 	base = lock_timer_base(timer, &flags);
+	/*
+	 * Has @timer been shutdown? This needs to be evaluated while
+	 * holding base lock to prevent a race against the shutdown code.
+	 */
+	if (!timer->function)
+		goto out_unlock;
+
 	if (base != new_base) {
 		timer->flags |= TIMER_MIGRATING;
 
@@ -1199,6 +1239,7 @@ void add_timer_on(struct timer_list *tim
 
 	debug_timer_activate(timer);
 	internal_add_timer(base, timer);
+out_unlock:
 	raw_spin_unlock_irqrestore(&base->lock, flags);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
@@ -1488,6 +1529,12 @@ static void expire_timers(struct timer_b
 
 		fn = timer->function;
 
+		if (WARN_ON_ONCE(!fn)) {
+			/* Should never happen. Emphasis on should! */
+			base->running_timer = NULL;
+			continue;
+		}
+
 		if (timer->flags & TIMER_IRQSAFE) {
 			raw_spin_unlock(&base->lock);
 			call_timer_fn(timer, fn, baseclk);


