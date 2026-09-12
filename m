Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95423542F8;
	Sat, 12 Sep 2026 09:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204631; cv=none; b=j56XmI7vEFG1+Zmu54pMAU+gHPRUUjhpT47vRiUtz+xsrfxaITOgv8xfhiaT0mufdTMS9plqfUuVXX8t+J0HoNi9aKWtH4vB8wTyPwjWhy+VyXyoLj+edcXRa0SxxDlmHrvnTqE4MrSrjQ7+vrSbyQ0Fl5wEwMZxOgkvZXfXaog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204631; c=relaxed/simple;
	bh=zyCClP2RHyavxisE7mxl5G9bjVH1+WQ3TN5JZ6rmkDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5EX1iSSXxkg+dpuzsBI+ERIZE9c3dONHP2vPNBjlo8X40x3JzpWQ72p8QEKJsqUVnDuJDqD/x72W1vPOSJKvjD34kX/hjmgEMrRn6392QhSs6Qoavm/UV92/tuDgXXaEbDX4naADHKKYzkOIsryRDfu68i8mQOULzQKdApQ2oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LafqFLKM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LafqFLKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C47A1F000FF;
	Sat, 12 Sep 2026 09:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204629;
	bh=PTjfO65TcHFRWH1p/2DHtUORmo5ARE+IChkcGsm9dtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LafqFLKMoJ8klx2+puKd+CTeVNH9zqREQDn9MCSxM6KrJZwkCIQbMFqFFr51oVfHj
	 Ri/4opDiH+cH2m6FisHKNDP7GlLHCwHbWkIsEUnNLVdkPxHqzaLo16fXz5TKYh8Pv9
	 ZD72W1ye8aKfwhnVFHAuoYZR5BdzM9ktGXC5q4Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Sachidanand <sauravsc@amazon.com>,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1599/1815] perf vendor events arm64: fix swapped MetricGroup for Tegra410 L1 prefetcher metrics
Date: Sat, 12 Sep 2026 08:55:49 +0200
Message-ID: <20260912065726.527277408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Sachidanand <sauravsc@amazon.com>

[ Upstream commit 2d85e13c5526eee5f4d5670472a949f1489707ed ]

The L1D prefetcher metrics (l1d_cache_rw_miss_ratio, l1d_demand_accesses,
etc.) were incorrectly assigned to MetricGroup "L1I_Prefetcher_Effectiveness"
and vice versa. This causes 'perf stat --metric-group L1D_Prefetcher_Effectiveness'
to display L1I metrics, which is misleading.

Swap the MetricGroup assignments so L1D metrics are in the L1D group and
L1I metrics are in the L1I group.

Fixes: 86ff690f45cc ("perf vendor events arm64: Add Tegra410 Olympus PMU events")
Signed-off-by: Saurav Sachidanand <sauravsc@amazon.com>
Reviewed-by: Besar Wicaksono <bwicaksono@nvidia.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arch/arm64/nvidia/t410/metrics.json       | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/perf/pmu-events/arch/arm64/nvidia/t410/metrics.json b/tools/perf/pmu-events/arch/arm64/nvidia/t410/metrics.json
index b825ede03f544..59474ccb7417f 100644
--- a/tools/perf/pmu-events/arch/arm64/nvidia/t410/metrics.json
+++ b/tools/perf/pmu-events/arch/arm64/nvidia/t410/metrics.json
@@ -346,42 +346,42 @@
         "MetricExpr": "l1d_demand_misses / l1d_demand_accesses",
         "BriefDescription": "This metric measures the ratio of L1 D-cache Read accesses missed to the total number of L1 D-cache accesses. This gives an indication of the effectiveness of the L1 D-cache for demand Load or Store traffic.",
         "ScaleUnit": "1per cache access",
-        "MetricGroup": "L1I_Prefetcher_Effectiveness"
+        "MetricGroup": "L1D_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1d_demand_accesses",
         "MetricExpr": "L1D_CACHE_RW",
         "BriefDescription": "This metric measures the count of L1 D-cache accesses incurred on Load or Store by the instruction stream of the program.",
         "ScaleUnit": "1count",
-        "MetricGroup": "L1I_Prefetcher_Effectiveness"
+        "MetricGroup": "L1D_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1d_demand_misses",
         "MetricExpr": "L1D_CACHE_REFILL_RW",
         "BriefDescription": "This metric measures the count of L1 D-cache misses incurred on a Load or Store by the instruction stream of the program.",
         "ScaleUnit": "1count",
-        "MetricGroup": "L1I_Prefetcher_Effectiveness"
+        "MetricGroup": "L1D_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1d_prf_accuracy",
         "MetricExpr": "100 * (l1d_useful_prf / l1d_refilled_prf)",
         "BriefDescription": "This metric measures the fraction of prefetched memory addresses that are used by the instruction stream.",
         "ScaleUnit": "1percent of prefetch",
-        "MetricGroup": "L1I_Prefetcher_Effectiveness"
+        "MetricGroup": "L1D_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1d_prf_coverage",
         "MetricExpr": "100 * (l1d_useful_prf / (l1d_demand_misses + l1d_refilled_prf))",
         "BriefDescription": "This metric measures the baseline demand cache misses which the prefetcher brings into the cache.",
         "ScaleUnit": "1percent of cache access",
-        "MetricGroup": "L1I_Prefetcher_Effectiveness"
+        "MetricGroup": "L1D_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1d_refilled_prf",
         "MetricExpr": "L1D_CACHE_REFILL_HWPRF + L1D_CACHE_REFILL_PRFM + L1D_LFB_HIT_RW_FHWPRF + L1D_LFB_HIT_RW_FPRFM",
         "BriefDescription": "This metric measures the count of cache lines refilled by L1 data prefetcher (hardware prefetches or software preload) into L1 D-cache.",
         "ScaleUnit": "1count",
-        "MetricGroup": "L1I_Prefetcher_Effectiveness"
+        "MetricGroup": "L1D_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1d_tlb_miss_ratio",
@@ -402,7 +402,7 @@
         "MetricExpr": "L1D_CACHE_HIT_RW_FPRF + L1D_LFB_HIT_RW_FHWPRF + L1D_LFB_HIT_RW_FPRFM",
         "BriefDescription": "This metric measures the count of cache lines refilled by L1 data prefetcher (hardware prefetches or software preload) into L1 D-cache which are further used by Load or Store from the instruction stream of the program.",
         "ScaleUnit": "1count",
-        "MetricGroup": "L1I_Prefetcher_Effectiveness"
+        "MetricGroup": "L1D_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1i_cache_miss_ratio",
@@ -423,42 +423,42 @@
         "MetricExpr": "l1i_demand_misses / l1i_demand_accesses",
         "BriefDescription": "This metric measures the ratio of L1 I-cache Read accesses missed to the total number of L1 I-cache accesses. This gives an indication of the effectiveness of the L1 I-cache for demand instruction fetch traffic. Note that cache accesses in this cache are demand instruction fetch.",
         "ScaleUnit": "1per cache access",
-        "MetricGroup": "L1D_Prefetcher_Effectiveness"
+        "MetricGroup": "L1I_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1i_demand_accesses",
         "MetricExpr": "L1I_CACHE_RD",
         "BriefDescription": "This metric measures the count of L1 I-cache accesses caused by an instruction fetch by the instruction stream of the program.",
         "ScaleUnit": "1count",
-        "MetricGroup": "L1D_Prefetcher_Effectiveness"
+        "MetricGroup": "L1I_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1i_demand_misses",
         "MetricExpr": "L1I_CACHE_REFILL_RD",
         "BriefDescription": "This metric measures the count of L1 I-cache misses caused by an instruction fetch by the instruction stream of the program.",
         "ScaleUnit": "1count",
-        "MetricGroup": "L1D_Prefetcher_Effectiveness"
+        "MetricGroup": "L1I_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1i_prf_accuracy",
         "MetricExpr": "100 * (l1i_useful_prf / l1i_refilled_prf)",
         "BriefDescription": "This metric measures the fraction of prefetched memory addresses that are used by the instruction stream.",
         "ScaleUnit": "1percent of prefetch",
-        "MetricGroup": "L1D_Prefetcher_Effectiveness"
+        "MetricGroup": "L1I_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1i_prf_coverage",
         "MetricExpr": "100 * (l1i_useful_prf / (l1i_demand_misses + l1i_refilled_prf))",
         "BriefDescription": "This metric measures the baseline demand cache misses which the prefetcher brings into the cache.",
         "ScaleUnit": "1percent of cache access",
-        "MetricGroup": "L1D_Prefetcher_Effectiveness"
+        "MetricGroup": "L1I_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1i_refilled_prf",
         "MetricExpr": "L1I_CACHE_REFILL_HWPRF + L1I_CACHE_REFILL_PRFM",
         "BriefDescription": "This metric measures the count of cache lines refilled by L1 instruction prefetcher (hardware prefetches or software preload) into L1 I-cache.",
         "ScaleUnit": "1count",
-        "MetricGroup": "L1D_Prefetcher_Effectiveness"
+        "MetricGroup": "L1I_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l1i_tlb_miss_ratio",
@@ -479,7 +479,7 @@
         "MetricExpr": "L1I_CACHE_HIT_RD_FPRF",
         "BriefDescription": "This metric measures the count of cache lines refilled by L1 instruction prefetcher (hardware prefetches or software preload) into L1 I-cache which are further used by instruction stream of the program.",
         "ScaleUnit": "1count",
-        "MetricGroup": "L1D_Prefetcher_Effectiveness"
+        "MetricGroup": "L1I_Prefetcher_Effectiveness"
     },
     {
         "MetricName": "l2_cache_miss_ratio",
-- 
2.53.0



