Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061507;
	b=IGCPpMUOZMystZaTUKw+f9ApBwo2LGWt9A0D2AxZSsrNWmY2CA81xsJ78zPc0N+JiPaR
	 Bky212Slyl7zbGgcGJw4fhoWQ4oBncAZZ+k+3nNQfr4IYtnZqlbTjHSiUDSz5gYd07vnN
	 cOFilmdeL9w4rij/8siF+s7+e/VA4t1MpeQ/Ke38/pnJl9As8250qzepbXy9WW28fGOrF
	 cTKCiL5jj7rPj7NFbw7ia1aYAQR0sb1j7xEN+3rosYqrq4alOcXpUNRVWZp2HnbbmCUPl
	 MpOPgxnsdFdkghbSVK1jLeEcDckSSHo94CSMC69Ou+h8uDP6v5kfWgiYDLNkrKSRYdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mkba6+hUaZzSvgdo8cRwkM6o5Gb97sublOPViaehTBk=;
	b=qoT38rfIcow6gWqPuPDHQuy7HCQuzsGLnrNbeS8qWt8UdU3DmcnLunCIPPTVa8vLNBub
	 DvYAUqfg+Py2BvjZeoWHyFRc699Vd3yRnbK2hVj4EPpPa0HusyAbfybVN6+QiJnqXLYPk
	 IvJGB0aIvkeNm0kunjaKocbYBAhMmaZKGQM5IVrN8/6ms0lwmEPkJ4fKlW4X4nTbArs/D
	 ZLPLaz3sibwJRFVzbbc19+DBNo5D+xgwtgF+02RwFrB1zGBpebBf+yX7K7MBKj2VIp8BA
	 HW3JiFE8K1/kh2VC6i2T1faOrVXZfVTcYNRofybglDyeTqpG6YH6Vw3J4vNYGYlaLFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSYnOnxf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A0E606A326;
	Sat,  7 Nov 2026 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSYnOnxf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4051F0089F;
	Sat,  7 Nov 2026 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061507;
	bh=mkba6+hUaZzSvgdo8cRwkM6o5Gb97sublOPViaehTBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSYnOnxf6EsvuwBviH+sNnAYbzLVD/MFSqgg+ayZjWmPSaKpe3n6a8T6jaGrs2nWa
	 d20O0VP2G+Qr1UTd6Yt/hnGT0c6gsTE7FfJLCv1nxG9XszyuNB3LaP0czEUtAB2+Or
	 /sPQ6nvYYB6E31SReBCggLM+6aiaqpMTphAqOEnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0599/1536] KVM: x86: Tell ->inject_page_fault() whether or a fault came from hardware
Date: Sat,  7 Nov 2026 08:43:35 -0500
Message-ID: <20261107135014.366969325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit fe0b872d750023eda270cbc01c53ead52b1049d8 ]

When injecting a page fault (including nested TDP faults into L1), tell the
injection routine whether or not the fault originated in hardware, i.e. if
KVM is effectively forwarding a fault it intercept.  For nested TDP fault
injection, KVM needs to grab PAGE_WALK vs. GUEST_FINAL information from the
VMCB/VMCS, _if_ the fault originated in hardware.

Note, simply checking whether or not the original exit was due a #NPF or
EPT Violation isn't sufficient/correct, as the fault being synthesized for
L1 may or may not be the "same" fault that triggered a VM-Exit from L2.
E.g. if access to emulated MMIO in L2 hits a !PRESENT fault (EPT Violation
or #NPF), e.g. because MMIO caching is disabled or it's the first time the
GPA has been accessed by L2, then KVM will enter the emulator.  If
emulating the MMIO instruction then hits a nested TDP fault, e.g. because
L2 was accessing MMIO with a MOVSQ (memory-to-memory move), or because L1
has since unmapped the code stream, then the TDP fault synthesized to L1
will not be the same emulated fault the triggered the VM-Exit.

No functional change intended (nothing uses the new param, yet...).

Link: https://patch.msgid.link/20260522232701.3671446-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[doebel: keep this tree's split kvm_requeue_exception()/_e()
declarations and EXPORT_SYMBOL_GPL()]
Stable-dep-of: 96b067b59ad9 ("KVM: VMX: Synthesize nested EPT violation GVA_IS_VALID/GVA_TRANSLATED bits")
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 18 ++++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/svm/nested.c       |  3 ++-
 arch/x86/kvm/vmx/nested.c       |  3 ++-
 arch/x86/kvm/x86.c              | 16 +++++++++-------
 5 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 565582cd96392..cec497aed149a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -451,7 +451,8 @@ struct kvm_mmu {
 	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
 	int (*page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
-				  struct x86_exception *fault);
+				  struct x86_exception *fault,
+				  bool from_hardware);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gpa_t gva_or_gpa, u64 access,
 			    struct x86_exception *exception);
@@ -2140,9 +2141,18 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
-void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
-void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
-				    struct x86_exception *fault);
+void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault,
+			   bool from_hardware);
+void __kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+				      struct x86_exception *fault,
+				      bool from_hardware);
+
+static inline void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+						  struct x86_exception *fault)
+{
+	__kvm_inject_emulated_page_fault(vcpu, fault, false);
+}
+
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 9e17ebcc4c318..829821fbc8437 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -799,7 +799,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	if (!r) {
 		if (!fault->prefetch)
-			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
+			__kvm_inject_emulated_page_fault(vcpu, &walker.fault, true);
 
 		return RET_PF_RETRY;
 	}
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c1ecaf1578052..90704214ec880 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -34,7 +34,8 @@
 #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
 
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
-				       struct x86_exception *fault)
+				       struct x86_exception *fault,
+				       bool from_hardware)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 016acc678fc03..17ecc0e863d44 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -414,7 +414,8 @@ static void nested_ept_invalidate_addr(struct kvm_vcpu *vcpu, gpa_t eptp,
 }
 
 static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
-		struct x86_exception *fault)
+					 struct x86_exception *fault,
+					 bool from_hardware)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c6cae3a0f3f6..cc20ccaf87e4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -921,7 +921,8 @@ static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
 				       EMULTYPE_COMPLETE_USER_EXIT);
 }
 
-void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
+void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault,
+			   bool from_hardware)
 {
 	++vcpu->stat.pf_guest;
 
@@ -938,8 +939,9 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 					fault->address);
 }
 
-void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
-				    struct x86_exception *fault)
+void __kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+				      struct x86_exception *fault,
+				      bool from_hardware)
 {
 	struct kvm_mmu *fault_mmu;
 	WARN_ON_ONCE(fault->vector != PF_VECTOR);
@@ -956,9 +958,9 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 		kvm_mmu_invalidate_addr(vcpu, fault_mmu, fault->address,
 					KVM_MMU_ROOT_CURRENT);
 
-	fault_mmu->inject_page_fault(vcpu, fault);
+	fault_mmu->inject_page_fault(vcpu, fault, from_hardware);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
+EXPORT_SYMBOL_GPL(__kvm_inject_emulated_page_fault);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
@@ -12661,7 +12663,7 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 		fault.nested_page_fault = false;
 		fault.address = work->arch.token;
 		fault.async_page_fault = true;
-		kvm_inject_page_fault(vcpu, &fault);
+		kvm_inject_page_fault(vcpu, &fault, false);
 		return true;
 	} else {
 		/*
@@ -12917,7 +12919,7 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 		fault.address = gva;
 		fault.async_page_fault = false;
 	}
-	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);
+	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault, true);
 }
 EXPORT_SYMBOL_GPL(kvm_fixup_and_inject_pf_error);
 
-- 
2.53.0



