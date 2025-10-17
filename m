Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FAF337110;
	Fri, 17 Oct 2025 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714957; cv=none; b=WJLhm0B+mpHa8ORRKKFy3LI8wWew/b+oXG+8iltd+uLqE8O6s8q1Rk1sxz6ejIz5PNVx7bmeyC6cWi0jz9E1t/xMJbn1WpDl3O3irnpGNxhswOMdVFaL9/9miG8N3oYmWkcqGAdp51PKJPWskkuhcdBmj626jw+IykU1qMysFxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714957; c=relaxed/simple;
	bh=6Fnne7VHaWH9/VTe5Fze+2Jc2HXqu0ZZtKiNCluX6ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vErul7glYemtAYkcVimUFjO6dPtuCWA0ZxowZb7h8WtQdClsGjlUGrGs5rY4s+c6Wn80ZpJa7mUm6kR6i8a31FziReXblEMe1jepz0GsfXjGiPfb0FSPebAFGosIj81zzJdgnMa/FXhd0cTYBvShXpU3GOpTHA4j5ePTcD9h+Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3oIJtcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3oIJtcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C23FC4CEE7;
	Fri, 17 Oct 2025 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714957;
	bh=6Fnne7VHaWH9/VTe5Fze+2Jc2HXqu0ZZtKiNCluX6ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3oIJtcN2zSz1F25Yg6/vpxRzm1NyVenLT/RajFKCHjdI2flvtS+xRvBnxcvz0Nyq
	 hyhPFtA8BUYwD2o7EOgtt/kCmkzG1KS+UMbXnkrUL7w1VztrXF5M/fS2jsk4BZ98pa
	 49b35k07oF2Cm5Mj3WN4cYrS4tT8t7G/aHdmpDo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 047/371] perf evsel: Fix uniquification when PMU given without suffix
Date: Fri, 17 Oct 2025 16:50:22 +0200
Message-ID: <20251017145203.502501600@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 693101792e45eefc888c7ba10b91108047399f5d ]

The PMU name is appearing twice in:
```
$ perf stat -e uncore_imc_free_running/data_total/ -A true

 Performance counter stats for 'system wide':

CPU0                 1.57 MiB  uncore_imc_free_running_0/uncore_imc_free_running,data_total/
CPU0                 1.58 MiB  uncore_imc_free_running_1/uncore_imc_free_running,data_total/
       0.000892376 seconds time elapsed
```

Use the pmu_name_len_no_suffix to avoid this problem.

Committer testing:

After this patch:

  root@x1:~# perf stat -e uncore_imc_free_running/data_total/ -A true

   Performance counter stats for 'system wide':

  CPU0                 1.69 MiB  uncore_imc_free_running_0/data_total/
  CPU0                 1.68 MiB  uncore_imc_free_running_1/data_total/

         0.002141605 seconds time elapsed

  root@x1:~#

Fixes: 7d45f402d3117e0b ("perf evlist: Make uniquifying counter names consistent")
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 496f42434327b..9c086d743d344 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -4050,9 +4050,9 @@ bool evsel__set_needs_uniquify(struct evsel *counter, const struct perf_stat_con
 
 void evsel__uniquify_counter(struct evsel *counter)
 {
-	const char *name, *pmu_name;
-	char *new_name, *config;
-	int ret;
+	const char *name, *pmu_name, *config;
+	char *new_name;
+	int len, ret;
 
 	/* No uniquification necessary. */
 	if (!counter->needs_uniquify)
@@ -4066,15 +4066,23 @@ void evsel__uniquify_counter(struct evsel *counter)
 	counter->uniquified_name = true;
 
 	name = evsel__name(counter);
+	config = strchr(name, '/');
 	pmu_name = counter->pmu->name;
-	/* Already prefixed by the PMU name. */
-	if (!strncmp(name, pmu_name, strlen(pmu_name)))
-		return;
 
-	config = strchr(name, '/');
-	if (config) {
-		int len = config - name;
+	/* Already prefixed by the PMU name? */
+	len = pmu_name_len_no_suffix(pmu_name);
+
+	if (!strncmp(name, pmu_name, len)) {
+		/*
+		 * If the PMU name is there, then there is no sense in not
+		 * having a slash. Do this for robustness.
+		 */
+		if (config == NULL)
+			config = name - 1;
 
+		ret = asprintf(&new_name, "%s/%s", pmu_name, config + 1);
+	} else if (config) {
+		len = config - name;
 		if (config[1] == '/') {
 			/* case: event// */
 			ret = asprintf(&new_name, "%s/%.*s/%s", pmu_name, len, name, config + 2);
@@ -4086,7 +4094,7 @@ void evsel__uniquify_counter(struct evsel *counter)
 		config = strchr(name, ':');
 		if (config) {
 			/* case: event:.. */
-			int len = config - name;
+			len = config - name;
 
 			ret = asprintf(&new_name, "%s/%.*s/%s", pmu_name, len, name, config + 1);
 		} else {
-- 
2.51.0



