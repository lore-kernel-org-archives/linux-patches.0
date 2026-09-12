Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D083DB31A;
	Sat, 12 Sep 2026 12:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217784; cv=none; b=gymytZb23H0BPB/X2nLKQvXXB+5S+koLs6uzUe1DcFen47/fz/3Tw67wB1Nyht6OQ1S9ghSNXJZdGc+mkCC4EaDsXUuW1Pdt6dq91L0SOYSmBDtBtOPKMrwRX5NUOiKU4lmPCB1c9H64rheiwxohATBM0Zg/fuOc773klshzA5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217784; c=relaxed/simple;
	bh=2LM9PrwtF6/ZmFZEVmNpdSXhZreFR05QQyiLjosg7PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFZ20EMpngkHBssPGHOv/4P7b6MavGH/o2fsjHRbtiOMq1QXmWBtyO4Fp1gslPb947qpgv4J/+xnWkfexUvCRzrXO8jjziO3fYeqCYef6VulRFJywhmMM91Y1QMidO6pFbflw3D9mTaZkL/VB4yJWNVMBjodt1UviXadh2gIjis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsxmxBFM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsxmxBFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DB11F000FF;
	Sat, 12 Sep 2026 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217783;
	bh=Fv3BcjUfI8FcwQ/fwMhmtotXjshX6BE8h48ut4EIokw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsxmxBFMFkBsDXxRVLDNvCirDsoqF8Y3ihTh0aS5IKuiTzM5NFlKsPGYFrP4i0ByH
	 lGTM21PWV59bTezKPi1zTDrbsWzS2uinHc2XKVikKSXP/tZ5lV3HOhhKub7wqzPWiU
	 ARIUwrVPxK1AHLeX/r21i9xvqst1k4N4nHyfmRbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Howard Chu <howardchu95@gmail.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Andi Kleen <ak@linux.intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1009/1376] perf test: Display number of active running tests
Date: Sat, 12 Sep 2026 08:57:15 +0200
Message-ID: <20260912065630.052286725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 0e036dcad4e62b89f8df3e41402babb9345521af ]

Before polling or sleeping to wait for a test to complete, print out
": Running (<num> active)" where the number of active tests is
determined by iterating over the tests and seeing which return false
for check_if_command_finished. The line erasing and printing out only
occur if the number of runnings tests changes to avoid the line
flickering excessively. Knowing tests are running allows a user to
know a test is running and in parallel mode how many of the tests are
waiting to complete. If color mode is disabled then avoid displaying
the "Running" message as deleting the line isn't reliable.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Weilin Wang <weilin.wang@intel.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Veronika Molnarova <vmolnaro@redhat.com>
Link: https://lore.kernel.org/r/20241025192109.132482-3-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 44e82c4d2ff3 ("perf test: Fix skiplist leak in cmd_test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 93 ++++++++++++++++++++++-----------
 tools/perf/util/color.h         |  1 +
 2 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 4f2f941bd1feb..3b6743a3232c1 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -246,7 +246,10 @@ static int run_test_child(struct child_process *process)
 	return -err;
 }
 
-static int print_test_result(struct test_suite *t, int i, int subtest, int result, int width)
+#define TEST_RUNNING -3
+
+static int print_test_result(struct test_suite *t, int i, int subtest, int result, int width,
+			     int running)
 {
 	if (has_subtests(t)) {
 		int subw = width > 2 ? width - 2 : width;
@@ -256,6 +259,9 @@ static int print_test_result(struct test_suite *t, int i, int subtest, int resul
 		pr_info("%3d: %-*s:", i + 1, width, test_description(t, subtest));
 
 	switch (result) {
+	case TEST_RUNNING:
+		color_fprintf(stderr, PERF_COLOR_YELLOW, " Running (%d active)\n", running);
+		break;
 	case TEST_OK:
 		pr_info(" Ok\n");
 		break;
@@ -277,14 +283,17 @@ static int print_test_result(struct test_suite *t, int i, int subtest, int resul
 	return 0;
 }
 
-static int finish_test(struct child_test *child_test, int width)
+static int finish_test(struct child_test **child_tests, int running_test, int child_test_num,
+		       int width)
 {
+	struct child_test *child_test = child_tests[running_test];
 	struct test_suite *t = child_test->test;
 	int i = child_test->test_num;
 	int subi = child_test->subtest;
 	int err = child_test->process.err;
-	bool err_done = err <= 0;
+	bool err_done = false;
 	struct strbuf err_output = STRBUF_INIT;
+	int last_running = -1;
 	int ret;
 
 	/*
@@ -298,7 +307,7 @@ static int finish_test(struct child_test *child_test, int width)
 	 * Busy loop reading from the child's stdout/stderr that are set to be
 	 * non-blocking until EOF.
 	 */
-	if (!err_done)
+	if (err > 0)
 		fcntl(err, F_SETFL, O_NONBLOCK);
 	if (verbose > 1) {
 		if (has_subtests(t))
@@ -312,38 +321,60 @@ static int finish_test(struct child_test *child_test, int width)
 			  .events = POLLIN | POLLERR | POLLHUP | POLLNVAL,
 			},
 		};
-		char buf[512];
-		ssize_t len;
-
-		/* Poll to avoid excessive spinning, timeout set for 100ms. */
-		poll(pfds, ARRAY_SIZE(pfds), /*timeout=*/100);
-		if (!err_done && pfds[0].revents) {
-			errno = 0;
-			len = read(err, buf, sizeof(buf) - 1);
-
-			if (len <= 0) {
-				err_done = errno != EAGAIN;
-			} else {
-				buf[len] = '\0';
-				if (verbose > 1)
-					fprintf(stdout, "%s", buf);
-				else
+		if (perf_use_color_default) {
+			int running = 0;
+
+			for (int y = running_test; y < child_test_num; y++) {
+				if (check_if_command_finished(&child_tests[y]->process) == 0)
+					running++;
+			}
+			if (running != last_running) {
+				if (last_running != -1) {
+					/*
+					 * Erase "Running (.. active)" line
+					 * printed before poll/sleep.
+					 */
+					fprintf(debug_file(), PERF_COLOR_DELETE_LINE);
+				}
+				print_test_result(t, i, subi, TEST_RUNNING, width, running);
+				last_running = running;
+			}
+		}
+
+		err_done = true;
+		if (err <= 0) {
+			/* No child stderr to poll, sleep for 10ms for child to complete. */
+			usleep(10 * 1000);
+		} else {
+			/* Poll to avoid excessive spinning, timeout set for 100ms. */
+			poll(pfds, ARRAY_SIZE(pfds), /*timeout=*/100);
+			if (pfds[0].revents) {
+				char buf[512];
+				ssize_t len;
+
+				len = read(err, buf, sizeof(buf) - 1);
+
+				if (len > 0) {
+					err_done = false;
+					buf[len] = '\0';
 					strbuf_addstr(&err_output, buf);
+				}
 			}
 		}
+		if (err_done)
+			err_done = check_if_command_finished(&child_test->process);
+	}
+	if (perf_use_color_default && last_running != -1) {
+		/* Erase "Running (.. active)" line printed before poll/sleep. */
+		fprintf(debug_file(), PERF_COLOR_DELETE_LINE);
 	}
 	/* Clean up child process. */
 	ret = finish_command(&child_test->process);
-	if (verbose == 1 && ret == TEST_FAIL) {
-		/* Add header for test that was skipped above. */
-		if (has_subtests(t))
-			pr_info("%3d.%1d: %s:\n", i + 1, subi + 1, test_description(t, subi));
-		else
-			pr_info("%3d: %s:\n", i + 1, test_description(t, -1));
+	if (verbose > 1 || (verbose == 1 && ret == TEST_FAIL))
 		fprintf(stderr, "%s", err_output.buf);
-	}
+
 	strbuf_release(&err_output);
-	print_test_result(t, i, subi, ret, width);
+	print_test_result(t, i, subi, ret, width, /*running=*/0);
 	if (err > 0)
 		close(err);
 	return 0;
@@ -359,7 +390,7 @@ static int start_test(struct test_suite *test, int i, int subi, struct child_tes
 		pr_debug("--- start ---\n");
 		err = test_function(test, subi)(test, subi);
 		pr_debug("---- end ----\n");
-		print_test_result(test, i, subi, err, width);
+		print_test_result(test, i, subi, err, width, /*running=*/0);
 		return 0;
 	}
 
@@ -384,7 +415,7 @@ static int start_test(struct test_suite *test, int i, int subi, struct child_tes
 	err = start_command(&(*child)->process);
 	if (err || !sequential)
 		return  err;
-	return finish_test(*child, width);
+	return finish_test(child, /*running_test=*/0, /*child_test_num=*/1, width);
 }
 
 #define for_each_test(j, k, t)					\
@@ -469,7 +500,7 @@ static int __cmd_test(int argc, const char *argv[], struct intlist *skiplist)
 	}
 	for (i = 0; i < child_test_num; i++) {
 		if (!sequential) {
-			int ret  = finish_test(child_tests[i], width);
+			int ret  = finish_test(child_tests, i, child_test_num, width);
 
 			if (ret)
 				return ret;
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index 01f7bed21c9b2..4b9f8d5d44395 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -22,6 +22,7 @@
 #define MIN_GREEN	0.5
 #define MIN_RED		5.0
 
+#define PERF_COLOR_DELETE_LINE	"\033[A\33[2K\r"
 /*
  * This variable stores the value of color.ui
  */
-- 
2.53.0



