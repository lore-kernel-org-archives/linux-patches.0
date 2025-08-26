Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6168338F32;
	Tue, 26 Aug 2025 13:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214144; cv=none; b=qGg+xwDJnSVBPoJrtbiEWLadKxi7G6af5quvHy0yzK5hPXbxajXndWKijy5MakeVcSvpGxJkToycL0QFKlzI399Fh26V5zR8yrWyYM66Kn9fLAuycc93uw0qk04zhd33Zn/wwmRInYDRY1X8SO7PZupNIQEkWQXlpXOsEnBBVLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214144; c=relaxed/simple;
	bh=UC77DIMbwOw/2H+LIL5A3LisSUX1BvusHrVeV7tQNik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhjpcRVtVGYzra9u3G0crj+GgtPXPfwZnb22MbAbWxXUut1s304N5Yw/S2H+8NGh0O016Q3i7GqqYQWUCltihkm0wOwkwJuzUStdGt2mVE98tfVJHVg8HL6ikvH0MHB2Vmbv3dc/AHnmcngxQO1kQsv5ODjPwPM3ENEWZ9Fdp+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYLpglAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYLpglAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BB7C4CEF1;
	Tue, 26 Aug 2025 13:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214144;
	bh=UC77DIMbwOw/2H+LIL5A3LisSUX1BvusHrVeV7tQNik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYLpglAWj8Jd/o5zAuGnS6VeWS3YmOCWPwPRICWzaWS5X88os5wDqUiduH5xGCojS
	 QKil/WFBMiiJrO4zA+3LJH924CavH/qLzjAujqXdqUw6cvVjpso/D4oqgrkJfbkpoU
	 bTA33easVq7NQvyBRmnZXWiUwx8n7pLpP+Hx4uE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/482] KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for AMD (x2AVIC)
Date: Tue, 26 Aug 2025 13:04:41 +0200
Message-ID: <20250826110931.497374924@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 73b42dc69be8564d4951a14d00f827929fe5ef79 ]

Re-introduce the "split" x2APIC ICR storage that KVM used prior to Intel's
IPI virtualization support, but only for AMD.  While not stated anywhere
in the APM, despite stating the ICR is a single 64-bit register, AMD CPUs
store the 64-bit ICR as two separate 32-bit values in ICR and ICR2.  When
IPI virtualization (IPIv on Intel, all AVIC flavors on AMD) is enabled,
KVM needs to match CPU behavior as some ICR ICR writes will be handled by
the CPU, not by KVM.

Add a kvm_x86_ops knob to control the underlying format used by the CPU to
store the x2APIC ICR, and tune it to AMD vs. Intel regardless of whether
or not x2AVIC is enabled.  If KVM is handling all ICR writes, the storage
format for x2APIC mode doesn't matter, and having the behavior follow AMD
versus Intel will provide better test coverage and ease debugging.

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20240719235107.3023592-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: resolve minor syntatic conflicts]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/lapic.c            | 42 +++++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 4 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eb06c2f68314..17b4e61a52b9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1547,6 +1547,8 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
+
+	const bool x2apic_icr_is_split;
 	bool (*check_apicv_inhibit_reasons)(enum kvm_apicv_inhibit reason);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7f57dce5c828..42eec987ac3d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2315,11 +2315,25 @@ int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
 	data &= ~APIC_ICR_BUSY;
 
 	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
-	kvm_lapic_set_reg64(apic, APIC_ICR, data);
+	if (kvm_x86_ops.x2apic_icr_is_split) {
+		kvm_lapic_set_reg(apic, APIC_ICR, data);
+		kvm_lapic_set_reg(apic, APIC_ICR2, data >> 32);
+	} else {
+		kvm_lapic_set_reg64(apic, APIC_ICR, data);
+	}
 	trace_kvm_apic_write(APIC_ICR, data);
 	return 0;
 }
 
+static u64 kvm_x2apic_icr_read(struct kvm_lapic *apic)
+{
+	if (kvm_x86_ops.x2apic_icr_is_split)
+		return (u64)kvm_lapic_get_reg(apic, APIC_ICR) |
+		       (u64)kvm_lapic_get_reg(apic, APIC_ICR2) << 32;
+
+	return kvm_lapic_get_reg64(apic, APIC_ICR);
+}
+
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
@@ -2337,7 +2351,7 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	 * maybe-unecessary write, and both are in the noise anyways.
 	 */
 	if (apic_x2apic_mode(apic) && offset == APIC_ICR)
-		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR)));
+		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_x2apic_icr_read(apic)));
 	else
 		kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
 }
@@ -2760,18 +2774,22 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 
 		/*
 		 * In x2APIC mode, the LDR is fixed and based on the id.  And
-		 * ICR is internally a single 64-bit register, but needs to be
-		 * split to ICR+ICR2 in userspace for backwards compatibility.
+		 * if the ICR is _not_ split, ICR is internally a single 64-bit
+		 * register, but needs to be split to ICR+ICR2 in userspace for
+		 * backwards compatibility.
 		 */
-		if (set) {
+		if (set)
 			*ldr = kvm_apic_calc_x2apic_ldr(*id);
 
-			icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
-			      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
-			__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
-		} else {
-			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
-			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
+		if (!kvm_x86_ops.x2apic_icr_is_split) {
+			if (set) {
+				icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
+				      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
+				__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
+			} else {
+				icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
+				__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
+			}
 		}
 	}
 
@@ -2971,7 +2989,7 @@ static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
 	u32 low;
 
 	if (reg == APIC_ICR) {
-		*data = kvm_lapic_get_reg64(apic, APIC_ICR);
+		*data = kvm_x2apic_icr_read(apic);
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c95a84afc35f..b922f31d1415 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4851,6 +4851,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
+
+	.x2apic_icr_is_split = true,
 	.set_virtual_apic_mode = avic_refresh_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fbe26b88f731..9a5cb896229f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8202,6 +8202,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.enable_nmi_window = vmx_enable_nmi_window,
 	.enable_irq_window = vmx_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
+
+	.x2apic_icr_is_split = false,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
-- 
2.50.1



