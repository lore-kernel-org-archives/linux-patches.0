Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF2B359708;
	Fri,  9 Jan 2026 12:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960624; cv=none; b=SHFP2ZuIojeDmdm7sDbL3U2yjSr7xBLW24sJx/UKEZWFbpueV0l+UrQbpbJuylSa/CcjRaF4DZBi4X+RVTTlJxGDzuYDmfmrLHQQdPJX5rlZnjFp4LV9igEjDdOvenmQSQljDbC9jxoaPNeCmBejt9neS6TT6Qo+NKcH2C0gR2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960624; c=relaxed/simple;
	bh=qavE7+2Ri9B9DGXJj8SsJymcXVBbb3k5EONYNcxG8Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFtUs0EZaSr6fwgwS022dUylPsAC9j+ej1l5I4M1hD25hrrRT0zatPJvE+bUefuxLPRI3jsHK2DVXPUg9jGhCw0CvEAakK9c+Yb0jj2Z1Tf2HlkmF0/vcr6E+n7edyPJrwTtpAZwNfXhuZJ0IKsxTt6ilhLmCnXUXzF0BwdFafs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FL8ztQfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FL8ztQfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFDEC4CEF1;
	Fri,  9 Jan 2026 12:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960624;
	bh=qavE7+2Ri9B9DGXJj8SsJymcXVBbb3k5EONYNcxG8Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FL8ztQfZ12EQyybkYvUxHIhHdQ6EpH4qbTJKcyauNN5HlzJeVYFBVDMeolbINvo3Y
	 MxH/nha9t3jFVZvAfBWEKZmjmfe3zSAV48g+POgGQdJFw8DalG/kH0BjuDOTSmju1p
	 xTk/x1mKJDiNs1OoNhX0qSiEnwGWrTuNccY9Ydso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 470/737] KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits
Date: Fri,  9 Jan 2026 12:40:09 +0100
Message-ID: <20260109112151.667811216@linuxfoundation.org>
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
@@ -2645,6 +2645,7 @@ static bool check_selective_cr0_intercep
 
 	if (cr0 ^ val) {
 		svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+		svm->vmcb->control.exit_code_hi = 0;
 		ret = (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE);
 	}
 
@@ -4647,6 +4648,7 @@ static int svm_check_intercept(struct kv
 	if (static_cpu_has(X86_FEATURE_NRIPS))
 		vmcb->control.next_rip  = info->next_rip;
 	vmcb->control.exit_code = icpt_info.exit_code;
+	vmcb->control.exit_code_hi = 0;
 	vmexit = nested_svm_exit_handled(svm);
 
 	ret = (vmexit == NESTED_EXIT_DONE) ? X86EMUL_INTERCEPTED
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -601,9 +601,10 @@ int nested_svm_vmexit(struct vcpu_svm *s
 
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
 


