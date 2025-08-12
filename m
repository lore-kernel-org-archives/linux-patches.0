Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592281C1AAA;
	Tue, 12 Aug 2025 19:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025231; cv=none; b=Bm6+ZhR01zayf5YGcZ7QBAPxBBBnOndgrTLcEUE1nY4IMGmUnRBXqcvmWlgRWr74Jsa6sau09Cx7laja8WGl1G8xw0L+0aFS54s6/+LIGOpq+Jq0Md3pJCin33HFd39ylk85Y/Oxp/yPOxMBedApYMiD27A2Svk1TTAVSRUUuzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025231; c=relaxed/simple;
	bh=ne/0uSTQpozr68/I9jIrQ4+OAXnx/Rd5sEvzSTU/wsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeG3MiQLHNNlW/NiskvlBJMsWF7YklTVqXd45kTagKN/jknR9bxXfpYrllJ6jt94VleT1lPYFyrymnA1N0Tg6ezen9DV6mp9pIctUwwZ5RrqdoENRLOy7vI+gyBwsCF9LfSTCmDbe0baPhg/p1lnZGTYEt2kUlukxvGLZsYIXik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcckgPXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcckgPXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549E8C4CEF0;
	Tue, 12 Aug 2025 19:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025230;
	bh=ne/0uSTQpozr68/I9jIrQ4+OAXnx/Rd5sEvzSTU/wsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcckgPXHPGBNSz+H90JBg07UySZ1WZiqHMUNjOC575I/ECRoiJGcf5hQXIamglhUn
	 9HLt4YjU7DzXInE3pFgOjgMut0XlkVhzJQd8hdgECA6Z1HqDsFUu6y6enoRQjyrcT+
	 L/s3w4qxqsl0adEpUub58RgxMez9E32lUHw87XxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.16 608/627] KVM: arm64: Filter out HCR_EL2 bits when running in hypervisor context
Date: Tue, 12 Aug 2025 19:35:03 +0200
Message-ID: <20250812173455.001234025@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 303084ad12767db64c84ba8fcd0450aec38c8534 upstream.

Most HCR_EL2 bits are not supposed to affect EL2 at all, but only
the guest. However, we gladly merge these bits with the host's
HCR_EL2 configuration, irrespective of entering L1 or L2.

This leads to some funky behaviour, such as L1 trying to inject
a virtual SError for L2, and getting a taste of its own medecine.
Not quite what the architecture anticipated.

In the end, the only bits that matter are those we have defined as
invariants, either because we've made them RESx (E2H, HCD...), or
that we actively refuse to merge because the mess with KVM's own
logic.

Use the sanitisation infrastructure to get the RES1 bits, and let
things rip in a safer way.

Fixes: 04ab519bb86df ("KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250721101955.535159-3-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -48,8 +48,7 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_ve
 
 static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 {
-	u64 guest_hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
-	u64 hcr = vcpu->arch.hcr_el2;
+	u64 guest_hcr, hcr = vcpu->arch.hcr_el2;
 
 	if (!vcpu_has_nv(vcpu))
 		return hcr;
@@ -68,10 +67,21 @@ static u64 __compute_hcr(struct kvm_vcpu
 		if (!vcpu_el2_e2h_is_set(vcpu))
 			hcr |= HCR_NV1;
 
+		/*
+		 * Nothing in HCR_EL2 should impact running in hypervisor
+		 * context, apart from bits we have defined as RESx (E2H,
+		 * HCD and co), or that cannot be set directly (the EXCLUDE
+		 * bits). Given that we OR the guest's view with the host's,
+		 * we can use the 0 value as the starting point, and only
+		 * use the config-driven RES1 bits.
+		 */
+		guest_hcr = kvm_vcpu_apply_reg_masks(vcpu, HCR_EL2, 0);
+
 		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
 	} else {
 		host_data_clear_flag(VCPU_IN_HYP_CONTEXT);
 
+		guest_hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
 		if (guest_hcr & HCR_NV) {
 			u64 va = __fix_to_virt(vncr_fixmap(smp_processor_id()));
 


