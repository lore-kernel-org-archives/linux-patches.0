Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85686522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F08C433C8;
	Sun,  9 Jul 2023 11:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902461;
	bh=h7tMkKr9fkwvRF79O3qCg7/2bCjH7Ujr8w3lJFds464=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yU4txPjJZ6gV78JlCE+T70yrth8TxrGpvpMPvgxWlZmwsdEfOex9WQAIPVJC25Jhf
	 pXLRqf2kKZ/vcVzWbI/KGQIU2BmFBbBvCWtosPvJelWAxsijhv9k2mz6O2y67izCfe
	 gd/rirBaQLbD0npDgzVHQfnJXR599cdrTRB/g/Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 384/431] perf stat: Reset aggr stats for each run
Date: Sun,  9 Jul 2023 13:15:32 +0200
Message-ID: <20230709111500.166502892@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit ed4090a22c123b9b33368741253edddc6ff8d18f ]

When it runs multiple times with -r option, it missed to reset the
aggregation counters and the values were added up.  The aggregation
count has the values to be printed in the end.  It should reset the
counters at the beginning of each run.  But the current code does that
only when -I/--interval-print option is given.

Fixes: 91f85f98da7ab8c3 ("perf stat: Display event stats using aggr counts")
Reported-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230616073211.1057936-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index eeba93ae3b584..f5a6d08cf07f6 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -777,6 +777,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			all_counters_use_bpf = false;
 	}
 
+	evlist__reset_aggr_stats(evsel_list);
+
 	evlist__for_each_cpu(evlist_cpu_itr, evsel_list, affinity) {
 		counter = evlist_cpu_itr.evsel;
 
-- 
2.39.2



