Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1500077F2F;
	Tue, 23 Jan 2024 02:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975541; cv=none; b=OYWvdBFc4x/q+VsKJnl8puk6A4ty5JnWgHE8hR1qyQ/M4rQ7UD3PhW36MpCi+Mp+ueoDgtqfYcZGXGObAyX+UA+gxtoZpe3evE44aWdJaphaWSb6ct4Pym6dwrdniU4+SWlI8yV78iWPvpQ6s9J1SMTdIHWJsNz9TAIAiN7JSFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975541; c=relaxed/simple;
	bh=Vb8vxCc0OHDkY9NoZQEJb337W/AuD2QBTWrcYxR0/Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/KNmc19bKAvKH1gwG9fx40inWLWMYeeYEApOAEBidl9gDmeU9ZBZE76qwMs7PKIUyXYoqgTc8QDG9hEVDyELvFBnIbZ++88ciJm25VtGQHZwHv2BrtGS6JAKmKHo51i93qhjN+fcrO+o54S87jZnZEa9PHy0QvNnzbXcxNTAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JClBQ7ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JClBQ7ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ACBC43390;
	Tue, 23 Jan 2024 02:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975540;
	bh=Vb8vxCc0OHDkY9NoZQEJb337W/AuD2QBTWrcYxR0/Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JClBQ7aoiiga8XPNqk/qypDXsS4PF/ann4J/z0x96/nhNYXzC1Qe2zOGe+IzCmVBj
	 fd3VnOWxUe0OB5ADmbz3HaYJM1GR4E4pf84CG8w1YaKpmamFg5L08safWh0iw1mT5p
	 RCMOtyp1Nh9vUQ5lYSEoM0n4egpgXLik24cT9Szk=
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
Subject: [PATCH 6.6 469/583] perf mem: Fix error on hybrid related to availability of mem event in a PMU
Date: Mon, 22 Jan 2024 15:58:40 -0800
Message-ID: <20240122235826.345837566@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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



