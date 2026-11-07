Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063419;
	b=xQXIktQsU2cNcviCtPWZdxnfD0aDByl9HbtQZbP2HWBj91vPcj6kW49rO5lDF2RqD8ZJ
	 +01hVHZjPr6ftr1HCOYxk9KSKElQWyJZKailj/5Dd5+STw6lPVhi9yRsNJBy0+uq6eX0q
	 9PSifZE8w63REaArIDtftzN5olEmvBXzoDAJZKDBq6grqYtQMsrHLIlkjSTEW2MLQ/Kgt
	 Mw1JBQGBMWjgclmEZUvJQwHPV6UOa3cl/QETl830CAcith+tpEShjiHL4PtIjiXwMXbXm
	 AFvJJ/EPfyGw1kw9uaFNKmPsrWY/kEClH/mwnqLtbCOfG7i4XuV1NLO0KuyNbvTQchg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xOfDpDM8Z558ZiMFbEGNx3dYnRiopJCq4695R5xL7is=;
	b=dYZYDwAMiQADzcUWgDULZC801qBGA5lb60g81gjoBGGqFXPleb0VvU/V2qBxyeNdCeqc
	 90ESiuI1RCyUwigryK+9AU5IkN4gQm5yilbg/IuVHyol5l4kOVeEv+VQmybHHCu8bqhYP
	 WfZnC9tPEgdLLPyzycqEIE5HwbeTagOsyWr6SlhvV+xm8A0i5pY4VYjyzJ22fXYrzqnOW
	 x0BVzb24TWwHdOEWMHjx6dK/Atga+nZ5cLY4ntKiZIheEKSeGsKZP7SRx8S6NBuvfaqSu
	 N82hIIfXwmTRYoFGFSKzYdyohqiORjAzlsSaBoYx3VrSyHvo88B8OVWBJFNnPXa4rdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aeaSY6kr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2623F606D80B;
	Sat,  7 Nov 2026 14:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aeaSY6kr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D8C1F0089F;
	Sat,  7 Nov 2026 14:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063419;
	bh=xOfDpDM8Z558ZiMFbEGNx3dYnRiopJCq4695R5xL7is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeaSY6krljczNTYPGdeGfZnAEYvaM/tCddOyzVeNlgp0KvA2CVBWlY9kw+oLj/01/
	 C7Y10bPcjo4+aSikREI6zJFqcJRkJEBS/mlmd7HXa7djq65TLcXeuep2OfK99GKHVs
	 Z5fMgMKDm54TLa6RY1IQ12vLntgRMgq/j3ME5uX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 586/869] KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded
Date: Sat,  7 Nov 2026 08:54:28 -0500
Message-ID: <20261107134913.016299183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ab01b6c961132..c8a8d9ce4b14e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1229,31 +1229,33 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
-		kvm_vgic_flush_hwstate(vcpu);
-
-		kvm_pmu_update_vcpu_events(vcpu);
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
-			if (kvm_vcpu_has_pmu(vcpu))
-				kvm_pmu_sync_hwstate(vcpu);
 			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
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
+		kvm_pmu_update_vcpu_events(vcpu);
+
 		kvm_arch_vcpu_ctxflush_fp(vcpu);
 
 		/**************************************************************
-- 
2.53.0



