Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6649F286417;
	Mon, 23 Mar 2026 14:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274889; cv=none; b=Kmj1i/GwS/RdBRdjx3l6cXE9q7G3fxCYHO8cRf/ZOWmhnqPkBJdUoT1pVboB/+Eyezlhmkcfq2s0X1ajmRbfu2/SMCpsPw94A/Ol5m14gt179fVwU/mg5VCu+HcqDebIYKZ95y6ffw1p/dYFt1lNCUnHia0WOpimL1DfiJ6TEfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274889; c=relaxed/simple;
	bh=dQJbVBzld0kcIKB2bV/LkDLBsGqAKov9aEiQ8CVcRBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsdTt5KItYYFiOQvnDW4O2rR7cMEUdIXAUFmbF4KV91GYSz6UWxGHiQ4U3XqA2kxQQE6K5HRM+Jd35XYXgQ31KJXrZyVG7yl9KFr2Cfuv+/Mv3wQnZMbdnaBrPGGLXMQuy1zY39xJiVEj3FHRol8oQOc3eICoab6g30zvHoI3ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTLVoyCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTLVoyCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEDFC4CEF7;
	Mon, 23 Mar 2026 14:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274889;
	bh=dQJbVBzld0kcIKB2bV/LkDLBsGqAKov9aEiQ8CVcRBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTLVoyCjJ+aW0T4x3+8MfjMcy6c4vFUtGQyFJ8WRek1wb2BGicSy8Lvr3NqdXF7jl
	 7F0mKwWd759e+k3KGg0VZtAZw9+MHEZcFYwcrGnvozfns+yguCKAu+Up7S83bCEXKi
	 Iwq8wrSwGDU8yFLlDj2eUaRxZ6o681Q/lk84kND8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Qais Yousef <qyousef@layalina.io>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/212] sched: idle: Consolidate the handling of two special cases
Date: Mon, 23 Mar 2026 14:46:06 +0100
Message-ID: <20260323134508.354507508@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit f4c31b07b136839e0fb3026f8a5b6543e3b14d2f ]

There are two special cases in the idle loop that are handled
inconsistently even though they are analogous.

The first one is when a cpuidle driver is absent and the default CPU
idle time power management implemented by the architecture code is used.
In that case, the scheduler tick is stopped every time before invoking
default_idle_call().

The second one is when a cpuidle driver is present, but there is only
one idle state in its table.  In that case, the scheduler tick is never
stopped at all.

Since each of these approaches has its drawbacks, reconcile them with
the help of one simple heuristic.  Namely, stop the tick if the CPU has
been woken up by it in the previous iteration of the idle loop, or let
it tick otherwise.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Qais Yousef <qyousef@layalina.io>
Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Fixes: ed98c3491998 ("sched: idle: Do not stop the tick before cpuidle_idle_call()")
[ rjw: Added Fixes tag, changelog edits ]
Link: https://patch.msgid.link/4741364.LvFx2qVVIh@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/idle.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index d9c515da328e5..bf92ae29361ed 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -160,6 +160,14 @@ static int call_cpuidle(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	return cpuidle_enter(drv, dev, next_state);
 }
 
+static void idle_call_stop_or_retain_tick(bool stop_tick)
+{
+	if (stop_tick || tick_nohz_tick_stopped())
+		tick_nohz_idle_stop_tick();
+	else
+		tick_nohz_idle_retain_tick();
+}
+
 /**
  * cpuidle_idle_call - the main idle function
  *
@@ -169,7 +177,7 @@ static int call_cpuidle(struct cpuidle_driver *drv, struct cpuidle_device *dev,
  * set, and it returns with polling set.  If it ever stops polling, it
  * must clear the polling bit.
  */
-static void cpuidle_idle_call(void)
+static void cpuidle_idle_call(bool stop_tick)
 {
 	struct cpuidle_device *dev = cpuidle_get_device();
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
@@ -185,7 +193,7 @@ static void cpuidle_idle_call(void)
 	}
 
 	if (cpuidle_not_available(drv, dev)) {
-		tick_nohz_idle_stop_tick();
+		idle_call_stop_or_retain_tick(stop_tick);
 
 		default_idle_call();
 		goto exit_idle;
@@ -220,17 +228,19 @@ static void cpuidle_idle_call(void)
 		next_state = cpuidle_find_deepest_state(drv, dev, max_latency_ns);
 		call_cpuidle(drv, dev, next_state);
 	} else if (drv->state_count > 1) {
-		bool stop_tick = true;
+		/*
+		 * stop_tick is expected to be true by default by cpuidle
+		 * governors, which allows them to select idle states with
+		 * target residency above the tick period length.
+		 */
+		stop_tick = true;
 
 		/*
 		 * Ask the cpuidle framework to choose a convenient idle state.
 		 */
 		next_state = cpuidle_select(drv, dev, &stop_tick);
 
-		if (stop_tick || tick_nohz_tick_stopped())
-			tick_nohz_idle_stop_tick();
-		else
-			tick_nohz_idle_retain_tick();
+		idle_call_stop_or_retain_tick(stop_tick);
 
 		entered_state = call_cpuidle(drv, dev, next_state);
 		/*
@@ -238,7 +248,7 @@ static void cpuidle_idle_call(void)
 		 */
 		cpuidle_reflect(dev, entered_state);
 	} else {
-		tick_nohz_idle_retain_tick();
+		idle_call_stop_or_retain_tick(stop_tick);
 
 		/*
 		 * If there is only a single idle state (or none), there is
@@ -266,6 +276,7 @@ static void cpuidle_idle_call(void)
 static void do_idle(void)
 {
 	int cpu = smp_processor_id();
+	bool got_tick = false;
 
 	/*
 	 * Check if we need to update blocked load
@@ -336,8 +347,9 @@ static void do_idle(void)
 			tick_nohz_idle_restart_tick();
 			cpu_idle_poll();
 		} else {
-			cpuidle_idle_call();
+			cpuidle_idle_call(got_tick);
 		}
+		got_tick = tick_nohz_idle_got_tick();
 		arch_cpu_idle_exit();
 	}
 
-- 
2.51.0



