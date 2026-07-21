Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4499335DA40;
	Tue, 21 Jul 2026 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662392; cv=none; b=PAO0WvsIgFWOkgoNQUTs5YaOweKYcCRY4EbJUgrEzmIXItL6G8d8Ai+6jBErB1U/dNoMrg/43r8vlrCY538hyMpw11cci+EOyayPyvzoc9oo7w+UQ6bp5jCrON6lcF4ynZ//R8ZBj3sj15oSwff0n3N+sLaxC2bDK3jj7EMsGdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662392; c=relaxed/simple;
	bh=UPRMPcnOfEXvrCRwWS3XZ4UsjWA6u7uTuewO7T0LX2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVEnayrr8tWIbr22Rh7lSohpxutYrCzOJj548zVfx6iMJO/eYfr9qmiJhOSLPLNoljSTGCCm9guu3AjFRUcLRIFHKQ3/iJ8R6PXZNtdHwWp05ps0bKjWSQTdboKOr+w1aHbStVvO3LLRYBr8hIvOmZwcXpgDY86pNsalm2FvoUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJEheJfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJEheJfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26111F000E9;
	Tue, 21 Jul 2026 19:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662391;
	bh=fq3KS2ZgpxfNyRKKKoYvmDvSrN7i4wyGaNYVVHz1HcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aJEheJfp394PZnfX+AxIUt75/blYc3w+B9q+6sx+N4WZLi1hpvV3a6shVaV4GB16a
	 8BYek1PCh7PUt6vJnbjR01ectyIaLQGq0wtoC1D1sKHI7PW2IaHYsZuxiIpu2qaKok
	 5z33pavH0yYdg9L7LknUMLf98VBw3QKKkXxuf/1U=
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
Subject: [PATCH 6.12 0428/1276] perf pmu: Skip test on Arm64 when #slots is zero
Date: Tue, 21 Jul 2026 17:14:31 +0200
Message-ID: <20260721152455.681649834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index db004d26fcb005..8c73ab189c5fce 100644
--- a/tools/perf/tests/pmu-events.c
+++ b/tools/perf/tests/pmu-events.c
@@ -15,6 +15,7 @@
 #include "util/expr.h"
 #include "util/hashmap.h"
 #include "util/parse-events.h"
+#include "util/tool_pmu.h"
 #include "metricgroup.h"
 #include "stat.h"
 
@@ -864,6 +865,26 @@ struct metric {
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
@@ -902,8 +923,7 @@ static int test__parsing_callback(const struct pmu_metric *pm,
 
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



