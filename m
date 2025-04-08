Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07324268FCB;
	Tue,  8 Apr 2025 11:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111583; cv=none; b=BA2AeS9UsfFBmwQlS+WQoHRnqFHbrlSSNdQHCEK/3GBydCSQoZX4TrO457li46Qy5twmP2Ped1BNKeMobvB4iudnGDm7WlLrBVED5FHKRnfmtgycyeB5svkPaDk5b6xutx35ebSCinH+rqL08aTcXWGkbN8tgeYAnDo7vovgZ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111583; c=relaxed/simple;
	bh=b1knjCQNePHusw4FN0KUj6XyvqJRTlR4W25IVCiL/MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c53xuLAzGUutI/Wcb4dPqEhA0ekgynJJ3TWpcMj+r/Vz3oNEuUjdyrW+iw+9IE1oMqA5fqT7ml4/+x29LFddEnqdcGKt57SYoep+AykTB6THCou/cOjNH4mK+JDMPaJjgDHperonBt+yxhVVBavgznycFK4/jL6MwwHAQPx+bSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsYAo+Gp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsYAo+Gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6346DC4CEE5;
	Tue,  8 Apr 2025 11:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111582;
	bh=b1knjCQNePHusw4FN0KUj6XyvqJRTlR4W25IVCiL/MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsYAo+GpCRO1/o6MkQHLGtuSuN+zAruk3NXqOcRxGrGzN0iaO9RkeOZlhV18CIuxZ
	 VNgi/Px9DSkJmnYEHyZ69/8YdZ0ti93tkUkFJGKnRX3AWo6xOQH8NVMrXmSRD4RbaE
	 XyT0zjmF/f5++7V6tH4lcZlrrUSGsNOvnzF/xc1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 466/731] perf pmu: Dynamically allocate tool PMU
Date: Tue,  8 Apr 2025 12:46:03 +0200
Message-ID: <20250408104925.118339732@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 72c6f57a4193f2eadceb52261315438719c4c1ad ]

perf_pmus__destroy() treats all PMUs as allocated and free's them so we
can't have any static PMUs that are added to the PMU lists. Fix it by
allocating the tool PMU in the same way as the others. Current users of
the tool PMU already use find_pmu() and not perf_pmus__tool_pmu(), so
rename the function to add 'new' to avoid it being misused in the
future.

perf_pmus__fake_pmu() can remain as static as it's not added to the
PMU lists.

Fixes the following error:

  $ perf bench internals pmu-scan

  # Running 'internals/pmu-scan' benchmark:
  Computing performance of sysfs PMU event scan for 100 times
  munmap_chunk(): invalid pointer
  Aborted (core dumped)

Fixes: 240505b2d0ad ("perf tool_pmu: Factor tool events into their own PMU")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250226104111.564443-2-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmus.c     |  2 +-
 tools/perf/util/tool_pmu.c | 23 +++++++++++------------
 tools/perf/util/tool_pmu.h |  2 +-
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/pmus.c b/tools/perf/util/pmus.c
index 8a0a919415d49..6498021acef01 100644
--- a/tools/perf/util/pmus.c
+++ b/tools/perf/util/pmus.c
@@ -268,7 +268,7 @@ static void pmu_read_sysfs(unsigned int to_read_types)
 
 	if ((to_read_types & PERF_TOOL_PMU_TYPE_TOOL_MASK) != 0 &&
 	    (read_pmu_types & PERF_TOOL_PMU_TYPE_TOOL_MASK) == 0) {
-		tool_pmu = perf_pmus__tool_pmu();
+		tool_pmu = tool_pmu__new();
 		list_add_tail(&tool_pmu->list, &other_pmus);
 	}
 	if ((to_read_types & PERF_TOOL_PMU_TYPE_HWMON_MASK) != 0 &&
diff --git a/tools/perf/util/tool_pmu.c b/tools/perf/util/tool_pmu.c
index 3a68debe71437..9156745ea180d 100644
--- a/tools/perf/util/tool_pmu.c
+++ b/tools/perf/util/tool_pmu.c
@@ -490,17 +490,16 @@ int evsel__tool_pmu_read(struct evsel *evsel, int cpu_map_idx, int thread)
 	return 0;
 }
 
-struct perf_pmu *perf_pmus__tool_pmu(void)
+struct perf_pmu *tool_pmu__new(void)
 {
-	static struct perf_pmu tool = {
-		.name = "tool",
-		.type = PERF_PMU_TYPE_TOOL,
-		.aliases = LIST_HEAD_INIT(tool.aliases),
-		.caps = LIST_HEAD_INIT(tool.caps),
-		.format = LIST_HEAD_INIT(tool.format),
-	};
-	if (!tool.events_table)
-		tool.events_table = find_core_events_table("common", "common");
-
-	return &tool;
+	struct perf_pmu *tool = zalloc(sizeof(struct perf_pmu));
+
+	tool->name = strdup("tool");
+	tool->type = PERF_PMU_TYPE_TOOL;
+	INIT_LIST_HEAD(&tool->aliases);
+	INIT_LIST_HEAD(&tool->caps);
+	INIT_LIST_HEAD(&tool->format);
+	tool->events_table = find_core_events_table("common", "common");
+
+	return tool;
 }
diff --git a/tools/perf/util/tool_pmu.h b/tools/perf/util/tool_pmu.h
index a60184859080f..c6ad1dd90a56d 100644
--- a/tools/perf/util/tool_pmu.h
+++ b/tools/perf/util/tool_pmu.h
@@ -51,6 +51,6 @@ int evsel__tool_pmu_open(struct evsel *evsel,
 			 int start_cpu_map_idx, int end_cpu_map_idx);
 int evsel__tool_pmu_read(struct evsel *evsel, int cpu_map_idx, int thread);
 
-struct perf_pmu *perf_pmus__tool_pmu(void);
+struct perf_pmu *tool_pmu__new(void);
 
 #endif /* __TOOL_PMU_H */
-- 
2.39.5



