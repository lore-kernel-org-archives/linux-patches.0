Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C99235BDC4;
	Fri,  9 Jan 2026 12:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962445; cv=none; b=M8i0W0rSilorgj9DQnuhAkkYuGjY1EFa4RjmcAIoE9sa6+wM7leEx+23TpwyLQdN02x4h2uyL3VYMAbnM4y7KeqDyszc0E5ETCCixGfTYtXL1xdMOIbR4gg0iHMm24l22KvBvMnkr6gvt1C3x37qzQQGbKdosSEd3GYRlK70vq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962445; c=relaxed/simple;
	bh=eBs14a05W3jkPeV2fmECsGLJ8XZZ3WpyV6QJH/MP+5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBXCXnaDHkou368nlzS3nSHHtLOJou8WCrgP1GdwM1TCmkwuWznH1BwCliAtjSlJG0G0TLDPmYYQUxDtxIvo109UvhfWnj2x0jN4cRNc5O1hESyIDwaXB5/Q4a5S2StZq7g3/PlDlk2xsSKGeqyXl0Ius6xLIE7Mzgs2z8pnrxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2GGgHtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2GGgHtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A87C4CEF1;
	Fri,  9 Jan 2026 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962445;
	bh=eBs14a05W3jkPeV2fmECsGLJ8XZZ3WpyV6QJH/MP+5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2GGgHtRnL2eVuHooP44Gxai+IX6Xcig13HN4Ta3wcv/4/UVRWiFOZpubW04w+9Cy
	 D31Vh2hLZjYxD7/8gCnAOypFlVpPbs02uqFX4tCHfOVIEfkxZ11mPsq1aNfFJeniFW
	 XOwR51GeS9T4DoIKYfhrYpvIcjYyLo9R1r4MnYFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 367/634] KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits
Date: Fri,  9 Jan 2026 12:40:45 +0100
Message-ID: <20260109112131.341106642@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit da01f64e7470988f8607776aa7afa924208863fb upstream.

Explicitly clear exit_code_hi in the VMCB when synthesizing "normal"
nested VM-Exits, as the full exit code is a 64-bit value (spoiler alert),
and all exit codes for non-failing VMRUN use only bits 31:0.

Cc: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: stable@vger.kernel.org
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251113225621.1688428-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    2 ++
 arch/x86/kvm/svm/svm.h |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2531,6 +2531,7 @@ static bool check_selective_cr0_intercep
 
 	if (cr0 ^ val) {
 		svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+		svm->vmcb->control.exit_code_hi = 0;
 		ret = (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE);
 	}
 
@@ -4445,6 +4446,7 @@ static int svm_check_intercept(struct kv
 	if (static_cpu_has(X86_FEATURE_NRIPS))
 		vmcb->control.next_rip  = info->next_rip;
 	vmcb->control.exit_code = icpt_info.exit_code;
+	vmcb->control.exit_code_hi = 0;
 	vmexit = nested_svm_exit_handled(svm);
 
 	ret = (vmexit == NESTED_EXIT_DONE) ? X86EMUL_INTERCEPTED
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -606,9 +606,10 @@ int nested_svm_vmexit(struct vcpu_svm *s
 
 static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
 {
-	svm->vmcb->control.exit_code   = exit_code;
-	svm->vmcb->control.exit_info_1 = 0;
-	svm->vmcb->control.exit_info_2 = 0;
+	svm->vmcb->control.exit_code	= exit_code;
+	svm->vmcb->control.exit_code_hi	= 0;
+	svm->vmcb->control.exit_info_1	= 0;
+	svm->vmcb->control.exit_info_2	= 0;
 	return nested_svm_vmexit(svm);
 }
 


