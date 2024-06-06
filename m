Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38B2196DBF;
	Thu,  6 Jun 2024 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682908; cv=none; b=qF0SrPZt7utE6FWAP8nUdv8KotfloZBR4MLvRjECPsMwLHfaK7j8DqgMZUxhWu73TTj1P3eGMDTV9hH2J1VtZk5Nhjp9KcUF8xbEODHdFJS82ZYuLwHkaKHwG3AqSAPRrbDYCNeQAGTVFgErWkd++Cl7K3IPu1zdc4car9eHrAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682908; c=relaxed/simple;
	bh=2AUWF9UElftPgnWR46nl5qC4XQNQ1BtYgVu7l6T4DVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPIfdYHlxXjYJrdV+lQURgNIsM+sOBYnymoaDHhxowKFWjRuplHZqYThgDR64X9RaW2nNL2S/kPAfcD9vs6Ghvh8P3ZVzNslGPO0QntMWiMovU9SPCRbT6AuPD8FUpi3wpmKTId1VwjCGUW89+nQwHySq71KuAerlcLUnd1ih4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwvQ30g/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwvQ30g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9CDC4AF07;
	Thu,  6 Jun 2024 14:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682908;
	bh=2AUWF9UElftPgnWR46nl5qC4XQNQ1BtYgVu7l6T4DVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwvQ30g/+K+FhImbIAtYR+IUtgqk8Qg5b7qGRQUJ3OzvIpdMHY0Olfz/9NNAiVzl2
	 MPDpK+3LKiWaY8626QE1pVucC6BAmLEAL7NgzRfOMuJdY2Id7rfRBPpRnwJiyiVdbq
	 RdgIY4LDSGUVHxHpVz3hFZVj+JjsX+fC/vfEx5dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Spoorthy S <spoorts2@in.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 035/374] perf tests: Apply attributes to all events in object code reading test
Date: Thu,  6 Jun 2024 16:00:14 +0200
Message-ID: <20240606131653.004764935@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit 2dade41a533f337447b945239b87ff31a8857890 ]

PERF_PMU_CAP_EXTENDED_HW_TYPE results in multiple events being opened on
heterogeneous systems. Currently this test only sets its required
attributes on the first event. Not disabling enable_on_exec on the other
events causes the test to fail because the forked objdump processes are
sampled. No tracking event is opened so Perf only knows about its own
mappings causing the objdump samples to give the following error:

  $ perf test -vvv "object code reading"

  Reading object code for memory address: 0xffff9aaa55ec
  thread__find_map failed
  ---- end(-1) ----
  24: Object code reading              : FAILED!

Fixes: 251aa040244a3b17 ("perf parse-events: Wildcard most "numeric" events")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Spoorthy S <spoorts2@in.ibm.com>
Link: https://lore.kernel.org/r/20240410103458.813656-3-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/code-reading.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 7a3a7bbbec714..29d2f3ee4e10f 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -637,11 +637,11 @@ static int do_test_code_reading(bool try_kcore)
 
 		evlist__config(evlist, &opts, NULL);
 
-		evsel = evlist__first(evlist);
-
-		evsel->core.attr.comm = 1;
-		evsel->core.attr.disabled = 1;
-		evsel->core.attr.enable_on_exec = 0;
+		evlist__for_each_entry(evlist, evsel) {
+			evsel->core.attr.comm = 1;
+			evsel->core.attr.disabled = 1;
+			evsel->core.attr.enable_on_exec = 0;
+		}
 
 		ret = evlist__open(evlist);
 		if (ret < 0) {
-- 
2.43.0



