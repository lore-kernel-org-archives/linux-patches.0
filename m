Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B37D13DDDD;
	Thu, 11 Apr 2024 09:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829593; cv=none; b=nox96adl85HBxgY2gisMXYAY8G6uog8jHYZ1sSiQqEWMhqQB2ZS1NoHt3ZAVK4267k0WkpBT8p8n2DyRN5K1M/diRhOUAwS9vA41/fdQKvQpYmj5eQRUHfQN+mG5O3qpXM8tTPs5Rj74zln5nHrhBbnpXdBPWp3xysZ3duDdlH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829593; c=relaxed/simple;
	bh=kQMK0nUIAothLCUvFWbs4BueDFPzk6ScDOSK37Qd0pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUOR6gnRBqyZYrUylFaF14C4JPee7VqAVounz0WZeXtItSYWXprwbbPXNwNErquVayKQG57ybfwSLGDTjpqRLrjclHaKMyohCFJ+cPnH8jYu/mpSycgNndFCxCWIlpxX96uInQw9CXa8Vx8DaDPUOsK6eC3Mel/gxfXSeoydS8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnT3DKYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnT3DKYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88392C433C7;
	Thu, 11 Apr 2024 09:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829592;
	bh=kQMK0nUIAothLCUvFWbs4BueDFPzk6ScDOSK37Qd0pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnT3DKYk9gRHE+ia156No7bjJTS/dq0Sjd1ufwb4IdKrpks9VQqxktDbNgLwxFR5B
	 gkDHYwo/Qj5uzPi7HZdB+FbwuX00gd1ciAsHPTcRYBmK3EF7UMAsFomrKcMnXPXx0a
	 dEB2bvOJQkV83t0CTCZiwmJDeVaoDXPMlcvUfV+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna-Maria Gleixner <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	fweisbec@gmail.com,
	peterz@infradead.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/175] timer/trace: Improve timer tracing
Date: Thu, 11 Apr 2024 11:53:48 +0200
Message-ID: <20240411095419.700907917@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

From: Anna-Maria Gleixner <anna-maria@linutronix.de>

[ Upstream commit f28d3d5346e97e60c81f933ac89ccf015430e5cf ]

Timers are added to the timer wheel off by one. This is required in
case a timer is queued directly before incrementing jiffies to prevent
early timer expiry.

When reading a timer trace and relying only on the expiry time of the timer
in the timer_start trace point and on the now in the timer_expiry_entry
trace point, it seems that the timer fires late. With the current
timer_expiry_entry trace point information only now=jiffies is printed but
not the value of base->clk. This makes it impossible to draw a conclusion
to the index of base->clk and makes it impossible to examine timer problems
without additional trace points.

Therefore add the base->clk value to the timer_expire_entry trace
point, to be able to calculate the index the timer base is located at
during collecting expired timers.

Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: https://lkml.kernel.org/r/20190321120921.16463-5-anna-maria@linutronix.de
Stable-dep-of: 0f7352557a35 ("wifi: brcmfmac: Fix use-after-free bug in brcmf_cfg80211_detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/timer.h | 11 +++++++----
 kernel/time/timer.c          | 17 +++++++++++++----
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 8f6240854e28f..295517f109d71 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -89,24 +89,27 @@ TRACE_EVENT(timer_start,
  */
 TRACE_EVENT(timer_expire_entry,
 
-	TP_PROTO(struct timer_list *timer),
+	TP_PROTO(struct timer_list *timer, unsigned long baseclk),
 
-	TP_ARGS(timer),
+	TP_ARGS(timer, baseclk),
 
 	TP_STRUCT__entry(
 		__field( void *,	timer	)
 		__field( unsigned long,	now	)
 		__field( void *,	function)
+		__field( unsigned long,	baseclk	)
 	),
 
 	TP_fast_assign(
 		__entry->timer		= timer;
 		__entry->now		= jiffies;
 		__entry->function	= timer->function;
+		__entry->baseclk	= baseclk;
 	),
 
-	TP_printk("timer=%p function=%ps now=%lu",
-		  __entry->timer, __entry->function, __entry->now)
+	TP_printk("timer=%p function=%ps now=%lu baseclk=%lu",
+		  __entry->timer, __entry->function, __entry->now,
+		  __entry->baseclk)
 );
 
 /**
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index a6e88d9bb931c..140662c2b41e1 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1311,7 +1311,9 @@ int del_timer_sync(struct timer_list *timer)
 EXPORT_SYMBOL(del_timer_sync);
 #endif
 
-static void call_timer_fn(struct timer_list *timer, void (*fn)(struct timer_list *))
+static void call_timer_fn(struct timer_list *timer,
+			  void (*fn)(struct timer_list *),
+			  unsigned long baseclk)
 {
 	int count = preempt_count();
 
@@ -1334,7 +1336,7 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(struct timer_list
 	 */
 	lock_map_acquire(&lockdep_map);
 
-	trace_timer_expire_entry(timer);
+	trace_timer_expire_entry(timer, baseclk);
 	fn(timer);
 	trace_timer_expire_exit(timer);
 
@@ -1355,6 +1357,13 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(struct timer_list
 
 static void expire_timers(struct timer_base *base, struct hlist_head *head)
 {
+	/*
+	 * This value is required only for tracing. base->clk was
+	 * incremented directly before expire_timers was called. But expiry
+	 * is related to the old base->clk value.
+	 */
+	unsigned long baseclk = base->clk - 1;
+
 	while (!hlist_empty(head)) {
 		struct timer_list *timer;
 		void (*fn)(struct timer_list *);
@@ -1368,11 +1377,11 @@ static void expire_timers(struct timer_base *base, struct hlist_head *head)
 
 		if (timer->flags & TIMER_IRQSAFE) {
 			raw_spin_unlock(&base->lock);
-			call_timer_fn(timer, fn);
+			call_timer_fn(timer, fn, baseclk);
 			raw_spin_lock(&base->lock);
 		} else {
 			raw_spin_unlock_irq(&base->lock);
-			call_timer_fn(timer, fn);
+			call_timer_fn(timer, fn, baseclk);
 			raw_spin_lock_irq(&base->lock);
 		}
 	}
-- 
2.43.0



