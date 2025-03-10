Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC9822CBFD;
	Mon, 10 Mar 2025 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627734; cv=none; b=fJk3ELNPgY3kq2j55ezGddTaGSmMW6cV+2ZX9bxj2PiRz5fe2C+xHPNF9Gg8QI7qC2V4J1+KVPmfRbq7SGVl5taAHeaxn49oItxwjj+2zMUSTqb4CcM5Hg38K3PdH2wU0YHzUGR0z0NXZKb+7SJWP7kM/fUndsyOeF1VR5KCVao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627734; c=relaxed/simple;
	bh=qjoOWGESrEISQAerxlY3fZhvChGVpT3F5rqoGWliypk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxhC5IObcZyjlHuMEX0nstivzkV7gUqpvEAL1G/OTNlxOF85Xk22g5imYMWzXZ9D/Tax7pGePETTbTiXI0EVnYzlQA43hLk8KYeYIm4Oyu5EPGIafY2/4XhPujiS92zENMU+GwdRuGvLa1MAkMoce7tjQaV4GeWLs4Zog9dWAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKEtp0Lq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKEtp0Lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D07C4CEEC;
	Mon, 10 Mar 2025 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627734;
	bh=qjoOWGESrEISQAerxlY3fZhvChGVpT3F5rqoGWliypk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKEtp0LqYwdFl5011y2UUdyQxgY2q122A/Ow56+tQvDPCv5dKsXl3PYFc3WMve/vI
	 E0ipyGHMGIE6wKc4sM50XyFGjwXrPfxqBkmG5L1FDoDZ3JEAfqTho8S0ESDRt4Pcwj
	 odlaCFT9LXS4Ts0uk07+zUCnN3/1zlMWrkDROfFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 232/269] KVM: SVM: Suppress DEBUGCTL.BTF on AMD
Date: Mon, 10 Mar 2025 18:06:25 +0100
Message-ID: <20250310170506.932653544@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit d0eac42f5cecce009d315655bee341304fbe075e upstream.

Mark BTF as reserved in DEBUGCTL on AMD, as KVM doesn't actually support
BTF, and fully enabling BTF virtualization is non-trivial due to
interactions with the emulator, guest_debug, #DB interception, nested SVM,
etc.

Don't inject #GP if the guest attempts to set BTF, as there's no way to
communicate lack of support to the guest, and instead suppress the flag
and treat the WRMSR as (partially) unsupported.

In short, make KVM behave the same on AMD and Intel (VMX already squashes
BTF).

Note, due to other bugs in KVM's handling of DEBUGCTL, the only way BTF
has "worked" in any capacity is if the guest simultaneously enables LBRs.

Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    9 +++++++++
 arch/x86/kvm/svm/svm.h |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3179,6 +3179,15 @@ static int svm_set_msr(struct kvm_vcpu *
 		 */
 		data &= ~GENMASK(5, 2);
 
+		/*
+		 * Suppress BTF as KVM doesn't virtualize BTF, but there's no
+		 * way to communicate lack of support to the guest.
+		 */
+		if (data & DEBUGCTLMSR_BTF) {
+			kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
+			data &= ~DEBUGCTLMSR_BTF;
+		}
+
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -591,7 +591,7 @@ static inline bool is_vnmi_enabled(struc
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-#define DEBUGCTL_RESERVED_BITS (~(DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR))
+#define DEBUGCTL_RESERVED_BITS (~DEBUGCTLMSR_LBR)
 
 extern bool dump_invalid_vmcb;
 


