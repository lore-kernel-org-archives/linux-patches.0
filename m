Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B038F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115D6C433C8;
	Sun, 16 Jul 2023 20:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538498;
	bh=WvwUjWJMfD0SL9pbZfYk/rYV+dUpluyu12Sr1ip0kUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikQQ21/O3/F5t01YhWyqBvxdoascI5TYChjXEHpbEnHkjBt7Q4cOM8Opssdw2ZjCW
	 6YMzRcRRacZ1v8T/t0CkuXn9c26z4+eVigp0CBQd2W+DwTnL0z1FK0fAykNYAquref
	 IYJk5EuIXcb+RW2x8vv7g1qhp7a65gSWnb6Z5wVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Gupta <adityag@linux.ibm.com>,
	Disha Goel <disgoel@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Petar Gligoric <petar.gligoric@rohde-schwarz.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linuxppc-dev@lists.ozlabs.org,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 473/800] perf tests task_analyzer: Skip tests if no libtraceevent support
Date: Sun, 16 Jul 2023 21:45:26 +0200
Message-ID: <20230716195000.067159112@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aditya Gupta <adityag@linux.ibm.com>

[ Upstream commit c3ac3b0779770acd3ad7eecb5099ab4419ef2e2e ]

Test "perf script task-analyzer tests" fails in environment with missing
libtraceevent support, as perf record fails to create the perf.data
file, which further tests depend on.

Instead, when perf is not compiled with libtraceevent support, skip
those tests instead of failing them, by checking the output of `perf
record --dry-run` to see if it prints the error "libtraceevent is
necessary for tracepoint support"

For the following output, perf compiled with: `make NO_LIBTRACEEVENT=1`

Before the patch:

108: perf script task-analyzer tests                                 :
test child forked, pid 24105
failed to open perf.data: No such file or directory  (try 'perf record' first)
FAIL: "invokation of perf script report task-analyzer command failed" Error message: ""
FAIL: "test_basic" Error message: "Failed to find required string:'Comm'."
failed to open perf.data: No such file or directory  (try 'perf record' first)
FAIL: "invokation of perf script report task-analyzer --ns --rename-comms-by-tids 0:random command failed" Error message: ""
FAIL: "test_ns_rename" Error message: "Failed to find required string:'Comm'."
failed to open perf.data: No such file or directory  (try 'perf record' first)
<...>
perf script task-analyzer tests: FAILED!

With this patch, the script instead returns 2 signifying SKIP, and after
the patch:

108: perf script task-analyzer tests                                 :
test child forked, pid 26010
libtraceevent is necessary for tracepoint support
WARN: Skipping tests. No libtraceevent support
test child finished with -2
perf script task-analyzer tests: Skip

Fixes: e8478b84d6ba9ccf ("perf test: Add new task-analyzer tests")
Signed-off-by: Aditya Gupta <adityag@linux.ibm.com>
Cc: Disha Goel <disgoel@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Petar Gligoric <petar.gligoric@rohde-schwarz.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20230613164145.50488-18-atrajeev@linux.vnet.ibm.com
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_task_analyzer.sh | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/perf/tests/shell/test_task_analyzer.sh b/tools/perf/tests/shell/test_task_analyzer.sh
index 6b3343234a6b2..1b7f3c1ec218b 100755
--- a/tools/perf/tests/shell/test_task_analyzer.sh
+++ b/tools/perf/tests/shell/test_task_analyzer.sh
@@ -44,9 +44,20 @@ find_str_or_fail() {
 	fi
 }
 
+# check if perf is compiled with libtraceevent support
+skip_no_probe_record_support() {
+	perf record -e "sched:sched_switch" -a -- sleep 1 2>&1 | grep "libtraceevent is necessary for tracepoint support" && return 2
+	return 0
+}
+
 prepare_perf_data() {
 	# 1s should be sufficient to catch at least some switches
 	perf record -e sched:sched_switch -a -- sleep 1 > /dev/null 2>&1
+	# check if perf data file got created in above step.
+	if [ ! -e "perf.data" ]; then
+		printf "FAIL: perf record failed to create \"perf.data\" \n"
+		return 1
+	fi
 }
 
 # check standard inkvokation with no arguments
@@ -134,6 +145,13 @@ test_csvsummary_extended() {
 	find_str_or_fail "Out-Out;" csvsummary ${FUNCNAME[0]}
 }
 
+skip_no_probe_record_support
+err=$?
+if [ $err -ne 0 ]; then
+	echo "WARN: Skipping tests. No libtraceevent support"
+	cleanup
+	exit $err
+fi
 prepare_perf_data
 test_basic
 test_ns_rename
-- 
2.39.2



