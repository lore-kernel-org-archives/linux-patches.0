Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F7347125C;
	Tue, 21 Jul 2026 18:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658366; cv=none; b=q86QrB1HHWWK4hv+NFLQhWMLd/ES632gCjots6u0mScVHj3XcPMESn2sCCacIMn1lHNP5k6nQoT8DwBgKxhs0j7N4Vayt5bgpV++De0plju3eRjUHiov6AG3QYb9cClEkTDse/CeNvWLWni3VU7MqaG/WatkIT4i4l/0qLgqDGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658366; c=relaxed/simple;
	bh=dTsrUfmTTxyuckkiFWRIwFxl70ure+lKVd3lvwzwULw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzoOWMZE5WibxlXfWyW0Vy2wVdccLCreDeHJEbBSk0/g0JuwcvwN1cQKqfamyqTyA/C9AOtHxeMtDFpRsoaZgoyV5Smvm6rWsxNwPQC6OcOnV+BZBBWA97DBUXYDEY94ut/F+vtCJ6LdMUkqITFijeXLmppmR6z9ZTye6pc68mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oymQ+6Xv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oymQ+6Xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF561F00A3A;
	Tue, 21 Jul 2026 18:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658364;
	bh=FeOwtSY1sG/LACYhgG3vXnGxCtzePPtR/SZUJiWfNlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oymQ+6Xvjnfaw5YohNBd1nfADuSNZ0ssTEBSO3SmM8LlB+kBURproTUFTDct9f400
	 6dPcBcwdLZEFCwcbtRuMtUUVphvo9j/tPtijM1F5VKVdd/WUdMYmTbxtg68hMOWmWc
	 Sh16ZnVJV5acF14uUdZ6YC572L7Njzqf4FajLoTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1072/1611] perf/x86/amd/core: Avoid enabling BRS from the SVM reload path
Date: Tue, 21 Jul 2026 17:19:48 +0200
Message-ID: <20260721152539.520864237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 07c60dda9c059c09f83d42a3ebda2e7cc1cf3bc2 ]

Branch Sampling (BRS) and Last Branch Record (LBR) are mutually
exclusive hardware features, and users of both are tracked via
cpuc->lbr_users.

When SVM is toggled on a CPU, the host perf events are reprogrammed to
update the HostOnly filter bit (set when virtualization is enabled,
cleared when it is disabled). On PerfMonV2-capable processors, this
reprogramming is performed by calling amd_pmu_enable_all() to rewrite
the event selectors. However, amd_pmu_enable_all() also calls
amd_brs_enable_all(), which enables BRS whenever cpuc->lbr_users > 0.
Having active LBR events satisfies this gating on processors that have
LBR but not BRS. The kernel then tries to set the BRS enable bit in
DebugExtnCfg (MSR 0xc000010f). Since that bit is deprecated on such
hardware, the write results in a #GP:

  Call Trace:
   <IRQ>
   amd_pmu_enable_all+0x1d/0x90
   amd_pmu_disable_virt+0x62/0xb0
   kvm_arch_disable_virtualization_cpu+0xa/0x40 [kvm]
   hardware_disable_nolock+0x1a/0x30 [kvm]
   __flush_smp_call_function_queue+0x9b/0x410
   __sysvec_call_function+0x18/0xc0
   sysvec_call_function+0x69/0x90
   </IRQ>
   <TASK>
   asm_sysvec_call_function+0x16/0x20
  RIP: 0010:cpuidle_enter_state+0xc4/0x450
   ? cpuidle_enter_state+0xb7/0x450
   cpuidle_enter+0x29/0x40
   cpuidle_idle_call+0xf5/0x160
   do_idle+0x7b/0xe0
   cpu_startup_entry+0x26/0x30
   start_secondary+0x115/0x140
   secondary_startup_64_no_verify+0x194/0x19b
   </TASK>

Fix this by ensuring that BRS is not enabled from the event selector
reprogramming path even when cpuc->lbr_users > 0.

Fixes: bae19fdd7e9e ("perf/x86/amd/core: Fix reloading events for SVM")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://patch.msgid.link/702fa204d574b03d14e3664c7d4b201db048bbfd.1783506528.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index e7d30908f25e5b..1325a49b3f6651 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -751,13 +751,11 @@ static void amd_pmu_enable_event(struct perf_event *event)
 	x86_pmu_enable_event(event);
 }
 
-static void amd_pmu_enable_all(int added)
+static void __amd_pmu_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx;
 
-	amd_brs_enable_all();
-
 	for_each_set_bit(idx, x86_pmu.cntr_mask, X86_PMC_IDX_MAX) {
 		/* only activate events which are marked as active */
 		if (!test_bit(idx, cpuc->active_mask))
@@ -772,6 +770,12 @@ static void amd_pmu_enable_all(int added)
 	}
 }
 
+static void amd_pmu_enable_all(int added)
+{
+	amd_brs_enable_all();
+	__amd_pmu_enable_all();
+}
+
 static void amd_pmu_v2_enable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -1556,7 +1560,7 @@ static inline void amd_pmu_reload_virt(void)
 		 * set global enable bits once again
 		 */
 		amd_pmu_v2_disable_all();
-		amd_pmu_enable_all(0);
+		__amd_pmu_enable_all();
 		amd_pmu_v2_enable_all(0);
 		return;
 	}
-- 
2.53.0



