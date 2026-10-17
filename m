Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B181E520A;
	Sat, 17 Oct 2026 16:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253934; cv=none; b=LhdjSs2EacR5Q6tYwMzdc4c02zEERkf4E2PMJb4h9NMf+QqrNaX9T1ToNNAXvXnpEDCqdLC7ABm7mIYiVxGgBvbpw7fDi6SolVGzc5zyTVMeyqgf/IFxABRr6enMficbf5mCntA7aIwsPVgxvat0jHxgETEbgbwK+P6piW+nens=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253934; c=relaxed/simple;
	bh=927OrWPIk67pCCmfeR1NZVZ1fbseJVANPHs3xRwCaEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aj2bHYO4ZEm3yYDUE/LqnwvUdz1j1qTzd3qyGfk8hvxquP68Vwzb5JbDImALAlfpF+UkC66r2Ctxr0oYTrb+vR7rrrs7xODmu86TXRUAIUZD4W/OrSMuICfL1/TPDsunPwW4bi8ZLU9AoAjyn3rNDl1bNBkbdD5Qs1cDM9ZTu2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRmb4AQR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRmb4AQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00C31F000C4;
	Sat, 17 Oct 2026 16:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253933;
	bh=AQN7gkTu1w/o9WIeXyGXvPScKUkCx6koqlD9jUTtem0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRmb4AQR2cWHoksLqO9gx4aYg2HEOLtuVFYaB0qwztoQZityDoFZZui8OSYcxXV1h
	 ts7HrKj/jFTtLa6IX/xChzmk6fZs9+p9zp0hMA8bPGZws0tVbzfMJghvXyyr5GiOFX
	 ZOtQA89lt5pgpLYaFdeMtnxG+q5m9gP8FH30Oces=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/869] KVM: nSVM: Always use NextRIP as vmcb02s NextRIP after first L2 VMRUN
Date: Sat, 17 Oct 2026 17:52:01 +0200
Message-ID: <20261017160044.251423103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit 8d397582f6b5e9fbcf09781c7c934b4910e94a50 ]

For guests with NRIPS disabled, L1 does not provide NextRIP when running
an L2 with an injected soft interrupt, instead it advances the current RIP
before running it. KVM uses the current RIP as the NextRIP in vmcb02 to
emulate a CPU without NRIPS.

However, after L2 runs the first time, NextRIP will be updated by the CPU
and/or KVM, and the current RIP is no longer the correct value to use in
vmcb02.  Hence, after save/restore, use the current RIP if and only if a
nested run is pending, otherwise use NextRIP.  Give soft_int_next_rip the
same treatment, as it's the same logic, just for a narrower use case.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260225005950.3739782-6-yosry@kernel.org
[sean: give soft_int_next_rip the same treatment]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 08274463ad867..2f98a90537d28 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -724,24 +724,32 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
 	/*
-	 * next_rip is consumed on VMRUN as the return address pushed on the
+	 * NextRIP is consumed on VMRUN as the return address pushed on the
 	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
-	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
-	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
-	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
-	 * prior to injecting the event).
+	 * to L1, take it verbatim from vmcb12.
+	 *
+	 * If nrips is supported in hardware but not exposed to L1, stuff the
+	 * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
+	 * responsible for advancing RIP prior to injecting the event). This is
+	 * only the case for the first L2 run after VMRUN. After that (e.g.
+	 * during save/restore), NextRIP is updated by the CPU and/or KVM, and
+	 * the value of the L2 RIP from vmcb12 should not be used.
 	 */
-	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
-		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
-	else if (boot_cpu_has(X86_FEATURE_NRIPS))
-		vmcb02->control.next_rip    = vmcb12_rip;
+	if (boot_cpu_has(X86_FEATURE_NRIPS)) {
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
+		    !svm->nested.nested_run_pending)
+			vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
+		else
+			vmcb02->control.next_rip    = vmcb12_rip;
+	}
 
 	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
 		svm->soft_int_injected = true;
 		svm->soft_int_csbase = vmcb12_csbase;
 		svm->soft_int_old_rip = vmcb12_rip;
-		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
+		    !svm->nested.nested_run_pending)
 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
 		else
 			svm->soft_int_next_rip = vmcb12_rip;
-- 
2.53.0



