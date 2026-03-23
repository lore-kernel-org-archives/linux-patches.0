Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20E83B8BCD;
	Mon, 23 Mar 2026 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278672; cv=none; b=rlX8DXiaOqpfPRNnFPZX7cK+WHc1lj3kufT/FgsHFkq+0PEwWssoFN+M6TpQleGXmnu2sFT4xEX7AccnRq5pomD8fQDLYMSP0YmXaqVBaxLCgGR0Cu+k73eZsX5Kti7dzw3frvxsqMuw9wCb82hiC8XvYfdRKENMsY2XYM6+L3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278672; c=relaxed/simple;
	bh=j7hCEgfySAfsriiwiAi37wufdcvfI3GgguHuFE2YB78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImgUGhHynVAgxq5BPOKPIdGPuIb0t6keblIQ8uVCdkGTZh4NpySb3lOaktDFd/4WZCVeUJVS6bxurONy3+JqEF+L2wd7r3arwG65rmpTjrCeWjnjhzUNZPE3fxJMgN1+zv/DYgdwyy2nYNZdwbYJEQKgkTEk9wcMHaBWaEgSjPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnLAfsS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnLAfsS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B7EC4CEF7;
	Mon, 23 Mar 2026 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278671;
	bh=j7hCEgfySAfsriiwiAi37wufdcvfI3GgguHuFE2YB78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnLAfsS8I/k6Yiu0kIt5Bcw2sq968j4wORiCUX3KOBssL7mLcrQ97vkdJef2BkWnd
	 aef7uNiWcCyhqvM/wEX0AOIMxXidA8xXsb4ShOmz0naaA3Qhdr9zdFKj/5Ww+ua9Lf
	 VHIN5B57QbthIMPUf2Ucl1FwVV3srFiPGNSwV1rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 383/567] KVM: SVM: Add a helper to look up the max physical ID for AVIC
Date: Mon, 23 Mar 2026 14:45:03 +0100
Message-ID: <20260323134543.320727656@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Naveen N Rao <naveen@kernel.org>

[ Upstream commit f2f6e67a56dc88fea7e9b10c4e79bb01d97386b7 ]

To help with a future change, add a helper to look up the maximum
physical ID depending on the vCPU AVIC mode. No functional change
intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
Link: https://lore.kernel.org/r/0ab9bf5e20a3463a4aa3a5ea9bbbac66beedf1d1.1757009416.git.naveen@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 87d0f901a9bd ("KVM: SVM: Set/clear CR8 write interception when AVIC is (de)activated")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -82,13 +82,31 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
+static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
+{
+	u32 arch_max;
+
+	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic))
+		arch_max = X2AVIC_MAX_PHYSICAL_ID;
+	else
+		arch_max = AVIC_MAX_PHYSICAL_ID;
+
+	/*
+	 * Despite its name, KVM_CAP_MAX_VCPU_ID represents the maximum APIC ID
+	 * plus one, so the max possible APIC ID is one less than that.
+	 */
+	return min(vcpu->kvm->arch.max_vcpu_ids - 1, arch_max);
+}
+
 static void avic_activate_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
-	struct kvm *kvm = svm->vcpu.kvm;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+	vmcb->control.avic_physical_id |= avic_get_max_physical_id(vcpu);
 
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 
@@ -101,8 +119,7 @@ static void avic_activate_vmcb(struct vc
 	 */
 	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
-		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
-						      X2AVIC_MAX_PHYSICAL_ID);
+
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
@@ -112,9 +129,6 @@ static void avic_activate_vmcb(struct vc
 		 */
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
 
-		/* For xAVIC and hybrid-xAVIC modes */
-		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
-						      AVIC_MAX_PHYSICAL_ID);
 		/* Enabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, true);
 	}


