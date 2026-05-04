Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A713D300A;
	Mon,  4 May 2026 14:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904077; cv=none; b=GsRDt82+RLbDxUXagggHPCDlxHGJ76d8LHZBZ8NPca5IdvneWGBpv5MLhYW/R4ZCqEK3uCbyFdpOQYRGGf64vtZelFCEbNELgdM8ZwURh5D/FLYKCUOJP1E743F200TvjUW0hksSdKeVTvQpSZ7V7f8fDOoOwT2qkWCtVg23MUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904077; c=relaxed/simple;
	bh=5rMg07mTSPmsyTunc5tgBjRlaAnaqXbCcpJWVGJ8VbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYL9PqcOpv+qKFCJ1XEpr7NAUqnpg+oODm8p+Z1KEas+FsjsxrVKODGaPsgNymjEBfaPlwOjhPF6X+x6rA5bVjjS6RLwSDLwHFYphMMqCdgx/17ZFKnMoBa8O0mEBCwoZph1s4O/j0FUCPaNEx1zupF3wNWLMCW4TdfVcFi07G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeawFZKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeawFZKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6DFC2BCC4;
	Mon,  4 May 2026 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904077;
	bh=5rMg07mTSPmsyTunc5tgBjRlaAnaqXbCcpJWVGJ8VbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeawFZKrN3qbzkEQfWC2GRpnYA3i4ugD59XiFOZFRUo/UG22MrQqADovg0drfdt5B
	 /oCQ7Itpz9/kI3YGshMhbuYwHLszd6pEXE8szi+ZwZM+F9f6EluzYWZxSSowB2RcVz
	 fePyxWkudww9/Nj2s1Eb1zmPI5xn4a7Dmg4LLsY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 175/275] KVM: nSVM: Always use NextRIP as vmcb02s NextRIP after first L2 VMRUN
Date: Mon,  4 May 2026 15:51:55 +0200
Message-ID: <20260504135149.570245193@linuxfoundation.org>
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

commit 8d397582f6b5e9fbcf09781c7c934b4910e94a50 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -814,24 +814,32 @@ static void nested_vmcb02_prepare_contro
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


