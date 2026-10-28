Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216302;
	b=AtmrUARYH6E7SWAQCenoTv6oKszyjqw+MSIk0pQehUGWcnEd53puE7rZqDDV7VGvOAxE
	 QRPavtYHJ8VU2++jiha94QI0jetF3PpCiKe/Uf9inkuWo9F5u1/eqyPe58ubljZESZoej
	 ZOVsAWQG58Lqy4eYU5+u43JmsT8W2cwayH7FDtRGDVxcY+nhBFJKrth774dKrCdT7Yiss
	 C7Ps+zP8xmejON6TlxQmP2j+Elwrppsl2n6u3DEhJ1oSGyme9izId5Hn1rnW5L/I22FGX
	 i8tV67Vih3DLbprQrvQQ122QDlgagLzuGkRlRkqZ36i2C7jZFk5Y6waZdTuHwDQve3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KaF2ag/bsFj2xyMu6mqsJWWD5HDsUxeCQL23R13R0k0=;
	b=l2v+1mtwdgopwwYmaN2VPZM3Vrd/vQIZ87aCL8CdDCPLKmqF+NNpf9LUd/1QmFc3AjvI
	 1QELsUIQaMM1UqYsKGs4DDzoFUjP3MfCoxpPd5aFPcU6meyhctf3J6Fu9zA+ZxKAYuq0E
	 Ok/+H/XsHEGREcUNKSodAkb6bpwAdr2GZtTaTna3xo0o/S94TjL7/x+AyYAzZm3r8sUNc
	 o9AmKJncmIb9buMLCVwWFpLZbjdT++Lw2eLnYbH/DDWltS1yaMD3X/orgxrsRuMbYnRf0
	 Rzvff50q0FjS55enWGOVi+k9s8W5IPwzVyXyeC4CcB6tV115l7GhDc8F7I41L+KxmGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wYHvViqY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653E7606A31D;
	Wed, 28 Oct 2026 19:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wYHvViqY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F481F01825;
	Wed, 28 Oct 2026 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216302;
	bh=KaF2ag/bsFj2xyMu6mqsJWWD5HDsUxeCQL23R13R0k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wYHvViqY6bfV/ddzJsW3MIh5WE3oBj+R026RvjoAe/lUkHYsq/DmnH9TFg9af9V2T
	 uTlciqKxRZzSrS+N5k3Xm6ZyWcSe7hAxtaFt2gGBetk6VLsSMjZCsNYcAhcd9R9jze
	 R1F0kbw3rHzVp8eUhmzsaIgKhsr1KLnXvRlxKr2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1457/1887] KVM: arm64: vgic: Handle race between interrupt affinity change and LPI disabling
Date: Wed, 28 Oct 2026 17:59:13 +0100
Message-ID: <20261028170532.616814558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 7258770e5814f15e8308ebda82ac9acf6964ba8e ]

Hyunwoo Kim reports some really bad races should the following
situation occur:

- LPI-I is pending in vcpu-B's AP list
- vcpu-A writes to vcpu-B's RD to disable its LPIs
- vcpu-C moves I from B to C

If the last two race nicely enough, vgic_prune_ap_list() can drop
the irq and AP list locks, reacquire them, and in the interval
the irq has been freed. UAF follows.

The fix is two-fold:

- Before dropping the irq and ap_list locks, take a reference on
  the irq

- Do not try to handle migration of the pending bit: there is no
  expectation that this state is retained, as per the architecture

With that, we're sure that the interrupt is still around, and we
safely remove it from the AP list as it has no target at this
stage (unless another interrupt fires, but that's another story).

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Tested-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/r/ailsCnyoS82r_QRz@v4bel
Link: https://patch.msgid.link/20260615181625.3029352-1-maz@kernel.org
Fixes: 5dd4b924e390a ("KVM: arm/arm64: vgic: Add refcounting for IRQs")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 832fa90f48e81..7c49b113b1f60 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -160,6 +160,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		if (irq->intid >= VGIC_MIN_LPI) {
 			raw_spin_lock(&irq->irq_lock);
+			irq->pending_latch = false;
 			list_del(&irq->ap_list);
 			irq->vcpu = NULL;
 			raw_spin_unlock(&irq->irq_lock);
@@ -663,7 +664,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			continue;
 		}
 
-		/* This interrupt looks like it has to be migrated. */
+		/*
+		 * This interrupt looks like it has to be migrated,
+		 * make sure it is kept alive while locks are dropped.
+		 */
+		vgic_get_irq_kref(irq);
 
 		raw_spin_unlock(&irq->irq_lock);
 		raw_spin_unlock(&vgic_cpu->ap_list_lock);
@@ -708,6 +713,8 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		raw_spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
 		raw_spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
 
+		vgic_put_irq(vcpu->kvm, irq);
+
 		if (target_vcpu_needs_kick) {
 			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
 			kvm_vcpu_kick(target_vcpu);
-- 
2.53.0



