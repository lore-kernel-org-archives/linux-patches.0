Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB243C2B9C;
	Sat, 30 May 2026 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160919; cv=none; b=sseI8NqL+mXoKKYobZXaZFUmOzmM56VQnmpXIyxiTPtj2KBXB4Ztz7ppi7HxnNxtm7NYsaqNrpAn4yPSm18Fa4DDv5/3XI6r3T5NwZN/QFiJwznhnWDAkQDvf1bjXDnA4Mf5vxkNHMt90s+jCdtzHBTbBaEcOkLxWO+5K14loRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160919; c=relaxed/simple;
	bh=TDe1TXmXnNqbNdaDnmjNK4Ef5Dur6njlQuIeqlGwFdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGU97PjJvMATqRLh4TV8ofjJWyHrQv2sBZKJwz1/cZQg1VGKP1sD947Ws7U8+qsWAuDicDaaT6u4L5vSlEpaDxXmB6xFESBjVjPJNBGqLfXaKUC1nqzP2Dowa6olv0q8jDwwF/y0rQ8bvSviNnS2g6vPWtMU/XMVI3xc5enri70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pVoecjw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pVoecjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102791F00898;
	Sat, 30 May 2026 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160917;
	bh=9j9R2m10vMbIVnDgLBtrqeNYyfgVEv5IuOgUDS7x+/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pVoecjwvI1uJzpqji38/xHEnbpuLIomaeOSJD0YWvRDbBpqiEn8Tl0zx7LtprmFM
	 YK9kJ9lGV179FYalzsQUrBD/SRI5H5j+1hQvnfEVS3zSr4zUdZSX69vndYJs4SCIJj
	 7vCBLdbibDyNmdXIXYvAHGHbuDnua5Oo5xdgA+cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 443/969] hrtimer: Reduce trace noise in hrtimer_start()
Date: Sat, 30 May 2026 17:59:27 +0200
Message-ID: <20260530160312.505363514@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b4bc2828fa09f..ec8d0de1ad225 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -198,12 +198,13 @@ TRACE_EVENT(hrtimer_init,
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
@@ -211,6 +212,7 @@ TRACE_EVENT(hrtimer_start,
 		__field( s64,		expires		)
 		__field( s64,		softexpires	)
 		__field( enum hrtimer_mode,	mode	)
+		__field( bool,		was_armed	)
 	),
 
 	TP_fast_assign(
@@ -219,13 +221,14 @@ TRACE_EVENT(hrtimer_start,
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
index 2d8c7b735baeb..d56e18b133741 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -497,17 +497,10 @@ debug_init(struct hrtimer *timer, clockid_t clockid,
 	trace_hrtimer_init(timer, clockid, mode);
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
@@ -1099,9 +1092,9 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
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
@@ -1161,6 +1154,8 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base,
 	if (state & HRTIMER_STATE_ENQUEUED) {
 		bool reprogram;
 
+		debug_hrtimer_deactivate(timer);
+
 		/*
 		 * Remove the timer and force reprogramming when high
 		 * resolution mode is active and the timer is on the current
@@ -1169,7 +1164,6 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base,
 		 * reprogramming happens in the interrupt handler. This is a
 		 * rare case and less expensive than a smp call.
 		 */
-		debug_deactivate(timer);
 		reprogram = base->cpu_base == this_cpu_ptr(&hrtimer_bases);
 
 		/*
@@ -1236,15 +1230,15 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
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
@@ -1266,7 +1260,7 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 * avoids programming the underlying clock event twice (once at
 	 * removal and once after enqueue).
 	 */
-	remove_hrtimer(timer, base, true, force_local);
+	was_armed = remove_hrtimer(timer, base, true, force_local);
 
 	if (mode & HRTIMER_MODE_REL)
 		tim = ktime_add_safe(tim, base->get_time());
@@ -1283,7 +1277,7 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		new_base = base;
 	}
 
-	first = enqueue_hrtimer(timer, new_base, mode);
+	first = enqueue_hrtimer(timer, new_base, mode, was_armed);
 
 	/*
 	 * If the hrtimer interrupt is running, then it will reevaluate the
@@ -1387,8 +1381,11 @@ int hrtimer_try_to_cancel(struct hrtimer *timer)
 
 	base = lock_hrtimer_base(timer, &flags);
 
-	if (!hrtimer_callback_running(timer))
+	if (!hrtimer_callback_running(timer)) {
 		ret = remove_hrtimer(timer, base, false, false);
+		if (ret)
+			trace_hrtimer_cancel(timer);
+	}
 
 	unlock_hrtimer_base(timer, &flags);
 
@@ -1768,7 +1765,7 @@ static void __run_hrtimer(struct hrtimer_cpu_base *cpu_base,
 	 */
 	if (restart != HRTIMER_NORESTART &&
 	    !(timer->state & HRTIMER_STATE_ENQUEUED))
-		enqueue_hrtimer(timer, base, HRTIMER_MODE_ABS);
+		enqueue_hrtimer(timer, base, HRTIMER_MODE_ABS, false);
 
 	/*
 	 * Separate the ->running assignment from the ->state assignment.
@@ -2250,7 +2247,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 	while ((node = timerqueue_getnext(&old_base->active))) {
 		timer = container_of(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
-		debug_deactivate(timer);
+		debug_hrtimer_deactivate(timer);
 
 		/*
 		 * Mark it as ENQUEUED not INACTIVE otherwise the
@@ -2267,7 +2264,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		 * sort out already expired timers and reprogram the
 		 * event device.
 		 */
-		enqueue_hrtimer(timer, new_base, HRTIMER_MODE_ABS);
+		enqueue_hrtimer(timer, new_base, HRTIMER_MODE_ABS, true);
 	}
 }
 
-- 
2.53.0



