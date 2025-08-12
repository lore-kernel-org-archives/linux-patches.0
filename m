Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B835421ABD0;
	Tue, 12 Aug 2025 19:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026289; cv=none; b=mqpfhBDmJoCPmJZIx/NuKoQXIv0D+nwktUzBcu06cIUwveIw/J3aFdT0GbQDFLhTmDu2jgeGBrgrb7hvb7y8yc0pI1PXBvwJuXMmNOayvu8EGEt5GSbISfNdRgZmqAKmVTu6IZgV8NN/JDqHh/18k2Nn2IfdtnuvWz+mkPNieiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026289; c=relaxed/simple;
	bh=V1edUTrneUwM73yVAop8YM2e1LKJ1/L8nhJEZXnAB4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k66wJpoNO0d3HvvsvGbT4oZoO9rmzPeEiGbc9D/SV07amy3QD62WURLHOJI2tFriIl/s5AvJtKfAS2aw2zzS4M0/U06aBQgrRLVTTbLcd3xc1s5qLxC8vomikTa0Mc486+s5ItrKtYG1R4H+PIwM4KB3D5tux7xyNbVt49YBkjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vorYXHdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vorYXHdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A71C4CEF0;
	Tue, 12 Aug 2025 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026289;
	bh=V1edUTrneUwM73yVAop8YM2e1LKJ1/L8nhJEZXnAB4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vorYXHdVP1Ke7Y7JqdPjiqJYG7JCGlTS+emRNbhvJS3czqot10KYejMDeQP8GO7GK
	 ZLSL9fSx89S5q7C/DJaB3z5plgoiSw0L42jNyTivGXKC+sD/+MQa4JK1l5a4negoJI
	 1drC3Oi84+URlENC826Kuwm2wJIyV9tiW89RoQ/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 260/480] perf sched: Fix memory leaks in perf sched map
Date: Tue, 12 Aug 2025 19:47:48 +0200
Message-ID: <20250812174408.165417185@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



