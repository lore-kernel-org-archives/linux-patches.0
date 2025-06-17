Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462142CCC5;
	Tue, 17 Jun 2025 16:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178249; cv=none; b=O+iPmnZ4I2uNhXn7JzoekWS98O2o10iX7+lVJ11V1RBgFXQhh7R4g19+qOWfl4GNRiuXLA5Nf8ach/1vavTSkOApuVeeGmwbnTbw2FS2z9xgZS5yD3AecdcgpEvm/nMBUwHe4zqSzkQzY2SheBmhQxH4BIoocSVJng84Uu77QZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178249; c=relaxed/simple;
	bh=jNm+qWDLcQxG5n4S4FxFGhFm0MH7Y0l0U61wIy0M3uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awUxBmN2SU7QIua5+hwAsfn5o3i/lFIuwFrijtmjhW3ffkM8ewrtUa05h4tTDXbDWbnk+En0CPfZIZuhnv9g9TwdWh+JsBgsCd8v0BkyM14Sozo5Xyiqk+clp4OYha7kFVfkQ5bSSu2LrqestYojSqWEES2iPVkc4qft07uiN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIdJZUzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIdJZUzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F60AC4CEE3;
	Tue, 17 Jun 2025 16:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178249;
	bh=jNm+qWDLcQxG5n4S4FxFGhFm0MH7Y0l0U61wIy0M3uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIdJZUzrNFyvGMYOgpjSaxHEMBV+aZuLWCSSaN1bfXWbt7u9uy9Ocl6lEzEjt8PAr
	 +rKtM0Ciu+MtJlRYSfz7m21Ddx/thC7ncSfPBY82jBkVivJJywXNVLK706G75fpJdP
	 qxa9qDKzwOsfNmuyJ+/x9JHIO0MjGuin3bnHxLnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephane Eranian <eranian@google.com>,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 433/780] perf tool_pmu: Fix aggregation on duration_time
Date: Tue, 17 Jun 2025 17:22:21 +0200
Message-ID: <20250617152509.101604690@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 68cb1567439fa325ba980f3b5b67f95d3953eafd ]

evsel__count_has_error() fails counters when the enabled or running time
are 0. The duration_time event reads 0 when the cpu_map_idx != 0 to
avoid aggregating time over CPUs. Change the enable and running time
to always have a ratio of 100% so that evsel__count_has_error won't
fail.

Before:
```
$ sudo /tmp/perf/perf stat --per-core -a -M UNCORE_FREQ sleep 1

 Performance counter stats for 'system wide':

S0-D0-C0              1      2,615,819,485      UNC_CLOCK.SOCKET                 #     2.61 UNCORE_FREQ
S0-D0-C0              2      <not counted>      duration_time

       1.002111784 seconds time elapsed
```

After:
```
$ perf stat --per-core -a -M UNCORE_FREQ sleep 1

 Performance counter stats for 'system wide':

S0-D0-C0              1        758,160,296      UNC_CLOCK.SOCKET                 #     0.76 UNCORE_FREQ
S0-D0-C0              2      1,003,438,246      duration_time

       1.002486017 seconds time elapsed
```

Note: the metric reads the value a different way and isn't impacted.

Fixes: 240505b2d0adcdc8 ("perf tool_pmu: Factor tool events into their own PMU")
Reported-by: Stephane Eranian <eranian@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lore.kernel.org/r/20250423050358.94310-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/tool_pmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/tool_pmu.c b/tools/perf/util/tool_pmu.c
index 97b327d1ce4a0..727a10e3f9900 100644
--- a/tools/perf/util/tool_pmu.c
+++ b/tools/perf/util/tool_pmu.c
@@ -486,8 +486,14 @@ int evsel__tool_pmu_read(struct evsel *evsel, int cpu_map_idx, int thread)
 		delta_start *= 1000000000 / ticks_per_sec;
 	}
 	count->val    = delta_start;
-	count->ena    = count->run = delta_start;
 	count->lost   = 0;
+	/*
+	 * The values of enabled and running must make a ratio of 100%. The
+	 * exact values don't matter as long as they are non-zero to avoid
+	 * issues with evsel__count_has_error.
+	 */
+	count->ena++;
+	count->run++;
 	return 0;
 }
 
-- 
2.39.5



