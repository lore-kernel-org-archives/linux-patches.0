Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05281B3721;
	Thu,  6 Jun 2024 14:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683418; cv=none; b=hI8B9TWMIlAT/atVIiLrILyQT/x0C41iJw0UAN6AvhWAS/VbSQwAMAMyVhoIl5Lx1Xd1EyEW2hbwhgwHN0LJuNzcej2dw/OTpDSOo9XJveqfdaboYxr6XmKCS1bTtHwpeZvIQBr+h9VFyJZp+2Q/Oc2L4Qrfq1iRJ4cIeNS18WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683418; c=relaxed/simple;
	bh=i3HJyFDH9sUFh3AZYyOFVKmCMf2TzCZ/nENqErycD4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opPFEB8TVuMzrAV32q0rzhXJZkFBU7OR/hMHpcHOfevQba+xNgy8362ebzIpg7fDq85BnJu6NO6610hZ5Jc2A4XpDtrTtvurRobt2W/ikooXIqVpCWvpR9LYnzXyurEJeOkFVXiii0Ria7klaPPp8oQi9b0mMm4w9Inknd1dc8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adCq2GXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adCq2GXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE65C4AF09;
	Thu,  6 Jun 2024 14:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683418;
	bh=i3HJyFDH9sUFh3AZYyOFVKmCMf2TzCZ/nENqErycD4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adCq2GXlaMQgY9zXwXPfruyIhrBKmvLs0crnDGWms45Hvk5n/3NedsYjD2rjPW+Gp
	 5p4r09yLvmZyGPnlJ3/S8nnED5/awqPKEghG5yRSP3lj7SC1z9OhODVgxNDPl2Way4
	 qSjnxCRoQVR/iJESbGfgw2z4ZeTBj1YGn4l3aCZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	German Gomez <german.gomez@arm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Zhengjun Xing <zhengjun.xing@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 301/473] perf test: Add sqrtloop test workload
Date: Thu,  6 Jun 2024 16:03:50 +0200
Message-ID: <20240606131709.881555025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 39281709a6e2301ac4c6ac7015c7793392ca2dfe ]

The sqrtloop creates a child process to run an infinite loop calling
sqrt() with rand().  This is needed for ARM SPE fork test.

  $ perf test -w sqrtloop

It can take an optional argument to specify how long it will run in
seconds (default: 1).

Committer notes:

Explicitely ignored the sqrt() return to fix the build on systems where
the compiler complains it isn't being used.

And added a sqrtloop specific CFLAGS to disable optimizations to make
this a bit more robust wrt dead code elimination.

Doing that a -U_FORTIFY_SOURCE needs to be added, as -O0 is incompatible
with it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20221116233854.1596378-8-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 256ef072b384 ("perf tests: Make "test data symbol" more robust on Neoverse N1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c       |  1 +
 tools/perf/tests/tests.h              |  1 +
 tools/perf/tests/workloads/Build      |  2 ++
 tools/perf/tests/workloads/sqrtloop.c | 45 +++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)
 create mode 100644 tools/perf/tests/workloads/sqrtloop.c

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 0ed5ac452f6ee..9acb7a93eeb97 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -122,6 +122,7 @@ static struct test_workload *workloads[] = {
 	&workload__noploop,
 	&workload__thloop,
 	&workload__leafloop,
+	&workload__sqrtloop,
 };
 
 static int num_subtests(const struct test_suite *t)
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 86804dd6452b7..18c40319e67c7 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -203,5 +203,6 @@ struct test_workload workload__##work = {	\
 DECLARE_WORKLOAD(noploop);
 DECLARE_WORKLOAD(thloop);
 DECLARE_WORKLOAD(leafloop);
+DECLARE_WORKLOAD(sqrtloop);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/workloads/Build b/tools/perf/tests/workloads/Build
index 03dc675a4a7c8..2312a338f01c0 100644
--- a/tools/perf/tests/workloads/Build
+++ b/tools/perf/tests/workloads/Build
@@ -3,5 +3,7 @@
 perf-y += noploop.o
 perf-y += thloop.o
 perf-y += leafloop.o
+perf-y += sqrtloop.o
 
+CFLAGS_sqrtloop.o         = -g -O0 -fno-inline -U_FORTIFY_SOURCE
 CFLAGS_leafloop.o         = -g -O0 -fno-inline -fno-omit-frame-pointer -U_FORTIFY_SOURCE
diff --git a/tools/perf/tests/workloads/sqrtloop.c b/tools/perf/tests/workloads/sqrtloop.c
new file mode 100644
index 0000000000000..ccc94c6a6676a
--- /dev/null
+++ b/tools/perf/tests/workloads/sqrtloop.c
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <math.h>
+#include <signal.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <linux/compiler.h>
+#include <sys/wait.h>
+#include "../tests.h"
+
+static volatile sig_atomic_t done;
+
+static void sighandler(int sig __maybe_unused)
+{
+	done = 1;
+}
+
+static int __sqrtloop(int sec)
+{
+	signal(SIGALRM, sighandler);
+	alarm(sec);
+
+	while (!done)
+		(void)sqrt(rand());
+	return 0;
+}
+
+static int sqrtloop(int argc, const char **argv)
+{
+	int sec = 1;
+
+	if (argc > 0)
+		sec = atoi(argv[0]);
+
+	switch (fork()) {
+	case 0:
+		return __sqrtloop(sec);
+	case -1:
+		return -1;
+	default:
+		wait(NULL);
+	}
+	return 0;
+}
+
+DEFINE_WORKLOAD(sqrtloop);
-- 
2.43.0



