Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F79940926D;
	Tue, 21 Jul 2026 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660154; cv=none; b=fXAlgxrYCsDQz4AsaViE+14iYRNXU1F3lLYbSEkWn3XDLefO/rhssD6w7zh/Ur4QqsGqQAlT7RVqQ0E+do9VICrfWx23W4P4ABoH74C57JFDSO8ycF3DSM1I8KFl7KbmhGQWXvfraYsO0w2Mx6v4p2SBh1lxQh1Gnxgt68wZg7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660154; c=relaxed/simple;
	bh=y1MkxPXf+OD1U/aPBGUZzkPhLgxo1z5sdQ5AUJEQ7zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNrDkmwZuxaJNQCjKFSUKucRkyZWxCWGyq2r/9jzpev0t5vYKEnI3EMp9utB8th8ZWfj9Aem1HZJvTsnSwxf7jim7WEOC92VsTyFoUfIy6jFNS3Kh4JPpCXQ/va/QVbMMGkdWuqWr2rNxZAVkwZykpt1NvjPThXAw6vdcukScN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNaYFhn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNaYFhn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4201F00A3A;
	Tue, 21 Jul 2026 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660153;
	bh=C7vW5VMGRsdJGkVeDzx85Rg8tAEbQBQwCCWS47xzItI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNaYFhn2/KlkwuhSloqQeEt0PQQIACxHhEMiog6Oa9PxYZCQufR2bNo6bWnG6ZnK4
	 iBAjZJdtaljzknGUDXK/HxLCbT9SlBh8R45mAuUpPbsFQ3BGmnFWIWy9iz3XayOVXL
	 EeGqx9ypRtKyJNzvqikVVzmQv117v1vyYy9CZ/GI=
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
Subject: [PATCH 7.1 0870/2077] perf pmu: Skip test on Arm64 when #slots is zero
Date: Tue, 21 Jul 2026 17:09:03 +0200
Message-ID: <20260721152613.312633188@linuxfoundation.org>
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
index a9971686216880..b1609a7e1d8c94 100644
--- a/tools/perf/tests/pmu-events.c
+++ b/tools/perf/tests/pmu-events.c
@@ -15,6 +15,7 @@
 #include "util/expr.h"
 #include "util/hashmap.h"
 #include "util/parse-events.h"
+#include "util/tool_pmu.h"
 #include "metricgroup.h"
 #include "stat.h"
 
@@ -817,6 +818,26 @@ struct metric {
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
@@ -852,8 +873,7 @@ static int test__parsing_callback(const struct pmu_metric *pm,
 
 	err = metricgroup__parse_groups_test(evlist, table, pm->metric_name);
 	if (err) {
-		if (!strcmp(pm->metric_name, "M1") || !strcmp(pm->metric_name, "M2") ||
-		    !strcmp(pm->metric_name, "M3")) {
+		if (is_expected_broken_metric(pm)) {
 			(*failures)--;
 			pr_debug("Expected broken metric %s skipping\n", pm->metric_name);
 			err = 0;
-- 
2.53.0



