Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53988522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB06C433C8;
	Sun,  9 Jul 2023 11:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902506;
	bh=/eCpOHVdDejXBXh6t0gTTlmuVTbygfJ3hKHPWPmuelg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUZpPWn5eTr+PZqjM0m0St2L4Gv2jXxaO2vpdtIFJ9zay4Q0D4i5Q9IJjFnVrHbyE
	 zuSsKHZI5LQrrvcUb4IWWnPrsM57+0/F0NQa5Kb6Z0YvfUvGnHtHUEQQIoMo+NSp0n
	 +Ra1lN3VF19LyPr9lLJDU15NfMoHGwZXnvStGG3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petar Gligoric <petar.gligoric@rohde-schwarz.com>,
	Hagen Paul Pfeifer <hagen@jauu.net>,
	Aditya Gupta <adityag@linux.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 393/431] perf test: Set PERF_EXEC_PATH for script execution
Date: Sun,  9 Jul 2023 13:15:41 +0200
Message-ID: <20230709111500.387094274@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit e4ef3ef1bc0a3d2535427da78b8095ef657eb474 ]

The task-analyzer.py script (actually every other scripts too) requires
PERF_EXEC_PATH env to find dependent libraries and scripts. For scripts
test to run correctly, it needs to set PERF_EXEC_PATH to the perf tool
source directory.

Instead of blindly update the env, let's check the directory structure
to make sure it points to the correct location.

Fixes: e8478b84d6ba ("perf test: add new task-analyzer tests")
Cc: Petar Gligoric <petar.gligoric@rohde-schwarz.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Aditya Gupta <adityag@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_task_analyzer.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/tests/shell/test_task_analyzer.sh b/tools/perf/tests/shell/test_task_analyzer.sh
index 1b7f3c1ec218b..365b61aea519a 100755
--- a/tools/perf/tests/shell/test_task_analyzer.sh
+++ b/tools/perf/tests/shell/test_task_analyzer.sh
@@ -5,6 +5,12 @@
 tmpdir=$(mktemp -d /tmp/perf-script-task-analyzer-XXXXX)
 err=0
 
+# set PERF_EXEC_PATH to find scripts in the source directory
+perfdir=$(dirname "$0")/../..
+if [ -e "$perfdir/scripts/python/Perf-Trace-Util" ]; then
+  export PERF_EXEC_PATH=$perfdir
+fi
+
 cleanup() {
   rm -f perf.data
   rm -f perf.data.old
-- 
2.39.2



