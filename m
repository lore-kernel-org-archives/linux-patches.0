Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C934737E5CF;
	Sat, 12 Sep 2026 12:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214599; cv=none; b=bTnRqF3dJxY6mvAhEA4GaitX86iJcsWVOlmrJ3aUVAtxEylj44mPLn4LXdDhdRAFrr2PsLDAwyKT1VxI8BQIat9PuUIGbEG3kCRoGSr58UyaMVnHXIh3DXX3s2yaeQ0X501qrSyVD7owmZMPxesI5jhRIB+5KGR6Jrg5LaNY2J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214599; c=relaxed/simple;
	bh=GHykiHbHdDd8PTwiEbgDHWKpJOjrEFG1KImWHSWLAoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEnrVjuI+E3chTFrzQ8FAMfAYqY3NWBzSasKqwjbRJyH4A6d7esGDgIsDQl9qL8k63ELoZBEHF/2imEJcsEz9FPtJkPZlTqzYQj/mLaJKDvPvHjmhNu0gknU5z8WjO7652BohpuRpXwUuP6IhCp8cxCP/rLtT72w/Cd6cJIbUpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oH/C2zTG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oH/C2zTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FDD1F000FF;
	Sat, 12 Sep 2026 12:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214597;
	bh=N8oFrXaK6EYZMX3Uh52Y9Hbv2cNewteB9CF/bmOCjIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oH/C2zTG7uArewLL+pihXhfzFm0qvKswracQHlUeIR/bEt5p+bQfKXCzXygYBNh8k
	 +8M8u1WdgRTTB1Ai8v+3blWoiYRD31c/izx/Y/a2LUfbQRzbvnLZkROGfxd9z1WyHc
	 rJJ2k0F0Td4EFh7InVBWrQ7MgfbXAXnDSACfoCeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0359/1376] perf test: Fix perf stat --bpf-counters on hybrid machines
Date: Sat, 12 Sep 2026 08:46:25 +0200
Message-ID: <20260912065615.552754876@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit d9db9c8db56c3e378aa5c91637664f77ca5a6f72 ]

The test constantly fails on my Intel hybrid machine.  The issue was it
has two events in the output even if I only gave it one event.

  $ perf stat -e instructions -- perf test -w sqrtloop

   Performance counter stats for 'perf test -w sqrtloop':

         910,856,421      cpu_atom/instructions/                (28.05%)
      14,852,865,997      cpu_core/instructions/                (96.79%)

         1.014313341 seconds time elapsed

         1.004114000 seconds user
         0.008174000 seconds sys

Let's modify the awk script to add the values for each line and print
the total.  The variable 'i' has a number of input lines that have valid
output and variable 'c' has the sum of actual counter values.  That way
it should work on any platforms.

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: b02027776ac5 ("perf tests: Fix flakiness in BPF counters test on hybrid systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_bpf_counters.sh | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
index 831f02add75e5..b776ee2e445a6 100755
--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -41,8 +41,14 @@ check_counts()
 test_bpf_counters()
 {
 	printf "Testing --bpf-counters "
-	base_instructions=$(perf stat --no-big-num -e instructions -- $workload 2>&1 | awk '/instructions/ {print $1}')
-	bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions -- $workload  2>&1 | awk '/instructions/ {print $1}')
+	base_instructions=$(perf stat --no-big-num -e instructions -- $workload 2>&1 | \
+				awk -v i=0 -v c=0 '/instructions/ { \
+					if ($1 != "<not") { i++; c += $1 } \
+				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
+	bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions -- $workload  2>&1 | \
+				awk -v i=0 -v c=0 '/instructions/ { \
+					if ($1 != "<not") { i++; c += $1 } \
+				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
 	check_counts $base_instructions $bpf_instructions
 	compare_number $base_instructions $bpf_instructions
 	echo "[Success]"
@@ -52,8 +58,14 @@ test_bpf_modifier()
 {
 	printf "Testing bpf event modifier "
 	stat_output=$(perf stat --no-big-num -e instructions/name=base_instructions/,instructions/name=bpf_instructions/b -- $workload 2>&1)
-	base_instructions=$(echo "$stat_output"| awk '/base_instructions/ {print $1}')
-	bpf_instructions=$(echo "$stat_output"| awk '/bpf_instructions/ {print $1}')
+	base_instructions=$(echo "$stat_output"| \
+				awk -v i=0 -v c=0 '/base_instructions/ { \
+					if ($1 != "<not") { i++; c += $1 } \
+				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
+	bpf_instructions=$(echo "$stat_output"| \
+				awk -v i=0 -v c=0 '/bpf_instructions/ { \
+					if ($1 != "<not") { i++; c += $1 } \
+				} END { if (i > 0) printf "%.0f", c; else print "<not" }')
 	check_counts $base_instructions $bpf_instructions
 	compare_number $base_instructions $bpf_instructions
 	echo "[Success]"
-- 
2.53.0



