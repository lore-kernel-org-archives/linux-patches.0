Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2F8374A16;
	Wed, 30 Sep 2026 16:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786604; cv=none; b=ZI9tTG7b90oa8NOsMyv2sbxhNPkL1icJ4lvEkt27KwytysFikC1LPGcWsTPAuABNf++RHJ0Qp5qqJrWuNJjW1u7KPTS5Puziu3bLVdUWuxd4e39E5crn50UVrc+oc8slW3rRAeBoj5yiL1tjV3DIdwZxd+5KUiTXVpg8a0JTZKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786604; c=relaxed/simple;
	bh=28+gyCHTboCRW+MMSTDhuThuq+YtdkaNRxVHkqhakuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRMP2TIaQLSaxlOAH+0fl4+FYyUPgCM+K9WzQsiI/9dJ9PBzl7e1qgE6/LAIpbRQ6vtgl4IXsyTHESWZeS19sZmZgqrH8x1X1PC+gm0hVSPvn4Jse0TlxHOm/ubUHLv+YO6CTYdL/tezEwzFKN2L5mjbIghBchhrnu/xMGKolaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghsSSPat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghsSSPat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308A31F000FF;
	Wed, 30 Sep 2026 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786602;
	bh=kJ12/fe4tpgaewNCNE8Cor089TRrwhCPLEqhQieLWkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghsSSPatKS4+ZwSHJmuYQhAnAQ+CZiBoHSFq3ghsqBroX3ZhVtSCmV/vi/u+ytGkj
	 MGmPcTJwv9YEJGbClm1YgpeN6vX9vjuqZpmmoGkG1GzXsT/v3XofhdcAEiiHFbd3nb
	 wr7z65xuPjELRSChKAmpkvw3o9eJS8ZBIjCM3uiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 918/982] perf/x86/intel: Dont write PEBS_ENABLED on host<=>guest xfers if CPU has PEBS isolation, to fix stuck PEBS_ENABLED
Date: Wed, 30 Sep 2026 17:27:34 +0200
Message-ID: <20260930152436.458586288@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 4b64dbdc5861477f148e13d1ed127e7fe7182e4f ]

When filling the list of MSRs to be loaded by KVM on VM-Enter and VM-Exit,
*never* insert an entry for PEBS_ENABLED if the CPU properly isolates PEBS
events, in which case disabling counters via PERF_GLOBAL_CTRL is sufficient
to prevent unwanted PEBS events in the guest (or host).  Because perf loads
PEBS_ENABLE with the unfiltered cpu_hw_events.pebs_enabled, i.e. with both
host and guest masks, there is no need to load different values for the
guest versus host, perf+KVM can and should simply control which counters
are enabled/disabled via PERF_GLOBAL_CTRL.

Avoiding touching PEBS_ENABLED "fixes" a bug where PEBS_ENABLED can end up
with "stuck" bits if a PEBS event is throttled between generating the list
and actually entering the guest (Intel CPUs can't arbtitrarily block NMIs).
Fixes in quotes because leaving PEBS_ENABLED as-is doesn't fix the
underlying problem of perf (via PMIs) being able to modify state after the
perf<=>KVM handoff.

But not writing PEBS_ENABLED is desirable no matter what, as stating the
obvious, leaving PEBS_ENABLED as-is avoids three MSR writes on every VMX
transition: one each on entry/exit, and one more explicit WRMSR to zero
PEBS_ENABLED before VM-Entry (KVM assumes the only reason PEBS_ENABLED is
in the load list is if the CPU lacks PEBS isolation and thus needs a
quiescent period).

Opportunistically add comments to (better) explain the rules for generating
the set of PEBS counters that will be active while the guest is running,
along with a FIXME for the suspected hack-a-fix where perf disables guest
PEBS if _any_ PEBS event is configured to count in the host (commit
854250329c02 ("KVM: x86/pmu: Disable guest PEBS temporarily in two rare
situations") doesn't explain the motivation, at all).

Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260921191418.950933-3-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 55 ++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ac4e149af80c2..4ddd967a9d3d1 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4123,12 +4123,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	struct kvm_pmu *kvm_pmu = (struct kvm_pmu *)data;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
 	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
-	int global_ctrl, pebs_enable;
+	u64 guest_pebs_mask;
+	int global_ctrl;
 
 	/*
 	 * In addition to obeying exclude_guest/exclude_host, remove bits being
 	 * used for PEBS when running a guest, because PEBS writes to virtual
-	 * addresses (not physical addresses).
+	 * addresses (not physical addresses).  If the guest wants to utilize
+	 * PEBS, and PEBS can be safely enabled in the guest, bits for the guest's
+	 * PEBS-enabled counters will be OR'd back in as appropriate.
 	 */
 	*nr = 0;
 	global_ctrl = (*nr)++;
@@ -4175,24 +4178,40 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		};
 	}
 
-	pebs_enable = (*nr)++;
-	arr[pebs_enable] = (struct perf_guest_switch_msr){
-		.msr = MSR_IA32_PEBS_ENABLE,
-		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
-		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask & kvm_pmu->pebs_enable,
-	};
+	/*
+	 * Restrict guest PEBS events to counters that (a) perf supports, (b)
+	 * the guest wants to use for PEBS, (c) are not excluded from counting
+	 * in the guest, and (d) _are_ excluded from counting in the host.
+	 */
+	guest_pebs_mask = pebs_mask & intel_ctrl & kvm_pmu->pebs_enable &
+			  ~cpuc->intel_ctrl_host_mask &
+			  cpuc->intel_ctrl_guest_mask;
 
-	if (arr[pebs_enable].host) {
-		/* Disable guest PEBS if host PEBS is enabled. */
-		arr[pebs_enable].guest = 0;
-	} else {
-		/* Disable guest PEBS thoroughly for cross-mapped PEBS counters. */
-		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
-		arr[global_ctrl].guest &= ~kvm_pmu->host_cross_mapped_mask;
-		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
-		arr[global_ctrl].guest |= intel_ctrl & arr[pebs_enable].guest;
-	}
+	/*
+	 * Disable counters where the guest PMC is different than the host PMC
+	 * being used on behalf of the guest, as the PEBS record includes
+	 * PERF_GLOBAL_STATUS, i.e. the guest will see overflow status for the
+	 * wrong counter(s).
+	 */
+	guest_pebs_mask &= ~kvm_pmu->host_cross_mapped_mask;
+
+	/*
+	 * FIXME: Allow guest and host usage of PEBS events to co-exist instead
+	 *        of disabling guest PEBS entirely if the host is using PEBS.
+	 *        What exactly goes wrong if guest and host are using PEBS is
+	 *        unknown.
+	 */
+	if (pebs_mask & ~cpuc->intel_ctrl_guest_mask)
+		guest_pebs_mask = 0;
 
+	/*
+	 * Do NOT mess with PEBS_ENABLED.  As above, disabling counters via
+	 * PERF_GLOBAL_CTRL is sufficient, and loading a stale PEBS_ENABLED,
+	 * e.g. on VM-Exit, can put the system in a bad state.  Simply enable
+	 * counters in PERF_GLOBAL_CTRL, as perf load PEBS_ENABLED with the
+	 * full value, i.e. perf *also* relies on PERF_GLOBAL_CTRL.
+	 */
+	arr[global_ctrl].guest |= guest_pebs_mask;
 	return arr;
 }
 
-- 
2.53.0



