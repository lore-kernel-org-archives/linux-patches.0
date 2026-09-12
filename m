Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C459B4BEE54;
	Sat, 12 Sep 2026 09:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206154; cv=none; b=AtC4MWyRAMBIe+sJ+MOXkIjeCO2DmWqmVX7tJiftzr+CkNIf8iX1HNSUeGovfQVXFGnFqRto1cCjo5nrqwoxnYYMN0LUeqC49i+mSStMN/+umPpEjRxlD1kslpqQVbu8+IoQv9XPV2uGAu2i0BaEZ7akeWcxGkNP25c+PGALoDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206154; c=relaxed/simple;
	bh=AWwlcSSnd6biaFeKyzjsxeQs+VtCIBJUmTTURvXC204=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXDPFF7G2/9uOYIWGqRgkCmJQn+XtsrgV0CK5sg68Lwb2LtBAfjCPlehfsMiliR4I5qVxw+b70zhCR9pFJOsA6KpQyZH6nFowuGg6ATZDYnFztZ3MS4MS5Ai0YWHAlNDdcsrnNdfs/gmos01a0rQnfFO42YEvjfucZg7tZhxuCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbP1EooH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbP1EooH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F28C1F000FF;
	Sat, 12 Sep 2026 09:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206152;
	bh=xYMJWoyRqg51u4Yunr+jyF3NX2ojZRMHGz2FidYDuHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbP1EooHQdjkrWMhfhHHy6JPcKPzPZOPxgVvE+QzmjLHShlBAm11cqOBiLKRH5gjB
	 nd3Ofzdw35wh18qjoFmbi6hFVI5+OlDcq7CoUmpGch6Zfj42rfte6oqKzP5omLkmD4
	 eroygt+iIyDCGNulUiOO6Zo5Lu32DCBrru1O3dk0=
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
Subject: [PATCH 6.18 0149/1518] perf test: Refactor parallel poll loop to drain all pipes simultaneously
Date: Sat, 12 Sep 2026 08:38:38 +0200
Message-ID: <20260912065626.863214159@linuxfoundation.org>
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

[ Upstream commit f35450738e789b80b540f41487b9053defd0bb8d ]

When running tests in parallel with verbose output (-v), child processes
write to pipes. If a test produces significant output (e.g. Granite
Rapids metric parsing printing hundreds of lines), it fills the 64KB
pipe buffer and blocks.

Previously, the parent harness (finish_test) only polled the pipe of the
current test waiting to be printed. Other children blocked indefinitely
until the parent reached them, severely sequentializing execution.

Address this by implementing finish_tests_parallel() to poll and drain
output pipes from all running children simultaneously into per-child
buffers, employing safe strbuf_addstr string operations alongside
thorough variable orderings for strict ISO C90 compliance. Reaping
occurs out of order as children finish, while final result printing
remains strictly in order.

This drops parallel verbose execution time for the PMU events suite from
~35 seconds down to ~5.9 seconds.

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
 tools/perf/tests/builtin-test.c | 267 +++++++++++++++++++++++++++++++-
 1 file changed, 259 insertions(+), 8 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b02138a855753..552aa898fc70d 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -295,6 +295,9 @@ struct child_test {
 	struct test_suite *test;
 	int suite_num;
 	int test_case_num;
+	struct strbuf err_output;
+	int result;
+	bool done;
 };
 
 static jmp_buf run_test_jmp_buf;
@@ -349,6 +352,11 @@ static int run_test_child(struct child_process *process)
 
 #define TEST_RUNNING -3
 
+static struct pollfd *global_pfds;
+static size_t *global_pfd_indices;
+
+static int strbuf_addstr_safe(struct strbuf *sb, const char *s);
+
 static int print_test_result(struct test_suite *t, int curr_suite, int curr_test_case,
 			     int result, int width, int running)
 {
@@ -415,7 +423,7 @@ static void finish_test(struct child_test **child_tests, int running_test, int c
 	 * Busy loop reading from the child's stdout/stderr that are set to be
 	 * non-blocking until EOF.
 	 */
-	if (err > 0)
+	if (err >= 0)
 		fcntl(err, F_SETFL, O_NONBLOCK);
 	if (verbose > 1) {
 		if (test_suite__num_test_cases(t) > 1)
@@ -469,7 +477,7 @@ static void finish_test(struct child_test **child_tests, int running_test, int c
 				if (len > 0) {
 					err_done = false;
 					buf[len] = '\0';
-					strbuf_addstr(&err_output, buf);
+					strbuf_addstr_safe(&err_output, buf);
 				}
 			}
 		}
@@ -477,13 +485,13 @@ static void finish_test(struct child_test **child_tests, int running_test, int c
 			err_done = check_if_command_finished(&child_test->process);
 	}
 	/* Drain any remaining data from the pipe. */
-	if (err > 0) {
+	if (err >= 0) {
 		char buf[512];
 		ssize_t len;
 
 		while ((len = read(err, buf, sizeof(buf) - 1)) > 0) {
 			buf[len] = '\0';
-			strbuf_addstr(&err_output, buf);
+			strbuf_addstr_safe(&err_output, buf);
 		}
 	}
 	if (perf_use_color_default && last_running != -1) {
@@ -492,16 +500,253 @@ static void finish_test(struct child_test **child_tests, int running_test, int c
 	}
 	/* Clean up child process. */
 	ret = finish_command(&child_test->process);
+	child_test->process.pid = 0;
+	if (child_test->err_output.len > 0) {
+		struct strbuf merged = STRBUF_INIT;
+
+		if (child_test->err_output.buf)
+			strbuf_addstr_safe(&merged, child_test->err_output.buf);
+		if (err_output.buf)
+			strbuf_addstr_safe(&merged, err_output.buf);
+		strbuf_release(&err_output);
+		err_output = merged;
+	}
 	if (verbose > 1 || (verbose == 1 && ret == TEST_FAIL))
 		fprintf(stderr, "%s", err_output.buf);
 
 	strbuf_release(&err_output);
+	strbuf_release(&child_test->err_output);
 	print_test_result(t, curr_suite, curr_test_case, ret, width, /*running=*/0);
 	if (err > 0)
 		close(err);
 	zfree(&child_tests[running_test]);
 }
 
+static int strbuf_addstr_safe(struct strbuf *sb, const char *s)
+{
+	sigset_t set, oldset;
+	int ret;
+
+	sigemptyset(&set);
+	sigaddset(&set, SIGINT);
+	sigaddset(&set, SIGTERM);
+	pthread_sigmask(SIG_BLOCK, &set, &oldset);
+	ret = strbuf_addstr(sb, s);
+	pthread_sigmask(SIG_SETMASK, &oldset, NULL);
+	return ret;
+}
+
+static void drain_child_process_err(struct child_test *child)
+{
+	char buf[512];
+	ssize_t len;
+
+	while ((len = read(child->process.err, buf, sizeof(buf) - 1)) > 0) {
+		buf[len] = '\0';
+		strbuf_addstr_safe(&child->err_output, buf);
+	}
+}
+
+static void handle_child_pipe_activity(struct child_test *child, short revents)
+{
+	if (!revents)
+		return;
+
+	drain_child_process_err(child);
+	/*
+	 * If the child closed its end of the pipe (EOF) or encountered
+	 * an error, close the file descriptor immediately and set it
+	 * to -1. This removes it from the pfds array for subsequent
+	 * iterations, preventing a tight CPU busy-loop while waiting
+	 * for the process itself to exit.
+	 */
+	if (revents & (POLLHUP | POLLERR | POLLNVAL)) {
+		close(child->process.err);
+		child->process.err = -1;
+	}
+}
+
+static int finish_tests_parallel(struct child_test **child_tests, size_t num_tests, int width)
+{
+	size_t next_to_print = 0;
+	struct pollfd *pfds;
+	size_t *pfd_indices;
+	size_t num_pfds = 0;
+	int last_running = -1;
+	size_t i;
+	int last_suite_printed = -1;
+	sigset_t set, oldset;
+
+	sigemptyset(&set);
+	sigaddset(&set, SIGINT);
+	sigaddset(&set, SIGTERM);
+
+	pthread_sigmask(SIG_BLOCK, &set, &oldset);
+	global_pfds = calloc(num_tests, sizeof(*pfds));
+	global_pfd_indices = calloc(num_tests, sizeof(*pfd_indices));
+	pfds = global_pfds;
+	pfd_indices = global_pfd_indices;
+	if (!pfds || !pfd_indices) {
+		free(pfds);
+		free(pfd_indices);
+		global_pfds = NULL;
+		global_pfd_indices = NULL;
+		pthread_sigmask(SIG_SETMASK, &oldset, NULL);
+		return -ENOMEM;
+	}
+	pthread_sigmask(SIG_SETMASK, &oldset, NULL);
+
+	for (i = 0; i < num_tests; i++) {
+		struct child_test *child = child_tests[i];
+
+		if (!child)
+			continue;
+		strbuf_init(&child->err_output, 0);
+		if (child->process.err >= 0)
+			fcntl(child->process.err, F_SETFL, O_NONBLOCK);
+	}
+
+	while (next_to_print < num_tests) {
+		size_t running_count = 0;
+		size_t p;
+
+		while (next_to_print < num_tests &&
+		       (!child_tests[next_to_print] || child_tests[next_to_print]->done))
+			next_to_print++;
+
+		if (next_to_print >= num_tests)
+			break;
+
+		num_pfds = 0;
+
+		for (i = next_to_print; i < num_tests; i++) {
+			struct child_test *child = child_tests[i];
+
+			if (!child || child->done)
+				continue;
+
+			if (!check_if_command_finished(&child->process))
+				running_count++;
+
+			if (child->process.err >= 0) {
+				pfds[num_pfds].fd = child->process.err;
+				pfds[num_pfds].events = POLLIN | POLLERR | POLLHUP | POLLNVAL;
+				pfd_indices[num_pfds] = i;
+				num_pfds++;
+			}
+		}
+
+		if (perf_use_color_default && running_count != (size_t)last_running) {
+			struct child_test *next_child = child_tests[next_to_print];
+
+			if (last_running != -1)
+				fprintf(debug_file(), PERF_COLOR_DELETE_LINE);
+
+			if (next_child) {
+				if (test_suite__num_test_cases(next_child->test) > 1 &&
+				    last_suite_printed != next_child->suite_num) {
+					pr_info("%3d: %-*s:\n", next_child->suite_num + 1, width,
+						test_description(next_child->test, -1));
+					last_suite_printed = next_child->suite_num;
+				}
+				print_test_result(next_child->test, next_child->suite_num,
+						  next_child->test_case_num, TEST_RUNNING, width,
+						  running_count);
+			}
+			last_running = running_count;
+		}
+
+		if (num_pfds == 0) {
+			if (running_count > 0)
+				usleep(10 * 1000);
+		} else {
+			int pret = poll(pfds, num_pfds, 100);
+
+			if (pret > 0) {
+				for (p = 0; p < num_pfds; p++) {
+					size_t idx = pfd_indices[p];
+
+					handle_child_pipe_activity(child_tests[idx],
+								   pfds[p].revents);
+				}
+			}
+		}
+
+		for (i = next_to_print; i < num_tests; i++) {
+			struct child_test *child = child_tests[i];
+
+			if (!child || child->done)
+				continue;
+
+			if (check_if_command_finished(&child->process)) {
+				if (child->process.err >= 0) {
+					drain_child_process_err(child);
+					close(child->process.err);
+					child->process.err = -1;
+				}
+				child->result = finish_command(&child->process);
+				child->process.pid = 0;
+				child->done = true;
+			}
+		}
+
+		while (next_to_print < num_tests) {
+			struct child_test *child = child_tests[next_to_print];
+
+			if (!child) {
+				next_to_print++;
+				continue;
+			}
+			if (!child->done)
+				break;
+
+			if (perf_use_color_default && last_running != -1) {
+				fprintf(debug_file(), PERF_COLOR_DELETE_LINE);
+				last_running = -1;
+			}
+
+			if (test_suite__num_test_cases(child->test) > 1 &&
+			    last_suite_printed != child->suite_num) {
+				pr_info("%3d: %-*s:\n", child->suite_num + 1, width,
+					test_description(child->test, -1));
+				last_suite_printed = child->suite_num;
+			}
+
+			if (verbose > 1) {
+				if (test_suite__num_test_cases(child->test) > 1) {
+					pr_info("%3d.%1d: %s:\n", child->suite_num + 1,
+						child->test_case_num + 1,
+						test_description(child->test,
+								 child->test_case_num));
+				} else {
+					pr_info("%3d: %s:\n", child->suite_num + 1,
+						test_description(child->test, -1));
+				}
+			}
+
+			if (verbose > 1 || (verbose == 1 && child->result == TEST_FAIL))
+				fprintf(stderr, "%s", child->err_output.buf);
+
+			print_test_result(child->test, child->suite_num, child->test_case_num,
+					  child->result, width, 0);
+			pthread_sigmask(SIG_BLOCK, &set, &oldset);
+			strbuf_release(&child->err_output);
+			child_tests[next_to_print] = NULL;
+			zfree(&child);
+			pthread_sigmask(SIG_SETMASK, &oldset, NULL);
+			next_to_print++;
+		}
+	}
+
+	pthread_sigmask(SIG_BLOCK, &set, &oldset);
+	free(global_pfds);
+	free(global_pfd_indices);
+	global_pfds = NULL;
+	global_pfd_indices = NULL;
+	pthread_sigmask(SIG_SETMASK, &oldset, NULL);
+	return 0;
+}
+
 static int start_test(struct test_suite *test, int curr_suite, int curr_test_case,
 		struct child_test **child, int width, int pass)
 {
@@ -535,13 +780,14 @@ static int start_test(struct test_suite *test, int curr_suite, int curr_test_cas
 	(*child)->test_case_num = curr_test_case;
 	(*child)->process.pid = -1;
 	(*child)->process.no_stdin = 1;
+	(*child)->process.in = -1;
+	(*child)->process.out = -1;
+	(*child)->process.err = -1;
 	if (verbose <= 0) {
 		(*child)->process.no_stdout = 1;
 		(*child)->process.no_stderr = 1;
 	} else {
 		(*child)->process.stdout_to_stderr = 1;
-		(*child)->process.out = -1;
-		(*child)->process.err = -1;
 	}
 	(*child)->process.no_exec_cmd = run_test_child;
 	if (sequential || pass == 2) {
@@ -664,8 +910,9 @@ static int __cmd_test(struct test_suite **suites, int argc, const char *argv[],
 		}
 		if (!sequential) {
 			/* Parallel mode starts tests but doesn't finish them. Do that now. */
-			for (size_t x = 0; x < num_tests; x++)
-				finish_test(child_tests, x, num_tests, width);
+			err = finish_tests_parallel(child_tests, num_tests, width);
+			if (err)
+				goto err_out;
 		}
 	}
 err_out:
@@ -676,6 +923,10 @@ static int __cmd_test(struct test_suite **suites, int argc, const char *argv[],
 		for (size_t x = 0; x < num_tests; x++)
 			finish_test(child_tests, x, num_tests, width);
 	}
+	free(global_pfds);
+	free(global_pfd_indices);
+	global_pfds = NULL;
+	global_pfd_indices = NULL;
 	free(child_tests);
 	return err;
 }
-- 
2.53.0



