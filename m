Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E77364B3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4af5vOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7861AC4E77C;
	Wed, 15 Nov 2023 20:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081786;
	bh=ERtyUS4eoJND5siG8YLiIKNCX993T0cMMDSShq51OVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4af5vOaUKUPxo1gdpt3xxgIdMbkqWLcrxi6H4jan1pFJ1gvSEHd42MgI4dAQbnJo
	 qdhNhF+n9BgcU2OZ4lAtzq8nrWdH+4nU9U8i9IMG3PC7dUjRGJPNF7qSGk2C8rBC8e
	 46X4A+2GAd+GeRW1OEQq7kfP4r0lyPdmy6luqqBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/191] perf evlist: Add evlist__add_dummy_on_all_cpus()
Date: Wed, 15 Nov 2023 15:46:39 -0500
Message-ID: <20231115204651.974403903@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 126d68fdcabed8c2ca5ffaba785add93ef722da8 ]

Add evlist__add_dummy_on_all_cpus() to enable creating a system-wide dummy
event that sets up the system-wide maps before map propagation.

For convenience, add evlist__add_aux_dummy() so that the logic can be used
whether or not the event needs to be system-wide.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Link: https://lore.kernel.org/r/20220524075436.29144-6-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: f9cdeb58a9cf ("perf evlist: Avoid frequency mode for the dummy event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evlist.c | 45 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |  5 +++++
 2 files changed, 50 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 98ae432470cdd..117420abdc325 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -261,6 +261,51 @@ int evlist__add_dummy(struct evlist *evlist)
 	return 0;
 }
 
+static void evlist__add_on_all_cpus(struct evlist *evlist, struct evsel *evsel)
+{
+	evsel->core.system_wide = true;
+
+	/*
+	 * All CPUs.
+	 *
+	 * Note perf_event_open() does not accept CPUs that are not online, so
+	 * in fact this CPU list will include only all online CPUs.
+	 */
+	perf_cpu_map__put(evsel->core.own_cpus);
+	evsel->core.own_cpus = perf_cpu_map__new(NULL);
+	perf_cpu_map__put(evsel->core.cpus);
+	evsel->core.cpus = perf_cpu_map__get(evsel->core.own_cpus);
+
+	/* No threads */
+	perf_thread_map__put(evsel->core.threads);
+	evsel->core.threads = perf_thread_map__new_dummy();
+
+	evlist__add(evlist, evsel);
+}
+
+struct evsel *evlist__add_aux_dummy(struct evlist *evlist, bool system_wide)
+{
+	struct evsel *evsel = evlist__dummy_event(evlist);
+
+	if (!evsel)
+		return NULL;
+
+	evsel->core.attr.exclude_kernel = 1;
+	evsel->core.attr.exclude_guest = 1;
+	evsel->core.attr.exclude_hv = 1;
+	evsel->core.attr.freq = 0;
+	evsel->core.attr.sample_period = 1;
+	evsel->no_aux_samples = true;
+	evsel->name = strdup("dummy:u");
+
+	if (system_wide)
+		evlist__add_on_all_cpus(evlist, evsel);
+	else
+		evlist__add(evlist, evsel);
+
+	return evsel;
+}
+
 static int evlist__add_attrs(struct evlist *evlist, struct perf_event_attr *attrs, size_t nr_attrs)
 {
 	struct evsel *evsel, *n;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 9298fce53ea31..eb36f85ba3f3e 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -111,6 +111,11 @@ int __evlist__add_default_attrs(struct evlist *evlist,
 	__evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
 
 int evlist__add_dummy(struct evlist *evlist);
+struct evsel *evlist__add_aux_dummy(struct evlist *evlist, bool system_wide);
+static inline struct evsel *evlist__add_dummy_on_all_cpus(struct evlist *evlist)
+{
+	return evlist__add_aux_dummy(evlist, true);
+}
 
 int perf_evlist__add_sb_event(struct evlist *evlist,
 			      struct perf_event_attr *attr,
-- 
2.42.0



