Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C06FBFA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8E3C433D2;
	Mon, 15 May 2023 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171165;
	bh=c/fsEZ+3vJxSHyI38WB2qcTWVoPPXqmXN7hk+/8zkKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifdnGzWNoWANXhhp6QGFf4bVMab37EF+wNKX3t03MDdPsIhCHqUlCV7L51sVFnxf3
	 u/CXlbFEa7tXdUC2F1YfGRZ+mYcvSvCaqbgqwPLEuZiQtYsqSw5qrjppSZB3cns/zw
	 XDcv3jfKCUAxaAN52Ubomzn2cgHhCfffqko7AG/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <shy828301@gmail.com>,
	James Clark <james.clark@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Leo Yan <leo.yan@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Suzuki Poulouse <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	coresight@lists.linaro.org,
	denik@google.com,
	linux-arm-kernel@lists.infradead.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 104/242] perf cs-etm: Fix timeless decode mode detection
Date: Mon, 15 May 2023 18:27:10 +0200
Message-Id: <20230515161725.022111650@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

[ Upstream commit 449067f3fc9f340da54e383738286881e6634d0b ]

In this context, timeless refers to the trace data rather than the perf
event data. But when detecting whether there are timestamps in the trace
data or not, the presence of a timestamp flag on any perf event is used.

Since commit f42c0ce573df ("perf record: Always get text_poke events
with --kcore option") timestamps were added to a tracking event when
--kcore is used which breaks this detection mechanism. Fix it by
detecting if trace timestamps exist by looking at the ETM config flags.
This would have always been a more accurate way of doing it anyway.

This fixes the following error message when using --kcore with
Coresight:

  $ perf record --kcore -e cs_etm// --per-thread
  $ perf report
  The perf.data/data data has no samples!

Fixes: f42c0ce573df79d1 ("perf record: Always get text_poke events with --kcore option")
Reported-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: coresight@lists.linaro.org
Cc: denik@google.com
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/lkml/CAHbLzkrJQTrYBtPkf=jf3OpQ-yBcJe7XkvQstX9j2frz4WF-SQ@mail.gmail.com/
Link: https://lore.kernel.org/r/20230424134748.228137-2-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 33303d03c2fa4..2f327986090e1 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -2488,26 +2488,29 @@ static int cs_etm__process_auxtrace_event(struct perf_session *session,
 	return 0;
 }
 
-static bool cs_etm__is_timeless_decoding(struct cs_etm_auxtrace *etm)
+static int cs_etm__setup_timeless_decoding(struct cs_etm_auxtrace *etm)
 {
 	struct evsel *evsel;
 	struct evlist *evlist = etm->session->evlist;
-	bool timeless_decoding = true;
 
 	/* Override timeless mode with user input from --itrace=Z */
-	if (etm->synth_opts.timeless_decoding)
-		return true;
+	if (etm->synth_opts.timeless_decoding) {
+		etm->timeless_decoding = true;
+		return 0;
+	}
 
 	/*
-	 * Circle through the list of event and complain if we find one
-	 * with the time bit set.
+	 * Find the cs_etm evsel and look at what its timestamp setting was
 	 */
-	evlist__for_each_entry(evlist, evsel) {
-		if ((evsel->core.attr.sample_type & PERF_SAMPLE_TIME))
-			timeless_decoding = false;
-	}
+	evlist__for_each_entry(evlist, evsel)
+		if (cs_etm__evsel_is_auxtrace(etm->session, evsel)) {
+			etm->timeless_decoding =
+				!(evsel->core.attr.config & BIT(ETM_OPT_TS));
+			return 0;
+		}
 
-	return timeless_decoding;
+	pr_err("CS ETM: Couldn't find ETM evsel\n");
+	return -EINVAL;
 }
 
 /*
@@ -2884,7 +2887,6 @@ int cs_etm__process_auxtrace_info_full(union perf_event *event,
 	etm->snapshot_mode = (ptr[CS_ETM_SNAPSHOT] != 0);
 	etm->metadata = metadata;
 	etm->auxtrace_type = auxtrace_info->type;
-	etm->timeless_decoding = cs_etm__is_timeless_decoding(etm);
 
 	etm->auxtrace.process_event = cs_etm__process_event;
 	etm->auxtrace.process_auxtrace_event = cs_etm__process_auxtrace_event;
@@ -2894,6 +2896,10 @@ int cs_etm__process_auxtrace_info_full(union perf_event *event,
 	etm->auxtrace.evsel_is_auxtrace = cs_etm__evsel_is_auxtrace;
 	session->auxtrace = &etm->auxtrace;
 
+	err = cs_etm__setup_timeless_decoding(etm);
+	if (err)
+		return err;
+
 	etm->unknown_thread = thread__new(999999999, 999999999);
 	if (!etm->unknown_thread) {
 		err = -ENOMEM;
-- 
2.39.2



