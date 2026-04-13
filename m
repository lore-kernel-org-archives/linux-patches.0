Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DD7317152;
	Mon, 13 Apr 2026 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099199; cv=none; b=h6fn/62pYOtOd1vRnZy2aiunGAmLh1sZlCev2O46rEqacNTJfGFsK0idOh5EEfNDm5zF87nh+U3MR7lTu+xMBiBktziBT859oa6z3J2CbOI1mc1fbKFav+a0SEgjU4t6vDe905ak50HZF9Mk+QebosddesrElSPpQPs1Vy2X+eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099199; c=relaxed/simple;
	bh=Gb6d2S1bFjGYsKfLmqHsVZbqkEYr3pwH75SKEb0aXIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wxn1kqKTLZ7fjbh1/bi+kfXsgDYA6wK7sQ78JTabm5TFbGjZDng1tsw857kVBcUxV8h8DXYEjc5yPv523xooT/wcHf6dlHeCTG0PNBsr4jq7NWTUAGklcrLjuNpollBp5QplshdMAQMSsqQ4SUUBdp7vR+HdY2aUTfg2BQGwiDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DM+5AgyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DM+5AgyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34B1C2BCAF;
	Mon, 13 Apr 2026 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099199;
	bh=Gb6d2S1bFjGYsKfLmqHsVZbqkEYr3pwH75SKEb0aXIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM+5AgySmP43ZsfQtoxT7nqMqzWkoQZmeuiRGTrrl2Uxp7AJZqHLnCYsdhHX3OYDp
	 AtXWuPTRRVB1D6Eg0uacamn+2lhkv9VPmTnTCkDoUB0Gnr4jtHuPJP3C8ixRzU2O9R
	 Txn7w3erRSaUud6e4Wm+3ocKTuGb0bg0KlZqCM/Q=
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
Subject: [PATCH 5.10 215/491] sched: idle: Consolidate the handling of two special cases
Date: Mon, 13 Apr 2026 17:57:40 +0200
Message-ID: <20260413155827.114692256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8c38b4fe9ee72..50b18ba9ca9cd 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -158,6 +158,14 @@ static int call_cpuidle(struct cpuidle_driver *drv, struct cpuidle_device *dev,
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
@@ -167,7 +175,7 @@ static int call_cpuidle(struct cpuidle_driver *drv, struct cpuidle_device *dev,
  * set, and it returns with polling set.  If it ever stops polling, it
  * must clear the polling bit.
  */
-static void cpuidle_idle_call(void)
+static void cpuidle_idle_call(bool stop_tick)
 {
 	struct cpuidle_device *dev = cpuidle_get_device();
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
@@ -189,7 +197,7 @@ static void cpuidle_idle_call(void)
 	 */
 
 	if (cpuidle_not_available(drv, dev)) {
-		tick_nohz_idle_stop_tick();
+		idle_call_stop_or_retain_tick(stop_tick);
 
 		default_idle_call();
 		goto exit_idle;
@@ -224,17 +232,19 @@ static void cpuidle_idle_call(void)
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
@@ -242,7 +252,7 @@ static void cpuidle_idle_call(void)
 		 */
 		cpuidle_reflect(dev, entered_state);
 	} else {
-		tick_nohz_idle_retain_tick();
+		idle_call_stop_or_retain_tick(stop_tick);
 
 		/*
 		 * If there is only a single idle state (or none), there is
@@ -270,6 +280,7 @@ static void cpuidle_idle_call(void)
 static void do_idle(void)
 {
 	int cpu = smp_processor_id();
+	bool got_tick = false;
 
 	/*
 	 * Check if we need to update blocked load
@@ -312,8 +323,9 @@ static void do_idle(void)
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



