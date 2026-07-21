Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A4E22B8DF;
	Tue, 21 Jul 2026 18:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660301; cv=none; b=OLKJyenUohI8nIyDZyyRwGfs11TPaiz8dSvOqbkKA4yn9SpypoZPSY42WVgiVyk9524BzNjsP5crmTmrAe3G+5AIc7RqOhO6MznNhAJTrTEo4dHcqQq2bCSxyyHsWQwcgv6XfzyOnB0gspwKP5dTHCAyQ2t6FqByWDGWZ3GbY8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660301; c=relaxed/simple;
	bh=pPFIxINLB3aT5b/+lgme+IvdEk4SrVL6zh8qC+sUm1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJARgDdVOls1bWJ7pIHBc61vIUJAf2NHkzUkWf0dM+OW9cyhAs12U8LqueCBnAj7shLwP55Gz3WZJDfINKeXSCCArKYPARLTc9BC90l0ERh6ztIHTv2/FQQaVUCFZexPJ1ZTyVxXhtqZ1htFq+RH9dVN8Cu9rDGy91WrlnSfmqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tf60PEg0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tf60PEg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94841F000E9;
	Tue, 21 Jul 2026 18:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660300;
	bh=H/CXuZDkMP94Ins13ikW9+g2VBL+g1aKatxR3BsVAW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tf60PEg0w8ZIvfhaUcQLUkQjnp08YdGRu87z7O/7WxgsX/vdvGFs1pC3l4qjS3tdP
	 qCvD4GoEkMSbRP00AYpD8VTjhAoLwPUHbJwg49JYDcBriwRWscmx963yVekGHEZv4P
	 3ivPKQaNUo5GAUztgtQz5BegSHyZjnlsZfgEi1fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Blanchard <anton@samba.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0929/2077] perf tools: Guard test_bit from out-of-bounds sample CPU
Date: Tue, 21 Jul 2026 17:10:02 +0200
Message-ID: <20260721152614.728853573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5e57b78548f421..bdc7adc83b4711 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -298,7 +298,8 @@ static int process_sample_event(const struct perf_tool *tool,
 		goto out_put;
 	}
 
-	if (ann->cpu_list && !test_bit(sample->cpu, ann->cpu_bitmap))
+	if (ann->cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			     !test_bit(sample->cpu, ann->cpu_bitmap)))
 		goto out_put;
 
 	if (!al.filtered &&
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 1b3df868849a99..29db0afc53ca07 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -416,7 +416,8 @@ static int diff__process_sample_event(const struct perf_tool *tool,
 		goto out;
 	}
 
-	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap)) {
+	if (cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			!test_bit(sample->cpu, cpu_bitmap))) {
 		ret = 0;
 		goto out;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0b0966d94128ee..3a5cf1b64adb0d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -300,7 +300,8 @@ static int process_sample_event(const struct perf_tool *tool,
 	if (symbol_conf.hide_unresolved && al.sym == NULL)
 		goto out_put;
 
-	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
+	if (rep->cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			     !test_bit(sample->cpu, rep->cpu_bitmap)))
 		goto out_put;
 
 	if (sort__mode == SORT_MODE__BRANCH) {
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 241c2f808f7b02..3dcd1f3525fde9 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2175,7 +2175,8 @@ static void timehist_print_sample(struct perf_sched *sched,
 	char nstr[30];
 	u64 wait_time;
 
-	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+	if (cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			!test_bit(sample->cpu, cpu_bitmap)))
 		return;
 
 	timestamp__scnprintf_usec(t, tstr, sizeof(tstr));
@@ -2857,7 +2858,8 @@ static int timehist_sched_change_event(const struct perf_tool *tool,
 	}
 
 	if (!sched->idle_hist || thread__tid(thread) == 0) {
-		if (!cpu_list || test_bit(sample->cpu, cpu_bitmap))
+		if (!cpu_list || (sample->cpu < MAX_NR_CPUS &&
+				 test_bit(sample->cpu, cpu_bitmap)))
 			timehist_update_runtime_stats(tr, t, tprev);
 
 		if (sched->idle_hist) {
-- 
2.53.0



