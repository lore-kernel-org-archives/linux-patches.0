Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7086A481C0;
	Mon,  1 Apr 2024 15:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986782; cv=none; b=rjVaNyAKNQYkHOU+tdrCftBqLgGe/lyD+cK1ZvAty2/usPK36at8+gq0uzkYTclJZkj3UIYpHowI5WAs/6EX6UO7+7E8+anMSqZomRvHJtGlVjSyki4CkNO9lqKB8K93bA/ZpBDv7WWtYtJ+ADyvFHFb9lshKTyBL3g1yS5H3P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986782; c=relaxed/simple;
	bh=w0YDojS72hNfebJGkABhkdlWF/hI/zm6xPmwtowfzAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELWSip1AuNW2MMnDyMHAh1WqM09CS9KkaMC2fCsHrgP+E1H1iM6JE1m/VH01kMfQRX+LdvMMIWTjBCqUpj2mN44UGWdQFZC4Pi/MqrO6ntQ8EGsS1GwwswkTGCZ+Dzn9X1Xl4/JvmlMg8cX2DzyMZgqyRzDdhGzuKdwXpCM4Neg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=priCEIOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="priCEIOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE90FC433F1;
	Mon,  1 Apr 2024 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986782;
	bh=w0YDojS72hNfebJGkABhkdlWF/hI/zm6xPmwtowfzAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=priCEIOhXmQaaK4VxHkAeA+J9ZPijj58jDeQafGZmNLBxBsqGohKk62aOzRfUGDVH
	 /+y3g6bINIurYfad/tPhTTcPfwc+zwctNI9kza+sIwAONSoV/2b98sy/8NrCvukOdc
	 fSjM3nz6HEc7ZaAZlv5aoAC/r1HJqGAoAnsbLoIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 084/399] KVM: x86/xen: inject vCPU upcall vector when local APIC is enabled
Date: Mon,  1 Apr 2024 17:40:50 +0200
Message-ID: <20240401152551.686933219@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit 8e62bf2bfa46367e14d0ffdcde5aada08759497c ]

Linux guests since commit b1c3497e604d ("x86/xen: Add support for
HVMOP_set_evtchn_upcall_vector") in v6.0 onwards will use the per-vCPU
upcall vector when it's advertised in the Xen CPUID leaves.

This upcall is injected through the guest's local APIC as an MSI, unlike
the older system vector which was merely injected by the hypervisor any
time the CPU was able to receive an interrupt and the upcall_pending
flags is set in its vcpu_info.

Effectively, that makes the per-CPU upcall edge triggered instead of
level triggered, which results in the upcall being lost if the MSI is
delivered when the local APIC is *disabled*.

Xen checks the vcpu_info->evtchn_upcall_pending flag when the local APIC
for a vCPU is software enabled (in fact, on any write to the SPIV
register which doesn't disable the APIC). Do the same in KVM since KVM
doesn't provide a way for userspace to intervene and trap accesses to
the SPIV register of a local APIC emulated by KVM.

Fixes: fde0451be8fb3 ("KVM: x86/xen: Support per-vCPU event channel upcall via local APIC")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240227115648.3104-3-dwmw2@infradead.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c |  5 ++++-
 arch/x86/kvm/xen.c   |  2 +-
 arch/x86/kvm/xen.h   | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da24576..75bc7d3f0022d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -41,6 +41,7 @@
 #include "ioapic.h"
 #include "trace.h"
 #include "x86.h"
+#include "xen.h"
 #include "cpuid.h"
 #include "hyperv.h"
 #include "smm.h"
@@ -499,8 +500,10 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 	}
 
 	/* Check if there are APF page ready requests pending */
-	if (enabled)
+	if (enabled) {
 		kvm_make_request(KVM_REQ_APF_READY, apic->vcpu);
+		kvm_xen_sw_enable_lapic(apic->vcpu);
+	}
 }
 
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4b4e738c6f1b7..b0212ba2d87a6 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -493,7 +493,7 @@ void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
 		kvm_xen_update_runstate_guest(v, state == RUNSTATE_runnable);
 }
 
-static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
+void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 {
 	struct kvm_lapic_irq irq = { };
 	int r;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index f8f1fe22d0906..f5841d9000aeb 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -18,6 +18,7 @@ extern struct static_key_false_deferred kvm_xen_enabled;
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
 void kvm_xen_inject_pending_events(struct kvm_vcpu *vcpu);
+void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *vcpu);
 int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
@@ -36,6 +37,19 @@ int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 const struct kvm_irq_routing_entry *ue);
 void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
 
+static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * The local APIC is being enabled. If the per-vCPU upcall vector is
+	 * set and the vCPU's evtchn_upcall_pending flag is set, inject the
+	 * interrupt.
+	 */
+	if (static_branch_unlikely(&kvm_xen_enabled.key) &&
+	    vcpu->arch.xen.vcpu_info_cache.active &&
+	    vcpu->arch.xen.upcall_vector && __kvm_xen_has_interrupt(vcpu))
+		kvm_xen_inject_vcpu_vector(vcpu);
+}
+
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
@@ -101,6 +115,10 @@ static inline void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 }
 
+static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
+{
+}
+
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return false;
-- 
2.43.0



