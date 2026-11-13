Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590701;
	b=rASEVHKypTik9R1Hhf7UMk+WIG1AscF7rnqCyYi7JF6FeY+sBxUhH/bvjm7/xbzu+wSd
	 8Cf/2/+8XDuICUEaCn8qICeJigsh/AS3cCd1V78ydPrnfnzRHBq4O9OHspolmyiQVwEhZ
	 qztJIuvKl4kUa2fCvuRCRNXpF+hq9V5gHNh/jP8UpmFu8BdffzuZTQHG5jTp7R6JuvhIO
	 NEKptcA5LkBx39ll4ydihSzImda9SgPKHWcdBBA6ErOPa0SuHrkL3P+uM/qShLUwQIGh3
	 M6IUd3esJ+crppqbXRQXcBRevmliV6Ikmum4bdaWXekjXz0ggb3F0SCDYrxLznIuAXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMNgA5ipw5k8CBZ8fBegdIZspCMJnHwlf6UQax+dQ9g=;
	b=Le38OpW8gCqXBvsGWKlPkQU10PsFfHAabc599ag6dZ59YEp9MAxBTAvMUZGIxQLRo59Y
	 bOD/bGkit7QFXRXchDKmPmRKUjzN6k9HjXGxLf3kk7HHHTOkqhWHefW2jDwdSjDHZ3wKK
	 8NfwnpKAjrKu9aDOnB1DxbN/kR/8bvKAemVzzz2O7sjG0H3WUYOuPiOCY9pGEflgJEElH
	 J1Rpzz0tCbxVGtzPjdUCyivhd/WlCbDN34cnbEFsIVaNeL9T0Z+BaMqkzkpy08Mf0oWUb
	 /ZIYHC1IXcs+dOG7EiBKrapnrXwEGDqNiA/g4uMX+JwSqlsX4v22Nh6EYqlHzYs4Gag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZQY6Vsr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDA3606B22B;
	Fri, 13 Nov 2026 17:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZQY6Vsr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20551F000C6;
	Fri, 13 Nov 2026 17:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590701;
	bh=KMNgA5ipw5k8CBZ8fBegdIZspCMJnHwlf6UQax+dQ9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZQY6VsryQjIn9eKYslZX1aTAfeXMYk4f9NN5/blR1CGaiKmjeHWkzN2B2yoCIfg6
	 HUv3t0849d6TsSOmCvQLf+sZW+FZoGomRtHWBnAtWIpdaCOWi+EvApZgR5BdoxqzfC
	 iuApp2EnJKzaWE87on8xv+3zG5lINzr8BoYx+ZiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 612/686] KVM: arm64: vgic: Stop the target vcpu when disabling LPIs
Date: Fri, 13 Nov 2026 10:52:25 -0500
Message-ID: <20261113153842.627868907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced missing kvm_pause_vcpu() and kvm_resume_vcpu() calls with whole-guest kvm_arm_halt_guest() and kvm_arm_resume_guest() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 79e018cec0f96..5ba3bb576bb15 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -303,9 +303,19 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
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
 		vgic_its_invalidate_all_caches(vcpu->kvm);
 		atomic_set_release(&vgic_cpu->ctlr, 0);
+		kvm_arm_resume_guest(vcpu->kvm);
 	} else {
 		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
 					      GICR_CTLR_ENABLE_LPIS);
-- 
2.53.0



