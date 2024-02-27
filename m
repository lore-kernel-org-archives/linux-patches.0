Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB69D2F2D;
	Tue, 27 Feb 2024 13:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041388; cv=none; b=ZFSvz03su5Kq1ylJaN0Jy4mK9zX6Y0Ml0NqgKZuFwI0sD0qHbnQE6Y9D+OCHoCPC7LEVxweW6OyeWWSXo5jlbUS55Z8ZQj1YwK+/mXroRjasEsA6rqDDFvhzBJYKxFjQJC2pHKYCXNBHU1l2fZSulCXgZ27P1gZ8+Vrwf9+Rsfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041388; c=relaxed/simple;
	bh=PaVyt1mC6osuGl2IH6yw1C0MJU3O/lhroKK53ifmO1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVaz/sXsTJkaLWZJnbXM6z0oQxtxV8G2o0NaQ6Hw27M7WVNKvPY9r/kFhk/pczMlxdBLZoY/dNWTnTDE64K3SYBV1KfDMF3oftcBK/7dk5TbiXyWXrYtGMPE+MdgAwn2emTmXJhvRbLTxVW6zjgqAS7pfUP5+buk+bqNHNY20wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LD24tuPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LD24tuPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA72C433C7;
	Tue, 27 Feb 2024 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041388;
	bh=PaVyt1mC6osuGl2IH6yw1C0MJU3O/lhroKK53ifmO1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LD24tuPWrqsygXV3+BuBMWQx9YOEgIvL0xI0Oe8X8XJ/dFCVV1vluyNqD+s6WNFgL
	 IUQrGsSa0MjYqs/Dys7BVDcd0zBx1HBPw/NLYspebnVKJNZRPfZ3YidNPkUdfCJuaG
	 Wzgm5qk6sbkfn33fiyuJWm70OBnlwwSgI3nC3/GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Shavit <mshavit@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 323/334] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as spinlock
Date: Tue, 27 Feb 2024 14:23:01 +0100
Message-ID: <20240227131641.533513651@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit b5bf7778b722105d7a04b1d51e884497b542638b ]

If the SMMU is configured to use a two level CD table then
arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
GFP_KERNEL. Due to recent changes this is being done under a spinlock to
iterate over the device list - thus it will trigger a sleeping while
atomic warning:

  arm_smmu_sva_set_dev_pasid()
    mutex_lock(&sva_lock);
    __arm_smmu_sva_bind()
     arm_smmu_mmu_notifier_get()
      spin_lock_irqsave()
      arm_smmu_write_ctx_desc()
	arm_smmu_get_cd_ptr()
         arm_smmu_alloc_cd_leaf_table()
	  dmam_alloc_coherent(GFP_KERNEL)

This is a 64K high order allocation and really should not be done
atomically.

At the moment the rework of the SVA to follow the new API is half
finished. Recently the CD table memory was moved from the domain to the
master, however we have the confusing situation where the SVA code is
wrongly using the RID domains device's list to track which CD tables the
SVA is installed in.

Remove the logic to replicate the CD across all the domain's masters
during attach. We know which master and which CD table the PASID should be
installed in.

Right now SVA only works when dma-iommu.c is in control of the RID
translation, which means we have a single iommu_domain shared across the
entire group and that iommu_domain is not shared outside the group.

Critically this means that the iommu_group->devices list and RID's
smmu_domain->devices list describe the same set of masters.

For PCI cases the core code also insists on singleton groups so there is
only one entry in the smmu_domain->devices list that is equal to the
master being passed in to arm_smmu_sva_set_dev_pasid().

Only non-PCI cases may have multi-device groups. However, the core code
will repeat the calls to arm_smmu_sva_set_dev_pasid() across the entire
iommu_group->devices list.

Instead of having arm_smmu_mmu_notifier_get() indirectly loop over all the
devices in the group via the RID's smmu_domain, rely on
__arm_smmu_sva_bind() to be called for each device in the group and
install the repeated CD entry that way.

This avoids taking the spinlock to access the devices list and permits the
arm_smmu_write_ctx_desc() to use a sleeping allocation. Leave the
arm_smmu_mm_release() as a confusing situation, this requires tracking
attached masters inside the SVA domain.

Removing the loop allows arm_smmu_write_ctx_desc() to be called outside
the spinlock and thus is safe to use GFP_KERNEL.

Move the clearing of the CD into arm_smmu_sva_remove_dev_pasid() so that
arm_smmu_mmu_notifier_get/put() remain paired functions.

Fixes: 24503148c545 ("iommu/arm-smmu-v3: Refactor write_ctx_desc")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/4e25d161-0cf8-4050-9aa3-dfa21cd63e56@moroto.mountain/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Link: https://lore.kernel.org/r/0-v3-11978fc67151+112-smmu_cd_atomic_jgg@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 38 ++++++-------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 05722121f00e7..4a27fbdb2d844 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -292,10 +292,8 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 			  struct mm_struct *mm)
 {
 	int ret;
-	unsigned long flags;
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_mmu_notifier *smmu_mn;
-	struct arm_smmu_master *master;
 
 	list_for_each_entry(smmu_mn, &smmu_domain->mmu_notifiers, list) {
 		if (smmu_mn->mn.mm == mm) {
@@ -325,28 +323,9 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 		goto err_free_cd;
 	}
 
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		ret = arm_smmu_write_ctx_desc(master, mm_get_enqcmd_pasid(mm),
-					      cd);
-		if (ret) {
-			list_for_each_entry_from_reverse(
-				master, &smmu_domain->devices, domain_head)
-				arm_smmu_write_ctx_desc(
-					master, mm_get_enqcmd_pasid(mm), NULL);
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-	if (ret)
-		goto err_put_notifier;
-
 	list_add(&smmu_mn->list, &smmu_domain->mmu_notifiers);
 	return smmu_mn;
 
-err_put_notifier:
-	/* Frees smmu_mn */
-	mmu_notifier_put(&smmu_mn->mn);
 err_free_cd:
 	arm_smmu_free_shared_cd(cd);
 	return ERR_PTR(ret);
@@ -363,9 +342,6 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 
 	list_del(&smmu_mn->list);
 
-	arm_smmu_update_ctx_desc_devices(smmu_domain, mm_get_enqcmd_pasid(mm),
-					 NULL);
-
 	/*
 	 * If we went through clear(), we've already invalidated, and no
 	 * new TLB entry can have been formed.
@@ -381,7 +357,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	arm_smmu_free_shared_cd(cd);
 }
 
-static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
+static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
+			       struct mm_struct *mm)
 {
 	int ret;
 	struct arm_smmu_bond *bond;
@@ -404,9 +381,15 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
 		goto err_free_bond;
 	}
 
+	ret = arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd);
+	if (ret)
+		goto err_put_notifier;
+
 	list_add(&bond->list, &master->bonds);
 	return 0;
 
+err_put_notifier:
+	arm_smmu_mmu_notifier_put(bond->smmu_mn);
 err_free_bond:
 	kfree(bond);
 	return ret;
@@ -568,6 +551,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
 	mutex_lock(&sva_lock);
+
+	arm_smmu_write_ctx_desc(master, id, NULL);
+
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
 			bond = t;
@@ -590,7 +576,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	struct mm_struct *mm = domain->mm;
 
 	mutex_lock(&sva_lock);
-	ret = __arm_smmu_sva_bind(dev, mm);
+	ret = __arm_smmu_sva_bind(dev, id, mm);
 	mutex_unlock(&sva_lock);
 
 	return ret;
-- 
2.43.0



