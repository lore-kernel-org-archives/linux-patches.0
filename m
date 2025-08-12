Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DCE26CE2B;
	Tue, 12 Aug 2025 18:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024391; cv=none; b=RrnYJ9y39Kk73N3gqtg43h9m+t/cDyG6P1DqXKBwgT+6eDBJNu1vOiJwKv5ggaCkB2GX9f41IxtkdmqEYNTXhvBXedZQP9sZV/UScguxfA2+P7zQ8OLZGnwFbsIPjChtdRMDsqRePxvlUUy6IG+sgtpDSS7SJ4SzSDgYNB4yMy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024391; c=relaxed/simple;
	bh=UPuo8bZXSJkV9BAQUwed12fhPKG76XgBSi901c+m/1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qj0kqKINW8avAmnT7Jzgnlv4G+b5if8iIkefJaUmkd7P+YcOOmlF91t+RbAMyISNFKF/pkTqaCkiu/EWAtyM5/2ixgh/xEono/BDn2ONuorOgKWtVsbCBFWmZ79xHhJLbS1gcRWymGsmmJ0IypPE2WVohLNg1LsyqmHJSxaUk5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5oBo76W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5oBo76W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D38EC4CEF0;
	Tue, 12 Aug 2025 18:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024391;
	bh=UPuo8bZXSJkV9BAQUwed12fhPKG76XgBSi901c+m/1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5oBo76WyfrPoqC4DlmCizJXnvhPyErSR6spfvJXtksddXYDL8Yhl833heShFuVAT
	 woWdO5BOz7lDZ3I25SwoLNu56RdWnV/8EpLFuFnGSUqbrFtQ3ADr9rG8qdEeBiUL+d
	 NXhb/cRpz0FueIb9h5BXyzPhWR1/DNLCNa+TL3UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 360/627] perf sched: Fix thread leaks in perf sched timehist
Date: Tue, 12 Aug 2025 19:30:55 +0200
Message-ID: <20250812173432.989638205@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit e2eb59260c4f6bac403491d0112891766b8650d1 ]

Add missing thread__put() after machine__findnew_thread() or
timehist_get_thread().  Also idle threads' last_thread should be
refcounted properly.

Fixes: 699b5b920db04a6f ("perf sched timehist: Save callchain when entering idle")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250703014942.1369397-5-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 48 +++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index b73989fb6ace..83b5a85a91b7 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2313,8 +2313,10 @@ static void save_task_callchain(struct perf_sched *sched,
 		return;
 	}
 
-	if (!sched->show_callchain || sample->callchain == NULL)
+	if (!sched->show_callchain || sample->callchain == NULL) {
+		thread__put(thread);
 		return;
+	}
 
 	cursor = get_tls_callchain_cursor();
 
@@ -2323,10 +2325,12 @@ static void save_task_callchain(struct perf_sched *sched,
 		if (verbose > 0)
 			pr_err("Failed to resolve callchain. Skipping\n");
 
+		thread__put(thread);
 		return;
 	}
 
 	callchain_cursor_commit(cursor);
+	thread__put(thread);
 
 	while (true) {
 		struct callchain_cursor_node *node;
@@ -2403,8 +2407,17 @@ static void free_idle_threads(void)
 		return;
 
 	for (i = 0; i < idle_max_cpu; ++i) {
-		if ((idle_threads[i]))
-			thread__delete(idle_threads[i]);
+		struct thread *idle = idle_threads[i];
+
+		if (idle) {
+			struct idle_thread_runtime *itr;
+
+			itr = thread__priv(idle);
+			if (itr)
+				thread__put(itr->last_thread);
+
+			thread__delete(idle);
+		}
 	}
 
 	free(idle_threads);
@@ -2441,7 +2454,7 @@ static struct thread *get_idle_thread(int cpu)
 		}
 	}
 
-	return idle_threads[cpu];
+	return thread__get(idle_threads[cpu]);
 }
 
 static void save_idle_callchain(struct perf_sched *sched,
@@ -2496,7 +2509,8 @@ static struct thread *timehist_get_thread(struct perf_sched *sched,
 			if (itr == NULL)
 				return NULL;
 
-			itr->last_thread = thread;
+			thread__put(itr->last_thread);
+			itr->last_thread = thread__get(thread);
 
 			/* copy task callchain when entering to idle */
 			if (evsel__intval(evsel, sample, "next_pid") == 0)
@@ -2567,6 +2581,7 @@ static void timehist_print_wakeup_event(struct perf_sched *sched,
 	/* show wakeup unless both awakee and awaker are filtered */
 	if (timehist_skip_sample(sched, thread, evsel, sample) &&
 	    timehist_skip_sample(sched, awakened, evsel, sample)) {
+		thread__put(thread);
 		return;
 	}
 
@@ -2583,6 +2598,8 @@ static void timehist_print_wakeup_event(struct perf_sched *sched,
 	printf("awakened: %s", timehist_get_commstr(awakened));
 
 	printf("\n");
+
+	thread__put(thread);
 }
 
 static int timehist_sched_wakeup_ignore(const struct perf_tool *tool __maybe_unused,
@@ -2611,8 +2628,10 @@ static int timehist_sched_wakeup_event(const struct perf_tool *tool,
 		return -1;
 
 	tr = thread__get_runtime(thread);
-	if (tr == NULL)
+	if (tr == NULL) {
+		thread__put(thread);
 		return -1;
+	}
 
 	if (tr->ready_to_run == 0)
 		tr->ready_to_run = sample->time;
@@ -2622,6 +2641,7 @@ static int timehist_sched_wakeup_event(const struct perf_tool *tool,
 	    !perf_time__skip_sample(&sched->ptime, sample->time))
 		timehist_print_wakeup_event(sched, evsel, sample, machine, thread);
 
+	thread__put(thread);
 	return 0;
 }
 
@@ -2649,6 +2669,7 @@ static void timehist_print_migration_event(struct perf_sched *sched,
 
 	if (timehist_skip_sample(sched, thread, evsel, sample) &&
 	    timehist_skip_sample(sched, migrated, evsel, sample)) {
+		thread__put(thread);
 		return;
 	}
 
@@ -2676,6 +2697,7 @@ static void timehist_print_migration_event(struct perf_sched *sched,
 	printf(" cpu %d => %d", ocpu, dcpu);
 
 	printf("\n");
+	thread__put(thread);
 }
 
 static int timehist_migrate_task_event(const struct perf_tool *tool,
@@ -2695,8 +2717,10 @@ static int timehist_migrate_task_event(const struct perf_tool *tool,
 		return -1;
 
 	tr = thread__get_runtime(thread);
-	if (tr == NULL)
+	if (tr == NULL) {
+		thread__put(thread);
 		return -1;
+	}
 
 	tr->migrations++;
 	tr->migrated = sample->time;
@@ -2706,6 +2730,7 @@ static int timehist_migrate_task_event(const struct perf_tool *tool,
 		timehist_print_migration_event(sched, evsel, sample,
 							machine, thread);
 	}
+	thread__put(thread);
 
 	return 0;
 }
@@ -2728,10 +2753,10 @@ static void timehist_update_task_prio(struct evsel *evsel,
 		return;
 
 	tr = thread__get_runtime(thread);
-	if (tr == NULL)
-		return;
+	if (tr != NULL)
+		tr->prio = next_prio;
 
-	tr->prio = next_prio;
+	thread__put(thread);
 }
 
 static int timehist_sched_change_event(const struct perf_tool *tool,
@@ -2743,7 +2768,7 @@ static int timehist_sched_change_event(const struct perf_tool *tool,
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 	struct perf_time_interval *ptime = &sched->ptime;
 	struct addr_location al;
-	struct thread *thread;
+	struct thread *thread = NULL;
 	struct thread_runtime *tr = NULL;
 	u64 tprev, t = sample->time;
 	int rc = 0;
@@ -2867,6 +2892,7 @@ static int timehist_sched_change_event(const struct perf_tool *tool,
 
 	evsel__save_time(evsel, sample->time, sample->cpu);
 
+	thread__put(thread);
 	addr_location__exit(&al);
 	return rc;
 }
-- 
2.39.5



