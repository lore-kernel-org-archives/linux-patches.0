Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8D438D;
	Thu,  6 Jun 2024 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682896; cv=none; b=g2ni8aWhraNuDY2kxodCrYPC4ZRr68fg0kHnGv3f4ty7gUpPqXc8OgOwkuxIVuf46/Gvc66oEJHRlVgoEjnCB4E9CCLJz0xteS0gnx+7QvZJdJ/BKrITrDhqhhT3uKGLHpR23EYNXmKriIWC+Wf3cDzDgjBOu2bM80IGqsxIxvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682896; c=relaxed/simple;
	bh=O0rZAdHAyR6lzw/tIuo7nMZS1luZhA+7VrfuXJXmTCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdevgCCtEQ752Bni0EAjZ7bBwQZoFPmwlL5D5w1jaIMZGPA8eP1ALlYWb2tsuxYn0vpCR2QD69NYvYXQ2OKAt+eWuQAMyxoJQ0GJScBoUuy8rIGxUkcFakGr49y2lVR5RhOGZbh1wtgocbu2nga73EZTATAKF1ZYON2/hp+uxaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZxbuXlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZxbuXlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50F0C4AF07;
	Thu,  6 Jun 2024 14:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682895;
	bh=O0rZAdHAyR6lzw/tIuo7nMZS1luZhA+7VrfuXJXmTCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZxbuXlRh/CDv04arusqLU144/U0dVtrZoMtidt3dStCSyJYFBEWU502BkbG8mBRZ
	 Dm6lAQdYmxek7RTmEdutgUfBf8UAZJQhW267j2PFsSJm7eX9Yo89AWREmQ0Ew1PJ+Z
	 3sujhIlKHxD/T6/nCz/UT3JW4bQm/+qsuapcBe/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Disha Goel <disgoel@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <songliubraving@fb.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 003/374] perf test: Use a single fd for the child process out/err
Date: Thu,  6 Jun 2024 15:59:42 +0200
Message-ID: <20240606131651.828185132@linuxfoundation.org>
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

[ Upstream commit e120f7091a25460a19967380725558c36bca7c6c ]

Switch from dumping err then out, to a single file descriptor for both
of them. This allows the err and output to be correctly interleaved in
verbose output.

Fixes: b482f5f8e0168f1e ("perf tests: Add option to run tests in parallel")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Disha Goel <disgoel@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20240301074639.2260708-3-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 37 ++++++---------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index d13ee7683d9d8..e05b370b1e2b1 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -274,11 +274,8 @@ static int finish_test(struct child_test *child_test, int width)
 	struct test_suite *t = child_test->test;
 	int i = child_test->test_num;
 	int subi = child_test->subtest;
-	int out = child_test->process.out;
 	int err = child_test->process.err;
-	bool out_done = out <= 0;
 	bool err_done = err <= 0;
-	struct strbuf out_output = STRBUF_INIT;
 	struct strbuf err_output = STRBUF_INIT;
 	int ret;
 
@@ -290,11 +287,9 @@ static int finish_test(struct child_test *child_test, int width)
 		pr_info("%3d: %-*s:\n", i + 1, width, test_description(t, -1));
 
 	/*
-	 * Busy loop reading from the child's stdout and stderr that are set to
-	 * be non-blocking until EOF.
+	 * Busy loop reading from the child's stdout/stderr that are set to be
+	 * non-blocking until EOF.
 	 */
-	if (!out_done)
-		fcntl(out, F_SETFL, O_NONBLOCK);
 	if (!err_done)
 		fcntl(err, F_SETFL, O_NONBLOCK);
 	if (verbose > 1) {
@@ -303,11 +298,8 @@ static int finish_test(struct child_test *child_test, int width)
 		else
 			pr_info("%3d: %s:\n", i + 1, test_description(t, -1));
 	}
-	while (!out_done || !err_done) {
-		struct pollfd pfds[2] = {
-			{ .fd = out,
-			  .events = POLLIN | POLLERR | POLLHUP | POLLNVAL,
-			},
+	while (!err_done) {
+		struct pollfd pfds[1] = {
 			{ .fd = err,
 			  .events = POLLIN | POLLERR | POLLHUP | POLLNVAL,
 			},
@@ -317,21 +309,7 @@ static int finish_test(struct child_test *child_test, int width)
 
 		/* Poll to avoid excessive spinning, timeout set for 1000ms. */
 		poll(pfds, ARRAY_SIZE(pfds), /*timeout=*/1000);
-		if (!out_done && pfds[0].revents) {
-			errno = 0;
-			len = read(out, buf, sizeof(buf) - 1);
-
-			if (len <= 0) {
-				out_done = errno != EAGAIN;
-			} else {
-				buf[len] = '\0';
-				if (verbose > 1)
-					fprintf(stdout, "%s", buf);
-				else
-					strbuf_addstr(&out_output, buf);
-			}
-		}
-		if (!err_done && pfds[1].revents) {
+		if (!err_done && pfds[0].revents) {
 			errno = 0;
 			len = read(err, buf, sizeof(buf) - 1);
 
@@ -354,14 +332,10 @@ static int finish_test(struct child_test *child_test, int width)
 			pr_info("%3d.%1d: %s:\n", i + 1, subi + 1, test_description(t, subi));
 		else
 			pr_info("%3d: %s:\n", i + 1, test_description(t, -1));
-		fprintf(stdout, "%s", out_output.buf);
 		fprintf(stderr, "%s", err_output.buf);
 	}
-	strbuf_release(&out_output);
 	strbuf_release(&err_output);
 	print_test_result(t, i, subi, ret, width);
-	if (out > 0)
-		close(out);
 	if (err > 0)
 		close(err);
 	return 0;
@@ -394,6 +368,7 @@ static int start_test(struct test_suite *test, int i, int subi, struct child_tes
 		(*child)->process.no_stdout = 1;
 		(*child)->process.no_stderr = 1;
 	} else {
+		(*child)->process.stdout_to_stderr = 1;
 		(*child)->process.out = -1;
 		(*child)->process.err = -1;
 	}
-- 
2.43.0



