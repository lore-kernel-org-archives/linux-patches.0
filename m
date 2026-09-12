Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3F2370AE5;
	Sat, 12 Sep 2026 09:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206245; cv=none; b=GFhDbOkrfhjFdlczAr+6fIDGE2H3YjORGnEe/YldX614jdwuGdAjHKHee3cslwI22lEPZsr4f9562bffBseewWNREnzZYcZkBl0JRF6WB/gyy1wVyd/BPIsxJpke/qiUth1js0P6sB9+5qSE9AldVuGRSDL328X2mHJ4k1O03bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206245; c=relaxed/simple;
	bh=J9lfkTnA3FwwcDBtodOrZ0htoWgDusqFPrWyLQmG6yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dj9BZR85j1ilcBioYcc0yGsjiYGFYUhsvqYli7I7BIBUwEE+f4oslkNL1+e9MC49eIOZ4ZTFDXCkJSF8bd047jiDuD5mYRqRWaxdTXa8ldW2BgNgPJQIAdCjqP3RGrT3a43KuPnQ08mDCF32A9Cpb2T+dcdaU4NyQT8HK5A/1EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1ORHh7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1ORHh7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC25A1F000FF;
	Sat, 12 Sep 2026 09:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206243;
	bh=m7LXsz6uXhiJONZmkgKPdIxf6gHdpJAsnYu0RYN/5f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1ORHh7z8F+EFVIQ30F7jjwbBEK89PAHolH/ddfYXNQds+143FMtekwZcVYOkTAxl
	 kXmK8zA3jL764r6DTMJKwNJlor6aMp2PTk2XBmvpxP31pL7p8uOvuh8SVxB2lioezg
	 i8yd8SJpHh/RA2Y4wRW7wm5pf3WH8aXoEWtRwoYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0166/1518] perf tests: Fix flakiness in branch stack sampling tests
Date: Sat, 12 Sep 2026 08:38:55 +0200
Message-ID: <20260912065627.251705377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 344d3aec164dba83a5520f23a0d46e13e904a205 ]

The branch stack sampling test (test 130) runs short iteration-based
workloads to verify syscall, kernel, and trap branch stack sampling.
Specifically, `test_syscall()` and `test_kernel_branches()` run `perf
bench syscall basic` with loop counts of 8000 and 1000, and
`test_trap_eret_branches()` runs `traploop` with 1000 iterations.

Because these loop limits are extremely small, the total benchmark
runtimes last only a few milliseconds (or less). Under high load,
virtualization, or coarse sampling conditions, PMU cycle sampling fails to
capture enough samples inside the brief benchmark loops. This leads to
false negatives where the script output lacks the expected syscall,
kernel, or trap branch entries (e.g. "ERROR: Branches missing getppid[^
]*/SYSCALL/").

Fix this by increasing the workload loop counts to 100,000 across all
three test sections. Running 100,000 loops still finishes virtually
instantaneously (less than 0.1 seconds), but generates enough iterations
to guarantee robust branch stack capture.

Fixes: b55878c90ab9 ("perf test: Add test for branch stack sampling")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_brstack.sh | 107 +++++++++++++++----------
 1 file changed, 66 insertions(+), 41 deletions(-)

diff --git a/tools/perf/tests/shell/test_brstack.sh b/tools/perf/tests/shell/test_brstack.sh
index eb5837f82e390..71550e0b37baa 100755
--- a/tools/perf/tests/shell/test_brstack.sh
+++ b/tools/perf/tests/shell/test_brstack.sh
@@ -110,20 +110,29 @@ test_trap_eret_branches() {
 		return
 	fi
 	start_err=$err
-	err=0
-	perf record -o $TMPDIR/perf.data --branch-filter any,save_type,u,k -- \
-		perf test -w traploop 1000 > "$TMPDIR/record.txt" 2>&1
-	perf script -i $TMPDIR/perf.data --fields brstacksym | \
-		tr ' ' '\n' > $TMPDIR/perf.script
-
-	# BRBINF<n>.TYPE == TRAP are mapped to PERF_BR_IRQ by the BRBE driver
-	check_branches "^trap_bench\+[^ ]+/[^ ]/IRQ/"
-	check_branches "^[^ ]+/trap_bench\+[^ ]+/ERET/"
-	if [ $err -eq 0 ]; then
+	local ret=1
+	for loops in 1000 10000 100000; do
+		err=0
+		perf record -o $TMPDIR/perf.data --branch-filter any,save_type,u,k -- \
+			perf test -w traploop $loops > "$TMPDIR/record.txt" 2>&1
+		perf script -i $TMPDIR/perf.data --fields brstacksym | \
+			tr ' ' '\n' > $TMPDIR/perf.script
+
+		# BRBINF<n>.TYPE == TRAP are mapped to PERF_BR_IRQ by the BRBE driver
+		check_branches "^trap_bench\+[^ ]+/[^ ]/IRQ/"
+		check_branches "^[^ ]+/trap_bench\+[^ ]+/ERET/"
+		if [ $err -eq 0 ]; then
+			ret=0
+			break
+		fi
+	done
+
+	if [ $ret -eq 0 ]; then
 		echo "Testing trap & eret branches [Passed]"
 		err=$start_err
 	else
 		echo "Testing trap & eret branches [Failed]"
+		err=1
 	fi
 }
 
@@ -135,32 +144,40 @@ test_kernel_branches() {
 		return
 	fi
 	start_err=$err
-	err=0
-	perf record -o $TMPDIR/perf.data --branch-filter any,k -- \
-		perf bench syscall basic --loop 1000 > "$TMPDIR/record.txt" 2>&1
-	perf script -i $TMPDIR/perf.data --fields brstack | \
-		tr ' ' '\n' > $TMPDIR/perf.script
-
-	# Example of branch entries:
-	#       "0xffffffff93bda241/0xffffffff93bda20f/M/-/-/..."
-	# Source addresses come first in user or kernel code. Next is the target
-	# address that must be in the kernel.
-
-	# Look for source addresses with top bit set
-	if ! grep -q -E -m1 "^0x[89a-f][0-9a-f]{15}" $TMPDIR/perf.script; then
-		echo "Testing kernel branch sampling [Failed kernel branches missing]"
-		err=1
-	fi
-	# Look for no target addresses without top bit set
-	if grep -q -E -m1 "^0x[0-9a-f]{0,16}/0x[0-7][0-9a-f]{1,15}/" $TMPDIR/perf.script; then
-		echo "Testing kernel branch sampling [Failed user branches found]"
-		err=1
-	fi
-	if [ $err -eq 0 ]; then
+	local ret=1
+	for loops in 1000 10000 100000; do
+		err=0
+		perf record -o $TMPDIR/perf.data --branch-filter any,k -- \
+			perf bench syscall basic --loop $loops > "$TMPDIR/record.txt" 2>&1
+		perf script -i $TMPDIR/perf.data --fields brstack | \
+			tr ' ' '\n' > $TMPDIR/perf.script
+
+		# Example of branch entries:
+		#       "0xffffffff93bda241/0xffffffff93bda20f/M/-/-/..."
+		# Source addresses come first in user or kernel code. Next is the target
+		# address that must be in the kernel.
+
+		# Look for source addresses with top bit set
+		if ! grep -q -E -m1 "^0x[89a-f][0-9a-f]{15}" $TMPDIR/perf.script; then
+			err=1
+		fi
+		# Look for no target addresses without top bit set
+		if grep -q -E -m1 "^0x[0-9a-f]{0,16}/0x[0-7][0-9a-f]{1,15}/" \
+			$TMPDIR/perf.script; then
+			err=1
+		fi
+		if [ $err -eq 0 ]; then
+			ret=0
+			break
+		fi
+	done
+
+	if [ $ret -eq 0 ]; then
 		echo "Testing kernel branch sampling [Passed]"
 		err=$start_err
 	else
 		echo "Testing kernel branch sampling [Failed]"
+		err=1
 	fi
 }
 
@@ -206,20 +223,28 @@ test_syscall() {
 		return
 	fi
 	start_err=$err
-	err=0
-	perf record -o $TMPDIR/perf.data --branch-filter \
-		any_call,save_type,u,k -c 10007 -- \
-		perf bench syscall basic --loop 8000  > "$TMPDIR/record.txt" 2>&1
-	perf script -i $TMPDIR/perf.data --fields brstacksym | \
-		tr ' ' '\n' > $TMPDIR/perf.script
-
-	check_branches "getppid[^ ]*/SYSCALL/"
+	local ret=1
+	for loops in 8000 30000 100000; do
+		err=0
+		perf record -o $TMPDIR/perf.data --branch-filter \
+			any_call,save_type,u,k -c 10007 -- \
+			perf bench syscall basic --loop $loops  > "$TMPDIR/record.txt" 2>&1
+		perf script -i $TMPDIR/perf.data --fields brstacksym | \
+			tr ' ' '\n' > $TMPDIR/perf.script
+
+		check_branches "getppid[^ ]*/SYSCALL/"
+		if [ $err -eq 0 ]; then
+			ret=0
+			break
+		fi
+	done
 
-	if [ $err -eq 0 ]; then
+	if [ $ret -eq 0 ]; then
 		echo "Testing syscalls [Passed]"
 		err=$start_err
 	else
 		echo "Testing syscalls [Failed]"
+		err=1
 	fi
 }
 set -e
-- 
2.53.0



