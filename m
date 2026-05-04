Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3C13BE630;
	Mon,  4 May 2026 14:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904100; cv=none; b=TPnsEGQacM5GJbo3KzbB8yF+hIQVKqGAhEfpxNeOjIS45Il+rBp4e/IpMJ+GrN4kJBxPlPZYp5cDDJfEGDA/nuM5acFmm1nI1FJAfv0qk+3mugqFSizdUeEgEEh0ievhIgqVE56wgnjQ1thlzkIzGwv39t79vUIsDQLI1glM4QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904100; c=relaxed/simple;
	bh=c+K3jTg/hFccIIY/wf5HmHA/meaNoQ8G8VcAOHUFkoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGSynWjvXTrdXg2hvH82B/iKKLXozMoQTjsyEvxTsjdJw5B+P6EzkRwRN8sFem/szwN5MbD4kRMK6p5lIPT85q1mpqDfJPXL/HkhaWzGbgKF5EbxfjahDg630tdmAXSBJmC8tckHtJItPldgsAIiv6Tn/UGzP0NTgjB1qlAh6MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeGs73mZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeGs73mZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF67C2BCB8;
	Mon,  4 May 2026 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904100;
	bh=c+K3jTg/hFccIIY/wf5HmHA/meaNoQ8G8VcAOHUFkoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeGs73mZIR01/hG7nRN8H9ABDkdb7QWxZZ3y91Nv7lXnzoDA7zKWCeLX1RN16edf2
	 Tr53w2iKhb8A/qVAxIzDvzDX/sREQtzlbOVAPFghlNu6psaE8TbIZBK2n0+v0n96NV
	 XLY4h674Vil04dlqQUMqfw+PpSgx8mkoKP39Px7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 183/275] KVM: nSVM: Refactor checking LBRV enablement in vmcb12 into a helper
Date: Mon,  4 May 2026 15:52:03 +0200
Message-ID: <20260504135149.875248047@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 290c8d82023ab0e1d2782d37136541e017174d7c upstream.

Refactor the vCPU cap and vmcb12 flag checks into a helper. The
unlikely() annotation is dropped, it's unlikely (huh) to make a
difference and the CPU will probably predict it better on its own.

CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-7-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -608,6 +608,12 @@ void nested_vmcb02_compute_g_pat(struct
 	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
 }
 
+static bool nested_vmcb12_has_lbrv(struct kvm_vcpu *vcpu)
+{
+	return guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
+		(to_svm(vcpu)->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
+}
+
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	bool new_vmcb12 = false;
@@ -673,8 +679,7 @@ static void nested_vmcb02_prepare_save(s
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 
-	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+	if (nested_vmcb12_has_lbrv(vcpu)) {
 		/*
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
@@ -1189,8 +1194,7 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	if (!nested_exit_on_intr(svm))
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
-	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+	if (nested_vmcb12_has_lbrv(vcpu)) {
 		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
 	} else {
 		svm_copy_lbrs(&vmcb01->save, &vmcb02->save);


