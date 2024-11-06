Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1051DF736;
	Wed,  6 Nov 2024 12:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895959; cv=none; b=Dj8uKx0/5ThrmDP9pk277yfkvCLq5+5HbqOC6xpaJk9crvNM0NdUH+3atfZ/d/duIKyeN3fM9AjpvT4BanK4nutD5ytEYUao1ywdgQyGm0pLLCyTVExsJN1GEbNCtA6gfoEiTq+f2k5pRmxGm3FkGpBQOYIUhOlPwHUprcg+atc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895959; c=relaxed/simple;
	bh=7rws39mYn5gm2o9Ps6Q5U/JvVtoovJAX6/y9Q2znfDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JpeuhQkI0RXcI9o9yUqBKdxHMiQZuLEgSFcDVxebmYQ1JqDqH/cQE4cXBu+EIXwx9zeuj4C28iUwGYU7OAw7Om5XFHsO2ZZWW7BiBd8SRpx/68edLIHI2dLl4FB5exlVqBHIXVWm3zAg6GCkicODjrlHhzis5od8+6KWEIB/oEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ve3FlcnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ve3FlcnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF21C4CECD;
	Wed,  6 Nov 2024 12:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895959;
	bh=7rws39mYn5gm2o9Ps6Q5U/JvVtoovJAX6/y9Q2znfDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ve3FlcnKdTmmCjeTdM5N3qMkqakaDCfHh6JVe825Ny/tRSgKtRV0cmsGnYUJT224s
	 PkBjf1SSdY5nFMcbpji9t+3rkS7ybNWXL7GLHBK3UG6TZ4feoGMGfYZWeP7Vd5ffW2
	 GFlmzsqE4dz+X7DrZNLOSKiFzUIfXXr6oCkliNco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 007/245] perf python: Fix up the build on architectures without HAVE_KVM_STAT_SUPPORT
Date: Wed,  6 Nov 2024 13:01:00 +0100
Message-ID: <20241106120319.425625622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 758f18158952a6287ac23679ec04c32d44ca5368 ]

Noticed while building on a raspbian arm 32-bit system.

There was also this other case, fixed by adding a missing util/stat.h
with the prototypes:

  /tmp/tmp.MbiSHoF3dj/perf-6.12.0-rc3/tools/perf/util/python.c:1396:6: error: no previous prototype for ‘perf_stat__set_no_csv_summary’ [-Werror=missing-prototypes]
   1396 | void perf_stat__set_no_csv_summary(int set __maybe_unused)
        |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /tmp/tmp.MbiSHoF3dj/perf-6.12.0-rc3/tools/perf/util/python.c:1400:6: error: no previous prototype for ‘perf_stat__set_big_num’ [-Werror=missing-prototypes]
   1400 | void perf_stat__set_big_num(int set __maybe_unused)
        |      ^~~~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

In other architectures this must be building due to some lucky indirect
inclusion of that header.

Fixes: 9dabf4003423c8d3 ("perf python: Switch module to linking libraries from building source")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/lkml/ZxllAtpmEw5fg9oy@x1
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 31a223eaf8e65..ee3d43a7ba457 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -19,6 +19,7 @@
 #include "util/bpf-filter.h"
 #include "util/env.h"
 #include "util/kvm-stat.h"
+#include "util/stat.h"
 #include "util/kwork.h"
 #include "util/sample.h"
 #include "util/lock-contention.h"
@@ -1355,6 +1356,7 @@ PyMODINIT_FUNC PyInit_perf(void)
 
 unsigned int scripting_max_stack = PERF_MAX_STACK_DEPTH;
 
+#ifdef HAVE_KVM_STAT_SUPPORT
 bool kvm_entry_event(struct evsel *evsel __maybe_unused)
 {
 	return false;
@@ -1384,6 +1386,7 @@ void exit_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
 			   char *decode __maybe_unused)
 {
 }
+#endif // HAVE_KVM_STAT_SUPPORT
 
 int find_scripts(char **scripts_array  __maybe_unused, char **scripts_path_array  __maybe_unused,
 		int num  __maybe_unused, int pathlen __maybe_unused)
-- 
2.43.0



