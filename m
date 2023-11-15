Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB5A3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPp4hS4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0EFC433C7;
	Wed, 15 Nov 2023 19:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078324;
	bh=/NSF0mPqyY3P/QZ93Bvt6HqdSmLjd4rCHeBJ7LZ8iN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPp4hS4GMZ8h5lZM8BEtYLY7PwL9v06TZSxE7npOttHjETzN7HAsCiQLWp+lt+4dP
	 hEF4g6asR8bj5Nj5kTcw9k2gebH6Iyme9Vkn/AXbrgN7ifzGVsx1UHdh/GtQ7gkPp/
	 T0V+xByow9uL0qh1oyEwddIphyCnrkoPNm3ZUXpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 253/379] perf stat: Fix aggr mode initialization
Date: Wed, 15 Nov 2023 14:25:28 -0500
Message-ID: <20231115192700.111069333@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

[ Upstream commit a84fbf205609313594b86065c67e823f09ebe29b ]

Generating metrics llc_code_read_mpi_demand_plus_prefetch,
llc_data_read_mpi_demand_plus_prefetch,
llc_miss_local_memory_bandwidth_read,
llc_miss_local_memory_bandwidth_write,
nllc_miss_remote_memory_bandwidth_read, memory_bandwidth_read,
memory_bandwidth_write, uncore_frequency, upi_data_transmit_bw,
C2_Pkg_Residency, C3_Core_Residency, C3_Pkg_Residency,
C6_Core_Residency, C6_Pkg_Residency, C7_Core_Residency,
C7_Pkg_Residency, UNCORE_FREQ and tma_info_system_socket_clks would
trigger an address sanitizer heap-buffer-overflows on a SkylakeX.

```
==2567752==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x5020003ed098 at pc 0x5621a816654e bp 0x7fffb55d4da0 sp 0x7fffb55d4d98
READ of size 4 at 0x5020003eee78 thread T0
    #0 0x558265d6654d in aggr_cpu_id__is_empty tools/perf/util/cpumap.c:694:12
    #1 0x558265c914da in perf_stat__get_aggr tools/perf/builtin-stat.c:1490:6
    #2 0x558265c914da in perf_stat__get_global_cached tools/perf/builtin-stat.c:1530:9
    #3 0x558265e53290 in should_skip_zero_counter tools/perf/util/stat-display.c:947:31
    #4 0x558265e53290 in print_counter_aggrdata tools/perf/util/stat-display.c:985:18
    #5 0x558265e51931 in print_counter tools/perf/util/stat-display.c:1110:3
    #6 0x558265e51931 in evlist__print_counters tools/perf/util/stat-display.c:1571:5
    #7 0x558265c8ec87 in print_counters tools/perf/builtin-stat.c:981:2
    #8 0x558265c8cc71 in cmd_stat tools/perf/builtin-stat.c:2837:3
    #9 0x558265bb9bd4 in run_builtin tools/perf/perf.c:323:11
    #10 0x558265bb98eb in handle_internal_command tools/perf/perf.c:377:8
    #11 0x558265bb9389 in run_argv tools/perf/perf.c:421:2
    #12 0x558265bb9389 in main tools/perf/perf.c:537:3
```

The issue was the use of testing a cpumap with NULL rather than using
empty, as a map containing the dummy value isn't NULL and the -1
results in an empty aggr map being allocated which legitimately
overflows when any member is accessed.

Fixes: 8a96f454f5668572 ("perf stat: Avoid SEGV if core.cpus isn't set")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230906003912.3317462-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a2c74a34e4a44..bdd8dd54fdb63 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1444,7 +1444,7 @@ static int perf_stat_init_aggr_mode(void)
 	 * taking the highest cpu number to be the size of
 	 * the aggregation translate cpumap.
 	 */
-	if (evsel_list->core.user_requested_cpus)
+	if (!perf_cpu_map__empty(evsel_list->core.user_requested_cpus))
 		nr = perf_cpu_map__max(evsel_list->core.user_requested_cpus).cpu;
 	else
 		nr = 0;
-- 
2.42.0



