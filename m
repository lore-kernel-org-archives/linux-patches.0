Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EC841F36F;
	Thu, 16 Jul 2026 13:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209029; cv=none; b=jl1igA/QVkpi/sYyPzAgv58QXLVYPVD9IOMgwbAhluW+6tFyHYN7hJsjDklgAIPIALHUNtdUs12F9Dwc3MSvLlJ56Ljio02ulOcmy6N/C70FH7uVCuedk1CBsss5W+G99xGPAMR5YUoAoSx+0bmawFG4zAdPiPJYIOugKMpFBYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209029; c=relaxed/simple;
	bh=e0KqY/45nh4AxNyqTEIzz0TjXyNILxzSvDYOK4btX/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJ78n+Kl+0habs8Ja5TBpjDOqoAl+2i2Hbcj6VjhjE/nRFKAdpoGQcDxSYf8n7luC6eneKnkQJ17m7WJ6HqJ9K7kMkx6uwizm++wig6k78VxcHNnsn5BKJ1igHNnDGg0O1MUkDy+b87iZMaPtSK95IYNp5afeMx1xOyuI3v9ZK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/OmNrY/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/OmNrY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2537E1F000E9;
	Thu, 16 Jul 2026 13:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209028;
	bh=lMwEWmfAITgjdZbKTU+tLaALurAeSP1AEfH5lEXFN6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/OmNrY/lbzTqRHY1oZY+rbTLKEudQo0A0mwXRBTNDzs2HJFANWxAfgkvoSKfJ4SR
	 6flq1jdWvYfFQRjl1dW3nnsYTMtXL9Urm0Rx6ie6x6wf963Ttd7U2yyeSBJ2FuqXOo
	 b8Yz/J5aGtZt0BbbtLRAUsS+okj5fiTrYPZSwfuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
Subject: [PATCH 7.1 008/518] KVM: x86: Move update_cr8_intercept() to lapic.c
Date: Thu, 16 Jul 2026 15:24:36 +0200
Message-ID: <20260716133047.961287514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream Commit c7722e5e1daeeabbd9f969554d52bb7158120b27 ]

Move update_cr8_intercept() to lapic.c so that it's globally visible
in anticipation of extracting most of the register-specific code out of
x86.c and into a new compilation unit.  Opportunistically prefix the
helper kvm_lapic_ to make its role/scope more obvious.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260529222223.870923-14-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   26 ++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h |    1 +
 arch/x86/kvm/x86.c   |   34 +++-------------------------------
 3 files changed, 30 insertions(+), 31 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2744,6 +2744,32 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *v
 	return (tpr & 0xf0) >> 4;
 }
 
+void kvm_lapic_update_cr8_intercept(struct kvm_vcpu *vcpu)
+{
+	int max_irr, tpr;
+
+	if (!kvm_x86_ops.update_cr8_intercept)
+		return;
+
+	if (!lapic_in_kernel(vcpu))
+		return;
+
+	if (vcpu->arch.apic->apicv_active)
+		return;
+
+	if (!vcpu->arch.apic->vapic_addr)
+		max_irr = kvm_lapic_find_highest_irr(vcpu);
+	else
+		max_irr = -1;
+
+	if (max_irr != -1)
+		max_irr >>= 4;
+
+	tpr = kvm_lapic_get_cr8(vcpu);
+
+	kvm_x86_call(update_cr8_intercept)(vcpu, tpr, max_irr);
+}
+
 static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
 {
 	u64 old_value = vcpu->arch.apic_base;
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -100,6 +100,7 @@ int kvm_apic_accept_events(struct kvm_vc
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
+void kvm_lapic_update_cr8_intercept(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -128,7 +128,6 @@ static u64 __read_mostly efer_reserved_b
 				    KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST	| \
 				    KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
@@ -5340,7 +5339,7 @@ static int kvm_vcpu_ioctl_set_lapic(stru
 	r = kvm_apic_set_state(vcpu, s);
 	if (r)
 		return r;
-	update_cr8_intercept(vcpu);
+	kvm_lapic_update_cr8_intercept(vcpu);
 
 	return 0;
 }
@@ -10595,33 +10594,6 @@ static void post_kvm_run_save(struct kvm
 		kvm_run->flags |= KVM_RUN_X86_GUEST_MODE;
 }
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu)
-{
-	int max_irr, tpr;
-
-	if (!kvm_x86_ops.update_cr8_intercept)
-		return;
-
-	if (!lapic_in_kernel(vcpu))
-		return;
-
-	if (vcpu->arch.apic->apicv_active)
-		return;
-
-	if (!vcpu->arch.apic->vapic_addr)
-		max_irr = kvm_lapic_find_highest_irr(vcpu);
-	else
-		max_irr = -1;
-
-	if (max_irr != -1)
-		max_irr >>= 4;
-
-	tpr = kvm_lapic_get_cr8(vcpu);
-
-	kvm_x86_call(update_cr8_intercept)(vcpu, tpr, max_irr);
-}
-
-
 int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	if (kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu)) {
@@ -11362,7 +11334,7 @@ static int vcpu_enter_guest(struct kvm_v
 			kvm_x86_call(enable_irq_window)(vcpu);
 
 		if (kvm_lapic_enabled(vcpu)) {
-			update_cr8_intercept(vcpu);
+			kvm_lapic_update_cr8_intercept(vcpu);
 			kvm_lapic_sync_to_vapic(vcpu);
 		}
 	}
@@ -12511,7 +12483,7 @@ static int __set_sregs_common(struct kvm
 	kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
 	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
-	update_cr8_intercept(vcpu);
+	kvm_lapic_update_cr8_intercept(vcpu);
 
 	/* Older userspace won't unhalt the vcpu on reset. */
 	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&


