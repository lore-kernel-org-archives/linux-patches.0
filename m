Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFAA346FBE;
	Wed,  3 Dec 2025 16:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780896; cv=none; b=aC3o6sWzeTHkl0EX6fNMCY598+JIuPXJ9SD6Gk5Yqc2NoGnU43vjuNsX+MtEDyHTAi33g6MMvPMiuY7+AFKLiZgYSFDujpRDPgkLTQyfRTerKauIafxyuHq3BuZSh/38gT6oR9fz5XFd2ovdca955pAvvRGua17dyqzOD57l0Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780896; c=relaxed/simple;
	bh=+yX0p1Bbs5ubaVEVkZYf+aIiArWI/Gq5opyNBLmqKcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mP4XKjvZf27ubHD+m+O3tufrbZ8+5fDciy6fyJxG3mUN+QvXUO+9hPd07FLW7yV0ZVRi8Uz6ebvHjR6PvoEBOfFAElCezrdILQHOOaViGUUJSb3WsldDZd8E1IdWFqRIUnJkXtm+GGb1rCGgv9FeIXkyMII1i4wUAMzyb6Kmayc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4bdam1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4bdam1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55419C4CEF5;
	Wed,  3 Dec 2025 16:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780895;
	bh=+yX0p1Bbs5ubaVEVkZYf+aIiArWI/Gq5opyNBLmqKcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4bdam1Ao4Boi/rXTBun0s0JtgUax+gHaV+NQmt3M4yRDGUZKJzr1dRUThAek0g2w
	 qa2vvaz/jy4XyX3b4jLJ1PRgEJAgBddREmtE/tWf7Yg4XC88kYTvfF/Ary9bQhDcQT
	 3slnMg/uv5M+iP+GAhIniL969UT/MJIuYgc9YSo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 6.12 121/132] KVM: SVM: Introduce svm_recalc_lbr_msr_intercepts()
Date: Wed,  3 Dec 2025 16:30:00 +0100
Message-ID: <20251203152347.796828790@linuxfoundation.org>
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
@@ -995,18 +995,31 @@ void svm_copy_lbrs(struct vmcb *to_vmcb,
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
@@ -1020,10 +1033,7 @@ static void svm_disable_lbrv(struct kvm_
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/*
 	 * Move the LBR msrs back to the vmcb01 to avoid copying them


