Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBC347143B;
	Tue, 21 Jul 2026 19:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663410; cv=none; b=SAFEwyXkufSe5+2Z9Sju8Yav5a8pmXxSHEGdmiqeNWYgP9lLuoQD3VRoxWuI9eGkUZuHPxFP5Z4znlyEcFrEp7KchRhFyel+zk3s/SEP9WNUqhXL0JAcldZ3ytkDwrEN9I6O/zm8Ac3QMBj7sjnupFJ4OH73/xtBNvfUdqAABB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663410; c=relaxed/simple;
	bh=yCWJKxJ65zm0edKs6ZniJPF69DYJKnMoCPLl6h4Lfuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1HxI2OxwdlNrOXR4wUdFeGrTgerPliB/CE01cL1lMsDkHmjC22UIg+IzsUxPoOMQTzJx/ZVXotWS/v7KuqByLG8t5dX1l/sxbWZCgzHicplbXRu2uAubvSSrwYLsDJMd4P6bzpowJuPTHZjZXW40LccusraaonLeETJSJhWRFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aT70jYd1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aT70jYd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F021F000E9;
	Tue, 21 Jul 2026 19:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663409;
	bh=RsEYFxYWOyOiIKuylAMBCxGs8oMa8sD9Dz9pXtq7JL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aT70jYd12jYboCQR+dP1Rlau3lPqng2fJka2B3/czTx5ColzIDyRA9BGnYPqm3/n9
	 jbu/PskL/G5OJnqLNcJJYCuH4UGxoBfpuITQfK2N2gUekzBA49cHl61Nne5KcEfKpR
	 ymaxET4J4nkYWM4aVS5h8xFdNVe2ELZXxTnh+oxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0785/1276] perf/x86/amd/core: Avoid enabling BRS from the SVM reload path
Date: Tue, 21 Jul 2026 17:20:28 +0200
Message-ID: <20260721152503.647471384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 6ca2301e81ccd4..09b973deed3439 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -750,13 +750,11 @@ static void amd_pmu_enable_event(struct perf_event *event)
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
@@ -771,6 +769,12 @@ static void amd_pmu_enable_all(int added)
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
@@ -1557,7 +1561,7 @@ static inline void amd_pmu_reload_virt(void)
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



