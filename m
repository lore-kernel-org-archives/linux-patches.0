Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C6E2F6160;
	Tue, 17 Mar 2026 17:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768499; cv=none; b=IuaeM42/meAjvYcCOCLRsT9yT7XgL9fNj2wkWg4GK1AcRJNa4/ccEnGZPaORVlkhY/gvApwfCi1MJPrA1iRVTNzCV3I4385Kwyc4GzPfcBlkzjCvh4y0NzmKEa1ElfodcNsnmrPwFpZyLDKr3xH2wlEU+yxnwaU2ZY9G8eTvaIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768499; c=relaxed/simple;
	bh=oDa2VUZqPFDvtMCH8MotnXszbUfzx1hWL4b3Ruzg0Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JorfyA49eHV7tgmP/+op/xyfWO6+bf23YMVmjebWIVR34T4sehXagvQgXnj/tTPcestbmcL7SkxyLY/fMKP+Ij37Pc6HjARXn5TJXTq1dQEk21YyENrhpYtkN61M/i7qmVCzPD1gfv0jNSejdmeo7ib035L8mm6+dTsePjrh1us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rp5mJGLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rp5mJGLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C33C4CEF7;
	Tue, 17 Mar 2026 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768499;
	bh=oDa2VUZqPFDvtMCH8MotnXszbUfzx1hWL4b3Ruzg0Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rp5mJGLw+UrQJF7VeVO/xbS3N04CBOpuQyuDyviBX01Ccq+929qU1bRo8PxrvI9lV
	 2IO4WucqSMGXA2utPxrqoiO+zacPAhfc0KrYVI711ACCo8ibEjndzdQGMWkxl7kkkn
	 Fkh5sseTh+XoUDoH/63kp42U1xvXMxgtIMTdSpjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 324/333] KVM: SVM: Add a helper to look up the max physical ID for AVIC
Date: Tue, 17 Mar 2026 17:35:53 +0100
Message-ID: <20260317163011.416051811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
@@ -158,13 +158,31 @@ static void avic_set_x2apic_msr_intercep
 	svm->x2avic_msrs_intercepted = intercept;
 }
 
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
 
@@ -177,8 +195,7 @@ static void avic_activate_vmcb(struct vc
 	 */
 	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
-		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
-						      X2AVIC_MAX_PHYSICAL_ID);
+
 		/* Disabling MSR intercept for x2APIC registers */
 		avic_set_x2apic_msr_interception(svm, false);
 	} else {
@@ -188,9 +205,6 @@ static void avic_activate_vmcb(struct vc
 		 */
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
 
-		/* For xAVIC and hybrid-xAVIC modes */
-		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
-						      AVIC_MAX_PHYSICAL_ID);
 		/* Enabling MSR intercept for x2APIC registers */
 		avic_set_x2apic_msr_interception(svm, true);
 	}


