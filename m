Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2A1F707A;
	Tue,  3 Dec 2024 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239551; cv=none; b=XoRiBNrdQ9dv2hrdVpk4WMEvtPEtuHlf6wwujnJSSfmZ8IpcZtdUJg2NFjaTL0+6cUO+gmF2IP9BqNHe9d6L+TGLQeu8nO+5x2ayYNdd9HME2iDEk7IVBfCiLaYlxdS0rmKZWzixQpqo5Qhk0MEpT+JfvyuQlRDcro1aQU57j4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239551; c=relaxed/simple;
	bh=hOR14dDyaRi+kntwiMPv8x7e7uQww0TWIxob1N8TxC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPjsH3oEo2EyVIAGJbkNhpGFytFW83yrpA9v1xzrvevmyvwBDuJ9/XaVST3h7tusg0F0IMUjTRMIzI1rdzHLcNEhct1AnB5uvnvawe+9fv13qyECEQ8Io16uX/s8D3t3YUhErqz6nbfrycLNUmk0xMAi1N9TrSsscp1/7vbe8kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUhHXn7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUhHXn7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8011DC4CECF;
	Tue,  3 Dec 2024 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239550;
	bh=hOR14dDyaRi+kntwiMPv8x7e7uQww0TWIxob1N8TxC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUhHXn7+TYnm43A04pOGtTH20I4OXKgVocEhJS925AcLip7fzfmMtqoQRgaIr5Chb
	 OBAbS3jqGTXfvDoN0x5Qy5DtbsrF1e0GTyRhLJz7EpZqDt4+d58SUZ/djSI09W6T0h
	 D2krhJ94t7Ho1PViyY/hCNmkpHNnsL80o8Op664Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.11 653/817] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
Date: Tue,  3 Dec 2024 15:43:45 +0100
Message-ID: <20241203144021.446992621@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/kvm/vgic/vgic.h     |   23 +++++++++++++++++++++++
 2 files changed, 31 insertions(+), 12 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2090,7 +2090,6 @@ static int scan_its_table(struct vgic_it
 static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 			      struct its_ite *ite, gpa_t gpa, int ite_esz)
 {
-	struct kvm *kvm = its->dev->kvm;
 	u32 next_offset;
 	u64 val;
 
@@ -2099,7 +2098,8 @@ static int vgic_its_save_ite(struct vgic
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
-	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
+
+	return vgic_its_write_entry_lock(its, gpa, val, ite_esz);
 }
 
 /**
@@ -2243,7 +2243,6 @@ static int vgic_its_restore_itt(struct v
 static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 			     gpa_t ptr, int dte_esz)
 {
-	struct kvm *kvm = its->dev->kvm;
 	u64 val, itt_addr_field;
 	u32 next_offset;
 
@@ -2254,7 +2253,8 @@ static int vgic_its_save_dte(struct vgic
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
-	return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
+
+	return vgic_its_write_entry_lock(its, ptr, val, dte_esz);
 }
 
 /**
@@ -2441,7 +2441,8 @@ static int vgic_its_save_cte(struct vgic
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
-	return vgic_write_guest_lock(its->dev->kvm, gpa, &val, esz);
+
+	return vgic_its_write_entry_lock(its, gpa, val, esz);
 }
 
 /*
@@ -2457,8 +2458,7 @@ static int vgic_its_restore_cte(struct v
 	u64 val;
 	int ret;
 
-	BUG_ON(esz > sizeof(val));
-	ret = kvm_read_guest_lock(kvm, gpa, &val, esz);
+	ret = vgic_its_read_entry_lock(its, gpa, &val, esz);
 	if (ret)
 		return ret;
 	val = le64_to_cpu(val);
@@ -2496,7 +2496,6 @@ static int vgic_its_save_collection_tabl
 	u64 baser = its->baser_coll_table;
 	gpa_t gpa = GITS_BASER_ADDR_48_to_52(baser);
 	struct its_collection *collection;
-	u64 val;
 	size_t max_size, filled = 0;
 	int ret, cte_esz = abi->cte_esz;
 
@@ -2520,10 +2519,7 @@ static int vgic_its_save_collection_tabl
 	 * table is not fully filled, add a last dummy element
 	 * with valid bit unset
 	 */
-	val = 0;
-	BUG_ON(cte_esz > sizeof(val));
-	ret = vgic_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
-	return ret;
+	return vgic_its_write_entry_lock(its, gpa, 0, cte_esz);
 }
 
 /*
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -146,6 +146,29 @@ static inline int vgic_write_guest_lock(
 	return ret;
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
+	return vgic_write_guest_lock(kvm, eaddr, &eval, esize);
+}
+
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC


