Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4527B745D6;
	Tue, 23 Jan 2024 02:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975477; cv=none; b=GOWBPXUw88z3LJ6ubJry4qyuxO83DRicpkcS8uuA5h9usPSAnCoSAJvZjf6/Zc/zIgtlvqhEgh67+cKyREv6jeudA02j0nhuzULTQCzdbImxqQK1XYi/dK+KfHgKDwBYXSJ4x1MSG/I7OMBvYn82MSZKO7+gpXcOnTeBNGLzWZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975477; c=relaxed/simple;
	bh=g2F2j0hPt+bqd3f78JnoscRGmcWg6VI/vrYiCBkpjBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9T8ZJbD202unQJwCoTqujxBZMq61TODEiCZIp82dtCyxXxPptoensvUnpmRYhFNUEZiT1NggAQdm05oiCxjjdnlFXg6jjhTpo7rRxJuU2A7EXMZT8xUP5eY9oYp3bZHZK2vHHK+Rt7zPCGSWEuJddQazrs8vW8IBaINrP4NyYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2szPMjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2szPMjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08232C433C7;
	Tue, 23 Jan 2024 02:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975477;
	bh=g2F2j0hPt+bqd3f78JnoscRGmcWg6VI/vrYiCBkpjBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2szPMjNx4sqGGZm42hyakSlzJbPrTaJMrKHanORjiawzSuR42NAo7eqt2J7qSUI6
	 5DAgNwZ4AmaRSqhf8t0hU6K1uTZMGkkSHr5fRczyR7eFE1+qWSL+kS7pjm4pdvIlml
	 fbddUmaXIua67r/2eRcndai4Y78D9pskng4u8XCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 431/583] KVM: x86/pmu: Reset the PMU, i.e. stop counters, before refreshing
Date: Mon, 22 Jan 2024 15:58:02 -0800
Message-ID: <20240122235825.170610265@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 1647b52757d59131fe30cf73fa36fac834d4367f upstream.

Stop all counters and release all perf events before refreshing the vPMU,
i.e. before reconfiguring the vPMU to respond to changes in the vCPU
model.

Clear need_cleanup in kvm_pmu_reset() as well so that KVM doesn't
prematurely stop counters, e.g. if KVM enters the guest and enables
counters before the vCPU is scheduled out.

Cc: stable@vger.kernel.org
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://lore.kernel.org/r/20231103230541.352265-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/pmu.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -657,25 +657,14 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcp
 	return 0;
 }
 
-/* refresh PMU settings. This function generally is called when underlying
- * settings are changed (such as changes of PMU CPUID by guest VMs), which
- * should rarely happen.
- */
-void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
-{
-	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
-		return;
-
-	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
-	static_call(kvm_x86_pmu_refresh)(vcpu);
-}
-
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 	int i;
 
+	pmu->need_cleanup = false;
+
 	bitmap_zero(pmu->reprogram_pmi, X86_PMC_IDX_MAX);
 
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
@@ -695,6 +684,26 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu
 	static_call_cond(kvm_x86_pmu_reset)(vcpu);
 }
 
+
+/*
+ * Refresh the PMU configuration for the vCPU, e.g. if userspace changes CPUID
+ * and/or PERF_CAPABILITIES.
+ */
+void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
+{
+	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
+		return;
+
+	/*
+	 * Stop/release all existing counters/events before realizing the new
+	 * vPMU model.
+	 */
+	kvm_pmu_reset(vcpu);
+
+	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
+	static_call(kvm_x86_pmu_refresh)(vcpu);
+}
+
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);


