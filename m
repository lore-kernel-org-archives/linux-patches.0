Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F9126E160;
	Tue,  8 Apr 2025 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116503; cv=none; b=CeL00Spb7Yls9Yj2GfClTjDtZvue8+C+Heg36juIks7wVhSOCS2f6arQhfdX8X5zPDmw5MRjQVFJHwO7tCRZI5J5lLSYU387b0zYfUQF5TLq841YEePQ1PjF158cVrbqyIcugtKCUoCMUU6vhCGrpHaCMfJ0uZUcdH2hYP2scU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116503; c=relaxed/simple;
	bh=mzj0aw/zVsacUXPRzv9NW4Xt1RSAm15DzNNb+ZI4qBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5Wl+v2AokKypJQ4yQFxxa+8OrN8Sgac8UeJFFdpw+UV3+eyBxBYgRWvZknj7d+jTUTdw45iiAg4qCEI+AuCtVMYFlX1XFog2DwaZ9JmHhXvFRKtXQj81Xea1uENglQhAretckiYRG1NTmWqQVM2xPxRc0kMGKnzBk0wS9jfr5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSLrKO5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSLrKO5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282E6C4CEEE;
	Tue,  8 Apr 2025 12:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116502;
	bh=mzj0aw/zVsacUXPRzv9NW4Xt1RSAm15DzNNb+ZI4qBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSLrKO5um2to8Uv77023k25LV4+LCLW1J4aZvG0XuNVfj8/jBQAEjtdst0EH5HL4p
	 xg2DG0tROR01rFQk55Gbx4H7l8YjVAT+apWXWfbl4AbA1O+aDcG5CDs+5Yv1Rh0RiA
	 4Am0Fc/UrhdC8M5P63IVl/tdDYTnL/y3u1oteis0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Atish Patra <atishp@rivosinc.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/423] perf stat: Fix find_stat for mixed legacy/non-legacy events
Date: Tue,  8 Apr 2025 12:48:08 +0200
Message-ID: <20250408104849.511368091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 8ce0d2da14d3fb62844dd0e95982c194326b1a5f ]

Legacy events typically don't have a PMU when added leading to
mismatched legacy/non-legacy cases in find_stat. Use evsel__find_pmu
to make sure the evsel PMU is looked up. Update the evsel__find_pmu
code to look for the PMU using the extended config type or, for legacy
hardware/hw_cache events on non-hybrid systems, just use the core PMU.

Before:
```
$ perf stat -e cycles,cpu/instructions/ -a sleep 1
 Performance counter stats for 'system wide':

       215,309,764      cycles
        44,326,491      cpu/instructions/

       1.002555314 seconds time elapsed
```
After:
```
$ perf stat -e cycles,cpu/instructions/ -a sleep 1

 Performance counter stats for 'system wide':

       990,676,332      cycles
     1,235,762,487      cpu/instructions/                #    1.25  insn per cycle

       1.002667198 seconds time elapsed
```

Fixes: 3612ca8e2935 ("perf stat: Fix the hard-coded metrics calculation on the hybrid")
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: James Clark <james.clark@linaro.org>
Tested-by: Leo Yan <leo.yan@arm.com>
Tested-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20250109222109.567031-3-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmus.c        | 20 +++++++++++++++++---
 tools/perf/util/stat-shadow.c |  3 ++-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/pmus.c b/tools/perf/util/pmus.c
index d7d67e09d759b..362596ed27294 100644
--- a/tools/perf/util/pmus.c
+++ b/tools/perf/util/pmus.c
@@ -701,11 +701,25 @@ char *perf_pmus__default_pmu_name(void)
 struct perf_pmu *evsel__find_pmu(const struct evsel *evsel)
 {
 	struct perf_pmu *pmu = evsel->pmu;
+	bool legacy_core_type;
 
-	if (!pmu) {
-		pmu = perf_pmus__find_by_type(evsel->core.attr.type);
-		((struct evsel *)evsel)->pmu = pmu;
+	if (pmu)
+		return pmu;
+
+	pmu = perf_pmus__find_by_type(evsel->core.attr.type);
+	legacy_core_type =
+		evsel->core.attr.type == PERF_TYPE_HARDWARE ||
+		evsel->core.attr.type == PERF_TYPE_HW_CACHE;
+	if (!pmu && legacy_core_type) {
+		if (perf_pmus__supports_extended_type()) {
+			u32 type = evsel->core.attr.config >> PERF_PMU_TYPE_SHIFT;
+
+			pmu = perf_pmus__find_by_type(type);
+		} else {
+			pmu = perf_pmus__find_core_pmu();
+		}
 	}
+	((struct evsel *)evsel)->pmu = pmu;
 	return pmu;
 }
 
diff --git a/tools/perf/util/stat-shadow.c b/tools/perf/util/stat-shadow.c
index 99376c12dd8ec..7c49997fab3a3 100644
--- a/tools/perf/util/stat-shadow.c
+++ b/tools/perf/util/stat-shadow.c
@@ -154,6 +154,7 @@ static double find_stat(const struct evsel *evsel, int aggr_idx, enum stat_type
 {
 	const struct evsel *cur;
 	int evsel_ctx = evsel_context(evsel);
+	struct perf_pmu *evsel_pmu = evsel__find_pmu(evsel);
 
 	evlist__for_each_entry(evsel->evlist, cur) {
 		struct perf_stat_aggr *aggr;
@@ -180,7 +181,7 @@ static double find_stat(const struct evsel *evsel, int aggr_idx, enum stat_type
 		 * Except the SW CLOCK events,
 		 * ignore if not the PMU we're looking for.
 		 */
-		if ((type != STAT_NSECS) && (evsel->pmu != cur->pmu))
+		if ((type != STAT_NSECS) && (evsel_pmu != evsel__find_pmu(cur)))
 			continue;
 
 		aggr = &cur->stats->aggr[aggr_idx];
-- 
2.39.5



