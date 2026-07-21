Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5B033689F;
	Tue, 21 Jul 2026 17:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654064; cv=none; b=jsFTxpevmT8FSVcDx483oO1URBRgJTBHy2JkXvM43bHLQCAvKdzouJw9Y7ZALwLtcpXdqLOFqkCyUKrfatzD/C5V8yS3z387zVESeDAvLv3rckk5fQ36YOZEBQOtvVe8OpNeY/+woL0oFX7pdOjxKSRuclpyQF8aewBuonMG4FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654064; c=relaxed/simple;
	bh=rQSeXma7RpCM8C+xd07AxnxWMJeBGAtRk8GXUbbmZh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx3++lAR8KnHsSKHnRbxKyLFAY7RAk933ORdykmnyJGVCOChH5x+cgXdUX8/+GeblsKsM+THNQSg/jeYBPHGafUzm+iJSEw9VHnm12fdj07PyVIwlk6ZZ3CkQWc/Ic6vift4//T6N53MhFPenraFYyI/jIa9ujsXbcGEZ5tNJaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/OPDaqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/OPDaqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5601F000E9;
	Tue, 21 Jul 2026 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654062;
	bh=rG8C19AMVpNDCF5grQoEFDXIOY6NNIpmDvQnyT9FTjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/OPDaqwiFjMDMHEkh+bg/zphlvPyN8iOe7Xk3Zn+E3oO1RSaBtAIEX2OM38WQgWp
	 3PVHO1qpT1N5sh9UKXRaGf8liB5iwl9JHSCSx1VYnJPsATRFRc/u5R0+xYMzCDgGp/
	 tYxCW68RYNmhMM1Ape2wNm/BlpbgG3wBkP44H8kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 1561/2077] KVM: arm64: vgic: Handle race between interrupt affinity change and LPI disabling
Date: Tue, 21 Jul 2026 17:20:34 +0200
Message-ID: <20260721152629.600317139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 7258770e5814f15e8308ebda82ac9acf6964ba8e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -204,6 +204,7 @@ void vgic_flush_pending_lpis(struct kvm_
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
+			irq->pending_latch = false;
 			list_del(&irq->ap_list);
 			irq->vcpu = NULL;
 			raw_spin_unlock(&irq->irq_lock);
@@ -795,7 +796,11 @@ retry:
 			continue;
 		}
 
-		/* This interrupt looks like it has to be migrated. */
+		/*
+		 * This interrupt looks like it has to be migrated,
+		 * make sure it is kept alive while locks are dropped.
+		 */
+		vgic_get_irq_ref(irq);
 
 		raw_spin_unlock(&irq->irq_lock);
 		raw_spin_unlock(&vgic_cpu->ap_list_lock);
@@ -840,6 +845,8 @@ retry:
 		raw_spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
 		raw_spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
 
+		deleted_lpis |= vgic_put_irq_norelease(vcpu->kvm, irq);
+
 		if (target_vcpu_needs_kick) {
 			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
 			kvm_vcpu_kick(target_vcpu);


