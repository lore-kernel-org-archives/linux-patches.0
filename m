Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047497;
	b=Uk+Z7SYz8e1orJm4ZdBKLv/mMl4prqV3QTKoZVzKiVuwL6LiPCaOyYGX2lNyXk29NWpJ
	 lQviRVeiV2Nnbg9RoF80hJDTnQRZ3p59U/EdoioqyNIQeP5lkUaPxN0ysOFmSRANOcdRC
	 uFpT13UdnD7AAy8wS7eNaL5pKwYDwyRt0krxzReC8hORvuFLy+JAF477x5B2fE6LOXBbq
	 kGU+FPSnG3CNCNVVGDHM6L9+MFx56t69+H4jU9ijWHHnFiTPIpNx+k/ZOH4ksW261uW14
	 nD+1ZyTwlazRThpna8Sa/e7YZu461rlLiTDuxTwJQ0dL42ltJNaYPw1JoiW/m5VG4Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sSWtFHB5SM+UVEYeekWyYHbUB9C97keTiQSM5nerwR4=;
	b=20Pknuc+810BeN5DVV/uMN200XUjIvAkJHAF5TUuCLb4bpmJecBTkVLV6oXRkACDmc5M
	 gAI2JZQPHqsTWZ3Y84l7eLVJvmTrNpa7I1FM4InRxmOxMBEDlJg7p7n7jE3PQv74jyVeY
	 nc9M58hmsxx7ZTc6nph+qojMlVZJ25BRg0oQt0VCxEsy38cf9inS8d2bx6jM77R8KVYDw
	 eMh9ZJDjCHRV69KMyy1JLacSZfhMqtvUbHK2DSJnniPk2wd+8uKefxK5hY78NIUg9i3Iq
	 qRCfjCvxV3zolm9yypDhunLSy62sCOTv2fShYXi0Ww73Tmr4+YpX4TEfodLV3rIdRCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hV3KieLH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D644D606A325;
	Thu, 19 Nov 2026 00:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hV3KieLH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3512F1F000C4;
	Thu, 19 Nov 2026 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047497;
	bh=sSWtFHB5SM+UVEYeekWyYHbUB9C97keTiQSM5nerwR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hV3KieLH4AQbj265woToE4B1mRhEjAbXH7OZV3LZixUcnY1v6R28X76iPpowl8Dwa
	 RxaUHtWXtx98FZy4E+HNiR5YvNK8Yv2b+/MjUq1Rx2V1u9YpXHZ2a3Io0sLHgxobbN
	 N2JtBA2axd7H1BwxZLndDadpAiyJqafO2BciHfIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1660/2857] KVM: arm64: vgic-its: Dont map an LPI from more than one event
Date: Wed, 18 Nov 2026 15:44:54 +0100
Message-ID: <20261118150301.098028633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit de81b28f0b83b22163d7d9a9b708d7aa912e0ef7 ]

KVM keeps one vgic_irq per LPI. A MAPTI of an LPI whose vgic_irq
already exists reuses it for the new ITE and leaves its target vCPU as
it was. Mapping one LPI from two events is UNPREDICTABLE (IHI 0069H.b,
5.2.10), but nothing stops a guest from doing it. If the first MAPTI
names a collection the guest never maps and the second a mapped one,
the LPI translates through the second event with a NULL target vCPU.

When the VMM routes an assigned device's MSI to that event on a host
with GICv4 enabled, kvm_vgic_v4_set_forwarding() takes the vPE from the
NULL target vCPU and the host oopses:

  Unable to handle kernel paging request at virtual address 0000000000001980
  [...]
  Call trace:
   its_build_vmapti_cmd (drivers/irqchip/irq-gic-v3-its.c:943) (P)
   its_irq_set_vcpu_affinity (drivers/irqchip/irq-gic-v3-its.c:1380)
   irq_set_vcpu_affinity (kernel/irq/manage.c:670)
   its_map_vlpi (drivers/irqchip/irq-gic-v4.c:326)
   kvm_vgic_v4_set_forwarding (arch/arm64/kvm/vgic/vgic-v4.c:485)
   kvm_arch_irq_bypass_add_producer (arch/arm64/kvm/arm.c:2977)
   irq_bypass_register_consumer (virt/lib/irqbypass.c:44)
   kvm_irqfd (arch/arm64/kvm/../../../virt/kvm/eventfd.c:496)
   kvm_vm_ioctl (arch/arm64/kvm/../../../virt/kvm/kvm_main.c:5270)

Track in each vgic_irq whether an ITE maps it. Drop a MAPTI of an LPI
that is already mapped, as a failed MAPTI already is. Restoring the ITS
tables keeps the first ITE it reads for each LPI and drops any later
one, so a guest saved with a double mapping still restores. Key the
check on the mapping, not on the vgic_irq. A vgic_irq outlives its ITE
while anything holds a reference to it, such as the vCPU it was last
queued on. A later MAPTI of such an LPI succeeds as before, and now
retargets it to its collection.

Fixes: 196b136498b35 ("KVM: arm/arm64: GICv4: Wire mapping/unmapping of VLPIs in VFIO irq bypass")
Suggested-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20261013081646.933312-2-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: added missing IRQ locking and hw clearing to its_free_ite() while declaring mapped as a plain bool ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 37 +++++++++++++++++++++++++++++-----
 include/kvm/arm_vgic.h         |  1 +
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 88a01ceb8ce2f..b290ccd644e7e 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -816,12 +816,18 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 /* Requires the its_lock to be held. */
 static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 {
+	struct vgic_irq *irq = ite->irq;
 	list_del(&ite->ite_list);
 
 	/* This put matches the get in vgic_add_lpi. */
-	if (ite->irq) {
-		if (ite->irq->hw)
-			WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
+	if (irq) {
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->hw)
+				WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
+
+			irq->hw = false;
+			irq->mapped = false;
+		}
 
 		vgic_put_irq(kvm, ite->irq);
 	}
@@ -829,6 +835,23 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 	kfree(ite);
 }
 
+/* Mapping one LPI from two events is UNPREDICTABLE: the first ITE keeps it. */
+static bool vgic_its_map_lpi(struct kvm *kvm, struct its_ite *ite,
+			     struct vgic_irq *irq, struct kvm_vcpu *vcpu)
+{
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+		if (!irq->mapped) {
+			irq->mapped = true;
+			irq->target_vcpu = vcpu;
+			ite->irq = irq;
+			return true;
+		}
+	}
+
+	vgic_put_irq(kvm, irq);
+	return false;
+}
+
 static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
 {
 	return (le64_to_cpu(its_cmd[word]) >> shift) & (BIT_ULL(size) - 1);
@@ -1138,13 +1161,14 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
 	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
+	if (!IS_ERR(irq) && !vgic_its_map_lpi(kvm, ite, irq, vcpu))
+		irq = ERR_PTR(-EEXIST);
 	if (IS_ERR(irq)) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
 		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
 	}
-	ite->irq = irq;
 
 	return 0;
 }
@@ -2291,7 +2315,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
 	}
-	ite->irq = irq;
+
+	/* Drop an ITE whose LPI another ITE maps, as MAPTI does. */
+	if (!vgic_its_map_lpi(kvm, ite, irq, vcpu))
+		its_free_ite(kvm, ite);
 
 	return offset;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 1d7d4cffaefc6..e0c4e70e15054 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -138,6 +138,7 @@ struct vgic_irq {
 	bool active;			/* not used for LPIs */
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
+	bool mapped;			/* LPIs: mapped by an ITE */
 	struct kref refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
-- 
2.53.0



