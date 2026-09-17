Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D1F4B44C4;
	Thu, 17 Sep 2026 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671330; cv=none; b=bQ8hYp5GFcQglCq/PVm7Q6eifNpZh4lIRYmtY6A3eX80ZPbKxguy1sLrbIgLdX3imLgG/dbiswj9S3LQaTWCq0sS7H3GNl8KToznFjDHT7ahn39alg06SJMf9pWYJgdnE4CVhWOJOhx5OGvr/JtAgQayMiHaJ5r906v+5IMhMkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671330; c=relaxed/simple;
	bh=AolWxVvYr52Qb364OU7lJFOzZWRCCIDjbnKglb2M+6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdlCfXZ3hzBN7rQ8gaxZBwJYVglsPHa99oiFh1G0h6BqRqW/6lZBBMRQ7XrF8qX25IyuXlILlXzAcqh+AG63DkmYjDdUTqxuWLvakWjUjuE9Lq3aeEBAmbN1OWtye9g6wQfjZSgniem2ikl+LyeAMXMH4WAENDnEIFxQnbzB1a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBGZNjMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBGZNjMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135911F000FF;
	Thu, 17 Sep 2026 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671328;
	bh=gLEZqNYYarg9yKb4Or87h62gt/Dapxh5VWVXj+QJin0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBGZNjMzrjUXQkNQ982Zp5k4jFbWZkT16A/aV+6Rx7yHXmSta425RCR+5YzAlpjEC
	 aWFlw1/NSzxoTGS9hHPMPrFm3gziKzXguamtwWhlTM9/D++Q9nGEqC+7XzfStpT6uE
	 EAW7uLhPr2k1S3wnGpq4Xa2yGfEbR9snoB5FPjOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0940/1102] Revert "perf tests: Fix flakiness in BPF counters test on hybrid systems"
Date: Thu, 17 Sep 2026 16:14:43 +0100
Message-ID: <20260917151604.243606026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

This reverts commit a5e14624e1e0e06363a11880f2872f67eaf6d921.

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



