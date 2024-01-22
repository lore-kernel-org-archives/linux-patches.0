Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626C7524B5;
	Tue, 23 Jan 2024 00:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969863; cv=none; b=qe+EnewbwN+i39Rtdxi42e2nHhjS0IJrJkBPgN7Akz2MJJDQUTebJ4EeclqYWCbxiftSyKvov8Ug3vZUyoYhtaKU1DbE0Bv8xLh8hxgHx3FA0TQ6fTIQR68nrWj9KqNO/H+IplLzQvftodh1u1pKZh3t2DuM2KB7+lyjEUVfMkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969863; c=relaxed/simple;
	bh=JJnK69n7y/3WI5vLn1OfvvlHC5zbcfm3Iv7hLvVTc74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFK3GiSIdIu+DyfklPklgnmxCM6lxpNwApBnKIXYBwD2od+hqy9ZpMuX2VYZH4F4+zLCJSI42HyX6JkuUDDaOgSTkEtGfKrc+5rUbD+miMzROxPIRtsSvAp8FcwgZIh1ti1QXmNOKOkyp+r4V9yIPi0J03BQRQ5Yh7zeWqkloPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2prFEuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2prFEuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220BFC433C7;
	Tue, 23 Jan 2024 00:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969863;
	bh=JJnK69n7y/3WI5vLn1OfvvlHC5zbcfm3Iv7hLvVTc74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2prFEuLK8rXwYxk7v1fpJNd7Vi/bT0xJPHnWzYLEgpqCN4BaQ1tADcBHM7/oVnhi
	 VlOomFyI6/yAq2ApJXOz7htlQP68XNJXhIam81bFcIDX7n7MNw5hHd2qknBXDTYIpz
	 qin5NGzXC0Jb/x1DyEMTQFOuQoSxePLPGCAkI6AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.7 475/641] KVM: x86/pmu: Reset the PMU, i.e. stop counters, before refreshing
Date: Mon, 22 Jan 2024 15:56:19 -0800
Message-ID: <20240122235832.923376288@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


