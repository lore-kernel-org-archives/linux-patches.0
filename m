Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BFB22EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3zSyqa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755CDC433C8;
	Mon,  6 Nov 2023 13:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277286;
	bh=6Y4vCP8XU1r9SPYgxL2UrLmjVuiooJ960Gw/mtDDfTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3zSyqa1l0wVNYoHyibzguDgElyMhIUtZuKj1VrmLXi4zacfvkjoq+zvwNQZm1N0W
	 7Nu+kN0xZE+JQEcMCCDKyzoexhI7G8FvQM2K8HmeAS7f2wjlAnrvPMRB2MVOilUCHZ
	 U4Pcp4uUKF0ud8B4bRVRjKYwEHkNXDAiwl9XXcLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/128] perf tools: Get rid of evlist__add_on_all_cpus()
Date: Mon,  6 Nov 2023 14:04:22 +0100
Message-ID: <20231106130313.804616255@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 60ea006f72512fd7c36f16cdbe91f4fc284f8115 ]

The cpu and thread maps are properly handled in libperf now.  No need to
do it in the perf tools anymore.  Let's remove the logic.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221003204647.1481128-4-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: f9cdeb58a9cf ("perf evlist: Avoid frequency mode for the dummy event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evlist.c | 29 ++---------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a75cdcf381308..63ef40543a9fe 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -258,28 +258,6 @@ int evlist__add_dummy(struct evlist *evlist)
 	return 0;
 }
 
-static void evlist__add_on_all_cpus(struct evlist *evlist, struct evsel *evsel)
-{
-	evsel->core.system_wide = true;
-
-	/*
-	 * All CPUs.
-	 *
-	 * Note perf_event_open() does not accept CPUs that are not online, so
-	 * in fact this CPU list will include only all online CPUs.
-	 */
-	perf_cpu_map__put(evsel->core.own_cpus);
-	evsel->core.own_cpus = perf_cpu_map__new(NULL);
-	perf_cpu_map__put(evsel->core.cpus);
-	evsel->core.cpus = perf_cpu_map__get(evsel->core.own_cpus);
-
-	/* No threads */
-	perf_thread_map__put(evsel->core.threads);
-	evsel->core.threads = perf_thread_map__new_dummy();
-
-	evlist__add(evlist, evsel);
-}
-
 struct evsel *evlist__add_aux_dummy(struct evlist *evlist, bool system_wide)
 {
 	struct evsel *evsel = evlist__dummy_event(evlist);
@@ -292,14 +270,11 @@ struct evsel *evlist__add_aux_dummy(struct evlist *evlist, bool system_wide)
 	evsel->core.attr.exclude_hv = 1;
 	evsel->core.attr.freq = 0;
 	evsel->core.attr.sample_period = 1;
+	evsel->core.system_wide = system_wide;
 	evsel->no_aux_samples = true;
 	evsel->name = strdup("dummy:u");
 
-	if (system_wide)
-		evlist__add_on_all_cpus(evlist, evsel);
-	else
-		evlist__add(evlist, evsel);
-
+	evlist__add(evlist, evsel);
 	return evsel;
 }
 
-- 
2.42.0



