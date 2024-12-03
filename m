Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EF02D7BF;
	Tue,  3 Dec 2024 15:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239043; cv=none; b=jQAkBFBKeqCORi1Xa82G2BjuVKpNDx1yZtrVnPRd7+8aY6JVVEcsl8HQ4sX48NS1xEQOvRUyD5g2J59erZEqe63TMARXAFWv/JV/P6iB6kMoDo/GCIQlsKlRmdc7AhDVPcNvhoe+LG+96oJ2VrXoAdL0W2sDTPJZulYRANP6ZQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239043; c=relaxed/simple;
	bh=3mnhTY1kFCcQ0IFjcP/IaJQ4ohipBqYxL8cclB2RGNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IS4rQZp+VN5UhLd8zHwH8q9s4TtI+bmn5j59wYRfhV9+z+EOfYxLN7rXI0PrAYNndCuqAn1I8Hw2S6TB7OUB4DqTwk0C0YwGwC8FX0tLlDVQBnYWcrOF7gkX6NqVY3vOvhGBvNiFg7V9AkVfKn+qFk7Jc+HoSQ6vBmU7U/5wai0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luSQ8iD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luSQ8iD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9723C4CED6;
	Tue,  3 Dec 2024 15:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239042;
	bh=3mnhTY1kFCcQ0IFjcP/IaJQ4ohipBqYxL8cclB2RGNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luSQ8iD3MGM8TP47GK8bOMgVsgE6B6hgemP7tgGQ8p0hXDDJUkAjjnqi9U3igS9ff
	 ejLktJWx62ASPb9tMVyByLGwu4xumi4zwhZOG9+lIxfpyFKekrZAbHJavGbyXqb4sA
	 vxMztGUSarPD1HjvCo50lsxli71XBblxSjwkXEgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Weilin Wang <weilin.wang@intel.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Caleb Biggers <caleb.biggers@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Perry Taylor <perry.taylor@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Samantha Alt <samantha.alt@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 485/817] perf test: Add test for Intel TPEBS counting mode
Date: Tue,  3 Dec 2024 15:40:57 +0100
Message-ID: <20241203144014.802305413@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weilin Wang <weilin.wang@intel.com>

[ Upstream commit b2738fda24543777a623a7d1cc2a9985ab81b448 ]

Intel TPEBS sampling mode is supported through perf record. The counting mode
code uses perf record to capture retire_latency value and use it in metric
calculation. This test checks the counting mode code on Intel platforms.

Committer testing:

  root@x1:~# perf test tpebs
  123: test Intel TPEBS counting mode                                  : Ok
  root@x1:~# set -o vi
  root@x1:~# perf test tpebs
  123: test Intel TPEBS counting mode                                  : Ok
  root@x1:~# perf test -v tpebs
  123: test Intel TPEBS counting mode                                  : Ok
  root@x1:~# perf test -vvv tpebs
  123: test Intel TPEBS counting mode:
  --- start ---
  test child forked, pid 16603
  Testing without --record-tpebs
  Testing with --record-tpebs
  ---- end(0) ----
  123: test Intel TPEBS counting mode                                  : Ok
  root@x1:~#

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Weilin Wang <weilin.wang@intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Caleb Biggers <caleb.biggers@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Perry Taylor <perry.taylor@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Samantha Alt <samantha.alt@intel.com>
Link: https://lore.kernel.org/r/20240720062102.444578-9-weilin.wang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 057f8bfc6f70 ("perf stat: Uniquify event name improvements")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../perf/tests/shell/test_stat_intel_tpebs.sh | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100755 tools/perf/tests/shell/test_stat_intel_tpebs.sh

diff --git a/tools/perf/tests/shell/test_stat_intel_tpebs.sh b/tools/perf/tests/shell/test_stat_intel_tpebs.sh
new file mode 100755
index 0000000000000..c60b29add9801
--- /dev/null
+++ b/tools/perf/tests/shell/test_stat_intel_tpebs.sh
@@ -0,0 +1,19 @@
+#!/bin/bash
+# test Intel TPEBS counting mode
+# SPDX-License-Identifier: GPL-2.0
+
+set -e
+grep -q GenuineIntel /proc/cpuinfo || { echo Skipping non-Intel; exit 2; }
+
+# Use this event for testing because it should exist in all platforms
+event=cache-misses:R
+
+# Without this cmd option, default value or zero is returned
+echo "Testing without --record-tpebs"
+result=$(perf stat -e "$event" true 2>&1)
+[[ "$result" =~ $event ]] || exit 1
+
+# In platforms that do not support TPEBS, it should execute without error.
+echo "Testing with --record-tpebs"
+result=$(perf stat -e "$event" --record-tpebs -a sleep 0.01 2>&1)
+[[ "$result" =~ "perf record" && "$result" =~ $event ]] || exit 1
-- 
2.43.0



