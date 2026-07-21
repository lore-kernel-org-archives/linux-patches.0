Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD873404BC7;
	Tue, 21 Jul 2026 18:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658400; cv=none; b=aEPbisw2k/2Xm8sbjL2A8ehYlZ5Efahv4y+G4waTbM3Ohjhc65xCHokNARJhS2H5YcaOe4iI+A2FWs0cCrNT1b+DWvLzmBdQGkvRdqXKaDSTYnDNRGl+eO3aOssLE5uEncA0RbX07lf2NvD+wsFAnKsnNkMkntz+fhDnQOntnB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658400; c=relaxed/simple;
	bh=eal7aELtSUJmyh02uKk93SQiaPKZUed7WLMCfJ+JP58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czIg3A5lJsxW6tMiOEi8f9XhyB3oHeVkCpIEb/2jFoRYxGiP0EGCPbwkS6cRQyrY8wvdzxrJvwH4SDOQrrDTIcWClcA51bAbFi2Q9889LdZnKGQBJ6kjt6gvSqG0t4hWQ8RLYTy7QkXTEj2/dMRLeOpOfIPTGT8ePPakQquDKYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVkCF/1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVkCF/1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FE31F000E9;
	Tue, 21 Jul 2026 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658399;
	bh=PPlS//thHTdmN+wVOJApTP3OTVq3Uqok1dnmdyEGy6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVkCF/1ftNWnrFu1cntBMMYCOWBuC4HXSfkmRoGPOMkdi4Iuk2mYfirOg1UysRtqN
	 VbD5gSFFCWFH+i9fatykbPVNYkbTN84QTV1dihwlevjm4QymE1Mx+0MCuPND4UhUhD
	 o9+etHJt+ZBlc7ydScnNBUS1BTCCytpHCRNQGmzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1130/1611] KVM: arm64: vgic: Check the interrupt is still ours before migrating it
Date: Tue, 21 Jul 2026 17:20:46 +0200
Message-ID: <20260721152540.840082281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 0074b82cdfcb5fd13710a0ac308ade68ac6f6fbe upstream.

vgic_prune_ap_list() drops both ap_list_lock and irq_lock while migrating
an interrupt to another vCPU. After reacquiring the locks it only checks
that the affinity is unchanged (target_vcpu == vgic_target_oracle(irq))
before moving the interrupt, which assumes that an interrupt whose affinity
is preserved is still queued on this vCPU's ap_list.

That assumption no longer holds if the interrupt is taken off the ap_list
while the locks are dropped. vgic_flush_pending_lpis() removes the
interrupt from the list and sets irq->vcpu to NULL, but leaves
enabled/pending/target_vcpu untouched. As the interrupt is still enabled
and pending, vgic_target_oracle() returns the same target_vcpu, so the
affinity check passes and list_del() is run a second time on an entry that
has already been removed.

Also check that the interrupt is still assigned to this vCPU
(irq->vcpu == vcpu) before moving it.

Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://patch.msgid.link/aiHnI1mu6SGQrgnz@v4bel
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -735,15 +735,16 @@ retry:
 		raw_spin_lock(&irq->irq_lock);
 
 		/*
-		 * If the affinity has been preserved, move the
-		 * interrupt around. Otherwise, it means things have
-		 * changed while the interrupt was unlocked, and we
-		 * need to replay this.
+		 * If the interrupt is still ours and its affinity has
+		 * been preserved, move it around. Otherwise, it means
+		 * things have changed while the interrupt was unlocked
+		 * (it may even have been taken off the list with its
+		 * affinity left untouched), and we need to replay this.
 		 *
 		 * In all cases, we cannot trust the list not to have
 		 * changed, so we restart from the beginning.
 		 */
-		if (target_vcpu == vgic_target_oracle(irq)) {
+		if (irq->vcpu == vcpu && target_vcpu == vgic_target_oracle(irq)) {
 			struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
 
 			list_del(&irq->ap_list);


