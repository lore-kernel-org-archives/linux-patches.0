Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23BC2BCF4C;
	Sat, 12 Sep 2026 18:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238240; cv=none; b=AV78GYPMeSla4S3urJFizqVCWWxtS4UizkJ5P+v6Q79tiPg0tL2dXlfWNJAMskZn3N+aU4cNxI2Qp6XiNnGu4dgUrek1EPOrCKxXtXKfdba7YGU3V/KfmESOsLMwADq2J1DkTMRnA1kSbet1/4OWZBDsunTXUz85QVMQhH1VNzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238240; c=relaxed/simple;
	bh=8V4KCLaSqD2ebylXFQtBuo19N3NGLBS7ssa7D9jb3Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcHPyYDu/0/YOdbb4ymksOw0+0bjdIRUCy+R/J/DsqDc/abnzsFNPhFqAtlPnnoWLVUtnMzQcxImUH/gDGQs8IyhtGgoMg+3Jl1N7G+jKujkkRDhHsz9VeOMPhUOTkLoewZrOTTXfqKqUL7Ry9WL4OAbqp/0AOphl8awYsp29vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VX9Wd+iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VX9Wd+iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EA41F000FF;
	Sat, 12 Sep 2026 18:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238238;
	bh=e/azgSZCD16ovWcGPmsZd2Nr1WzZx465NTmuBWNICwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VX9Wd+ivwvmALjBMTrh6btBB72VsSPTpTl1hjMWJDG212hFOXU/Jz7XiyGYGyy5OX
	 9g3zmUIVYl2mndIjEY1ilNXVZBRgabkApIPpt1X2sZj4ezswFUo9EJeOhky/KywP1s
	 uITnZyd5RVRXfQaCa1aeS/aauMP1hHDvbjfyZkA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/935] perf tests: Fix flakiness in BPF counters test on hybrid systems
Date: Sat, 12 Sep 2026 08:57:31 +0200
Message-ID: <20260912065536.479738528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit b02027776ac5bf737f1b76f3759f405e376097e5 ]

The `perf stat --bpf-counters test` fails intermittently on hybrid
architectures or systems with dynamic frequency scaling (DVFS). This
happens because the test workload (`sqrtloop`) runs for a fixed 1-second
duration, and the CPU frequency can scale dynamically between idle and
maximum frequency. As the first run runs on a cold CPU and the second run
runs on a warmed-up CPU (or vice versa), the number of instructions
executed in 1 second differs by up to 2.2x, violating the comparison
tolerance.

Also, when running as root, BPF tracepoints and scheduling programs
trigger frequently. Since standard `perf stat -e instructions` measures
both user and kernel space instructions, it counts BPF helper and program
execution overheads, whereas the BPF counters themselves do not self-
measure. This introduces a large kernel-space instruction count
discrepancy between standard and BPF counters.

Fix these issues by:
1. Switching the workload to a strictly deterministic, iteration-based
   workload: `awk 'BEGIN { for (i=0; i<10000000; i++) sum+=i }'`. We pin
the
   workload to a single random allowed CPU using `taskset -c $CPU` via a
bash array.
2. Restricting the counted event to user-space only (`instructions:u` or
`/u`).
3. Tightening the comparison tolerance from 20% to 15%.

These modifications isolate the measurements to user-space instructions of
the deterministic loop, which executes a virtually identical number of
instructions on both runs (with less than 0.001% variation), eliminating
Dynamic Frequency Scaling (DVFS), kernel scheduling noise, and BPF helper
self-measurement overheads.

Fixes: 2c0cb9f56020 ("perf test: Add a shell test for 'perf stat --bpf-counters' new option")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_bpf_counters.sh | 28 +++++++++++++--------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
index b776ee2e445a6..76d4a7f15a43d 100755
--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -4,21 +4,26 @@
 
 set -e
 
-workload="perf test -w sqrtloop"
+# Get the first allowed CPU
+CPU=$(taskset -c -p $$ | awk -F': ' '{print $2}' | awk -F'[,-]' '{print $1}')
+if [ -z "$CPU" ]; then
+	CPU=0
+fi
+workload=(taskset -c "$CPU" awk 'BEGIN { for (i=0; i<10000000; i++) sum+=i }')
 
-# check whether $2 is within +/- 20% of $1
+# check whether $2 is within +/- 15% of $1
 compare_number()
 {
 	first_num=$1
 	second_num=$2
 
-	# upper bound is first_num * 120%
-	upper=$(expr $first_num + $first_num / 5 )
-	# lower bound is first_num * 80%
-	lower=$(expr $first_num - $first_num / 5 )
+	# upper bound is first_num * 115%
+	upper=$(expr $first_num + $first_num / 20 \* 3 )
+	# lower bound is first_num * 85%
+	lower=$(expr $first_num - $first_num / 20 \* 3 )
 
 	if [ $second_num -gt $upper ] || [ $second_num -lt $lower ]; then
-		echo "The difference between $first_num and $second_num are greater than 20%."
+		echo "The difference between $first_num and $second_num are greater than 15%."
 		exit 1
 	fi
 }
@@ -41,11 +46,12 @@ check_counts()
 test_bpf_counters()
 {
 	printf "Testing --bpf-counters "
-	base_instructions=$(perf stat --no-big-num -e instructions -- $workload 2>&1 | \
+	base_instructions=$(perf stat --no-big-num -e instructions:u -- "${workload[@]}" 2>&1 | \
 				awk -v i=0 -v c=0 '/instructions/ { \
 					if ($1 != "<not") { i++; c += $1 } \
 				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
-	bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions -- $workload  2>&1 | \
+	bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions:u \
+				-- "${workload[@]}"  2>&1 | \
 				awk -v i=0 -v c=0 '/instructions/ { \
 					if ($1 != "<not") { i++; c += $1 } \
 				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
@@ -57,7 +63,9 @@ test_bpf_counters()
 test_bpf_modifier()
 {
 	printf "Testing bpf event modifier "
-	stat_output=$(perf stat --no-big-num -e instructions/name=base_instructions/,instructions/name=bpf_instructions/b -- $workload 2>&1)
+	stat_output=$(perf stat --no-big-num \
+		-e instructions/name=base_instructions/u,instructions/name=bpf_instructions/bu \
+		-- "${workload[@]}" 2>&1)
 	base_instructions=$(echo "$stat_output"| \
 				awk -v i=0 -v c=0 '/base_instructions/ { \
 					if ($1 != "<not") { i++; c += $1 } \
-- 
2.53.0



