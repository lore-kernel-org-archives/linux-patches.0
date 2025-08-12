Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C621A9F89;
	Tue, 12 Aug 2025 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024388; cv=none; b=DczcNhNbHzLvyGHp6L4/V/3uX9dsyCIMBkcSWTC9YpqzPEaxCEikyX8KeWWkyqixldaWJ0n2rfnPnGMklg9aurA4kQeRZF7oxy03sUEmQ1rwFlAEvB+6Ii2hGUMra/3RKGQOv82AtPO91d92qBGUZ0jl7bo7eKx3Ccj+Xs3HVss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024388; c=relaxed/simple;
	bh=6pUWw1bZq+FzutqoQAX2uk8KBZkQrECNTFA6Tbgme4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chcyi1kvDvoUopsmTjVxsfxOwjCy+njseKoNhpk5wQFKO/uTW3WNidV8mz0s3p1CE37X/hHGFaH0fmuwotC54XkGyPWRwNGf0wfTkq8ZiTpY8YvVf0w/r78CgjpAquz+SCdPt0yD93Pmpc3ki9GnRALkwmNEWGEw6ridcT1KK64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmvpeEx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmvpeEx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65914C4CEF0;
	Tue, 12 Aug 2025 18:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024387;
	bh=6pUWw1bZq+FzutqoQAX2uk8KBZkQrECNTFA6Tbgme4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmvpeEx6yjmGI2aXK84Vc00zLImbq5rs+6S7uzYeguggZyjK1dG0WLxIgN4LTH1y5
	 vMajd0wojPH+YM0rtkrHkwV4v6PwKqP32nrBeiv4YNqBQJGDMpxcDhfNCvUUBTYUuG
	 z/M+Y96Nf9pQ90hM+QWhkk63Y7Tg6+U0c3JiEg/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 359/627] perf sched: Fix memory leaks in perf sched map
Date: Tue, 12 Aug 2025 19:30:54 +0200
Message-ID: <20250812173432.952954502@linuxfoundation.org>
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
index fa4052e04020..b73989fb6ace 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1634,6 +1634,7 @@ static int map_switch_event(struct perf_sched *sched, struct evsel *evsel,
 	const char *color = PERF_COLOR_NORMAL;
 	char stimestamp[32];
 	const char *str;
+	int ret = -1;
 
 	BUG_ON(this_cpu.cpu >= MAX_CPUS || this_cpu.cpu < 0);
 
@@ -1664,17 +1665,20 @@ static int map_switch_event(struct perf_sched *sched, struct evsel *evsel,
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
@@ -1769,12 +1773,10 @@ static int map_switch_event(struct perf_sched *sched, struct evsel *evsel,
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
@@ -3556,10 +3558,10 @@ static int perf_sched__map(struct perf_sched *sched)
 
 	sched->curr_out_thread = calloc(MAX_CPUS, sizeof(*(sched->curr_out_thread)));
 	if (!sched->curr_out_thread)
-		return rc;
+		goto out_free_curr_thread;
 
 	if (setup_cpus_switch_event(sched))
-		goto out_free_curr_thread;
+		goto out_free_curr_out_thread;
 
 	if (setup_map_cpus(sched))
 		goto out_free_cpus_switch_event;
@@ -3590,7 +3592,14 @@ static int perf_sched__map(struct perf_sched *sched)
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



