Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE751527AC;
	Fri,  6 Dec 2024 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497720; cv=none; b=XTxDgyA9rFjQrklqRG8JVXM8QHDZJz8r9hLk4XlXCUoxaOSbk40K65DRawuIOhJEoA+4M/ZFRcmIdtsZUUjWV1ADYK+ht0OIuFyVmcNPgKIwgVpebfjvP70zI/E9+aZeL/FcWTp3NyzZW0cIw5IhJqOFauCyndgYrtjmm7ADtMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497720; c=relaxed/simple;
	bh=svwWuE5T0UxKRboHe8LJC3+OSKbYu3IZBM3ksdfmrfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKpaJNecRDpkQafuaelHcLvzP4XralQxx6wgTi//f3D9nV7H+W2NAMoH7lXI0Y8mktGjiqgb+5NXkrTcfF4igkGATJWbkmNwHbUqJYm8rWYpgUWm6ow6O0f8OxNKi4zvO32oS26708tp5+NGvqkbnFsCHBjqObWQLA0I/wrXmdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grrbLID7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grrbLID7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637DEC4CED1;
	Fri,  6 Dec 2024 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497720;
	bh=svwWuE5T0UxKRboHe8LJC3+OSKbYu3IZBM3ksdfmrfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grrbLID7VKZ+kae0jkn7ELEsaa3zzhHjmYdUfBk8lh5KumxYzRM6117/rmFjzwbxd
	 ZhAnJ/VGP7AewQKM/aLKpzwUudbVW47VUX3S/FmbH9ns/yEhyvgu4jQPalNvnWSYVt
	 CG2ciem/+C/HhdEt8nqttv+rQ5FivyOnXl4Cg4pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Jean-Philippe Romain <jean-philippe.romain@foss.st.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Junhao He <hejunhao3@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 373/676] perf list: Fix topic and pmu_name argument order
Date: Fri,  6 Dec 2024 15:33:12 +0100
Message-ID: <20241206143707.914592970@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Jean-Philippe Romain <jean-philippe.romain@foss.st.com>

[ Upstream commit d99b3125726aade4f5ec4aae04805134ab4b0abd ]

Fix function definitions to match header file declaration. Fix two
callers to pass the arguments in the right order.

On Intel Tigerlake, before:
```
$ perf list -j|grep "\"Topic\""|sort|uniq
        "Topic": "cache",
        "Topic": "cpu",
        "Topic": "floating point",
        "Topic": "frontend",
        "Topic": "memory",
        "Topic": "other",
        "Topic": "pfm icl",
        "Topic": "pfm ix86arch",
        "Topic": "pfm perf_raw",
        "Topic": "pipeline",
        "Topic": "tool",
        "Topic": "uncore interconnect",
        "Topic": "uncore memory",
        "Topic": "uncore other",
        "Topic": "virtual memory",
$ perf list -j|grep "\"Unit\""|sort|uniq
        "Unit": "cache",
        "Unit": "cpu",
        "Unit": "cstate_core",
        "Unit": "cstate_pkg",
        "Unit": "i915",
        "Unit": "icl",
        "Unit": "intel_bts",
        "Unit": "intel_pt",
        "Unit": "ix86arch",
        "Unit": "msr",
        "Unit": "perf_raw",
        "Unit": "power",
        "Unit": "tool",
        "Unit": "uncore_arb",
        "Unit": "uncore_clock",
        "Unit": "uncore_imc_free_running_0",
        "Unit": "uncore_imc_free_running_1",
```

After:
```
$ perf list -j|grep "\"Topic\""|sort|uniq
        "Topic": "cache",
        "Topic": "floating point",
        "Topic": "frontend",
        "Topic": "memory",
        "Topic": "other",
        "Topic": "pfm icl",
        "Topic": "pfm ix86arch",
        "Topic": "pfm perf_raw",
        "Topic": "pipeline",
        "Topic": "tool",
        "Topic": "uncore interconnect",
        "Topic": "uncore memory",
        "Topic": "uncore other",
        "Topic": "virtual memory",
$ perf list -j|grep "\"Unit\""|sort|uniq
        "Unit": "cpu",
        "Unit": "cstate_core",
        "Unit": "cstate_pkg",
        "Unit": "i915",
        "Unit": "icl",
        "Unit": "intel_bts",
        "Unit": "intel_pt",
        "Unit": "ix86arch",
        "Unit": "msr",
        "Unit": "perf_raw",
        "Unit": "power",
        "Unit": "tool",
        "Unit": "uncore_arb",
        "Unit": "uncore_clock",
        "Unit": "uncore_imc_free_running_0",
        "Unit": "uncore_imc_free_running_1",
```

Fixes: e5c6109f4813246a ("perf list: Reorganize to use callbacks to allow honouring command line options")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Jean-Philippe Romain <jean-philippe.romain@foss.st.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Junhao He <hejunhao3@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241109025801.560378-1-irogers@google.com
[ I fixed the two callers and added it to Jean-Phillippe's original change. ]
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-list.c | 4 ++--
 tools/perf/util/pfm.c     | 4 ++--
 tools/perf/util/pmus.c    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 61c2c96cc0701..c8c72fcf37e11 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -95,7 +95,7 @@ static void wordwrap(const char *s, int start, int max, int corr)
 	}
 }
 
-static void default_print_event(void *ps, const char *pmu_name, const char *topic,
+static void default_print_event(void *ps, const char *topic, const char *pmu_name,
 				const char *event_name, const char *event_alias,
 				const char *scale_unit __maybe_unused,
 				bool deprecated, const char *event_type_desc,
@@ -321,7 +321,7 @@ static void fix_escape_printf(struct strbuf *buf, const char *fmt, ...)
 	fputs(buf->buf, stdout);
 }
 
-static void json_print_event(void *ps, const char *pmu_name, const char *topic,
+static void json_print_event(void *ps, const char *topic, const char *pmu_name,
 			     const char *event_name, const char *event_alias,
 			     const char *scale_unit,
 			     bool deprecated, const char *event_type_desc,
diff --git a/tools/perf/util/pfm.c b/tools/perf/util/pfm.c
index 862e4a689868b..54421fceef5c7 100644
--- a/tools/perf/util/pfm.c
+++ b/tools/perf/util/pfm.c
@@ -220,7 +220,7 @@ print_libpfm_event(const struct print_callbacks *print_cb, void *print_state,
 	}
 
 	if (is_libpfm_event_supported(name, cpus, threads)) {
-		print_cb->print_event(print_state, pinfo->name, topic,
+		print_cb->print_event(print_state, topic, pinfo->name,
 				      name, info->equiv,
 				      /*scale_unit=*/NULL,
 				      /*deprecated=*/NULL, "PFM event",
@@ -254,8 +254,8 @@ print_libpfm_event(const struct print_callbacks *print_cb, void *print_state,
 				continue;
 
 			print_cb->print_event(print_state,
-					pinfo->name,
 					topic,
+					pinfo->name,
 					name, /*alias=*/NULL,
 					/*scale_unit=*/NULL,
 					/*deprecated=*/NULL, "PFM event",
diff --git a/tools/perf/util/pmus.c b/tools/perf/util/pmus.c
index 54a237b2b8538..f0577aa7eca88 100644
--- a/tools/perf/util/pmus.c
+++ b/tools/perf/util/pmus.c
@@ -474,8 +474,8 @@ void perf_pmus__print_pmu_events(const struct print_callbacks *print_cb, void *p
 			goto free;
 
 		print_cb->print_event(print_state,
-				aliases[j].pmu_name,
 				aliases[j].topic,
+				aliases[j].pmu_name,
 				aliases[j].name,
 				aliases[j].alias,
 				aliases[j].scale_unit,
-- 
2.43.0



