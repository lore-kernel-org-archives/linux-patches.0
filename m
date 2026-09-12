Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E662144C504;
	Sat, 12 Sep 2026 08:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202778; cv=none; b=sDwxIrQzD0xezwqMpDdF8uz0JXH4BxdOHeti4OQ0Io6z6RVdYh/LNIzjTTmeVMefRxZP3tdkSS88RM4v3JnXAHrmppfVuk+k8fCP+NugNjXN7I46N3n81DCmwpQQWBK+em2BYZ3n3nK/MrLWyyVyb1CGDgHfRha2i50EFean7h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202778; c=relaxed/simple;
	bh=s19AazJsm7fFXwPk6p8fQiVLjEAqvxHXRs8ZAN5WhAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dp34psroKuBAQf8Lsqiya+quO3vACa+je/diuvYlayjVbQAiezkcO3ssPpdJOMEKOhuizhHUTU3VifQdqfsHlpQHi2BnSyzXLh+Aj4PyDPWvkMSpXf7ZWZTDwPucHGsaexVxJ/9btsYMJq9f7orMdFeGszi2Yw0h6SBtYhlNXgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LInCe5Sn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LInCe5Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F25E1F000FF;
	Sat, 12 Sep 2026 08:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202776;
	bh=LRNGueApIwxmwyUIs6EKmM4tAddA9Zz9+9eubvbooxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LInCe5Sntga82E3oyy6X76A30cjaYwzRIAmFxhF+FcFluTdIWQzAaWvrmTH59UE52
	 AFtmY40a8XxX9P37xUZuPMIv1mO5gJ/72O0ywc5gAjblWq6FzvO9Qkvc33Ak+oYsek
	 cfCHjJgLAmGqPjY0/pRxpaHdiqwG2X1qNvnQQ8C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1236/1815] perf sched: Handle missing trace samples in pipe mode
Date: Sat, 12 Sep 2026 08:49:46 +0200
Message-ID: <20260912065718.029450627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit 44f8dd1ee1d55db399a443e1715cd8cdd3268362 ]

For pipe mode streams, event attributes are received dynamically during
event processing, meaning session->evlist is not populated prior to
perf_session__process_events(). To handle pipe input correctly:
  - Register the missing .attr, .tracing_data, .build_id, and .feature
    callbacks in cmd_sched()

  - Promote the handlers array to file-scope (latency_handlers[]) and
    dynamically assign matching tracepoint handlers
    (or process_sched_ignore) inside
    perf_sched__process_tracepoint_sample() when evsel->handler is NULL;
    replace process_sched_wakeup_ignore() with process_sched_ignore()

  - Perform the trace check post-processing when handling pipe data

Fixes: 27295592c22e ("perf session: Share the common trace sample_check routine as perf_session__has_traces")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 72 +++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9c89991b24a28..d0921bd0ce758 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1581,12 +1581,6 @@ static int process_sched_wakeup_event(const struct perf_tool *tool,
 	return 0;
 }
 
-static int process_sched_wakeup_ignore(const struct perf_tool *tool __maybe_unused,
-				      struct perf_sample *sample __maybe_unused,
-				      struct machine *machine __maybe_unused)
-{
-	return 0;
-}
 
 static bool thread__has_color(struct thread *thread)
 {
@@ -1938,6 +1932,22 @@ typedef int (*tracepoint_handler)(const struct perf_tool *tool,
 				  struct perf_sample *sample,
 				  struct machine *machine);
 
+static struct evsel_str_handler latency_handlers[] = {
+	{ "sched:sched_switch",       process_sched_switch_event, },
+	{ "sched:sched_stat_runtime", process_sched_runtime_event, },
+	{ "sched:sched_wakeup",       process_sched_wakeup_event, },
+	{ "sched:sched_waking",       process_sched_wakeup_event, },
+	{ "sched:sched_wakeup_new",   process_sched_wakeup_event, },
+	{ "sched:sched_migrate_task", process_sched_migrate_task_event, },
+};
+
+static int process_sched_ignore(const struct perf_tool *tool __maybe_unused,
+				struct perf_sample *sample __maybe_unused,
+				struct machine *machine __maybe_unused)
+{
+	return 0;
+}
+
 static int perf_sched__process_tracepoint_sample(const struct perf_tool *tool __maybe_unused,
 						 union perf_event *event __maybe_unused,
 						 struct perf_sample *sample,
@@ -1946,7 +1956,23 @@ static int perf_sched__process_tracepoint_sample(const struct perf_tool *tool __
 	struct evsel *evsel = sample->evsel;
 	int err = 0;
 
-	if (evsel->handler != NULL) {
+	if (evsel->handler == NULL) {
+		evsel->handler = process_sched_ignore;
+		for (size_t i = 0; i < ARRAY_SIZE(latency_handlers); i++) {
+			if (!evsel__name_is(evsel, latency_handlers[i].name))
+				continue;
+
+			if (!strcmp(latency_handlers[i].name, "sched:sched_wakeup") &&
+			    sample->evsel->evlist &&
+			    evlist__find_tracepoint_by_name(sample->evsel->evlist, "sched:sched_waking"))
+				break;
+
+			evsel->handler = latency_handlers[i].handler;
+			break;
+		}
+	}
+
+	if (evsel->handler != process_sched_ignore) {
 		tracepoint_handler f = evsel->handler;
 		err = f(tool, sample, machine);
 	}
@@ -1987,14 +2013,6 @@ static int perf_sched__process_comm(const struct perf_tool *tool __maybe_unused,
 
 static int perf_sched__read_events(struct perf_sched *sched)
 {
-	struct evsel_str_handler handlers[] = {
-		{ "sched:sched_switch",	      process_sched_switch_event, },
-		{ "sched:sched_stat_runtime", process_sched_runtime_event, },
-		{ "sched:sched_wakeup",	      process_sched_wakeup_event, },
-		{ "sched:sched_waking",	      process_sched_wakeup_event, },
-		{ "sched:sched_wakeup_new",   process_sched_wakeup_event, },
-		{ "sched:sched_migrate_task", process_sched_migrate_task_event, },
-	};
 	struct perf_session *session;
 	struct perf_data data = {
 		.path  = input_name,
@@ -2011,14 +2029,17 @@ static int perf_sched__read_events(struct perf_sched *sched)
 
 	symbol__init(perf_session__env(session));
 
-	/* prefer sched_waking if it is captured */
-	if (evlist__find_tracepoint_by_name(session->evlist, "sched:sched_waking"))
-		handlers[2].handler = process_sched_wakeup_ignore;
+	if (!perf_data__is_pipe(session->data)) {
+		/* prefer sched_waking if it is captured */
+		if (evlist__find_tracepoint_by_name(session->evlist, "sched:sched_waking"))
+			latency_handlers[2].handler = process_sched_ignore;
 
-	if (perf_session__set_tracepoints_handlers(session, handlers))
-		goto out_delete;
+		if (perf_session__set_tracepoints_handlers(session, latency_handlers))
+			goto out_delete;
+	}
 
-	if (!perf_session__has_traces(session, "record -R"))
+	if (!perf_data__is_pipe(session->data) &&
+	    !perf_session__has_traces(session, "record -R"))
 		goto out_delete;
 
 	err = perf_session__process_events(session);
@@ -2027,6 +2048,11 @@ static int perf_sched__read_events(struct perf_sched *sched)
 		goto out_delete;
 	}
 
+	if (perf_data__is_pipe(session->data) &&
+	    !perf_session__has_traces(session, "record -R")) {
+		goto out_delete;
+	}
+
 	sched->nr_events      = evlist__stats(session->evlist)->nr_events[0];
 	sched->nr_lost_events = evlist__stats(session->evlist)->total_lost;
 	sched->nr_lost_chunks = evlist__stats(session->evlist)->nr_events[PERF_RECORD_LOST];
@@ -5172,6 +5198,10 @@ int cmd_sched(int argc, const char **argv)
 	sched.tool.namespaces	 = perf_event__process_namespaces;
 	sched.tool.lost		 = perf_event__process_lost;
 	sched.tool.fork		 = perf_sched__process_fork_event;
+	sched.tool.attr		 = perf_event__process_attr;
+	sched.tool.tracing_data	 = perf_event__process_tracing_data;
+	sched.tool.build_id	 = perf_event__process_build_id;
+	sched.tool.feature       = perf_event__process_feature;
 
 	argc = parse_options_subcommand(argc, argv, sched_options, sched_subcommands,
 					sched_usage, PARSE_OPT_STOP_AT_NON_OPTION);
-- 
2.53.0



