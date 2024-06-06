Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D351A19D070;
	Thu,  6 Jun 2024 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683453; cv=none; b=JZbx5Eb6Ien8+tIicRkauKmI5cjg3XXYeUSJEXRDZ1LERGB2XG3URDV5MJ8UhA37SoNmwTUZSlSh6PyeeC2ukAuFdhD35axaPGRtVJn+/fsmEYJX1+QtqdWnuTLHip9XFnfjAvTuE79Ji6axes2lgqes4VmPsnvSwHihmQIHqYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683453; c=relaxed/simple;
	bh=9b2BB0t4pVh9zGTHczWTygCSW/Q373vW8uPZG7YzvI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3iL4adC2x3Ssd3UiR1cU4f4rz00OjiRl/thXnHyfpKwk0PR7sJaXwQoQPSRIj0DnNKmp7iFwVPhf3mh4dsaBcqb8JLk00/TlISm46KlMSpn0xBJPCvi3kudzonociRFMpN8K11E0iol/uxOQOo1HHo48WNnlMqu/AlAxupEng8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VK4XKnf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VK4XKnf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC988C2BD10;
	Thu,  6 Jun 2024 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683453;
	bh=9b2BB0t4pVh9zGTHczWTygCSW/Q373vW8uPZG7YzvI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK4XKnf8CVUsbOt9bew6OTkN5rz6IiINZn5MNS+EqKsQfcVNTu1ogPE/lRMAhHQYd
	 ImCFN6ur3nDaL5eaCIKWT0aVCSgH3yvXMdA7AT6iZ+//BxaHZy7qjrHznZLrJm4YTB
	 H06f4VyFmrK+s8MpEQyEbm8AxeQnYqr7pvAaSClI=
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
Subject: [PATCH 6.1 303/473] perf test: Add datasym test workload
Date: Thu,  6 Jun 2024 16:03:52 +0200
Message-ID: <20240606131709.948667976@linuxfoundation.org>
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

[ Upstream commit 3dfc01fe9d12a1e832f49deab37279faa8a9ebc8 ]

The datasym workload is to check if perf mem command gets the data
addresses precisely.  This is needed for data symbol test.

  $ perf test -w datasym

I had to keep the buf1 in the data section, otherwise it could end
up in the BSS and was mmaped as a separate //anon region, then it
was not symbolized at all.  It needs to be fixed separately.

Committer notes:

Add a -U _FORTIFY_SOURCE to the datasym CFLAGS, as the main perf flags
set it and it requires building with optimization, and this new test has
a -O0.

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
Link: https://lore.kernel.org/r/20221116233854.1596378-12-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 256ef072b384 ("perf tests: Make "test data symbol" more robust on Neoverse N1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c      |  1 +
 tools/perf/tests/tests.h             |  1 +
 tools/perf/tests/workloads/Build     |  2 ++
 tools/perf/tests/workloads/datasym.c | 24 ++++++++++++++++++++++++
 4 files changed, 28 insertions(+)
 create mode 100644 tools/perf/tests/workloads/datasym.c

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 69fa56939309b..4c6ae59a4dfd7 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -124,6 +124,7 @@ static struct test_workload *workloads[] = {
 	&workload__leafloop,
 	&workload__sqrtloop,
 	&workload__brstack,
+	&workload__datasym,
 };
 
 static int num_subtests(const struct test_suite *t)
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index dc96f59cac2ef..e15f24cfc9094 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -205,5 +205,6 @@ DECLARE_WORKLOAD(thloop);
 DECLARE_WORKLOAD(leafloop);
 DECLARE_WORKLOAD(sqrtloop);
 DECLARE_WORKLOAD(brstack);
+DECLARE_WORKLOAD(datasym);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/workloads/Build b/tools/perf/tests/workloads/Build
index ae06a5538b171..a1f34d5861e36 100644
--- a/tools/perf/tests/workloads/Build
+++ b/tools/perf/tests/workloads/Build
@@ -5,7 +5,9 @@ perf-y += thloop.o
 perf-y += leafloop.o
 perf-y += sqrtloop.o
 perf-y += brstack.o
+perf-y += datasym.o
 
 CFLAGS_sqrtloop.o         = -g -O0 -fno-inline -U_FORTIFY_SOURCE
 CFLAGS_leafloop.o         = -g -O0 -fno-inline -fno-omit-frame-pointer -U_FORTIFY_SOURCE
 CFLAGS_brstack.o          = -g -O0 -fno-inline -U_FORTIFY_SOURCE
+CFLAGS_datasym.o          = -g -O0 -fno-inline -U_FORTIFY_SOURCE
diff --git a/tools/perf/tests/workloads/datasym.c b/tools/perf/tests/workloads/datasym.c
new file mode 100644
index 0000000000000..ddd40bc63448a
--- /dev/null
+++ b/tools/perf/tests/workloads/datasym.c
@@ -0,0 +1,24 @@
+#include <linux/compiler.h>
+#include "../tests.h"
+
+typedef struct _buf {
+	char data1;
+	char reserved[55];
+	char data2;
+} buf __attribute__((aligned(64)));
+
+static buf buf1 = {
+	/* to have this in the data section */
+	.reserved[0] = 1,
+};
+
+static int datasym(int argc __maybe_unused, const char **argv __maybe_unused)
+{
+	for (;;) {
+		buf1.data1++;
+		buf1.data2 += buf1.data1;
+	}
+	return 0;
+}
+
+DEFINE_WORKLOAD(datasym);
-- 
2.43.0



