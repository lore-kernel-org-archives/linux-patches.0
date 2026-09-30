Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D3C36F905;
	Wed, 30 Sep 2026 19:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796931; cv=none; b=aGmAwjjkvDeqbMl0jCb+MRbWU4On+7z/h9hb+3mAz/kkflHlQjM0iayfkYdii0xBK57nhusvFoR6pg3GPf74F6D+4snyK4CcJnOa3H0FktfzA/CeHiilc28G1/pNN8VYtKBcHepDyZk4KAdAsG1S7CD5yjV5/kgPXrbRlE3VhNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796931; c=relaxed/simple;
	bh=lIebwmxOztNWs28SdV5kpncPGJZt6BaMYhAD4nkyuNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVb73LCir9xRnCqcevJm2IEYSez6W6KT/Qmy2qXWHC2jKN16pBBo56wB19pdVjDF+BTXycFtJtNK/5tbNaIksm4Dhc3HzUSOdMvDc/0o8cW+HQeeG79l7NungLQRKFlK00J/zK7GQiaGYnFu7AQPHn9TJNhA0Vuw78bOkK2hI40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtMmWJVU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtMmWJVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B001F000FF;
	Wed, 30 Sep 2026 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796929;
	bh=zP6IgZpp0oqgJhDTTOWtu/Bb2KFn4xOzDthyc9baabI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtMmWJVUK8beWtZcHSBLpd851cSZZLKhT38s50Jo7thjAYl9IRFmb0DIxgj9367/9
	 cxPet4fPF8YJAmlniOdDHQyuTfmjA2jd3iE4mBQ3rBFG762Qe6B8VNYqYYOpminuNz
	 aUEn/gW6Pcupg9d/xr/DRbLVFpjcWbKTFGZCl8yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1085/1193] perf/x86/intel: Dont pointlessly context switch DS_AREA (and PEBS config) if PEBS is unused
Date: Wed, 30 Sep 2026 17:29:29 +0200
Message-ID: <20260930152458.338289036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit d06260e99eb93d2942b7af4ccd789eb8a6c829d3 ]

When filling the list of MSRs to be loaded by KVM on VM-Enter and VM-Exit,
load the guest values for DS_AREA and (conditionally) MSR_PEBS_DATA_CFG if
and only if PEBS will be active in the guest, i.e. only if a PEBS record
may be generated while running the guest.  As shown by the !pebs_ept path,
it's perfectly safe to run with the host's DS_AREA, so long as PEBS-enabled
counters are disabled via PERF_GLOBAL_CTRL.

Omitting DS_AREA and MSR_PEBS_DATA_CFG when PEBS is unused saves two MSR
writes per MSR on each VMX transition, i.e. eliminates two/four pointless
MSR writes on each VMX roundtrip when PEBS isn't being used by the guest.

Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260921191418.950933-4-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 39 +++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 7afcf1567f5c3..98f92c366cb57 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4190,23 +4190,14 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		return arr;
 	}
 
+	/*
+	 * If the guest won't use PEBS or the CPU doesn't support PEBS in the
+	 * guest, then there's nothing more to do as disabling PMCs via
+	 * PERF_GLOBAL_CTRL is sufficient on CPUs with guest/host isolation.
+	 */
 	if (!kvm_pmu || !x86_pmu.pebs_ept)
 		return arr;
 
-	arr[(*nr)++] = (struct perf_guest_switch_msr){
-		.msr = MSR_IA32_DS_AREA,
-		.host = (unsigned long)cpuc->ds,
-		.guest = kvm_pmu->ds_area,
-	};
-
-	if (x86_pmu.intel_cap.pebs_baseline) {
-		arr[(*nr)++] = (struct perf_guest_switch_msr){
-			.msr = MSR_PEBS_DATA_CFG,
-			.host = cpuc->active_pebs_data_cfg,
-			.guest = kvm_pmu->pebs_data_cfg,
-		};
-	}
-
 	/*
 	 * Restrict guest PEBS events to counters that (a) perf supports, (b)
 	 * the guest wants to use for PEBS, (c) are not excluded from counting
@@ -4233,6 +4224,26 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	if (pebs_mask & ~cpuc->intel_ctrl_guest_mask)
 		guest_pebs_mask = 0;
 
+	/*
+	 * Context switch DS_AREA and PEBS_DATA_CFG if and only if PEBS will be
+	 * active in the guest; if no records will be generated while the guest
+	 * is running, then simply keep the host values resident in hardware.
+	 */
+	arr[(*nr)++] = (struct perf_guest_switch_msr){
+		.msr = MSR_IA32_DS_AREA,
+		.host = (unsigned long)cpuc->ds,
+		.guest = guest_pebs_mask ? kvm_pmu->ds_area : (unsigned long)cpuc->ds,
+	};
+
+	if (x86_pmu.intel_cap.pebs_baseline) {
+		arr[(*nr)++] = (struct perf_guest_switch_msr){
+			.msr = MSR_PEBS_DATA_CFG,
+			.host = cpuc->active_pebs_data_cfg,
+			.guest = guest_pebs_mask ? kvm_pmu->pebs_data_cfg :
+						   cpuc->active_pebs_data_cfg,
+		};
+	}
+
 	/*
 	 * Do NOT mess with PEBS_ENABLED.  As above, disabling counters via
 	 * PERF_GLOBAL_CTRL is sufficient, and loading a stale PEBS_ENABLED,
-- 
2.53.0



