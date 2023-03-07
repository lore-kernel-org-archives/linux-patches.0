Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A892CBA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D11C433EF;
	Tue,  7 Mar 2023 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210214;
	bh=dxFSj10K1gAdGhzhQE+cReJR7o4SDTExojXack2sgcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXEaqvf03OH2uPj+tPGeha0503KVIR7SdBAj8nZKWpsvOcw4t35pyPgTsN0Kv+GET
	 UbHCz+DK6HxXEOGuoZbtLOTDzrhRuYIo2TaO13RWBIsRQ8ItMjJehv3l+UKzmaRVko
	 l+CRTZZ0hJ3BDR0V2goGVrl0WwCKR0+eIndElVw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Andi Kleen <ak@linux.intel.com>,
	Disha Goel <disgoel@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nageswara R Sastry <rnsastry@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Wang Nan <wangnan0@huawei.com>,
	linuxppc-dev@lists.ozlabs.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0470/1001] perf test bpf: Skip test if kernel-debuginfo is not present
Date: Tue,  7 Mar 2023 17:54:02 +0100
Message-Id: <20230307170041.792183851@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 34266f904abd45731bdade2e92d0536c092ee9bc ]

Perf BPF filter test fails in environment where "kernel-debuginfo"
is not installed.

Test failure logs:

  <<>>
  42: BPF filter                            :
  42.1: Basic BPF filtering                 : Ok
  42.2: BPF pinning                         : Ok
  42.3: BPF prologue generation             : FAILED!
  <<>>

Enabling verbose option provided debug logs, which says debuginfo
needs to be installed. Snippet of verbose logs:

  <<>>
  42.3: BPF prologue generation                                       :
  --- start ---
  test child forked, pid 28218
  <<>>
  Rebuild with CONFIG_DEBUG_INFO=y, or install an appropriate debuginfo
  package.
  bpf_probe: failed to convert perf probe events
  Failed to add events selected by BPF
  test child finished with -1
  ---- end ----
  BPF filter subtest 3: FAILED!
  <<>>

Here the subtest "BPF prologue generation" failed and logs shows
debuginfo is needed. After installing kernel-debuginfo package, testcase
passes.

The "BPF prologue generation" subtest failed because, the do_test()
returns TEST_FAIL without checking the error type returned by
parse_events_load_bpf_obj().

parse_events_load_bpf_obj() can also return error of type -ENODATA
incase kernel-debuginfo package is not installed. Fix this by adding
check for -ENODATA error.

Test result after the patch changes:

Test failure logs:

  <<>>
  42: BPF filter                 :
  42.1: Basic BPF filtering      : Ok
  42.2: BPF pinning              : Ok
  42.3: BPF prologue generation  : Skip (clang/debuginfo isn't installed or environment missing BPF support)
  <<>>

Fixes: ba1fae431e74bb42 ("perf test: Add 'perf test BPF'")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Disha Goel <disgoel@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nageswara R Sastry <rnsastry@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lore.kernel.org/linux-perf-users/Y7bIk77mdE4j8Jyi@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/bpf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/bpf.c b/tools/perf/tests/bpf.c
index 17c023823713d..6a4235a9cf57e 100644
--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -126,6 +126,10 @@ static int do_test(struct bpf_object *obj, int (*func)(void),
 
 	err = parse_events_load_bpf_obj(&parse_state, &parse_state.list, obj, NULL);
 	parse_events_error__exit(&parse_error);
+	if (err == -ENODATA) {
+		pr_debug("Failed to add events selected by BPF, debuginfo package not installed\n");
+		return TEST_SKIP;
+	}
 	if (err || list_empty(&parse_state.list)) {
 		pr_debug("Failed to add events selected by BPF\n");
 		return TEST_FAIL;
@@ -368,7 +372,7 @@ static struct test_case bpf_tests[] = {
 			"clang isn't installed or environment missing BPF support"),
 #ifdef HAVE_BPF_PROLOGUE
 	TEST_CASE_REASON("BPF prologue generation", bpf_prologue_test,
-			"clang isn't installed or environment missing BPF support"),
+			"clang/debuginfo isn't installed or environment missing BPF support"),
 #else
 	TEST_CASE_REASON("BPF prologue generation", bpf_prologue_test, "not compiled in"),
 #endif
-- 
2.39.2



