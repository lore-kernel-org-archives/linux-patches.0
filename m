Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9B4139579;
	Tue, 26 Aug 2025 13:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214171; cv=none; b=qtwRH2+VcZVxmk4d6veUloX01wfr45uTyn3dN6Fz9NEBaCtM3bLn/20dgq1YgCD5rMQKudrUURh1yU9ioH9bka00IcDKNCiOO9Bxt2ahWSp5DJgpAzbY++zCyn6w7C680pjc/XbMsTb0v4Ihej5hw4ot9MHnu/UtXeFwlwK2VnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214171; c=relaxed/simple;
	bh=GQinJb4AdNCY4q3oDGQuteRMj7bSS0QkDMmR0mZlE/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3aAhWWhFmcwz4yiq88kTi0ACJnD6Hd8z+/3efIzujOVPBJF1D2leXaSX8dEeDCRF5KczfMz68HuqmZ0rANj047tEr2H0QERhOVhS698HjZioeOsB16lzvdWFDJc4MBhziM9k532+4RKUL6WuPsdsX8g5KIVkxqcOpYEDD0l0ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ON3umKDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ON3umKDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B7FC4CEF1;
	Tue, 26 Aug 2025 13:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214171;
	bh=GQinJb4AdNCY4q3oDGQuteRMj7bSS0QkDMmR0mZlE/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ON3umKDleRlfZoHlTkoDEm8ETIee/pMSO+lMpHtRnme7GacMad63I6slf5PgzLqBz
	 XkUG69obMOpTWE31FCMa6k4dg0WYaIkg9r4LbIA6k8hTuaGPokTA4s1qEvuTkn1rie
	 uExB/ebQPRXtcXk19m95wJ+1RM+SzTuBMfEFDEMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/482] KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers
Date: Tue, 26 Aug 2025 13:04:50 +0200
Message-ID: <20250826110931.725419444@linuxfoundation.org>
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
[sean: resolve syntactic conflict in svm_exit_handlers_fastpath()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 6 +++---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b4283c2358a6..337a304d211b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3964,6 +3964,9 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
 
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	/*
 	 * Note, the next RIP must be provided as SRCU isn't held, i.e. KVM
 	 * can't read guest memory (dereference memslots) to decode the WRMSR.
@@ -4127,9 +4130,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 
 	svm_complete_interrupts(vcpu);
 
-	if (is_guest_mode(vcpu))
-		return EXIT_FASTPATH_NONE;
-
 	return svm_exit_handlers_fastpath(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c804ad001a79..18ceed9046a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7138,6 +7138,9 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	switch (to_vmx(vcpu)->exit_reason.basic) {
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_set_msr_irqoff(vcpu);
@@ -7337,9 +7340,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
-	if (is_guest_mode(vcpu))
-		return EXIT_FASTPATH_NONE;
-
 	return vmx_exit_handlers_fastpath(vcpu);
 }
 
-- 
2.50.1



