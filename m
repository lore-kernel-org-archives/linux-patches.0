Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062397;
	b=DOVWmGugHY1m3iVIKeWknVdwKpotsKWxb2xwj0GBa69gVs0ywJUJYRbuLBKlI2/VeE6X
	 /1MUKKm9Z0sygFuCuZOYkPkOpZMhXwC8JhJODDQ+Pmm97979jze0S/wfiNcRtvtlqm9Zg
	 QnDnr5eCsxv1CswUitWxcFhEqR7N1dI/E8daUpc/LCJ8mdWHkYb5PhESY12ndvI4nBr9P
	 vQOfiAghd2OqjkCLeCNEjGgck9xEcIz0FphtUbfkltm5tZuitv4OemluWSLG/3Dih2vrZ
	 F+OwqMKiZTtN8I31wv17lnQl7rtkZLWr67fJTNLI0R8CE6+0fLpUYdoAAvZ6/0QsQCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VJpBJx3inbehIpHedndAr4/rSosJfXu09M50Yfzg6nU=;
	b=FXh1R1egeZWAJ1VgU21RRnqPyJ146a1ZsogoSX9pNoGQ44isReSmPKeU92/DIn9/tlpI
	 htZPgZT95tH+kfGojtafXc1KNrnuLyJ+bfKL8WmfcKKuxeAPF9FD7/U44nKagJDoj6zwS
	 bzMH15y3713BDjy2Ed+O9vfl4hKJvFLlALqYeucu0gnG5QEZmubNWJ/PWrX2BAfHKcAtX
	 heNownoJqFL9XZytRJybYUYemN2DPyihAUdmLWm5L0aGuZ6A9ZgwqqdV2srW2qLKyr0tE
	 tMmAixb5Gjh4jdHvxU9byee2t37AFsiVsJN68Qm07pAr0kAoF3N2dt6SyNkTCxVk3nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXXJ7M6K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC43608362A;
	Sat,  7 Nov 2026 14:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXXJ7M6K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FDD1F0089F;
	Sat,  7 Nov 2026 14:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062396;
	bh=VJpBJx3inbehIpHedndAr4/rSosJfXu09M50Yfzg6nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXXJ7M6KBlcCWCR3p4pFVkyTVOKQZVxZSHnhfOh1svMg0aK3lyDC36chn53CiuVW+
	 sOYkoIG7D4sFW3TL2AYuozQrZ6+FSfVxxsuiXUcESglTc+SukLXFghJjS5FSmZO8aw
	 ROAs6Nkk0LVhrAgNzWQXsSxFqhg0abw2jEXRbpe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1314/1536] KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being saved
Date: Sat,  7 Nov 2026 08:55:30 -0500
Message-ID: <20261107135034.708285622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2a156ddf0c314..818a742f90ad0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1199,12 +1199,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
@@ -1221,7 +1221,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 		/*
 		 * Back from guest
@@ -1253,6 +1252,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
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



