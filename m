Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506A53F2101;
	Tue, 21 Jul 2026 18:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660149; cv=none; b=qZy/cEt3O0iWRLoDVxiBKxep5hSnlLounYu22Hv7LfS8IQsdp824/PsaO9Jb+OhAPI0Gk1RNA0BRBBO6CHNqn3MidEurh+hsg0M9bYxksm6n8vdxpqhKiA45KGbIhwIfI0a+vVfg6aHjhwuEWWCENp9lPXCNq/a9gAtPpWitjUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660149; c=relaxed/simple;
	bh=bNSKUDvl+qjBSLTNCvEt/scT4FmrkOns5TeSUwUolSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqsHTIJsYpiZJrKvFmTiWNrsejE2SdDuQFhj1U31LfeyVAINKGHOZQh0uVW2MBVUaU07iVQKM9kffSztywKcI/OlbbT/cvZfdKTVinQ+usHI4KDdXMl2fY5Yr+UX/ATbMSZtyrWNZ56TcK6rGxUcMvezcgnZRYqy7ZMOXMI8yjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veh4lPCU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veh4lPCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2F81F00A3A;
	Tue, 21 Jul 2026 18:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660148;
	bh=khU1qHO+Mf7hfPakPE42j7W3D4FUpY7evsShmwn0AYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veh4lPCU0IsZ/daccHzFNuo1m8E31BVOz2yIn87mCSLKX+69IKEvyM+TeF11TQs7K
	 op8Cwz0MWtt7R5OxC4g1mC+hAQCr19pMFfwwFfzbDuIFBeRG3u6eWFbKMTEBuqY8nJ
	 JGHC7x/LTdr+VJgIlRewqo0YZZBa+GiRvsNjJzwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0868/2077] perf pmu-events AMD: Switch l2_itlb_misses to bp_l1_tlb_miss_l2_tlb_miss.all
Date: Tue, 21 Jul 2026 17:09:01 +0200
Message-ID: <20260721152613.263601923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 41a543c86d110073275e5294852d692e5faf6b3b ]

l2_itlb_misses is a valid legacy cache event name, hence allowing it
in all_events in metric.py. l2_itlb_misses was also a json event for
AMD zen1, zen2 and zen3.

For zen4, zen5 and zen6 the checking that metric events are within the
json was skipping l2_itlb_misses as it is a valid legacy event, however,
the PMU driver lacks the event mapping causing it to be a bad event when
used in the metric.

Add bp_l1_tlb_miss_l2_tlb_miss.all as the l2 itlb miss event (bp =
branch predictor, the AMD way to say itlb), so that is used in
preference to l2_itlb_misses when the event exists.

Remove l2_itlb_misses from metric.py as the legacy event isn't used by
any metrics and having it is error prone for newer AMD zen models.

Fixes: e596f329668ec2b5 ("perf jevents: Add itlb metric group for AMD")
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/amd_metrics.py | 2 +-
 tools/perf/pmu-events/metric.py      | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/pmu-events/amd_metrics.py b/tools/perf/pmu-events/amd_metrics.py
index e2defaffde3e6b..971f6e7af1f828 100755
--- a/tools/perf/pmu-events/amd_metrics.py
+++ b/tools/perf/pmu-events/amd_metrics.py
@@ -268,7 +268,7 @@ def AmdDtlb() -> Optional[MetricGroup]:
 def AmdItlb():
     global _zen_model
     l2h = Event("bp_l1_tlb_miss_l2_tlb_hit", "bp_l1_tlb_miss_l2_hit")
-    l2m = Event("l2_itlb_misses")
+    l2m = Event("bp_l1_tlb_miss_l2_tlb_miss.all", "l2_itlb_misses",)
     l2r = l2h + l2m
 
     itlb_l1_mg = None
diff --git a/tools/perf/pmu-events/metric.py b/tools/perf/pmu-events/metric.py
index 585454828c2fe9..ac582db785fc10 100644
--- a/tools/perf/pmu-events/metric.py
+++ b/tools/perf/pmu-events/metric.py
@@ -25,7 +25,6 @@ def LoadEvents(directory: str) -> None:
       "cycles",
       "duration_time",
       "instructions",
-      "l2_itlb_misses",
   }
   for file in os.listdir(os.fsencode(directory)):
     filename = os.fsdecode(file)
-- 
2.53.0



