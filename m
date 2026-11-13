Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585578;
	b=vcKSOPbtgPNZRv4bCpVNVBQPHuB5NihC3IteF9LdpAlIAWTNNap7eBZe1KkgztEz07Ie
	 fD0pAlo6p5yyh1++7xvuJQd/FoOo2UxsJdHG59m/l2lJh9EKajJslqL3k6s1Tw0WdDPdR
	 ba8WesDskWPVsa0bFo4q4jU9Vd9Bwzy8rx59jEjvb8mn72fCvmzNQflDmbc8L/cfhUmyh
	 w6X/kzWS9mCeSknkspK9d4sv+fdiVpUieVO1npqinpFf/51EBydWEY65mjhjVoFwzHDej
	 OC1RcSZ3m+LLH2Ar9reqmMNdfqA3EyTZGz6o4syNjUFup8/ZD2k8gdICM6HRXyMsF9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jg4RzCxqT/7lWUUDpsEQrd1lUvmeblWTV7troDWfato=;
	b=0PzPUHGcQM0j5gLNhjXVw2+TUCZC1PJUhlCYycALTpcf1kT2mFvxf6YL9ZSKEvGuY12Z
	 WkQC/GPo8/8g6qXlWl6wNOntNRS9LjdAX5Zs7XaC+dhkLd5YaGO3h5qnMfRqbPLpWYLmp
	 6ITP37M6/YrnOjlA1TJL5/BMyYNVGYWe+N5t6ug78eAZZPZ+wTnttPalsHTxEbZ67CnkS
	 qn4oBdFuRbEMIqv2+2hBOgI49oDAFqykx7R44WExZ9CN9foXcBkiTTG3PQ6tFWUg1+GO7
	 5dzZe7WqsUF8cxpWYdkS0bLq0HrWQYt+4TPJtTtT+ndRdJxtk0fQgltt3cy8zCXUdzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVA03cid;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129946070202;
	Fri, 13 Nov 2026 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVA03cid
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F951F000C4;
	Fri, 13 Nov 2026 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585577;
	bh=jg4RzCxqT/7lWUUDpsEQrd1lUvmeblWTV7troDWfato=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVA03cidlMs5G5mvimKFg6mBeaGHakzwMAZjhj98xNsrIcO0Lg/MV2tK7uAdR0Iny
	 5QtiRwmiBsdjTYRt3Bw5gFwSuh37w2W770xqWSueQMi0angXGupEcD1SBurj33FibB
	 apDLFZy31/IFKYXwz4y9UBG9S5v371MPVf1jpLKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Oren Yomtov <thenameisoren@gmail.com>,
	Chris Mason <mason@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 210/507] KVM: x86: Unconditionally reset MMU context when emulating INIT
Date: Fri, 13 Nov 2026 10:48:34 -0500
Message-ID: <20261113153801.596513757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c7c288d178cb0b78d3464a616b16b1aa0b316049 ]

Force an MMU reset when emulating an INIT even if paging was already
disabled, as the MMU page role includes guest_mode (L2), i.e. an INIT while
L2 is running with CR0.PG=0 will result in KVM running L1 with a stale MMU
context.

Alternatively, the reset could be scoped strictly to paging being enabled
or L2 being active, but SMM is also encoded in the page role.  Even though
it _should_ be impossible for the vCPU to be INIT'd while SMM is active,
there's zero value in not handling SMM.  At that point, the only scenario
where KVM _doesn't_ need to reset the MMU context is on an INIT with the
vCPU running in Real Mode or Unpaged Protect Mode, and while INIT in those
modes is somewhat common, it's far from a hot path and re-initializing the
MMU is not expensive, especially when the role isn't changing (KVM elides
most of the re-configuration in that case).

Note, like the Fixes commit, this bug only affects nested SVM as INIT is an
unconditional intercept on VMX, i.e. it's impossible to emulate INIT while
L2 is active.

Temporarily keep the guest TLB flush when CR0.PG is being cleared even
though it is fully redundant with the flush that is emitted on all INIT
events (KVM itself only does RESET when a vCPU is being created, i.e. when
CR0.PG must be '0').

Fixes: ed129ec9057f ("KVM: x86: forcibly leave nested mode on vCPU reset")
Reported-by: Stefan Teodorescu <fane@google.com>
Reported-by: Oren Yomtov <thenameisoren@gmail.com>
Reported-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261022015407.279870-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00e2e4587543b..56a19a7260d3d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9663,18 +9663,23 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_x86_call(set_efer)(vcpu, 0);
 	kvm_x86_call(update_exception_bitmap)(vcpu);
 
+	if (old_cr0 & X86_CR0_PG)
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+
 	/*
-	 * On the standard CR0/CR4/EFER modification paths, there are several
-	 * complex conditions determining whether the MMU has to be reset and/or
-	 * which PCIDs have to be flushed.  However, CR0.WP and the paging-related
-	 * bits in CR4 and EFER are irrelevant if CR0.PG was '0'; and a reset+flush
-	 * is needed anyway if CR0.PG was '1' (which can only happen for INIT, as
-	 * CR0 will be '0' prior to RESET).  So we only need to check CR0.PG here.
+	 * Unconditionally reset the MMU, even though super strictly speaking,
+	 * a MMU reset is only necessary if and only one of the page role bits
+	 * is changing.  All of the CR0/CR4/EFER bits effectively get covered
+	 * by checking CR0.PG=1, as CR0.WP and the paging-related bits in CR4
+	 * and EFER are irrelevant if CR0.PG was '0'.  Subtly, if the vCPU was
+	 * in guest mode (L2) or SMM (although emulating INIT in SMM _should_
+	 * be impossible), an MMU reset is also necessary as "guest mode" and
+	 * "smm" are both encoded in the shadow page role.  As a result, the
+	 * only scenarios where an MMU reset is *not* needed is if the vCPU is
+	 * in Real Mode or Unpaged Protected Mode, and micro-optimizing those
+	 * paths are not worth the risk of running with a stale MMU context.
 	 */
-	if (old_cr0 & X86_CR0_PG) {
-		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
-		kvm_mmu_reset_context(vcpu);
-	}
+	kvm_mmu_reset_context(vcpu);
 
 	/*
 	 * Intel's SDM states that all TLB entries are flushed on INIT.  AMD's
-- 
2.53.0



