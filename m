Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC8213C69C;
	Thu, 13 Jun 2024 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281231; cv=none; b=qGaYNRAGuAAVfbyoubyR9I6wLL7+zh8O4Ft5X6bQWD/IMNPqrsyaRGXSQFN3wu8YbJ+CVQsDXim1TP7sYKJr+6dkLlLtOXEywY/XFV+fBQviMVtFe0aBdHSdhEddt5Ogyvj7c8BK7AL7HfhbU0wPd4Ro8ZzQh0O+gOhWkRcW9Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281231; c=relaxed/simple;
	bh=DdyYPkQLnBcI8axQjFIsBX3HJS5GIvOWGkfv/kiE3KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZv8kzZ2lMDyiQx8sHK9YY1+G2rX8gpwuS4aMeDO6QGmJmwFOKqHBnIXXKIdtnMsExmqGZ/FZICWV+d0ajCzBC0Sw+Ckyox2BqNWWfmvZQIX3YUh0Lq/Rj7E1RgRwglmwB6J0TJglXln4S7g5oct1NJxJ4FqW4SzqaVPjidfnfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOnZIIQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOnZIIQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8D9C2BBFC;
	Thu, 13 Jun 2024 12:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281231;
	bh=DdyYPkQLnBcI8axQjFIsBX3HJS5GIvOWGkfv/kiE3KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOnZIIQnuITCcL8+7PQ/VmnXFpHXAVSUTg6BRxCxGLik4Nv9qM1Agoq+fEfC8mdW9
	 Yr5Cyxr9clULnokUmwTQLpbYmogmIkJT1m4F/YskbSk1YhVPdCGx4+ikNo580XEg6Z
	 8GYGx476R4wogbfFU4vvTj3QryjTaXecd1iVRx8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/317] perf report: Avoid SEGV in report__setup_sample_type()
Date: Thu, 13 Jun 2024 13:33:22 +0200
Message-ID: <20240613113254.677628090@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 45b4f402a6b782352c4bafcff682bfb01da9ca05 ]

In some cases evsel->name is lazily initialized in evsel__name(). If not
initialized passing NULL to strstr() leads to a SEGV.

Fixes: ccb17caecfbd542f ("perf report: Set PERF_SAMPLE_DATA_SRC bit for Arm SPE event")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240508035301.1554434-4-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b55ee073c2f72..6283c2d10d27d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -401,7 +401,7 @@ static int report__setup_sample_type(struct report *rep)
 		 * compatibility, set the bit if it's an old perf data file.
 		 */
 		evlist__for_each_entry(session->evlist, evsel) {
-			if (strstr(evsel->name, "arm_spe") &&
+			if (strstr(evsel__name(evsel), "arm_spe") &&
 				!(sample_type & PERF_SAMPLE_DATA_SRC)) {
 				evsel->core.attr.sample_type |= PERF_SAMPLE_DATA_SRC;
 				sample_type |= PERF_SAMPLE_DATA_SRC;
-- 
2.43.0



