Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66501347FD8;
	Wed,  3 Dec 2025 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780899; cv=none; b=OsqWfpn7zpwNNpupJqXk6aTcaBWwr7KN0c5FOzabQgkgtmVZ5X9m8JK3GRB2ItOc1XufIaMEZV8z7sty8plrrB7UbxmOOFUd4v4M7s3SLJFJrO6qQRX+bEE6jHUBjCQSWE3YjFGlct6ClJz+7TkUkd7nUMWs6hs7tgHCRgk2xXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780899; c=relaxed/simple;
	bh=09twLx6ylzMypTxIPOWJ+3HFaOyFuDS65PAS8WGum3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/CWcbRn6ZOpc5r4LITh4/EVEnyl8tcUoP+FP+XaEdp+6nwk/xCanMhGsTGiuExhwGqQa3YyRB5jkw2kjeKHY/+slXUqSLKcUrANxiI96A21DbnaQak74iDmhnZqFbyPjPR/L87EgWnoIXhoZraPcrLnE2ENdpqzQHM62RUvuC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cE5gWXXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cE5gWXXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F10BC4CEF5;
	Wed,  3 Dec 2025 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780899;
	bh=09twLx6ylzMypTxIPOWJ+3HFaOyFuDS65PAS8WGum3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE5gWXXkd6j1IxI9NoD6pTsLpp6M9M4WrdfJqz2eiWJL0mjljyCXuqQJGF4z1pPAJ
	 ygk58SjerUedsOpYd4inj9NuitZHhWCZGJte6Y9jDSUuJu5eOwGGo2flGhzm75ir28
	 U6P+o6BplAaCFAPMmkXi6JIteWOPpK7O4luPz6+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 122/132] KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()
Date: Wed,  3 Dec 2025 16:30:01 +0100
Message-ID: <20251203152347.833279006@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit fbe5e5f030c22ae717ee422aaab0e00ea84fab5e upstream.

svm_update_lbrv() is called when MSR_IA32_DEBUGCTLMSR is updated, and on
nested transitions where LBRV is used. It checks whether LBRV enablement
needs to be changed in the current VMCB, and if it does, it also
recalculate intercepts to LBR MSRs.

However, there are cases where intercepts need to be updated even when
LBRV enablement doesn't. Example scenario:
- L1 has MSR_IA32_DEBUGCTLMSR cleared.
- L1 runs L2 without LBR_CTL_ENABLE (no LBRV).
- L2 sets DEBUGCTLMSR_LBR in MSR_IA32_DEBUGCTLMSR, svm_update_lbrv()
  sets LBR_CTL_ENABLE in VMCB02 and disables intercepts to LBR MSRs.
- L2 exits to L1, svm_update_lbrv() is not called on this transition.
- L1 clears MSR_IA32_DEBUGCTLMSR, svm_update_lbrv() finds that
  LBR_CTL_ENABLE is already cleared in VMCB01 and does nothing.
- Intercepts remain disabled, L1 reads to LBR MSRs read the host MSRs.

Fix it by always recalculating intercepts in svm_update_lbrv().

Fixes: 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251108004524.1600006-3-yosry.ahmed@linux.dev
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1014,26 +1014,30 @@ static void svm_recalc_lbr_msr_intercept
 				     !intercept, !intercept);
 }
 
-void svm_enable_lbrv(struct kvm_vcpu *vcpu)
+static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
 	if (is_guest_mode(vcpu))
 		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
 }
 
-static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
+void svm_enable_lbrv(struct kvm_vcpu *vcpu)
+{
+	__svm_enable_lbrv(vcpu);
+	svm_recalc_lbr_msr_intercepts(vcpu);
+}
+
+static void __svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/*
 	 * Move the LBR msrs back to the vmcb01 to avoid copying them
@@ -1062,13 +1066,18 @@ void svm_update_lbrv(struct kvm_vcpu *vc
 			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
-	if (enable_lbrv == current_enable_lbrv)
-		return;
+	if (enable_lbrv && !current_enable_lbrv)
+		__svm_enable_lbrv(vcpu);
+	else if (!enable_lbrv && current_enable_lbrv)
+		__svm_disable_lbrv(vcpu);
 
-	if (enable_lbrv)
-		svm_enable_lbrv(vcpu);
-	else
-		svm_disable_lbrv(vcpu);
+	/*
+	 * During nested transitions, it is possible that the current VMCB has
+	 * LBR_CTL set, but the previous LBR_CTL had it cleared (or vice versa).
+	 * In this case, even though LBR_CTL does not need an update, intercepts
+	 * do, so always recalculate the intercepts here.
+	 */
+	svm_recalc_lbr_msr_intercepts(vcpu);
 }
 
 void disable_nmi_singlestep(struct vcpu_svm *svm)


