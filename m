Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F7B2EBBB2;
	Fri,  9 Jan 2026 12:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962502; cv=none; b=oQee4RalC/2PXifMkoS36ur4/hqMsrcK5/woO+UVoGtc/BvVaSTRogojMbqQ/zTtkMyPpOVzvkqkNseXWbkXFnILJN7NQ26Z8/ej3lzG/QbxZ3KBCxDdLszAoUGEo57dHghx+RlBOzB6eZJui3ZCWjWkPfJSQ5F3Jb+MkMKF3nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962502; c=relaxed/simple;
	bh=lmz7HhhPO2Ke3rZtLSCXTLrw0eRwUa6prqYsENwuxl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UykxDhn4/VwRO77t5tAG1zVFLxke4tf8Sd+mwPDVI9b4M9Dxdos8YzWXO6EdCjh5i0hjkYI/9OQ1BS173BCKTErnnGISE7d4CNWUwucvH9Rgz5mTXxTq9ZXoRhuBqBqLNEU4edz5aOIQ0I9M+/zmOTD5uhKgy4lT8p9zJmJRG2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwthOFYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwthOFYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922F3C16AAE;
	Fri,  9 Jan 2026 12:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962502;
	bh=lmz7HhhPO2Ke3rZtLSCXTLrw0eRwUa6prqYsENwuxl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwthOFYjBO2sF/Qs5qVw0tQmZdBuBktrIHPapg9a9+HNWNHAISQWc3XaACzIXa5UR
	 J7jLuHt02iioaePQPajE6lZ3OwFhRSKr+UL0SrH5VPBZBnz38MfqwkXiE0xRbvApKX
	 z0rwyR2C3fFpieVIV/s+HAiDUMOuvXH+PrXGzx9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 354/634] KVM: x86: Dont clear async #PF queue when CR0.PG is disabled (e.g. on #SMI)
Date: Fri,  9 Jan 2026 12:40:32 +0100
Message-ID: <20260109112130.845361114@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <mlevitsk@redhat.com>

commit ab4e41eb9fabd4607304fa7cfe8ec9c0bd8e1552 upstream.

Fix an interaction between SMM and PV asynchronous #PFs where an #SMI can
cause KVM to drop an async #PF ready event, and thus result in guest tasks
becoming permanently stuck due to the task that encountered the #PF never
being resumed.  Specifically, don't clear the completion queue when paging
is disabled, and re-check for completed async #PFs if/when paging is
enabled.

Prior to commit 2635b5c4a0e4 ("KVM: x86: interrupt based APF 'page ready'
event delivery"), flushing the APF queue without notifying the guest of
completed APF requests when paging is disabled was "necessary", in that
delivering a #PF to the guest when paging is disabled would likely confuse
and/or crash the guest.  And presumably the original async #PF development
assumed that a guest would only disable paging when there was no intent to
ever re-enable paging.

That assumption fails in several scenarios, most visibly on an emulated
SMI, as entering SMM always disables CR0.PG (i.e. initially runs with
paging disabled).  When the SMM handler eventually executes RSM, the
interrupted paging-enabled is restored, and the async #PF event is lost.

Similarly, invoking firmware, e.g. via EFI runtime calls, might require a
transition through paging modes and thus also disable paging with valid
entries in the competion queue.

To avoid dropping completion events, drop the "clear" entirely, and handle
paging-enable transitions in the same way KVM already handles APIC
enable/disable events: if a vCPU's APIC is disabled, APF completion events
are not kept pending and not injected while APIC is disabled.  Once a
vCPU's APIC is re-enabled, KVM raises KVM_REQ_APF_READY so that the vCPU
recognizes any pending pending #APF ready events.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251015033258.50974-4-mlevitsk@redhat.com
[sean: rework changelog to call out #PF injection, drop "real mode"
       references, expand the code comment]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -853,6 +853,13 @@ bool kvm_require_dr(struct kvm_vcpu *vcp
 }
 EXPORT_SYMBOL_GPL(kvm_require_dr);
 
+static bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
+{
+	u64 mask = KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
+
+	return (vcpu->arch.apf.msr_en_val & mask) == mask;
+}
+
 static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.reserved_gpa_bits | rsvd_bits(5, 8) | rsvd_bits(1, 2);
@@ -939,15 +946,20 @@ void kvm_post_set_cr0(struct kvm_vcpu *v
 	}
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_async_pf_hash_reset(vcpu);
-
 		/*
 		 * Clearing CR0.PG is defined to flush the TLB from the guest's
 		 * perspective.
 		 */
 		if (!(cr0 & X86_CR0_PG))
 			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+		/*
+		 * Check for async #PF completion events when enabling paging,
+		 * as the vCPU may have previously encountered async #PFs (it's
+		 * entirely legal for the guest to toggle paging on/off without
+		 * waiting for the async #PF queue to drain).
+		 */
+		else if (kvm_pv_async_pf_enabled(vcpu))
+			kvm_make_request(KVM_REQ_APF_READY, vcpu);
 	}
 
 	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
@@ -3358,13 +3370,6 @@ static int set_msr_mce(struct kvm_vcpu *
 	return 0;
 }
 
-static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
-{
-	u64 mask = KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
-
-	return (vcpu->arch.apf.msr_en_val & mask) == mask;
-}
-
 static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 {
 	gpa_t gpa = data & ~0x3f;


