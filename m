Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3181A61FFE;
	Tue, 12 Aug 2025 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022635; cv=none; b=sbFmBcIY+cCmCDttnfwvxmYmY7c4RTwxVZNnih1VOFHF8CkTGbWb0xLpfOGx1naJW1GF9f4zPgZPwb5IwyqDrQGQGpots6PSye3ewcxQLpW/sR7/keouzhaM3ItOAImRMOpj0/BZ+8uhEhMbVH1KmaSj0OGJmNOZfCgYsHHqpno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022635; c=relaxed/simple;
	bh=2NhMcA2h85UBndp3Y++bCgW6paMTRe5ORL7XLP6EcfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lU5Eiy9jm3BhfcelkiueUPKNLYYyjZjSvuq9z6GLdTZk4jJjdF9PdPLUPsVy7k+3pVV/U77lVIr3NAWjb9eli9dfzZUxrmLOexPHOcEmk16Skwo8fJyugXjNfowKhbKVETD2xtgwXroMVe6iQwW4EvMfl2+JuYS7rYCFTgrm9qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QH/sPQ9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QH/sPQ9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDDDC4CEF0;
	Tue, 12 Aug 2025 18:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022634;
	bh=2NhMcA2h85UBndp3Y++bCgW6paMTRe5ORL7XLP6EcfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QH/sPQ9R9qOAmQnwxfJ7ckXQUOEthQzEAduEDWLk40S0JC9QCiuotNuOQVo8YVIWY
	 g9klZDE+wh9WrpinNWtH6dUPrBaqwRMhaYtlfCIczdT+BMy4asoeMNDtzPsGHtrnn+
	 ZO5iwS7GdEdPWPX6sUo1jIyuvXdVhd7coRGyd/dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/369] perf sched: Fix memory leaks in perf sched map
Date: Tue, 12 Aug 2025 19:27:57 +0200
Message-ID: <20250812173021.546168110@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit dc3a80c98884d86389b3b572c50ccc7f502cd41b ]

It maintains per-cpu pointers for the current thread but it doesn't
release the refcounts.

Fixes: 5e895278697c014e ("perf sched: Move curr_thread initialization to perf_sched__map()")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250703014942.1369397-4-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c55388b36ac5..cd15c0cba9b2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1639,6 +1639,7 @@ static int map_switch_event(struct perf_sched *sched, struct evsel *evsel,
 	const char *color = PERF_COLOR_NORMAL;
 	char stimestamp[32];
 	const char *str;
+	int ret = -1;
 
 	BUG_ON(this_cpu.cpu >= MAX_CPUS || this_cpu.cpu < 0);
 
@@ -1669,17 +1670,20 @@ static int map_switch_event(struct perf_sched *sched, struct evsel *evsel,
 	sched_in = map__findnew_thread(sched, machine, -1, next_pid);
 	sched_out = map__findnew_thread(sched, machine, -1, prev_pid);
 	if (sched_in == NULL || sched_out == NULL)
-		return -1;
+		goto out;
 
 	tr = thread__get_runtime(sched_in);
-	if (tr == NULL) {
-		thread__put(sched_in);
-		return -1;
-	}
+	if (tr == NULL)
+		goto out;
+
+	thread__put(sched->curr_thread[this_cpu.cpu]);
+	thread__put(sched->curr_out_thread[this_cpu.cpu]);
 
 	sched->curr_thread[this_cpu.cpu] = thread__get(sched_in);
 	sched->curr_out_thread[this_cpu.cpu] = thread__get(sched_out);
 
+	ret = 0;
+
 	str = thread__comm_str(sched_in);
 	new_shortname = 0;
 	if (!tr->shortname[0]) {
@@ -1774,12 +1778,10 @@ static int map_switch_event(struct perf_sched *sched, struct evsel *evsel,
 	color_fprintf(stdout, color, "\n");
 
 out:
-	if (sched->map.task_name)
-		thread__put(sched_out);
-
+	thread__put(sched_out);
 	thread__put(sched_in);
 
-	return 0;
+	return ret;
 }
 
 static int process_sched_switch_event(const struct perf_tool *tool,
@@ -3546,10 +3548,10 @@ static int perf_sched__map(struct perf_sched *sched)
 
 	sched->curr_out_thread = calloc(MAX_CPUS, sizeof(*(sched->curr_out_thread)));
 	if (!sched->curr_out_thread)
-		return rc;
+		goto out_free_curr_thread;
 
 	if (setup_cpus_switch_event(sched))
-		goto out_free_curr_thread;
+		goto out_free_curr_out_thread;
 
 	if (setup_map_cpus(sched))
 		goto out_free_cpus_switch_event;
@@ -3580,7 +3582,14 @@ static int perf_sched__map(struct perf_sched *sched)
 out_free_cpus_switch_event:
 	free_cpus_switch_event(sched);
 
+out_free_curr_out_thread:
+	for (int i = 0; i < MAX_CPUS; i++)
+		thread__put(sched->curr_out_thread[i]);
+	zfree(&sched->curr_out_thread);
+
 out_free_curr_thread:
+	for (int i = 0; i < MAX_CPUS; i++)
+		thread__put(sched->curr_thread[i]);
 	zfree(&sched->curr_thread);
 	return rc;
 }
-- 
2.39.5



