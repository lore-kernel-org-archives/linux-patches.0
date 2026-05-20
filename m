Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B09339844;
	Wed, 20 May 2026 16:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296032; cv=none; b=SFPs+Cy0wet9LN6PxJbjMMP7olQw0Gds7eI+GxkYxLGydtSox9L1UTTTNjYFlI5yUR0a57a1g8ZWbUOQdO59qakfj1F6Ntg9fhu42VqcP0b1IjMTY13Gi0zoVV8WeLsPQUpBhw7DbEfRII2zdPnTALuQ4PpiYPqpNLBRu1fl20c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296032; c=relaxed/simple;
	bh=mRh2xq+1iw+Yh69kGSPRyMPIn+CdGgNo8lg6+CaE/Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENN+iU733NDCSkta62l124euOLMOpt/MIMs4HME26EMfNc02Uvr5mgGlQ+xOCisoejpLt02c7M+DVeqqo4UXqukoFiRA03/IqGezBbULh7YLajb8Cs0f9eFUYyyjjHBUMFCx72JPel0IgTtgq1QV6snCeNrJl3ZI82ryYB7AW4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xC0mIe0q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xC0mIe0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5A41F000E9;
	Wed, 20 May 2026 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296031;
	bh=zMpVlTvhWILFU5vCqpF3oUoCEPCbTuYxETtKXfqdbW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xC0mIe0q4Ltgd7FLadpeuye8Z7KmKx6zzS236Ku9K287ogPiD1+8LhcStCN2Cq8N5
	 c+DxCJC5KMbPIY2WXeTlF1W750Fc52bqC7dwQKKflXvX2hvm4zJvKH/Mww8xkaawBA
	 jFEHCObGeR1CaN/e4gQOcI+kTgxRkAN0IgWa1M2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Falcon <thomas.falcon@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0643/1146] perf test: Fix ratio_to_prev event parsing test
Date: Wed, 20 May 2026 18:14:53 +0200
Message-ID: <20260520162202.729277956@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Falcon <thomas.falcon@intel.com>

[ Upstream commit 77cb9b443b7fff2a93d78cd2e309db030046772f ]

test__ratio_to_prev() assumed the first event in a group is the leader,
which is not the case when the event is expanded into two event groups
on hybrid PMU's with auto counter reload support. Instead, iterate over the
event group generated for each core PMU. Also update "wrong leader" test to
check that the subordinate event has the correct leader instead of checking
that it is not the group leader. Finally, do not exit immediately if a PMU
without auto counter reload support is found.

Signed-off-by: Thomas Falcon <thomas.falcon@intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 56be0fe5f62c ("perf record: Add auto counter reload parse and regression tests")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/parse-events.c | 49 +++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 1d3cc224fbc27..05c3e899b4251 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1796,31 +1796,38 @@ static bool test__acr_valid(void)
 
 static int test__ratio_to_prev(struct evlist *evlist)
 {
-	struct evsel *evsel;
+	struct evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 2 * perf_pmus__num_core_pmus() == evlist->core.nr_entries);
 
-	 evlist__for_each_entry(evlist, evsel) {
-		if (!perf_pmu__has_format(evsel->pmu, "acr_mask"))
-			return TEST_OK;
-
-		if (evsel == evlist__first(evlist)) {
-			TEST_ASSERT_VAL("wrong config2", 0 == evsel->core.attr.config2);
-			TEST_ASSERT_VAL("wrong leader", evsel__is_group_leader(evsel));
-			TEST_ASSERT_VAL("wrong core.nr_members", evsel->core.nr_members == 2);
-			TEST_ASSERT_VAL("wrong group_idx", evsel__group_idx(evsel) == 0);
-			TEST_ASSERT_EVSEL("unexpected event",
-					evsel__match(evsel, HARDWARE, HW_CPU_CYCLES),
-					evsel);
-		} else {
-			TEST_ASSERT_VAL("wrong config2", 0 == evsel->core.attr.config2);
-			TEST_ASSERT_VAL("wrong leader", !evsel__is_group_leader(evsel));
-			TEST_ASSERT_VAL("wrong core.nr_members", evsel->core.nr_members == 0);
-			TEST_ASSERT_VAL("wrong group_idx", evsel__group_idx(evsel) == 1);
-			TEST_ASSERT_EVSEL("unexpected event",
-					evsel__match(evsel, HARDWARE, HW_INSTRUCTIONS),
-					evsel);
+	evlist__for_each_entry(evlist, evsel) {
+		if (evsel != evsel__leader(evsel) ||
+		    !perf_pmu__has_format(evsel->pmu, "acr_mask")) {
+			continue;
 		}
+		leader = evsel;
+		/* cycles */
+		TEST_ASSERT_VAL("wrong config2", 0 == leader->core.attr.config2);
+		TEST_ASSERT_VAL("wrong core.nr_members", leader->core.nr_members == 2);
+		TEST_ASSERT_VAL("wrong group_idx", evsel__group_idx(leader) == 0);
+		TEST_ASSERT_EVSEL("unexpected event",
+				  evsel__match(leader, HARDWARE, HW_CPU_CYCLES),
+				  leader);
+		/*
+		 * The period value gets configured within evlist__config,
+		 * while this test executes only parse events method.
+		 */
+		TEST_ASSERT_VAL("wrong period", 0 == leader->core.attr.sample_period);
+
+		 /* instructions/period=200000,ratio-to-prev=2.0/ */
+		evsel = evsel__next(evsel);
+		TEST_ASSERT_VAL("wrong config2", 0 == evsel->core.attr.config2);
+		TEST_ASSERT_VAL("wrong leader", evsel__has_leader(evsel, leader));
+		TEST_ASSERT_VAL("wrong core.nr_members", evsel->core.nr_members == 0);
+		TEST_ASSERT_VAL("wrong group_idx", evsel__group_idx(evsel) == 1);
+		TEST_ASSERT_EVSEL("unexpected event",
+				  evsel__match(evsel, HARDWARE, HW_INSTRUCTIONS),
+				  evsel);
 		/*
 		 * The period value gets configured within evlist__config,
 		 * while this test executes only parse events method.
-- 
2.53.0



