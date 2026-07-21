Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E91D2EBB8D;
	Tue, 21 Jul 2026 20:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666320; cv=none; b=FoqI1sw98Wy6doizdBdtROUHjSsPYPmKDbnbCyXButhZ2waDsFCrMR3YGsop8gKuHP8p3wPgDNtw3o7b/ve1vlBP2xNepXs9JWneTuyqMGZkycUXmhala3LuQMqoMefRCcFS85h0KZqO3jEolYFJ4/McC0Ucz07gsFE3K37VAwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666320; c=relaxed/simple;
	bh=qHCraPs4dWyDnTxOFCSBKvJItHzfHBRA5lMCFAy48F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t39Zzk3evRJdDytbAruXWNUzZ07hP+/HifRZREgoZo0l+4I5o4vx5dGocvGZzVmMXbeCIiurOEa4CYEsYE4aQSvxdbP2GPdKsNyM7Nhk+mvZ3B70I+s3Z6kgBq3kGfENDEXZIvns7NjBWyhjGab956t9xHk+HdkLuHx1TLySLa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkcVwEAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkcVwEAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2301F000E9;
	Tue, 21 Jul 2026 20:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666319;
	bh=/y+nABWWH0tQSoxkEtGHfHJBu4M9YanC1oTNCz6QYfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkcVwEAJYahBgyDONZ09813N/wnSjGwEfx7L6mVqKrCZzyHofNiAorKOsyffUfqE5
	 cj+WJstWnDsSFdN24pmj79KQI4rWYwnEoqpewE8SeT3Mcq/UPrIHpaI5EJ+a3mGyX9
	 4W2HcfsTVjmWfMoJtbnr8v5b6DBahiOZ+n5BVA9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Blanchard <anton@samba.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0636/1266] perf tools: Guard test_bit from out-of-bounds sample CPU
Date: Tue, 21 Jul 2026 17:17:53 +0200
Message-ID: <20260721152456.088548532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f1e5787b4edac..e572043be2dbb8 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -287,7 +287,8 @@ static int process_sample_event(struct perf_tool *tool,
 		goto out_put;
 	}
 
-	if (ann->cpu_list && !test_bit(sample->cpu, ann->cpu_bitmap))
+	if (ann->cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			     !test_bit(sample->cpu, ann->cpu_bitmap)))
 		goto out_put;
 
 	if (!al.filtered &&
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 57d300d8e5700c..41f557fcc5567f 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -417,7 +417,8 @@ static int diff__process_sample_event(struct perf_tool *tool,
 		goto out;
 	}
 
-	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap)) {
+	if (cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			!test_bit(sample->cpu, cpu_bitmap))) {
 		ret = 0;
 		goto out;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 54b06db597862f..eed8a2621d01f7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -298,7 +298,8 @@ static int process_sample_event(struct perf_tool *tool,
 	if (symbol_conf.hide_unresolved && al.sym == NULL)
 		goto out_put;
 
-	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
+	if (rep->cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			     !test_bit(sample->cpu, rep->cpu_bitmap)))
 		goto out_put;
 
 	if (sort__mode == SORT_MODE__BRANCH) {
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 1a22314094e6ad..942fde8a1d52e3 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2085,7 +2085,8 @@ static void timehist_print_sample(struct perf_sched *sched,
 	char nstr[30];
 	u64 wait_time;
 
-	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+	if (cpu_list && (sample->cpu >= MAX_NR_CPUS ||
+			!test_bit(sample->cpu, cpu_bitmap)))
 		return;
 
 	timestamp__scnprintf_usec(t, tstr, sizeof(tstr));
@@ -2671,7 +2672,8 @@ static int timehist_sched_change_event(struct perf_tool *tool,
 	}
 
 	if (!sched->idle_hist || thread__tid(thread) == 0) {
-		if (!cpu_list || test_bit(sample->cpu, cpu_bitmap))
+		if (!cpu_list || (sample->cpu < MAX_NR_CPUS &&
+				 test_bit(sample->cpu, cpu_bitmap)))
 			timehist_update_runtime_stats(tr, t, tprev);
 
 		if (sched->idle_hist) {
-- 
2.53.0



