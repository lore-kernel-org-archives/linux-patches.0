Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2E6213E6B;
	Thu, 12 Dec 2024 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023455; cv=none; b=VVv9jBXwcAh9hUczHDy/L/cA48e3nSWO0+FG7jJcTgqJ1CRFHS5pkfgIopYQexR2hPSO81eL/Rk+YFqtYyh7ALCRAg0ce8wDo34GaruI/7BIB1cY/g3dt9R3+E7vHR1tU5iMWnHFy5SYH9MGGe8FSNYZRd17/osK5lO6YMurM74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023455; c=relaxed/simple;
	bh=sS7t9bAMctXufkxgYmEilDyU1bfupAYji+pYt7PUynY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmQID6pL3ymJ0Yz3vUOsCckB/VcDySzpOX2VF+pkv4ln1bO/Tk9xxrixoCnR3W8vbGxIOISY9zc8wiXotllX0A9V+eBYJjQLsilEdtj2DznIvWad7qT+kPq176/qf6Z+3+gh5700WMd1clTl+A95gXx7ciCD+vpSRuNv5QckWNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/lD6S8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/lD6S8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9118C4CED3;
	Thu, 12 Dec 2024 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023455;
	bh=sS7t9bAMctXufkxgYmEilDyU1bfupAYji+pYt7PUynY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/lD6S8fHiH3LSecY8KwPja4IUpjJuGR/MYmy9bJCibDhBiHwQBoaFnNIATi7RDlM
	 sxEcOKgZUB4Y0c+7/LK+clIUjYT4t/s66pptu2XDzgyCRjtkexSpwHXbsYc1Iz6DDK
	 bgOHdepiVpfvWDqi4cGP3Xuii/teYaUU/8+m1cjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5.15 539/565] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
Date: Thu, 12 Dec 2024 16:02:14 +0100
Message-ID: <20241212144333.155650227@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jing Zhang <jingzhangos@google.com>

commit 7fe28d7e68f92cc3d0668b8f2fbdf5c303ac3022 upstream.

In all the vgic_its_save_*() functinos, they do not check whether
the data length is 8 bytes before calling vgic_write_guest_lock.
This patch adds the check. To prevent the kernel from being blown up
when the fault occurs, KVM_BUG_ON() is used. And the other BUG_ON()s
are replaced together.

Cc: stable@vger.kernel.org
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[Jing: Update with the new entry read/write helpers]
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Link: https://lore.kernel.org/r/20241107214137.428439-4-jingzhangos@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |   20 ++++++++------------
 arch/arm64/kvm/vgic/vgic.h     |   24 ++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 12 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2135,7 +2135,6 @@ static int scan_its_table(struct vgic_it
 static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 			      struct its_ite *ite, gpa_t gpa, int ite_esz)
 {
-	struct kvm *kvm = its->dev->kvm;
 	u32 next_offset;
 	u64 val;
 
@@ -2144,7 +2143,8 @@ static int vgic_its_save_ite(struct vgic
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
-	return kvm_write_guest_lock(kvm, gpa, &val, ite_esz);
+
+	return vgic_its_write_entry_lock(its, gpa, val, ite_esz);
 }
 
 /**
@@ -2280,7 +2280,6 @@ static int vgic_its_restore_itt(struct v
 static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 			     gpa_t ptr, int dte_esz)
 {
-	struct kvm *kvm = its->dev->kvm;
 	u64 val, itt_addr_field;
 	u32 next_offset;
 
@@ -2291,7 +2290,8 @@ static int vgic_its_save_dte(struct vgic
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
-	return kvm_write_guest_lock(kvm, ptr, &val, dte_esz);
+
+	return vgic_its_write_entry_lock(its, ptr, val, dte_esz);
 }
 
 /**
@@ -2471,7 +2471,8 @@ static int vgic_its_save_cte(struct vgic
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
-	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
+
+	return vgic_its_write_entry_lock(its, gpa, val, esz);
 }
 
 static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
@@ -2482,8 +2483,7 @@ static int vgic_its_restore_cte(struct v
 	u64 val;
 	int ret;
 
-	BUG_ON(esz > sizeof(val));
-	ret = kvm_read_guest_lock(kvm, gpa, &val, esz);
+	ret = vgic_its_read_entry_lock(its, gpa, &val, esz);
 	if (ret)
 		return ret;
 	val = le64_to_cpu(val);
@@ -2517,7 +2517,6 @@ static int vgic_its_save_collection_tabl
 	u64 baser = its->baser_coll_table;
 	gpa_t gpa = GITS_BASER_ADDR_48_to_52(baser);
 	struct its_collection *collection;
-	u64 val;
 	size_t max_size, filled = 0;
 	int ret, cte_esz = abi->cte_esz;
 
@@ -2541,10 +2540,7 @@ static int vgic_its_save_collection_tabl
 	 * table is not fully filled, add a last dummy element
 	 * with valid bit unset
 	 */
-	val = 0;
-	BUG_ON(cte_esz > sizeof(val));
-	ret = kvm_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
-	return ret;
+	return vgic_its_write_entry_lock(its, gpa, 0, cte_esz);
 }
 
 /**
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -6,6 +6,7 @@
 #define __KVM_ARM_VGIC_NEW_H__
 
 #include <linux/irqchip/arm-gic-common.h>
+#include <asm/kvm_mmu.h>
 
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
@@ -126,6 +127,29 @@ static inline bool vgic_irq_is_multi_sgi
 	return vgic_irq_get_lr_count(irq) > 1;
 }
 
+static inline int vgic_its_read_entry_lock(struct vgic_its *its, gpa_t eaddr,
+					   u64 *eval, unsigned long esize)
+{
+	struct kvm *kvm = its->dev->kvm;
+
+	if (KVM_BUG_ON(esize != sizeof(*eval), kvm))
+		return -EINVAL;
+
+	return kvm_read_guest_lock(kvm, eaddr, eval, esize);
+
+}
+
+static inline int vgic_its_write_entry_lock(struct vgic_its *its, gpa_t eaddr,
+					    u64 eval, unsigned long esize)
+{
+	struct kvm *kvm = its->dev->kvm;
+
+	if (KVM_BUG_ON(esize != sizeof(eval), kvm))
+		return -EINVAL;
+
+	return kvm_write_guest_lock(kvm, eaddr, &eval, esize);
+}
+
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC


