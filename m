Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC78E35C1B4;
	Tue, 16 Dec 2025 12:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886757; cv=none; b=VgbAfIoimdy6HZOSWyXCkacTJB2c9yOtFM9NV9gZLsbE1iPVJ3pvrzFg5e44mIDd609NElw4pinGYkMNZ9yUFDZrVmtsjOOxCuY5fLJM0HFH2oLB20SnykamjaQZG5vYdtxH/zXNNIAvriKC9R38gEz5LQ1CmRvZD9qkaQkBQzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886757; c=relaxed/simple;
	bh=EXe8TyD2/HkhUAcFvQ106kH8INsC+gLrkJZXYP5WtLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORx8H4E755W/pY1SkhDDr/gUxvGmtgHOOiJfjvF+p3jHHzHAYPASi+7OPDgXn5VviFJz+gkLbfL2ZG9PzhXFuKQkrTUzEqbZd7LlCknRMqkuIr+r3xDo6rOi97XnfSmPtaK6BuJVTlttcHe7DhWINAfW3bR7gvdRo46ia/6d8ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkO1oLPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkO1oLPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD90C4CEF1;
	Tue, 16 Dec 2025 12:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886757;
	bh=EXe8TyD2/HkhUAcFvQ106kH8INsC+gLrkJZXYP5WtLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkO1oLPTsBv/nF7ZJcpNOCPTGXuUBCF4nesG5FE2CEvt8zBf3Lv0sLGtx8Oc2oz0b
	 z1+mjBcxQ+uaQ02s0hSYPjrZxBUPs4PFPYJqX3AlZQ3OzkiOJtMBaV/nM6LiKUBeMo
	 zLiI+6oefI18Ly/b7VUh8VxtSH4MMS01W3wSuioc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/614] perf bpf_counter: Fix opening of "any"(-1) CPU events
Date: Tue, 16 Dec 2025 12:06:30 +0100
Message-ID: <20251216111402.144230281@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 2a67955de13624ec17d1c2504d2c9eeb37933b77 ]

The bperf BPF counter code doesn't handle "any"(-1) CPU events, always
wanting to aggregate a count against a CPU, which avoids the need for
atomics so let's not change that. Force evsels used for BPF counters
to require a CPU when not in system-wide mode so that the "any"(-1)
value isn't used during map propagation and evsel's CPU map matches
that of the PMU.

Fixes: b91917c0c6fa ("perf bpf_counter: Fix handling of cpumap fixing hybrid")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c     | 13 +++++++++++++
 tools/perf/util/bpf_counter.c |  7 ++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7006f848f87a6..f1c9d6c94fc50 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2540,6 +2540,7 @@ int cmd_stat(int argc, const char **argv)
 	unsigned int interval, timeout;
 	const char * const stat_subcommands[] = { "record", "report" };
 	char errbuf[BUFSIZ];
+	struct evsel *counter;
 
 	setlocale(LC_ALL, "");
 
@@ -2797,6 +2798,18 @@ int cmd_stat(int argc, const char **argv)
 
 	evlist__warn_user_requested_cpus(evsel_list, target.cpu_list);
 
+	evlist__for_each_entry(evsel_list, counter) {
+		/*
+		 * Setup BPF counters to require CPUs as any(-1) isn't
+		 * supported. evlist__create_maps below will propagate this
+		 * information to the evsels. Note, evsel__is_bperf isn't yet
+		 * set up, and this change must happen early, so directly use
+		 * the bpf_counter variable and target information.
+		 */
+		if ((counter->bpf_counter || target.use_bpf) && !target__has_cpu(&target))
+			counter->core.requires_cpu = true;
+	}
+
 	if (evlist__create_maps(evsel_list, &target) < 0) {
 		if (target__has_task(&target)) {
 			pr_err("Problems finding threads of monitor\n");
diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index ca5d01b9017db..a5882b5822057 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -460,6 +460,7 @@ static int bperf_reload_leader_program(struct evsel *evsel, int attr_map_fd,
 	struct bperf_leader_bpf *skel = bperf_leader_bpf__open();
 	int link_fd, diff_map_fd, err;
 	struct bpf_link *link = NULL;
+	struct perf_thread_map *threads;
 
 	if (!skel) {
 		pr_err("Failed to open leader skeleton\n");
@@ -495,7 +496,11 @@ static int bperf_reload_leader_program(struct evsel *evsel, int attr_map_fd,
 	 * following evsel__open_per_cpu call
 	 */
 	evsel->leader_skel = skel;
-	evsel__open(evsel, evsel->core.cpus, evsel->core.threads);
+	assert(!perf_cpu_map__has_any_cpu_or_is_empty(evsel->core.cpus));
+	/* Always open system wide. */
+	threads = thread_map__new_by_tid(-1);
+	evsel__open(evsel, evsel->core.cpus, threads);
+	perf_thread_map__put(threads);
 
 out:
 	bperf_leader_bpf__destroy(skel);
-- 
2.51.0



