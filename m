Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460DB1C5399;
	Thu,  6 Jun 2024 14:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683674; cv=none; b=Tu0fSFrJeGsoDO90Z9ZL9mC/f/Sy56Q0qFEgR2gZMOt7/E37zrFWF8GiL6ZQvlS1r4ql7TbRs+/5gFlI3k+tda5kr1KKLjMa5ESedCXLf5SHX9bIQSYvgLRQZYaTBdhJd8HVnH2OKfMYQZiGHUHrQ8PrcJGp39Pj3jPK7Ql6lnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683674; c=relaxed/simple;
	bh=FphWuKzQpHoGkIxX/yYWv2ikPHGlVAwzSu6vkUDWBvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jocODWjjoR9kp4w4lC1P5XZJYRFwvvHPSNDVpJBlAVp5ad3wtVxxe+pkKvju6V9JwjoboD7PHCvQsWGiBbBjq6PixslbKNyjN9fIobjLo//+YDWEfEXkRA7Ga6mloyXHRjDLUa+J9SLQ0t8Ky63yxRph8L+sR20+E/+ApqpCZ2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kx3vnuVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kx3vnuVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EFEC2BD10;
	Thu,  6 Jun 2024 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683674;
	bh=FphWuKzQpHoGkIxX/yYWv2ikPHGlVAwzSu6vkUDWBvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kx3vnuVuOiJLrh7eaP9pmMvRC4/FT81tiFU9Y2THF1J26IC8mMlReRX2WRWO5Jjpc
	 p2Jrz7/JIxPhmlsoDQVqeilUBYPqjCBY2Fx877NfvUhFmlODqf1Tyypb8xjgX7Opmm
	 LUWLAmiqIuWvASMslwmlE6YpySwLz7aQSwTy83As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Ian Rogers <irogers@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Will Deacon <will@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Haixin Yu <yuhaixin.yhx@linux.alibaba.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 526/744] perf pmu: Move pmu__find_core_pmu() to pmus.c
Date: Thu,  6 Jun 2024 16:03:18 +0200
Message-ID: <20240606131749.309213383@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: James Clark <james.clark@arm.com>

[ Upstream commit 3d0f5f456a5786573ba6a3358178c8db580e4b85 ]

pmu__find_core_pmu() more logically belongs in pmus.c because it
iterates over all PMUs, so move it to pmus.c

At the same time rename it to perf_pmus__find_core_pmu() to match the
naming convention in this file.

list_prepare_entry() can't be used in perf_pmus__scan_core() anymore now
that it's called from the same compilation unit. This is with -O2
(specifically -O1 -ftree-vrp -finline-functions
-finline-small-functions) which allow the bounds of the array
access to be determined at compile time. list_prepare_entry() subtracts
the offset of the 'list' member in struct perf_pmu from &core_pmus,
which isn't a struct perf_pmu. The compiler sees that pmu results in
&core_pmus - 8 and refuses to compile. At runtime this works because
list_for_each_entry_continue() always adds the offset back again before
dereferencing ->next, but it's technically undefined behavior. With
-fsanitize=undefined an additional warning is generated.

Using list_first_entry_or_null() to get the first entry here avoids
doing &core_pmus - 8 but has the same result and fixes both the compile
warning and the undefined behavior warning. There are other uses of
list_prepare_entry() in pmus.c, but the compiler doesn't seem to be
able to see that they can also be called with &core_pmus, so I won't
change any at this time.

Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Jing Zhang <renyu.zj@linux.alibaba.com>
Cc: Haixin Yu <yuhaixin.yhx@linux.alibaba.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20230913153355.138331-2-james.clark@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: d9c5f5f94c2d ("perf pmu: Count sys and cpuid JSON events separately")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/arm64/util/pmu.c |  6 +++---
 tools/perf/tests/expr.c          |  2 +-
 tools/perf/util/expr.c           |  2 +-
 tools/perf/util/pmu.c            | 17 -----------------
 tools/perf/util/pmu.h            |  2 +-
 tools/perf/util/pmus.c           | 20 +++++++++++++++++++-
 6 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/tools/perf/arch/arm64/util/pmu.c b/tools/perf/arch/arm64/util/pmu.c
index 615084eb88d8c..3d9330feebd28 100644
--- a/tools/perf/arch/arm64/util/pmu.c
+++ b/tools/perf/arch/arm64/util/pmu.c
@@ -10,7 +10,7 @@
 
 const struct pmu_metrics_table *pmu_metrics_table__find(void)
 {
-	struct perf_pmu *pmu = pmu__find_core_pmu();
+	struct perf_pmu *pmu = perf_pmus__find_core_pmu();
 
 	if (pmu)
 		return perf_pmu__find_metrics_table(pmu);
@@ -20,7 +20,7 @@ const struct pmu_metrics_table *pmu_metrics_table__find(void)
 
 const struct pmu_events_table *pmu_events_table__find(void)
 {
-	struct perf_pmu *pmu = pmu__find_core_pmu();
+	struct perf_pmu *pmu = perf_pmus__find_core_pmu();
 
 	if (pmu)
 		return perf_pmu__find_events_table(pmu);
@@ -32,7 +32,7 @@ double perf_pmu__cpu_slots_per_cycle(void)
 {
 	char path[PATH_MAX];
 	unsigned long long slots = 0;
-	struct perf_pmu *pmu = pmu__find_core_pmu();
+	struct perf_pmu *pmu = perf_pmus__find_core_pmu();
 
 	if (pmu) {
 		perf_pmu__pathname_scnprintf(path, sizeof(path),
diff --git a/tools/perf/tests/expr.c b/tools/perf/tests/expr.c
index b177d09078038..cea4a506197db 100644
--- a/tools/perf/tests/expr.c
+++ b/tools/perf/tests/expr.c
@@ -76,7 +76,7 @@ static int test__expr(struct test_suite *t __maybe_unused, int subtest __maybe_u
 	struct expr_parse_ctx *ctx;
 	bool is_intel = false;
 	char strcmp_cpuid_buf[256];
-	struct perf_pmu *pmu = pmu__find_core_pmu();
+	struct perf_pmu *pmu = perf_pmus__find_core_pmu();
 	char *cpuid = perf_pmu__getcpuid(pmu);
 	char *escaped_cpuid1, *escaped_cpuid2;
 
diff --git a/tools/perf/util/expr.c b/tools/perf/util/expr.c
index 80cf2478f98fc..b8875aac8f870 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -527,7 +527,7 @@ double expr__strcmp_cpuid_str(const struct expr_parse_ctx *ctx __maybe_unused,
 		       bool compute_ids __maybe_unused, const char *test_id)
 {
 	double ret;
-	struct perf_pmu *pmu = pmu__find_core_pmu();
+	struct perf_pmu *pmu = perf_pmus__find_core_pmu();
 	char *cpuid = perf_pmu__getcpuid(pmu);
 
 	if (!cpuid)
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 86bfdf5db2135..72b7a1d3225f6 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -2058,20 +2058,3 @@ void perf_pmu__delete(struct perf_pmu *pmu)
 	zfree(&pmu->id);
 	free(pmu);
 }
-
-struct perf_pmu *pmu__find_core_pmu(void)
-{
-	struct perf_pmu *pmu = NULL;
-
-	while ((pmu = perf_pmus__scan_core(pmu))) {
-		/*
-		 * The cpumap should cover all CPUs. Otherwise, some CPUs may
-		 * not support some events or have different event IDs.
-		 */
-		if (RC_CHK_ACCESS(pmu->cpus)->nr != cpu__max_cpu().cpu)
-			return NULL;
-
-		return pmu;
-	}
-	return NULL;
-}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 6a4e170c61d6b..45079f26abf60 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -264,6 +264,6 @@ int perf_pmu__pathname_fd(int dirfd, const char *pmu_name, const char *filename,
 struct perf_pmu *perf_pmu__lookup(struct list_head *pmus, int dirfd, const char *lookup_name);
 struct perf_pmu *perf_pmu__create_placeholder_core_pmu(struct list_head *core_pmus);
 void perf_pmu__delete(struct perf_pmu *pmu);
-struct perf_pmu *pmu__find_core_pmu(void);
+struct perf_pmu *perf_pmus__find_core_pmu(void);
 
 #endif /* __PMU_H */
diff --git a/tools/perf/util/pmus.c b/tools/perf/util/pmus.c
index 6631367c756fd..cec869cbe163a 100644
--- a/tools/perf/util/pmus.c
+++ b/tools/perf/util/pmus.c
@@ -10,6 +10,7 @@
 #include <pthread.h>
 #include <string.h>
 #include <unistd.h>
+#include "cpumap.h"
 #include "debug.h"
 #include "evsel.h"
 #include "pmus.h"
@@ -268,7 +269,7 @@ struct perf_pmu *perf_pmus__scan_core(struct perf_pmu *pmu)
 {
 	if (!pmu) {
 		pmu_read_sysfs(/*core_only=*/true);
-		pmu = list_prepare_entry(pmu, &core_pmus, list);
+		return list_first_entry_or_null(&core_pmus, typeof(*pmu), list);
 	}
 	list_for_each_entry_continue(pmu, &core_pmus, list)
 		return pmu;
@@ -592,3 +593,20 @@ struct perf_pmu *evsel__find_pmu(const struct evsel *evsel)
 	}
 	return pmu;
 }
+
+struct perf_pmu *perf_pmus__find_core_pmu(void)
+{
+	struct perf_pmu *pmu = NULL;
+
+	while ((pmu = perf_pmus__scan_core(pmu))) {
+		/*
+		 * The cpumap should cover all CPUs. Otherwise, some CPUs may
+		 * not support some events or have different event IDs.
+		 */
+		if (RC_CHK_ACCESS(pmu->cpus)->nr != cpu__max_cpu().cpu)
+			return NULL;
+
+		return pmu;
+	}
+	return NULL;
+}
-- 
2.43.0



