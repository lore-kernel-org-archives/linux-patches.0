Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687072F0C52;
	Mon, 22 Sep 2025 19:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570069; cv=none; b=nCrWpKjLtHWG0xEG2uzoOTOkY3WsE/kzZrBja8A/o56ugL5VrGDxYyiY3naEsORLRMjTMyLo3eLLGOARTq91GSO7OdLCs8iUq0l9TqFMmMzCz9gXo+rJ+SMer3hRxOtqbL2F6S5kiS7TxE3FeHL0XDYN4B44quH1gUdR2Eec6KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570069; c=relaxed/simple;
	bh=lb/NJVixgtLmi+G9bPDmLUJd9RNMHt4m4HIAVHjXv9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObhSqnhbeP8srtuaszR+sjUNNXQefSi4dJSqa8LWTdEHdcIGGcvcXNOAjkUXCb5/h/RgcgZga6n0tMI0HTHs1sphaEnOArpska32bfwPeANv1E0clv2+wtqmTWN4iCdypNyq5y852Z9zC1Qh5HxcFUNMnBdGhKoUTVMXhTmOeRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCGDJKJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCGDJKJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B2BC4CEF0;
	Mon, 22 Sep 2025 19:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570069;
	bh=lb/NJVixgtLmi+G9bPDmLUJd9RNMHt4m4HIAVHjXv9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCGDJKJk5WpBbM0vnczrZGCMhyaeB11F86rUx70hxK016+vrp5w3aUlaWAIKaxaU8
	 DCItx/KLwptMCkPDJziJpW1B4p2dOrcgb11vLwXVYOGcYhrARaSmT7ZwkL9Ji+VffL
	 MRpzaNpTg6nwrVKlKy5jXO/PKRpPAKxyDkfn9IcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Larabel <Michael@michaellarabel.com>,
	Borislav Petkov <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 089/105] KVM: SVM: Set/clear SRSOs BP_SPEC_REDUCE on 0 <=> 1 VM count transitions
Date: Mon, 22 Sep 2025 21:30:12 +0200
Message-ID: <20250922192411.237774445@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit e3417ab75ab2e7dca6372a1bfa26b1be3ac5889e upstream.

Set the magic BP_SPEC_REDUCE bit to mitigate SRSO when running VMs if and
only if KVM has at least one active VM.  Leaving the bit set at all times
unfortunately degrades performance by a wee bit more than expected.

Use a dedicated spinlock and counter instead of hooking virtualization
enablement, as changing the behavior of kvm.enable_virt_at_load based on
SRSO_BP_SPEC_REDUCE is painful, and has its own drawbacks, e.g. could
result in performance issues for flows that are sensitive to VM creation
latency.

Defer setting BP_SPEC_REDUCE until VMRUN is imminent to avoid impacting
performance on CPUs that aren't running VMs, e.g. if a setup is using
housekeeping CPUs.  Setting BP_SPEC_REDUCE in task context, i.e. without
blasting IPIs to all CPUs, also helps avoid serializing 1<=>N transitions
without incurring a gross amount of complexity (see the Link for details
on how ugly coordinating via IPIs gets).

Link: https://lore.kernel.org/all/aBOnzNCngyS_pQIW@google.com
Fixes: 8442df2b49ed ("x86/bugs: KVM: Add support for SRSO_MSR_FIX")
Reported-by: Michael Larabel <Michael@michaellarabel.com>
Closes: https://www.phoronix.com/review/linux-615-amd-regression
Cc: Borislav Petkov <bp@alien8.de>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20250505180300.973137-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   71 ++++++++++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h |    2 +
 2 files changed, 67 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -608,9 +608,6 @@ static void svm_disable_virtualization_c
 	kvm_cpu_svm_disable();
 
 	amd_pmu_disable_virt();
-
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -688,9 +685,6 @@ static int svm_enable_virtualization_cpu
 		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
 	}
 
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
-
 	return 0;
 }
 
@@ -1513,6 +1507,63 @@ static void svm_vcpu_free(struct kvm_vcp
 	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
 }
 
+#ifdef CONFIG_CPU_MITIGATIONS
+static DEFINE_SPINLOCK(srso_lock);
+static atomic_t srso_nr_vms;
+
+static void svm_srso_clear_bp_spec_reduce(void *ign)
+{
+	struct svm_cpu_data *sd = this_cpu_ptr(&svm_data);
+
+	if (!sd->bp_spec_reduce_set)
+		return;
+
+	msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+	sd->bp_spec_reduce_set = false;
+}
+
+static void svm_srso_vm_destroy(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		return;
+
+	if (atomic_dec_return(&srso_nr_vms))
+		return;
+
+	guard(spinlock)(&srso_lock);
+
+	/*
+	 * Verify a new VM didn't come along, acquire the lock, and increment
+	 * the count before this task acquired the lock.
+	 */
+	if (atomic_read(&srso_nr_vms))
+		return;
+
+	on_each_cpu(svm_srso_clear_bp_spec_reduce, NULL, 1);
+}
+
+static void svm_srso_vm_init(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		return;
+
+	/*
+	 * Acquire the lock on 0 => 1 transitions to ensure a potential 1 => 0
+	 * transition, i.e. destroying the last VM, is fully complete, e.g. so
+	 * that a delayed IPI doesn't clear BP_SPEC_REDUCE after a vCPU runs.
+	 */
+	if (atomic_inc_not_zero(&srso_nr_vms))
+		return;
+
+	guard(spinlock)(&srso_lock);
+
+	atomic_inc(&srso_nr_vms);
+}
+#else
+static void svm_srso_vm_init(void) { }
+static void svm_srso_vm_destroy(void) { }
+#endif
+
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1545,6 +1596,11 @@ static void svm_prepare_switch_to_guest(
 	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE) &&
+	    !sd->bp_spec_reduce_set) {
+		sd->bp_spec_reduce_set = true;
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+	}
 	svm->guest_state_loaded = true;
 }
 
@@ -5010,6 +5066,8 @@ static void svm_vm_destroy(struct kvm *k
 {
 	avic_vm_destroy(kvm);
 	sev_vm_destroy(kvm);
+
+	svm_srso_vm_destroy();
 }
 
 static int svm_vm_init(struct kvm *kvm)
@@ -5035,6 +5093,7 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	svm_srso_vm_init();
 	return 0;
 }
 
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -335,6 +335,8 @@ struct svm_cpu_data {
 	u32 next_asid;
 	u32 min_asid;
 
+	bool bp_spec_reduce_set;
+
 	struct vmcb *save_area;
 	unsigned long save_area_pa;
 


