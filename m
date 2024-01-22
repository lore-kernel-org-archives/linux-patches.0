Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1F952F7C;
	Tue, 23 Jan 2024 00:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969905; cv=none; b=KkZ5/sKs7D8PP6EdLhuPQ4CBtHbozCKDM9YzDQ0V0L15gmCafRabvIey3O5KCQIsTajf/Sz9WDi5lTt3aJuzck43+LqLm2GC0ZptYq/OijMCi/279ImyAyLytofE+v23uRQzB120j76rIhhT2vfjG70AeR72SNIoHsbXjLXg+rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969905; c=relaxed/simple;
	bh=UJj7jmxjlWzWVdQCCqYrTcz5npzYnZxDinnWg9oOoME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbdoS0FXGMFZVgskKMQOLXn241Giz+OYlkmtBw42LOBhvGmF0yFyoAWWQ+CUhazAT5BrVWkPvN+RzYloTkUdF8c8WR1wrKQAHpaf9SaxkWygENNysfBvw+1d0WwjgtgppMVytoi0yYz1CIaCYScBw/VsRkCB4CEpOReOm0Nyoos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUzGKwcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUzGKwcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30231C433F1;
	Tue, 23 Jan 2024 00:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969905;
	bh=UJj7jmxjlWzWVdQCCqYrTcz5npzYnZxDinnWg9oOoME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUzGKwcvXGY2VbJsw1NVnTD0Ae3Q9FWPCBMhIKXLc40ke3wXtNWSN4C1N+janTRng
	 oMeRLa0F+Sf/SguMGBnf/2Ioeg0XM3EtWsi8Mqsb1tbBh7RHFvCjuDPmka5Sc/Z0xG
	 WU8hxHEq9U3xTGOkS9vRKPvTpSZ1XC/5DzvZgfiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ammy Yi <ammy.yi@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 518/641] perf mem: Fix error on hybrid related to availability of mem event in a PMU
Date: Mon, 22 Jan 2024 15:57:02 -0800
Message-ID: <20240122235834.304939665@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit a4320085a6c694326dd8db46f563d52d1a826f07 ]

The below error can be triggered on a hybrid machine.

 $ perf mem record -t load sleep 1
 event syntax error: 'breakpoint/mem-loads,ldlat=30/P'
                                \___ Bad event or PMU

 Unable to find PMU or event on a PMU of 'breakpoint'

In the perf_mem_events__record_args(), the current perf never checks the
availability of a mem event on a given PMU. All the PMUs will be added
to the perf mem event list. Perf errors out for the unsupported PMU.

Extend perf_mem_event__supported() and take a PMU into account. Check
the mem event for each PMU before adding it to the perf mem event list.

Optimize the perf_mem_events__init() a little bit. The function is to
check whether the mem events are supported in the system. It doesn't
need to scan all PMUs. Just return with the first supported PMU is good
enough.

Fixes: 5752c20f3787c9bc ("perf mem: Scan all PMUs instead of just core ones")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Ammy Yi <ammy.yi@intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20231128203940.3964287-1-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mem-events.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/mem-events.c b/tools/perf/util/mem-events.c
index 954b235e12e5..3a2e3687878c 100644
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -100,11 +100,14 @@ int perf_mem_events__parse(const char *str)
 	return -1;
 }
 
-static bool perf_mem_event__supported(const char *mnt, char *sysfs_name)
+static bool perf_mem_event__supported(const char *mnt, struct perf_pmu *pmu,
+				      struct perf_mem_event *e)
 {
+	char sysfs_name[100];
 	char path[PATH_MAX];
 	struct stat st;
 
+	scnprintf(sysfs_name, sizeof(sysfs_name), e->sysfs_name, pmu->name);
 	scnprintf(path, PATH_MAX, "%s/devices/%s", mnt, sysfs_name);
 	return !stat(path, &st);
 }
@@ -120,7 +123,6 @@ int perf_mem_events__init(void)
 
 	for (j = 0; j < PERF_MEM_EVENTS__MAX; j++) {
 		struct perf_mem_event *e = perf_mem_events__ptr(j);
-		char sysfs_name[100];
 		struct perf_pmu *pmu = NULL;
 
 		/*
@@ -136,12 +138,12 @@ int perf_mem_events__init(void)
 		 * of core PMU.
 		 */
 		while ((pmu = perf_pmus__scan(pmu)) != NULL) {
-			scnprintf(sysfs_name, sizeof(sysfs_name), e->sysfs_name, pmu->name);
-			e->supported |= perf_mem_event__supported(mnt, sysfs_name);
+			e->supported |= perf_mem_event__supported(mnt, pmu, e);
+			if (e->supported) {
+				found = true;
+				break;
+			}
 		}
-
-		if (e->supported)
-			found = true;
 	}
 
 	return found ? 0 : -ENOENT;
@@ -167,13 +169,10 @@ static void perf_mem_events__print_unsupport_hybrid(struct perf_mem_event *e,
 						    int idx)
 {
 	const char *mnt = sysfs__mount();
-	char sysfs_name[100];
 	struct perf_pmu *pmu = NULL;
 
 	while ((pmu = perf_pmus__scan(pmu)) != NULL) {
-		scnprintf(sysfs_name, sizeof(sysfs_name), e->sysfs_name,
-			  pmu->name);
-		if (!perf_mem_event__supported(mnt, sysfs_name)) {
+		if (!perf_mem_event__supported(mnt, pmu, e)) {
 			pr_err("failed: event '%s' not supported\n",
 			       perf_mem_events__name(idx, pmu->name));
 		}
@@ -183,6 +182,7 @@ static void perf_mem_events__print_unsupport_hybrid(struct perf_mem_event *e,
 int perf_mem_events__record_args(const char **rec_argv, int *argv_nr,
 				 char **rec_tmp, int *tmp_nr)
 {
+	const char *mnt = sysfs__mount();
 	int i = *argv_nr, k = 0;
 	struct perf_mem_event *e;
 
@@ -211,6 +211,9 @@ int perf_mem_events__record_args(const char **rec_argv, int *argv_nr,
 			while ((pmu = perf_pmus__scan(pmu)) != NULL) {
 				const char *s = perf_mem_events__name(j, pmu->name);
 
+				if (!perf_mem_event__supported(mnt, pmu, e))
+					continue;
+
 				rec_argv[i++] = "-e";
 				if (s) {
 					char *copy = strdup(s);
-- 
2.43.0



