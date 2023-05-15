Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E23FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A027C433D2;
	Mon, 15 May 2023 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169716;
	bh=8z5yXFlNasZ1rri+oVWZ3attzAR6SXce5X0Om3gSaCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEQgQi4TRNENaBUkazrc6doH/KQ78IRHmQ07zhbzkdEV1qRyspBqH+0+nrFAILIQC
	 DbX/7DCyFgmRGSx/ImmvQdRKrBupzkzg2o26zIvLODUNlWywekEACWLbzjNDUjdTyJ
	 kM8Tq2nICOAqeqdNXiDHNibfPc4v0BhDzLWlLH+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 120/246] perf stat: Separate bperf from bpf_profiler
Date: Mon, 15 May 2023 18:25:32 +0200
Message-Id: <20230515161726.169240860@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitrii Dolgov <9erthalion6@gmail.com>

[ Upstream commit ecc68ee216c6c5b2f84915e1441adf436f1b019b ]

It seems that perf stat -b <prog id> doesn't produce any results:

    $ perf stat -e cycles -b 4 -I 10000 -vvv
    Control descriptor is not initialized
    cycles: 0 0 0
                time        counts unit      events
	10.007641640    <not supported>      cycles

Looks like this happens because fentry/fexit progs are getting loaded, but the
corresponding perf event is not enabled and not added into the events bpf map.
I think there is some mixing up between two type of bpf support, one for bperf
and one for bpf_profiler. Both are identified via evsel__is_bpf, based on which
perf events are enabled, but for the latter (bpf_profiler) a perf event is
required. Using evsel__is_bperf to check only bperf produces expected results:

    $ perf stat -e cycles -b 4 -I 10000 -vvv
    Control descriptor is not initialized
    ------------------------------------------------------------
    perf_event_attr:
      size                             136
      sample_type                      IDENTIFIER
      read_format                      TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING
      disabled                         1
      exclude_guest                    1
    ------------------------------------------------------------
    sys_perf_event_open: pid -1  cpu 0  group_fd -1  flags 0x8 = 3
    ------------------------------------------------------------
    [...perf_event_attr for other CPUs...]
    ------------------------------------------------------------
    cycles: 309426 169009 169009
		time             counts unit events
	10.010091271             309426      cycles

The final numbers correspond (at least in the level of magnitude) to the
same metric obtained via bpftool.

Fixes: 112cb56164bc2108 ("perf stat: Introduce config stat.bpf-counter-events")
Reviewed-by: Song Liu <song@kernel.org>
Signed-off-by: Dmitrii Dolgov <9erthalion6@gmail.com>
Tested-by: Song Liu <song@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230412182316.11628-1-9erthalion6@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 4 ++--
 tools/perf/util/evsel.h   | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index fa7c40956d0fa..eeba93ae3b584 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -773,7 +773,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		counter->reset_group = false;
 		if (bpf_counter__load(counter, &target))
 			return -1;
-		if (!evsel__is_bpf(counter))
+		if (!(evsel__is_bperf(counter)))
 			all_counters_use_bpf = false;
 	}
 
@@ -789,7 +789,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 
 		if (counter->reset_group || counter->errored)
 			continue;
-		if (evsel__is_bpf(counter))
+		if (evsel__is_bperf(counter))
 			continue;
 try_again:
 		if (create_perf_stat_counter(counter, &stat_config, &target,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 24cb807ef6ce0..1a7358b46ad4e 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -267,6 +267,11 @@ static inline bool evsel__is_bpf(struct evsel *evsel)
 	return evsel->bpf_counter_ops != NULL;
 }
 
+static inline bool evsel__is_bperf(struct evsel *evsel)
+{
+	return evsel->bpf_counter_ops != NULL && list_empty(&evsel->bpf_counter_list);
+}
+
 #define EVSEL__MAX_ALIASES 8
 
 extern const char *const evsel__hw_cache[PERF_COUNT_HW_CACHE_MAX][EVSEL__MAX_ALIASES];
-- 
2.39.2



