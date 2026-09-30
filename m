Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A8651DB02;
	Wed, 30 Sep 2026 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792822; cv=none; b=DX38g0hxLwVtw2xMWBE4FLGS/locYbGlzdm09RwdsE9xHCi4RGI4yZSzhdpG/Ma2RfuNtLHdIoCQ9B/2+Q1rRxYTEU50qhu0LfxHs6NQ1recW7K20FeFunUDv9lNS+U2fNQcPjVSPQnvRWh+zKACAL+ek4jMxhxL1Eo2CJ1qAGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792822; c=relaxed/simple;
	bh=K/BFH1ccmG6Q1QMuT18TVKZX23kSWas5SbRoIGF5vJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHcmN91QM93NYzo2hQouYan6+Oj/Yn/zKHX+pc/RYexFwKdEJG6gG0ilVe3amDvdz29BuUDrsno7dFxtF9wvrTeC4huQoeDT8zwrHP8amzNLxQQhO5CYYk1zoAUnxLPDAoeP8XiByiKAsjJLnmVcKilA98omDyf6gQMEqfsacKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFr9vgcB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFr9vgcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6841F000FF;
	Wed, 30 Sep 2026 18:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792820;
	bh=VoUsB1/h0jv3G0z46PQDzTpfYYBplyPhZHPwzBE7DVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFr9vgcBm7n4Yl25yqX4V0UjPLpq2sNaqf0hYFJ3+PY9337KB3OGfhFOd4lu2tmqm
	 dVKu8LrfvVBSAt5WHlqrwhncpnsiYT45NLrOGP9a9zCv+c9uh43GWUpq4qca8giAGz
	 atn9GBrVc2uwT5DZLG4QjhKP2Q0kLJIY04dvh+bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/395] KVM: arm64: Include VM type when checking VM capabilities in pKVM
Date: Wed, 30 Sep 2026 17:25:00 +0200
Message-ID: <20260930152341.450548303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Fuad Tabba <tabba@google.com>

[ Upstream commit 43a21a0f0c4ab7de755f2cee2ff4700f26fe0bba ]

Certain features and capabilities are restricted in protected mode. Most
of these features are restricted only for protected VMs, but some
are restricted for ALL VMs in protected mode.

Extend the pKVM capability check to pass the VM (kvm), and use that when
determining supported features.

Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20251211104710.151771-6-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Stable-dep-of: 4f16c5fc8dc4 ("KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h | 10 ++++++----
 arch/arm64/kvm/arm.c              |  4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 10 +++++-----
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 08be89c95466e..7195be508d994 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -23,10 +23,12 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm);
 int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
 
 /*
- * This functions as an allow-list of protected VM capabilities.
- * Features not explicitly allowed by this function are denied.
+ * Check whether the specific capability is allowed in pKVM.
+ *
+ * Certain features are allowed only for non-protected VMs in pKVM, which is why
+ * this takes the VM (kvm) as a parameter.
  */
-static inline bool kvm_pvm_ext_allowed(long ext)
+static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 {
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
@@ -43,7 +45,7 @@ static inline bool kvm_pvm_ext_allowed(long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		return true;
 	default:
-		return false;
+		return !kvm || !kvm_vm_is_protected(kvm);
 	}
 }
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5d2435dd76f35..52549bebb7829 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -87,7 +87,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	if (cap->flags)
 		return -EINVAL;
 
-	if (kvm_vm_is_protected(kvm) && !kvm_pvm_ext_allowed(cap->cap))
+	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, cap->cap))
 		return -EINVAL;
 
 	switch (cap->cap) {
@@ -312,7 +312,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
 
-	if (kvm && kvm_vm_is_protected(kvm) && !kvm_pvm_ext_allowed(ext))
+	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, ext))
 		return 0;
 
 	switch (ext) {
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 1b73a2411a998..43195083fe7d0 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -356,23 +356,23 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		return;
 	}
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE))
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE))
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
 
 	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
 
 	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PMU_V3))
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PMU_V3))
 		set_bit(KVM_ARM_VCPU_PMU_V3, allowed_features);
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_ADDRESS))
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_GENERIC))
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_SVE)) {
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE)) {
 		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
 	}
-- 
2.53.0



