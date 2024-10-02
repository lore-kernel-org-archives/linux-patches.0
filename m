Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87EA1D1E9A;
	Wed,  2 Oct 2024 14:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879828; cv=none; b=mnAwtpWL0yxiuMXPE0wZ1lHMvPND6WdsFW5Gzya7V1Bh2VdO/qydUsXHP2FCCxlIJIqgLbnRN7oPbKqNbVDaCek8/5cGQafpPDF6fDXI7zpKEDV+I3b4pVL4XjyXJa+Jiiip8cDlAdHcM4qbj4LLpmqJp9i2RQz9EtfAGmHraHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879828; c=relaxed/simple;
	bh=Fmc5EazjXyPnT0Sm87SCiI13nA0gCxqiQp7pB5CYoWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igDrv904gGRQC+tVSvo9jC9toc8mphbXZ481rXw5Fldz9yfQE78uleVtkB2p+oRPyaPl9t7XNWlgWch75gwiYTDIDFZJq4Kr65amJsbQEhi7ab3HvPsIHduGQcLvOU5vpZRh3W7yNclGuFVKmLrZaAAPwSuk525UpneFSTh85l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1TqqB3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1TqqB3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243D4C4CEC5;
	Wed,  2 Oct 2024 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879828;
	bh=Fmc5EazjXyPnT0Sm87SCiI13nA0gCxqiQp7pB5CYoWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1TqqB3zTg8zVu0rYQRasS5C3Vru8ftNTFq0tWPHMO6KYqpLQ1gRkZRpI/DMm4HVt
	 Cp4WvP9BRCuMj/a49ztTg5gPLHGqwLr5i9x13FtSs8GHUazY0CBmPnlxA6H78UsMrd
	 rlgdWUhHFkyF/2uTlfvKVrzq1WsZ5pD7mCcz4f90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jin Yao <yao.jin@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/538] perf report: Fix --total-cycles --stdio output error
Date: Wed,  2 Oct 2024 14:58:11 +0200
Message-ID: <20241002125802.205212056@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 3ef44458071a19e5b5832cdfe6f75273aa521b6e ]

The --total-cycles may output wrong information with the --stdio.

For example:

  # perf record -e "{cycles,instructions}",cache-misses -b sleep 1
  # perf report --total-cycles --stdio

The total cycles output of {cycles,instructions} and cache-misses are
almost the same.

  # Samples: 938  of events 'anon group { cycles, instructions }'
  # Event count (approx.): 938
  #
  # Sampled Cycles%  Sampled Cycles  Avg Cycles%  Avg Cycles  [Program Block Range]
  # ...............  ..............  ...........  ..........  ..................................................>
  #
            11.19%            2.6K        0.10%           21  [perf_iterate_ctx+48 -> >
             5.79%            1.4K        0.45%           97  [__intel_pmu_enable_all.constprop.0+80 -> __intel_>
             5.11%            1.2K        0.33%           71  [native_write_msr+0 ->>

  # Samples: 293  of event 'cache-misses'
  # Event count (approx.): 293
  #
  # Sampled Cycles%  Sampled Cycles  Avg Cycles%  Avg Cycles  [Program Block Range]
  # ...............  ..............  ...........  ..........  ..................................................>
  #
            11.19%            2.6K        0.13%           21  [perf_iterate_ctx+48 -> >
             5.79%            1.4K        0.59%           97  [__intel_pmu_enable_all.constprop.0+80 -> __intel_>
             5.11%            1.2K        0.43%           71  [native_write_msr+0 ->>

With the symbol_conf.event_group, the 'perf report' should only report the
block information of the leader event in a group.

However, the current implementation retrieves the next event's block
information, rather than the next group leader's block information.

Make sure the index is updated even if the event is skipped.

With the patch,

  # Samples: 293  of event 'cache-misses'
  # Event count (approx.): 293
  #
  # Sampled Cycles%  Sampled Cycles  Avg Cycles%  Avg Cycles  [Program Block Range]
  # ...............  ..............  ...........  ..........  ..................................................>
  #
           37.98%            9.0K        4.05%           299  [perf_event_addr_filters_exec+0 -> perf_event_a>
           11.19%            2.6K        0.28%            21  [perf_iterate_ctx+48 -> >
            5.79%            1.4K        1.32%            97  [__intel_pmu_enable_all.constprop.0+80 -> __intel_>

Fixes: 6f7164fa231a5f36 ("perf report: Sort by sampled cycles percent per block for stdio")
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20240813160208.2493643-2-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 212760e4dd166..cd2f3f1a75633 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -562,6 +562,7 @@ static int evlist__tty_browse_hists(struct evlist *evlist, struct report *rep, c
 		struct hists *hists = evsel__hists(pos);
 		const char *evname = evsel__name(pos);
 
+		i++;
 		if (symbol_conf.event_group && !evsel__is_group_leader(pos))
 			continue;
 
@@ -571,7 +572,7 @@ static int evlist__tty_browse_hists(struct evlist *evlist, struct report *rep, c
 		hists__fprintf_nr_sample_events(hists, rep, evname, stdout);
 
 		if (rep->total_cycles_mode) {
-			report__browse_block_hists(&rep->block_reports[i++].hist,
+			report__browse_block_hists(&rep->block_reports[i - 1].hist,
 						   rep->min_percent, pos, NULL);
 			continue;
 		}
-- 
2.43.0



