Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838702F12BE;
	Fri, 17 Oct 2025 15:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714124; cv=none; b=uIRTMGPat44kLtWKU4Q+PcZSbXtLL41WQBECxOtAEfUAkRwRlTeHQDfZMpVKUu3+9GJe8oryrqcXP1ETrPEdeQt56IGno5wEKFy5N0OrAdqRQ2iECGdxMmwfhx5AFTIkRf/YvFRm4rIWaHc7u02gO/+p1pAYH4DHDdebmg5AnjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714124; c=relaxed/simple;
	bh=L00Dx/A4cjInJ9BK6MsY3I+D9YH/5aUTzKqjXVV65XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMUygIXbmigRs/B3surlZEcChuXYM0Ue9uptX/JdbeV6O2cIUXpfLcdoua4B9+Xao+i0hPH6BaJ+kk7+pEAhYLrVOfQimlBAoYvZNWl7aJHRfPSCkE+sYp+fDMZpOyMVK1/okhfEbBsPfZIgbg3SOapt1Hwr42H1Fjx765SgkKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qH5bgA72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qH5bgA72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32E2C4CEE7;
	Fri, 17 Oct 2025 15:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714124;
	bh=L00Dx/A4cjInJ9BK6MsY3I+D9YH/5aUTzKqjXVV65XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qH5bgA72k2yv3Z/rZzhPQCc6v1uF/72mEPD/FzRAlFrFYYOaP8F6scVRZr0ZPf24B
	 5om3E6d+AVmE7TR3yO3AsKyBgvQ4/y5ac0zAkASGwM1VU0Y7t64IUUemQ1/OKPJZ2e
	 2t738ZGwtueLGZmyZbSqWzQxHLk3D9p4Fy7Qnhec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/277] perf test shell lbr: Avoid failures with perf event paranoia
Date: Fri, 17 Oct 2025 16:50:35 +0200
Message-ID: <20251017145148.175738822@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

[ Upstream commit 48314d20fe467d6653783cbf5536cb2fcc9bdd7c ]

When not running as root and with higher perf event paranoia values
the perf record LBR tests could fail rather than skipping the
problematic tests.

Add the sensitivity to the test and confirm it passes with paranoia
values from -1 to 2.

Committer testing:

Testing with '$ perf test -vv lbr', i.e. as non root, and then comparing
the output shows the mentioned errors before this patch:

  acme@x1:~$ grep -m1 "model name" /proc/cpuinfo
  model name	: 13th Gen Intel(R) Core(TM) i7-1365U
  acme@x1:~$

Before:

 132: perf record LBR tests            : Skip

After:

 132: perf record LBR tests            : Ok

Fixes: 32559b99e0f59070 ("perf test: Add set of perf record LBR tests")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/record_lbr.sh | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/shell/record_lbr.sh b/tools/perf/tests/shell/record_lbr.sh
index ab6f2825f7903..5984ca9b78f8a 100755
--- a/tools/perf/tests/shell/record_lbr.sh
+++ b/tools/perf/tests/shell/record_lbr.sh
@@ -4,6 +4,10 @@
 
 set -e
 
+ParanoidAndNotRoot() {
+  [ "$(id -u)" != 0 ] && [ "$(cat /proc/sys/kernel/perf_event_paranoid)" -gt $1 ]
+}
+
 if [ ! -f /sys/bus/event_source/devices/cpu/caps/branches ] &&
    [ ! -f /sys/bus/event_source/devices/cpu_core/caps/branches ]
 then
@@ -23,6 +27,7 @@ cleanup() {
 }
 
 trap_cleanup() {
+  echo "Unexpected signal in ${FUNCNAME[1]}"
   cleanup
   exit 1
 }
@@ -123,8 +128,11 @@ lbr_test "-j ind_call" "any indirect call" 2
 lbr_test "-j ind_jmp" "any indirect jump" 100
 lbr_test "-j call" "direct calls" 2
 lbr_test "-j ind_call,u" "any indirect user call" 100
-lbr_test "-a -b" "system wide any branch" 2
-lbr_test "-a -j any_call" "system wide any call" 2
+if ! ParanoidAndNotRoot 1
+then
+  lbr_test "-a -b" "system wide any branch" 2
+  lbr_test "-a -j any_call" "system wide any call" 2
+fi
 
 # Parallel
 parallel_lbr_test "-b" "parallel any branch" 100 &
@@ -141,10 +149,16 @@ parallel_lbr_test "-j call" "parallel direct calls" 100 &
 pid6=$!
 parallel_lbr_test "-j ind_call,u" "parallel any indirect user call" 100 &
 pid7=$!
-parallel_lbr_test "-a -b" "parallel system wide any branch" 100 &
-pid8=$!
-parallel_lbr_test "-a -j any_call" "parallel system wide any call" 100 &
-pid9=$!
+if ParanoidAndNotRoot 1
+then
+  pid8=
+  pid9=
+else
+  parallel_lbr_test "-a -b" "parallel system wide any branch" 100 &
+  pid8=$!
+  parallel_lbr_test "-a -j any_call" "parallel system wide any call" 100 &
+  pid9=$!
+fi
 
 for pid in $pid1 $pid2 $pid3 $pid4 $pid5 $pid6 $pid7 $pid8 $pid9
 do
-- 
2.51.0



