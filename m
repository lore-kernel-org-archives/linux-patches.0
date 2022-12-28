Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4201863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63036C433EF;
	Wed, 28 Dec 2022 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241782;
	bh=mseXsLiypA6NQg/vgIDljnyc6z7ai/3VdKb/O1Cc4WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rn0kJpOTIqqTIL4ISpx4aZyHDOqHfk3fXckBGsHDrlruNxxyZkZS/5pPtJrHXEytq
	 TS1Dg8e4yp9NRRKIfEkpcrbhuGQ3Jbxsc3ymRmAtv6AcR15KKKTXUjpfLWNvWsBxS9
	 T9gKRTidfbwGO5cAvV2qqQS5dB4Odwf4aqkMcfP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@linaro.org>,
	=?UTF-8?q?Adri=C3=A1n=20Herrera=20Arcila?= <adrian.herrera@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 522/731] perf stat: Refactor __run_perf_stat() common code
Date: Wed, 28 Dec 2022 15:40:29 +0100
Message-Id: <20221228144311.677454714@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrián Herrera Arcila <adrian.herrera@arm.com>

[ Upstream commit bb8bc52e75785af94b9ba079277547d50d018a52 ]

This extracts common code from the branches of the forks if-then-else.

enable_counters(), which was at the beginning of both branches of the
conditional, is now unconditional; evlist__start_workload() is extracted
to a different if, which enables making the common clocking code
unconditional.

Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Adrián Herrera Arcila <adrian.herrera@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/r/20220729161244.10522-1-adrian.herrera@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: c587e77e100f ("perf stat: Do not delay the workload with --delay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index abf88a1ad455..2602c750779d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -953,18 +953,18 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			return err;
 	}
 
-	/*
-	 * Enable counters and exec the command:
-	 */
-	if (forks) {
-		err = enable_counters();
-		if (err)
-			return -1;
+	err = enable_counters();
+	if (err)
+		return -1;
+
+	/* Exec the command, if any */
+	if (forks)
 		evlist__start_workload(evsel_list);
 
-		t0 = rdclock();
-		clock_gettime(CLOCK_MONOTONIC, &ref_time);
+	t0 = rdclock();
+	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
+	if (forks) {
 		if (interval || timeout || evlist__ctlfd_initialized(evsel_list))
 			status = dispatch_events(forks, timeout, interval, &times);
 		if (child_pid != -1) {
@@ -982,13 +982,6 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		if (WIFSIGNALED(status))
 			psignal(WTERMSIG(status), argv[0]);
 	} else {
-		err = enable_counters();
-		if (err)
-			return -1;
-
-		t0 = rdclock();
-		clock_gettime(CLOCK_MONOTONIC, &ref_time);
-
 		status = dispatch_events(forks, timeout, interval, &times);
 	}
 
-- 
2.35.1



