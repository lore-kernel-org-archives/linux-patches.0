Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2C629B799;
	Sat, 30 May 2026 18:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164556; cv=none; b=M53SLhhfPCOgW6fKP8xh7T+nYA+qVopCAoupIYIF2J67mhdi3mPm7+viIYv3sqOxrKecnXWaizdzvpaNFlos2Fd/O+JmlmGCg2fea4ETUMOWgtsN3T1mj3Y0YgolNC3HkWWgGkD0Od+PVUkihmoTu6dQClpDzflu+uM6HeKOG0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164556; c=relaxed/simple;
	bh=6Gnxcs+tbgtP+m+c1UJ9SR+zrE0gQauWUyJPMpVHHlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgac6EISv1UDeRkWZdOPWlmIQdQXh+xcA/MrPQlRZ1dBjFQ05/gGSRZJ0TP//xbGZhAEWfkvAKoJrXCVK8GYbfMKKBRpTYGQp4e7grR3EryqY0S2ZaBdNntnOSOrKzkPT7f1AAku4MjuhTBGCIyENGacWPCK9nE449gXyPsON2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUIKMJ3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUIKMJ3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CED01F00893;
	Sat, 30 May 2026 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164554;
	bh=nVErYH8OkKAcgQVIaqOWhctqKi950PamGHaxRdD/Er0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUIKMJ3j2AXPhz5ZiThrH3CYDrKggFzmQHKZBmQNWOIAY9zX09HMrU/e+Ui0F/oQg
	 YZGT7Tj0rpaibmdlNLkgQRnz9F417ieGASStVPDMZLvC4VhULpe0+HngUZfH7vyCDR
	 0/tOJ/sEai3QHAZXwL+dkOvR50D6opBeERVa3t7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 560/776] net/sched: taprio: rename close_time to end_time
Date: Sat, 30 May 2026 18:04:34 +0200
Message-ID: <20260530160254.611059937@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e5517551112ff2395611e552443932152f83672d ]

There is a confusion in terms in taprio which makes what is called
"close_time" to be actually used for 2 things:

1. determining when an entry "closes" such that transmitted skbs are
   never allowed to overrun that time (?!)
2. an aid for determining when to advance and/or restart the schedule
   using the hrtimer

It makes more sense to call this so-called "close_time" "end_time",
because it's not clear at all to me what "closes". Future patches will
hopefully make better use of the term "to close".

This is an absolutely mechanical change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 105425b1969c ("net/sched: taprio: fix use-after-free in advance_sched() on schedule switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 52 +++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 185f0bd7ed407..189101dfbaae9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -37,11 +37,11 @@ static DEFINE_SPINLOCK(taprio_list_lock);
 struct sched_entry {
 	struct list_head list;
 
-	/* The instant that this entry "closes" and the next one
+	/* The instant that this entry ends and the next one
 	 * should open, the qdisc will make some effort so that no
 	 * packet leaves after this time.
 	 */
-	ktime_t close_time;
+	ktime_t end_time;
 	ktime_t next_txtime;
 	atomic_t budget;
 	int index;
@@ -54,7 +54,7 @@ struct sched_gate_list {
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
-	ktime_t cycle_close_time;
+	ktime_t cycle_end_time;
 	s64 cycle_time;
 	s64 cycle_time_extension;
 	s64 base_time;
@@ -581,7 +581,7 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	 * guard band ...
 	 */
 	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-	    ktime_after(guard, entry->close_time))
+	    ktime_after(guard, entry->end_time))
 		return NULL;
 
 	/* ... and no budget. */
@@ -643,7 +643,7 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 	if (list_is_last(&entry->list, &oper->entries))
 		return true;
 
-	if (ktime_compare(entry->close_time, oper->cycle_close_time) == 0)
+	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
 		return true;
 
 	return false;
@@ -651,7 +651,7 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 
 static bool should_change_schedules(const struct sched_gate_list *admin,
 				    const struct sched_gate_list *oper,
-				    ktime_t close_time)
+				    ktime_t end_time)
 {
 	ktime_t next_base_time, extension_time;
 
@@ -660,18 +660,18 @@ static bool should_change_schedules(const struct sched_gate_list *admin,
 
 	next_base_time = sched_base_time(admin);
 
-	/* This is the simple case, the close_time would fall after
+	/* This is the simple case, the end_time would fall after
 	 * the next schedule base_time.
 	 */
-	if (ktime_compare(next_base_time, close_time) <= 0)
+	if (ktime_compare(next_base_time, end_time) <= 0)
 		return true;
 
-	/* This is the cycle_time_extension case, if the close_time
+	/* This is the cycle_time_extension case, if the end_time
 	 * plus the amount that can be extended would fall after the
 	 * next schedule base_time, we can extend the current schedule
 	 * for that amount.
 	 */
-	extension_time = ktime_add_ns(close_time, oper->cycle_time_extension);
+	extension_time = ktime_add_ns(end_time, oper->cycle_time_extension);
 
 	/* FIXME: the IEEE 802.1Q-2018 Specification isn't clear about
 	 * how precisely the extension should be made. So after
@@ -690,7 +690,7 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	struct sched_gate_list *oper, *admin;
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t close_time;
+	ktime_t end_time;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -709,41 +709,41 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	 * entry of all schedules are pre-calculated during the
 	 * schedule initialization.
 	 */
-	if (unlikely(!entry || entry->close_time == oper->base_time)) {
+	if (unlikely(!entry || entry->end_time == oper->base_time)) {
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
-		close_time = next->close_time;
+		end_time = next->end_time;
 		goto first_run;
 	}
 
 	if (should_restart_cycle(oper, entry)) {
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
-		oper->cycle_close_time = ktime_add_ns(oper->cycle_close_time,
-						      oper->cycle_time);
+		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+						    oper->cycle_time);
 	} else {
 		next = list_next_entry(entry, list);
 	}
 
-	close_time = ktime_add_ns(entry->close_time, next->interval);
-	close_time = min_t(ktime_t, close_time, oper->cycle_close_time);
+	end_time = ktime_add_ns(entry->end_time, next->interval);
+	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 
-	if (should_change_schedules(admin, oper, close_time)) {
+	if (should_change_schedules(admin, oper, end_time)) {
 		/* Set things so the next time this runs, the new
 		 * schedule runs.
 		 */
-		close_time = sched_base_time(admin);
+		end_time = sched_base_time(admin);
 		switch_schedules(q, &admin, &oper);
 	}
 
-	next->close_time = close_time;
+	next->end_time = end_time;
 	taprio_set_budget(q, next);
 
 first_run:
 	rcu_assign_pointer(q->current_entry, next);
 	spin_unlock(&q->current_entry_lock);
 
-	hrtimer_set_expires(&q->advance_timer, close_time);
+	hrtimer_set_expires(&q->advance_timer, end_time);
 
 	rcu_read_lock();
 	__netif_schedule(sch);
@@ -1016,8 +1016,8 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	return 0;
 }
 
-static void setup_first_close_time(struct taprio_sched *q,
-				   struct sched_gate_list *sched, ktime_t base)
+static void setup_first_end_time(struct taprio_sched *q,
+				 struct sched_gate_list *sched, ktime_t base)
 {
 	struct sched_entry *first;
 	ktime_t cycle;
@@ -1028,9 +1028,9 @@ static void setup_first_close_time(struct taprio_sched *q,
 	cycle = sched->cycle_time;
 
 	/* FIXME: find a better place to do this */
-	sched->cycle_close_time = ktime_add_ns(base, cycle);
+	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
-	first->close_time = ktime_add_ns(base, first->interval);
+	first->end_time = ktime_add_ns(base, first->interval);
 	taprio_set_budget(q, first);
 	rcu_assign_pointer(q->current_entry, NULL);
 }
@@ -1573,7 +1573,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 	} else {
-		setup_first_close_time(q, new_admin, start);
+		setup_first_end_time(q, new_admin, start);
 
 		/* Protects against advance_sched() */
 		spin_lock_irqsave(&q->current_entry_lock, flags);
-- 
2.53.0



