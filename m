Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7E3C6A5C;
	Wed, 20 May 2026 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297591; cv=none; b=T1UJEfLopFg5hpBaUEmuflSn5AGhO4bgwe2gzDhjbIAVdCjneoVDt8PqD/W1oG+s4qea1Zz3F/m5/P55Nb5vBONu7UA5bGiSWP0KUHnrjKXSucBcwGZ0baftJxAc4PC+hMCYAD+OSVNEsNouwNqqlqu1PciqLymY9BFH1mmvuYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297591; c=relaxed/simple;
	bh=/IEf8oNfOVcf7DTPYy6WkI21zd4Wgdc+fPOT5+9w0/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYHJbseb7t/7ig1fBlNe7im0MpZ1x4P2wONOtqD98AssvfrG/+yLEvylITa2HM/P5T3AKpAbWRvYx57hCubn0p7H86QLmGVyMQsfdhFhAWS2At99WymNOxFG/Cdap4r7uiXVdiryQYty8yTHF1WtuAnCbn1UzSKw5Z2ptg+z8H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcdVrFgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcdVrFgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AA21F000E9;
	Wed, 20 May 2026 17:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297590;
	bh=p5sDra03FpqmH2lmcSzraBLnr7oQOs0NoHBa6he0Kpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcdVrFgly+1E1U9Cmj1HfD/WrTqryiaktwrVSWRX8JrgT2LCkwW0RJDW2+Tvy9/HE
	 yh1O89rmf8It1HpgB0YJ6b9KsSD75xhYgp6uTxsxPRB2NDGsRDgaTM9yBLXkdTK2Jq
	 bl2RU9QAyq3jC7UzB8h7h8S4MT14Twfd9od7tpvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/957] hrtimer: Reduce trace noise in hrtimer_start()
Date: Wed, 20 May 2026 18:08:40 +0200
Message-ID: <20260520162135.362413246@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit f2e388a019e4cf83a15883a3d1f1384298e9a6aa ]

hrtimer_start() when invoked with an already armed timer traces like:

 <comm>-..   [032] d.h2. 5.002263: hrtimer_cancel: hrtimer= ....
 <comm>-..   [032] d.h1. 5.002263: hrtimer_start: hrtimer= ....

Which is incorrect as the timer doesn't get canceled. Just the expiry time
changes. The internal dequeue operation which is required for that is not
really interesting for trace analysis. But it makes it tedious to keep real
cancellations and the above case apart.

Remove the cancel tracing in hrtimer_start() and add a 'was_armed'
indicator to the hrtimer start tracepoint, which clearly indicates what the
state of the hrtimer is when hrtimer_start() is invoked:

<comm>-..   [032] d.h1. 6.200103: hrtimer_start: hrtimer= .... was_armed=0
 <comm>-..   [032] d.h1. 6.200558: hrtimer_start: hrtimer= .... was_armed=1

Fixes: c6a2a1770245 ("hrtimer: Add tracepoint for hrtimers")
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260224163430.208491877@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/timer.h | 11 +++++----
 kernel/time/hrtimer.c        | 43 +++++++++++++++++-------------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 1641ae3e6ca06..ab9a9386f7b65 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -218,12 +218,13 @@ TRACE_EVENT(hrtimer_setup,
  * hrtimer_start - called when the hrtimer is started
  * @hrtimer:	pointer to struct hrtimer
  * @mode:	the hrtimers mode
+ * @was_armed:	Was armed when hrtimer_start*() was invoked
  */
 TRACE_EVENT(hrtimer_start,
 
-	TP_PROTO(struct hrtimer *hrtimer, enum hrtimer_mode mode),
+	TP_PROTO(struct hrtimer *hrtimer, enum hrtimer_mode mode, bool was_armed),
 
-	TP_ARGS(hrtimer, mode),
+	TP_ARGS(hrtimer, mode, was_armed),
 
 	TP_STRUCT__entry(
 		__field( void *,	hrtimer		)
@@ -231,6 +232,7 @@ TRACE_EVENT(hrtimer_start,
 		__field( s64,		expires		)
 		__field( s64,		softexpires	)
 		__field( enum hrtimer_mode,	mode	)
+		__field( bool,		was_armed	)
 	),
 
 	TP_fast_assign(
@@ -239,13 +241,14 @@ TRACE_EVENT(hrtimer_start,
 		__entry->expires	= hrtimer_get_expires(hrtimer);
 		__entry->softexpires	= hrtimer_get_softexpires(hrtimer);
 		__entry->mode		= mode;
+		__entry->was_armed	= was_armed;
 	),
 
 	TP_printk("hrtimer=%p function=%ps expires=%llu softexpires=%llu "
-		  "mode=%s", __entry->hrtimer, __entry->function,
+		  "mode=%s was_armed=%d", __entry->hrtimer, __entry->function,
 		  (unsigned long long) __entry->expires,
 		  (unsigned long long) __entry->softexpires,
-		  decode_hrtimer_mode(__entry->mode))
+		  decode_hrtimer_mode(__entry->mode), __entry->was_armed)
 );
 
 /**
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 2589cd1b2ec3a..1f602deeb09a4 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -471,17 +471,10 @@ static inline void debug_setup_on_stack(struct hrtimer *timer, clockid_t clockid
 	trace_hrtimer_setup(timer, clockid, mode);
 }
 
-static inline void debug_activate(struct hrtimer *timer,
-				  enum hrtimer_mode mode)
+static inline void debug_activate(struct hrtimer *timer, enum hrtimer_mode mode, bool was_armed)
 {
 	debug_hrtimer_activate(timer, mode);
-	trace_hrtimer_start(timer, mode);
-}
-
-static inline void debug_deactivate(struct hrtimer *timer)
-{
-	debug_hrtimer_deactivate(timer);
-	trace_hrtimer_cancel(timer);
+	trace_hrtimer_start(timer, mode, was_armed);
 }
 
 static struct hrtimer_clock_base *
@@ -1076,9 +1069,9 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
  * Returns true when the new timer is the leftmost timer in the tree.
  */
 static bool enqueue_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base,
-			    enum hrtimer_mode mode)
+			    enum hrtimer_mode mode, bool was_armed)
 {
-	debug_activate(timer, mode);
+	debug_activate(timer, mode, was_armed);
 	WARN_ON_ONCE(!base->cpu_base->online);
 
 	base->cpu_base->active_bases |= 1 << base->index;
@@ -1138,6 +1131,8 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base,
 	if (state & HRTIMER_STATE_ENQUEUED) {
 		bool reprogram;
 
+		debug_hrtimer_deactivate(timer);
+
 		/*
 		 * Remove the timer and force reprogramming when high
 		 * resolution mode is active and the timer is on the current
@@ -1146,7 +1141,6 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base,
 		 * reprogramming happens in the interrupt handler. This is a
 		 * rare case and less expensive than a smp call.
 		 */
-		debug_deactivate(timer);
 		reprogram = base->cpu_base == this_cpu_ptr(&hrtimer_bases);
 
 		/*
@@ -1213,15 +1207,15 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 {
 	struct hrtimer_cpu_base *this_cpu_base = this_cpu_ptr(&hrtimer_bases);
 	struct hrtimer_clock_base *new_base;
-	bool force_local, first;
+	bool force_local, first, was_armed;
 
 	/*
 	 * If the timer is on the local cpu base and is the first expiring
 	 * timer then this might end up reprogramming the hardware twice
-	 * (on removal and on enqueue). To avoid that by prevent the
-	 * reprogram on removal, keep the timer local to the current CPU
-	 * and enforce reprogramming after it is queued no matter whether
-	 * it is the new first expiring timer again or not.
+	 * (on removal and on enqueue). To avoid that prevent the reprogram
+	 * on removal, keep the timer local to the current CPU and enforce
+	 * reprogramming after it is queued no matter whether it is the new
+	 * first expiring timer again or not.
 	 */
 	force_local = base->cpu_base == this_cpu_base;
 	force_local &= base->cpu_base->next_timer == timer;
@@ -1243,7 +1237,7 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 * avoids programming the underlying clock event twice (once at
 	 * removal and once after enqueue).
 	 */
-	remove_hrtimer(timer, base, true, force_local);
+	was_armed = remove_hrtimer(timer, base, true, force_local);
 
 	if (mode & HRTIMER_MODE_REL)
 		tim = ktime_add_safe(tim, __hrtimer_cb_get_time(base->clockid));
@@ -1260,7 +1254,7 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		new_base = base;
 	}
 
-	first = enqueue_hrtimer(timer, new_base, mode);
+	first = enqueue_hrtimer(timer, new_base, mode, was_armed);
 
 	/*
 	 * If the hrtimer interrupt is running, then it will reevaluate the
@@ -1362,8 +1356,11 @@ int hrtimer_try_to_cancel(struct hrtimer *timer)
 
 	base = lock_hrtimer_base(timer, &flags);
 
-	if (!hrtimer_callback_running(timer))
+	if (!hrtimer_callback_running(timer)) {
 		ret = remove_hrtimer(timer, base, false, false);
+		if (ret)
+			trace_hrtimer_cancel(timer);
+	}
 
 	unlock_hrtimer_base(timer, &flags);
 
@@ -1799,7 +1796,7 @@ static void __run_hrtimer(struct hrtimer_cpu_base *cpu_base,
 	 */
 	if (restart != HRTIMER_NORESTART &&
 	    !(timer->state & HRTIMER_STATE_ENQUEUED))
-		enqueue_hrtimer(timer, base, HRTIMER_MODE_ABS);
+		enqueue_hrtimer(timer, base, HRTIMER_MODE_ABS, false);
 
 	/*
 	 * Separate the ->running assignment from the ->state assignment.
@@ -2278,7 +2275,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 	while ((node = timerqueue_getnext(&old_base->active))) {
 		timer = container_of(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
-		debug_deactivate(timer);
+		debug_hrtimer_deactivate(timer);
 
 		/*
 		 * Mark it as ENQUEUED not INACTIVE otherwise the
@@ -2295,7 +2292,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		 * sort out already expired timers and reprogram the
 		 * event device.
 		 */
-		enqueue_hrtimer(timer, new_base, HRTIMER_MODE_ABS);
+		enqueue_hrtimer(timer, new_base, HRTIMER_MODE_ABS, true);
 	}
 }
 
-- 
2.53.0



