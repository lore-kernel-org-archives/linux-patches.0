Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C5B196D90;
	Thu,  6 Jun 2024 14:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683674; cv=none; b=VydkK/nznzgdvKuJp+QtszqDQzpf1EiKaQGF6le9Vz8PsrqAw2Zm4iLZ60m3e6YweCzGGdnDRLUmTi1lNHHDfEWdwtbqZwx8Y5LmpPLtumuPjRvNUwxVcGVZqkmdmCniYsoEjIy9rDDSD4MB1B2s8s8+9TANimdN/4BIoM7vxX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683674; c=relaxed/simple;
	bh=Eqtd01dAaM6WmM8X1LjdmKtuuUZwTwL4sCuka/4Gb+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8HX39Gr2HPWLDnoHF/OYW8okmfWNjcrStsnm46OWtwcAoHzma503kDkjeM8wb+sRU06QX8CZjcdeJWULd4ntGXL9F0ZePZD/hj+8TlgfvkOkTcN3VQ2BABAA4kRu8dcXGbBKyTgbdi0AZ10tUrVEyHPqoU5dURiyF2ODlU1WKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FY9bXw1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FY9bXw1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2A1C2BD10;
	Thu,  6 Jun 2024 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683674;
	bh=Eqtd01dAaM6WmM8X1LjdmKtuuUZwTwL4sCuka/4Gb+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FY9bXw1EbQbWy5ioYZAQ3F0pVzKXfx2QELz9a3QAy5gD6o0H4pWge+Jc8uqY+68v4
	 dBEEGUzzgtu97R3qFROG3ckk8B1CYXuYoGAGQV1bfNtt7nT1AIm1vEP3nNLDRJReFl
	 qlGlntDj2rpOR8LP+Wj7Osz4FaVyinkASgAI7VOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Will Deacon <will@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Zhuo Song <zhuo.song@linux.alibaba.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 527/744] perf pmu: "Compat" supports regular expression matching identifiers
Date: Thu,  6 Jun 2024 16:03:19 +0200
Message-ID: <20240606131749.337542621@linuxfoundation.org>
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

From: Jing Zhang <renyu.zj@linux.alibaba.com>

[ Upstream commit 2879ff36f5ed80deec5f9d82a7a4107f2347630e ]

The jevent "Compat" is used for uncore PMU alias or metric definitions.

The same PMU driver has different PMU identifiers due to different
hardware versions and types, but they may have some common PMU event.
Since a Compat value can only match one identifier, when adding the
same event alias to PMUs with different identifiers, each identifier
needs to be defined once, which is not streamlined enough.

So let "Compat" support using regular expression to match identifiers
for uncore PMU alias. For example, if the "Compat" value is set to
"43401|43c01", it would be able to match PMU identifiers such as "43401"
or "43c01", which correspond to CMN600_r0p0 or CMN700_r0p0.

Signed-off-by: Jing Zhang <renyu.zj@linux.alibaba.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Zhuo Song <zhuo.song@linux.alibaba.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Link: https://lore.kernel.org/r/1695794391-34817-2-git-send-email-renyu.zj@linux.alibaba.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: d9c5f5f94c2d ("perf pmu: Count sys and cpuid JSON events separately")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 27 +++++++++++++++++++++++++--
 tools/perf/util/pmu.h |  1 +
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 72b7a1d3225f6..64b605a6060e2 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -28,6 +28,7 @@
 #include "strbuf.h"
 #include "fncache.h"
 #include "util/evsel_config.h"
+#include <regex.h>
 
 struct perf_pmu perf_pmu__fake = {
 	.name = "fake",
@@ -874,6 +875,28 @@ static bool pmu_uncore_alias_match(const char *pmu_name, const char *name)
 	return res;
 }
 
+bool pmu_uncore_identifier_match(const char *compat, const char *id)
+{
+	regex_t re;
+	regmatch_t pmatch[1];
+	int match;
+
+	if (regcomp(&re, compat, REG_EXTENDED) != 0) {
+		/* Warn unable to generate match particular string. */
+		pr_info("Invalid regular expression %s\n", compat);
+		return false;
+	}
+
+	match = !regexec(&re, id, 1, pmatch, 0);
+	if (match) {
+		/* Ensure a full match. */
+		match = pmatch[0].rm_so == 0 && (size_t)pmatch[0].rm_eo == strlen(id);
+	}
+	regfree(&re);
+
+	return match;
+}
+
 static int pmu_add_cpu_aliases_map_callback(const struct pmu_event *pe,
 					const struct pmu_events_table *table __maybe_unused,
 					void *vdata)
@@ -914,8 +937,8 @@ static int pmu_add_sys_aliases_iter_fn(const struct pmu_event *pe,
 	if (!pe->compat || !pe->pmu)
 		return 0;
 
-	if (!strcmp(pmu->id, pe->compat) &&
-	    pmu_uncore_alias_match(pe->pmu, pmu->name)) {
+	if (pmu_uncore_alias_match(pe->pmu, pmu->name) &&
+			pmu_uncore_identifier_match(pe->compat, pmu->id)) {
 		perf_pmu__new_alias(pmu,
 				pe->name,
 				pe->desc,
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 45079f26abf60..c4b4fabe16edc 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -240,6 +240,7 @@ void pmu_add_cpu_aliases_table(struct perf_pmu *pmu,
 char *perf_pmu__getcpuid(struct perf_pmu *pmu);
 const struct pmu_events_table *pmu_events_table__find(void);
 const struct pmu_metrics_table *pmu_metrics_table__find(void);
+bool pmu_uncore_identifier_match(const char *compat, const char *id);
 
 int perf_pmu__convert_scale(const char *scale, char **end, double *sval);
 
-- 
2.43.0



