Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8681D3EFD14;
	Tue, 17 Mar 2026 16:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765969; cv=none; b=rvgwukkBWXXL8przl25lHKD2U+7D3pSsIwVWg5nTiVcM6m+uGgGd0o13vnvuM+tpGHjmuBgsx7eV8JppDdSeFpKJzDbnwQTJchsIgOMuFcS0jIEYZAChRa4ChdDO950pO3CVyt3x8lVIbKLxRfNS6J6IgcfrzbgLHSLesHWJj8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765969; c=relaxed/simple;
	bh=b6j9txLksLrteUW8Vc2UYFh62eOO7F7ty38eqi4go4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/UrqUxpYmERfZhCQChwNGdP//plAoEhpfQTlUKOsmzR7vgPSzbiO07wzJhpAi2O5YWxCvAs51UHHAEna7MD6QwGOAlKD3rmuY0YMPPPZo/zB8m470Faj3PrAbf82T7gLDrYJNzJfiJxaFNBE8O6DbzqdVLav/cP8vB2ZfTtvM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=noB5ujLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="noB5ujLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067E3C4CEF7;
	Tue, 17 Mar 2026 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765969;
	bh=b6j9txLksLrteUW8Vc2UYFh62eOO7F7ty38eqi4go4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noB5ujLoHmWYFq4lFBGgN4821nNBzVRlJ3coI56yxTKZXycMJwjs8t6O6T/ImkPjZ
	 Y3d5HlU6n95yi13dvJgcodxEoeuQB1AWgj63B7k7EW4TrlONb/uDRk4VJ/MWMeEU8W
	 gGAdPFAGQI4tYyLRWqWFtBgMsQvePG5qQYZTfORc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentine Burley <valentine.burley@collabora.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.19 140/378] KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail
Date: Tue, 17 Mar 2026 17:31:37 +0100
Message-ID: <20260317163012.163591932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 6da5e537f5afe091658e846da1949d7e557d2ade upstream.

Valentine reports that their guests fail to boot correctly, losing
interrupts, and indicates that the wrong interrupt gets deactivated.

What happens here is that if the maintenance interrupt is slow enough
to kick us out of the guest, extra interrupts can be activated from
the LRs. We then exit and proceed to handle EOIcount deactivations,
picking active interrupts from the AP list. But we start from the
top of the list, potentially deactivating interrupts that were in
the LRs, while EOIcount only denotes deactivation of interrupts that
are not present in an LR.

Solve this by tracking the last interrupt that made it in the LRs,
and start the EOIcount deactivation walk *after* that interrupt.
Since this only makes sense while the vcpu is loaded, stash this
in the per-CPU host state.

Huge thanks to Valentine for doing all the detective work and
providing an initial patch.

Fixes: 3cfd59f81e0f3 ("KVM: arm64: GICv3: Handle LR overflow when EOImode==0")
Fixes: 281c6c06e2a7b ("KVM: arm64: GICv2: Handle LR overflow when EOImode==0")
Reported-by: Valentine Burley <valentine.burley@collabora.com>
Tested-by: Valentine Burley <valentine.burley@collabora.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20260307115955.369455-1-valentine.burley@collabora.com
Link: https://patch.msgid.link/20260307191151.3781182-1-maz@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    3 +++
 arch/arm64/kvm/vgic/vgic-v2.c     |    4 ++--
 arch/arm64/kvm/vgic/vgic-v3.c     |   12 ++++++------
 arch/arm64/kvm/vgic/vgic.c        |    6 ++++++
 4 files changed, 17 insertions(+), 8 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -760,6 +760,9 @@ struct kvm_host_data {
 	/* Number of debug breakpoints/watchpoints for this CPU (minus 1) */
 	unsigned int debug_brps;
 	unsigned int debug_wrps;
+
+	/* Last vgic_irq part of the AP list recorded in an LR */
+	struct vgic_irq *last_lr_irq;
 };
 
 struct kvm_host_psci_config {
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -115,7 +115,7 @@ void vgic_v2_fold_lr_state(struct kvm_vc
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v2_cpu_if *cpuif = &vgic_cpu->vgic_v2;
 	u32 eoicount = FIELD_GET(GICH_HCR_EOICOUNT, cpuif->vgic_hcr);
-	struct vgic_irq *irq;
+	struct vgic_irq *irq = *host_data_ptr(last_lr_irq);
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
@@ -123,7 +123,7 @@ void vgic_v2_fold_lr_state(struct kvm_vc
 		vgic_v2_fold_lr(vcpu, cpuif->vgic_lr[lr]);
 
 	/* See the GICv3 equivalent for the EOIcount handling rationale */
-	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+	list_for_each_entry_continue(irq, &vgic_cpu->ap_list_head, ap_list) {
 		u32 lr;
 
 		if (!eoicount) {
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -148,7 +148,7 @@ void vgic_v3_fold_lr_state(struct kvm_vc
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
 	u32 eoicount = FIELD_GET(ICH_HCR_EL2_EOIcount, cpuif->vgic_hcr);
-	struct vgic_irq *irq;
+	struct vgic_irq *irq = *host_data_ptr(last_lr_irq);
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
@@ -158,12 +158,12 @@ void vgic_v3_fold_lr_state(struct kvm_vc
 	/*
 	 * EOIMode=0: use EOIcount to emulate deactivation. We are
 	 * guaranteed to deactivate in reverse order of the activation, so
-	 * just pick one active interrupt after the other in the ap_list,
-	 * and replay the deactivation as if the CPU was doing it. We also
-	 * rely on priority drop to have taken place, and the list to be
-	 * sorted by priority.
+	 * just pick one active interrupt after the other in the tail part
+	 * of the ap_list, past the LRs, and replay the deactivation as if
+	 * the CPU was doing it. We also rely on priority drop to have taken
+	 * place, and the list to be sorted by priority.
 	 */
-	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+	list_for_each_entry_continue(irq, &vgic_cpu->ap_list_head, ap_list) {
 		u64 lr;
 
 		/*
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -814,6 +814,9 @@ retry:
 
 static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
 {
+	if (!*host_data_ptr(last_lr_irq))
+		return;
+
 	if (kvm_vgic_global_state.type == VGIC_V2)
 		vgic_v2_fold_lr_state(vcpu);
 	else
@@ -960,10 +963,13 @@ static void vgic_flush_lr_state(struct k
 	if (irqs_outside_lrs(&als))
 		vgic_sort_ap_list(vcpu);
 
+	*host_data_ptr(last_lr_irq) = NULL;
+
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		scoped_guard(raw_spinlock,  &irq->irq_lock) {
 			if (likely(vgic_target_oracle(irq) == vcpu)) {
 				vgic_populate_lr(vcpu, irq, count++);
+				*host_data_ptr(last_lr_irq) = irq;
 			}
 		}
 


