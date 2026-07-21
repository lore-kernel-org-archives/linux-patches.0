Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C53415F1B;
	Tue, 21 Jul 2026 18:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657101; cv=none; b=oRH+FY+QlAUjXRt6REGcnA6PCg1+EkA3l6w+Iz3UIkLSYQ2FDolETp5wpx5WUt0pAtkP++vs/+aHHhyzWN4nTpQQU1/juqFK7ubVifBhoMJ7mR+CjjjP/vTzXVLM9yIM07DAI5Ot1wUEn93YF/f2+Fb3qG+KKs2PjBmlGlgmksg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657101; c=relaxed/simple;
	bh=1OWLZ30L0wp2VWvEcn1qZy90qpTGrpM6Ii+vuA88qEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSzrGxlExaF3lHDMX4jb/IhNhKKdbtPj1oEhADbmdq2Pu285u9OHvBZaGMOfU6A2AfQU1vI7msk7UEzL3Rqir6QDic7dxiTRRLC9uLeATDuWKHbhZoHnc9kFPnwJOrkH0flHIBEYMX+KR2kFZesGFaGJyJzuD38ry9SCKn8Xq8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIpOvHLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIpOvHLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368141F000E9;
	Tue, 21 Jul 2026 18:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657099;
	bh=DHZh8WTcgZBEtlQr5mwpUsEaN6ZWt9IAz4IOqHbNNXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIpOvHLAv7KR6lNu+eqB/tN8f3yd2c5MmrRK5ExVsMfH2oxnraGj82I1YA0E7sNWq
	 DfrD/kHHeQ2BNYEKx922JDu/pvXQkBxuZqlBpAsLlh4uSY2/krgwkBzcg6Y6OjzSeG
	 nrAwY8mQvDigQyhTrcVQzv54Mvr+WOmPa2EzU2yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Blanchard <anton@samba.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0636/1611] perf tools: Guard test_bit from out-of-bounds sample CPU
Date: Tue, 21 Jul 2026 17:12:32 +0200
Message-ID: <20260721152529.695709115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit a5498ccf8079fc91c938f122ff9697b0c526b2fd ]

When PERF_SAMPLE_CPU is absent from a perf.data file, sample->cpu is
initialized to (u32)-1 by evsel__parse_sample().  Five call sites pass
this value directly to test_bit(sample->cpu, cpu_bitmap), reading
massively out of bounds past the DECLARE_BITMAP(..., MAX_NR_CPUS)
allocation of 4096 bits.

Add a sample->cpu >= MAX_NR_CPUS guard before each test_bit() call,
matching the existing safe pattern in builtin-kwork.c.  This catches
both the (u32)-1 sentinel and any corrupted CPU value exceeding the
bitmap size.

Fixes: 5d67be97f890 ("perf report/annotate/script: Add option to specify a CPU range")
Cc: Anton Blanchard <anton@samba.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-annotate.c | 3 ++-
 tools/perf/builtin-diff.c     | 3 ++-
 tools/perf/builtin-report.c   | 3 ++-
 tools/perf/builtin-sched.c    | 6 ++++--
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 646f43b0f7c4c9..0485bddb024644 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -299,7 +299,8 @@ static int process_sample_event(const struct perf_tool *tool,
 		goto out_put;
 	}
 
-	if (ann->cpu_list && !test_bit(sample->cpu, ann->cpu_bitmap))
+	if (ann->cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			     !test_bit(sample->cpu, ann->cpu_bitmap)))
 		goto out_put;
 
 	if (!al.filtered &&
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 53d5ea4a6a4f7b..a41568b0b8d812 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -418,7 +418,8 @@ static int diff__process_sample_event(const struct perf_tool *tool,
 		goto out;
 	}
 
-	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap)) {
+	if (cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			!test_bit(sample->cpu, cpu_bitmap))) {
 		ret = 0;
 		goto out;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 35df04dad2fd08..fd5bd3d9768626 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -303,7 +303,8 @@ static int process_sample_event(const struct perf_tool *tool,
 	if (symbol_conf.hide_unresolved && al.sym == NULL)
 		goto out_put;
 
-	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
+	if (rep->cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			     !test_bit(sample->cpu, rep->cpu_bitmap)))
 		goto out_put;
 
 	if (sort__mode == SORT_MODE__BRANCH) {
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index ce0858f309e164..8310aa23cbb3c5 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2168,7 +2168,8 @@ static void timehist_print_sample(struct perf_sched *sched,
 	char nstr[30];
 	u64 wait_time;
 
-	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+	if (cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			!test_bit(sample->cpu, cpu_bitmap)))
 		return;
 
 	timestamp__scnprintf_usec(t, tstr, sizeof(tstr));
@@ -2850,7 +2851,8 @@ static int timehist_sched_change_event(const struct perf_tool *tool,
 	}
 
 	if (!sched->idle_hist || thread__tid(thread) == 0) {
-		if (!cpu_list || test_bit(sample->cpu, cpu_bitmap))
+		if (!cpu_list || (sample->cpu < MAX_NR_CPUS &&
+				 test_bit(sample->cpu, cpu_bitmap)))
 			timehist_update_runtime_stats(tr, t, tprev);
 
 		if (sched->idle_hist) {
-- 
2.53.0



