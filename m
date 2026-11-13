Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585917;
	b=OuI8u4gurLxlzsG1+WlCXGz/oUav3t14EhATs84VSnsNPiapVd9Yq3SNNfs1AZ4WRFEf
	 3/vvw0Ao5LsyHDvjjKI/ptGwqKexi46nCWsFnCN5jY0mnmfqKRZ0ZZzDxgAy0EbqDqduv
	 kebff/Vl+HvboGuo0J0qFRgrafAYfXe6p80ne+5+Ck0Y7+l7ixY2yFjmeELL66eOb3WWV
	 or/BYvpcOHFyGNWKjlOdd1UZMZJgMI/r7rn5hXyJ6tIdRcJL+OrUMGuUaSHmsyUdTsbkD
	 3o5vI8Sl6i50E4DCmAaG1oW0n+gXKZrisNmC0U6CzzfPeMrYhlkgfHGLz1/e6RZdZog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6HVXB3O7bgU8zeCm6CeznP+ZVKf0pOqTKlIaRPR0hiE=;
	b=2fx2Jq4IZ+MXCB3SijWB0qboUq4aYf1rSybXAFI1QRWrHnckSj2DFK+M+mXtn5UA7KGq
	 6cDcVowbRJYdONg6EnsfAfcD8fE5U4oB88eaokZXVFS1aVdeqQo+/7252R24keju1sfXz
	 haCLSML+NB2yGa4FF4JL5+qrVEpLvSnHUyR12iMUsyR3CYLV3z5b4W94pCJV8lXgQRiJ7
	 5uzMtXPAd3gsPWhyPNyTvb2swJSmte+XobE+5c0NlNjgVcmzW3Gw4YbtkvHPnp+79v8xV
	 FLbQ/Z/mfFTZ2xNIr7hBSj0u8WKJY7Yhbvjas/DVZFGWwJ9VZsuPhyLCCqAUWJAnxxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEKIExsb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB449607020E;
	Fri, 13 Nov 2026 16:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEKIExsb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8151B1F000C4;
	Fri, 13 Nov 2026 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585917;
	bh=6HVXB3O7bgU8zeCm6CeznP+ZVKf0pOqTKlIaRPR0hiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EEKIExsbubeSJMSlzO2hWZVDA34LO61bTj7WziRL4GEnKgd80P0bI597cB1hYopN3
	 SaPcdilDibvckzJ2ciQX8L1tGyOhuw0fjjDY8WF2THq50u61KGuu0At7zqUmOac+zm
	 1+DYwUU9NPjZJ4VLp6uaGPIXfWXaTg5om9YLNUto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 479/507] KVM: arm64: vgic: Stop the target vcpu when disabling LPIs
Date: Fri, 13 Nov 2026 10:53:03 -0500
Message-ID: <20261113153813.247026516@linuxfoundation.org>
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
[ sashal: Replaced per-vCPU pause/resume helpers with kvm_arm_halt_guest() and kvm_arm_resume_guest(), which pause all vCPUs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5ab789accc9d4..9e6200c5adcef 100644
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



