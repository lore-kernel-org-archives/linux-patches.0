Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0383714A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARctGKJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716C8C433C7;
	Mon, 23 Oct 2023 11:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059686;
	bh=xXM6jvPdNxtGxUgQIA0TsNKPUl1M06ndFp8nMmSdrD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARctGKJwBm9XnA3dwNMgDGPO1WSxqRhi6VMEdnb8InOh8s4TXuraAB0TpN4zlF5yF
	 yNWeU9wV19ICtx+Mpgl79dwXrKoMLvbJsC+Lrlxdz4Kez8hWu7npdQGSG3KQx1L1xH
	 nsLgJYOErnKonBnp/Jyy5tYEs5yHxErSW22yxBsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Marco Elver <elver@google.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 4.19 19/98] sched,idle,rcu: Push rcu_idle deeper into the idle path
Date: Mon, 23 Oct 2023 12:56:08 +0200
Message-ID: <20231023104814.267567527@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 1098582a0f6c4e8fd28da0a6305f9233d02c9c1d upstream.

Lots of things take locks, due to a wee bug, rcu_lockdep didn't notice
that the locking tracepoints were using RCU.

Push rcu_idle_{enter,exit}() as deep as possible into the idle paths,
this also resolves a lot of _rcuidle()/RCU_NONIDLE() usage.

Specifically, sched_clock_idle_wakeup_event() will use ktime which
will use seqlocks which will tickle lockdep, and
stop_critical_timings() uses lock.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Marco Elver <elver@google.com>
Link: https://lkml.kernel.org/r/20200821085348.310943801@infradead.org
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/cpuidle.c |   12 ++++++++----
 kernel/sched/idle.c       |   22 ++++++++--------------
 2 files changed, 16 insertions(+), 18 deletions(-)

--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -140,13 +140,14 @@ static void enter_s2idle_proper(struct c
 	 * executing it contains RCU usage regarded as invalid in the idle
 	 * context, so tell RCU about that.
 	 */
-	RCU_NONIDLE(tick_freeze());
+	tick_freeze();
 	/*
 	 * The state used here cannot be a "coupled" one, because the "coupled"
 	 * cpuidle mechanism enables interrupts and doing that with timekeeping
 	 * suspended is generally unsafe.
 	 */
 	stop_critical_timings();
+	rcu_idle_enter();
 	drv->states[index].enter_s2idle(dev, drv, index);
 	if (WARN_ON_ONCE(!irqs_disabled()))
 		local_irq_disable();
@@ -155,7 +156,8 @@ static void enter_s2idle_proper(struct c
 	 * first CPU executing it calls functions containing RCU read-side
 	 * critical sections, so tell RCU about that.
 	 */
-	RCU_NONIDLE(tick_unfreeze());
+	rcu_idle_exit();
+	tick_unfreeze();
 	start_critical_timings();
 
 	time_end = ns_to_ktime(local_clock());
@@ -224,16 +226,18 @@ int cpuidle_enter_state(struct cpuidle_d
 	/* Take note of the planned idle state. */
 	sched_idle_set_state(target_state);
 
-	trace_cpu_idle_rcuidle(index, dev->cpu);
+	trace_cpu_idle(index, dev->cpu);
 	time_start = ns_to_ktime(local_clock());
 
 	stop_critical_timings();
+	rcu_idle_enter();
 	entered_state = target_state->enter(dev, drv, index);
+	rcu_idle_exit();
 	start_critical_timings();
 
 	sched_clock_idle_wakeup_event();
 	time_end = ns_to_ktime(local_clock());
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
 
 	/* The cpu is no longer idle or about to enter idle. */
 	sched_idle_set_state(NULL);
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -53,17 +53,18 @@ __setup("hlt", cpu_idle_nopoll_setup);
 
 static noinline int __cpuidle cpu_idle_poll(void)
 {
+	trace_cpu_idle(0, smp_processor_id());
+	stop_critical_timings();
 	rcu_idle_enter();
-	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
-	stop_critical_timings();
 
 	while (!tif_need_resched() &&
-		(cpu_idle_force_poll || tick_check_broadcast_expired()))
+	       (cpu_idle_force_poll || tick_check_broadcast_expired()))
 		cpu_relax();
-	start_critical_timings();
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
+
 	rcu_idle_exit();
+	start_critical_timings();
+	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 
 	return 1;
 }
@@ -90,7 +91,9 @@ void __cpuidle default_idle_call(void)
 		local_irq_enable();
 	} else {
 		stop_critical_timings();
+		rcu_idle_enter();
 		arch_cpu_idle();
+		rcu_idle_exit();
 		start_critical_timings();
 	}
 }
@@ -148,7 +151,6 @@ static void cpuidle_idle_call(void)
 
 	if (cpuidle_not_available(drv, dev)) {
 		tick_nohz_idle_stop_tick();
-		rcu_idle_enter();
 
 		default_idle_call();
 		goto exit_idle;
@@ -166,19 +168,15 @@ static void cpuidle_idle_call(void)
 
 	if (idle_should_enter_s2idle() || dev->use_deepest_state) {
 		if (idle_should_enter_s2idle()) {
-			rcu_idle_enter();
 
 			entered_state = cpuidle_enter_s2idle(drv, dev);
 			if (entered_state > 0) {
 				local_irq_enable();
 				goto exit_idle;
 			}
-
-			rcu_idle_exit();
 		}
 
 		tick_nohz_idle_stop_tick();
-		rcu_idle_enter();
 
 		next_state = cpuidle_find_deepest_state(drv, dev);
 		call_cpuidle(drv, dev, next_state);
@@ -195,8 +193,6 @@ static void cpuidle_idle_call(void)
 		else
 			tick_nohz_idle_retain_tick();
 
-		rcu_idle_enter();
-
 		entered_state = call_cpuidle(drv, dev, next_state);
 		/*
 		 * Give the governor an opportunity to reflect on the outcome
@@ -212,8 +208,6 @@ exit_idle:
 	 */
 	if (WARN_ON_ONCE(irqs_disabled()))
 		local_irq_enable();
-
-	rcu_idle_exit();
 }
 
 /*


