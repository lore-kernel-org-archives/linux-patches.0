Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FC736B061;
	Tue, 16 Dec 2025 12:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887417; cv=none; b=PLyn2+q/74Z3gA82LP/e1rJY7g22ltGBVQQ3meWrzcFY7oyabXSPDNYBOadHwWn5Oej2e23muZkm3ulwI7It4KaRL5CXR9CE56SCe3Fes3qkiCVq57u6MVKtjL1RNl3qEW+ZC1PjAF75gbUQPt8HfBf38wtDLB6D2PGSAm2K61g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887417; c=relaxed/simple;
	bh=lm5Jr7O23B9ncFzgXiwrrpK8WIBOSBpkBeKvAlYtF1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aybHdMKq8CSv3470gB9ZNTF+1sdbBZ51eMiZVDxii625c4WV1sLVx7y8DNpcsgToolFy0o/mvTdp38sAUy8zWXPiGHLiNzbgnEqbdfVhv7utLRDSUCXbnQOJKTxLg91YoWaCWMKClKF0jVPmfCpEGKNPUz8f1SiaPEREW1KtahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTe6lexv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTe6lexv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258A3C4CEF1;
	Tue, 16 Dec 2025 12:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887416;
	bh=lm5Jr7O23B9ncFzgXiwrrpK8WIBOSBpkBeKvAlYtF1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTe6lexv0oyZz+OIq+icPI6N2fdRbzHLbzYk0dzAGIuCVrr5RnPKp//UY+8EjM3Cx
	 Tn5eWXsL++Qsgx42ATGCyF9/gKJjpVhWbFvrxBwkF2HtHoDAzZwISkWIsDQnDvuMrx
	 hlADi5bYEtv2DJ1Fmd9VqcMm5UlCTTb22T9/cBek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 223/614] perf/x86: Fix NULL event access and potential PEBS record loss
Date: Tue, 16 Dec 2025 12:09:50 +0100
Message-ID: <20251216111409.452419138@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fa6c47b509897..dd9ff120ad437 100644
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



