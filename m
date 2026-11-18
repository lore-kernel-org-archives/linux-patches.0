Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036624;
	b=nq/MkIJQxRHgomrXqlUheP3qOVnqJ8kjBU1UlB6ZBW6QycII21+yZRuMWy5x/fZoMZta
	 M+CiH0JkGg6cCIF6f80tk+SpBm3Xk+A4ec0sugD0qw1553W0RD4dXa+wzK+7FZZDAWljq
	 75CKsqC9bV0AXFA9j/jRcTZn+btdl4fU6+R8TvLcbpmMjUUdUCoOjg2itOKwTwSafvmwE
	 bbI00WMVEouX/FfYe1Man4wbJVx4h9NHKKyBK/9PTl+b0TnvtEJPHfdhPF80kr8rLWVpV
	 D4t5Pebk2NUjTesClWs0BDWpSa0s+Oc/f6E5BiLUnHHzXwSSR1lBlDHjgENKASUindA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZeFHCacruk5c+ERU8owhXB9dSU0NFUwaj69dyZiEfFc=;
	b=DXAF/R28DkgDtrD0wktNBMD+mVVuderR3t2YE8X243p5gdoPWQ3G1dugESEH4d9d+pZp
	 QZlvBbpxksGImk8cTTM9UysJMgvvejvRiVlA5xgVN6sxTbbY48ei58T6ZKK1+Alfr5rJ7
	 WEtR6xY4fs8E6qVO47koTdtDN3i9Y+Ph2F/bE2DFcwF7FgTPduU++ufHEnfTlGIGx6t48
	 051/6ITnyq0j9R4puy9pEjKofK5uap2365vcc7S5zj5BCZxJlR8PdqGHzDwovkzEcGAck
	 g6nX6M8CZYQuLOxGnbs6g5tktf7XQJ36ZGxVQdJ4QV4ZiOhGmnUihUTJCdIBDXXNuDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qAOqPA7N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F49606A31C;
	Wed, 18 Nov 2026 21:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qAOqPA7N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D891D1F000C4;
	Wed, 18 Nov 2026 21:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036624;
	bh=ZeFHCacruk5c+ERU8owhXB9dSU0NFUwaj69dyZiEfFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAOqPA7NOTeRMapGSzoJOkFCb5A7FvquLXknSuEMEYsX8O+KgQKI8eGzNRsLu+Oax
	 tY1HbjFLDdQ7C3TUGgcH56aybfJflLRXHCCJTeraCE1s2jZ9oxlrYLsKhLFWQbkXjE
	 55N9mg2SlyCU64pX4PnlPFVfun+0a1bnUVyNPQAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1126/3318] KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being saved
Date: Wed, 18 Nov 2026 15:29:08 +0100
Message-ID: <20261118150353.818436132@linuxfoundation.org>
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

[ Upstream commit 1d4ce2901f1e25b06d447c0b02d105d6dd3550d8 ]

OUTSIDE_GUEST_MODE indicates to the rest of KVM that the vcpu has
exited. So far, this is set as soon as we return from the notional
hypervisor (which with VHE is just a function call away).

However, code that uses OUTSIDE_GUEST_MODE as a synchronisation point
relies on the vcpu state to have been written back to the in-memory
structures. Clearly, this is not what is happening.

Move the publication of OUTSIDE_GUEST_MODE to the point where the state
is actually written, and give this write release semantics to ensure the
correct ordering.

Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-3-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 37a6545238187..7ff28efd4bd55 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -969,12 +969,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
 			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
+			smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			preempt_enable();
 			continue;
@@ -991,7 +991,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 		/*
 		 * Back from guest
@@ -1023,6 +1022,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
 
+		/*
+		 * The state that was pushed into the CPU on entering
+		 * the guest has been synchronised back, let's
+		 * advertise we're outside of the guest.
+		 */
+		smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
+
 		/*
 		 * We must ensure that any pending interrupts are taken before
 		 * we exit guest timing so that timer ticks are accounted as
-- 
2.53.0



