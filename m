Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053836;
	b=j1PDwpdHUvgigxujs1XCn1HSuWbqiAlg00EBik9lsENpM2FgVBuFg27FoH8yKFANprIx
	 mJm3Fl3b162RW9H0VSyRGeSU5J2nFrgXqGlC3J1Xj8dPyVcP77TfMtzd2e/vv5531oGjx
	 1OKtx0/sdXDRv79GU0Ffbt5QqGPyFPmKRX6KSJSOAytIt1yeC9xsgqXfQ1FcoplrA5Mb7
	 3wIZaHGvfb07nYfZI+53lDoM7EYX5Rlrulygm9ZZl4GjyjuxDAWoAsOQXl1ZbieeTtmYN
	 bq9oe1+wl4C7o/kZCIaJitulDG0FNHVSaJKrx9xMiZwOCAXqSyuR4f90aZ6JPsGxgfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zaXoWdpzAYvy+nluI2ZcHWJKdICd/mN/q9kpm4cBXjY=;
	b=hHgcIvtiV58BL3FcsQxrCfOoIaCsvaVuQcgmd/N/UbIMHYEuZYixNBUEaRZ4cUXeO43o
	 4X2lvcY7b4NkGLWgiaMMMDqtjOW8iPG/RTh8egpGWrVMjre2iWATTAcBL7IZ7s82ALSEF
	 VQWNvkurbA7vI1t78kh+nvKrZqlTwAcnW3pxpoxNovcIRb2vL5psFKlIUadl86oflzXNV
	 j+iYW8E9UZ6FmgZhMUvtTemdIWJoUvJDdTcF/b75J7RalBYHS4qVFlFQuTXUWGDZ6mYxa
	 2rVt1NZ9K6k3IzkHYG7cdBTLY3wijUZwvfaHCpdaUsA2qwyc5u1mhJPKtOZyAIu/SWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FG4spaFc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9196606A31C;
	Thu, 19 Nov 2026 02:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FG4spaFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCE21F000C4;
	Thu, 19 Nov 2026 02:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053836;
	bh=zaXoWdpzAYvy+nluI2ZcHWJKdICd/mN/q9kpm4cBXjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FG4spaFc6Dv4epkekonQqKT3cW1CxRW2bJDizvh15pnN8jdP9z80mBwSxxT6KQZ5i
	 klvJfgfDgSumZWSCfl7AABLK2WXq9gCLBP5xxb+3MmNbfjsJKcd1jIjSaT8GnoxbFe
	 6lMGc9c82Fj6sqJ3Qk+NmMYmwtRvUt0B+jXHvgDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1059/2214] KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded
Date: Wed, 18 Nov 2026 15:45:35 +0100
Message-ID: <20261118150054.670363045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 22b6557ad05bf05c73246f62c19af3e04017270e ]

IN_GUEST_MODE is advertised too late, when state has already been moved
onto CPU registers and cannot be observed by another CPU anymore.

Move the IN_GUEST_MODE publication ahead of the state being loaded, and
immediately check for pending request. This ensures that there is no
window of opportunity for another CPU to observe OUTSIDE_GUEST_MODE and
yet for state to be loaded.

This also simplifies the "state rollback", which solely amounts to
synchronising the timer when no irqchip is present.

Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-4-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: Omitted relocation of kvm_pmu_update_vcpu_events() because the helper is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6bff7fd323872..a621dd31d9213 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -836,28 +836,31 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
-		kvm_vgic_flush_hwstate(vcpu);
-
 		/*
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
 		 * Documentation/virt/kvm/vcpu-requests.rst
+		 *
+		 * Requests to self must be posted before this point, or
+		 * won't be taken into account until the next exit. No state
+		 * loading other than what happens at vcpu_load() time can
+		 * be done before we have checked for pending requests.
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			isb(); /* Ensure work in x_flush_hwstate is committed */
-			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
 				kvm_timer_sync_user(vcpu);
-			kvm_vgic_sync_hwstate(vcpu);
 			smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			preempt_enable();
 			continue;
 		}
 
+		/* From here onwards, we are commited to entering the guest */
+		kvm_vgic_flush_hwstate(vcpu);
+
 		kvm_arm_setup_debug(vcpu);
 
 		/**************************************************************
-- 
2.53.0



