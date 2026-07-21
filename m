Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D789A4302F5;
	Tue, 21 Jul 2026 19:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662500; cv=none; b=jwtHhhbLnDjsGLq8YzS7R6kUr6PJx0taIX9Zo9REVV1zpjIqps5cuiXSzRmINdL5jUiAJpXd4unThIb7npKrUZbCLg3b76wiuhSLBe05sdHLYbJrs3aMlBIgv1crnbqMmdV/rm55RG0t7tLJjujy10lT10DzwZ9U4rlbRPiZgDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662500; c=relaxed/simple;
	bh=49kedLJBMUp+fjeaEUG8TWs+Gk5qjnwMok987mNWPjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnq4JWKnVaBV75XxSiW48bZQNtnCl3yFihrWgVSgDLxeUfVXF/FRh1+e+7M2FDsqTMXBt+qGM3EFLw03+7gtmr/B9gZv3BuxhEw182BWDewrMJfPiSq3/ddmWIZZ9IqmjZAu8HocYzqFH9oGM2IRmil+qVl+J200At1n5wUi4m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4NRD1NK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4NRD1NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432F41F00A3D;
	Tue, 21 Jul 2026 19:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662498;
	bh=DeA+vBsryt0rGd3296hmTd+8iErTO3DV84EMkMPF3Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4NRD1NKc3ZeMp4TM1qd7Ety1SNhCYyBJvqLTufHSLWy+AbWiozINg3R92pcp3WZf
	 +JoohO9mrm30GCtZ1Tk+EyrvA7oAfTlUW7OLQrkUPJHBA6o8stGbYSyFgR9qNiLO67
	 kpQbbEVmgkQgwymH31+ksg1gOehzhhvS+NHjthkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madadi Vineeth Reddy <vineethr@linux.ibm.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0469/1276] perf sched timehist: Add pre-migration wait time option
Date: Tue, 21 Jul 2026 17:15:12 +0200
Message-ID: <20260721152456.598701569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Madadi Vineeth Reddy <vineethr@linux.ibm.com>

[ Upstream commit cd912ab3b65445df7b95bbdd06ac29f823d4df98 ]

pre-migration wait time is the time that a task unnecessarily spends
on the runqueue of a CPU but doesn't get switched-in there. In terms
of tracepoints, it is the time between sched:sched_wakeup and
sched:sched_migrate_task.

Let's say a task woke up on CPU2, then it got migrated to CPU4 and
then it's switched-in to CPU4. So, here pre-migration wait time is
time that it was waiting on runqueue of CPU2 after it is woken up.

The general pattern for pre-migration to occur is:
sched:sched_wakeup
sched:sched_migrate_task
sched:sched_switch

The sched:sched_waking event is used to capture the wakeup time,
as it aligns with the existing code and only introduces a negligible
time difference.

pre-migrations are generally not useful and it increases migrations.
This metric would be helpful in testing patches mainly related to wakeup
and load-balancer code paths as better wakeup logic would choose an
optimal CPU where task would be switched-in and thereby reducing pre-
migrations.

The sample output(s) when -P or --pre-migrations is used:
=================
           time    cpu  task name                       wait time  sch delay   run time  pre-mig time
                        [tid/pid]                          (msec)     (msec)     (msec)     (msec)
--------------- ------  ------------------------------  ---------  ---------  ---------  ---------
   38456.720806 [0001]  schbench[28634/28574]               4.917      4.768      1.004      0.000
   38456.720810 [0001]  rcu_preempt[18]                     3.919      0.003      0.004      0.000
   38456.721800 [0006]  schbench[28779/28574]              23.465     23.465      1.999      0.000
   38456.722800 [0002]  schbench[28773/28574]              60.371     60.237      3.955     60.197
   38456.722806 [0001]  schbench[28634/28574]               0.004      0.004      1.996      0.000
   38456.722811 [0001]  rcu_preempt[18]                     1.996      0.005      0.005      0.000
   38456.723800 [0000]  schbench[28833/28574]               4.000      4.000      3.999      0.000
   38456.723800 [0004]  schbench[28762/28574]              42.951     42.839      3.999     39.867
   38456.723802 [0007]  schbench[28812/28574]              43.947     43.817      3.999     40.866
   38456.723804 [0001]  schbench[28587/28574]               7.935      7.822      0.993      0.000

Signed-off-by: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Link: https://lore.kernel.org/r/20241004170756.18064-1-vineethr@linux.ibm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: a99d6394cd48 ("perf sched: Use thread__put() in free_idle_threads()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-sched.txt |  8 ++
 tools/perf/builtin-sched.c              | 98 +++++++++++++++----------
 2 files changed, 67 insertions(+), 39 deletions(-)

diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
index 3db64954a267a3..6dbbddb6464d01 100644
--- a/tools/perf/Documentation/perf-sched.txt
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -221,6 +221,14 @@ OPTIONS for 'perf sched timehist'
 	priorities are specified with -: 120-129. A combination of both can also be
 	provided: 0,120-129.
 
+-P::
+--pre-migrations::
+	Show pre-migration wait time. pre-migration wait time is the time spent
+	by a task waiting on a runqueue but not getting the chance to run there
+	and is migrated to a different runqueue where it is finally run. This
+	time between sched_wakeup and migrate_task is the pre-migration wait
+	time.
+
 OPTIONS for 'perf sched replay'
 ------------------------------
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index fd93ab11bd37ed..1203425d2b8a55 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -229,6 +229,7 @@ struct perf_sched {
 	bool		show_wakeups;
 	bool		show_next;
 	bool		show_migrations;
+	bool		pre_migrations;
 	bool		show_state;
 	bool		show_prio;
 	u64		skipped_samples;
@@ -248,7 +249,9 @@ struct thread_runtime {
 	u64 dt_iowait;      /* time between CPU access by iowait (off cpu) */
 	u64 dt_preempt;     /* time between CPU access by preempt (off cpu) */
 	u64 dt_delay;       /* time between wakeup and sched-in */
+	u64 dt_pre_mig;     /* time between migration and wakeup */
 	u64 ready_to_run;   /* time of wakeup */
+	u64 migrated;	    /* time when a thread is migrated */
 
 	struct stats run_stats;
 	u64 total_run_time;
@@ -256,6 +259,7 @@ struct thread_runtime {
 	u64 total_iowait_time;
 	u64 total_preempt_time;
 	u64 total_delay_time;
+	u64 total_pre_mig_time;
 
 	char last_state;
 
@@ -2148,14 +2152,15 @@ static void timehist_header(struct perf_sched *sched)
 		printf(" ");
 	}
 
-	if (sched->show_prio) {
-		printf(" %-*s  %-*s  %9s  %9s  %9s",
-		       comm_width, "task name", MAX_PRIO_STR_LEN, "prio",
-		       "wait time", "sch delay", "run time");
-	} else {
-		printf(" %-*s  %9s  %9s  %9s", comm_width,
-		       "task name", "wait time", "sch delay", "run time");
-	}
+	printf(" %-*s", comm_width, "task name");
+
+	if (sched->show_prio)
+		printf("  %-*s", MAX_PRIO_STR_LEN, "prio");
+
+	printf("  %9s  %9s  %9s", "wait time", "sch delay", "run time");
+
+	if (sched->pre_migrations)
+		printf("  %9s", "pre-mig time");
 
 	if (sched->show_state)
 		printf("  %s", "state");
@@ -2170,17 +2175,15 @@ static void timehist_header(struct perf_sched *sched)
 	if (sched->show_cpu_visual)
 		printf(" %*s ", ncpus, "");
 
-	if (sched->show_prio) {
-		printf(" %-*s  %-*s  %9s  %9s  %9s",
-		       comm_width, "[tid/pid]", MAX_PRIO_STR_LEN, "",
-		       "(msec)", "(msec)", "(msec)");
-	} else {
-		printf(" %-*s  %9s  %9s  %9s", comm_width,
-		       "[tid/pid]", "(msec)", "(msec)", "(msec)");
-	}
+	printf(" %-*s", comm_width, "[tid/pid]");
 
-	if (sched->show_state)
-		printf("  %5s", "");
+	if (sched->show_prio)
+		printf("  %-*s", MAX_PRIO_STR_LEN, "");
+
+	printf("  %9s  %9s  %9s", "(msec)", "(msec)", "(msec)");
+
+	if (sched->pre_migrations)
+		printf("  %9s", "(msec)");
 
 	printf("\n");
 
@@ -2192,15 +2195,15 @@ static void timehist_header(struct perf_sched *sched)
 	if (sched->show_cpu_visual)
 		printf(" %.*s ", ncpus, graph_dotted_line);
 
-	if (sched->show_prio) {
-		printf(" %.*s  %.*s  %.9s  %.9s  %.9s",
-		       comm_width, graph_dotted_line, MAX_PRIO_STR_LEN, graph_dotted_line,
-		       graph_dotted_line, graph_dotted_line, graph_dotted_line);
-	} else {
-		printf(" %.*s  %.9s  %.9s  %.9s", comm_width,
-		       graph_dotted_line, graph_dotted_line, graph_dotted_line,
-		       graph_dotted_line);
-	}
+	printf(" %.*s", comm_width, graph_dotted_line);
+
+	if (sched->show_prio)
+		printf("  %.*s", MAX_PRIO_STR_LEN, graph_dotted_line);
+
+	printf("  %.9s  %.9s  %.9s", graph_dotted_line, graph_dotted_line, graph_dotted_line);
+
+	if (sched->pre_migrations)
+		printf("  %.9s", graph_dotted_line);
 
 	if (sched->show_state)
 		printf("  %.5s", graph_dotted_line);
@@ -2256,6 +2259,8 @@ static void timehist_print_sample(struct perf_sched *sched,
 
 	print_sched_time(tr->dt_delay, 6);
 	print_sched_time(tr->dt_run, 6);
+	if (sched->pre_migrations)
+		print_sched_time(tr->dt_pre_mig, 6);
 
 	if (sched->show_state)
 		printf(" %5c ", thread__tid(thread) == 0 ? 'I' : state);
@@ -2293,18 +2298,21 @@ static void timehist_print_sample(struct perf_sched *sched,
  *    last_time = time of last sched change event for current task
  *                (i.e, time process was last scheduled out)
  * ready_to_run = time of wakeup for current task
+ *     migrated = time of task migration to another CPU
  *
- * -----|------------|------------|------------|------
- *    last         ready        tprev          t
+ * -----|-------------|-------------|-------------|-------------|-----
+ *    last         ready         migrated       tprev           t
  *    time         to run
  *
- *      |-------- dt_wait --------|
- *                   |- dt_delay -|-- dt_run --|
+ *      |---------------- dt_wait ----------------|
+ *                   |--------- dt_delay ---------|-- dt_run --|
+ *                   |- dt_pre_mig -|
  *
- *   dt_run = run time of current task
- *  dt_wait = time between last schedule out event for task and tprev
- *            represents time spent off the cpu
- * dt_delay = time between wakeup and schedule-in of task
+ *     dt_run = run time of current task
+ *    dt_wait = time between last schedule out event for task and tprev
+ *              represents time spent off the cpu
+ *   dt_delay = time between wakeup and schedule-in of task
+ * dt_pre_mig = time between wakeup and migration to another CPU
  */
 
 static void timehist_update_runtime_stats(struct thread_runtime *r,
@@ -2315,6 +2323,7 @@ static void timehist_update_runtime_stats(struct thread_runtime *r,
 	r->dt_iowait  = 0;
 	r->dt_preempt = 0;
 	r->dt_run     = 0;
+	r->dt_pre_mig = 0;
 
 	if (tprev) {
 		r->dt_run = t - tprev;
@@ -2323,6 +2332,9 @@ static void timehist_update_runtime_stats(struct thread_runtime *r,
 				pr_debug("time travel: wakeup time for task > previous sched_switch event\n");
 			else
 				r->dt_delay = tprev - r->ready_to_run;
+
+			if ((r->migrated > r->ready_to_run) && (r->migrated < tprev))
+				r->dt_pre_mig = r->migrated - r->ready_to_run;
 		}
 
 		if (r->last_time > tprev)
@@ -2346,6 +2358,7 @@ static void timehist_update_runtime_stats(struct thread_runtime *r,
 	r->total_sleep_time   += r->dt_sleep;
 	r->total_iowait_time  += r->dt_iowait;
 	r->total_preempt_time += r->dt_preempt;
+	r->total_pre_mig_time += r->dt_pre_mig;
 }
 
 static bool is_idle_sample(struct perf_sample *sample,
@@ -2762,9 +2775,13 @@ static int timehist_migrate_task_event(const struct perf_tool *tool,
 		return -1;
 
 	tr->migrations++;
+	tr->migrated = sample->time;
 
 	/* show migrations if requested */
-	timehist_print_migration_event(sched, evsel, sample, machine, thread);
+	if (sched->show_migrations) {
+		timehist_print_migration_event(sched, evsel, sample,
+							machine, thread);
+	}
 
 	return 0;
 }
@@ -2916,11 +2933,13 @@ static int timehist_sched_change_event(const struct perf_tool *tool,
 		/* last state is used to determine where to account wait time */
 		tr->last_state = state;
 
-		/* sched out event for task so reset ready to run time */
+		/* sched out event for task so reset ready to run time and migrated time */
 		if (state == 'R')
 			tr->ready_to_run = t;
 		else
 			tr->ready_to_run = 0;
+
+		tr->migrated = 0;
 	}
 
 	evsel__save_time(evsel, sample->time, sample->cpu);
@@ -3363,8 +3382,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 		goto out;
 	}
 
-	if (sched->show_migrations &&
-	    perf_session__set_tracepoints_handlers(session, migrate_handlers))
+	if ((sched->show_migrations || sched->pre_migrations) &&
+		perf_session__set_tracepoints_handlers(session, migrate_handlers))
 		goto out;
 
 	/* pre-allocate struct for per-CPU idle stats */
@@ -3919,6 +3938,7 @@ int cmd_sched(int argc, const char **argv)
 	OPT_BOOLEAN(0, "show-prio", &sched.show_prio, "Show task priority"),
 	OPT_STRING(0, "prio", &sched.prio_str, "prio",
 		   "analyze events only for given task priority(ies)"),
+	OPT_BOOLEAN('P', "pre-migrations", &sched.pre_migrations, "Show pre-migration wait time"),
 	OPT_PARENT(sched_options)
 	};
 
-- 
2.53.0



