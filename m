Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A481B87D5;
	Wed, 19 Mar 2025 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394928; cv=none; b=UE1bfTOY32A2DWl4KZTKSUpkX8ll4e0/vKT1DRH+pqe8jJTvapPPz74+puINjL6xXGdvwW2UddWNZjKaX2AiTg5c1rtsFokwGWCdmqGw42aJ9T0VDIh2+tw4MVP/bYUVZPQ2GaLsPaudUIEhCdZ52PnK92NFFJw1vGw4mFE3tKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394928; c=relaxed/simple;
	bh=c+8grjqaxCEZuCDXvDd3LFvUOu7PL7n/B10bs9jce38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da99vfbNfy9rcYNXxdtGJ3AisVaHYhCbyTSHeWJRSR75CA4S/x8+hSttTm6Ksa4nj0o5ZmikXgSNHucK6ISmcWSHVkkUl6gLAEzwzfH6vsUokRT1FWsGRVNa2/fgDX0xDhlZ4F51o2Qa/QBeWI6jk1A6NBxduiyCbett6Vv68QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jo739vVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jo739vVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C330C4CEE4;
	Wed, 19 Mar 2025 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394928;
	bh=c+8grjqaxCEZuCDXvDd3LFvUOu7PL7n/B10bs9jce38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jo739vVnAafPu3KoxYgMl6SBTQ0NMx/dF2jFm0HuzvGOntooGGiMNNvr6j1+73sCZ
	 RsjSKytryXb/u6f3i/6ECKuD1yvQl6oGQCv3G1AU9FVDPyVo9tiPWt9tHcfwJvcnTd
	 QMz5UgjGffNQFI+HnZkMWx9+UTwMrxhd1AZiOyQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 141/241] perf/x86/intel: Use better start period for frequency mode
Date: Wed, 19 Mar 2025 07:30:11 -0700
Message-ID: <20250319143031.210607794@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit a26b24b2e21f6222635a95426b9ef9eec63d69b1 ]

Freqency mode is the current default mode of Linux perf. A period of 1 is
used as a starting period. The period is auto-adjusted on each tick or an
overflow, to meet the frequency target.

The start period of 1 is too low and may trigger some issues:

- Many HWs do not support period 1 well.
  https://lore.kernel.org/lkml/875xs2oh69.ffs@tglx/

- For an event that occurs frequently, period 1 is too far away from the
  real period. Lots of samples are generated at the beginning.
  The distribution of samples may not be even.

- A low starting period for frequently occurring events also challenges
  virtualization, which has a longer path to handle a PMI.

The limit_period value only checks the minimum acceptable value for HW.
It cannot be used to set the start period, because some events may
need a very low period. The limit_period cannot be set too high. It
doesn't help with the events that occur frequently.

It's hard to find a universal starting period for all events. The idea
implemented by this patch is to only give an estimate for the popular
HW and HW cache events. For the rest of the events, start from the lowest
possible recommended value.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250117151913.3043942-3-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 85 ++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2bba1d934efb0..6651360d6a525 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3949,6 +3949,85 @@ static inline bool intel_pmu_has_cap(struct perf_event *event, int idx)
 	return test_bit(idx, (unsigned long *)&intel_cap->capabilities);
 }
 
+static u64 intel_pmu_freq_start_period(struct perf_event *event)
+{
+	int type = event->attr.type;
+	u64 config, factor;
+	s64 start;
+
+	/*
+	 * The 127 is the lowest possible recommended SAV (sample after value)
+	 * for a 4000 freq (default freq), according to the event list JSON file.
+	 * Also, assume the workload is idle 50% time.
+	 */
+	factor = 64 * 4000;
+	if (type != PERF_TYPE_HARDWARE && type != PERF_TYPE_HW_CACHE)
+		goto end;
+
+	/*
+	 * The estimation of the start period in the freq mode is
+	 * based on the below assumption.
+	 *
+	 * For a cycles or an instructions event, 1GHZ of the
+	 * underlying platform, 1 IPC. The workload is idle 50% time.
+	 * The start period = 1,000,000,000 * 1 / freq / 2.
+	 *		    = 500,000,000 / freq
+	 *
+	 * Usually, the branch-related events occur less than the
+	 * instructions event. According to the Intel event list JSON
+	 * file, the SAV (sample after value) of a branch-related event
+	 * is usually 1/4 of an instruction event.
+	 * The start period of branch-related events = 125,000,000 / freq.
+	 *
+	 * The cache-related events occurs even less. The SAV is usually
+	 * 1/20 of an instruction event.
+	 * The start period of cache-related events = 25,000,000 / freq.
+	 */
+	config = event->attr.config & PERF_HW_EVENT_MASK;
+	if (type == PERF_TYPE_HARDWARE) {
+		switch (config) {
+		case PERF_COUNT_HW_CPU_CYCLES:
+		case PERF_COUNT_HW_INSTRUCTIONS:
+		case PERF_COUNT_HW_BUS_CYCLES:
+		case PERF_COUNT_HW_STALLED_CYCLES_FRONTEND:
+		case PERF_COUNT_HW_STALLED_CYCLES_BACKEND:
+		case PERF_COUNT_HW_REF_CPU_CYCLES:
+			factor = 500000000;
+			break;
+		case PERF_COUNT_HW_BRANCH_INSTRUCTIONS:
+		case PERF_COUNT_HW_BRANCH_MISSES:
+			factor = 125000000;
+			break;
+		case PERF_COUNT_HW_CACHE_REFERENCES:
+		case PERF_COUNT_HW_CACHE_MISSES:
+			factor = 25000000;
+			break;
+		default:
+			goto end;
+		}
+	}
+
+	if (type == PERF_TYPE_HW_CACHE)
+		factor = 25000000;
+end:
+	/*
+	 * Usually, a prime or a number with less factors (close to prime)
+	 * is chosen as an SAV, which makes it less likely that the sampling
+	 * period synchronizes with some periodic event in the workload.
+	 * Minus 1 to make it at least avoiding values near power of twos
+	 * for the default freq.
+	 */
+	start = DIV_ROUND_UP_ULL(factor, event->attr.sample_freq) - 1;
+
+	if (start > x86_pmu.max_period)
+		start = x86_pmu.max_period;
+
+	if (x86_pmu.limit_period)
+		x86_pmu.limit_period(event, &start);
+
+	return start;
+}
+
 static int intel_pmu_hw_config(struct perf_event *event)
 {
 	int ret = x86_pmu_hw_config(event);
@@ -3960,6 +4039,12 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
+	if (event->attr.freq && event->attr.sample_freq) {
+		event->hw.sample_period = intel_pmu_freq_start_period(event);
+		event->hw.last_period = event->hw.sample_period;
+		local64_set(&event->hw.period_left, event->hw.sample_period);
+	}
+
 	if (event->attr.precise_ip) {
 		if ((event->attr.config & INTEL_ARCH_EVENT_MASK) == INTEL_FIXED_VLBR_EVENT)
 			return -EINVAL;
-- 
2.39.5



