Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020653;
	b=i2e7L9jYIZcr6dYQS6Ivpf/78XNRV6lchvxE2G/TcxTgo7T8luNfHA+lnVhW+kr0iDnL
	 IXI2FaAlES3nMVlCr4aM4lioxQWKe+HQBP9rCEiZQQAhx6fNdM6XGWuLxLOMQ+f3PKB7R
	 R4ynoSO1xQYi3h4G0+dTuq3dO8bP4NxB3EY76y9hEDLG3CdB08MMU1rTXLVhV35KqW4UE
	 LlsXd1NNvHvRmCCszGIaATOrMOhU1job9pbVglXaLTx2dLBHlCITV1S17IBqNkYGNDYr6
	 Fxc2kvw+ApVfjO7U3pcu2LRfHT8NJ4f7Nz0vOftfOYh1Z1uG5A55DIlJ14MHWAgppzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o1POwUOc5optfjJ+UUUWsBDoqh5lpXnAcSU6rKwJxHA=;
	b=2jBv3MPDMx5uhX9GXoHaeH07WPYjp2Pbz5IbuxVBRGD6Eyy10W1AHDZX6jrL1sk93zYw
	 I1/b6jFoqYTF9hlkWO4XlCog2w+KAwMZr83QpIYs3zyDYLilwYT4JFs3G1miAa05MBUoq
	 51ceNtTVUncJ4S/F0mePEPH97pUkg3V6tJzmciRmvR0PMLw/9HptX70koSTRes8Rlg/TG
	 Phim6W8t0A0eh1pUI4SobSHzf2TRcmnC8CakeeRhuPw3ocKVQ5NTpvDrOXDGJQmMIv3qT
	 YEGj3gh69jN+QlN+RJYZqu602G0lSjXG5n+diHvhIF69c7jWy3bBrKjj5SdC5nTWMtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z9jTEg1d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D62660A262D;
	Wed, 18 Nov 2026 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z9jTEg1d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F3F1F00927;
	Wed, 18 Nov 2026 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020653;
	bh=o1POwUOc5optfjJ+UUUWsBDoqh5lpXnAcSU6rKwJxHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9jTEg1dujPqZFSKMIWp2Vp/Q8EKfOTcfp3CV8n2J4z1Kn2XgZvhTOUQhFJ+vW/YM
	 5jTQWJagKUWUYSJTwtvT2yMjT2EBPjsNwlGxsufAkhoPzxflTzLbfO4c2IzUkQp1ee
	 Rru6MyY5nk6Bg9zR2j5fk0KSr5btwItX7v3OeGDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stian Halseth <stian@itx.no>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2028/2651] sched/cputime: Dont account idle time twice after dyntick-idle
Date: Wed, 18 Nov 2026 15:54:28 +0100
Message-ID: <20261118150359.176635284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Stian Halseth <stian@itx.no>

[ Upstream commit 96a494c9cfd8f4bb7b1a7a70275426db71cf98aa ]

On idle exit the dyntick-idle accounting accounts the time up to now,
then the tick is restarted on its old period. The first tick accounts a
whole TICK_NSEC to whatever runs, although the part of that period
before the idle exit has just been accounted as idle time, or with
IRQ_TIME_ACCOUNTING as IRQ time. That is up to a full tick per idle
exit, and /proc/stat reports more idle time than wall time.

Record how much of the current tick period dyntick-idle has accounted,
and leave it out of the tick that ends the period.

Fixes: cf6444c3e1bb7 ("tick/sched: Unify idle cputime accounting")
Signed-off-by: Stian Halseth <stian@itx.no>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/all/20261004142724.3896396-1-stian@itx.no/
Link: https://patch.msgid.link/20261007142950.547604-1-stian@itx.no
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kernel_stat.h |  7 +++++--
 kernel/sched/cputime.c      | 39 +++++++++++++++++++++++++++++++------
 kernel/time/tick-sched.c    | 22 ++++++++++++++++-----
 3 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 9ca6c2259dfea..6e252048b5ade 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -40,6 +40,9 @@ struct kernel_cpustat {
 	seqcount_t	idle_sleeptime_seq;
 	u64		idle_entrytime;
 	u64		idle_stealtime[2];
+	u64		idle_dyntick_entry;
+	u64		idle_tick_period;
+	u64		idle_tick_overlap;
 #endif
 	u64		cpustat[NR_STATS];
 };
@@ -111,7 +114,7 @@ static inline unsigned long kstat_cpu_irqs_sum(unsigned int cpu)
 #ifdef CONFIG_HAVE_VIRT_CPU_ACCOUNTING_IDLE
 
 static inline void kcpustat_dyntick_start(u64 now) { }
-static inline void kcpustat_dyntick_stop(u64 now) { }
+static inline void kcpustat_dyntick_stop(u64 now, u64 tick_start) { }
 static inline void kcpustat_irq_enter(u64 now) { }
 static inline void kcpustat_irq_exit(u64 now) { }
 static inline bool kcpustat_idle_dyntick(void) { return false; }
@@ -132,7 +135,7 @@ static inline u64 kcpustat_field_iowait(int cpu)
 #else /* !CONFIG_HAVE_VIRT_CPU_ACCOUNTING_IDLE */
 
 extern void kcpustat_dyntick_start(u64 now);
-extern void kcpustat_dyntick_stop(u64 now);
+extern void kcpustat_dyntick_stop(u64 now, u64 tick_start);
 extern void kcpustat_irq_enter(u64 now);
 extern void kcpustat_irq_exit(u64 now);
 extern u64 kcpustat_field_idle(int cpu);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 06bddaa738e52..faac7c2066d84 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -381,9 +381,9 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
  * softirq as those do not count in task exec_runtime any more.
  */
 static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-					 int ticks)
+					 u64 cputime)
 {
-	u64 other, cputime = TICK_NSEC * ticks;
+	u64 other;
 
 	/*
 	 * When returning from idle, many ticks can get accounted at
@@ -418,7 +418,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 
 #else /* !CONFIG_IRQ_TIME_ACCOUNTING: */
 static inline void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-						int nr_ticks) { }
+						u64 cputime) { }
 #endif /* !CONFIG_IRQ_TIME_ACCOUNTING */
 
 #if defined(CONFIG_NO_HZ_COMMON) && !defined(CONFIG_HAVE_VIRT_CPU_ACCOUNTING_IDLE)
@@ -468,18 +468,38 @@ static void kcpustat_idle_start(struct kernel_cpustat *kc, u64 now)
 	write_seqcount_end(&kc->idle_sleeptime_seq);
 }
 
-void kcpustat_dyntick_stop(u64 now)
+void kcpustat_dyntick_stop(u64 now, u64 tick_start)
 {
 	struct kernel_cpustat *kc = kcpustat_this_cpu;
 
 	if (!vtime_generic_enabled_this_cpu()) {
 		WARN_ON_ONCE(!kc->idle_dyntick);
+		if (kc->idle_tick_period != tick_start) {
+			kc->idle_tick_period = tick_start;
+			kc->idle_tick_overlap = 0;
+		}
+		tick_start = max(tick_start, kc->idle_dyntick_entry);
+		if (!WARN_ON_ONCE(now < tick_start))
+			kc->idle_tick_overlap += now - tick_start;
 		kcpustat_idle_stop(kc, now);
 		kc->idle_dyntick = false;
 		vtime_dyntick_stop();
 	}
 }
 
+/*
+ * The first tick after dyntick-idle covers a period that the dyntick-idle
+ * accounting may already have accounted in part.
+ */
+static inline u64 kcpustat_tick_overlap(void)
+{
+	struct kernel_cpustat *kc = kcpustat_this_cpu;
+	u64 overlap = kc->idle_tick_overlap;
+
+	kc->idle_tick_overlap = 0;
+	return overlap;
+}
+
 void kcpustat_dyntick_start(u64 now)
 {
 	struct kernel_cpustat *kc = kcpustat_this_cpu;
@@ -487,6 +507,7 @@ void kcpustat_dyntick_start(u64 now)
 	if (!vtime_generic_enabled_this_cpu()) {
 		vtime_dyntick_start();
 		kc->idle_dyntick = true;
+		kc->idle_dyntick_entry = now;
 		kcpustat_idle_start(kc, now);
 	}
 }
@@ -555,6 +576,11 @@ u64 kcpustat_field_iowait(int cpu)
 }
 EXPORT_SYMBOL_GPL(kcpustat_field_iowait);
 #else
+static inline u64 kcpustat_tick_overlap(void)
+{
+	return 0;
+}
+
 static u64 kcpustat_field_dyntick(int cpu, enum cpu_usage_stat idx,
 				  bool compute_delta, ktime_t now)
 {
@@ -695,12 +721,13 @@ void account_process_tick(struct task_struct *p, int user_tick)
 	if (kcpustat_idle_dyntick())
 		return;
 
+	cputime = TICK_NSEC - kcpustat_tick_overlap();
+
 	if (irqtime_enabled()) {
-		irqtime_account_process_tick(p, user_tick, 1);
+		irqtime_account_process_tick(p, user_tick, cputime);
 		return;
 	}
 
-	cputime = TICK_NSEC;
 	steal = steal_account_process_time(ULONG_MAX);
 
 	if (steal >= cputime)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index baa3ac9b48f88..6546e196645f2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -775,12 +775,18 @@ static ktime_t tick_forward_now(ktime_t expires, ktime_t now)
 	return expires + TICK_NSEC;
 }
 
+static void tick_nohz_forward_last_tick(struct tick_sched *ts, ktime_t now)
+{
+	if (now >= ts->last_tick)
+		ts->last_tick = tick_forward_now(ts->last_tick, now);
+}
+
 static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 {
-	ktime_t expires = ts->last_tick;
+	ktime_t expires;
 
-	if (now >= expires)
-		expires = tick_forward_now(expires, now);
+	tick_nohz_forward_last_tick(ts, now);
+	expires = ts->last_tick;
 
 	if (tick_sched_flag_test(ts, TS_FLAG_HIGHRES)) {
 		hrtimer_start(&ts->sched_timer,	expires, HRTIMER_MODE_ABS_PINNED_HARD);
@@ -1341,6 +1347,12 @@ unsigned long tick_nohz_get_idle_calls_cpu(int cpu)
 	return ts->idle_calls;
 }
 
+static void tick_nohz_dyntick_stop(struct tick_sched *ts, ktime_t now)
+{
+	tick_nohz_forward_last_tick(ts, now);
+	kcpustat_dyntick_stop(now, ts->last_tick - TICK_NSEC);
+}
+
 void tick_nohz_idle_restart_tick(void)
 {
 	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
@@ -1353,7 +1365,7 @@ void tick_nohz_idle_restart_tick(void)
 		 * no tiny amount of idle time is accounted twice.
 		 */
 		ts->idle_entrytime = ktime_get();
-		kcpustat_dyntick_stop(ts->idle_entrytime);
+		tick_nohz_dyntick_stop(ts, ts->idle_entrytime);
 		tick_nohz_restart_sched_tick(ts, ts->idle_entrytime);
 	}
 }
@@ -1397,7 +1409,7 @@ void tick_nohz_idle_exit(void)
 
 	if (tick_sched_flag_test(ts, TS_FLAG_STOPPED)) {
 		now = ktime_get();
-		kcpustat_dyntick_stop(now);
+		tick_nohz_dyntick_stop(ts, now);
 		tick_nohz_idle_update_tick(ts, now);
 	}
 
-- 
2.53.0



