Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046023;
	b=0BVWhteac601oCy+imucegWlHpwdf9MD+bAct6hTlJatEixLTscgpLDiPVlBRNWXz6BF
	 WrJV/lmyrQ4WVNiAZvh2zdZWkWyShEwo2WVZ4bGvWIjjqhIP/4HDqItmt9xETQp334Pcl
	 PTSpivBvOuDC0cDDSmS9t6vzcEnT150XP8nUAVYWdNZdhCVcH7+bTV9QE6NIwxNN3UF6V
	 juqmCpE8CGlbh0loWmy4P1OWl/my/ZyLHmxjjLLGwJGxwMpKtUjASq1KV4ZsSxHZ+2Nys
	 Zwh3XtdZzkHeFvjbGpPztUoIwmbN0XHvFvo/o0K88/4Fui6SkpYW8L3yBEMMLk0xVHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eHaDFxKtXlUxSMSXj+1QlovigVWw2eAbkVrIhXfLbvw=;
	b=XCyveu8AMQef7kuDiypklmbUqwzbEzXSvGR1pr3yvcCYnhyRAmemz8fKFgsHWmyavPln
	 i9a9OnS8J2cwWH21Da/5PbUmE68VX5HgFuI/FaV5NBIEkgiWGyPL9SNjyLZnWJwLxYqW0
	 bRkqHusN/jdys6+cvpWjfDVCO7uswX0zybZ2AJiWFVMoI5ceG1ELF0eIJpVUzc5jO0YVk
	 CJM4hS4CUMMtLzNjY+UPbSkEDkqG4W3GMuS3JxpDcAdDxK82eC4yJur2Wvzb4cR9ZbD6G
	 Vuta7XAyuA5IHmBOOLtMzkdYPWBuhrb8E4pya1pnGRegGrggT73ZaAaFac3eNul9Dsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=in+izRBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64738606A325;
	Wed, 18 Nov 2026 23:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=in+izRBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57DD1F000C4;
	Wed, 18 Nov 2026 23:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046023;
	bh=eHaDFxKtXlUxSMSXj+1QlovigVWw2eAbkVrIhXfLbvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=in+izRBie0RF3PMeGp5ZClQo6/HcUaZUKnyOQYm3P/fiMtBLTzIZNHqj5Pmwh3Kgq
	 YvqYgWHod6XpLW5sCbYPV5M2KuLGGm3ol98UQZpFvQZ8doomHw50/4vBgQTig1ZV+b
	 GhigwErmjhPkcxNOPs5mOU+1kZEj0WFwlelnjk4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1134/2857] KVM: x86/xen: Take kvm->srcu in __kvm_xen_has_interrupt()
Date: Wed, 18 Nov 2026 15:36:08 +0100
Message-ID: <20261118150242.427690856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit aa8ad943f242ef14d136c5440b1178de77466c9e ]

kvm_gpc_check() checks the cached memslot generation against the current
one, which dereferences kvm->memslots and therefore requires kvm->srcu to
be held. __kvm_xen_has_interrupt() does not take it.

Most callers do happen to hold kvm->srcu, but not all of them:

 - kvm_emulate_halt() on the VM-Exit path, via kvm_vcpu_has_events() and
   kvm_cpu_has_extint(). vcpu_enter_guest() drops the vCPU's SRCU lock
   before entering the guest, so it is not held on the way back out.

 - kvm_vcpu_block() -> kvm_vcpu_check_block() -> kvm_arch_vcpu_runnable(),
   which is the case the existing comment in this function describes.

On a PROVE_RCU kernel the former produces:

  WARNING: suspicious RCU usage
  include/linux/kvm_host.h:1092 suspicious rcu_dereference_check() usage!
  ...
   kvm_gpc_check+0x344/0x3e0 [kvm]
   __kvm_xen_has_interrupt+0x83/0x310 [kvm]
   kvm_cpu_has_extint+0x1ff/0x370 [kvm]
   kvm_cpu_has_interrupt+0x16/0x100 [kvm]
   kvm_vcpu_has_events+0x4ce/0x690 [kvm]
   kvm_emulate_halt+0x52/0x1f0 [kvm]
   vmx_vcpu_run+0x988/0x2630 [kvm_intel]

Use guard(srcu) so that the three existing early returns don't each need
an explicit unlock. SRCU read sections nest, so this is harmless on the
paths which already hold it, and srcu_read_lock() does not sleep, so it
is also safe in the atomic case which this function already handles.

Fixes: 7caf9571563e ("KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_info")
Cc: stable@vger.kernel.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://patch.msgid.link/20260831213632.81023-11-dwmw2@infradead.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/xen.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 8e38f976feb47..baa0c6d180962 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -416,6 +416,16 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	BUILD_BUG_ON(sizeof(rc) !=
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
+	/*
+	 * kvm_gpc_check() checks the memslot generation, so kvm->srcu must be
+	 * held. Most callers hold it already, but this is also reached from
+	 * kvm_emulate_halt() on the VM-Exit path and from kvm_vcpu_block(),
+	 * where vcpu_enter_guest() has already dropped the vCPU's SRCU lock.
+	 * Taking SRCU does not sleep, so it is safe even in the atomic case
+	 * which is handled below.
+	 */
+	guard(srcu)(&v->kvm->srcu);
+
 	read_lock_irqsave(&gpc->lock, flags);
 	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
 					   sizeof(struct vcpu_info))) {
-- 
2.53.0



