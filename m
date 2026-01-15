Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61FC3D3337;
	Thu, 15 Jan 2026 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498212; cv=none; b=jO0tx2eK4InBpkQ3UlTYkM+9f9zC8/E9CTXwmrFHBDEBnYToC0xTJv0EnCV9hc73Q9+qmgBJCuLEgX/B3bVdrMbfoEM4zx5H93/f84MMJC10S7VK6HNJhAlPdM7W0Nr0z+DYgRSzOkccwQ5nec70BGWzliotY9qs5uCbaW747P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498212; c=relaxed/simple;
	bh=G15KrVgCcXDqwxQcx5wXS0X3luKSOVSNepNlC9jQRBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHybzetrSxaU3pb12zbBdUe3Hgk1bzXDErn9GrsVX43do4qnXWbacm240nXl0DbBLDJ0fEA0q8ROdFCuXf9QLIMy3BRa2zQsSNGfvWk43VrczO9JmeU9y/xCnhH+/sea7prad++bMtl6xPMrl3KoJvuJVq2nt8jrXTjEY8nlOxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UY6mWUAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UY6mWUAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4795EC116D0;
	Thu, 15 Jan 2026 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498212;
	bh=G15KrVgCcXDqwxQcx5wXS0X3luKSOVSNepNlC9jQRBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UY6mWUALpCmnWtoueWJIaVpK/1CCrF0ISbAfHzYnNYXYcnwUpm4qG0d/cME+tTVuf
	 58aD4CDle057cJCs/52rYl/M/wRSIXtGb64sfaAu5xtWWtEdOha7ZsgN24MEWyGJrO
	 r7tFc7LPBQ0MyIOZUG+THgH0Ou8yXwwFp/484OBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 319/554] KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits
Date: Thu, 15 Jan 2026 17:46:25 +0100
Message-ID: <20260115164257.775503522@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2496,6 +2496,7 @@ static bool check_selective_cr0_intercep
 
 	if (cr0 ^ val) {
 		svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+		svm->vmcb->control.exit_code_hi = 0;
 		ret = (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE);
 	}
 
@@ -4288,6 +4289,7 @@ static int svm_check_intercept(struct kv
 	if (static_cpu_has(X86_FEATURE_NRIPS))
 		vmcb->control.next_rip  = info->next_rip;
 	vmcb->control.exit_code = icpt_info.exit_code;
+	vmcb->control.exit_code_hi = 0;
 	vmexit = nested_svm_exit_handled(svm);
 
 	ret = (vmexit == NESTED_EXIT_DONE) ? X86EMUL_INTERCEPTED
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -474,9 +474,10 @@ int nested_svm_vmexit(struct vcpu_svm *s
 
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
 


