Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D5946C4D8;
	Tue, 21 Jul 2026 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655437; cv=none; b=rPSkkchEU/Elb920/vvIs61VPwP+hkwiFjiQuq9W+edwh7P3prB9KEaZJ3+akuz8Vdz5MonRGIMdichuPl9qZ8jngTMlF7gJLrZUbWwfvLwASnwJymQJd31mDo75Rwx7m5qFCmRJsV2vncUoxjUIxnLbkJaIj5Qemgoq5rtvJZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655437; c=relaxed/simple;
	bh=xOiT0mH4IEIxr4V2ENRAjJMYojO0vSDawCMd4Li85IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpEjZib/a/SIYiwbHg8PnDHar4jC9Sr4hXE0lr4nuuuZ1A+CEwcs+jzh7Tze0Ik8uSNyiSESEoF9klSQFX5XF28meD/qqggW1XAb7CtJHxrakklHy5Q40azNHEqBQIQfYik2CZwNDkSkihl/cPKAEiTMuY++EzsE6/4vcFLaqjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OYG62gU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OYG62gU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF301F000E9;
	Tue, 21 Jul 2026 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655436;
	bh=QCrWjyvdzLMSavWBQ/TqXZZ2fk3kd869JDodFKCp85I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OYG62gUVRqUKhZ9FXQTrgcLiJwwt6Lc9kVn/1+rUpkGGeasiBXpaex0U9c0jXS+n
	 /mNAgPYgwNOd8YJqUn813dyroIux913Ki1UUpdak3sT00LBK+e0CtXjAa9pKCyzLil
	 R+/nT/2qnSBsycBdqmfcvqfiJVgnhgwuvJWoNziU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 7.1 2076/2077] posix-timers: Expand timer_[re]arm() callbacks with a boolean return value
Date: Tue, 21 Jul 2026 17:29:09 +0200
Message-ID: <20260721152641.671701016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

commit 6fdb2677a594ab38eade927919bbd4d9688bfa1c upstream.

In order to catch expiry times which are already in the past the
timer_arm() and timer_rearm() callbacks need to be able to report back to
the caller whether the timer has been queued or not.

Change the function signature and let all implementations return true for
now. While at it simplify posix_cpu_timer_rearm().

No functional change intended.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/20260408114952.130222296@kernel.org
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/alarmtimer.c       |    6 ++++--
 kernel/time/posix-cpu-timers.c |   18 ++++++++++--------
 kernel/time/posix-timers.c     |    6 ++++--
 kernel/time/posix-timers.h     |    4 ++--
 4 files changed, 20 insertions(+), 14 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -525,12 +525,13 @@ static void alarm_handle_timer(struct al
  * alarm_timer_rearm - Posix timer callback for rearming timer
  * @timr:	Pointer to the posixtimer data struct
  */
-static void alarm_timer_rearm(struct k_itimer *timr)
+static bool alarm_timer_rearm(struct k_itimer *timr)
 {
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
 
 	timr->it_overrun += alarm_forward_now(alarm, timr->it_interval);
 	alarm_start(alarm, alarm->node.expires);
+	return true;
 }
 
 /**
@@ -586,7 +587,7 @@ static void alarm_timer_wait_running(str
  * @absolute:	Expiry value is absolute time
  * @sigev_none:	Posix timer does not deliver signals
  */
-static void alarm_timer_arm(struct k_itimer *timr, ktime_t expires,
+static bool alarm_timer_arm(struct k_itimer *timr, ktime_t expires,
 			    bool absolute, bool sigev_none)
 {
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
@@ -598,6 +599,7 @@ static void alarm_timer_arm(struct k_iti
 		alarm->node.expires = expires;
 	else
 		alarm_start(&timr->it.alarm.alarmtimer, expires);
+	return true;
 }
 
 /**
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -19,7 +19,7 @@
 
 #include "posix-timers.h"
 
-static void posix_cpu_timer_rearm(struct k_itimer *timer);
+static bool posix_cpu_timer_rearm(struct k_itimer *timer);
 
 void posix_cputimers_group_init(struct posix_cputimers *pct, u64 cpu_limit)
 {
@@ -1011,24 +1011,27 @@ static void check_process_timers(struct
 /*
  * This is called from the signal code (via posixtimer_rearm)
  * when the last timer signal was delivered and we have to reload the timer.
+ *
+ * Return true unconditionally so the core code assumes the timer to be
+ * armed. Otherwise it would requeue the signal.
  */
-static void posix_cpu_timer_rearm(struct k_itimer *timer)
+static bool posix_cpu_timer_rearm(struct k_itimer *timer)
 {
 	clockid_t clkid = CPUCLOCK_WHICH(timer->it_clock);
-	struct task_struct *p;
 	struct sighand_struct *sighand;
+	struct task_struct *p;
 	unsigned long flags;
 	u64 now;
 
-	rcu_read_lock();
+	guard(rcu)();
 	p = cpu_timer_task_rcu(timer);
 	if (!p)
-		goto out;
+		return true;
 
 	/* Protect timer list r/w in arm_timer() */
 	sighand = lock_task_sighand(p, &flags);
 	if (unlikely(sighand == NULL))
-		goto out;
+		return true;
 
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
@@ -1045,8 +1048,7 @@ static void posix_cpu_timer_rearm(struct
 	 */
 	arm_timer(timer, p);
 	unlock_task_sighand(p, &flags);
-out:
-	rcu_read_unlock();
+	return true;
 }
 
 /**
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -288,12 +288,13 @@ static inline int timer_overrun_to_int(s
 	return (int)timr->it_overrun_last;
 }
 
-static void common_hrtimer_rearm(struct k_itimer *timr)
+static bool common_hrtimer_rearm(struct k_itimer *timr)
 {
 	struct hrtimer *timer = &timr->it.real.timer;
 
 	timr->it_overrun += hrtimer_forward_now(timer, timr->it_interval);
 	hrtimer_restart(timer);
+	return true;
 }
 
 static bool __posixtimer_deliver_signal(struct kernel_siginfo *info, struct k_itimer *timr)
@@ -795,7 +796,7 @@ SYSCALL_DEFINE1(timer_getoverrun, timer_
 		return timer_overrun_to_int(scoped_timer);
 }
 
-static void common_hrtimer_arm(struct k_itimer *timr, ktime_t expires,
+static bool common_hrtimer_arm(struct k_itimer *timr, ktime_t expires,
 			       bool absolute, bool sigev_none)
 {
 	struct hrtimer *timer = &timr->it.real.timer;
@@ -822,6 +823,7 @@ static void common_hrtimer_arm(struct k_
 
 	if (!sigev_none)
 		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
+	return true;
 }
 
 static int common_hrtimer_try_to_cancel(struct k_itimer *timr)
--- a/kernel/time/posix-timers.h
+++ b/kernel/time/posix-timers.h
@@ -27,11 +27,11 @@ struct k_clock {
 	int	(*timer_del)(struct k_itimer *timr);
 	void	(*timer_get)(struct k_itimer *timr,
 			     struct itimerspec64 *cur_setting);
-	void	(*timer_rearm)(struct k_itimer *timr);
+	bool	(*timer_rearm)(struct k_itimer *timr);
 	s64	(*timer_forward)(struct k_itimer *timr, ktime_t now);
 	ktime_t	(*timer_remaining)(struct k_itimer *timr, ktime_t now);
 	int	(*timer_try_to_cancel)(struct k_itimer *timr);
-	void	(*timer_arm)(struct k_itimer *timr, ktime_t expires,
+	bool	(*timer_arm)(struct k_itimer *timr, ktime_t expires,
 			     bool absolute, bool sigev_none);
 	void	(*timer_wait_running)(struct k_itimer *timr);
 };


