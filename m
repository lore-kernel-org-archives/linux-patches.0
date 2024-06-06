Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08C2196D90;
	Thu,  6 Jun 2024 14:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683673; cv=none; b=pWj8tNjgc4vVhqZNIV9As83HxN5DmS7uA5s5HP/D93LUEr3AiYV2bejE9TSX7FdcAWC8IE9LK312pRAgqeH51lTNCIO8/kF7fFLA0k7p18x+X+i47tUo+2H05Eykxkb2kp/SmRuajMnCSiYcofYGgOCgpUhU09ZPvnZb9FswAwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683673; c=relaxed/simple;
	bh=24eBEpGK7A/K3/307S74FLVW35OlGz7ECXTQR3etoV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVcqI0nifHs6xrTGZRqeKzw2oTq4jYH1C+HzG2dc4hqjEQVEORrZlaQF/KAsARATI/B51e4I9yMZ/FnIVsWIMCawyP8xCd7A2EIX5nOFav3nvD2HCjT8nCZjyO4j8xakgdt7GpZJwZ3UTaFy/D5xz8vkV+esuxWqUAg9YrTW+G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwU/goFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwU/goFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE44C2BD10;
	Thu,  6 Jun 2024 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683673;
	bh=24eBEpGK7A/K3/307S74FLVW35OlGz7ECXTQR3etoV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwU/goFluCJ9TwbmP+q4o4YNe9Biz5Yy5sVwukOicy4G+icvfVzZ0jJWlI6v5Sfde
	 yyO8MVkaTxlmCYCOist2scC45FhuAuCfKAH6E6gytQptYJztFV9QXUoL81YnSbrWaP
	 592CaS+4mmSkExsyx7aA5Lr8n5J6bJR89ZMWvJ0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Haixin Yu <yuhaixin.yhx@linux.alibaba.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Will Deacon <will@kernel.org>,
	Yang Jihong <yangjihong1@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 525/744] perf test: Add a test for strcmp_cpuid_str() expression
Date: Thu,  6 Jun 2024 16:03:17 +0200
Message-ID: <20240606131749.280299711@linuxfoundation.org>
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

[ Upstream commit a1ebf7718ee31501d2d2ee3af1716e0084c81926 ]

Test that the new expression builtin returns a match when the current
escaped CPU ID is given, and that it doesn't match when "0x0" is given.

The CPU ID in test__expr() has to be changed to perf_pmu__getcpuid()
which returns the CPU ID string, rather than the raw CPU ID that
get_cpuid() returns because that can't be used with strcmp_cpuid_str().
It doesn't affect the is_intel test because both versions contain
"Intel".

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Chen Zhongjin <chenzhongjin@huawei.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Haixin Yu <yuhaixin.yhx@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jing Zhang <renyu.zj@linux.alibaba.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Jihong <yangjihong1@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20230904095104.1162928-5-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: d9c5f5f94c2d ("perf pmu: Count sys and cpuid JSON events separately")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/expr.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/expr.c b/tools/perf/tests/expr.c
index 81229fa4f1e96..b177d09078038 100644
--- a/tools/perf/tests/expr.c
+++ b/tools/perf/tests/expr.c
@@ -9,6 +9,7 @@
 #include <math.h>
 #include <stdlib.h>
 #include <string.h>
+#include <string2.h>
 #include <linux/zalloc.h>
 
 static int test_ids_union(void)
@@ -74,10 +75,13 @@ static int test__expr(struct test_suite *t __maybe_unused, int subtest __maybe_u
 	int ret;
 	struct expr_parse_ctx *ctx;
 	bool is_intel = false;
-	char buf[128];
+	char strcmp_cpuid_buf[256];
+	struct perf_pmu *pmu = pmu__find_core_pmu();
+	char *cpuid = perf_pmu__getcpuid(pmu);
+	char *escaped_cpuid1, *escaped_cpuid2;
 
-	if (!get_cpuid(buf, sizeof(buf)))
-		is_intel = strstr(buf, "Intel") != NULL;
+	TEST_ASSERT_VAL("get_cpuid", cpuid);
+	is_intel = strstr(cpuid, "Intel") != NULL;
 
 	TEST_ASSERT_EQUAL("ids_union", test_ids_union(), 0);
 
@@ -257,9 +261,28 @@ static int test__expr(struct test_suite *t __maybe_unused, int subtest __maybe_u
 	TEST_ASSERT_VAL("source count", hashmap__size(ctx->ids) == 1);
 	TEST_ASSERT_VAL("source count", hashmap__find(ctx->ids, "EVENT1", &val_ptr));
 
+
+	/* Test no cpuid match */
+	ret = test(ctx, "strcmp_cpuid_str(0x0)", 0);
+
+	/*
+	 * Test cpuid match with current cpuid. Special chars have to be
+	 * escaped.
+	 */
+	escaped_cpuid1 = strreplace_chars('-', cpuid, "\\-");
+	free(cpuid);
+	escaped_cpuid2 = strreplace_chars(',', escaped_cpuid1, "\\,");
+	free(escaped_cpuid1);
+	escaped_cpuid1 = strreplace_chars('=', escaped_cpuid2, "\\=");
+	free(escaped_cpuid2);
+	scnprintf(strcmp_cpuid_buf, sizeof(strcmp_cpuid_buf),
+		  "strcmp_cpuid_str(%s)", escaped_cpuid1);
+	free(escaped_cpuid1);
+	ret |= test(ctx, strcmp_cpuid_buf, 1);
+
 	/* has_event returns 1 when an event exists. */
 	expr__add_id_val(ctx, strdup("cycles"), 2);
-	ret = test(ctx, "has_event(cycles)", 1);
+	ret |= test(ctx, "has_event(cycles)", 1);
 
 	expr__ctx_free(ctx);
 
-- 
2.43.0



