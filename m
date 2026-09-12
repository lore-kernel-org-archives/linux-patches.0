Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277D747ACE6;
	Sat, 12 Sep 2026 12:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217789; cv=none; b=jFmeGNIzh+NWoG7rg4jRrLbacd9/3+aSCbPH/Qe9gRoJqsxe6wVKrzxZ9Cd+KS+4ce0LjKr2UbXDb1HsFFCyQmW7OUdhycoKIY/gV44EWNnsOmxvIKyXr7F836ExKJSBJhP+eL5tWiVStFAb0yVKG42neS5REM4pBI7ngLFizws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217789; c=relaxed/simple;
	bh=gHB3R8vikBtIM/UUsSEUy9vewMH5/AfJgSb5ChZyhaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP37VZY7WDR+cylCmxgL6bzD15eQiq2+M7ZBEhWsDYsWuucuuJKi5H/PbOgWd0OvcJiQgPk2Q5HuyOjuxMtk6cQt2Hk0/l5AjEwq1iRYJ3cMAorfqOmTZBpsjsxya/+8uqrTbVprISpeiO2Oxf/hRIBaHDOGFnF1R7T+bvQTzjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhvrvbpO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhvrvbpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47761F000FF;
	Sat, 12 Sep 2026 12:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217788;
	bh=sgzh4LUhQA/y22YUeLaCZaa8d1g5VsSwfxCmEWhdKrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhvrvbpOmMVpgz8FkCBIffpcK77dcB+SYEN1guK6c70QNo9qehhi31aO6qR2sPPji
	 b09mffHJ38qGVLKngDujD3kwriXeq+B1cWk5ko29C/q449AsEDz++6tsBUQysO1nKP
	 QpK/EvU5fwaYSOyyzrSBh/StZkygJDoSdK1wxTkk=
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
Subject: [PATCH 6.12 1010/1376] perf test: Add a signal handler around running a test
Date: Sat, 12 Sep 2026 08:57:16 +0200
Message-ID: <20260912065630.074618465@linuxfoundation.org>
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

[ Upstream commit a6fffc60940a903ebcd70d44f047277ba5188225 ]

Add a signal handler around running a test. If a signal occurs during
the test a siglongjmp unwinds the stack and output is flushed. The
global run_test_jmp_buf is either unique per forked child or not
shared during sequential execution.

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
Link: https://lore.kernel.org/r/20241025192109.132482-7-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 44e82c4d2ff3 ("perf test: Fix skiplist leak in cmd_test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 3b6743a3232c1..28d3c25478a1f 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -8,6 +8,7 @@
 #include <errno.h>
 #include <poll.h>
 #include <unistd.h>
+#include <setjmp.h>
 #include <string.h>
 #include <stdlib.h>
 #include <sys/types.h>
@@ -233,16 +234,41 @@ struct child_test {
 	int subtest;
 };
 
+static jmp_buf run_test_jmp_buf;
+
+static void child_test_sig_handler(int sig)
+{
+	siglongjmp(run_test_jmp_buf, sig);
+}
+
 static int run_test_child(struct child_process *process)
 {
-	struct child_test *child = container_of(process, struct child_test, process);
+	const int signals[] = {
+		SIGABRT, SIGBUS, SIGFPE, SIGILL, SIGINT, SIGPIPE, SIGQUIT, SIGSEGV, SIGTERM,
+	};
+	static struct child_test *child;
 	int err;
 
+	err = sigsetjmp(run_test_jmp_buf, 1);
+	if (err) {
+		fprintf(stderr, "\n---- unexpected signal (%d) ----\n", err);
+		err = err > 0 ? -err : -1;
+		goto err_out;
+	}
+
+	child = container_of(process, struct child_test, process);
+	for (size_t i = 0; i < ARRAY_SIZE(signals); i++)
+		signal(signals[i], child_test_sig_handler);
+
 	pr_debug("--- start ---\n");
 	pr_debug("test child forked, pid %d\n", getpid());
 	err = test_function(child->test, child->subtest)(child->test, child->subtest);
 	pr_debug("---- end(%d) ----\n", err);
+
+err_out:
 	fflush(NULL);
+	for (size_t i = 0; i < ARRAY_SIZE(signals); i++)
+		signal(signals[i], SIG_DFL);
 	return -err;
 }
 
-- 
2.53.0



