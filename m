Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AC24BEE54;
	Sat, 12 Sep 2026 09:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206175; cv=none; b=egnzln7141fdcA7mo6tWtf5jw9Vex0H1EZx9o07LNwse3oBuL7h0o6KVyqPFx2CKjmeb2ipIGgIitGRQh9k6T5vR6EQM+yfaVAKNpfhdHgeHbqGavO7fxi80kWimpIJB6Xumo5p2k24ulnr5n1qoouIE3byEYaexUCg+BxIZ9LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206175; c=relaxed/simple;
	bh=10ztC1hDn4pGY9o7Ye0hnTEDk9/Z+tqmEa4bSZ/+9Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJanjJ7kwj+jI86P+vueofuKVN/I5vJJAx3CFLai2klxqwwPeAJawgtRVAwFunsuxZCU3YtOqkrgf1hEl5h7A5lT13wxWRzhzwBF/klyjSVMMvP6u752PjVIirpusqMr7EIfmu9ikIsRw/oJJ+oWtLSVmiTB2o/384AgYRVQQrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmocFzZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmocFzZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACA51F000FF;
	Sat, 12 Sep 2026 09:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206173;
	bh=/M4jenSwMhCNwGgk6PSq4Ce6P1afLnKIWblqxvl9GIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmocFzZtg6OqiODql4FqlT2P5BFQ0dv0Y42XOusH1qVpRl3kDzDeQIAullLHChgy5
	 Wgy5iVgkBcZP5qzZ+NNLThX7ZrIJqDnQf1RKtU5ctkdfbJ5WOl5dcWGxrmeIDwNajI
	 Msn/7PLeUnu2zVB1Po8v/Ra9KPK3vlP2EK3fXmXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0154/1518] perf test: Truncate printed test descriptions dynamically to avoid terminal wrapping
Date: Sat, 12 Sep 2026 08:38:43 +0200
Message-ID: <20260912065626.976720981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 9e3fcab6fbecebbcffeafeb5db612a57688cb7f4 ]

When test descriptions are extremely long (e.g., the truncated perf.data
graceful handling test is 103 characters long), they wrap across terminal
boundaries.

Because the ANSI escape code to delete the line (PERF_COLOR_DELETE_LINE)
only clears a single terminal line, visual wrapping leaves orphan
wrapped lines on the screen, which results in the test description being
printed multiple times.

Resolve this by checking the terminal width (get_term_dimensions) and
dynamically truncating the printed test description to fit within the
available columns, leaving safety space for the prefix index and status
suffix.

Also, remove the width padding from the test suite headers which do not
display inline status messages. This prevents their trailing colons from
wrapping onto new lines on standard width terminals.

Finally, avoid GCC 16's -Wformat-truncation warnings by delegating the
description padding to pr_info's %-*s format specifier instead of padding
within a temporary buffer, and clamp the truncation limit to the temporary
buffer's size.

JUnit XML output and the failure summary report still print the full,
untruncated test descriptions.

Assisted-by: Gemini-CLI:Google Gemini 3.1 Pro
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 32e6312f7e39 ("perf test: Truncate test description to fit terminal width")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 66 +++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 7 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 9f262a4c93a22..8b98b352aa3b8 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -20,6 +20,8 @@
 #include <sys/wait.h>
 #include <sys/stat.h>
 #include <sys/time.h>
+#include <sys/ioctl.h>
+#include "util/term.h"
 #include "builtin.h"
 #include "config.h"
 #include "hist.h"
@@ -396,19 +398,69 @@ static char *xml_escape(const char *str)
 	return res ? res : strdup("");
 }
 
+static const char *format_test_description(const char *desc, int max_desc_width,
+					  char *buf, size_t buf_sz)
+{
+	int len = strlen(desc);
+
+	/*
+	 * Clamp to buf_sz to prevent GCC format-truncation warnings
+	 * when terminal width is very large.
+	 */
+	if (max_desc_width >= (int)buf_sz)
+		max_desc_width = buf_sz - 1;
+
+	if (len > max_desc_width) {
+		snprintf(buf, buf_sz, "%.*s...", max_desc_width - 3, desc);
+		return buf;
+	}
+	return desc;
+}
+
 static int print_test_result(struct test_suite *t, int curr_suite, int curr_test_case,
 			     int result, int width, int running,
 			     const char *err_output, double elapsed)
 {
+	char desc_buf[256];
+	const char *desc = test_description(t, curr_test_case);
+	struct winsize ws;
+	int max_desc_area_width;
+	int target_desc_area_width;
+	int desc_padding;
+
+	get_term_dimensions(&ws);
+	/*
+	 * Total terminal columns minus space for status e.g. " Running (12 active)"
+	 * which is 20 chars, plus a margin of 3 chars = 23 chars.
+	 */
+	max_desc_area_width = ws.ws_col - 23;
+	if (max_desc_area_width < 40)
+		max_desc_area_width = 40;
+
+	/* Standard test has prefix "%3d: " which is 5 chars */
+	target_desc_area_width = width + 5;
+	if (target_desc_area_width > max_desc_area_width)
+		target_desc_area_width = max_desc_area_width;
+
 	if (test_suite__num_test_cases(t) > 1) {
 		char prefix[32];
 		int len = snprintf(prefix, sizeof(prefix), "%3d.%1d:",
 				   curr_suite + 1, curr_test_case + 1);
-		int subw = len >= 4 ? width + 4 - len : width;
 
-		pr_info("%s %-*s:", prefix, subw, test_description(t, curr_test_case));
-	} else
-		pr_info("%3d: %-*s:", curr_suite + 1, width, test_description(t, curr_test_case));
+		desc_padding = target_desc_area_width - (len + 1);
+		if (desc_padding < 20)
+			desc_padding = 20;
+
+		desc = format_test_description(desc, desc_padding, desc_buf, sizeof(desc_buf));
+		pr_info("%s %-*s:", prefix, desc_padding, desc);
+	} else {
+		desc_padding = target_desc_area_width - 5;
+		if (desc_padding < 20)
+			desc_padding = 20;
+
+		desc = format_test_description(desc, desc_padding, desc_buf, sizeof(desc_buf));
+		pr_info("%3d: %-*s:", curr_suite + 1, desc_padding, desc);
+	}
 
 	switch (result) {
 	case TEST_RUNNING:
@@ -692,7 +744,7 @@ static void finish_test(struct child_test **child_tests, int running_test, int c
 	 * sub test names.
 	 */
 	if (test_suite__num_test_cases(t) > 1 && curr_test_case == 0)
-		pr_info("%3d: %-*s:\n", curr_suite + 1, width, test_description(t, -1));
+		pr_info("%3d: %s:\n", curr_suite + 1, test_description(t, -1));
 
 	/*
 	 * Busy loop reading from the child's stdout/stderr that are set to be
@@ -968,7 +1020,7 @@ static int finish_tests_parallel(struct child_test **child_tests, size_t num_tes
 			if (next_child) {
 				if (test_suite__num_test_cases(next_child->test) > 1 &&
 				    last_suite_printed != next_child->suite_num) {
-					pr_info("%3d: %-*s:\n", next_child->suite_num + 1, width,
+					pr_info("%3d: %s:\n", next_child->suite_num + 1,
 						test_description(next_child->test, -1));
 					last_suite_printed = next_child->suite_num;
 				}
@@ -1032,7 +1084,7 @@ static int finish_tests_parallel(struct child_test **child_tests, size_t num_tes
 
 			if (test_suite__num_test_cases(child->test) > 1 &&
 			    last_suite_printed != child->suite_num) {
-				pr_info("%3d: %-*s:\n", child->suite_num + 1, width,
+				pr_info("%3d: %s:\n", child->suite_num + 1,
 					test_description(child->test, -1));
 				last_suite_printed = child->suite_num;
 			}
-- 
2.53.0



