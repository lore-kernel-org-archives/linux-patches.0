Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA50C207E14;
	Tue,  8 Apr 2025 11:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111469; cv=none; b=OQdp0sMt0Hixhqd6lLSsNLcSIWEtREQsaMEu19RBzDI2nJy/mAqGoGEvJMO+Uj7ne5m8K1pW7Tb0oL4BShvWskugRWuFWOpt+lirUlvW/3611N+BbXCjujBKSuZvs7H7L0zsyjFbED+ZfiPdeKrA2IxVe93s0NSuWTq9iJYNTJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111469; c=relaxed/simple;
	bh=jeSoTQ6eVE5xbJpMX6+/dihMUuT2wqtTRHwvadblY4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kr5LoUwdWWHz/hIjGpRoK2lkVm/75uhLFu9Qlrg9/a7QY57F4fnTxa2AGso7mkFb8UQUUSYgD2/ntT0RaFMlW5emjNa/1kc9VsUQswsrJ4J0Hw3ZAnVvwvzo5IeEGMjeO5oHU5xgEyOA7snMMOMGFpcwOVb8fdPCxiEmnPh6tPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyIyG2tn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyIyG2tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1EBC4CEE5;
	Tue,  8 Apr 2025 11:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111469;
	bh=jeSoTQ6eVE5xbJpMX6+/dihMUuT2wqtTRHwvadblY4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyIyG2tnX0IMzz7TRTlNXl36e1KizDBJ53BIXTPMMtEfokm26DLULBHRkXX3oJMDo
	 P1+iTyBtefrk8Uu+LvDWq15DJyChrARRGvVYD3qGndH0n44ZkFKSaCbcJAFtc2WuXc
	 jU8V1Y0O2eG8R0eFNtqypD5jLBilyxqA2fM/U19w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 442/731] perf stat: Dont merge counters purely on name
Date: Tue,  8 Apr 2025 12:45:39 +0200
Message-ID: <20250408104924.554233368@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 2d9961c690d299893735783a2077e866f2d46a56 ]

Counter merging was added in commit 942c5593393d ("perf stat: Add
perf_stat_merge_counters()"), however, it merges events with the same
name on different PMUs regardless of whether the different PMUs are
actually of the same type (ie they differ only in the suffix on the
PMU). For hwmon events there may be a temp1 event on every PMU, but
the PMU names are all unique and don't differ just by a suffix. The
merging is over eager and will merge all the hwmon counters together
meaning an aggregated and very large temp1 value is shown. The same
would be true for say cache events and memory controller events where
the PMUs differ but the event names are the same.

Fix the problem by correctly saying two PMUs alias when they differ
only by suffix.

Note, there is an overlap with evsel's merged_stat with aggregation
and the evsel's metric_leader where aggregation happens for metrics.

Fixes: 942c5593393d ("perf stat: Add perf_stat_merge_counters()")
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20250201074320.746259-5-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 7c2ccdcc3fdba..1f7abd8754c75 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -535,7 +535,10 @@ static int evsel__merge_aggr_counters(struct evsel *evsel, struct evsel *alias)
 
 	return 0;
 }
-/* events should have the same name, scale, unit, cgroup but on different PMUs */
+/*
+ * Events should have the same name, scale, unit, cgroup but on different core
+ * PMUs or on different but matching uncore PMUs.
+ */
 static bool evsel__is_alias(struct evsel *evsel_a, struct evsel *evsel_b)
 {
 	if (strcmp(evsel__name(evsel_a), evsel__name(evsel_b)))
@@ -553,7 +556,13 @@ static bool evsel__is_alias(struct evsel *evsel_a, struct evsel *evsel_b)
 	if (evsel__is_clock(evsel_a) != evsel__is_clock(evsel_b))
 		return false;
 
-	return evsel_a->pmu != evsel_b->pmu;
+	if (evsel_a->pmu == evsel_b->pmu || evsel_a->pmu == NULL || evsel_b->pmu == NULL)
+		return false;
+
+	if (evsel_a->pmu->is_core)
+		return evsel_b->pmu->is_core;
+
+	return perf_pmu__name_no_suffix_match(evsel_a->pmu, evsel_b->pmu->name);
 }
 
 static void evsel__merge_aliases(struct evsel *evsel)
-- 
2.39.5



