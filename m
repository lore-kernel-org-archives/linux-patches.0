Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB5C51AEEE;
	Wed, 30 Sep 2026 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789491; cv=none; b=BXfeWhGTx76iZDT4gixo7Wagwec3335CaGdNAXBAYAM36LJ03rMzvNkjUGfa7f4+zhDy/z4mvroARQCCCcJNLSsWhJia8J0gyyh4xOmpZwO9oZ0R7tkYSI0+8HNvF/rh1Jrx8W38cQhfIVpc/fU2WPSUM0t5d0na7OBt4Fd1idE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789491; c=relaxed/simple;
	bh=A/24YctoQ+PP2Q+auQTi4HNPV/vz1ACNqRjbi0ZfjEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lv4NjTLi4+yULFFC0YYoktEeEbE5CpKtAde3D6e0Pi3IxoZ1E3Fd5UfN/TdWyA0pbHy9dnRHGLDowWAnZ4HwugMaUCui9qprvt4UyhDGcDgiQ6j87SMlen3ybaaBTqRVFbp5M1oGXXer1xzruqpmCTtL+Ctb+ngVoB56LjoCOMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psCozqOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psCozqOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129C61F000FF;
	Wed, 30 Sep 2026 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789490;
	bh=4QUx6Tg7K0dmy8NmYIGIfq0jZCVRkEhrzgC7OCu8wiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psCozqOuIqSwbz+D6ITz4bamvaS8GHEhJcRHLvpXhMh94Ns/kC2dHeatHuScUK+L4
	 j7ibaC0uAXIxqg7S/OE9SmuZDZEqTS/1DGcpz8v3Q1Mbs5TB6DahjhFSxrFaIuqrjl
	 iugee0ctC4z/g4x6XH11PMXmh2cecZjWOlYZQO6A=
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
Subject: [PATCH 6.12 451/877] perf/x86/intel: Dont pointlessly context switch DS_AREA (and PEBS config) if PEBS is unused
Date: Wed, 30 Sep 2026 17:22:42 +0200
Message-ID: <20260930152424.412338892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 573298a35005f..313456a90bcbe 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4326,23 +4326,14 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
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
@@ -4369,6 +4360,26 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
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



