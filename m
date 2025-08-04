Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284981D54D8;
	Mon,  4 Aug 2025 00:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267626; cv=none; b=G/0WK2NjLkcwGsAuYixYwG+JvqGP5C86hRnjMugb/EPFTeTXTjTT+90zZGFtZ/iI+nyzIxjI03oyO95tlf0fm4/zmfLNEjcAEBirNf3Wu6Pt2bKmvVhu30nqIKpt5Tc3/s8VhbHM9rb6I5xXc+/47JPjBOm5P7KwcwkqGF41M3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267626; c=relaxed/simple;
	bh=mKs5js1KFTQCFSdcCwpm0zYrDEHeDicLewjv+Co+4T8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=glKenJ56CZybs9ulDCgZZ4F5uy22hu0Y5BEEW0d2shDAjbKVFJb7SX0fpQUr9WQ3tDrqraS6PZHZ9o/ILELDmFdu8Gl71c40v41ICJohsP2M/hhTEVYhqOMzSr6r2P9z6bI617SrC3xE3zVssX+BgSaxpyTJPtTdERYxN3RHVqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQ97kbNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQ97kbNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C805AC4CEF0;
	Mon,  4 Aug 2025 00:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267626;
	bh=mKs5js1KFTQCFSdcCwpm0zYrDEHeDicLewjv+Co+4T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQ97kbNN4bK4KQ+Z2JsEtlIz/pC2KR9DLk7PDTCnDzISY6aE5cb6OFt0noOAIo9ur
	 Gu9scBaHPUzF1JB36IBvMMKMDeOdQWKetbPQzxbnYqf6Vva7rIy3rqIRWnCPRsNrc2
	 tJbknjJg9kL7qAigvuzlC1N5eatcN0l0U0/97Mu6dDbTxLRZy2tck86I20WnZ9PHMc
	 APyC5D66pnnt2tdOR62aIbO/YTAxdU7bTNoIsF0EE9CyJ3RJCM8H8Ord41QLFCKB5f
	 VQSZgcSFJTOPTVQsJpAgYYCo0f1f5H4617GR9nUxEtThBXZLkVH5ALWn6mMaJvSupR
	 fiJeKL9iA3+FA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	herongguang@linux.alibaba.com,
	wangfushuai@baidu.com
Subject: [PATCH AUTOSEL 6.12 59/69] pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()
Date: Sun,  3 Aug 2025 20:31:09 -0400
Message-Id: <20250804003119.3620476-59-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
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

