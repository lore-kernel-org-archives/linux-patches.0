Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDB1226557;
	Thu, 12 Dec 2024 16:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021770; cv=none; b=ZDNhxrdt7y8FQGF9zDVpOBWItf9iZjiP1V4buctf/NWqIMpfR0lKo7a0LwLsA7z7TthGmtjT37dfv/gVHNRtSAvA8CaqFEx1a1FXfzqY1jYW7UGVQ9ajHkYccWOf/Zd1RdJQWSzELZwHhvgTBVJbgB3BnvHz3Bj5aXNrripE/Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021770; c=relaxed/simple;
	bh=XtfhbM1WCC0f7Yutdm4QeRjzRMT4fI/r61YJcHNIOws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PohiErDw/IuNLC0Z2U1jJWEfmy1ltE04ApM6P2j7nOLNRI0kZg69OBubrujfMFwtOrfELIxpunYnwugYxaDwYqenenFOB4YwmqWmxBrlJAE2cD9QCv82T9ydZVRoaRw61Fsbrc07HaXmn6NgNTrpc4JMlhdW26Pd0/vip3p3ENg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kafS46AV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kafS46AV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A031C4CECE;
	Thu, 12 Dec 2024 16:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021770;
	bh=XtfhbM1WCC0f7Yutdm4QeRjzRMT4fI/r61YJcHNIOws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kafS46AVLBmfvEBDGAikhjga3t97vWJ54Y2DY0Rz8hjOM6A/NCrKHsreIMICI5RGW
	 gPAwWq7dyRaulvPw7f4vTzgnkWVwW7F86DtGUDQRubFUtbPJ42VzfJi8YroL8WEWUq
	 fVEX+TbMafgaLsJdEmK/D5nU+QlggH/ozy17ck5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Like Xu <like.xu.linux@gmail.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 028/565] KVM: nVMX: Treat vpid01 as current if L2 is active, but with VPID disabled
Date: Thu, 12 Dec 2024 15:53:43 +0100
Message-ID: <20241212144312.564867311@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 2657b82a78f18528bef56dc1b017158490970873 upstream.

When getting the current VPID, e.g. to emulate a guest TLB flush, return
vpid01 if L2 is running but with VPID disabled, i.e. if VPID is disabled
in vmcs12.  Architecturally, if VPID is disabled, then the guest and host
effectively share VPID=0.  KVM emulates this behavior by using vpid01 when
running an L2 with VPID disabled (see prepare_vmcs02_early_rare()), and so
KVM must also treat vpid01 as the current VPID while L2 is active.

Unconditionally treating vpid02 as the current VPID when L2 is active
causes KVM to flush TLB entries for vpid02 instead of vpid01, which
results in TLB entries from L1 being incorrectly preserved across nested
VM-Enter to L2 (L2=>L1 isn't problematic, because the TLB flush after
nested VM-Exit flushes vpid01).

The bug manifests as failures in the vmx_apicv_test KVM-Unit-Test, as KVM
incorrectly retains TLB entries for the APIC-access page across a nested
VM-Enter.

Opportunisticaly add comments at various touchpoints to explain the
architectural requirements, and also why KVM uses vpid01 instead of vpid02.

All credit goes to Chao, who root caused the issue and identified the fix.

Link: https://lore.kernel.org/all/ZwzczkIlYGX+QXJz@intel.com
Fixes: 2b4a5a5d5688 ("KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST")
Cc: stable@vger.kernel.org
Cc: Like Xu <like.xu.linux@gmail.com>
Debugged-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/r/20241031202011.1580522-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   30 +++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c    |    2 +-
 2 files changed, 26 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1158,11 +1158,14 @@ static void nested_vmx_transition_tlb_fl
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	/*
-	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
-	 * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
-	 * full TLB flush from the guest's perspective.  This is required even
-	 * if VPID is disabled in the host as KVM may need to synchronize the
-	 * MMU in response to the guest TLB flush.
+	 * If VPID is disabled, then guest TLB accesses use VPID=0, i.e. the
+	 * same VPID as the host, and so architecturally, linear and combined
+	 * mappings for VPID=0 must be flushed at VM-Enter and VM-Exit.  KVM
+	 * emulates L2 sharing L1's VPID=0 by using vpid01 while running L2,
+	 * and so KVM must also emulate TLB flush of VPID=0, i.e. vpid01.  This
+	 * is required if VPID is disabled in KVM, as a TLB flush (there are no
+	 * VPIDs) still occurs from L1's perspective, and KVM may need to
+	 * synchronize the MMU in response to the guest TLB flush.
 	 *
 	 * Note, using TLB_FLUSH_GUEST is correct even if nested EPT is in use.
 	 * EPT is a special snowflake, as guest-physical mappings aren't
@@ -2189,6 +2192,17 @@ static void prepare_vmcs02_early_rare(st
 
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
 
+	/*
+	 * If VPID is disabled, then guest TLB accesses use VPID=0, i.e. the
+	 * same VPID as the host.  Emulate this behavior by using vpid01 for L2
+	 * if VPID is disabled in vmcs12.  Note, if VPID is disabled, VM-Enter
+	 * and VM-Exit are architecturally required to flush VPID=0, but *only*
+	 * VPID=0.  I.e. using vpid02 would be ok (so long as KVM emulates the
+	 * required flushes), but doing so would cause KVM to over-flush.  E.g.
+	 * if L1 runs L2 X with VPID12=1, then runs L2 Y with VPID12 disabled,
+	 * and then runs L2 X again, then KVM can and should retain TLB entries
+	 * for VPID12=1.
+	 */
 	if (enable_vpid) {
 		if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
 			vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->nested.vpid02);
@@ -5591,6 +5605,12 @@ static int handle_invvpid(struct kvm_vcp
 		return nested_vmx_fail(vcpu,
 			VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
+	/*
+	 * Always flush the effective vpid02, i.e. never flush the current VPID
+	 * and never explicitly flush vpid01.  INVVPID targets a VPID, not a
+	 * VMCS, and so whether or not the current vmcs12 has VPID enabled is
+	 * irrelevant (and there may not be a loaded vmcs12).
+	 */
 	vpid02 = nested_get_vpid02(vcpu);
 	switch (type) {
 	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3019,7 +3019,7 @@ static void vmx_flush_tlb_all(struct kvm
 
 static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
+	if (is_guest_mode(vcpu) && nested_cpu_has_vpid(get_vmcs12(vcpu)))
 		return nested_get_vpid02(vcpu);
 	return to_vmx(vcpu)->vpid;
 }


