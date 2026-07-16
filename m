Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC983B0ADE;
	Thu, 16 Jul 2026 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211544; cv=none; b=HWUwG+ZdFv2YwIIo6IEtCAqfXDdpkhonOnimdfg9vqESp5xcZZsg4zhk7oZfGfNZlYA8ReIByFLRhqa+AFK07qLqLnkXzx9SAL3MbWfRTpM+MME8RxQqNubKkKHY2YFFYlGKzVMeNWAoMrD/oqhA+Xunp7PQV6N12AuECgio5tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211544; c=relaxed/simple;
	bh=kS7BP0qE/+uuv4sJn6Yo4N5SZ+JtaQnWar3d5gARM88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPKbi2cLUC/nilryPclMjOx5dcXh5dZdcSDyBWd04XD+cZSqoAX9OCA0ZnO7qXqaq2W91hTwVyR2MYTqV6Mfgo6v7/xOrbBbOGhKGq+NJjntBvNXTykcf8n425KRkxxglaz+X+qsIBPzgb1tpXX6L/9iohvc4KvxFDfZzhznq40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ypRMkCU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ypRMkCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9561F00A3D;
	Thu, 16 Jul 2026 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211543;
	bh=NKugVTY5CYSF0QL0sZogLl+0LwHBvWYetSFzflSyeag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ypRMkCU72sxc7mULmjiXkwOszDD3ypsKiQXhB6LSHutUTz4Xt9mDFnPc8Souz46g
	 R6v6nCV2xlerbI5dZn6A+iroFsXd2PoatIp27QMc48FM/3imWKcFb+b5RS3bmL+P5v
	 huUIj4Grevfo2GlBNkltIBn4DX/Tc+Pe9O51r2yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 424/480] KVM: SVM: Only disable x2AVIC WRMSR interception for MSRs that are accelerated
Date: Thu, 16 Jul 2026 15:32:51 +0200
Message-ID: <20260716133053.986865607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

commit 8c63179d975f2029c948ecce622f72af616dbff7 upstream.

When x2AVIC is enabled, disable WRMSR interception only for MSRs that are
actually accelerated by hardware.  Disabling interception for MSRs that
aren't accelerated is functionally "fine", and in some cases a weird "win"
for performance, but only for cases that should never be triggered by a
well-behaved VM (writes to read-only registers; the #GP will typically
occur in the guest without taking a #VMEXIT, even for fault-like exits).

But overall, disabling interception for MSRs that aren't accelerated is at
best confusing and unintuitive, and at worst introduces avoidable risk, as
the APM's documentation is imperfect and contradictory.  The table in
"15.29.3.1 Virtual APIC Register Accesses" of simply states that such
writes generate exits, where as "Section 15.29.10 x2AVIC" says:

  x2APIC MSR intercept checks and access checks have higher priority than
  AVIC access permission checks.

CPU behavior follows the latter (which makes perfect sense), but all in
all there's simply no reason to disable interception just to make a #GP
faster.

Note, the set of MSRs that are passed through for write is identical to
VMX's set when IPI virtualization is enabled.  This is not a coincidence,
and is another motiviating factor for cleaning up the intercepts, as x2AVIC
is functionally equivalent to APICv+IPIv.

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Link: https://patch.msgid.link/20260514213115.1637082-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |   40 ++++------------------------------------
 1 file changed, 4 insertions(+), 36 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -113,39 +113,6 @@ static void avic_set_x2apic_msr_intercep
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	u64 rd_regs;
-
-	static const u32 x2avic_passthrough_msrs[] = {
-		X2APIC_MSR(APIC_ID),
-		X2APIC_MSR(APIC_LVR),
-		X2APIC_MSR(APIC_TASKPRI),
-		X2APIC_MSR(APIC_ARBPRI),
-		X2APIC_MSR(APIC_PROCPRI),
-		X2APIC_MSR(APIC_EOI),
-		X2APIC_MSR(APIC_RRR),
-		X2APIC_MSR(APIC_LDR),
-		X2APIC_MSR(APIC_DFR),
-		X2APIC_MSR(APIC_SPIV),
-		X2APIC_MSR(APIC_ISR),
-		X2APIC_MSR(APIC_TMR),
-		X2APIC_MSR(APIC_IRR),
-		X2APIC_MSR(APIC_ESR),
-		X2APIC_MSR(APIC_ICR),
-		X2APIC_MSR(APIC_ICR2),
-
-		/*
-		 * Note!  Always intercept LVTT, as TSC-deadline timer mode
-		 * isn't virtualized by hardware, and the CPU will generate a
-		 * #GP instead of a #VMEXIT.
-		 */
-		X2APIC_MSR(APIC_LVTTHMR),
-		X2APIC_MSR(APIC_LVTPC),
-		X2APIC_MSR(APIC_LVT0),
-		X2APIC_MSR(APIC_LVT1),
-		X2APIC_MSR(APIC_LVTERR),
-		X2APIC_MSR(APIC_TMICT),
-		X2APIC_MSR(APIC_TMCCT),
-		X2APIC_MSR(APIC_TDCR),
-	};
 	int i;
 
 	if (intercept == svm->x2avic_msrs_intercepted)
@@ -160,9 +127,10 @@ static void avic_set_x2apic_msr_intercep
 		svm_set_intercept_for_msr(vcpu, APIC_BASE_MSR + i,
 					  MSR_TYPE_R, intercept);
 
-	for (i = 0; i < ARRAY_SIZE(x2avic_passthrough_msrs); i++)
-		svm_set_intercept_for_msr(vcpu, x2avic_passthrough_msrs[i],
-					  MSR_TYPE_W, intercept);
+	svm_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_W, intercept);
+	svm_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W, intercept);
+	svm_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W, intercept);
+	svm_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR), MSR_TYPE_W, intercept);
 
 	svm->x2avic_msrs_intercepted = intercept;
 }


