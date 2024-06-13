Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C696F14534A;
	Thu, 13 Jun 2024 12:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281248; cv=none; b=EpNW5qpfryMDBGCR/TwjBF+ySGv4ob2aC3VsJapxyUGPLt0yB//t351i7P4Sht0pulzOnU3stU1KJdSAxQVd1NZ2miuS/3IVygDVlInxom+rN2xqHP/puMS2zKXqL3pcFrQ2YNUT6K9FoFLinF3AMeyc0T2LbjUTtCgxJtT/DT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281248; c=relaxed/simple;
	bh=Ofq/dNmXcwIKaun8BIZ3ujAcd+NVVhE+0E9MSo2SjRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRYan+QAesh1Q9CqQXf2hGTfALh5sDaZHCT6u39AmeMXDxi9FoGVaJCAmbGnqln6ChCNVDVKUoSOVt4U/Q4qpjGRXPSrPJdVn1gY6k3BXem82hj5+sjS6uR0K45b1lVvandOMzAI9BIOoR+j+03Slea+rTBTapcLbX+/Mcp/Ko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/RI9KTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/RI9KTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229A2C2BBFC;
	Thu, 13 Jun 2024 12:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281248;
	bh=Ofq/dNmXcwIKaun8BIZ3ujAcd+NVVhE+0E9MSo2SjRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/RI9KTmPixod/zzZBUEr19aFWqq8XM2i0tkuj9JCq3cPSslow2B1hj8vD/Zp30vK
	 pGeWs2yAy74lK5Bcf8Ud2bfD9Z56TKwGBM9LBUwb7gLr+pNMEv5DR6Z7A3geixkLKL
	 wLoCgeDLKoGk47e90QXwjkCL02QDiMgHzdMkFQhA=
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
Subject: [PATCH 5.10 190/317] perf stat: Dont display metric header for non-leader uncore events
Date: Thu, 13 Jun 2024 13:33:28 +0200
Message-ID: <20240613113254.907414857@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 971fd77bd3e61..8c2da9a3f953c 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -939,6 +939,9 @@ static void print_metric_headers(struct perf_stat_config *config,
 
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



