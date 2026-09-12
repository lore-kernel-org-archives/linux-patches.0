Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F8C472091;
	Sat, 12 Sep 2026 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228984; cv=none; b=e3BphhCB68KCymXSCxQ+YoFbv+Ripy0Kd/CAcT9gkA0zus0mOK5uJ+lullHwE2vZor6nOZ7mCEUJsZyFokmCy7emADQ0KaEduXQkpBf9Bf74P20bVsWMSr7dd412LhyYX3mUIrByzVhcdUuNU/qODEXcvMiKQqr9TvadZ2xvgUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228984; c=relaxed/simple;
	bh=GgfCyVNnv5dcSrkuavKAHomzZ0s4jPCPqVS2/DYVnxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RL8ZGSKFYe7D9IHOdqjrK26SuKdeRIitRHas9Vg+Yim2yNCTfhhjCfFTPQs6IC1FBeH/7xMPtZo2H6nURmo0G3byX0tz4IUdb7GrjfVKnLMH7RhUTQw0mQ04fFYsTbyM5NGcxuudOWfhzIGcSEJmcyG2VOCF8M1qNYUnnkok5Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xas3odlq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xas3odlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944C21F000FF;
	Sat, 12 Sep 2026 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228982;
	bh=2Kv3PbYHwpzejTPVatfFinHtZo1Nm/DgjN3jePuPSU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xas3odlqU4e99kG9pIxcejYhfS+r/pyOu5lG9BsjeRnkhw8ZrYWfbfynUBhIwtC1u
	 BbhCVEM0QxWwcvfBlivBTak3c9vhvAI35Lez3aJ733/GcM+19Nsa5YQg/6MmZJlOa5
	 wQHytyqvy1JVFoAJVnVYeK0vlJP+8sTBctAUjjZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	mpetlan@redhat.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0496/1191] perf test stat_bpf_counter.sh: Stabilize the test results
Date: Sat, 12 Sep 2026 08:53:44 +0200
Message-ID: <20260912065559.374238214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



