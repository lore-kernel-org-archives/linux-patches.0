Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2D32C026C;
	Sat, 17 Oct 2026 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254211; cv=none; b=S96ZogxnoHm6YFynmthNlaJG2+Vo6i0RxyZb8EhDbTkG0Gz5n4QXdzMtdDIaQUAWuZj3VKY8ZNiXfCrPcjUNO4zjF7sgckuGrq+0IJK6ciF/spwJ0AS0IqbAmOFoKfI8K8oMj6yp6O0+Yj9yhq2sxtKLjSkukjKFhMJD2YoKaR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254211; c=relaxed/simple;
	bh=U8dh9UPppKVi5VAfMenU6Y3D8qP2eU0uCHRHIM4qAv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4/Dwkd5A0AaaYTMBucAIpZKdcc6vWVlHCuFJkorQWKGDTli0u/W8sqyfv38KDHEAydKipFAwZFCtfc7MO0xwu1UqXPS047sR3IPQP1BCVn4HnJQa6kpS/M/J4tIlCEXWCSEQyhW/PEztE9uUNwVIIovk3RvOAu7p9QUwzxGk+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zs4Ysea0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zs4Ysea0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0691F000C4;
	Sat, 17 Oct 2026 16:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254210;
	bh=ij5HqaZOhr7VzRtzWF8xE9HXLPOPzB5rTscGomjYR80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zs4Ysea0ptJiAYpsznW8M5cLguQVNrzUPsLqi8X7B7zR/LzSXJeadtfFPal6wOCJC
	 Na9Fy/bjZNsyg/tIPmVE+AO4ngkWdq3oDtnOow7T/0UsZJSzNW+3tHSOQQ+dEbW0I+
	 iLP6vCnMNEqweWwXEPFde1yhcUI8iE265nOLF3xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/869] KVM: x86: Drop superfluous kvm_lapic_set_base() call when setting APIC state
Date: Sat, 17 Oct 2026 17:53:32 +0200
Message-ID: <20261017160046.621797532@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 8166d25579120590ad0ec4ece02afd00a3c54f6a ]

Now that kvm_lapic_set_base() does nothing if the "new" APIC base MSR is
the same as the current value, drop the kvm_lapic_set_base() call in the
KVM_SET_LAPIC flow that passes in the current value, as it too does
nothing.

Note, the purpose of invoking kvm_lapic_set_base() was purely to set
apic->base_address (see commit 5dbc8f3fed0b ("KVM: use kvm_lapic_set_base()
to change apic_base")).  And there is no evidence that explicitly setting
apic->base_address in KVM_SET_LAPIC ever had any functional impact; even
in the original commit 96ad2cc61324 ("KVM: in-kernel LAPIC save and restore
support"), all flows that set apic_base also set apic->base_address to the
same address.  E.g. svm_create_vcpu() did open code a write to apic_base,

	svm->vcpu.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;

but it also called kvm_create_lapic() when irqchip_in_kernel() is true.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-3-seanjc@google.com
Link: https://lore.kernel.org/r/20241101183555.1794700-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: bb365a506b1e ("KVM: x86: Unconditionally recompute CR8 intercept on PPR update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a7d38b8cbd756..910db04a1addc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3107,7 +3107,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 
 	kvm_x86_call(apicv_pre_state_restore)(vcpu);
 
-	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
 	/* set SPIV separately to get count of SW disabled APICs right */
 	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
 
-- 
2.53.0



