Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A55FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F3CC433EF;
	Mon, 15 May 2023 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173361;
	bh=XmNYg1PQsz8vNeQbI+155zAITQTRKcFB3NUHy93W8ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNYs+rB8QfnGcUnruOuDyGsdCz8TfHBaPvimEDw7vRvV4OitErjnPuaA7ofLfTawh
	 37ewL2FCf/gS7T6qkAcMJ/cXx3VH3cp0CnKtPdqkWwaP0Gs1DvX/PFuf0UmobXvupm
	 ku3C3QCOVFAfT0vGV4SYuiK/VQXehNos287AQjHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/282] timekeeping: Split jiffies seqlock
Date: Mon, 15 May 2023 18:27:26 +0200
Message-Id: <20230515161724.274205539@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit e5d4d1756b07d9490a0269a9e68c1e05ee1feb9b ]

seqlock consists of a sequence counter and a spinlock_t which is used to
serialize the writers. spinlock_t is substituted by a "sleeping" spinlock
on PREEMPT_RT enabled kernels which breaks the usage in the timekeeping
code as the writers are executed in hard interrupt and therefore
non-preemptible context even on PREEMPT_RT.

The spinlock in seqlock cannot be unconditionally replaced by a
raw_spinlock_t as many seqlock users have nesting spinlock sections or
other code which is not suitable to run in truly atomic context on RT.

Instead of providing a raw_seqlock API for a single use case, open code the
seqlock for the jiffies use case and implement it with a raw_spinlock_t and
a sequence counter.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200321113242.120587764@linutronix.de
Stable-dep-of: e9523a0d8189 ("tick/common: Align tick period with the HZ tick.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/jiffies.c     |  7 ++++---
 kernel/time/tick-common.c | 10 ++++++----
 kernel/time/tick-sched.c  | 19 ++++++++++++-------
 kernel/time/timekeeping.c |  6 ++++--
 kernel/time/timekeeping.h |  3 ++-
 5 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index d23b434c2ca7b..eddcf49704445 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -58,7 +58,8 @@ static struct clocksource clocksource_jiffies = {
 	.max_cycles	= 10,
 };
 
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(jiffies_lock);
+__cacheline_aligned_in_smp DEFINE_RAW_SPINLOCK(jiffies_lock);
+__cacheline_aligned_in_smp seqcount_t jiffies_seq;
 
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)
@@ -67,9 +68,9 @@ u64 get_jiffies_64(void)
 	u64 ret;
 
 	do {
-		seq = read_seqbegin(&jiffies_lock);
+		seq = read_seqcount_begin(&jiffies_seq);
 		ret = jiffies_64;
-	} while (read_seqretry(&jiffies_lock, seq));
+	} while (read_seqcount_retry(&jiffies_seq, seq));
 	return ret;
 }
 EXPORT_SYMBOL(get_jiffies_64);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 7e5d3524e924d..6c9c342dd0e53 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -84,13 +84,15 @@ int tick_is_oneshot_available(void)
 static void tick_periodic(int cpu)
 {
 	if (tick_do_timer_cpu == cpu) {
-		write_seqlock(&jiffies_lock);
+		raw_spin_lock(&jiffies_lock);
+		write_seqcount_begin(&jiffies_seq);
 
 		/* Keep track of the next tick event */
 		tick_next_period = ktime_add(tick_next_period, tick_period);
 
 		do_timer(1);
-		write_sequnlock(&jiffies_lock);
+		write_seqcount_end(&jiffies_seq);
+		raw_spin_unlock(&jiffies_lock);
 		update_wall_time();
 	}
 
@@ -162,9 +164,9 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 		ktime_t next;
 
 		do {
-			seq = read_seqbegin(&jiffies_lock);
+			seq = read_seqcount_begin(&jiffies_seq);
 			next = tick_next_period;
-		} while (read_seqretry(&jiffies_lock, seq));
+		} while (read_seqcount_retry(&jiffies_seq, seq));
 
 		clockevents_switch_state(dev, CLOCK_EVT_STATE_ONESHOT);
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5eb04bb598026..88a508cc89255 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -65,7 +65,8 @@ static void tick_do_update_jiffies64(ktime_t now)
 		return;
 
 	/* Reevaluate with jiffies_lock held */
-	write_seqlock(&jiffies_lock);
+	raw_spin_lock(&jiffies_lock);
+	write_seqcount_begin(&jiffies_seq);
 
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta >= tick_period) {
@@ -91,10 +92,12 @@ static void tick_do_update_jiffies64(ktime_t now)
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	} else {
-		write_sequnlock(&jiffies_lock);
+		write_seqcount_end(&jiffies_seq);
+		raw_spin_unlock(&jiffies_lock);
 		return;
 	}
-	write_sequnlock(&jiffies_lock);
+	write_seqcount_end(&jiffies_seq);
+	raw_spin_unlock(&jiffies_lock);
 	update_wall_time();
 }
 
@@ -105,12 +108,14 @@ static ktime_t tick_init_jiffy_update(void)
 {
 	ktime_t period;
 
-	write_seqlock(&jiffies_lock);
+	raw_spin_lock(&jiffies_lock);
+	write_seqcount_begin(&jiffies_seq);
 	/* Did we start the jiffies update yet ? */
 	if (last_jiffies_update == 0)
 		last_jiffies_update = tick_next_period;
 	period = last_jiffies_update;
-	write_sequnlock(&jiffies_lock);
+	write_seqcount_end(&jiffies_seq);
+	raw_spin_unlock(&jiffies_lock);
 	return period;
 }
 
@@ -665,10 +670,10 @@ static ktime_t tick_nohz_next_event(struct tick_sched *ts, int cpu)
 
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
-		seq = read_seqbegin(&jiffies_lock);
+		seq = read_seqcount_begin(&jiffies_seq);
 		basemono = last_jiffies_update;
 		basejiff = jiffies;
-	} while (read_seqretry(&jiffies_lock, seq));
+	} while (read_seqcount_retry(&jiffies_seq, seq));
 	ts->last_jiffies = basejiff;
 	ts->timer_expires_base = basemono;
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2bc278dd98546..105dd0b663291 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2415,8 +2415,10 @@ EXPORT_SYMBOL(hardpps);
  */
 void xtime_update(unsigned long ticks)
 {
-	write_seqlock(&jiffies_lock);
+	raw_spin_lock(&jiffies_lock);
+	write_seqcount_begin(&jiffies_seq);
 	do_timer(ticks);
-	write_sequnlock(&jiffies_lock);
+	write_seqcount_end(&jiffies_seq);
+	raw_spin_unlock(&jiffies_lock);
 	update_wall_time();
 }
diff --git a/kernel/time/timekeeping.h b/kernel/time/timekeeping.h
index 141ab3ab0354f..099737f6f10c7 100644
--- a/kernel/time/timekeeping.h
+++ b/kernel/time/timekeeping.h
@@ -25,7 +25,8 @@ static inline void sched_clock_resume(void) { }
 extern void do_timer(unsigned long ticks);
 extern void update_wall_time(void);
 
-extern seqlock_t jiffies_lock;
+extern raw_spinlock_t jiffies_lock;
+extern seqcount_t jiffies_seq;
 
 #define CS_NAME_LEN	32
 
-- 
2.39.2



