Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC94EBA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F379DC433D2;
	Tue,  7 Mar 2023 17:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210245;
	bh=SibYQp57NS7jPG0XJfh0C067YW6BJeRZPyxGP2VFcxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOAskOO3pfYyR7f0zS/FVjZRKwusQPj2JGa8+Ru1uhAAGD1la4Bn1LzXMU82rE7VH
	 8n7OBapIcUBzMh6jb9TjEe0HnVXCk4LfOHiNM8jkziiMWUUmXjGctZyj4BwzhF6yHi
	 yJbkec5aGsNDayFqMUuKWy058VItnGieGbhc5Hqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Disha Goel <disgoel@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nageswara R Sastry <rnsastry@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0479/1001] perf tests stat_all_metrics: Change true workload to sleep workload for system wide check
Date: Tue,  7 Mar 2023 17:54:11 +0100
Message-Id: <20230307170042.194193521@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit f9fa0778ee7349a9aa3d2ea10e9f2ab843a0b44e ]

Testcase stat_all_metrics.sh fails in powerpc:

98: perf all metrics test : FAILED!

Logs with verbose:

  [command]# ./perf test 98 -vv
   98: perf all metrics test                                           :
   --- start ---
  test child forked, pid 13262
  Testing BRU_STALL_CPI
  Testing COMPLETION_STALL_CPI
   ----
  Testing TOTAL_LOCAL_NODE_PUMPS_P23
  Metric 'TOTAL_LOCAL_NODE_PUMPS_P23' not printed in:
  Error:
  Invalid event (hv_24x7/PM_PB_LNS_PUMP23,chip=3/) in per-thread mode, enable system wide with '-a'.
  Testing TOTAL_LOCAL_NODE_PUMPS_RETRIES_P01
  Metric 'TOTAL_LOCAL_NODE_PUMPS_RETRIES_P01' not printed in:
  Error:
  Invalid event (hv_24x7/PM_PB_RTY_LNS_PUMP01,chip=3/) in per-thread mode, enable system wide with '-a'.
   ----

Based on above logs, we could see some of the hv-24x7 metric events
fails, and logs suggest to run the metric event with -a option.  This
change happened after the commit a4b8cfcabb1d90ec ("perf stat: Delay
metric parsing"), which delayed the metric parsing phase and now before
metric parsing phase perf tool identifies, whether target is system-wide
or not. With this change, perf_event_open will fails with workload
monitoring for uncore events as expected.

The perf all metric test case fails as some of the hv-24x7 metric events
may need bigger workload with system wide monitoring to get the data.
Fix this issue by changing current system wide check from true workload
to sleep 0.01 workload.

Result with the patch changes in powerpc:

  98: perf all metrics test : Ok

Fixes: a4b8cfcabb1d90ec ("perf stat: Delay metric parsing")
Suggested-by: Ian Rogers <irogers@google.com>
Reviewed-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Tested-by: Disha Goel <disgoel@linux.ibm.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nageswara R Sastry <rnsastry@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20230215093827.124921-1-kjain@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_all_metrics.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/stat_all_metrics.sh b/tools/perf/tests/shell/stat_all_metrics.sh
index 6e79349e42bef..22e9cb294b40e 100755
--- a/tools/perf/tests/shell/stat_all_metrics.sh
+++ b/tools/perf/tests/shell/stat_all_metrics.sh
@@ -11,7 +11,7 @@ for m in $(perf list --raw-dump metrics); do
     continue
   fi
   # Failed so try system wide.
-  result=$(perf stat -M "$m" -a true 2>&1)
+  result=$(perf stat -M "$m" -a sleep 0.01 2>&1)
   if [[ "$result" =~ "${m:0:50}" ]]
   then
     continue
-- 
2.39.2



