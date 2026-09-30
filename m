Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D02397E89;
	Wed, 30 Sep 2026 19:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796605; cv=none; b=nR5JI4fFQncTm1Hkw6X2dA7pwMAzu1Txb2tRjL8TH9cDRfoZ+MpYKdhITo9u2Js359zrFTusqWdrqnKgLOJtFxTuxp7gWrgrlqHqWbwlDQglZfTw57Bl4aKSpJyESe0VeEVcn2sPwrSgL+ZzSLqhXDpbsxTBEVlvNyet9p+viMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796605; c=relaxed/simple;
	bh=65ryl8bo6H7jobM4KO8SoenN11crjfbQ0U1a28RTJoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBaJ+uH/aMVM1i0EMig38iCP8kD/fNrRVN3f1XojFHONTV+77SEETc1OzJIu5f2q61J6vg5omDdmGh6S6jma1YaFESVngZqIvdTdGIqN+hEFJvMv7ciYjinupgzeorhhVwS54yGbQoqdoTwWyu4wOwX4vPmgU4FtK/NgYqNaN5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmZMh2VH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmZMh2VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163DF1F000FF;
	Wed, 30 Sep 2026 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796604;
	bh=XzddCGFpdbzrTgCvficEVBLOakyXbkaDu4cIjBqtXYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmZMh2VHBnNeK+0lKdJOP1nDZmL+a3VUVPkGkX26e6p5/AtiGiRzYHHUZ1toO6s2c
	 86ClftlHS3MO0ee5MpwPa5VOB9b0RHih6nVr9DmQIdtt7ZYtf39loo9crrmec73TLk
	 StUL92xbGxZ8uTBvbKrBTH+g/fBvN0ss9bifu56Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0972/1193] KVM: arm64: vgic-its: Add stronger type-checking to the ITS entry sizes
Date: Wed, 30 Sep 2026 17:27:36 +0200
Message-ID: <20260930152455.841145129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 3b2c81d5feb250dfdcb0ef5825319f36c29f8336 ]

The ITS ABI infrastructure allows for some pretty lax code, where
the size of the data doesn't have to match the size of the entry,
potentially leading to a collection of interesting bugs.

Commit 7fe28d7e68f9 ("KVM: arm64: vgic-its: Add a data length check
in vgic_its_save_*") added some checks, but starts by implicitly
casting all writes to a 64bit value, hiding some of the issues.

Instead, introduce macros that will check the data type actually used
for dealing with the table entries. The macros are taking a symbolic
entry type that is used to fetch the size of the entry type for the
current ABI. This immediately catches a couple of low-impact gotchas
(zero values that are implicitly 32bit), easy enough to fix.

Given that we currently only have a single ABI, hardcode a couple of
BUILD_BUG_ON()s that will fire if we use anything but a 64bit quantity,
and some (currently unreachable) fallback code that may become useful
one day.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241117165757.247686-5-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Stable-dep-of: cc5d96036e01 ("KVM: arm64: vgic-its: Skip unreachable devices instead of failing the save")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 68 +++++++++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic.h     | 23 ------------
 2 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index c8d180b80abdf..b938aa88d6dfc 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -29,6 +29,41 @@ static int vgic_its_commit_v0(struct vgic_its *its);
 static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
 
+#define vgic_its_read_entry_lock(i, g, valp, t)				\
+	({								\
+		int __sz = vgic_its_get_abi(i)->t##_esz;		\
+		struct kvm *__k = (i)->dev->kvm;			\
+		int __ret;						\
+									\
+		BUILD_BUG_ON(NR_ITS_ABIS == 1 &&			\
+			     sizeof(*(valp)) != ABI_0_ESZ);		\
+		if (NR_ITS_ABIS > 1 &&					\
+		    KVM_BUG_ON(__sz != sizeof(*(valp)), __k))		\
+			__ret = -EINVAL;				\
+		else							\
+			__ret = kvm_read_guest_lock(__k, (g),		\
+						    valp, __sz);	\
+		__ret;							\
+	})
+
+#define vgic_its_write_entry_lock(i, g, val, t)				\
+	({								\
+		int __sz = vgic_its_get_abi(i)->t##_esz;		\
+		struct kvm *__k = (i)->dev->kvm;			\
+		typeof(val) __v = (val);				\
+		int __ret;						\
+									\
+		BUILD_BUG_ON(NR_ITS_ABIS == 1 &&			\
+			     sizeof(__v) != ABI_0_ESZ);			\
+		if (NR_ITS_ABIS > 1 &&					\
+		    KVM_BUG_ON(__sz != sizeof(__v), __k))		\
+			__ret = -EINVAL;				\
+		else							\
+			__ret = vgic_write_guest_lock(__k, (g),		\
+						      &__v, __sz);	\
+		__ret;							\
+	})
+
 /*
  * Creates a new (reference to a) struct vgic_irq for a given LPI.
  * If this LPI is already mapped on another ITS, we increase its refcount
@@ -869,7 +904,7 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 
 		its_free_ite(kvm, ite);
 
-		return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
+		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
 	}
 
 	return E_ITS_DISCARD_UNMAPPED_INTERRUPT;
@@ -1217,7 +1252,6 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	bool valid = its_cmd_get_validbit(its_cmd);
 	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
-	int dte_esz = vgic_its_get_abi(its)->dte_esz;
 	struct its_device *device;
 	gpa_t gpa;
 
@@ -1242,7 +1276,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * is an error, so we are done in any case.
 	 */
 	if (!valid)
-		return vgic_its_write_entry_lock(its, gpa, 0, dte_esz);
+		return vgic_its_write_entry_lock(its, gpa, 0ULL, dte);
 
 	device = vgic_its_alloc_device(its, device_id, itt_addr,
 				       num_eventid_bits);
@@ -2213,7 +2247,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
  * vgic_its_save_ite - Save an interrupt translation entry at @gpa
  */
 static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
-			      struct its_ite *ite, gpa_t gpa, int ite_esz)
+			      struct its_ite *ite, gpa_t gpa)
 {
 	u32 next_offset;
 	u64 val;
@@ -2224,7 +2258,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
 
-	return vgic_its_write_entry_lock(its, gpa, val, ite_esz);
+	return vgic_its_write_entry_lock(its, gpa, val, ite);
 }
 
 /**
@@ -2322,7 +2356,7 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 		if (ite->irq->hw && !kvm_vgic_global_state.has_gicv4_1)
 			return -EACCES;
 
-		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
+		ret = vgic_its_save_ite(its, device, ite, gpa);
 		if (ret)
 			return ret;
 	}
@@ -2363,7 +2397,7 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
  * @ptr: GPA
  */
 static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
-			     gpa_t ptr, int dte_esz)
+			     gpa_t ptr)
 {
 	u64 val, itt_addr_field;
 	u32 next_offset;
@@ -2376,7 +2410,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
 
-	return vgic_its_write_entry_lock(its, ptr, val, dte_esz);
+	return vgic_its_write_entry_lock(its, ptr, val, dte);
 }
 
 /**
@@ -2456,10 +2490,8 @@ static int vgic_its_device_cmp(void *priv, const struct list_head *a,
  */
 static int vgic_its_save_device_tables(struct vgic_its *its)
 {
-	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	u64 baser = its->baser_device_table;
 	struct its_device *dev;
-	int dte_esz = abi->dte_esz;
 
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
@@ -2478,7 +2510,7 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
 		if (ret)
 			return ret;
 
-		ret = vgic_its_save_dte(its, dev, eaddr, dte_esz);
+		ret = vgic_its_save_dte(its, dev, eaddr);
 		if (ret)
 			return ret;
 	}
@@ -2559,7 +2591,7 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 
 static int vgic_its_save_cte(struct vgic_its *its,
 			     struct its_collection *collection,
-			     gpa_t gpa, int esz)
+			     gpa_t gpa)
 {
 	u64 val;
 
@@ -2568,7 +2600,7 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	       collection->collection_id);
 	val = cpu_to_le64(val);
 
-	return vgic_its_write_entry_lock(its, gpa, val, esz);
+	return vgic_its_write_entry_lock(its, gpa, val, cte);
 }
 
 /*
@@ -2576,7 +2608,7 @@ static int vgic_its_save_cte(struct vgic_its *its,
  * Return +1 on success, 0 if the entry was invalid (which should be
  * interpreted as end-of-table), and a negative error value for generic errors.
  */
-static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
+static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa)
 {
 	struct its_collection *collection;
 	struct kvm *kvm = its->dev->kvm;
@@ -2584,7 +2616,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	u64 val;
 	int ret;
 
-	ret = vgic_its_read_entry_lock(its, gpa, &val, esz);
+	ret = vgic_its_read_entry_lock(its, gpa, &val, cte);
 	if (ret)
 		return ret;
 	val = le64_to_cpu(val);
@@ -2631,7 +2663,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
 	list_for_each_entry(collection, &its->collection_list, coll_list) {
-		ret = vgic_its_save_cte(its, collection, gpa, cte_esz);
+		ret = vgic_its_save_cte(its, collection, gpa);
 		if (ret)
 			return ret;
 		gpa += cte_esz;
@@ -2645,7 +2677,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	 * table is not fully filled, add a last dummy element
 	 * with valid bit unset
 	 */
-	return vgic_its_write_entry_lock(its, gpa, 0, cte_esz);
+	return vgic_its_write_entry_lock(its, gpa, 0ULL, cte);
 }
 
 /**
@@ -2670,7 +2702,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
 	while (read < max_size) {
-		ret = vgic_its_restore_cte(its, gpa, cte_esz);
+		ret = vgic_its_restore_cte(its, gpa);
 		if (ret <= 0)
 			break;
 		gpa += cte_esz;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 3fa68827dc89f..07e48f8a4f23b 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -145,29 +145,6 @@ static inline int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
 	return ret;
 }
 
-static inline int vgic_its_read_entry_lock(struct vgic_its *its, gpa_t eaddr,
-					   u64 *eval, unsigned long esize)
-{
-	struct kvm *kvm = its->dev->kvm;
-
-	if (KVM_BUG_ON(esize != sizeof(*eval), kvm))
-		return -EINVAL;
-
-	return kvm_read_guest_lock(kvm, eaddr, eval, esize);
-
-}
-
-static inline int vgic_its_write_entry_lock(struct vgic_its *its, gpa_t eaddr,
-					    u64 eval, unsigned long esize)
-{
-	struct kvm *kvm = its->dev->kvm;
-
-	if (KVM_BUG_ON(esize != sizeof(eval), kvm))
-		return -EINVAL;
-
-	return vgic_write_guest_lock(kvm, eaddr, &eval, esize);
-}
-
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
-- 
2.53.0



