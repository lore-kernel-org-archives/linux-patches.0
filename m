Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF4151DAEB;
	Wed, 30 Sep 2026 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792819; cv=none; b=Fh77/1O4faWMz+uwXPveAPEauETMxxOgE7Msr8roA4GFioDSDFwrwhqnXBOrfz7VBPWHmCzW47bbYwoKwriMXY+NXPpwsU4SVW+kgTI+qTaUAVZRI75ONIvY82fnNYjmvj4xJBKeocGPk2NqBjbK9D72VZZa+e3SzoT5jegNDVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792819; c=relaxed/simple;
	bh=22JWvb2tBcOXPUCUPk7B6iU2j8ORsZsQi9mCYN17Pvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToNTDZQU4cbrkRAcuklrbjZ5a5Z3QxXN4/ofvLrrClSRu54Q53fe6mNsRv5yKKDqWufR86ag8Gx3ArdNijjt+NppqGau7GU6vi4dS1ZiWoxwHijwU6AUieDrEiEXHJZdJkonR/mq10xP08FOtPxLzu309T6fIC5BSyBrhFaVXcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhpPTCT5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhpPTCT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6938C1F000FF;
	Wed, 30 Sep 2026 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792817;
	bh=kwTFmDyoYerSQ3vp+JYtMAfR41gxn4XPfXLLUE39YWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhpPTCT5aF4kL4kWcqeq9AVwggYJ2lDW1uygVlkN6iyu5cmW/fnIvrakAparNscJT
	 PEoRQBB5QCHwDDi9idNLyrHRGWDEW//Xk0YS1O4O+9XYAHxpgsmlHel1SwnK9Cj2Dk
	 Vz5jLxETU0xyX4J1u6zYaCLIaqFDQxap04EIKa0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/395] KVM: arm64: Fix MTE flag initialization for protected VMs
Date: Wed, 30 Sep 2026 17:24:59 +0200
Message-ID: <20260930152341.427929483@linuxfoundation.org>
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

[ Upstream commit ebbcaece84738f71b35f32339bdeb8776004e641 ]

The function pkvm_init_features_from_host() initializes guest
features, propagating them from the host. The logic to propagate
KVM_ARCH_FLAG_MTE_ENABLED (Memory Tagging Extension)
has a couple of issues.

First, the check was in the common path, before the divergence for
protected and non-protected VMs. For non-protected VMs, this was
unnecessary, as 'kvm->arch.flags' is completely overwritten by
host_arch_flags immediately after, which already contains the MTE flag.
For protected VMs, this was setting the flag even if the feature is not
allowed.

Second, the check was reading 'host_kvm->arch.flags' instead of using
the local 'host_arch_flags', which is read once from the host flags.

Fix these by moving the MTE flag check inside the protected-VM-only
path, checking if the feature is allowed, and changing it to use the
correct host_arch_flags local variable. This ensures non-protected VMs
get the flag via the bulk copy, and protected VMs get it via an explicit
check.

Fixes: b7f345fbc32a ("KVM: arm64: Fix FEAT_MTE in pKVM")
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20251211104710.151771-4-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Stable-dep-of: 4f16c5fc8dc4 ("KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 26a19185e2ada..1b73a2411a998 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -341,9 +341,6 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	/* Preserve the vgic model so that GICv3 emulation works */
 	hyp_vm->kvm.arch.vgic.vgic_model = host_kvm->arch.vgic.vgic_model;
 
-	if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
-		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
-
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
 		hyp_vm->kvm.arch.flags = host_arch_flags;
@@ -359,6 +356,9 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		return;
 	}
 
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE))
+		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
+
 	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
 
 	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
-- 
2.53.0



