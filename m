Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FCF35B121;
	Fri,  9 Jan 2026 12:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961297; cv=none; b=X9qkKTxiNkQsXSGDhpMaPWggc5gRN5Zd2TsmwrG7B+UrEV3snijlxLU5N/SKTrgW1fMFKsg9V7FhfLCrGfEFyYcqayCIW34RNpSijABoRReN1milPMxVZ0BHDV/Lp3pD2sM8RL9SXm2LSxeMQrUIj/eTue9KM3O0CX9pg5wj4tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961297; c=relaxed/simple;
	bh=2O+9Dp055ZTrXa3Ub6joct0DmO0sgBj3Hp9oZUsIL8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pao0ke/ERWpGJPPvlM1RTg9TOyPAvF3TI6XKZWqVHaFcobVuQ/QfJQ0n37rulFJX+LLJO0a7BiZsvQXLZnqNxKJUDYrg82VtxbLZJHAyj1X1uNNhJ5tee9rcgRB9uNQmPtS/zudhuMKOx5YM8kPKOvAC1TJFTbUZVMftgb6VSnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSfH98V2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSfH98V2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BEAC16AAE;
	Fri,  9 Jan 2026 12:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961297;
	bh=2O+9Dp055ZTrXa3Ub6joct0DmO0sgBj3Hp9oZUsIL8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSfH98V2vqtljP/A9BsAOgTnhUq0SQk7gW0xQm0ApQpTAuwmKjmE8m9xZOl9zDmSC
	 rUJbRNQOxsewHQWmFQ9umFrGVaXpM22vZU4pcn7M3cWFKCtS6phQtjEz4vho+9u7Tb
	 oMzXIgZ2ywtJILJktZX014hN1K/5ZLFChd93/mLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 6.6 702/737] KVM: SVM: Introduce svm_recalc_lbr_msr_intercepts()
Date: Fri,  9 Jan 2026 12:44:01 +0100
Message-ID: <20260109112200.480485652@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry.ahmed@linux.dev>

Introduce a helper updating the intercepts for LBR MSRs, similar to the
one introduced upstream by commit 160f143cc131 ("KVM: SVM: Manually
recalc all MSR intercepts on userspace MSR filter change"). The main
difference is that this version uses set_msr_interception(), which has
inverted polarity compared to svm_set_intercept_for_msr().

This is intended to simplify incoming backports. No functional changes
intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1012,18 +1012,31 @@ void svm_copy_lbrs(struct vmcb *to_vmcb,
 	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
 }
 
-void svm_enable_lbrv(struct kvm_vcpu *vcpu)
+static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool intercept = !(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
 
-	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP,
+			     !intercept, !intercept);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP,
+			     !intercept, !intercept);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP,
+			     !intercept, !intercept);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP,
+			     !intercept, !intercept);
 
 	if (sev_es_guest(vcpu->kvm))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR,
+				     !intercept, !intercept);
+}
+
+void svm_enable_lbrv(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
+	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
 	if (is_guest_mode(vcpu))
@@ -1037,10 +1050,7 @@ static void svm_disable_lbrv(struct kvm_
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/*
 	 * Move the LBR msrs back to the vmcb01 to avoid copying them


