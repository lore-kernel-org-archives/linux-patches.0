Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215094;
	b=WoThWqPMjqhKMW363gUGOGH8LcfEu3qCfUmdFOt4R8Phjsp0da3bX819EwmKGAFcNAjJ
	 QOoWsMdbSEa5vBbD7V1N/Qrhw3p0RjeP6Ors0dgkpbWuV8/MXbNqE39WgRbTlaUJxNPBV
	 x/uKpwdRhmGKdkni+rBkv2Wztu6j03mPxjG3JtIVuPpqweJlYaCB+E6HttbiR0eelANrV
	 6umFt5QJB0iv6vVL6hiTDe/md84ZXZA+7zbzHj/tZo2jZNtgEhlXbPvki+abird3y3dlM
	 IUBTm05lIXWSQrrns71t+jP1uQ0yNGmFFOjHkf0SyCL0rb9oge9JynBx87aVXlgbsoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QoOMU35Kgt+7ZRhDzDYHTlx3siAiFVvpoEuOhsvjuUg=;
	b=JRoirM9eVlDt1dmfAZJsXLqw/GdtwyqToi35NqaT0auIrR0H8HfSvHW4HK62ioO2+F5n
	 P/hrppA8crgfIGm826FbYYdKIEg2mHJyRWJ1iG06iFQJjdyWYU5QU556Dp/Uh6i2S/mof
	 DKPyFrhqeRm9lJSyL6F6ij6hVSBOdfqpJp/FJAtJZ8vzdNOeyUBqM8wPqp3LImT6H74Y6
	 vH2lK+cgjEoeEZpcGYWrMjlkRGe8Zw0bVwofsYbB6vVm/PQfENwycBTkdtG0dhkLfbuzk
	 nh7qD+V+Yv0go7wauJf69+21SQfIRIVpXO05QfoHriCzGUslLYUJW38h3+SUVe2HKDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oE5dcN/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2123606A31D;
	Wed, 28 Oct 2026 19:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oE5dcN/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF841F01825;
	Wed, 28 Oct 2026 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215093;
	bh=QoOMU35Kgt+7ZRhDzDYHTlx3siAiFVvpoEuOhsvjuUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oE5dcN/hxsVC6wlNxnYZ2yOFmLTQQHQDhdd8iee/ttMOlL4p6q7RZmBV3qGya+2DS
	 8nJfqOWAj7E2hcb3qswz+BMxHc6glfh2E8wyp2dFZeigsODgz/Ty0ACbgLoC+x9O1e
	 N/D3uN43OpnBc3QmAsg4G1STi+JMYP/bWP6DLZg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1046/1887] KVM: nSVM: Always use NextRIP as vmcb02s NextRIP after first L2 VMRUN
Date: Wed, 28 Oct 2026 17:52:22 +0100
Message-ID: <20261028170523.214309807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kvm/svm/nested.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dbb4b3d2c8046..313f9e952d6a8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -684,24 +684,30 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
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
-	if (svm->nrips_enabled)
-		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
-	else if (boot_cpu_has(X86_FEATURE_NRIPS))
-		vmcb02->control.next_rip    = vmcb12_rip;
+	if (boot_cpu_has(X86_FEATURE_NRIPS)) {
+		if (svm->nrips_enabled || !svm->nested.nested_run_pending)
+			vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
+		else
+			vmcb02->control.next_rip    = vmcb12_rip;
+	}
 
 	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
 		svm->soft_int_injected = true;
 		svm->soft_int_csbase = vmcb12_csbase;
 		svm->soft_int_old_rip = vmcb12_rip;
-		if (svm->nrips_enabled)
+		if (svm->nrips_enabled || !svm->nested.nested_run_pending)
 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
 		else
 			svm->soft_int_next_rip = vmcb12_rip;
-- 
2.53.0



