Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3636C1C7B61;
	Tue, 27 Aug 2024 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770539; cv=none; b=dz8xAtwjaLpveeRveqWU7wSkX2cbhifOf6cc5eO/o0M/5zlTRwNhol/OOR6887kn0G+bDw745ZNz2HSu4jvz/9Qv6jqx21kFnzFAWMsK4EQIru/d6YSFuLmk63twTOPsaA1HnmAxqBWWOOvLn4E2HLvG/3+v+2V+XlM6wTE/S98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770539; c=relaxed/simple;
	bh=gChB20CZTuEPysysyPf5V+GWvFcrOky1K5nzyCInHBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dl4PcklBy2aZuXkyXJBQvvL/BD/yoN4X1c3vZamMeAKSDxa9ws8jeQQMOCmF/WM5ASa+R5pNrLOX/yMRkA1D5vWMoH6BAARPHNI/Z73ijW57ATD5FqbrLwKdZXz3NJkW9EDuvXhY7LN35XhwVrleDNmZnAlaxdVivJymM4L388M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AXB3VNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AXB3VNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9606DC4E698;
	Tue, 27 Aug 2024 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770539;
	bh=gChB20CZTuEPysysyPf5V+GWvFcrOky1K5nzyCInHBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AXB3VNyEWg8mmOjQjkTzHJAuwVi3jtJQEJ2AHuhZFi02DZFaXPaRc0TQlQci/iNI
	 Cv4oJaxFzzBDgu76cxNf90VshlIrS0VbHzE/zVlLeUWSc43pc1kDZz5HUfl9nDIMEs
	 IE+SmgbuqWQDBVbmzTN7Y33mCAHVax20lwjubLyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Brown <broonie@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/341] selftests/mm: log run_vmtests.sh results in TAP format
Date: Tue, 27 Aug 2024 16:37:39 +0200
Message-ID: <20240827143852.087443841@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit a3c5cc5129ef55ac6c69f468e5ee6e4b0cd8179c ]

When running tests on a CI system (e.g.  LAVA) it is useful to output test
results in TAP (Test Anything Protocol) format so that the CI can parse
the fine-grained results to show regressions.  Many of the mm selftest
binaries already output using the TAP format.  And the kselftests runner
(run_kselftest.sh) also uses the format.  CI systems such as LAVA can
already handle nested TAP reports.  However, with the mm selftests we have
3 levels of nesting (run_kselftest.sh -> run_vmtests.sh -> individual test
binaries) and the middle level did not previously support TAP, which
breaks the parser.

Let's fix that by teaching run_vmtests.sh to output using the TAP format.
Ideally this would be opt-in via a command line argument to avoid the
possibility of breaking anyone's existing scripts that might scrape the
output.  However, it is not possible to pass arguments to tests invoked
via run_kselftest.sh.  So I've implemented an opt-out option (-n), which
will revert to the existing output format.

Future changes to this file should be aware of 2 new conventions:

 - output that is part of the TAP reporting is piped through tap_output
 - general output is piped through tap_prefix

Link: https://lkml.kernel.org/r/20231214162434.3580009-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7c5e8d212d7d ("selftests: memfd_secret: don't build memfd_secret test on unsupported arches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/run_vmtests.sh | 51 +++++++++++++++++------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 7d31718ce8343..7fae86e482613 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -5,6 +5,7 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
+count_total=0
 count_pass=0
 count_fail=0
 count_skip=0
@@ -17,6 +18,7 @@ usage: ${BASH_SOURCE[0]:-$0} [ options ]
   -a: run all tests, including extra ones
   -t: specify specific categories to tests to run
   -h: display this message
+  -n: disable TAP output
 
 The default behavior is to run required tests only.  If -a is specified,
 will run all tests.
@@ -75,12 +77,14 @@ EOF
 }
 
 RUN_ALL=false
+TAP_PREFIX="# "
 
-while getopts "aht:" OPT; do
+while getopts "aht:n" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
 		"h") usage ;;
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
+		"n") TAP_PREFIX= ;;
 	esac
 done
 shift $((OPTIND -1))
@@ -182,30 +186,52 @@ fi
 VADDR64=0
 echo "$ARCH64STR" | grep "$ARCH" &>/dev/null && VADDR64=1
 
+tap_prefix() {
+	sed -e "s/^/${TAP_PREFIX}/"
+}
+
+tap_output() {
+	if [[ ! -z "$TAP_PREFIX" ]]; then
+		read str
+		echo $str
+	fi
+}
+
+pretty_name() {
+	echo "$*" | sed -e 's/^\(bash \)\?\.\///'
+}
+
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
+		local test=$(pretty_name "$*")
 		local title="running $*"
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
-		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep"
+		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep" | tap_prefix
 
-		"$@"
-		local ret=$?
+		("$@" 2>&1) | tap_prefix
+		local ret=${PIPESTATUS[0]}
+		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
-			echo "[PASS]"
+			echo "[PASS]" | tap_prefix
+			echo "ok ${count_total} ${test}" | tap_output
 		elif [ $ret -eq $ksft_skip ]; then
 			count_skip=$(( count_skip + 1 ))
-			echo "[SKIP]"
+			echo "[SKIP]" | tap_prefix
+			echo "ok ${count_total} ${test} # SKIP" | tap_output
 			exitcode=$ksft_skip
 		else
 			count_fail=$(( count_fail + 1 ))
-			echo "[FAIL]"
+			echo "[FAIL]" | tap_prefix
+			echo "not ok ${count_total} ${test} # exit=$ret" | tap_output
 			exitcode=1
 		fi
 	fi # test_selected
 }
 
+echo "TAP version 13" | tap_output
+
 CATEGORY="hugetlb" run_test ./hugepage-mmap
 
 shmmax=$(cat /proc/sys/kernel/shmmax)
@@ -222,9 +248,9 @@ CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 
 if test_selected "hugetlb"; then
-	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"
-	echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
-	echo "      hugetlb regression testing."
+	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"	  | tap_prefix
+	echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for" | tap_prefix
+	echo "      hugetlb regression testing."			  | tap_prefix
 fi
 
 CATEGORY="mmap" run_test ./map_fixed_noreplace
@@ -303,7 +329,7 @@ CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
-echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
+(echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
 CATEGORY="memfd_secret" run_test ./memfd_secret
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
@@ -358,6 +384,7 @@ CATEGORY="mkdirty" run_test ./mkdirty
 
 CATEGORY="mdwe" run_test ./mdwe_test
 
-echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}"
+echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
+echo "1..${count_total}" | tap_output
 
 exit $exitcode
-- 
2.43.0



