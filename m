Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB5D1D1E8B;
	Wed,  2 Oct 2024 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878215; cv=none; b=Qkj9jH10CS49ExOFfM7MmS2vRvr8naFptJP3mk39k7ETWLiBt6crr5ZVvX1QzK9Npc7/O7EqG3h1Rx7DA6Z8IfFSRhb7tj3drL2AKEk98OQk1ceGdej8n3UoibhwmUgyqnHkfdHJpXJouovu6D5MVTTiF3B+lAa4YO17PAuQcwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878215; c=relaxed/simple;
	bh=beH752JM3KB7yqTluUV+/SskiSTZq/MxCQ8qnxVromw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhlvMTZqs6IWu6Oe/2FT9dFgT5jvnFzj7SN1bSUzyODazK06VLWuwkQD32lWNY55seMwpBDFrAvCKpZoxCJQm5oIVAJwybCEtbaJ4PGPMJnZNrwtFIWmbkaqsKhqNszAJE1ppJIln0ebp4eiy4lnv4Vy2W0VZpmOiNCq/4kUcII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldU7NVHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldU7NVHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371A6C4CEC2;
	Wed,  2 Oct 2024 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878215;
	bh=beH752JM3KB7yqTluUV+/SskiSTZq/MxCQ8qnxVromw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldU7NVHQiuft0P+8ecYRrpxsUm1mCfRoerbukElPIhLHITMJW+XC+dQ+SOfNK3dFf
	 pjaaIk1yc5wm4RTnBOSRkLXKCuTHWpkOlxSIw2l+ETV+HYjNnjTAfSlbXUJ1Jhfgee
	 DMdF32ljy0LM81MKVrixwFp9VSzKdKBlqYQfRlys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 306/634] perf mem: Check mem_events for all eligible PMUs
Date: Wed,  2 Oct 2024 14:56:46 +0200
Message-ID: <20241002125823.187444302@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 6e05d28ff232cf445cc6ae59336b7f2081ef9b96 ]

The current perf_pmu__mem_events_init() only checks the availability of
the mem_events for the first eligible PMU. It works for non-hybrid
machines and hybrid machines that have the same mem_events.

However, it may bring issues if a hybrid machine has a different
mem_events on different PMU, e.g., Alder Lake and Raptor Lake. A
mem-loads-aux event is only required for the p-core. The mem_events on
both e-core and p-core should be checked and marked.

The issue was not found, because it's hidden by another bug, which only
records the mem-events for the e-core. The wrong check for the p-core
events didn't yell.

Fixes: abbdd79b786e036e ("perf mem: Clean up perf_mem_events__name()")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240905170737.4070743-1-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c     |  2 +-
 tools/perf/builtin-mem.c     |  2 +-
 tools/perf/util/mem-events.c | 14 +++++++++++++-
 tools/perf/util/mem-events.h |  2 +-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index c157bd31f2e5a..0b2cb59212938 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -3266,7 +3266,7 @@ static int perf_c2c__record(int argc, const char **argv)
 		return -1;
 	}
 
-	if (perf_pmu__mem_events_init(pmu)) {
+	if (perf_pmu__mem_events_init()) {
 		pr_err("failed: memory events not supported\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 93413cfcd585a..7fdbaaed14af2 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -97,7 +97,7 @@ static int __cmd_record(int argc, const char **argv, struct perf_mem *mem)
 		return -1;
 	}
 
-	if (perf_pmu__mem_events_init(pmu)) {
+	if (perf_pmu__mem_events_init()) {
 		pr_err("failed: memory events not supported\n");
 		return -1;
 	}
diff --git a/tools/perf/util/mem-events.c b/tools/perf/util/mem-events.c
index 6dda47bb774fa..c844aca0726ce 100644
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -191,7 +191,7 @@ static bool perf_pmu__mem_events_supported(const char *mnt, struct perf_pmu *pmu
 	return !stat(path, &st);
 }
 
-int perf_pmu__mem_events_init(struct perf_pmu *pmu)
+static int __perf_pmu__mem_events_init(struct perf_pmu *pmu)
 {
 	const char *mnt = sysfs__mount();
 	bool found = false;
@@ -218,6 +218,18 @@ int perf_pmu__mem_events_init(struct perf_pmu *pmu)
 	return found ? 0 : -ENOENT;
 }
 
+int perf_pmu__mem_events_init(void)
+{
+	struct perf_pmu *pmu = NULL;
+
+	while ((pmu = perf_pmus__scan_mem(pmu)) != NULL) {
+		if (__perf_pmu__mem_events_init(pmu))
+			return -ENOENT;
+	}
+
+	return 0;
+}
+
 void perf_pmu__mem_events_list(struct perf_pmu *pmu)
 {
 	int j;
diff --git a/tools/perf/util/mem-events.h b/tools/perf/util/mem-events.h
index ca31014d7934f..a6fc2a5939388 100644
--- a/tools/perf/util/mem-events.h
+++ b/tools/perf/util/mem-events.h
@@ -30,7 +30,7 @@ extern unsigned int perf_mem_events__loads_ldlat;
 extern struct perf_mem_event perf_mem_events[PERF_MEM_EVENTS__MAX];
 
 int perf_pmu__mem_events_parse(struct perf_pmu *pmu, const char *str);
-int perf_pmu__mem_events_init(struct perf_pmu *pmu);
+int perf_pmu__mem_events_init(void);
 
 struct perf_mem_event *perf_pmu__mem_events_ptr(struct perf_pmu *pmu, int i);
 struct perf_pmu *perf_mem_events_find_pmu(void);
-- 
2.43.0



