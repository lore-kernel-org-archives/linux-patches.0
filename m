Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DAD19D081;
	Thu,  6 Jun 2024 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683462; cv=none; b=G5MhKvQ+MWqJZ1nzGxIcyLCKudy3w0XfvJnCyZLVEfWlQjeeSy27pz2VzgMlFbjPoLID2YO6V6Uu/6iOOuqDPEDrwzdsUwt2/fr1IEs1Sn4Gd+Yhs11Lbom7QlrAG8HXov1ReVIcL+AfHjc9FatLdy/Ua5Wo1PB9UkW6YiF4n24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683462; c=relaxed/simple;
	bh=cU1C5PH83tVtCD7vTP4siPmB3FK4NdDH/anoP+ZfBe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4+utjNDymCQfwxOPJOwdo9BkVaSYOzZuhsNe0Z4fNOaBSkofaMbWZrVpIDDy5mJvgMR00aSx1WELnD6dDfqNfceMlBft9ZZHcoiUv0gxeG1wSKx1Ym6+8fFlJyUMcP5w73qL5RQVB5plk95n3kNm+hAOfYSX6BPNeu63xIDmAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZE9YKkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZE9YKkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40789C2BD10;
	Thu,  6 Jun 2024 14:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683462;
	bh=cU1C5PH83tVtCD7vTP4siPmB3FK4NdDH/anoP+ZfBe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZE9YKkdFIJ3yqGtHLtJzCiwstcINxQQErsw+fWfsXkUA0afJ3wk9R515TaQoCpWd
	 an5tH9Olu8mAYv1A2Kx/zNbqIJpICK7ZVD5fkDuOanattRZN6jKAa6LTgxkOikWW9t
	 ga9FRZ60hKQguXZsaoylGQeMqiXlvHH4Wojvv4s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kaige Ye <ye@kaige.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 349/473] perf stat: Dont display metric header for non-leader uncore events
Date: Thu,  6 Jun 2024 16:04:38 +0200
Message-ID: <20240606131711.448835419@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 193a9e30207f54777ff42d0d8be8389edc522277 ]

On an Intel tigerlake laptop a metric like:

    {
        "BriefDescription": "Test",
        "MetricExpr": "imc_free_running@data_read@ + imc_free_running@data_write@",
        "MetricGroup": "Test",
        "MetricName": "Test",
        "ScaleUnit": "6.103515625e-5MiB"
    },

Will have 4 events:

  uncore_imc_free_running_0/data_read/
  uncore_imc_free_running_0/data_write/
  uncore_imc_free_running_1/data_read/
  uncore_imc_free_running_1/data_write/

If aggregration is disabled with metric-only 2 column headers are
needed:

  $ perf stat -M test --metric-only -A -a sleep 1

   Performance counter stats for 'system wide':

                    MiB  Test            MiB  Test
  CPU0                 1821.0               1820.5

But when not, the counts aggregated in the metric leader and only 1
column should be shown:

  $ perf stat -M test --metric-only -a sleep 1
   Performance counter stats for 'system wide':

              MiB  Test
                5909.4

         1.001258915 seconds time elapsed

Achieve this by skipping events that aren't metric leaders when
printing column headers and aggregation isn't disabled.

The bug is long standing, the fixes tag is set to a refactor as that
is as far back as is reasonable to backport.

Fixes: 088519f318be3a41 ("perf stat: Move the display functions to stat-display.c")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kaige Ye <ye@kaige.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20240510051309.2452468-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index ef9a3df459657..9053db0dc00a1 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -1162,6 +1162,9 @@ static void print_metric_headers(struct perf_stat_config *config,
 
 	/* Print metrics headers only */
 	evlist__for_each_entry(evlist, counter) {
+		if (config->aggr_mode != AGGR_NONE && counter->metric_leader != counter)
+			continue;
+
 		os.evsel = counter;
 
 		if (!first && config->json_output)
-- 
2.43.0



