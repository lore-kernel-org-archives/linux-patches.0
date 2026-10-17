Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D756436B93B;
	Sat, 17 Oct 2026 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254214; cv=none; b=r8ttoPhB+BVCQBS9vY9nd5aT0nTdbUQMjBWlFyeJioYqUo9CeWYUoT5HE2SUeG/g7yBjIUYW/dVsW/eBxosDOhElHqsA9tj3xMc7e7gP8stFU4sYFLg8vbbu/SG1UEDNgL141i0AKNGazrWTEkhpCNy1dL4HuahT1bZNj7DzPj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254214; c=relaxed/simple;
	bh=MmetMypoeCAqKyS2qsVgn7R/OyN7WKoh4wus6K99EzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmHB2SQd91y1sUTlfbkv9gR6PUuOq87oKGkt7NIRtO5DPpE4DieFg5A5CBK1mM3Ji4dDss0TxyTuNJp2wMR2QkdRhJ3SVx8fnwY7SXqojyIw9tCB7xXMM/AMcsfoZi5KOzb69SeXrMss4SNOeg0T3DF//O5xDm/COfc+hzQNIRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v50KRWkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v50KRWkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304201F000C4;
	Sat, 17 Oct 2026 16:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254213;
	bh=Uh36Mj2yw8QAxGztH7n9Yx21oNXaLjY2i2Y2CIMvFpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v50KRWkDTvk9cTCX//5kIEbgx78X1cpRQphApfBr7orBxG4eWZCGQ1kel0ubbO9lh
	 t1/6JsA0REw51rVPi9Il+PxnAmBNLBRWOyKd24c6xCXPaNbAFI3LG3fDewZ9U6fFs7
	 Uzg7Ed6AjuQ+j+NsA4EIUmxZ37SAlpuAzA99G6AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 372/869] KVM: x86: Move kvm_set_apic_base() implementation to lapic.c (from x86.c)
Date: Sat, 17 Oct 2026 17:53:33 +0200
Message-ID: <20261017160046.646217115@linuxfoundation.org>
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

[ Upstream commit c9c9acfcd5738fb292e670a582e4333a1187004c ]

Move kvm_set_apic_base() to lapic.c so that the bulk of KVM's local APIC
code resides in lapic.c, regardless of whether or not KVM is emulating the
local APIC in-kernel.  This will also allow making various helpers visible
only to lapic.c.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-6-seanjc@google.com
Link: https://lore.kernel.org/r/20241101183555.1794700-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: bb365a506b1e ("KVM: x86: Unconditionally recompute CR8 intercept on PPR update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 21 +++++++++++++++++++++
 arch/x86/kvm/x86.c   | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 910db04a1addc..ea1c1728c1bf2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2656,6 +2656,27 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	}
 }
 
+int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
+	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
+	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
+		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
+
+	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
+		return 1;
+	if (!msr_info->host_initiated) {
+		if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
+			return 1;
+		if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
+			return 1;
+	}
+
+	kvm_lapic_set_base(vcpu, msr_info->data);
+	kvm_recalculate_apic_map(vcpu->kvm);
+	return 0;
+}
+
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a28c6346a96a..af99fb9666132 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -658,27 +658,6 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
-{
-	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
-	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
-	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
-		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
-
-	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
-		return 1;
-	if (!msr_info->host_initiated) {
-		if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
-			return 1;
-		if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
-			return 1;
-	}
-
-	kvm_lapic_set_base(vcpu, msr_info->data);
-	kvm_recalculate_apic_map(vcpu->kvm);
-	return 0;
-}
-
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
  *
-- 
2.53.0



