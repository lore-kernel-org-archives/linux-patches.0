Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D1A34252D;
	Sat, 12 Sep 2026 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214638; cv=none; b=mbhTMEX8HJ04iC5OO0290+PP74NAB63MrpXr8v9nZQcNUwH5dnwAWe6PBi5OBAiISE4sJdkdNt/K20JQZFxMIQfTrk0UnTVnG83XvRU0opU+uxXZeLswi0Fb2JaF9zmOSjuGNxOX/xxiCbG3Vlov/AeyX7YTi7ByDTW1kbKRMlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214638; c=relaxed/simple;
	bh=mRxXHKZiWpZxnI1lfWmo+zg2cXR9NMVyeJDbOnQ8fTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwxL1m8ZQRn+p9TUMGz6YYBvKdPLhjNv3JXO3dNq+WUd3lmENSAK+tymPTrzE/AwfRB/c+INGIXfHHOxUWtAsVThr8SjXsMM1wsMaRhIbc2Z6R+PrRh1RnbVPW1+c72hSbsftxSZNHUsT2dJQo/+ARYgxPGUuhM4EeS5OTVKckw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbyKiUwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbyKiUwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B061F000FF;
	Sat, 12 Sep 2026 12:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214636;
	bh=9KIj699/0M+3pGyVDwkQzEb1bgSRC1zCOH+PZRfL7kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VbyKiUwlvM78/UICKT0gKYBPJAexZTmbkz8Jl3CpBZz+HS/j3+64QNygRa6a24q/o
	 GolHdxjWkINyYW9KLTzqIvjaXRdrwqqJ8GizzJtzZeGOInV+Oy4vrzQKkSabeo9u6i
	 2EpepSxIwZj0gTKxV2FKMbc9pmBNDms707WGW0qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0366/1376] perf test: Fixes for check branch stack sampling
Date: Sat, 12 Sep 2026 08:46:32 +0200
Message-ID: <20260912065615.707916893@linuxfoundation.org>
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

[ Upstream commit 86d1095fdb7017a93e9d7be875775f7e5aa5c2f5 ]

When filtering branch stack samples on user events they sample in user
land but may have come from the kernel. Aarch64 avoids leaking the
kernel address for kaslr reasons but other platforms, for now,
don't. Be more permissive in allowing kernel addresses in the source
of user branch stacks.

When filtering branch stack samples on kernel events they sample in
kernel land but may have come from user land. Avoid the target being a
user address but allow the source to be in user land. Aarch64 may not
leak the user land addresses (making them 0) but other platforms
do. As the kernel address sampling implies privelege, just allow this.

Increase the duration of the system call sampling test to make the
likelihood of sampling a system call higher (increased from 1000 to
8000 loops - a number found through experimentation on an Intel
Tigerlake laptop), also make the period of the event a prime number.

Put unneeded perf record output into a temporary file so that the test
output isn't cluttered. More clearly state which test is running and
the pass, fail or skipped result of the test.

These changes make the test on an Intel tigerlake laptop reliably pass
rather than reliably fail.

Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 344d3aec164d ("perf tests: Fix flakiness in branch stack sampling tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_brstack.sh | 146 ++++++++++++++++---------
 1 file changed, 96 insertions(+), 50 deletions(-)

diff --git a/tools/perf/tests/shell/test_brstack.sh b/tools/perf/tests/shell/test_brstack.sh
index 85233d435be63..eb5837f82e390 100755
--- a/tools/perf/tests/shell/test_brstack.sh
+++ b/tools/perf/tests/shell/test_brstack.sh
@@ -38,9 +38,13 @@ is_arm64() {
 	[ "$(uname -m)" = "aarch64" ];
 }
 
+has_kaslr_bug() {
+	[ "$(uname -m)" != "aarch64" ];
+}
+
 check_branches() {
 	if ! tr -s ' ' '\n' < "$TMPDIR/perf.script" | grep -E -m1 -q "$1"; then
-		echo "Branches missing $1"
+		echo "ERROR: Branches missing $1"
 		err=1
 	fi
 }
@@ -48,6 +52,8 @@ check_branches() {
 test_user_branches() {
 	echo "Testing user branch stack sampling"
 
+	start_err=$err
+	err=0
 	perf record -o "$TMPDIR/perf.data" --branch-filter any,save_type,u -- ${TESTPROG} > "$TMPDIR/record.txt" 2>&1
 	perf script -i "$TMPDIR/perf.data" --fields brstacksym > "$TMPDIR/perf.script"
 
@@ -73,59 +79,88 @@ test_user_branches() {
 	perf script -i "$TMPDIR/perf.data" --fields brstack | \
 		tr ' ' '\n' > "$TMPDIR/perf.script"
 
-	# There should be no kernel addresses with the u option, in either
-	# source or target addresses.
-	if grep -E -m1 "0x[89a-f][0-9a-f]{15}" $TMPDIR/perf.script; then
-		echo "ERROR: Kernel address found in user mode"
+	# There should be no kernel addresses in the target with the u option.
+	local regex="0x[89a-f][0-9a-f]{15}"
+	if has_kaslr_bug; then
+		# If the system has a kaslr bug that may leak kernel addresses
+		# in the source of something like an ERET/SYSRET. Make the regex
+		# more specific and just check the target address is in user
+		# code.
+		regex="^0x[0-9a-f]{0,16}/0x[89a-f][0-9a-f]{15}/"
+	fi
+	if grep -q -E -m1 "$regex" $TMPDIR/perf.script; then
+		echo "Testing user branch stack sampling [Failed kernel address found in user mode]"
 		err=1
 	fi
 	# some branch types are still not being tested:
 	# IND COND_CALL COND_RET SYSRET SERROR NO_TX
+	if [ $err -eq 0 ]; then
+		echo "Testing user branch stack sampling [Passed]"
+		err=$start_err
+	else
+		echo "Testing user branch stack sampling [Failed]"
+	fi
 }
 
 test_trap_eret_branches() {
 	echo "Testing trap & eret branches"
+
 	if ! is_arm64; then
-		echo "skip: not arm64"
+		echo "Testing trap & eret branches [Skipped not arm64]"
+		return
+	fi
+	start_err=$err
+	err=0
+	perf record -o $TMPDIR/perf.data --branch-filter any,save_type,u,k -- \
+		perf test -w traploop 1000 > "$TMPDIR/record.txt" 2>&1
+	perf script -i $TMPDIR/perf.data --fields brstacksym | \
+		tr ' ' '\n' > $TMPDIR/perf.script
+
+	# BRBINF<n>.TYPE == TRAP are mapped to PERF_BR_IRQ by the BRBE driver
+	check_branches "^trap_bench\+[^ ]+/[^ ]/IRQ/"
+	check_branches "^[^ ]+/trap_bench\+[^ ]+/ERET/"
+	if [ $err -eq 0 ]; then
+		echo "Testing trap & eret branches [Passed]"
+		err=$start_err
 	else
-		perf record -o $TMPDIR/perf.data --branch-filter any,save_type,u,k -- \
-			perf test -w traploop 1000
-		perf script -i $TMPDIR/perf.data --fields brstacksym | \
-			tr ' ' '\n' > $TMPDIR/perf.script
-
-		# BRBINF<n>.TYPE == TRAP are mapped to PERF_BR_IRQ by the BRBE driver
-		check_branches "^trap_bench\+[^ ]+/[^ ]/IRQ/"
-		check_branches "^[^ ]+/trap_bench\+[^ ]+/ERET/"
+		echo "Testing trap & eret branches [Failed]"
 	fi
 }
 
 test_kernel_branches() {
-	echo "Testing that k option only includes kernel source addresses"
+	echo "Testing kernel branch sampling"
 
-	if ! perf record --branch-filter any,k -o- -- true > /dev/null; then
-		echo "skip: not enough privileges"
+	if ! perf record --branch-filter any,k -o- -- true > "$TMPDIR/record.txt" 2>&1; then
+		echo "Testing that k option [Skipped not enough privileges]"
+		return
+	fi
+	start_err=$err
+	err=0
+	perf record -o $TMPDIR/perf.data --branch-filter any,k -- \
+		perf bench syscall basic --loop 1000 > "$TMPDIR/record.txt" 2>&1
+	perf script -i $TMPDIR/perf.data --fields brstack | \
+		tr ' ' '\n' > $TMPDIR/perf.script
+
+	# Example of branch entries:
+	#       "0xffffffff93bda241/0xffffffff93bda20f/M/-/-/..."
+	# Source addresses come first in user or kernel code. Next is the target
+	# address that must be in the kernel.
+
+	# Look for source addresses with top bit set
+	if ! grep -q -E -m1 "^0x[89a-f][0-9a-f]{15}" $TMPDIR/perf.script; then
+		echo "Testing kernel branch sampling [Failed kernel branches missing]"
+		err=1
+	fi
+	# Look for no target addresses without top bit set
+	if grep -q -E -m1 "^0x[0-9a-f]{0,16}/0x[0-7][0-9a-f]{1,15}/" $TMPDIR/perf.script; then
+		echo "Testing kernel branch sampling [Failed user branches found]"
+		err=1
+	fi
+	if [ $err -eq 0 ]; then
+		echo "Testing kernel branch sampling [Passed]"
+		err=$start_err
 	else
-		perf record -o $TMPDIR/perf.data --branch-filter any,k -- \
-			perf bench syscall basic --loop 1000
-		perf script -i $TMPDIR/perf.data --fields brstack | \
-			tr ' ' '\n' > $TMPDIR/perf.script
-
-		# Example of branch entries:
-		#       "0xffffffff93bda241/0xffffffff93bda20f/M/-/-/..."
-		# Source addresses come first and target address can be either
-		# userspace or kernel even with k option, as long as the source
-		# is in kernel.
-
-		#Look for source addresses with top bit set
-		if ! grep -E -m1 "^0x[89a-f][0-9a-f]{15}" $TMPDIR/perf.script; then
-			echo "ERROR: Kernel branches missing"
-			err=1
-		fi
-		# Look for no source addresses without top bit set
-		if grep -E -m1 "^0x[0-7][0-9a-f]{0,15}" $TMPDIR/perf.script; then
-			echo "ERROR: User branches found with kernel filter"
-			err=1
-		fi
+		echo "Testing kernel branch sampling [Failed]"
 	fi
 }
 
@@ -136,14 +171,15 @@ test_filter() {
 	test_filter_expect=$2
 
 	echo "Testing branch stack filtering permutation ($test_filter_filter,$test_filter_expect)"
-	perf record -o "$TMPDIR/perf.data" --branch-filter "$test_filter_filter,save_type,u" -- ${TESTPROG}  > "$TMPDIR/record.txt" 2>&1
+	perf record -o "$TMPDIR/perf.data" --branch-filter "$test_filter_filter,save_type,u" -- \
+		${TESTPROG}  > "$TMPDIR/record.txt" 2>&1
 	perf script -i "$TMPDIR/perf.data" --fields brstack > "$TMPDIR/perf.script"
 
 	# fail if we find any branch type that doesn't match any of the expected ones
 	# also consider UNKNOWN branch types (-)
 	if [ ! -s "$TMPDIR/perf.script" ]
 	then
-		echo "Empty script output"
+		echo "Testing branch stack filtering [Failed empty script output]"
 		err=1
 		return
 	fi
@@ -154,26 +190,36 @@ test_filter() {
 	  > "$TMPDIR/perf.script-filtered" || true
 	if [ -s "$TMPDIR/perf.script-filtered" ]
 	then
-		echo "Unexpected branch filter in script output"
+		echo "Testing branch stack filtering [Failed unexpected branch filter]"
 		cat "$TMPDIR/perf.script"
 		err=1
 		return
 	fi
+	echo "Testing branch stack filtering [Passed]"
 }
 
 test_syscall() {
 	echo "Testing syscalls"
 	# skip if perf doesn't have enough privileges
-	if ! perf record --branch-filter any,k -o- -- true > /dev/null; then
-		echo "skip: not enough privileges"
+	if ! perf record --branch-filter any,k -o- -- true > "$TMPDIR/record.txt" 2>&1; then
+		echo "Testing syscalls [Skipped: not enough privileges]"
+		return
+	fi
+	start_err=$err
+	err=0
+	perf record -o $TMPDIR/perf.data --branch-filter \
+		any_call,save_type,u,k -c 10007 -- \
+		perf bench syscall basic --loop 8000  > "$TMPDIR/record.txt" 2>&1
+	perf script -i $TMPDIR/perf.data --fields brstacksym | \
+		tr ' ' '\n' > $TMPDIR/perf.script
+
+	check_branches "getppid[^ ]*/SYSCALL/"
+
+	if [ $err -eq 0 ]; then
+		echo "Testing syscalls [Passed]"
+		err=$start_err
 	else
-		perf record -o $TMPDIR/perf.data --branch-filter \
-			any_call,save_type,u,k -c 10000 -- \
-			perf bench syscall basic --loop 1000
-		perf script -i $TMPDIR/perf.data --fields brstacksym | \
-			tr ' ' '\n' > $TMPDIR/perf.script
-
-		check_branches "getppid[^ ]*/SYSCALL/"
+		echo "Testing syscalls [Failed]"
 	fi
 }
 set -e
-- 
2.53.0



