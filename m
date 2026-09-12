Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16A84BEE54;
	Sat, 12 Sep 2026 09:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206163; cv=none; b=ZxuOdoRoPp/+QOGMBdXTu+8qcyahQX8vQWn12tV4hX4h1b3GWpG15Act1/jqfnRHgwIM5TBrUtqUymYfaNH9pxug21miARZ9i7mv3k8jVHR07pqQmjqWz4iEvZ2SBeEzc7rWV5/tq02o9Wz7fy1Fnbus7oEiY+S959uwAvgvw5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206163; c=relaxed/simple;
	bh=eqURXMQ3dmPYZn1zyiAeKQzmXUD65y4YN3qynEISnKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qby8/FpuwtXp7jTHSVytMqP+YvIPU8/wfz0IEgG90+o1bDzRgS4GNKJL3aOHPQh3EOLVYDIth5EA3Pw5l90l4rusgoA02vvySxu34Y3luWmTLhlzWsOMCg9Ma/dlXmy+s+yNrFYTzOXN6k8myGtxLidRo2V6WhYsSyjGIjPYPNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUutiDan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUutiDan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CE61F000FF;
	Sat, 12 Sep 2026 09:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206161;
	bh=e4Yacp57xAd3AIZrJdo+p+8mVWoKIxZMOssFBHoinIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUutiDanJJuQTZQs8zSRFs3dgtYLqLevVmpzuYHw5Aq5wAhr/xpbrAseq8MbHLJjY
	 S71siJxFP6picd4cJOH5qlwLjuv30G9O6M3/cL2ElheeqGjFAIQiDRnPNpdZWJqrpd
	 ZZ7LSOj9V/M1u1HlriVeF1NX/RE/s3w5DnpJPHzI=
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
Subject: [PATCH 6.18 0151/1518] perf test: Add summary reporting
Date: Sat, 12 Sep 2026 08:38:40 +0200
Message-ID: <20260912065626.908571079@linuxfoundation.org>
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

[ Upstream commit 33f20342ba525ef75fd9734db71e9823fe65e769 ]

Currently, when running test suites (perf test), users must scroll
through hundreds of lines of console output to manually tally the number
of passed, skipped, or failed test cases.

Introduce an automated, global execution summary printed at the absolute
tail of the test run:

1. Track counts mid-flight inside the print_test_result() accumulator,
   clearly separating pass counts into standalone main tests vs.
   individual subtests (where num_test_cases > 1).

2. Accumulate the precise descriptions of all failed test cases
   directly into a global string buffer, formatted with their suite
   indices (e.g., 3.1: Parse event definition strings) for effortless
   cross-referencing.

3. Define a summary printer function print_tests_summary() that
   emits a colored outline of the final pass, skip, and fail totals,
   followed by the explicit list of failed tests.

4. Invoke the summary printer right before freeing the test array at
   the absolute tail of __cmd_test(), guaranteeing that the summary is
   successfully printed even if an internal emergency signal cleanup
   occurs or if the user interrupts the run early.

Example output:
```
$ sudo perf test -v
  1: vmlinux symtab matches kallsyms                                 : Skip
  2: Detect openat syscall event                                     : Ok
  3: Detect openat syscall event on all cpus                         : Ok
...
163: perf trace summary                                              : Ok

=== Test Summary ===
Passed main tests : 123
Passed subtests   : 145
Skipped tests     : 22
Failed tests      : 6
List of failed tests:
   92: perf kvm tests
   95: kernel lock contention analysis test
  120: perf metrics value validation
  124: Check branch stack sampling
  143: perftool-testsuite_probe
  158: test Intel TPEBS counting mode
```

Assisted-by: Gemini-CLI:Google Gemini 3
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
 tools/perf/tests/builtin-test.c | 89 +++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 626d1b328b2f2..13c4dfa5d512a 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -356,8 +356,14 @@ static int run_test_child(struct child_process *process)
 
 static struct pollfd *global_pfds;
 static size_t *global_pfd_indices;
+static unsigned int summary_tests_passed;
+static unsigned int summary_subtests_passed;
+static unsigned int summary_tests_skipped;
+static unsigned int summary_tests_failed;
+static struct strbuf summary_failed_tests_buf = STRBUF_INIT;
 
 static int strbuf_addstr_safe(struct strbuf *sb, const char *s);
+static int __printf(2, 3) strbuf_addf_safe(struct strbuf *sb, const char *fmt, ...);
 
 static int print_test_result(struct test_suite *t, int curr_suite, int curr_test_case,
 			     int result, int width, int running)
@@ -375,11 +381,16 @@ static int print_test_result(struct test_suite *t, int curr_suite, int curr_test
 		color_fprintf(stderr, PERF_COLOR_YELLOW, " Running (%d active)\n", running);
 		break;
 	case TEST_OK:
+		if (test_suite__num_test_cases(t) > 1)
+			summary_subtests_passed++;
+		else
+			summary_tests_passed++;
 		pr_info(" Ok\n");
 		break;
 	case TEST_SKIP: {
 		const char *reason = skip_reason(t, curr_test_case);
 
+		summary_tests_skipped++;
 		if (reason)
 			color_fprintf(stderr, PERF_COLOR_YELLOW, " Skip (%s)\n", reason);
 		else
@@ -388,6 +399,15 @@ static int print_test_result(struct test_suite *t, int curr_suite, int curr_test
 		break;
 	case TEST_FAIL:
 	default:
+		summary_tests_failed++;
+		if (test_suite__num_test_cases(t) > 1)
+			strbuf_addf_safe(&summary_failed_tests_buf, "  %3d.%1d: %s\n",
+				    curr_suite + 1, curr_test_case + 1,
+				    test_description(t, curr_test_case));
+		else
+			strbuf_addf_safe(&summary_failed_tests_buf, "  %3d: %s\n",
+				    curr_suite + 1,
+				    test_description(t, curr_test_case));
 		color_fprintf(stderr, PERF_COLOR_RED, " FAILED!\n");
 		break;
 	}
@@ -729,6 +749,47 @@ static int strbuf_addstr_safe(struct strbuf *sb, const char *s)
 	return ret;
 }
 
+static int __printf(2, 3) strbuf_addf_safe(struct strbuf *sb, const char *fmt, ...)
+{
+	char buf[1024];
+	va_list ap;
+	int len;
+	sigset_t set, oldset;
+	int ret;
+
+	sigemptyset(&set);
+	sigaddset(&set, SIGINT);
+	sigaddset(&set, SIGTERM);
+	sigprocmask(SIG_BLOCK, &set, &oldset);
+
+	va_start(ap, fmt);
+	len = vsnprintf(buf, sizeof(buf), fmt, ap);
+	va_end(ap);
+
+	if (len < 0) {
+		sigprocmask(SIG_SETMASK, &oldset, NULL);
+		return len;
+	}
+	if ((size_t)len >= sizeof(buf)) {
+		char *dynamic_buf = malloc(len + 1);
+
+		if (!dynamic_buf) {
+			sigprocmask(SIG_SETMASK, &oldset, NULL);
+			return -ENOMEM;
+		}
+		va_start(ap, fmt);
+		vsnprintf(dynamic_buf, len + 1, fmt, ap);
+		va_end(ap);
+		ret = strbuf_addstr(sb, dynamic_buf);
+		free(dynamic_buf);
+	} else {
+		ret = strbuf_addstr(sb, buf);
+	}
+
+	sigprocmask(SIG_SETMASK, &oldset, NULL);
+	return ret;
+}
+
 static void drain_child_process_err(struct child_test *child)
 {
 	char buf[512];
@@ -1006,6 +1067,23 @@ static void cmd_test_sig_handler(int sig)
 	siglongjmp(cmd_test_jmp_buf, sig);
 }
 
+static void print_tests_summary(void)
+{
+	pr_info("\n=== Test Summary ===\n");
+	pr_info("Passed main tests : %u\n", summary_tests_passed);
+	pr_info("Passed subtests   : %u\n", summary_subtests_passed);
+	pr_info("Skipped tests     : %u\n", summary_tests_skipped);
+	if (summary_tests_failed > 0) {
+		color_fprintf(stderr, PERF_COLOR_RED, "Failed tests      : %u\n",
+			      summary_tests_failed);
+		pr_info("List of failed tests:\n");
+		pr_info("%s", summary_failed_tests_buf.buf);
+	} else {
+		color_fprintf(stderr, PERF_COLOR_GREEN, "Failed tests      : 0\n");
+	}
+	strbuf_release(&summary_failed_tests_buf);
+}
+
 static int __cmd_test(struct test_suite **suites, int argc, const char *argv[],
 		      struct intlist *skiplist)
 {
@@ -1083,9 +1161,13 @@ static int __cmd_test(struct test_suite **suites, int argc, const char *argv[],
 			}
 
 			if (intlist__find(skiplist, curr_suite + 1)) {
-				pr_info("%3d: %-*s:", curr_suite + 1, width,
-					test_description(*t, -1));
-				color_fprintf(stderr, PERF_COLOR_YELLOW, " Skip (user override)\n");
+				if (pass == 1) {
+					pr_info("%3d: %-*s:", curr_suite + 1, width,
+						test_description(*t, -1));
+					color_fprintf(stderr, PERF_COLOR_YELLOW,
+						      " Skip (user override)\n");
+					summary_tests_skipped++;
+				}
 				continue;
 			}
 
@@ -1118,6 +1200,7 @@ static int __cmd_test(struct test_suite **suites, int argc, const char *argv[],
 		for (size_t x = 0; x < num_tests; x++)
 			finish_test(child_tests, x, num_tests, width);
 	}
+	print_tests_summary();
 	free(global_pfds);
 	free(global_pfd_indices);
 	global_pfds = NULL;
-- 
2.53.0



