Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57154325704
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300902; cv=none; b=MK1v4ydvPIoRqTsDD9uI9I8S2pUw+k46yPrWdLuRTECaZ6pViaVfnWoJxoyH9XZAWXSzFraM5lBlGo+RwMCtAPk4NZB5OwtkAlXeS2hrK0IZma63sO4R+AgH5WyC/PZ2BI9DZYbrJQOiFGfTQtcJzrr6zk/Sq6STMGptA/dOCyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300902; c=relaxed/simple;
	bh=5DLthrwaQ4P8bCT3/l3haLmoSWFTHHexrJJVVVyJFYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+K6wzeLUTIIhs9mBpCSIEN2IjU8gspH5zN4LU10zEyMOPwad60iDNEW4EVKKfvApwRoDAME0jfI09S6lV+cP2l1JPvPK5XRaUd4+RXmV8unuLE452aDafVQRhmRIasoNZpfTRUbpoVP4Qo6wn6+hWe8Qtu+eW8kxAnojDYtGVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nggTXgNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nggTXgNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D52C19423;
	Sat, 28 Feb 2026 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300902;
	bh=5DLthrwaQ4P8bCT3/l3haLmoSWFTHHexrJJVVVyJFYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nggTXgNPnD3O30diUBUl9ipNP1PZDU6yPoeuLuYz5DOl0DktTxzhXNgIUs0Q9kEJA
	 Q707IN81o8msjievAa3dlSl3btI850a5jy6Nyyr9iXTpqXWQD4d2q5sQ5J8MVbIT6C
	 viW4ADbM4tWbLYoTh5v/DXUpQhnSwV/QUFmIlW/RqX5aQrHN739jdbnJmQObIh3tXV
	 atBgFf0GXBa8dgw62+Ecj1mx02U9rDGtLbl1xGrMCHgLyIEQdAtAWRpS6BKCRjWqgD
	 Cx+4hlIpbtESztajOQCn6HIM6iwnxhTOryo5Z2ulVnWaj+WhFZcTGzGCzNtjtycKQS
	 vM5b2VJBmBxGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sandipan Das <sandipan.das@amd.com>,
	Suyash Mahar <smahar@meta.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ananth Narayan <ananth.narayan@amd.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/752] perf vendor events amd: Fix Zen 5 MAB allocation events
Date: Sat, 28 Feb 2026 12:35:28 -0500
Message-ID: <20260228174750.1542406-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 76b2cf07a6d2a836108f9c2486d76599f7adf6e8 ]

The unit masks for PMCx041 vary across different generations of Zen
processors.

Fix the Zen 5 events based on PMCx041 as they incorrectly use the same
unit masks as that of Zen 4.

Fixes: 45c072f2537ab07b ("perf vendor events amd: Add Zen 5 core events")
Reported-by: Suyash Mahar <smahar@meta.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ananth Narayan <ananth.narayan@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/x86/amdzen5/load-store.json | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/pmu-events/arch/x86/amdzen5/load-store.json b/tools/perf/pmu-events/arch/x86/amdzen5/load-store.json
index ff6627a778057..06bbaea159259 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen5/load-store.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen5/load-store.json
@@ -70,19 +70,19 @@
     "EventName": "ls_mab_alloc.load_store_allocations",
     "EventCode": "0x41",
     "BriefDescription": "Miss Address Buffer (MAB) entries allocated by a Load-Store (LS) pipe for load-store allocations.",
-    "UMask": "0x3f"
+    "UMask": "0x07"
   },
   {
     "EventName": "ls_mab_alloc.hardware_prefetcher_allocations",
     "EventCode": "0x41",
     "BriefDescription": "Miss Address Buffer (MAB) entries allocated by a Load-Store (LS) pipe for hardware prefetcher allocations.",
-    "UMask": "0x40"
+    "UMask": "0x08"
   },
   {
     "EventName": "ls_mab_alloc.all_allocations",
     "EventCode": "0x41",
     "BriefDescription": "Miss Address Buffer (MAB) entries allocated by a Load-Store (LS) pipe for all types of allocations.",
-    "UMask": "0x7f"
+    "UMask": "0x0f"
   },
   {
     "EventName": "ls_dmnd_fills_from_sys.local_l2",
-- 
2.51.0

