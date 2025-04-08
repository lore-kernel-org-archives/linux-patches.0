Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B3821ADAE;
	Tue,  8 Apr 2025 11:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111464; cv=none; b=csj5WripmFgIw3IPyT94qp3XI86+foO+grEsaHaWZKiVfO3IJ87MYoRVN8Z37mPq00m9sA/Z5buRp3Bb49Wxz2GT+On5sFJV7QoGbKExdkLbrr/Acy/zP3qMA9NY+dtmkz7tj8+KlScXF3xc5W0FtSk1Jl0eHzppyziO53A+ZHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111464; c=relaxed/simple;
	bh=So2z2ChnrPwVZItLgq1QymeDb/TVSH2HNyoT8v6NCXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt62kK6gzadldL1UpV7J4tvwx6cvfGtfYSGwiG6uwho7IJDom41NPmwgpxTC/YkdJo1T1+P14ol0SecWWCoaamSaNReVQa16yvrAkAL8PRQWqXAqE5TLSxSDjiyaR3KRK41JjWzwq29866wlhL6wZKQOl699+6onZolki0XPptI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxxpsmrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxxpsmrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C95C4CEE5;
	Tue,  8 Apr 2025 11:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111464;
	bh=So2z2ChnrPwVZItLgq1QymeDb/TVSH2HNyoT8v6NCXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxxpsmrYSx7Ef/1DUpbmnrzGa4lF0eYeG+RvQcchHgBzhCigByzgXUoOs0z6D1gRX
	 LAcuGQBrfdaCaZ1QnWCSRB/mmq2oWDfWrpBD3onRtpxRhEKacSjn1Ex6iK0W7RKSs0
	 RQN7CsalLviQh6GAbXkpVg5kOv28720Yipy1RblY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 441/731] perf test: Fix Hwmon PMU test endianess issue
Date: Tue,  8 Apr 2025 12:45:38 +0200
Message-ID: <20250408104924.530417954@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 888751e4d0e948d0364eee6fb47e21f090b2b5e4 ]

perf test 11 hwmon fails on s390 with this error

 # ./perf test -Fv 11
 --- start ---
 ---- end ----
 11.1: Basic parsing test             : Ok
 --- start ---
 Testing 'temp_test_hwmon_event1'
 Using CPUID IBM,3931,704,A01,3.7,002f
 temp_test_hwmon_event1 -> hwmon_a_test_hwmon_pmu/temp_test_hwmon_event1/
 FAILED tests/hwmon_pmu.c:189 Unexpected config for
    'temp_test_hwmon_event1', 292470092988416 != 655361
 ---- end ----
 11.2: Parsing without PMU name       : FAILED!
 --- start ---
 Testing 'hwmon_a_test_hwmon_pmu/temp_test_hwmon_event1/'
 FAILED tests/hwmon_pmu.c:189 Unexpected config for
    'hwmon_a_test_hwmon_pmu/temp_test_hwmon_event1/',
    292470092988416 != 655361
 ---- end ----
 11.3: Parsing with PMU name          : FAILED!
 #

The root cause is in member test_event::config which is initialized
to 0xA0001 or 655361. During event parsing a long list event parsing
functions are called and end up with this gdb call stack:

 #0  hwmon_pmu__config_term (hwm=0x168dfd0, attr=0x3ffffff5ee8,
	term=0x168db60, err=0x3ffffff81c8) at util/hwmon_pmu.c:623
 #1  hwmon_pmu__config_terms (pmu=0x168dfd0, attr=0x3ffffff5ee8,
	terms=0x3ffffff5ea8, err=0x3ffffff81c8) at util/hwmon_pmu.c:662
 #2  0x00000000012f870c in perf_pmu__config_terms (pmu=0x168dfd0,
	attr=0x3ffffff5ee8, terms=0x3ffffff5ea8, zero=false,
	apply_hardcoded=false, err=0x3ffffff81c8) at util/pmu.c:1519
 #3  0x00000000012f88a4 in perf_pmu__config (pmu=0x168dfd0, attr=0x3ffffff5ee8,
	head_terms=0x3ffffff5ea8, apply_hardcoded=false, err=0x3ffffff81c8)
	at util/pmu.c:1545
 #4  0x00000000012680c4 in parse_events_add_pmu (parse_state=0x3ffffff7fb8,
	list=0x168dc00, pmu=0x168dfd0, const_parsed_terms=0x3ffffff6090,
	auto_merge_stats=true, alternate_hw_config=10)
	at util/parse-events.c:1508
 #5  0x00000000012684c6 in parse_events_multi_pmu_add (parse_state=0x3ffffff7fb8,
	event_name=0x168ec10 "temp_test_hwmon_event1", hw_config=10,
	const_parsed_terms=0x0, listp=0x3ffffff6230, loc_=0x3ffffff70e0)
	at util/parse-events.c:1592
 #6  0x00000000012f0e4e in parse_events_parse (_parse_state=0x3ffffff7fb8,
	scanner=0x16878c0) at util/parse-events.y:293
 #7  0x00000000012695a0 in parse_events__scanner (str=0x3ffffff81d8
	"temp_test_hwmon_event1", input=0x0, parse_state=0x3ffffff7fb8)
	at util/parse-events.c:1867
 #8  0x000000000126a1e8 in __parse_events (evlist=0x168b580,
	str=0x3ffffff81d8 "temp_test_hwmon_event1", pmu_filter=0x0,
	err=0x3ffffff81c8, fake_pmu=false, warn_if_reordered=true,
	fake_tp=false) at util/parse-events.c:2136
 #9  0x00000000011e36aa in parse_events (evlist=0x168b580,
	str=0x3ffffff81d8 "temp_test_hwmon_event1", err=0x3ffffff81c8)
	at /root/linux/tools/perf/util/parse-events.h:41
 #10 0x00000000011e3e64 in do_test (i=0, with_pmu=false, with_alias=false)
	at tests/hwmon_pmu.c:164
 #11 0x00000000011e422c in test__hwmon_pmu (with_pmu=false)
	at tests/hwmon_pmu.c:219
 #12 0x00000000011e431c in test__hwmon_pmu_without_pmu (test=0x1610368
	<suite.hwmon_pmu>, subtest=1) at tests/hwmon_pmu.c:23

where the attr::config is set to value 292470092988416 or 0x10a0000000000
in line 625 of file ./util/hwmon_pmu.c:

   attr->config = key.type_and_num;

However member key::type_and_num is defined as union and bit field:

   union hwmon_pmu_event_key {
        long type_and_num;
        struct {
                int num :16;
                enum hwmon_type type :8;
        };
   };

s390 is big endian and Intel is little endian architecture.
The events for the hwmon dummy pmu have num = 1 or num = 2 and
type is set to HWMON_TYPE_TEMP (which is 10).
On s390 this assignes member key::type_and_num the value of
0x10a0000000000 (which is 292470092988416) as shown in above
trace output.

Fix this and export the structure/union hwmon_pmu_event_key
so the test shares the same implementation as the event parsing
functions for union and bit fields. This should avoid
endianess issues on all platforms.

Output after:
 # ./perf test -F 11
 11.1: Basic parsing test         : Ok
 11.2: Parsing without PMU name   : Ok
 11.3: Parsing with PMU name      : Ok
 #

Fixes: 531ee0fd4836 ("perf test: Add hwmon "PMU" test")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250131112400.568975-1-tmricht@linux.ibm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/hwmon_pmu.c | 16 +++++++++++-----
 tools/perf/util/hwmon_pmu.c  | 14 --------------
 tools/perf/util/hwmon_pmu.h  | 16 ++++++++++++++++
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/tools/perf/tests/hwmon_pmu.c b/tools/perf/tests/hwmon_pmu.c
index d2b066a2b557a..0837aca1cdfa7 100644
--- a/tools/perf/tests/hwmon_pmu.c
+++ b/tools/perf/tests/hwmon_pmu.c
@@ -13,17 +13,23 @@
 static const struct test_event {
 	const char *name;
 	const char *alias;
-	long config;
+	union hwmon_pmu_event_key key;
 } test_events[] = {
 	{
 		"temp_test_hwmon_event1",
 		"temp1",
-		0xA0001,
+		.key = {
+			.num = 1,
+			.type = 10
+		},
 	},
 	{
 		"temp_test_hwmon_event2",
 		"temp2",
-		0xA0002,
+		.key = {
+			.num = 2,
+			.type = 10
+		},
 	},
 };
 
@@ -183,11 +189,11 @@ static int do_test(size_t i, bool with_pmu, bool with_alias)
 		    strcmp(evsel->pmu->name, "hwmon_a_test_hwmon_pmu"))
 			continue;
 
-		if (evsel->core.attr.config != (u64)test_events[i].config) {
+		if (evsel->core.attr.config != (u64)test_events[i].key.type_and_num) {
 			pr_debug("FAILED %s:%d Unexpected config for '%s', %lld != %ld\n",
 				__FILE__, __LINE__, str,
 				evsel->core.attr.config,
-				test_events[i].config);
+				test_events[i].key.type_and_num);
 			ret = TEST_FAIL;
 			goto out;
 		}
diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index 4acb9bb19b846..acd889b2462f6 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -107,20 +107,6 @@ struct hwmon_pmu {
 	int hwmon_dir_fd;
 };
 
-/**
- * union hwmon_pmu_event_key: Key for hwmon_pmu->events as such each key
- * represents an event.
- *
- * Related hwmon files start <type><number> that this key represents.
- */
-union hwmon_pmu_event_key {
-	long type_and_num;
-	struct {
-		int num :16;
-		enum hwmon_type type :8;
-	};
-};
-
 /**
  * struct hwmon_pmu_event_value: Value in hwmon_pmu->events.
  *
diff --git a/tools/perf/util/hwmon_pmu.h b/tools/perf/util/hwmon_pmu.h
index 882566846df46..b3329774d2b22 100644
--- a/tools/perf/util/hwmon_pmu.h
+++ b/tools/perf/util/hwmon_pmu.h
@@ -91,6 +91,22 @@ enum hwmon_item {
 	HWMON_ITEM__MAX,
 };
 
+/**
+ * union hwmon_pmu_event_key: Key for hwmon_pmu->events as such each key
+ * represents an event.
+ * union is exposed for testing to ensure problems are avoided on big
+ * endian machines.
+ *
+ * Related hwmon files start <type><number> that this key represents.
+ */
+union hwmon_pmu_event_key {
+	long type_and_num;
+	struct {
+		int num :16;
+		enum hwmon_type type :8;
+	};
+};
+
 bool perf_pmu__is_hwmon(const struct perf_pmu *pmu);
 bool evsel__is_hwmon(const struct evsel *evsel);
 
-- 
2.39.5



