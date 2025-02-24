Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAC821345;
	Mon, 24 Feb 2025 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408295; cv=none; b=bejyymkdtB+Yh5jEmXQ/dxpJiLSofWmWJWpbVC9abKx5TAid8BPfnuKbFTRRPE/VeTP3MolZFzj2nNg7uChV8GEetAuXEyhkgbbuzXzTCVKJDsn0hLsQjJv0GXEQnGkZ6REp44Nu/GUCNtEWR1dlOjilLRfUjth5R/Yr7NDcRAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408295; c=relaxed/simple;
	bh=JjzpQcE4/Pjf62bhiqcBBhE+45zXHHUDJz3yt/uLYh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVfxgqYFeGZkEzPSju2FyKoHzQxunUa536qSYtoo5ZdD3faAnfsAdUCwXHFfOSoPsj9I8HFDAynvdthlQj9E7zhStGOlCc25+Ep3XRXbjMOOUCmEHmxnhX8xp8Er9uKEK+MnwkyEJXXmld0iTDztTQdJmGuYfFTv213NMoJYui4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x26IXd3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x26IXd3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CB5C4CED6;
	Mon, 24 Feb 2025 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408295;
	bh=JjzpQcE4/Pjf62bhiqcBBhE+45zXHHUDJz3yt/uLYh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x26IXd3kbaHBMVJpmG2al3nslXKz8X/vH2Uyek4W6F8AaKY2YvBBIOFmLtKCe33WU
	 LYJEGGvU2K4LL8Nx3q6Ort+hqMDYGvxOfTnKX0SLj5xb6QhSgwy38cC+nUlpCZu7y+
	 +2/LXxVM4M2op9LG20k231nRcxS5F0dN4a5ozBYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/154] KVM: x86: Inline kvm_get_apic_mode() in lapic.h
Date: Mon, 24 Feb 2025 15:33:35 +0100
Message-ID: <20250224142607.716290665@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

[ Upstream commit adfec1f4591cf8c69664104eaf41e06b2e7b767e ]

Inline kvm_get_apic_mode() in lapic.h to avoid a CALL+RET as well as an
export.  The underlying kvm_apic_mode() helper is public information, i.e.
there is no state/information that needs to be hidden from vendor modules.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-5-seanjc@google.com
Link: https://lore.kernel.org/r/20241101183555.1794700-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 04bc93cf49d1 ("KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.h | 6 +++++-
 arch/x86/kvm/x86.c   | 6 ------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 441abc4f4afd9..fc4bd36d44cfc 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -120,7 +120,6 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
-enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
@@ -270,6 +269,11 @@ static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
 }
 
+static inline enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
+{
+	return kvm_apic_mode(vcpu->arch.apic_base);
+}
+
 static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 {
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 36bedf235340c..b67a2f46e40b0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -667,12 +667,6 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
-{
-	return kvm_apic_mode(vcpu->arch.apic_base);
-}
-EXPORT_SYMBOL_GPL(kvm_get_apic_mode);
-
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
-- 
2.39.5



