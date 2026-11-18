Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037770;
	b=3cm+wU5lapUTLYt78vBli6ufWAzntGwssQ1klT/xQj6Xz/iBFgUoQ4rw2+mMcQLn0I4L
	 pNQkYatekUMpNvRU539fbf9gf/myr2Jymmxhf7VlRiYp4NRwjvfFLMFrf4mIiwKAoW1cP
	 7343iaR3yqD70GlDNIif75vY5v8Rj/UU207ArcgxUmogalQrmXuDeJjTTMRHb+40pfjQY
	 +kSTbR6/2ij3oAuXzW8pB26eKjn7DWidcknq3Zq+x+f9uGV1KePIWA74mQhu2k40jV+Vj
	 VWDhG0sP+5WOb6IOhMLZhAxdaq5JYZ27WdQ8HS9W5tDwJyo1QHYp9IBeQ3Dk0dCFmvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LUB51Ny5y2lbFs4uibbd/Ea5pFoBD7coWH3IIj1n38A=;
	b=MK1pGBabgwFi8n33jbavk0zuGhJImv/OcBO8sIxpexmxbWkVWeZ/Gd6//c0oK4m+/md/
	 SUQKObqe1fyR9H3K6QhKk0Lo9kyPlXcGmGaJ11qqrh86GSt/8Gb7zL5hGMq2R5ZJFqkCv
	 3EfDqTnk9vONYYja28+wT8XQUVVvWF/gxuRvAFzBhpxPm9imyHh5wm74voxWd/oBPylXQ
	 FgZbx85XdZZNw7UhfVVFHwZIrC7MNlOamkOuRjGFptlhIskBcY35JKxfOOLh1Wh1e/Aiv
	 QTzY7d+rVkbmtD4+iFhiZ5z323kgx8Q706zf4/vHK0yOmKUjB9I4/UhYxLIazUXjUKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjFuRoV7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A450606A31C;
	Wed, 18 Nov 2026 21:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjFuRoV7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946B01F000C4;
	Wed, 18 Nov 2026 21:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037770;
	bh=LUB51Ny5y2lbFs4uibbd/Ea5pFoBD7coWH3IIj1n38A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjFuRoV7M5XTgzgwb3k0ggi6r273GgK9xJRbexnfdj2qRMNf8g9hkuF29JX915VJS
	 gUBqUplWAYM1ma/jWxeqQDPLO03lGwqTCmNeWpdzjCcetm7plX7j0kz7VbIxcpuUVi
	 pViUgq0z1HgHiBd8+3tSAG2Auqcbdtjzbr53G5qk=
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
Subject: [PATCH 6.6 1472/3318] KVM: x86: Unconditionally reset MMU context when emulating INIT
Date: Wed, 18 Nov 2026 15:34:54 +0100
Message-ID: <20261118150405.056712723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a09ce0f97c22b..cc50327a0f137 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12327,18 +12327,23 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	static_call(kvm_x86_set_efer)(vcpu, 0);
 	static_call(kvm_x86_update_exception_bitmap)(vcpu);
 
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



