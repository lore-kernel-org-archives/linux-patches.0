Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4167844C6F;
	Thu, 13 Jun 2024 12:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280133; cv=none; b=H7xW1e3dPjUze6Y/jPQo9It/9WeVdtS1VYbf4m1jrs408n12ikdXzIptFthr3xBKUQviGBhu0P99WQWUBmahu1KCBZNA0ZMZ7zFLHcyivLTJjbz5YR75QXymL+HWjaQwlCompn/wteIzCSRQ6M1Cu8z693ebSX0L6VPTgMQyRyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280133; c=relaxed/simple;
	bh=wlpgOKYKi8UGEI3c61OQMr+d4t9PFj7cJnoKfCOlwIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er5cNbvBZ4GAIK0DWlcJMCUx+y/d+ny/OW3wqIZtS7SkWmgjgiwVdcD3WMqpIJpVg2On3DGeOCsLh0a/ed8QbZauMF0S926lhh/JS0DpterPfEdKt8yM0EKi6lkQnf8fmxjJ/ax2XTT4zCeJrNRw7RMihUpWbYHdZGwarkRneII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCeJc4sN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCeJc4sN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E541C2BBFC;
	Thu, 13 Jun 2024 12:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280133;
	bh=wlpgOKYKi8UGEI3c61OQMr+d4t9PFj7cJnoKfCOlwIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCeJc4sNy0VDv0ZNRRV0leMUccDeVuNfRKG7dXd7EGMD/uo+YdnHBPD/l437pb4Zt
	 GOUhfDOG5s9iEO1jxpfqYwn5qvmLvPaJFRS73bfVsH2G8csxGUl3uoLBS2gRh9FJLM
	 S+JC1N9Y8Z04BpOOcqYjKamxkNaGsJr21EeBe6fo=
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
Subject: [PATCH 5.4 123/202] perf stat: Dont display metric header for non-leader uncore events
Date: Thu, 13 Jun 2024 13:33:41 +0200
Message-ID: <20240613113232.509114665@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 70612ec583f35..7ea2bddd75d51 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -931,6 +931,9 @@ static void print_metric_headers(struct perf_stat_config *config,
 
 	/* Print metrics headers only */
 	evlist__for_each_entry(evlist, counter) {
+		if (config->aggr_mode != AGGR_NONE && counter->metric_leader != counter)
+			continue;
+
 		os.evsel = counter;
 		out.ctx = &os;
 		out.print_metric = print_metric_header;
-- 
2.43.0



