Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038475;
	b=m7IR5YA/igZR24cj/cNpkoEfihUmPg4YWBxV49yk1jOs7D08qQIumaDsFuz3dfqczwvr
	 rHJ0Pw6R+k7VmCWq0fysOf65X31EgSE+yqbW0KrhHkbdxfRLrdsUu9AWWlZd7lxCleAzA
	 0J5NECFRZ2T+f0KI/LAbo3pazURYNNVtCaKSdUSeVWs1JHOynlQVuO9ewIBe4Na6wUzyV
	 Cij+jo6WGVwvl/shSsBSTNNeBIwGRKAo2oRmCc1TNyCjmDVsquLDD7d9QIPsijQmKlwcN
	 fA1HWUqxRx1cP3owbLONEulqeuh96Iodco9sBL9Ujg4EQU2PdHTVp5DBgfxSk8VJjrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IHxJz0v6qYwmH+y21xlQHBsR+2TRr/OYKAZ8tK6AtIE=;
	b=TJR2jlwA03gQuQnB8dapU+YcqMqUpGbQCv/IbiuslUCHNiMmm/12fFtJG+4pshC2RMXX
	 fJprM/hLTz9Y804oD36DlURTZsYeGT5/en/ZJEgKzsgo6kXmy60YGsMJLzyqS3bYQsfiI
	 1DIY5lYPmTD9aAk0SxCHWvVHuworgNpnfogVVionVO6mlmLD/KO/K/5iMezOXOT4+cuDE
	 rVtwK1zrbqHRKhqsIV7aOSmmlVCZ6zI/v9bC1keZ822pLXInvX1kfVdK4wCKeM/hOSUNt
	 rfTdpAcSaTUQcgT1L4AmKqsfRPGbyuXcxUmzPuXMD/EBxzhLCCo1NJTjaw7Pt5HYjzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSkqVx2c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49456606A325;
	Wed, 18 Nov 2026 21:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSkqVx2c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEA71F000C4;
	Wed, 18 Nov 2026 21:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038475;
	bh=IHxJz0v6qYwmH+y21xlQHBsR+2TRr/OYKAZ8tK6AtIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSkqVx2cizRJlKkq/u6XWZRKZdMdDYFuSAVnSR+7Du2V8y9BX/i+Jfxs1sak7vdaD
	 R3I2J/QtTBUSc2MNrHfc0zpgI/ySGHz/ayp8bS8mLaecpD8QIsXOta5O7pGmRl5OO6
	 3OY8t80IaEC7EDEsg7iqYjIMr5kX5gaYO9oq79/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1756/3318] KVM: arm64: vgic: Stop the target vcpu when disabling LPIs
Date: Wed, 18 Nov 2026 15:39:38 +0100
Message-ID: <20261118150414.536825055@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit a1b4bd2c2c262b8094c86afb99364d16ac08cb66 ]

Disabling LPIs is pretty nasty, as it directly messes with the AP list
of the affected CPU, which could be running... This has the potential to
lead to really bad behaviours, and we should not be doing that.

Take example on the way the Active state is handled and simply pause the
the vcpu so that we are sure it is in a quiescent state, and the state be
safely manipulated.

Nobody has any expectation of performance for this anyway.

Fixes: 96085b949672d ("KVM: arm/arm64: vgic-v3: Retire pending interrupts on disabling LPIs")
Co-developed-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Oliver Upton <oupton@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-7-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: Replaced kvm_pause_vcpu()/kvm_resume_vcpu() with whole-guest kvm_arm_halt_guest()/kvm_arm_resume_guest() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 33ff9fcfcfb08..1dab5298ae9e7 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -276,9 +276,19 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 		if (ctlr != GICR_CTLR_ENABLE_LPIS)
 			return;
 
+		/*
+		 * Yes, disabling LPIs is painful, since it can be done from
+		 * a *remote* vcpu! So let's not take any chance, and make
+		 * sure that the target vCPU has written their LRs back to the
+		 * irq structures, and release any reference they would have.
+		 *
+		 * If it hurts, don't do it.
+		 */
+		kvm_arm_halt_guest(vcpu->kvm);
 		vgic_flush_pending_lpis(vcpu);
 		vgic_its_invalidate_cache(vcpu->kvm);
 		atomic_set_release(&vgic_cpu->ctlr, 0);
+		kvm_arm_resume_guest(vcpu->kvm);
 	} else {
 		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
 					      GICR_CTLR_ENABLE_LPIS);
-- 
2.53.0



