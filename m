Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063C022F767;
	Sat, 17 Oct 2026 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254512; cv=none; b=Ek1W/cG587zOfAVpXuCR0z+HbI/vGg5g3LtafDpEFrbgA+wwydfiD+AON/JW9Xzc5LOIMRBqyI7u+244zEMnvgo2BUtBU0pIVtCmATzVCWcO4RRHEAvz6e2rozmBDApUXz41aqXlS1U/Ze0fibR+597wmSa9AcrU2BQQ3Zh8kgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254512; c=relaxed/simple;
	bh=P+tNR0mwVcSPLTSj05d5RzexAvf70GGBgAvZlxpAfAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLKnRa7s5z+zTJJFBEk0SC3tVWWJfQqGuebLNUFnm2bcMgYzu/DFaGLHMLPFfb8jGFi8nsw1Gg05qGMIonFCs7kU6gvDlPVBDeKzCGnFHeKX3kKfvMTjz/NI8N4orgGDgqTrQJQu7AQSXuQD/q6LEIL2+VVFaUo+Gjh1YDr49ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qner6ZiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qner6ZiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D4D1F000C4;
	Sat, 17 Oct 2026 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254510;
	bh=Pk38Yw873Mntv9wUbeFl/aD6OGzmDwIP36Klw4XAVSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qner6ZiEdXyqQ+mqA051XS6Z0VwktNeHqSL+IXRhndbkWPetMz2f34TwocBAF5nNm
	 mrwcwmEBGoC3Q/hySIJYqoDYySKmM6JnWtDv9iWfq1qAPzyeHbOL2wh/jWCu7LMs/I
	 nd8UMi++y3daCj+7YfItecQvawnY4+upEUps7oos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 431/869] KVM: arm64: vgic: Handle race between interrupt affinity change and LPI disabling
Date: Sat, 17 Oct 2026 17:54:32 +0200
Message-ID: <20261017160048.192944692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 497b7af5caa4d..967d8111642cf 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -144,6 +144,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		if (irq->intid >= VGIC_MIN_LPI) {
 			raw_spin_lock(&irq->irq_lock);
+			irq->pending_latch = false;
 			list_del(&irq->ap_list);
 			irq->vcpu = NULL;
 			raw_spin_unlock(&irq->irq_lock);
@@ -661,7 +662,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
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
@@ -706,6 +711,8 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		raw_spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
 		raw_spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
 
+		vgic_put_irq(vcpu->kvm, irq);
+
 		if (target_vcpu_needs_kick) {
 			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
 			kvm_vcpu_kick(target_vcpu);
-- 
2.53.0



