Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FD530EF82;
	Mon, 13 Oct 2025 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368826; cv=none; b=h8kLECMt77yvVy2h43TVqZbbvSp5kvlnUdm+zs9MVLxAlizcjNYeNI34Y3lIwYY9r02lVHTFWivNTrK8XwmROYuExVX1bQCFmTK50dD6Uw1MJhlLYKmF/Im382INZF+osn3xwOc61cpJnSYs+CAdDKCIGJBBVAvQPJeuKcxqgbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368826; c=relaxed/simple;
	bh=NbmYe5dihMq1aZnnpexAVIbIXPxe4erTlThoiGKhfv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8Uzr5x0l4JQCurOJjEC8G5SBSovxZDvZrOSytbDCZq2Gag3N1QkKhtXFyWu5OempgmPdOam6Wwp9H/pguDMkeWwMvYGaWRa+EqD2swuLzjxGtzvaFqiBEufktIEANDfAabgTTbyyy9bcIX1LhFNPel8upneSWF6z/c6BSjwbDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDJK5PJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDJK5PJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C502C116C6;
	Mon, 13 Oct 2025 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368825;
	bh=NbmYe5dihMq1aZnnpexAVIbIXPxe4erTlThoiGKhfv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDJK5PJNfiSNBSXTKQfjm7iZNffrj5Bpo16/VA7ekvPGJHMmzdJf5/89i74hqgx86
	 zdUbHsnLeKFJRv6e10mHei4Yhecq/Opnqj6HfvIpgmydd2FbQlUQ0pUZChWAFj14hJ
	 5qEuz8dY8C6E7qQbjejoMepTwn+ro4cjISI4Y71s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 033/563] perf/x86/intel: Fix IA32_PMC_x_CFG_B MSRs access error
Date: Mon, 13 Oct 2025 16:38:14 +0200
Message-ID: <20251013144412.488907664@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

[ Upstream commit 43796f30507802d93ead2dc44fc9637f34671a89 ]

When running perf_fuzzer on PTL, sometimes the below "unchecked MSR
 access error" is seen when accessing IA32_PMC_x_CFG_B MSRs.

[   55.611268] unchecked MSR access error: WRMSR to 0x1986 (tried to write 0x0000000200000001) at rIP: 0xffffffffac564b28 (native_write_msr+0x8/0x30)
[   55.611280] Call Trace:
[   55.611282]  <TASK>
[   55.611284]  ? intel_pmu_config_acr+0x87/0x160
[   55.611289]  intel_pmu_enable_acr+0x6d/0x80
[   55.611291]  intel_pmu_enable_event+0xce/0x460
[   55.611293]  x86_pmu_start+0x78/0xb0
[   55.611297]  x86_pmu_enable+0x218/0x3a0
[   55.611300]  ? x86_pmu_enable+0x121/0x3a0
[   55.611302]  perf_pmu_enable+0x40/0x50
[   55.611307]  ctx_resched+0x19d/0x220
[   55.611309]  __perf_install_in_context+0x284/0x2f0
[   55.611311]  ? __pfx_remote_function+0x10/0x10
[   55.611314]  remote_function+0x52/0x70
[   55.611317]  ? __pfx_remote_function+0x10/0x10
[   55.611319]  generic_exec_single+0x84/0x150
[   55.611323]  smp_call_function_single+0xc5/0x1a0
[   55.611326]  ? __pfx_remote_function+0x10/0x10
[   55.611329]  perf_install_in_context+0xd1/0x1e0
[   55.611331]  ? __pfx___perf_install_in_context+0x10/0x10
[   55.611333]  __do_sys_perf_event_open+0xa76/0x1040
[   55.611336]  __x64_sys_perf_event_open+0x26/0x30
[   55.611337]  x64_sys_call+0x1d8e/0x20c0
[   55.611339]  do_syscall_64+0x4f/0x120
[   55.611343]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

On PTL, GP counter 0 and 1 doesn't support auto counter reload feature,
thus it would trigger a #GP when trying to write 1 on bit 0 of CFG_B MSR
which requires to enable auto counter reload on GP counter 0.

The root cause of causing this issue is the check for auto counter
reload (ACR) counter mask from user space is incorrect in
intel_pmu_acr_late_setup() helper. It leads to an invalid ACR counter
mask from user space could be set into hw.config1 and then written into
CFG_B MSRs and trigger the MSR access warning.

e.g., User may create a perf event with ACR counter mask (config2=0xcb),
and there is only 1 event created, so "cpuc->n_events" is 1.

The correct check condition should be "i + idx >= cpuc->n_events"
instead of "i + idx > cpuc->n_events" (it looks a typo). Otherwise,
the counter mask would traverse twice and an invalid "cpuc->assign[1]"
bit (bit 0) is set into hw.config1 and cause MSR accessing error.

Besides, also check if the ACR counter mask corresponding events are
ACR events. If not, filter out these counter mask. If a event is not a
ACR event, it could be scheduled to an HW counter which doesn't support
ACR. It's invalid to add their counter index in ACR counter mask.

Furthermore, remove the WARN_ON_ONCE() since it's easily triggered as
user could set any invalid ACR counter mask and the warning message
could mislead users.

Fixes: ec980e4facef ("perf/x86/intel: Support auto counter reload")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20250820023032.17128-3-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c2fb729c270ec..15da60cf69f20 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2997,7 +2997,8 @@ static void intel_pmu_acr_late_setup(struct cpu_hw_events *cpuc)
 			if (event->group_leader != leader->group_leader)
 				break;
 			for_each_set_bit(idx, (unsigned long *)&event->attr.config2, X86_PMC_IDX_MAX) {
-				if (WARN_ON_ONCE(i + idx > cpuc->n_events))
+				if (i + idx >= cpuc->n_events ||
+				    !is_acr_event_group(cpuc->event_list[i + idx]))
 					return;
 				__set_bit(cpuc->assign[i + idx], (unsigned long *)&event->hw.config1);
 			}
-- 
2.51.0



