Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F6C34DCF3;
	Tue, 16 Dec 2025 11:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885596; cv=none; b=Pwb9hU2CXHJQ/jeCkozxHvTkxZX13P1GZBrGS6IzKvDgIRlRAhycIsh2Q+bY7LoANW9xPgfgn3KTRASXqKyxLfu684tvvLXL5QdvUV/bNGhSNvv+aSiUtPaNDklsQpisJch9SgoEY8Mg30K+f3MPceNtwmKzl4ImeiOcchyfBOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885596; c=relaxed/simple;
	bh=zczvj2aeGMXl07t7+ZLVmmg69cW3nFqn9D3MryXPhbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVvqlVkjFDFV1Z53GCSA72PWGn7IwZyCJtg/z7M98KxDAZaVTsrLCokRCUADcMzqOIGMDXlTx5zPm2cJbMZq2cuxTlqtP6f163cfCQ8bFw79RkF0rI8olqmEM1WSSlCr7QjQaH7p+D1o52QsOeCJLOvYbDNmXSwCIMmEHgOs4zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ntnk1gy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ntnk1gy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA30C4CEF1;
	Tue, 16 Dec 2025 11:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885596;
	bh=zczvj2aeGMXl07t7+ZLVmmg69cW3nFqn9D3MryXPhbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ntnk1gy3f4iAangp+z8dZT6Jz0ghlhG59QibiJx/K9I1aCHah4v7211DzKDVWiJgy
	 B2HZ1kKhmpKRxa/wXTSCoig7Tgt3jNhrMrvNpWriOTKw7QwMnmb8gYTiKxvUj4YbK6
	 cd+luFHOMr5jKuSXothWI8Xv/R2ZD47Ho2PTEd4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 187/507] perf/x86: Fix NULL event access and potential PEBS record loss
Date: Tue, 16 Dec 2025 12:10:28 +0100
Message-ID: <20251216111352.287888571@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 7e772a93eb61cb6265bdd1c5bde17d0f2718b452 ]

When intel_pmu_drain_pebs_icl() is called to drain PEBS records, the
perf_event_overflow() could be called to process the last PEBS record.

While perf_event_overflow() could trigger the interrupt throttle and
stop all events of the group, like what the below call-chain shows.

perf_event_overflow()
  -> __perf_event_overflow()
    ->__perf_event_account_interrupt()
      -> perf_event_throttle_group()
        -> perf_event_throttle()
          -> event->pmu->stop()
            -> x86_pmu_stop()

The side effect of stopping the events is that all corresponding event
pointers in cpuc->events[] array are cleared to NULL.

Assume there are two PEBS events (event a and event b) in a group. When
intel_pmu_drain_pebs_icl() calls perf_event_overflow() to process the
last PEBS record of PEBS event a, interrupt throttle is triggered and
all pointers of event a and event b are cleared to NULL. Then
intel_pmu_drain_pebs_icl() tries to process the last PEBS record of
event b and encounters NULL pointer access.

To avoid this issue, move cpuc->events[] clearing from x86_pmu_stop()
to x86_pmu_del(). It's safe since cpuc->active_mask or
cpuc->pebs_enabled is always checked before access the event pointer
from cpuc->events[].

Closes: https://lore.kernel.org/oe-lkp/202507042103.a15d2923-lkp@intel.com
Fixes: 9734e25fbf5a ("perf: Fix the throttle logic for a group")
Reported-by: kernel test robot <oliver.sang@intel.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251029102136.61364-3-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 38f7102e2dacc..dc77e11f23657 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1344,6 +1344,7 @@ static void x86_pmu_enable(struct pmu *pmu)
 				hwc->state |= PERF_HES_ARCH;
 
 			x86_pmu_stop(event, PERF_EF_UPDATE);
+			cpuc->events[hwc->idx] = NULL;
 		}
 
 		/*
@@ -1365,6 +1366,7 @@ static void x86_pmu_enable(struct pmu *pmu)
 			 * if cpuc->enabled = 0, then no wrmsr as
 			 * per x86_pmu_enable_event()
 			 */
+			cpuc->events[hwc->idx] = event;
 			x86_pmu_start(event, PERF_EF_RELOAD);
 		}
 		cpuc->n_added = 0;
@@ -1531,7 +1533,6 @@ static void x86_pmu_start(struct perf_event *event, int flags)
 
 	event->hw.state = 0;
 
-	cpuc->events[idx] = event;
 	__set_bit(idx, cpuc->active_mask);
 	static_call(x86_pmu_enable)(event);
 	perf_event_update_userpage(event);
@@ -1610,7 +1611,6 @@ void x86_pmu_stop(struct perf_event *event, int flags)
 	if (test_bit(hwc->idx, cpuc->active_mask)) {
 		static_call(x86_pmu_disable)(event);
 		__clear_bit(hwc->idx, cpuc->active_mask);
-		cpuc->events[hwc->idx] = NULL;
 		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
 		hwc->state |= PERF_HES_STOPPED;
 	}
@@ -1648,6 +1648,7 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	 * Not a TXN, therefore cleanup properly.
 	 */
 	x86_pmu_stop(event, PERF_EF_UPDATE);
+	cpuc->events[event->hw.idx] = NULL;
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i])
-- 
2.51.0



