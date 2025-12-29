Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF883314C4;
	Mon, 29 Dec 2025 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025916; cv=none; b=Qr5tbslmmprSaML0VUYKhgmK6xinBnyY0YhKf0uO0rN/5Piv/tqaMsE7gL/+2il1nT+SVmoZQnkgCRzu9sp5cMCpvStuLOkPy/LiJ+nZkQgF9cX5lO1Bqk8REqtsWyLokPK55AgFED2JNNZWaffeMMkNxzMvrZYgA4yoU+FCOwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025916; c=relaxed/simple;
	bh=7RUXYjSUNgkXjOlauKf5Nq8zF2g2L4D6L2Tc0GuK/RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItfVFD/rtIFz27dTbqFwlIQD3PSIJ4gImkgindBkLz0GtvjXtOfg7apnrhytsS7/Z/INtVFGFaAKUOh5Dtpi7YUC1yG5iJsuRAm3qBJPiZ/N+Lq4L08oPM0yn+EotcBNrqPBUM+X+9hoJzBdlVsQz6xmekKu2WUmELgTBaqIAVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDS7sbAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDS7sbAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A21C4CEF7;
	Mon, 29 Dec 2025 16:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025916;
	bh=7RUXYjSUNgkXjOlauKf5Nq8zF2g2L4D6L2Tc0GuK/RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDS7sbAy87uY4e1oaugQXZR9WJ9PgpM8rXO4A6YBxhYhNUB1i1TnwEuKulgYcnFrZ
	 OUCfM3b7Qcsg2hJJB5aj0siOMqL5ZX1MKbyrF4LzUiho/9BzJJpk7zn5gdsIMroqin
	 IbMRBwFks8hXG2UxRttF+f4E7rvEvwlAtYqHcSKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 351/430] KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits
Date: Mon, 29 Dec 2025 17:12:33 +0100
Message-ID: <20251229160737.243990408@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -2438,6 +2438,7 @@ static bool check_selective_cr0_intercep
 
 	if (cr0 ^ val) {
 		svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+		svm->vmcb->control.exit_code_hi = 0;
 		ret = (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE);
 	}
 
@@ -4627,6 +4628,7 @@ static int svm_check_intercept(struct kv
 	if (static_cpu_has(X86_FEATURE_NRIPS))
 		vmcb->control.next_rip  = info->next_rip;
 	vmcb->control.exit_code = icpt_info.exit_code;
+	vmcb->control.exit_code_hi = 0;
 	vmexit = nested_svm_exit_handled(svm);
 
 	ret = (vmexit == NESTED_EXIT_DONE) ? X86EMUL_INTERCEPTED
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -764,9 +764,10 @@ int nested_svm_vmexit(struct vcpu_svm *s
 
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
 


