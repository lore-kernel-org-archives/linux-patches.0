Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C195B196C8C;
	Thu,  6 Jun 2024 14:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682955; cv=none; b=qA+/ve2sgFoe8vvwSW05he4mLYN1hqSsx5Vf8Z0yxDAjAyW77b5eqmOqT5QzDUJOihAImgzzhDnbmA3O2EVGK3scCTFs1V3Utvrm4ZLLR7rF132AqOct6Wsp/3fwh6YtjolEkmhxU882g3xg+3YKYicgB9QUM2QQ/n28xIfzylA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682955; c=relaxed/simple;
	bh=DKsPLVAuv+WdICCIgEI7IXVGAsBluuHyTHZLYvBdgdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwccz9qHg6xUcL/03WAHCZnv/UgV5IYf1S5WqEtrcR5jYKzlrGTxYpQUHVKB/R9pbOUz+/f1Q9vwpKm3fYlBHvEDqjIkg1samJbcpJkeknh6vm9yEOSbkTpS1NTedsxKFk3mIImGKVwIXxX5J7Y2S41FfcXYkhCSVRF4pexTKwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOoU/2uI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOoU/2uI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD6DC2BD10;
	Thu,  6 Jun 2024 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682955;
	bh=DKsPLVAuv+WdICCIgEI7IXVGAsBluuHyTHZLYvBdgdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOoU/2uIzRMJANDES/ifyFZprjPbtyhYc2K+U+ZsqC1bk9GkLEPi6K7z6R13NgmYU
	 Q04dJvGEwt26Wuz7bKjuxULDlz3Jc2pAacfeq2SnYc3I1KOSPR9GwFcuGIACOs49XZ
	 1laBygW6vrdbtm7O0VXMP4dyrM64x4IJzuzBUcQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 122/374] perf tools: Use pmus to describe type from attribute
Date: Thu,  6 Jun 2024 16:01:41 +0200
Message-ID: <20240606131656.002910566@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 7093882067e2e2f88d3449c35c5f0f3f566c8a26 ]

When dumping a perf_event_attr, use pmus to find the PMU and its name
by the type number. This allows dynamically added PMUs to be described.

Before:

  $ perf stat -vv -e data_read true
  ...
  perf_event_attr:
    type                             24
    size                             136
    config                           0x20ff
    sample_type                      IDENTIFIER
    read_format                      TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING
    disabled                         1
    inherit                          1
    exclude_guest                    1
  ...

After:

  $ perf stat -vv -e data_read true
  ...
  perf_event_attr:
    type                             24 (uncore_imc_free_running_0)
    size                             136
    config                           0x20ff
    sample_type                      IDENTIFIER
    read_format                      TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING
    disabled                         1
    inherit                          1
    exclude_guest                    1
  ...

However, it also means that when we have a PMU name we prefer it to a
hard coded name:

Before:

  $ perf stat -vv -e faults true
  ...
  perf_event_attr:
    type                             1 (PERF_TYPE_SOFTWARE)
    size                             136
    config                           0x2 (PERF_COUNT_SW_PAGE_FAULTS)
    sample_type                      IDENTIFIER
    read_format                      TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING
    disabled                         1
    inherit                          1
    enable_on_exec                   1
    exclude_guest                    1
  ...

After:

  $ perf stat -vv -e faults true
  ...
  perf_event_attr:
    type                             1 (software)
    size                             136
    config                           0x2 (PERF_COUNT_SW_PAGE_FAULTS)
    sample_type                      IDENTIFIER
    read_format                      TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING
    disabled                         1
    inherit                          1
    enable_on_exec                   1
    exclude_guest                    1
  ...

It feels more consistent to do this, rather than only prefer a PMU
name when a hard coded name isn't available.

Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20240308001915.4060155-6-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: d9c5f5f94c2d ("perf pmu: Count sys and cpuid JSON events separately")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/perf_event_attr_fprintf.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/perf_event_attr_fprintf.c b/tools/perf/util/perf_event_attr_fprintf.c
index 8f04d3b7f3ec7..29e66835da3a7 100644
--- a/tools/perf/util/perf_event_attr_fprintf.c
+++ b/tools/perf/util/perf_event_attr_fprintf.c
@@ -7,6 +7,8 @@
 #include <linux/types.h>
 #include <linux/perf_event.h>
 #include "util/evsel_fprintf.h"
+#include "util/pmu.h"
+#include "util/pmus.h"
 #include "trace-event.h"
 
 struct bit_names {
@@ -75,9 +77,12 @@ static void __p_read_format(char *buf, size_t size, u64 value)
 }
 
 #define ENUM_ID_TO_STR_CASE(x) case x: return (#x);
-static const char *stringify_perf_type_id(u64 value)
+static const char *stringify_perf_type_id(struct perf_pmu *pmu, u32 type)
 {
-	switch (value) {
+	if (pmu)
+		return pmu->name;
+
+	switch (type) {
 	ENUM_ID_TO_STR_CASE(PERF_TYPE_HARDWARE)
 	ENUM_ID_TO_STR_CASE(PERF_TYPE_SOFTWARE)
 	ENUM_ID_TO_STR_CASE(PERF_TYPE_TRACEPOINT)
@@ -175,9 +180,9 @@ do {								\
 #define print_id_unsigned(_s)	PRINT_ID(_s, "%"PRIu64)
 #define print_id_hex(_s)	PRINT_ID(_s, "%#"PRIx64)
 
-static void __p_type_id(char *buf, size_t size, u64 value)
+static void __p_type_id(struct perf_pmu *pmu, char *buf, size_t size, u64 value)
 {
-	print_id_unsigned(stringify_perf_type_id(value));
+	print_id_unsigned(stringify_perf_type_id(pmu, value));
 }
 
 static void __p_config_hw_id(char *buf, size_t size, u64 value)
@@ -246,7 +251,7 @@ static void __p_config_id(char *buf, size_t size, u32 type, u64 value)
 #define p_sample_type(val)	__p_sample_type(buf, BUF_SIZE, val)
 #define p_branch_sample_type(val) __p_branch_sample_type(buf, BUF_SIZE, val)
 #define p_read_format(val)	__p_read_format(buf, BUF_SIZE, val)
-#define p_type_id(val)		__p_type_id(buf, BUF_SIZE, val)
+#define p_type_id(val)		__p_type_id(pmu, buf, BUF_SIZE, val)
 #define p_config_id(val)	__p_config_id(buf, BUF_SIZE, attr->type, val)
 
 #define PRINT_ATTRn(_n, _f, _p, _a)			\
@@ -262,6 +267,7 @@ do {							\
 int perf_event_attr__fprintf(FILE *fp, struct perf_event_attr *attr,
 			     attr__fprintf_f attr__fprintf, void *priv)
 {
+	struct perf_pmu *pmu = perf_pmus__find_by_type(attr->type);
 	char buf[BUF_SIZE];
 	int ret = 0;
 
-- 
2.43.0



