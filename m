Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390FA1FDD;
	Mon,  4 Aug 2025 00:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268128; cv=none; b=RpqmKwNzYYLDzJLmw9XT5r1k3z2XXeWfPRjOr/tEdPX+hdEkTdwJyxl4I1lbsL7+smCwkHrCIUtgxd8jJsOD7fBiR/fhzjurgFkf6QWLBXQagGGc3UKqa5zew325xFtxQO5W+frZlxd+/2wY9fIJCpk52GFk2OPpt1SxbOO2BzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268128; c=relaxed/simple;
	bh=mKs5js1KFTQCFSdcCwpm0zYrDEHeDicLewjv+Co+4T8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q7NUX6+TG44hI5Buchp/ffKC8WJBCnV7FOKKp5GkI4I/Xj5Ytz18NyxRH/gQurWQijjJ15A6BZHXFI5KZYEXWyvmWE6qEM4HSo0f8Hxx7hrz/GY0MXDr1vxyNXiNrcsfwGcL1WuZQ6Gnv6WJlk8k/hTkw34HOsohSMovxi82yo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocjRX+5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocjRX+5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD6CC4CEF0;
	Mon,  4 Aug 2025 00:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268128;
	bh=mKs5js1KFTQCFSdcCwpm0zYrDEHeDicLewjv+Co+4T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocjRX+5nLu3YMf9iMb+ElI4cQu7tQlpz5GZGV9kackI5GbDMqDNaPLRhik6gZvbDq
	 VZ1afb4wWp4qrIGdADRn89iYgMXhfIlGVp4LBLhU/uMjQ5NOgX+swmnxCM28PJKrvN
	 lyWIbtrvp9YVXAgbvFH3lhxtih469yfFVmJPG2vDy++RL1cE5gKZ7cPGtjUc7JxI4z
	 7LFFdZN4THLA+SvH1hs2FWUKqLsbMzLd6aQ9/sNJjDHlbeCBi1X1SugWy1fzAV1GRj
	 pZ0O9D+Qxv45ds0t5Opr8QeM7f5aG0k2GWI0g1j+mPPD4qJvaEoVEMDke6vTgHf6iu
	 ISZ+o5yG7OQow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	wangfushuai@baidu.com,
	herongguang@linux.alibaba.com
Subject: [PATCH AUTOSEL 5.10 32/39] pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()
Date: Sun,  3 Aug 2025 20:40:34 -0400
Message-Id: <20250804004041.3628812-32-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004041.3628812-1-sashal@kernel.org>
References: <20250804004041.3628812-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.240
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Gautham R. Shenoy" <gautham.shenoy@amd.com>

[ Upstream commit cda7ac8ce7de84cf32a3871ba5f318aa3b79381e ]

In the function mperf_start(), mperf_monitor snapshots the time, tsc
and finally the aperf,mperf MSRs. However, this order of snapshotting
in is reversed in mperf_stop(). As a result, the C0 residency (which
is computed as delta_mperf * 100 / delta_tsc) is under-reported on
CPUs that is 100% busy.

Fix this by snapshotting time, tsc and then aperf,mperf in
mperf_stop() in the same order as in mperf_start().

Link: https://lore.kernel.org/r/20250612122355.19629-2-gautham.shenoy@amd.com
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Clear bug fix with user impact**: The commit fixes a calculation
   bug in the cpupower tool where C0 residency (processor active time)
   is under-reported on 100% busy CPUs. This directly affects users
   monitoring CPU performance and power states.

2. **Simple and contained fix**: The change is minimal - it only
   reorders three function calls in `mperf_stop()` to match the order in
   `mperf_start()`:
   - Before: `mperf_measure_stats()` → `mperf_get_tsc()` →
     `clock_gettime()`
   - After: `clock_gettime()` → `mperf_get_tsc()` →
     `mperf_measure_stats()`

3. **Low risk of regression**: The fix simply ensures consistent
   snapshot ordering between start and stop measurements. This is a
   logical correction that aligns the measurement methodology without
   introducing new functionality.

4. **Clear root cause**: The bug occurs because the reversed snapshot
   order causes timing skew in the C0 residency calculation
   (`delta_mperf * 100 / delta_tsc`). When snapshots are taken in
   different orders at start vs stop, the time windows don't align
   properly, leading to incorrect calculations.

5. **Affects monitoring tool accuracy**: While this is a userspace tool
   bug rather than a kernel bug, cpupower is an important diagnostic
   tool shipped with the kernel. Incorrect C0 residency reporting could
   mislead system administrators and developers analyzing CPU
   performance.

6. **No architectural changes**: The fix doesn't change any data
   structures, APIs, or fundamental behavior - it simply corrects the
   measurement sequence.

The commit meets stable tree criteria as it fixes a real bug affecting
users, is minimal in scope, and has very low risk of introducing new
issues.

 tools/power/cpupower/utils/idle_monitor/mperf_monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
index 08a399b0be28..6ab9139f16af 100644
--- a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
@@ -240,9 +240,9 @@ static int mperf_stop(void)
 	int cpu;
 
 	for (cpu = 0; cpu < cpu_count; cpu++) {
-		mperf_measure_stats(cpu);
-		mperf_get_tsc(&tsc_at_measure_end[cpu]);
 		clock_gettime(CLOCK_REALTIME, &time_end[cpu]);
+		mperf_get_tsc(&tsc_at_measure_end[cpu]);
+		mperf_measure_stats(cpu);
 	}
 
 	return 0;
-- 
2.39.5

