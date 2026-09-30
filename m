Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F384D4F93DB;
	Wed, 30 Sep 2026 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785595; cv=none; b=FIVKYDLSikf9GivFgXqr5GERwP+MnmBdgMbXjLSUVNpiNBPkinEdJL7SzAABQt+rK93tUPeM411oMT+MVv68uBC6tC7poqXYPp68jJ3dxbBAprVeWEnrlkbHWD9mQnACKu1S1sMqLQnr7G4P1hc0SX6M8FkvhkAQW1lWx15DsTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785595; c=relaxed/simple;
	bh=DrJamwhJmmwfn3d/TXvqSXeKPP27xSXq5Vi0VpnmhTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbpMFkDrH6duUfQW5K1mIOvXa/W4JCwNkl+g1sp/XgI50tNN0KuSjJ/VTE+3qSy40KiSxVthuBV+wTsxWKUk4Lh0mBllifbL5iv9Bz7/LnUeYDVRoRuOpaAfbj1iosnLbe+52cVuJ3L6gdxqaQP3H1vouVJ+9qw2sN3ABpSsBZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lr3AE3mJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lr3AE3mJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467231F00899;
	Wed, 30 Sep 2026 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785582;
	bh=LarswIPy2/zm1EhgRvyDNsOdaynNdk+kJN6tbgC36lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lr3AE3mJQuzg+cNbbI3bPmvpriqWyhg2OV1uFeTVIdx0USHPoHKGvVttCOlMDD0vW
	 poct9kNKBoTeDOWaMV9e5L6IQEBsL3klDEY4o791bnjVCyzp+pBnDDHQsyGsnW/Ou9
	 RLmvL7QfyqsXhF/3CV1jeH+jOoCWqgWmoEvN5TN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 560/982] Revert "perf tests: Fix flakiness in BPF counters test on hybrid systems"
Date: Wed, 30 Sep 2026 17:21:36 +0200
Message-ID: <20260930152428.802376231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

This reverts commit 08c1316f983d3e1777f9087bb466dc5cf9a476f8.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_bpf_counters.sh | 28 ++++++++-------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
index 76d4a7f15a43d..b776ee2e445a6 100755
--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -4,26 +4,21 @@
 
 set -e
 
-# Get the first allowed CPU
-CPU=$(taskset -c -p $$ | awk -F': ' '{print $2}' | awk -F'[,-]' '{print $1}')
-if [ -z "$CPU" ]; then
-	CPU=0
-fi
-workload=(taskset -c "$CPU" awk 'BEGIN { for (i=0; i<10000000; i++) sum+=i }')
+workload="perf test -w sqrtloop"
 
-# check whether $2 is within +/- 15% of $1
+# check whether $2 is within +/- 20% of $1
 compare_number()
 {
 	first_num=$1
 	second_num=$2
 
-	# upper bound is first_num * 115%
-	upper=$(expr $first_num + $first_num / 20 \* 3 )
-	# lower bound is first_num * 85%
-	lower=$(expr $first_num - $first_num / 20 \* 3 )
+	# upper bound is first_num * 120%
+	upper=$(expr $first_num + $first_num / 5 )
+	# lower bound is first_num * 80%
+	lower=$(expr $first_num - $first_num / 5 )
 
 	if [ $second_num -gt $upper ] || [ $second_num -lt $lower ]; then
-		echo "The difference between $first_num and $second_num are greater than 15%."
+		echo "The difference between $first_num and $second_num are greater than 20%."
 		exit 1
 	fi
 }
@@ -46,12 +41,11 @@ check_counts()
 test_bpf_counters()
 {
 	printf "Testing --bpf-counters "
-	base_instructions=$(perf stat --no-big-num -e instructions:u -- "${workload[@]}" 2>&1 | \
+	base_instructions=$(perf stat --no-big-num -e instructions -- $workload 2>&1 | \
 				awk -v i=0 -v c=0 '/instructions/ { \
 					if ($1 != "<not") { i++; c += $1 } \
 				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
-	bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions:u \
-				-- "${workload[@]}"  2>&1 | \
+	bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions -- $workload  2>&1 | \
 				awk -v i=0 -v c=0 '/instructions/ { \
 					if ($1 != "<not") { i++; c += $1 } \
 				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
@@ -63,9 +57,7 @@ test_bpf_counters()
 test_bpf_modifier()
 {
 	printf "Testing bpf event modifier "
-	stat_output=$(perf stat --no-big-num \
-		-e instructions/name=base_instructions/u,instructions/name=bpf_instructions/bu \
-		-- "${workload[@]}" 2>&1)
+	stat_output=$(perf stat --no-big-num -e instructions/name=base_instructions/,instructions/name=bpf_instructions/b -- $workload 2>&1)
 	base_instructions=$(echo "$stat_output"| \
 				awk -v i=0 -v c=0 '/base_instructions/ { \
 					if ($1 != "<not") { i++; c += $1 } \
-- 
2.53.0



