Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC0F3D1CC6;
	Wed, 20 May 2026 18:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301576; cv=none; b=DSqix7QSplZeLBs3uqobWnwMqQTuhhEgamRrbxv+ofPRyqMk56sKnlBdnx+PiDLSLk6Bx/83Vl/GjPaxMPWZ0Igev8goSREomBVkCY9FrFwMQOJzqxIl8LhyQzbXvEvv5yMebZF6dh6FnvbMWQsVtJAntTXW8CuNpWHUAfK+wNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301576; c=relaxed/simple;
	bh=vKp9TwQ1s9U8z9MB0ud/lMgW3gom/0bAXVnLHJ9lpBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX2uTg99J2p5qgSdkgCl80DdhUWmV0Q8BDgFJ87RHt7Dk5z4FCvO43SCjXH/FFR4mWkcn3qFpjeZM8h+cwxxC1omZ4BVa3QSXYcLap0hgYpD9ktRX/ksrpA67BK1xEWgvQL+BP1QelESunaeWtNREEDdjLEf4tF03fIrcFfcqDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM+V8r/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM+V8r/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015711F000E9;
	Wed, 20 May 2026 18:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301575;
	bh=cOy/BmYfWeJ52td+VqI8t+isT3Vian73HAW9w5HVRs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gM+V8r/4sfnJu3EvqvR7TgvkDLrLkVN7w64/gSMjVanQkg8uue5WnHKQcKdZDaY2f
	 hxJJn5d9tFQCLU94tB/jQfGLaqsSc47JQMXeWByE3TWaD3coQrd4zSJ+Cb+wtTh+og
	 RM9IRR6da0TF5Pjw+9QbzcdW/S9wGAViQUNUxtcE=
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
Subject: [PATCH 6.12 605/666] perf tool_pmu: Fix aggregation on duration_time
Date: Wed, 20 May 2026 18:23:36 +0200
Message-ID: <20260520162124.382497099@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index f41fed39d70d8..3d1d6b3352ec7 100644
--- a/tools/perf/util/tool_pmu.c
+++ b/tools/perf/util/tool_pmu.c
@@ -392,8 +392,14 @@ int evsel__read_tool(struct evsel *evsel, int cpu_map_idx, int thread)
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
2.53.0



