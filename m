Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A2C13B5B9;
	Thu, 11 Apr 2024 10:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830128; cv=none; b=mAJ8GTlyJ14to6rPd0HBLi7gJ2ZvUxvhCypduhANGUq976M7hwENC59Ie7qqG2Cayg1Jfdj4Rn05eMfng2Y1paXo7m7MWiTF4QoHJp0e8ULnujN5k3GqAeJEKNJJ4Mqrb1yV2tun0OhHmUARAuV65EcMq23jFDUkzuaRqoHNj4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830128; c=relaxed/simple;
	bh=1qkPQCqF6qTf9olnwzpFl3Xa1IkH3le/kJ6AMuW5Nrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdMH877KkTnHGO6kDzGuNCppGDzwWuiOa7geZ7xypLDrE6OaHR+aA8eDMlXhffmhbeR4LDwlcwqWGcVygITbJP1do8RBypEkRHSdqsp0M7puBwLVMB3UaE4YsYdk7a6OeXGWlAlpkTi04u7L4pf7piCqCouviAbyYeFsdm186/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1OMknHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1OMknHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337E4C433F1;
	Thu, 11 Apr 2024 10:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830128;
	bh=1qkPQCqF6qTf9olnwzpFl3Xa1IkH3le/kJ6AMuW5Nrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1OMknHn2iHuxcgtvJYlBFl4qPeaSJa/5DfnDeoULln9gBimWOUV7BMR0VquDCG3C
	 jOLTzmdkGapxXp94twG/BSOHz/KYnGTvh1fKLubSjFAMCU3b190YVP4gkJVj2vKToE
	 CPZK5oMYu9BbdOESKiVFKP68/K2bYB0JgUWBcT+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Moritz Fischer <moritzf@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 043/143] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock during all of attach_dev
Date: Thu, 11 Apr 2024 11:55:11 +0200
Message-ID: <20240411095422.211176366@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 9f7c68911579bc15c57d227d021ccd253da2b635 ]

The BTM support wants to be able to change the ASID of any smmu_domain.
When it goes to do this it holds the arm_smmu_asid_lock and iterates over
the target domain's devices list.

During attach of a S1 domain we must ensure that the devices list and
CD are in sync, otherwise we could miss CD updates or a parallel CD update
could push an out of date CD.

This is pretty complicated, and almost works today because
arm_smmu_detach_dev() removes the master from the linked list before
working on the CD entries, preventing parallel update of the CD.

However, it does have an issue where the CD can remain programed while the
domain appears to be unattached. arm_smmu_share_asid() will then not clear
any CD entriess and install its own CD entry with the same ASID
concurrently. This creates a small race window where the IOMMU can see two
ASIDs pointing to different translations.

       CPU0                                   CPU1
arm_smmu_attach_dev()
   arm_smmu_detach_dev()
     spin_lock_irqsave(&smmu_domain->devices_lock, flags);
     list_del(&master->domain_head);
     spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);

				      arm_smmu_mmu_notifier_get()
				       arm_smmu_alloc_shared_cd()
					arm_smmu_share_asid():
                                          // Does nothing due to list_del above
					  arm_smmu_update_ctx_desc_devices()
					  arm_smmu_tlb_inv_asid()
				       arm_smmu_write_ctx_desc()
					 ** Now the ASID is in two CDs
					    with different translation

     arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);

Solve this by wrapping most of the attach flow in the
arm_smmu_asid_lock. This locks more than strictly needed to prepare for
the next patch which will reorganize the order of the linked list, STE and
CD changes.

Move arm_smmu_detach_dev() till after we have initialized the domain so
the lock can be held for less time.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/5-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0ffb1cf17e0b2..f3f2e47b6d488 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2398,8 +2398,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		return -EBUSY;
 	}
 
-	arm_smmu_detach_dev(master);
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2414,6 +2412,16 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	if (ret)
 		return ret;
 
+	/*
+	 * Prevent arm_smmu_share_asid() from trying to change the ASID
+	 * of either the old or new domain while we are working on it.
+	 * This allows the STE and the smmu_domain->devices list to
+	 * be inconsistent during this routine.
+	 */
+	mutex_lock(&arm_smmu_asid_lock);
+
+	arm_smmu_detach_dev(master);
+
 	master->domain = smmu_domain;
 
 	/*
@@ -2439,13 +2447,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			}
 		}
 
-		/*
-		 * Prevent SVA from concurrently modifying the CD or writing to
-		 * the CD entry
-		 */
-		mutex_lock(&arm_smmu_asid_lock);
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		mutex_unlock(&arm_smmu_asid_lock);
 		if (ret) {
 			master->domain = NULL;
 			goto out_list_del;
@@ -2455,13 +2457,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	arm_smmu_install_ste_for_dev(master);
 
 	arm_smmu_enable_ats(master);
-	return 0;
+	goto out_unlock;
 
 out_list_del:
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_del(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
+out_unlock:
+	mutex_unlock(&arm_smmu_asid_lock);
 	return ret;
 }
 
-- 
2.43.0



