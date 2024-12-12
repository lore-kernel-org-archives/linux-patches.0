Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7391D20A5EE;
	Thu, 12 Dec 2024 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024864; cv=none; b=XdgxJSmZdEZLK4UFL3BMlgVAdWfF3SY76CWW2pUMCdStrYBXJKfCypRE2XYUjhHL7HSl5Vvqr26acJzUd0ewsrLuWT4JlpKPnVAkbFyHoWWChWI1BAbkt+YWqjFsqfvDoZ7QVnGtKuESpQofHFo6mvteBoiyYzw0pE8F0h/Z6EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024864; c=relaxed/simple;
	bh=TpUSddJXaFAp/Ql+9yeQQ5nPDw4uvh/lqXzMOIOI7ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMj+FltCbQoSo0FXASncXsLpTIydlJ1DhkenukGjJgoCuMlUz1sWQ5uWkf4qDtscw9xixQEry/GN9C2CbjQCtBEe10xAZV2UD+wzuH+18fYdzUA5ydXH7kt6LmmuRF+C5djUDmoqFx5nbiHTX/63Kn7oPe1LrsXmdsWV4GlIhPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZo7cwHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZo7cwHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D250C4CECE;
	Thu, 12 Dec 2024 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024863;
	bh=TpUSddJXaFAp/Ql+9yeQQ5nPDw4uvh/lqXzMOIOI7ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZo7cwHapHb2gd5hL33d6KfJFHu4vYkZufbN1ggngSey01OBrEgkfSlyHsuaIHOa3
	 p/TnRZia8NEfhlfVyg9poMGUJebIdkBuui9roToKthhJGK9AKD0W1+dxANsXhtgaS5
	 5ChBD1U8fEt/6+kVnnGFHfTtvsm2bSFOgXlXwznU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Valentin Schneider <valentin.schneider@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 437/459] sched/fair: Trigger the update of blocked load on newly idle cpu
Date: Thu, 12 Dec 2024 16:02:55 +0100
Message-ID: <20241212144311.018420394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit c6f886546cb8a38617cdbe755fe50d3acd2463e4 ]

Instead of waking up a random and already idle CPU, we can take advantage
of this_cpu being about to enter idle to run the ILB and update the
blocked load.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210224133007.28644-7-vincent.guittot@linaro.org
Stable-dep-of: ff47a0acfcce ("sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  |  2 +-
 kernel/sched/fair.c  | 24 +++++++++++++++++++++---
 kernel/sched/idle.c  |  6 ++++++
 kernel/sched/sched.h |  7 +++++++
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8e30041cecf94..1f4bf91c27d22 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -746,7 +746,7 @@ static void nohz_csd_func(void *info)
 	/*
 	 * Release the rq::nohz_csd.
 	 */
-	flags = atomic_fetch_andnot(NOHZ_KICK_MASK, nohz_flags(cpu));
+	flags = atomic_fetch_andnot(NOHZ_KICK_MASK | NOHZ_NEWILB_KICK, nohz_flags(cpu));
 	WARN_ON(!(flags & NOHZ_KICK_MASK));
 
 	rq->idle_balance = idle_cpu(cpu);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ab29666eb50ed..8121cfd60b8fb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10747,6 +10747,24 @@ static bool nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 	return true;
 }
 
+/*
+ * Check if we need to run the ILB for updating blocked load before entering
+ * idle state.
+ */
+void nohz_run_idle_balance(int cpu)
+{
+	unsigned int flags;
+
+	flags = atomic_fetch_andnot(NOHZ_NEWILB_KICK, nohz_flags(cpu));
+
+	/*
+	 * Update the blocked load only if no SCHED_SOFTIRQ is about to happen
+	 * (ie NOHZ_STATS_KICK set) and will do the same.
+	 */
+	if ((flags == NOHZ_NEWILB_KICK) && !need_resched())
+		_nohz_idle_balance(cpu_rq(cpu), NOHZ_STATS_KICK, CPU_IDLE);
+}
+
 static void nohz_newidle_balance(struct rq *this_rq)
 {
 	int this_cpu = this_rq->cpu;
@@ -10768,10 +10786,10 @@ static void nohz_newidle_balance(struct rq *this_rq)
 		return;
 
 	/*
-	 * Blocked load of idle CPUs need to be updated.
-	 * Kick an ILB to update statistics.
+	 * Set the need to trigger ILB in order to update blocked load
+	 * before entering idle state.
 	 */
-	kick_ilb(NOHZ_STATS_KICK);
+	atomic_or(NOHZ_NEWILB_KICK, nohz_flags(this_cpu));
 }
 
 #else /* !CONFIG_NO_HZ_COMMON */
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 2593a733c0849..cdc3e690de714 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -261,6 +261,12 @@ static void cpuidle_idle_call(void)
 static void do_idle(void)
 {
 	int cpu = smp_processor_id();
+
+	/*
+	 * Check if we need to update blocked load
+	 */
+	nohz_run_idle_balance(cpu);
+
 	/*
 	 * If the arch has a polling bit, we maintain an invariant:
 	 *
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index df6cf8aa59f89..66e3ecb7c10e4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2292,9 +2292,11 @@ extern void cfs_bandwidth_usage_dec(void);
 #ifdef CONFIG_NO_HZ_COMMON
 #define NOHZ_BALANCE_KICK_BIT	0
 #define NOHZ_STATS_KICK_BIT	1
+#define NOHZ_NEWILB_KICK_BIT	2
 
 #define NOHZ_BALANCE_KICK	BIT(NOHZ_BALANCE_KICK_BIT)
 #define NOHZ_STATS_KICK		BIT(NOHZ_STATS_KICK_BIT)
+#define NOHZ_NEWILB_KICK	BIT(NOHZ_NEWILB_KICK_BIT)
 
 #define NOHZ_KICK_MASK	(NOHZ_BALANCE_KICK | NOHZ_STATS_KICK)
 
@@ -2305,6 +2307,11 @@ extern void nohz_balance_exit_idle(struct rq *rq);
 static inline void nohz_balance_exit_idle(struct rq *rq) { }
 #endif
 
+#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
+extern void nohz_run_idle_balance(int cpu);
+#else
+static inline void nohz_run_idle_balance(int cpu) { }
+#endif
 
 #ifdef CONFIG_SMP
 static inline
-- 
2.43.0



