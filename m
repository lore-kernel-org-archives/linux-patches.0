Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0B5337107;
	Fri, 17 Oct 2025 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713020; cv=none; b=VE6KydX8ivEvKpr4fDvAMPjV/vfQ7+P5WQKdem/R4qPwNu8t3g4Eip8YwRmsE7kgrHfPkQag1whlRD6Cohha3hU7KxVl9y6UNbg5piP0dX5ua0X1RIpdREeEDTHG2+1W63yu2QR6vXLu1bdMSWhmMInJ8IesTv1Ex5W32vDc7Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713020; c=relaxed/simple;
	bh=Rb3P0jIDo2NvMtjAmbJHv0tgm3CqVuL7ytqbNnEhqd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Giu2meJagFa5YdX2GfvWwlWmlgDSGmYr1kt0l8wQ9WeYJP7l+WQBTVBn2oYDDuhN+NujYtc5bRZWCdO7tpiBF8rIO3O/985QlYLuZdfKIuL7XcJQjJ8+yUTwPxLY+qDGwc/VzXDySOBVRSv+Bfs5IPlJYOxlmU1pX/g6s9ShSGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Odr4z7mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Odr4z7mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627E3C4CEE7;
	Fri, 17 Oct 2025 14:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713020;
	bh=Rb3P0jIDo2NvMtjAmbJHv0tgm3CqVuL7ytqbNnEhqd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Odr4z7mhyeDD6hFMRsA5r2/ewcQvJUPAHTDvSRRPpJZoOdldwXzmTmYLtzIwyN/st
	 Iuybv5Bm+Jd5o74bgFuwuGzXUUAZLxlJkWW8xMszKhApGeYmS9yX52gQpzhykK7ToS
	 XXlUmkJKURyLWSyd6IOs8OI+yOQIWtYQesEnmSx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Blake Jones <blakejones@google.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Collin Funk <collin.funk1@gmail.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Li Huafei <lihuafei1@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nam Cao <namcao@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/168] perf evsel: Avoid container_of on a NULL leader
Date: Fri, 17 Oct 2025 16:51:25 +0200
Message-ID: <20251017145129.244140425@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 2354479026d726954ff86ce82f4b649637319661 ]

An evsel should typically have a leader of itself, however, in tests
like 'Sample parsing' a NULL leader may occur and the container_of
will return a corrupt pointer.

Avoid this with an explicit NULL test.

Fixes: fba7c86601e2e42d ("libperf: Move 'leader' from tools/perf to perf_evsel::leader")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Blake Jones <blakejones@google.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Collin Funk <collin.funk1@gmail.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250821163820.1132977-4-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 22969cc00a5fc..755da242f2670 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3146,6 +3146,8 @@ bool evsel__is_hybrid(struct evsel *evsel)
 
 struct evsel *evsel__leader(struct evsel *evsel)
 {
+	if (evsel->core.leader == NULL)
+		return NULL;
 	return container_of(evsel->core.leader, struct evsel, core);
 }
 
-- 
2.51.0



