Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F76386567;
	Sat, 12 Sep 2026 18:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238227; cv=none; b=lcSmLv8utp5O8as/shXaPb5FAcw/eauppaDuc7NDSb1zRx2/3xshzAReG+1xteoe4p03zlIzglVNl5GPOGfGO7N14ItjrT5zoCbrP/BROzSIX2D2OJ8EJiT8fLTXRyXtwyQ6rIDAwLz8iNCClQwEGm+5Cg6QisY4SgkWD2Lx+VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238227; c=relaxed/simple;
	bh=CkAgOZc66Jnykty5ecu/ix7rOeK/DvvtkS7iybpCR54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJbd35AV8fb2No6GS2oKG8kAylSgZFozB3tW81iZVtyaV0FkNWLjzonzMQ82MyAY3Wz4XL9I2+kfzeOPxUqhqCK+wElw2ga2sPmWOOMDtgElwgKhwsyoqKp4d3wNkqrxIht3Qfw2RQ/gkGNdjxFIG/U9gozeU6FeZ7CHMHKktt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6x6wde5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6x6wde5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E414F1F000FF;
	Sat, 12 Sep 2026 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238223;
	bh=LToN7KPY3WedoR+frKu9LkXr+oHasJ/DM5shev0vvqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6x6wde5kty1eXj3bF0SheFO55vHp+X7O4sCTCvhJA/vPfRLbydzb2CHJ46Ecp++V
	 N8n35uYlclRqI3zbAIk31yhTtepLDQyJ6A/nYOrCBWZ5ia9y0IaVCOyccnEAl2yCOd
	 oarRyqMN16W7eYoCP76sgYzL8nkxHAfe1UnsYnFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	mpetlan@redhat.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/935] perf test stat_bpf_counter.sh: Stabilize the test results
Date: Sat, 12 Sep 2026 08:57:28 +0200
Message-ID: <20260912065536.408737898@linuxfoundation.org>
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

From: Veronika Molnarova <vmolnaro@redhat.com>

[ Upstream commit e8b86f0311a4b721663df8105a680e5968f21d4c ]

The test has been failing for some time when two separate runs of
perf benchmarks are recorded for cycles events and their counts are
compared, while once the recording was done with option --bpf-counters
and once without it. It is expected that the count of the samples
should be within a certain range, firstly the difference was set to be
within 10%, which was then later raised to 20%. However, the test case
keeps failing on certain architectures as recording the provided
benchmark can produce completely different counts based on the
current load of the system.

Sampling two separate runs on intel-eaglestream-spr-13 of "perf stat
--no-big-num -e cycles -- perf bench sched messaging -g 1 -l 100 -t":

 Performance counter stats for 'perf bench sched messaging -g 1 -l 100 -t':

         396782898      cycles

       0.010051983 seconds time elapsed

       0.008664000 seconds user
       0.097058000 seconds sys

 Performance counter stats for 'perf bench sched messaging -g 1 -l 100 -t':

        1431133032      cycles

       0.021803714 seconds time elapsed

       0.023377000 seconds user
       0.349918000 seconds sys

, which is ranging from 400mil to 1400mil samples.

Instead of recording the cycles use instructions event, which provides
more stable values. At the same time change the tested workload to one
of the provided testing workloads by perf that is not based on a
scheduler, which can provide another dependency on the current load.

Sampling instructions event with the new workload provide much more
stable results on intel-eaglestream-spr-13 of "perf stat --no-big-num
-e instructions -- perf test -w brstack":

 Performance counter stats for 'perf test -w brstack':

          64584494      instructions

       0.009173945 seconds time elapsed

       0.007262000 seconds user
       0.002071000 seconds sys

 Performance counter stats for 'perf test -w brstack':

          64672669      instructions

       0.008888135 seconds time elapsed

       0.005018000 seconds user
       0.004018000 seconds sys

Signed-off-by: Veronika Molnarova <vmolnaro@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: mpetlan@redhat.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240625092001.10909-1-vmolnaro@redhat.com
Stable-dep-of: b02027776ac5 ("perf tests: Fix flakiness in BPF counters test on hybrid systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_bpf_counters.sh | 36 ++++++++++-----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
index 61f8149d854e1..f250b7d6f773f 100755
--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -4,7 +4,7 @@
 
 set -e
 
-workload="perf bench sched messaging -g 1 -l 100 -t"
+workload="perf test -w brstack"
 
 # check whether $2 is within +/- 20% of $1
 compare_number()
@@ -25,15 +25,15 @@ compare_number()
 
 check_counts()
 {
-	base_cycles=$1
-	bpf_cycles=$2
+	base_instructions=$1
+	bpf_instructions=$2
 
-	if [ "$base_cycles" = "<not" ]; then
-		echo "Skipping: cycles event not counted"
+	if [ "$base_instructions" = "<not" ]; then
+		echo "Skipping: instructions event not counted"
 		exit 2
 	fi
-	if [ "$bpf_cycles" = "<not" ]; then
-		echo "Failed: cycles not counted with --bpf-counters"
+	if [ "$bpf_instructions" = "<not" ]; then
+		echo "Failed: instructions not counted with --bpf-counters"
 		exit 1
 	fi
 }
@@ -41,29 +41,29 @@ check_counts()
 test_bpf_counters()
 {
 	printf "Testing --bpf-counters "
-	base_cycles=$(perf stat --no-big-num -e cycles -- $workload 2>&1 | awk '/cycles/ {print $1}')
-	bpf_cycles=$(perf stat --no-big-num --bpf-counters -e cycles -- $workload  2>&1 | awk '/cycles/ {print $1}')
-	check_counts $base_cycles $bpf_cycles
-	compare_number $base_cycles $bpf_cycles
+	base_instructions=$(perf stat --no-big-num -e instructions -- $workload 2>&1 | awk '/instructions/ {print $1}')
+	bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions -- $workload  2>&1 | awk '/instructions/ {print $1}')
+	check_counts $base_instructions $bpf_instructions
+	compare_number $base_instructions $bpf_instructions
 	echo "[Success]"
 }
 
 test_bpf_modifier()
 {
 	printf "Testing bpf event modifier "
-	stat_output=$(perf stat --no-big-num -e cycles/name=base_cycles/,cycles/name=bpf_cycles/b -- $workload 2>&1)
-	base_cycles=$(echo "$stat_output"| awk '/base_cycles/ {print $1}')
-	bpf_cycles=$(echo "$stat_output"| awk '/bpf_cycles/ {print $1}')
-	check_counts $base_cycles $bpf_cycles
-	compare_number $base_cycles $bpf_cycles
+	stat_output=$(perf stat --no-big-num -e instructions/name=base_instructions/,instructions/name=bpf_instructions/b -- $workload 2>&1)
+	base_instructions=$(echo "$stat_output"| awk '/base_instructions/ {print $1}')
+	bpf_instructions=$(echo "$stat_output"| awk '/bpf_instructions/ {print $1}')
+	check_counts $base_instructions $bpf_instructions
+	compare_number $base_instructions $bpf_instructions
 	echo "[Success]"
 }
 
 # skip if --bpf-counters is not supported
-if ! perf stat -e cycles --bpf-counters true > /dev/null 2>&1; then
+if ! perf stat -e instructions --bpf-counters true > /dev/null 2>&1; then
 	if [ "$1" = "-v" ]; then
 		echo "Skipping: --bpf-counters not supported"
-		perf --no-pager stat -e cycles --bpf-counters true || true
+		perf --no-pager stat -e instructions --bpf-counters true || true
 	fi
 	exit 2
 fi
-- 
2.53.0



