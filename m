Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4619446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DB1C433C8;
	Sun, 13 Aug 2023 21:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963219;
	bh=p1TCzpOYLO1db3AV0DSc8kuYPs2Z9b3JL4+onPNEPo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/dD3VhruBh1PcsjYiyA1u8aiP3lGuLyB8+IJOnnlzRPlUYIe4D/iZQJCLjsv8QD6
	 NifJJo2YW21pCpo+H4S2HursU43zH7D9BHYW1cUFunJK5GHmH4fk4vfyc8YVM02N0+
	 VLJTg6BnOy6guhsYxAYZPdYJHsDWJ2w6RIm8gK9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 5.15 89/89] timers/nohz: Last resort update jiffies on nohz_full IRQ entry
Date: Sun, 13 Aug 2023 23:20:20 +0200
Message-ID: <20230813211713.427805967@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 53e87e3cdc155f20c3417b689df8d2ac88d79576 ]

When at least one CPU runs in nohz_full mode, a dedicated timekeeper CPU
is guaranteed to stay online and to never stop its tick.

Meanwhile on some rare case, the dedicated timekeeper may be running
with interrupts disabled for a while, such as in stop_machine.

If jiffies stop being updated, a nohz_full CPU may end up endlessly
programming the next tick in the past, taking the last jiffies update
monotonic timestamp as a stale base, resulting in an tick storm.

Here is a scenario where it matters:

0) CPU 0 is the timekeeper and CPU 1 a nohz_full CPU.

1) A stop machine callback is queued to execute somewhere.

2) CPU 0 reaches MULTI_STOP_DISABLE_IRQ while CPU 1 is still in
   MULTI_STOP_PREPARE. Hence CPU 0 can't do its timekeeping duty. CPU 1
   can still take IRQs.

3) CPU 1 receives an IRQ which queues a timer callback one jiffy forward.

4) On IRQ exit, CPU 1 schedules the tick one jiffy forward, taking
   last_jiffies_update as a base. But last_jiffies_update hasn't been
   updated for 2 jiffies since the timekeeper has interrupts disabled.

5) clockevents_program_event(), which relies on ktime_get(), observes
   that the expiration is in the past and therefore programs the min
   delta event on the clock.

6) The tick fires immediately, goto 3)

7) Tick storm, the nohz_full CPU is drown and takes ages to reach
   MULTI_STOP_DISABLE_IRQ, which is the only way out of this situation.

Solve this with unconditionally updating jiffies if the value is stale
on nohz_full IRQ entry. IRQs and other disturbances are expected to be
rare enough on nohz_full for the unconditional call to ktime_get() to
actually matter.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20211026141055.57358-2-frederic@kernel.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/softirq.c         |    3 ++-
 kernel/time/tick-sched.c |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -595,7 +595,8 @@ void irq_enter_rcu(void)
 {
 	__irq_enter_raw();
 
-	if (is_idle_task(current) && (irq_count() == HARDIRQ_OFFSET))
+	if (tick_nohz_full_cpu(smp_processor_id()) ||
+	    (is_idle_task(current) && (irq_count() == HARDIRQ_OFFSET)))
 		tick_irq_enter();
 
 	account_hardirq_enter(current);
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1420,6 +1420,13 @@ static inline void tick_nohz_irq_enter(v
 	now = ktime_get();
 	if (ts->idle_active)
 		tick_nohz_stop_idle(ts, now);
+	/*
+	 * If all CPUs are idle. We may need to update a stale jiffies value.
+	 * Note nohz_full is a special case: a timekeeper is guaranteed to stay
+	 * alive but it might be busy looping with interrupts disabled in some
+	 * rare case (typically stop machine). So we must make sure we have a
+	 * last resort.
+	 */
 	if (ts->tick_stopped)
 		tick_nohz_update_jiffies(now);
 }


