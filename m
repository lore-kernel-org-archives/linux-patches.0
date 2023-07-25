Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C465182C8
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1375C433C8;
	Tue, 25 Jul 2023 11:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282960;
	bh=nH/t1pxwGcWPD6AfdFLKSc3uWuiODdxPNpsfJ4G1bHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYalbcJZkKhzm3Ee4esmLJw0ykQQO2HF7npUuPWV3qaaMssW11ilcx12fUuLrhs51
	 8oOI66qC52WnnRS+/zMoY2oQRstF3EufHa6Ex+EJamKmNuKzLnNv7PfLRtBKup6Mbt
	 WS12Cf+0xX2IhSDv97wPgbcdVM16/XW5/JPCWKD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Domenico Cerasuolo <cerasuolodomenico@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/183] sched/psi: Rearrange polling code in preparation
Date: Tue, 25 Jul 2023 12:45:16 +0200
Message-ID: <20230725104511.133684061@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>

[ Upstream commit 7fab21fa0d000a0ea32d73ce8eec68557c6c268b ]

Move a few functions up in the file to avoid forward declaration needed
in the patch implementing unprivileged PSI triggers.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lore.kernel.org/r/20230330105418.77061-2-cerasuolodomenico@gmail.com
Stable-dep-of: aff037078eca ("sched/psi: use kernfs polling functions for PSI trigger polling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 196 ++++++++++++++++++++++-----------------------
 1 file changed, 98 insertions(+), 98 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 02e011cabe917..fe9269f1d2a46 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -384,92 +384,6 @@ static void collect_percpu_times(struct psi_group *group,
 		*pchanged_states = changed_states;
 }
 
-static u64 update_averages(struct psi_group *group, u64 now)
-{
-	unsigned long missed_periods = 0;
-	u64 expires, period;
-	u64 avg_next_update;
-	int s;
-
-	/* avgX= */
-	expires = group->avg_next_update;
-	if (now - expires >= psi_period)
-		missed_periods = div_u64(now - expires, psi_period);
-
-	/*
-	 * The periodic clock tick can get delayed for various
-	 * reasons, especially on loaded systems. To avoid clock
-	 * drift, we schedule the clock in fixed psi_period intervals.
-	 * But the deltas we sample out of the per-cpu buckets above
-	 * are based on the actual time elapsing between clock ticks.
-	 */
-	avg_next_update = expires + ((1 + missed_periods) * psi_period);
-	period = now - (group->avg_last_update + (missed_periods * psi_period));
-	group->avg_last_update = now;
-
-	for (s = 0; s < NR_PSI_STATES - 1; s++) {
-		u32 sample;
-
-		sample = group->total[PSI_AVGS][s] - group->avg_total[s];
-		/*
-		 * Due to the lockless sampling of the time buckets,
-		 * recorded time deltas can slip into the next period,
-		 * which under full pressure can result in samples in
-		 * excess of the period length.
-		 *
-		 * We don't want to report non-sensical pressures in
-		 * excess of 100%, nor do we want to drop such events
-		 * on the floor. Instead we punt any overage into the
-		 * future until pressure subsides. By doing this we
-		 * don't underreport the occurring pressure curve, we
-		 * just report it delayed by one period length.
-		 *
-		 * The error isn't cumulative. As soon as another
-		 * delta slips from a period P to P+1, by definition
-		 * it frees up its time T in P.
-		 */
-		if (sample > period)
-			sample = period;
-		group->avg_total[s] += sample;
-		calc_avgs(group->avg[s], missed_periods, sample, period);
-	}
-
-	return avg_next_update;
-}
-
-static void psi_avgs_work(struct work_struct *work)
-{
-	struct delayed_work *dwork;
-	struct psi_group *group;
-	u32 changed_states;
-	u64 now;
-
-	dwork = to_delayed_work(work);
-	group = container_of(dwork, struct psi_group, avgs_work);
-
-	mutex_lock(&group->avgs_lock);
-
-	now = sched_clock();
-
-	collect_percpu_times(group, PSI_AVGS, &changed_states);
-	/*
-	 * If there is task activity, periodically fold the per-cpu
-	 * times and feed samples into the running averages. If things
-	 * are idle and there is no data to process, stop the clock.
-	 * Once restarted, we'll catch up the running averages in one
-	 * go - see calc_avgs() and missed_periods.
-	 */
-	if (now >= group->avg_next_update)
-		group->avg_next_update = update_averages(group, now);
-
-	if (changed_states & PSI_STATE_RESCHEDULE) {
-		schedule_delayed_work(dwork, nsecs_to_jiffies(
-				group->avg_next_update - now) + 1);
-	}
-
-	mutex_unlock(&group->avgs_lock);
-}
-
 /* Trigger tracking window manipulations */
 static void window_reset(struct psi_window *win, u64 now, u64 value,
 			 u64 prev_growth)
@@ -516,18 +430,6 @@ static u64 window_update(struct psi_window *win, u64 now, u64 value)
 	return growth;
 }
 
-static void init_triggers(struct psi_group *group, u64 now)
-{
-	struct psi_trigger *t;
-
-	list_for_each_entry(t, &group->triggers, node)
-		window_reset(&t->win, now,
-				group->total[PSI_POLL][t->state], 0);
-	memcpy(group->polling_total, group->total[PSI_POLL],
-		   sizeof(group->polling_total));
-	group->polling_next_update = now + group->poll_min_period;
-}
-
 static u64 update_triggers(struct psi_group *group, u64 now)
 {
 	struct psi_trigger *t;
@@ -590,6 +492,104 @@ static u64 update_triggers(struct psi_group *group, u64 now)
 	return now + group->poll_min_period;
 }
 
+static u64 update_averages(struct psi_group *group, u64 now)
+{
+	unsigned long missed_periods = 0;
+	u64 expires, period;
+	u64 avg_next_update;
+	int s;
+
+	/* avgX= */
+	expires = group->avg_next_update;
+	if (now - expires >= psi_period)
+		missed_periods = div_u64(now - expires, psi_period);
+
+	/*
+	 * The periodic clock tick can get delayed for various
+	 * reasons, especially on loaded systems. To avoid clock
+	 * drift, we schedule the clock in fixed psi_period intervals.
+	 * But the deltas we sample out of the per-cpu buckets above
+	 * are based on the actual time elapsing between clock ticks.
+	 */
+	avg_next_update = expires + ((1 + missed_periods) * psi_period);
+	period = now - (group->avg_last_update + (missed_periods * psi_period));
+	group->avg_last_update = now;
+
+	for (s = 0; s < NR_PSI_STATES - 1; s++) {
+		u32 sample;
+
+		sample = group->total[PSI_AVGS][s] - group->avg_total[s];
+		/*
+		 * Due to the lockless sampling of the time buckets,
+		 * recorded time deltas can slip into the next period,
+		 * which under full pressure can result in samples in
+		 * excess of the period length.
+		 *
+		 * We don't want to report non-sensical pressures in
+		 * excess of 100%, nor do we want to drop such events
+		 * on the floor. Instead we punt any overage into the
+		 * future until pressure subsides. By doing this we
+		 * don't underreport the occurring pressure curve, we
+		 * just report it delayed by one period length.
+		 *
+		 * The error isn't cumulative. As soon as another
+		 * delta slips from a period P to P+1, by definition
+		 * it frees up its time T in P.
+		 */
+		if (sample > period)
+			sample = period;
+		group->avg_total[s] += sample;
+		calc_avgs(group->avg[s], missed_periods, sample, period);
+	}
+
+	return avg_next_update;
+}
+
+static void psi_avgs_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct psi_group *group;
+	u32 changed_states;
+	u64 now;
+
+	dwork = to_delayed_work(work);
+	group = container_of(dwork, struct psi_group, avgs_work);
+
+	mutex_lock(&group->avgs_lock);
+
+	now = sched_clock();
+
+	collect_percpu_times(group, PSI_AVGS, &changed_states);
+	/*
+	 * If there is task activity, periodically fold the per-cpu
+	 * times and feed samples into the running averages. If things
+	 * are idle and there is no data to process, stop the clock.
+	 * Once restarted, we'll catch up the running averages in one
+	 * go - see calc_avgs() and missed_periods.
+	 */
+	if (now >= group->avg_next_update)
+		group->avg_next_update = update_averages(group, now);
+
+	if (changed_states & PSI_STATE_RESCHEDULE) {
+		schedule_delayed_work(dwork, nsecs_to_jiffies(
+				group->avg_next_update - now) + 1);
+	}
+
+	mutex_unlock(&group->avgs_lock);
+}
+
+static void init_triggers(struct psi_group *group, u64 now)
+{
+	struct psi_trigger *t;
+
+	list_for_each_entry(t, &group->triggers, node)
+		window_reset(&t->win, now,
+				group->total[PSI_POLL][t->state], 0);
+	memcpy(group->polling_total, group->total[PSI_POLL],
+		   sizeof(group->polling_total));
+	group->polling_next_update = now + group->poll_min_period;
+}
+
 /* Schedule polling if it's not already scheduled or forced. */
 static void psi_schedule_poll_work(struct psi_group *group, unsigned long delay,
 				   bool force)
-- 
2.39.2



