Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A263CF031;
	Mon, 20 Apr 2026 13:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691074; cv=none; b=dKZawuZJPNoWKOSvHsyUqZOYpZ8xt1pLQRN0yLjDBNTCm7Byh60qq9ULgeEzgrO9HgR5YfFE5q35ILUfKHoTKRt+4Bjw6RN2e2KDZhxpPqLl4Q7EkJGiFf9tm+Y30bSzLCI4IbtKIbN7yb+z+OtzWwmCilw5Fm4gVDyrT8FPjqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691074; c=relaxed/simple;
	bh=HFGN5sQH5I3Po8dQv095pPP1AcxCdNtDAd+YZHL3B54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5wJJNgNO/F5KxqZL+6o5XIs87sx1imAsTixbMYoUq9ZfIjkkaFvTQJtoYq2+v483EQlMCDRFzRzhQWa6w2yYAqo1sgolh8QOi61nDKqYXehQWWsliX8xfl4TyTbE0an2Mv9UGBIa+ASkG1MFzkA1ElAzqAQqpJBMwbzgbhhxj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJn541t7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJn541t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D67EC19425;
	Mon, 20 Apr 2026 13:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691074;
	bh=HFGN5sQH5I3Po8dQv095pPP1AcxCdNtDAd+YZHL3B54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJn541t7fcPZjyiClA63Q4zrIX0LIxvM1SeiG02z4RrWoROLQ3LnJdS6N95BKucv+
	 C8MU4c9FjaFLvRyYVQjr7spXMq2DoO3c+/XJyBew8XpkD6IDPQuWEWjP0ysls44iUu
	 LNmkL5YSdk1ZfNveo2JD7HHlbFPX7CSybwnJh5BNSKBZ72/0H+1hH0MJb9pXxqQJ8O
	 rVWQkL9nHoNxw2XhCpsIpYqaSRnqY6mmsvp4aJCBbrXKwyDmTJSizeCmOzYrkDd64N
	 Tsksb7wjDigEMJx6hYHW16F6cRin8LdtFgbrLDJNkHrhg2GyVdNuoc9KPB7onvC3Vq
	 GhqZbfGbbAjsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@kernel.org>,
	Calvin Owens <calvin@wbinvd.org>,
	Borislav Petkov <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	fweisbec@gmail.com,
	mingo@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] clockevents: Prevent timer interrupt starvation
Date: Mon, 20 Apr 2026 09:09:04 -0400
Message-ID: <20260420131539.986432-78-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit d6e152d905bdb1f32f9d99775e2f453350399a6a ]

Calvin reported an odd NMI watchdog lockup which claims that the CPU locked
up in user space. He provided a reproducer, which sets up a timerfd based
timer and then rearms it in a loop with an absolute expiry time of 1ns.

As the expiry time is in the past, the timer ends up as the first expiring
timer in the per CPU hrtimer base and the clockevent device is programmed
with the minimum delta value. If the machine is fast enough, this ends up
in a endless loop of programming the delta value to the minimum value
defined by the clock event device, before the timer interrupt can fire,
which starves the interrupt and consequently triggers the lockup detector
because the hrtimer callback of the lockup mechanism is never invoked.

As a first step to prevent this, avoid reprogramming the clock event device
when:
     - a forced minimum delta event is pending
     - the new expiry delta is less then or equal to the minimum delta

Thanks to Calvin for providing the reproducer and to Borislav for testing
and providing data from his Zen5 machine.

The problem is not limited to Zen5, but depending on the underlying
clock event device (e.g. TSC deadline timer on Intel) and the CPU speed
not necessarily observable.

This change serves only as the last resort and further changes will be made
to prevent this scenario earlier in the call chain as far as possible.

[ tglx: Updated to restore the old behaviour vs. !force and delta <= 0 and
  	fixed up the tick-broadcast handlers as pointed out by Borislav ]

Fixes: d316c57ff6bf ("[PATCH] clockevents: add core functionality")
Reported-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Calvin Owens <calvin@wbinvd.org>
Tested-by: Borislav Petkov <bp@alien8.de>
Link: https://lore.kernel.org/lkml/acMe-QZUel-bBYUh@mozart.vkv.me/
Link: https://patch.msgid.link/20260407083247.562657657@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 include/linux/clockchips.h   |  2 ++
 kernel/time/clockevents.c    | 27 +++++++++++++++++++--------
 kernel/time/hrtimer.c        |  1 +
 kernel/time/tick-broadcast.c |  8 +++++++-
 kernel/time/tick-common.c    |  1 +
 kernel/time/tick-sched.c     |  1 +
 6 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index b0df28ddd394b..50cdc9da8d32a 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -80,6 +80,7 @@ enum clock_event_state {
  * @shift:		nanoseconds to cycles divisor (power of two)
  * @state_use_accessors:current state of the device, assigned by the core code
  * @features:		features
+ * @next_event_forced:	True if the last programming was a forced event
  * @retries:		number of forced programming retries
  * @set_state_periodic:	switch state to periodic
  * @set_state_oneshot:	switch state to oneshot
@@ -108,6 +109,7 @@ struct clock_event_device {
 	u32			shift;
 	enum clock_event_state	state_use_accessors;
 	unsigned int		features;
+	unsigned int		next_event_forced;
 	unsigned long		retries;
 
 	int			(*set_state_periodic)(struct clock_event_device *);
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index a59bc75ab7c5b..e7b0163eeeb44 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -172,6 +172,7 @@ void clockevents_shutdown(struct clock_event_device *dev)
 {
 	clockevents_switch_state(dev, CLOCK_EVT_STATE_SHUTDOWN);
 	dev->next_event = KTIME_MAX;
+	dev->next_event_forced = 0;
 }
 
 /**
@@ -305,7 +306,6 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
 {
 	unsigned long long clc;
 	int64_t delta;
-	int rc;
 
 	if (WARN_ON_ONCE(expires < 0))
 		return -ETIME;
@@ -324,16 +324,27 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
 		return dev->set_next_ktime(expires, dev);
 
 	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
-	if (delta <= 0)
-		return force ? clockevents_program_min_delta(dev) : -ETIME;
 
-	delta = min(delta, (int64_t) dev->max_delta_ns);
-	delta = max(delta, (int64_t) dev->min_delta_ns);
+	/* Required for tick_periodic() during early boot */
+	if (delta <= 0 && !force)
+		return -ETIME;
+
+	if (delta > (int64_t)dev->min_delta_ns) {
+		delta = min(delta, (int64_t) dev->max_delta_ns);
+		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
+		if (!dev->set_next_event((unsigned long) clc, dev))
+			return 0;
+	}
 
-	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
-	rc = dev->set_next_event((unsigned long) clc, dev);
+	if (dev->next_event_forced)
+		return 0;
 
-	return (rc && force) ? clockevents_program_min_delta(dev) : rc;
+	if (dev->set_next_event(dev->min_delta_ticks, dev)) {
+		if (!force || clockevents_program_min_delta(dev))
+			return -ETIME;
+	}
+	dev->next_event_forced = 1;
+	return 0;
 }
 
 /*
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 21b6d93401480..fde64bfed98fe 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1880,6 +1880,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
 	dev->next_event = KTIME_MAX;
+	dev->next_event_forced = 0;
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 	entry_time = now = hrtimer_update_base(cpu_base);
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 0207868c8b4d2..e411a378db949 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -76,8 +76,10 @@ const struct clock_event_device *tick_get_wakeup_device(int cpu)
  */
 static void tick_broadcast_start_periodic(struct clock_event_device *bc)
 {
-	if (bc)
+	if (bc) {
+		bc->next_event_forced = 0;
 		tick_setup_periodic(bc, 1);
+	}
 }
 
 /*
@@ -403,6 +405,7 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 	bool bc_local;
 
 	raw_spin_lock(&tick_broadcast_lock);
+	tick_broadcast_device.evtdev->next_event_forced = 0;
 
 	/* Handle spurious interrupts gracefully */
 	if (clockevent_state_shutdown(tick_broadcast_device.evtdev)) {
@@ -696,6 +699,7 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 
 	raw_spin_lock(&tick_broadcast_lock);
 	dev->next_event = KTIME_MAX;
+	tick_broadcast_device.evtdev->next_event_forced = 0;
 	next_event = KTIME_MAX;
 	cpumask_clear(tmpmask);
 	now = ktime_get();
@@ -1063,6 +1067,7 @@ static void tick_broadcast_setup_oneshot(struct clock_event_device *bc,
 
 
 	bc->event_handler = tick_handle_oneshot_broadcast;
+	bc->next_event_forced = 0;
 	bc->next_event = KTIME_MAX;
 
 	/*
@@ -1175,6 +1180,7 @@ void hotplug_cpu__broadcast_tick_pull(int deadcpu)
 		}
 
 		/* This moves the broadcast assignment to this CPU: */
+		bc->next_event_forced = 0;
 		clockevents_program_event(bc, bc->next_event, 1);
 	}
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 7e33d3f2e889b..b0c669a7745a7 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -110,6 +110,7 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	int cpu = smp_processor_id();
 	ktime_t next = dev->next_event;
 
+	dev->next_event_forced = 0;
 	tick_periodic(cpu);
 
 	/*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 466e083c82721..36f27a8ae6c03 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1482,6 +1482,7 @@ static void tick_nohz_lowres_handler(struct clock_event_device *dev)
 	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	dev->next_event = KTIME_MAX;
+	dev->next_event_forced = 0;
 
 	if (likely(tick_nohz_handler(&ts->sched_timer) == HRTIMER_RESTART))
 		tick_program_event(hrtimer_get_expires(&ts->sched_timer), 1);
-- 
2.53.0

