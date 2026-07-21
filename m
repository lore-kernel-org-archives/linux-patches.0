Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DDC2EBB8D;
	Tue, 21 Jul 2026 20:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666262; cv=none; b=syY9+2kYnQwEQPVEsqbxf3h7HLOuyWKYh8lKGkcpjHa9O5c+KiSIjodDfmY2Rz8LCTmvShJaInCjFKGVmEjyYm3JT7Amb55QUPeA8TBYDzd3tATmICMLN5re0D/uXYeNRruUEhUdhIPTvKUtTQN2JZ2kBPBxXe2H4zNGxM1MQxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666262; c=relaxed/simple;
	bh=aJMmuFXWIIKcRcTucb1Sz1R2JRW2jSS41KTL1y9Vijg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9CgvDdZHT2GMtcT6lKpMYzoJ252fGQheRyiMxxJgzzXRaUDLOUVYp+9FyZzy8nYJ+ojDRh/y52GD+l2tuIRI2bm/L/fbFBONmlhCBo6f3r8fLAVKILAr/JFYdDGF4RiGqyhjylHaQP5KkkLr//Tl4ceVJwyBrDa1mi9UWwCwA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rV9FAF1+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rV9FAF1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F251F00A3A;
	Tue, 21 Jul 2026 20:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666261;
	bh=xUMHBq7wpfvBwF+JGQuGAMbGhTb8Piu6uyv85vNGxjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rV9FAF1+BgHyunWpk8manHke+jh4ZB/6rXWcrKmtE+1EJMb5e/slJJIrI5VrH8YC/
	 rGt4Tmic37pFr5ouQHBTFzmWuPha2HShZ8puohvlHdvwsGsbRQ+mJPkRuJ4S3RzWSI
	 0KY3nFCeVrnX7JU0kCWY52C+rOTQ+vmfLDAv7C+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0616/1266] perf pmu: Skip test on Arm64 when #slots is zero
Date: Tue, 21 Jul 2026 17:17:33 +0200
Message-ID: <20260721152455.645500421@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 2e2ba7d1ea554ee6e9e751a53eebf3e9270b0670 ]

Some Arm64 PMUs expose 'caps/slots' as 0 when the slot count is not
implemented, tool_pmu__read_event() currently returns false for this,
so metrics that reference #slots are reported as syntax error.

Since the commit 3a61fd866ef9 ("perf expr: Return -EINVAL for syntax
error in expr__find_ids()"), these syntax errors are populated as
failures and make the PMU metric test fail:

    9.3: Parsing of PMU event table metrics:
    --- start ---
    ...

    Found metric 'backend_bound'
    metric expr 100 * (stall_slot_backend / (#slots * cpu_cycles)) for backend_bound
    parsing metric: 100 * (stall_slot_backend / (#slots * cpu_cycles))
    Failure to read '#slots'
    literal: #slots = nan
    syntax error
    Fail to parse metric or group `backend_bound'

    ...
    ---- end(-1) ----
    9.3: Parsing of PMU event table metrics    : FAILED!

This commit introduces a new function is_expected_broken_metric() to
identify broken metrics, and treats metrics containing "#slots" as
expected broken when #slots == 0 on Arm64 platforms.

Fixes: 3a61fd866ef9aaa1 ("perf expr: Return -EINVAL for syntax error in expr__find_ids()")
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/pmu-events.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
index f5321fbdee79d1..2ed9d2ad792e2b 100644
--- a/tools/perf/tests/pmu-events.c
+++ b/tools/perf/tests/pmu-events.c
@@ -15,6 +15,7 @@
 #include "util/expr.h"
 #include "util/hashmap.h"
 #include "util/parse-events.h"
+#include "util/tool_pmu.h"
 #include "metricgroup.h"
 #include "stat.h"
 
@@ -804,6 +805,26 @@ struct metric {
 	struct metric_ref metric_ref;
 };
 
+static bool is_expected_broken_metric(const struct pmu_metric *pm)
+{
+	if (!strcmp(pm->metric_name, "M1") || !strcmp(pm->metric_name, "M2") ||
+	    !strcmp(pm->metric_name, "M3"))
+		return true;
+
+#if defined(__aarch64__)
+	/*
+	 * Arm64 platforms may return "#slots == 0", which is treated as a
+	 * syntax error by the parser. Don't test these metrics when running
+	 * on such platforms.
+	 */
+	if (strstr(pm->metric_expr, "#slots") &&
+	    !tool_pmu__cpu_slots_per_cycle())
+		return true;
+#endif
+
+	return false;
+}
+
 static int test__parsing_callback(const struct pmu_metric *pm,
 				  const struct pmu_metrics_table *table,
 				  void *data)
@@ -842,8 +863,7 @@ static int test__parsing_callback(const struct pmu_metric *pm,
 
 	err = metricgroup__parse_groups_test(evlist, table, pm->metric_name, &metric_events);
 	if (err) {
-		if (!strcmp(pm->metric_name, "M1") || !strcmp(pm->metric_name, "M2") ||
-		    !strcmp(pm->metric_name, "M3")) {
+		if (is_expected_broken_metric(pm)) {
 			(*failures)--;
 			pr_debug("Expected broken metric %s skipping\n", pm->metric_name);
 			err = 0;
-- 
2.53.0



