Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212FB11187;
	Tue, 26 Aug 2025 12:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212636; cv=none; b=KkbJo1wW/rYrKZKlJuH2AjuH+nG73a7q7EDCmmWvVfdafWg1lFp5qXw78wm4bizkX2II0dEaUXeGHvyjU2s2ePfyT+PIHUFYhPV+sSO/eQpNvttE5fU7hDO5+4Pv6m0bW57tNYTLlIh1LaPz3ZXV5uK9qBd7QZ20Tb0L0D95r50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212636; c=relaxed/simple;
	bh=+FPu8PdlTqfEh8R7UkHlf44EaldPTNsIafR7Kc0187o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poTPbulMoJVf4sIZv7S4kMriMwElkDzXJc1WXaaW8bl3q/X+93/koCIAb8sAGvFSAbBoK3rSg4g8nBdAfABs35k3khcv7uxs/VOYmt5jus2kQC81GlwVoc8aJfJj6J5OmgI4Q2zS4frMrCJqFceAoKxYdjQmGJMwY9PRY38+Jig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TTph2DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TTph2DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A258CC113CF;
	Tue, 26 Aug 2025 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212636;
	bh=+FPu8PdlTqfEh8R7UkHlf44EaldPTNsIafR7Kc0187o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TTph2DST/xioTsOTxggisqus84Svukv3416RK+AGuIY6/JyxdoMxBsfegBHp6Oww
	 MWnxcpsDIRjVou+tjaygyoxmokbm9eGMO1XNcWZrW3D3PAEo9WEMN9MmmMSsGYZ6NK
	 FHwzJ6LMAA+e9QUU8x1ggvfIVAH6A1G9PK6QZU+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/587] KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers
Date: Tue, 26 Aug 2025 13:03:13 +0200
Message-ID: <20250826110954.066419547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit bf1a49436ea37b98dd2f37c57608951d0e28eecc ]

Let the fastpath code decide which exits can/can't be handled in the
fastpath when L2 is active, e.g. when KVM generates a VMX preemption
timer exit to forcefully regain control, there is no "work" to be done and
so such exits can be handled in the fastpath regardless of whether L1 or
L2 is active.

Moving the is_guest_mode() check into the fastpath code also makes it
easier to see that L2 isn't allowed to use the fastpath in most cases,
e.g. it's not immediately obvious why handle_fastpath_preemption_timer()
is called from the fastpath and the normal path.

Link: https://lore.kernel.org/r/20240110012705.506918-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 6 +++---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5a230be224d1..f42c6ef7dc20 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4157,6 +4157,9 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
 	    to_svm(vcpu)->vmcb->control.exit_info_1)
 		return handle_fastpath_set_msr_irqoff(vcpu);
@@ -4315,9 +4318,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 
 	svm_complete_interrupts(vcpu);
 
-	if (is_guest_mode(vcpu))
-		return EXIT_FASTPATH_NONE;
-
 	return svm_exit_handlers_fastpath(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 631fdd4a575a..4c991d514015 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7258,6 +7258,9 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	switch (to_vmx(vcpu)->exit_reason.basic) {
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_set_msr_irqoff(vcpu);
@@ -7468,9 +7471,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
-	if (is_guest_mode(vcpu))
-		return EXIT_FASTPATH_NONE;
-
 	return vmx_exit_handlers_fastpath(vcpu);
 }
 
-- 
2.50.1



