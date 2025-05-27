Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628FB2566;
	Tue, 27 May 2025 17:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368409; cv=none; b=mIv/XNBdWt4o7N7CogAbuenG6g8rzO8RD8qxiVcA04UbXRbkeGlRiwPKGr9BdtAxWEjVwfTLZs+zDL4o+7J+KUEVvTRX6zRjsy/8Okbtl4+AxIL+E+QlaAbEasacZIODsaqiLE7TN0mJJrHUY1cU8u5oL0T75/X7UpxU8YBSfPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368409; c=relaxed/simple;
	bh=RnJbyAluFlrQ5ooYbd7s/txWcJOc/Xdfq8wrXcMMvZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njO/zJggdlAejByt/HksNsF3v92nRSuzDvveOkF1S5qJhfj7m83uYfHcUizma7mbcN4h9HLNL6R6mCB96gaTN6zzgvIMLDqXApKYEWZAx4AhdJN0gM5h5XFzSkmii5INCMVzxS017ieYbh6WTt4FKZfKlPCv945tHippZ+J/3kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDh9bbH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDh9bbH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B26C4CEE9;
	Tue, 27 May 2025 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368409;
	bh=RnJbyAluFlrQ5ooYbd7s/txWcJOc/Xdfq8wrXcMMvZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDh9bbH4eJOCDssy26i9xZCviOC2d3jbZyGKhzRtO/X57q9Bdi1BfuL/aol9thR4z
	 kvezke6Ejl9StDK8HJrUWg1/tu8Na0golvH2WU7IpG7/QKLuMEE5Hdex4kZx9LTtRO
	 KdUsk3ODF1IYL/ig3UqAUI2hD1n2XAAs/8EhUjio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	linux-perf-users@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 697/783] perf/x86/intel: Fix segfault with PEBS-via-PT with sample_freq
Date: Tue, 27 May 2025 18:28:14 +0200
Message-ID: <20250527162541.510196807@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 99bcd91fabada0dbb1d5f0de44532d8008db93c6 ]

Currently, using PEBS-via-PT with a sample frequency instead of a sample
period, causes a segfault.  For example:

    BUG: kernel NULL pointer dereference, address: 0000000000000195
    <NMI>
    ? __die_body.cold+0x19/0x27
    ? page_fault_oops+0xca/0x290
    ? exc_page_fault+0x7e/0x1b0
    ? asm_exc_page_fault+0x26/0x30
    ? intel_pmu_pebs_event_update_no_drain+0x40/0x60
    ? intel_pmu_pebs_event_update_no_drain+0x32/0x60
    intel_pmu_drain_pebs_icl+0x333/0x350
    handle_pmi_common+0x272/0x3c0
    intel_pmu_handle_irq+0x10a/0x2e0
    perf_event_nmi_handler+0x2a/0x50

That happens because intel_pmu_pebs_event_update_no_drain() assumes all the
pebs_enabled bits represent counter indexes, which is not always the case.
In this particular case, bits 60 and 61 are set for PEBS-via-PT purposes.

The behaviour of PEBS-via-PT with sample frequency is questionable because
although a PMI is generated (PEBS_PMI_AFTER_EACH_RECORD), the period is not
adjusted anyway.

Putting that aside, fix intel_pmu_pebs_event_update_no_drain() by passing
the mask of counter bits instead of 'size'.  Note, prior to the Fixes
commit, 'size' would be limited to the maximum counter index, so the issue
was not hit.

Fixes: 722e42e45c2f1 ("perf/x86: Support counter mask")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: linux-perf-users@vger.kernel.org
Link: https://lore.kernel.org/r/20250508134452.73960-1-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 08de293bebad1..97587d4c7befd 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2280,8 +2280,9 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs, struct perf_sample_
 				setup_pebs_fixed_sample_data);
 }
 
-static void intel_pmu_pebs_event_update_no_drain(struct cpu_hw_events *cpuc, int size)
+static void intel_pmu_pebs_event_update_no_drain(struct cpu_hw_events *cpuc, u64 mask)
 {
+	u64 pebs_enabled = cpuc->pebs_enabled & mask;
 	struct perf_event *event;
 	int bit;
 
@@ -2292,7 +2293,7 @@ static void intel_pmu_pebs_event_update_no_drain(struct cpu_hw_events *cpuc, int
 	 * It needs to call intel_pmu_save_and_restart_reload() to
 	 * update the event->count for this case.
 	 */
-	for_each_set_bit(bit, (unsigned long *)&cpuc->pebs_enabled, size) {
+	for_each_set_bit(bit, (unsigned long *)&pebs_enabled, X86_PMC_IDX_MAX) {
 		event = cpuc->events[bit];
 		if (event->hw.flags & PERF_X86_EVENT_AUTO_RELOAD)
 			intel_pmu_save_and_restart_reload(event, 0);
@@ -2327,7 +2328,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
 	}
 
 	if (unlikely(base >= top)) {
-		intel_pmu_pebs_event_update_no_drain(cpuc, size);
+		intel_pmu_pebs_event_update_no_drain(cpuc, mask);
 		return;
 	}
 
@@ -2441,7 +2442,7 @@ static void intel_pmu_drain_pebs_icl(struct pt_regs *iregs, struct perf_sample_d
 	       (hybrid(cpuc->pmu, fixed_cntr_mask64) << INTEL_PMC_IDX_FIXED);
 
 	if (unlikely(base >= top)) {
-		intel_pmu_pebs_event_update_no_drain(cpuc, X86_PMC_IDX_MAX);
+		intel_pmu_pebs_event_update_no_drain(cpuc, mask);
 		return;
 	}
 
-- 
2.39.5



