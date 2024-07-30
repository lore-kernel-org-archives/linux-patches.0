Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7050B188013;
	Tue, 30 Jul 2024 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358306; cv=none; b=uuwWTZdawp/qYLBoHv+G8ARL9t/YVcG08P342WQMQYMt9QvScOIbyyc1WW1nT7XonMXK3cUjsxUyoIi6PmbLrlLTGIpd+eLtM8kl9GWCtrzrYiwqvYLv0AnNiXEqwy4jVa4BI56Dr3lBDOxX1OZjrBYb56fItb8I/TnzSkEv5YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358306; c=relaxed/simple;
	bh=oPiDfVBpsK18ztKbSO78GGcuSm/Ffa1jT5GEvftHcJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYXrlxbIJkbV40pFcXz1XxVnNKqu/YWurj/+yEbeGIZZlHj76cn748Fqt/ZDDIe1ORb97ZAmoztG6jJOLHkR4Xd5ZWDRInw2vREaAlyQlT/n26XLJ6nxbiSZ38OF6aAI4q7g6O1+WUYWiAgi7bQTyhkIoRZ7Eq2trTBJSgWM5q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoe9Bkjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoe9Bkjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA77C4AF0A;
	Tue, 30 Jul 2024 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358306;
	bh=oPiDfVBpsK18ztKbSO78GGcuSm/Ffa1jT5GEvftHcJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoe9Bkjpig9vUT+2u1q+dm1ikEJjo2tpSvR6nKj1HyBIZUIye2AtkI77ZgapwvOGB
	 srTsKVUSbofAA3s4BCxQoS6kweIUPAobiUYoAkHdke8nlG0nKvL2RcxoENlMe8aU+f
	 PUNus6KvBA86lggBnWRHt86S2byHRW/xTY23qPlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	German Gomez <german.gomez@arm.com>,
	Spoorthy S <spoorts2@in.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 344/809] perf test: Make test_arm_callgraph_fp.sh more robust
Date: Tue, 30 Jul 2024 17:43:40 +0200
Message-ID: <20240730151738.220452901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit ff16aeb9b83441b8458d4235496cf320189a0c60 ]

The 2 second sleep can cause the test to fail on very slow network file
systems because Perf ends up being killed before it finishes starting
up.

Fix it by making the leafloop workload end after a fixed time like the
other workloads so there is no need to kill it after 2 seconds.

Also remove the 1 second start sampling delay because it is similarly
fragile. Instead, search through all samples for a matching one, rather
than just checking the first sample and hoping it's in the right place.

Fixes: cd6382d82752 ("perf test arm64: Test unwinding using fame-pointer (fp) mode")
Signed-off-by: James Clark <james.clark@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: German Gomez <german.gomez@arm.com>
Cc: Spoorthy S <spoorts2@in.ibm.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240612140316.3006660-1-james.clark@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../perf/tests/shell/test_arm_callgraph_fp.sh | 27 +++++++------------
 tools/perf/tests/workloads/leafloop.c         | 20 +++++++++++---
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/tools/perf/tests/shell/test_arm_callgraph_fp.sh b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
index 61898e2566160..9caa361301759 100755
--- a/tools/perf/tests/shell/test_arm_callgraph_fp.sh
+++ b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
@@ -28,28 +28,21 @@ cleanup_files()
 
 trap cleanup_files EXIT TERM INT
 
-# Add a 1 second delay to skip samples that are not in the leaf() function
 # shellcheck disable=SC2086
-perf record -o "$PERF_DATA" --call-graph fp -e cycles//u -D 1000 --user-callchains -- $TEST_PROGRAM 2> /dev/null &
-PID=$!
+perf record -o "$PERF_DATA" --call-graph fp -e cycles//u --user-callchains -- $TEST_PROGRAM
 
-echo " + Recording (PID=$PID)..."
-sleep 2
-echo " + Stopping perf-record..."
-
-kill $PID
-wait $PID
+# Try opening the file so any immediate errors are visible in the log
+perf script -i "$PERF_DATA" -F comm,ip,sym | head -n4
 
-# expected perf-script output:
+# expected perf-script output if 'leaf' has been inserted correctly:
 #
-# program
+# perf
 # 	728 leaf
 # 	753 parent
 # 	76c leafloop
-# ...
+# ... remaining stack to main() ...
 
-perf script -i "$PERF_DATA" -F comm,ip,sym | head -n4
-perf script -i "$PERF_DATA" -F comm,ip,sym | head -n4 | \
-	awk '{ if ($2 != "") sym[i++] = $2 } END { if (sym[0] != "leaf" ||
-						       sym[1] != "parent" ||
-						       sym[2] != "leafloop") exit 1 }'
+# Each frame is separated by a tab, some spaces and an address
+SEP="[[:space:]]+ [[:xdigit:]]+"
+perf script -i "$PERF_DATA" -F comm,ip,sym | tr '\n' ' ' | \
+	grep -E -q "perf $SEP leaf $SEP parent $SEP leafloop"
diff --git a/tools/perf/tests/workloads/leafloop.c b/tools/perf/tests/workloads/leafloop.c
index 1bf5cc97649b0..f7561767e32cd 100644
--- a/tools/perf/tests/workloads/leafloop.c
+++ b/tools/perf/tests/workloads/leafloop.c
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#include <signal.h>
 #include <stdlib.h>
 #include <linux/compiler.h>
+#include <unistd.h>
 #include "../tests.h"
 
 /* We want to check these symbols in perf script */
@@ -8,10 +10,16 @@ noinline void leaf(volatile int b);
 noinline void parent(volatile int b);
 
 static volatile int a;
+static volatile sig_atomic_t done;
+
+static void sighandler(int sig __maybe_unused)
+{
+	done = 1;
+}
 
 noinline void leaf(volatile int b)
 {
-	for (;;)
+	while (!done)
 		a += b;
 }
 
@@ -22,12 +30,16 @@ noinline void parent(volatile int b)
 
 static int leafloop(int argc, const char **argv)
 {
-	int c = 1;
+	int sec = 1;
 
 	if (argc > 0)
-		c = atoi(argv[0]);
+		sec = atoi(argv[0]);
+
+	signal(SIGINT, sighandler);
+	signal(SIGALRM, sighandler);
+	alarm(sec);
 
-	parent(c);
+	parent(sec);
 	return 0;
 }
 
-- 
2.43.0



