Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618A83B2FDC;
	Wed, 30 Sep 2026 18:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792816; cv=none; b=PuaCH1jEqhQR9rPnZsS5vQ8wowCPj7IbGNLLf4xRval1a5bQZyT5ezsSF3f++GrEZBNcIeLrl5a/27ZIQ9+fr8rYxRGsL1vHxx681O97IWAyc2gOcfo33FHPZHCPtnuq8TG5Jx5xQN2bsPg3Dwu9SDO4kDBCbdypX3IPOlBBADU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792816; c=relaxed/simple;
	bh=FEJE9ZX9UgtJZlKOmzBQRtwGHvuaGcJBqmenIGh+y+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HelhV8EPGVeq+HvDa1/6MRiZFF0R+6w2LZNPdNLf+I9AvmSk9+L/ju4BK2Bbds64Nvw2UoHxulGArqUHwuN2Ze5qK62gOOBxovJdz06xHq1s7lh8iUsBvlzkF0RJyPe1lFN6YbW7pwIhPL495Ta9JvWxw2/2mvx5hI6BaK4gj5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4Ec+u6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4Ec+u6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958691F000FF;
	Wed, 30 Sep 2026 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792815;
	bh=L5a1zcAShG7gW4TrHgCuHcZBdhK7JOL/XG/Olw1JLfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4Ec+u6BHx4x8K17ZwTfehObx+4vGkFwgDeoshJ1aSLXEGG3imJRTCVs6OKvfwwov
	 gV4OHjwD2jO+DZH9DAadCKKw6xj4ll5KYdhod9QPzsfooVduAJuwp+sQZ32k/wcTod
	 tXuYLvgBaOucEWkhGd/oQe6n620YlneqAJ9w1dAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/395] KVM: arm64: vgic-v3: Fix GICv3 trapping in protected mode
Date: Wed, 30 Sep 2026 17:24:58 +0200
Message-ID: <20260930152341.406765796@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 567ebfedb5bd204a8ce6a11695f02730f1bf57f4 ]

As we are about to start trapping a bunch of extra things, augment
the pKVM trap description with all the registers trapped by ICH_HCR_EL2.TC,
making them legal instead of resulting in a UNDEF injection in the guest.

While we're at it, ensure that pKVM captures the vgic model so that it
can be checked by the emulation code.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Link: https://msgid.link/20251120172540.2267180-6-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Stable-dep-of: 4f16c5fc8dc4 ("KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 3 +++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index b3ea49f121870..26a19185e2ada 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -338,6 +338,9 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	/* CTR_EL0 is always under host control, even for protected VMs. */
 	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
 
+	/* Preserve the vgic model so that GICv3 emulation works */
+	hyp_vm->kvm.arch.vgic.vgic_model = host_kvm->arch.vgic.vgic_model;
+
 	if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
 		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 82da9b03692d4..3108b5185c204 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -444,6 +444,8 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	/* Scalable Vector Registers are restricted. */
 
+	HOST_HANDLED(SYS_ICC_PMR_EL1),
+
 	RAZ_WI(SYS_ERRIDR_EL1),
 	RAZ_WI(SYS_ERRSELR_EL1),
 	RAZ_WI(SYS_ERXFR_EL1),
@@ -457,9 +459,12 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	/* Limited Ordering Regions Registers are restricted. */
 
+	HOST_HANDLED(SYS_ICC_DIR_EL1),
+	HOST_HANDLED(SYS_ICC_RPR_EL1),
 	HOST_HANDLED(SYS_ICC_SGI1R_EL1),
 	HOST_HANDLED(SYS_ICC_ASGI1R_EL1),
 	HOST_HANDLED(SYS_ICC_SGI0R_EL1),
+	HOST_HANDLED(SYS_ICC_CTLR_EL1),
 	{ SYS_DESC(SYS_ICC_SRE_EL1), .access = pvm_gic_read_sre, },
 
 	HOST_HANDLED(SYS_CCSIDR_EL1),
-- 
2.53.0



