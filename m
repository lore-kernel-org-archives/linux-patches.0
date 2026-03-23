Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E64D274B5C;
	Mon, 23 Mar 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277341; cv=none; b=Ya3+EknRee1haCZppsd69OJcN4n8gu6ucnZ+6xflZafoNthyBXEAcCcC2HFyXWK6z1kcYlRiUko8shPuqNEiqKZp9S6c92xhldUQZUOXA8Jv+90izO5siq3wNppL5lCvQd3RnO0NNyhnNFln6O9yT68a18xf4EMimRYcTq+lYEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277341; c=relaxed/simple;
	bh=+iTzc2mU0QBOzWs9clU9MZBzSoB2rYZsX/RFlOA+mGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxztFWNkMqI/rZ+kMk3wZCFWMzkK8Odp2ikWE4ozTiXBiZugFtGLW4ktHiLnHJW+dq0dWX4RcqkXIgrElkkoVAjwh+Z42juvqKSn0Cmq16+kE7gIo0P9KVmdWtUmucLeAtDsQNAphaOWZdfFm/aV2qew+ZysxMVUGPMHO2Sd/Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgGRXfBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgGRXfBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFE6C4CEF7;
	Mon, 23 Mar 2026 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277341;
	bh=+iTzc2mU0QBOzWs9clU9MZBzSoB2rYZsX/RFlOA+mGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgGRXfBI3Zkdvq03zX4xFKcDjlFy2nRUVkYWdcWo1rBwN1EP/kibotoc/klCHwIYm
	 iolaMQQqYqQgtDtzgNFVg1UrghCBIJDAk9MpEo0H1ZwHe5wvUlBiqr5WPyk8sYvhDT
	 WUYVx4MEOO+gGxovCbFC5FEZnowK+Ib9jHnebkx8=
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
Subject: [PATCH 6.12 403/460] sched: idle: Consolidate the handling of two special cases
Date: Mon, 23 Mar 2026 14:46:39 +0100
Message-ID: <20260323134536.464934475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b6a072a323a44..1f0f0d9a5a5cf 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -155,6 +155,14 @@ static int call_cpuidle(struct cpuidle_driver *drv, struct cpuidle_device *dev,
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
@@ -164,7 +172,7 @@ static int call_cpuidle(struct cpuidle_driver *drv, struct cpuidle_device *dev,
  * set, and it returns with polling set.  If it ever stops polling, it
  * must clear the polling bit.
  */
-static void cpuidle_idle_call(void)
+static void cpuidle_idle_call(bool stop_tick)
 {
 	struct cpuidle_device *dev = cpuidle_get_device();
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
@@ -180,7 +188,7 @@ static void cpuidle_idle_call(void)
 	}
 
 	if (cpuidle_not_available(drv, dev)) {
-		tick_nohz_idle_stop_tick();
+		idle_call_stop_or_retain_tick(stop_tick);
 
 		default_idle_call();
 		goto exit_idle;
@@ -215,17 +223,19 @@ static void cpuidle_idle_call(void)
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
@@ -233,7 +243,7 @@ static void cpuidle_idle_call(void)
 		 */
 		cpuidle_reflect(dev, entered_state);
 	} else {
-		tick_nohz_idle_retain_tick();
+		idle_call_stop_or_retain_tick(stop_tick);
 
 		/*
 		 * If there is only a single idle state (or none), there is
@@ -261,6 +271,7 @@ static void cpuidle_idle_call(void)
 static void do_idle(void)
 {
 	int cpu = smp_processor_id();
+	bool got_tick = false;
 
 	/*
 	 * Check if we need to update blocked load
@@ -332,8 +343,9 @@ static void do_idle(void)
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



