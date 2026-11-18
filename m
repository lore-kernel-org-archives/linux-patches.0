Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038326;
	b=a5tjlLqRKekTfpu4CyoPQa8eIzFEeoEmY6+69iB47DJaKDj6M1l0yX4TQhGxIYo2mE2j
	 dTgON9v3xX7MUj/Sa60LCsUaAN4F8qD9MG665qoh6Tr0tE64X46ANvQUO2n534mrNrlJm
	 J99T2wBMqF90bi5Nn3TRyQYm9Oy6ObYRYdIxEjKXNKmmELYW4xPYrpegU8E6YqAtmRH0Z
	 CpHQeSmWGcBAdFmhUEDtSfUYTVXQQEu6vAPKwdCXhgm0IoUvDDSBYKqZJs8RFuiX4mhcT
	 a838ORyodF4yAGcgjOb47O6VmnL01o/ZjQcBhoyFZAEijp2cegD5QkaX8p7PJDGyXVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fYFReU9Yg6V5OTMMDbkm/vZvutTQHFiPIkAQojmvNIs=;
	b=4cIp+BGRaRZmcNCFCGAk4zy0WaDLitIADAuOk465mIrKV/nLnO7tAz2OjVdCj6PQzWUL
	 DmgQlD5IoPw2B8EpmRE19HtYPtHiOguc2ok2BAa8ZakeAUWmW9aof4dncuRcObaIuEXbA
	 T8/cBRrALs1ZDhoYqiYCe9r5Dzje8MJJcElBT5t7L01WohfDnfX3+H3t7wtlF/Uy9YgH2
	 4putmY7h2BOV632q5Zx647Uv+q4UGBHlJRPLhORIWMj+BuTKkoTVloIeHKpVixXeJTLnt
	 zw6o19t30RmT9wDKSoGE5AbglznOtD5mlPVYe1fSGfti8U7qhGYmrx4QXMh/i5tizzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyCBZNzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A72606A332;
	Wed, 18 Nov 2026 21:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyCBZNzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CE41F000C4;
	Wed, 18 Nov 2026 21:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038326;
	bh=fYFReU9Yg6V5OTMMDbkm/vZvutTQHFiPIkAQojmvNIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyCBZNzIws3p0Hed16+Mzg3pxLG3Zhu/xpQREeP1jsH7jvjTY8UYyT5Ejv6ABnwkY
	 ac7xAMLcyWBDAavsbrbix+9glOdAtpkCPdqrk+dW6WgZzaPputg//z121gMV0Ifng0
	 xr+N3oZfBBWxMe/0me/DgYUr6YhF2ay08kFBV9MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1706/3318] KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded
Date: Wed, 18 Nov 2026 15:38:48 +0100
Message-ID: <20261118150413.039231894@linuxfoundation.org>
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
[ sashal: adapted removal of kvm_pmu_sync_hwstate() to the existing unconditional call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7b7afea4c5363..9ff2984d203fe 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -959,30 +959,33 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
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
-			kvm_pmu_sync_hwstate(vcpu);
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
 		kvm_arm_setup_debug(vcpu);
 		kvm_arch_vcpu_ctxflush_fp(vcpu);
 
-- 
2.53.0



