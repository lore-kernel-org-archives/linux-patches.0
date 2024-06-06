Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051041BA874;
	Thu,  6 Jun 2024 14:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683483; cv=none; b=TY+IJeRWJVPX/LCEQtXgxCi5DkmD0avFY262MqYoA+MWl3qU53jDu5efUj2GEbhJw2xVV5qZg4vKJSYGwuvQN7HLdCCH716uoO0F36aINPrWLxHKDcmPNqq0yYqeuZGmINxHK5a+Lx4OMkr2IPkrJs8nPbH9Wr7g5voeKS4ThdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683483; c=relaxed/simple;
	bh=oCHuV+thutJFrxTDxP18ehnQkZHPJH5d9jU5rAL6ssM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fka7qS74XoU5e6vLbycBEMEgh6pwLp2U7j2loWAxI2yXr1UJlHsLLtvgNj9ElEn8/BK778dTCirATyLPWJEeckN7yw2Vvx5d6kLaO5aTJU8bcAZAgELtzVhURSUVOAb5UlsO2zcE7OmACwHvAvJFTEs0bX1KvMOl1YlFAXWpP90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLWL2IUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLWL2IUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B9BC2BD10;
	Thu,  6 Jun 2024 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683482;
	bh=oCHuV+thutJFrxTDxP18ehnQkZHPJH5d9jU5rAL6ssM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLWL2IUHuCjxHag22jAhJyfqY0VZVjmUxwGAxSisckLIYep/FRTG8QvrfzfZZMOxx
	 UVzgJApipRcn06h9E92Y3KFsvxE+nng/K/3gSYn3HXdy6nRilQff/Xm5htdzhEhW/R
	 Ov81pqcWNJ3lCXv27s4i4h3kEiHHOLaBee+GmLTo=
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
Subject: [PATCH 6.6 425/744] perf tests: Apply attributes to all events in object code reading test
Date: Thu,  6 Jun 2024 16:01:37 +0200
Message-ID: <20240606131746.103852738@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index ed3815163d1be..ff249555ca57a 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -657,11 +657,11 @@ static int do_test_code_reading(bool try_kcore)
 
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



