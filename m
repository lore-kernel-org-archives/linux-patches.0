Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6062345CA2;
	Tue, 16 Dec 2025 11:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885041; cv=none; b=cYH8u5+U+i3MLg58BrVgD1Hd9omN8r0daIa7HPzSzHWL4PReNZsvPm0pryB8/Keklaf/88PiugAGISem/BD6dVDtJ5tQLO0ZWN4esn+nPf0/0YmE+4EWC6EU/KmaOMrheXbQVxIhC+8yeKWkt79h9hgaTiLNascJgcsOIn+QDRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885041; c=relaxed/simple;
	bh=W0UlnpTOq/nIFHzLFyRdjmFpFdDPuqraWq0IM19U1k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAqIQ0zfAZDKRNINjObX2+89+3kTUJiZ+4BmmA68lQ29mLc/PzsuprlWgdIvCN48VMlUlbjKLkentLReh1/TsCIK0YrJ2bxB0+9HjCekDPbv5o+UcKa/+CnLo79ZWFJh+pT3JLlKn9FP2lptEfCGzDiNyla38MZWv9jyUNgg3tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ln+GP4Ug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ln+GP4Ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0C6C4CEF1;
	Tue, 16 Dec 2025 11:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885041;
	bh=W0UlnpTOq/nIFHzLFyRdjmFpFdDPuqraWq0IM19U1k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ln+GP4UglWCEkaDzV7FqZgkdwhdT5IMFFfGDfwbZFBef+tpyISSAhgNV4ck4w6L5G
	 hsd0KBDI0T+t8Uo5vaneF2oZR+ESCDep/MPNya/pUbRKV5KoOarzlaqBxtg3DXAt2a
	 WJr0KQnSvH4jCkA7+tRYpAD7UDt7zzwOekW/gtAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 020/507] perf bpf_counter: Fix opening of "any"(-1) CPU events
Date: Tue, 16 Dec 2025 12:07:41 +0100
Message-ID: <20251216111346.268118933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 2c38dd98f6cae..64af743bb10a4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2511,6 +2511,7 @@ int cmd_stat(int argc, const char **argv)
 	unsigned int interval, timeout;
 	const char * const stat_subcommands[] = { "record", "report" };
 	char errbuf[BUFSIZ];
+	struct evsel *counter;
 
 	setlocale(LC_ALL, "");
 
@@ -2768,6 +2769,18 @@ int cmd_stat(int argc, const char **argv)
 
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
index ed88ba570c80a..af31aa28ff445 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -402,6 +402,7 @@ static int bperf_reload_leader_program(struct evsel *evsel, int attr_map_fd,
 	struct bperf_leader_bpf *skel = bperf_leader_bpf__open();
 	int link_fd, diff_map_fd, err;
 	struct bpf_link *link = NULL;
+	struct perf_thread_map *threads;
 
 	if (!skel) {
 		pr_err("Failed to open leader skeleton\n");
@@ -437,7 +438,11 @@ static int bperf_reload_leader_program(struct evsel *evsel, int attr_map_fd,
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



