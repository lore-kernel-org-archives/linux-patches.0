Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8287B3E5;
	Mon,  8 Apr 2024 13:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582122; cv=none; b=gG52etqMVlH9sODwqLJfl4s42XxuraCGluZ+fSDcVU+3nZ2bcVvJc/7OOD3+XgJOyZURFD8k138bUcMUoSfurMZ4v/2iznGGSUuTjpLlQzk+vUjF8UD2FXAOy6/4o8f5Dp9Jh2u5mYLH7d9yKli/VtarHqlhO+d+isFK0MYXpdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582122; c=relaxed/simple;
	bh=Yu+Gv2DWpbSluETMPwmlfZfQvKNRqiLvSQmjUaaUpos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sa/oc4qpsFp0NAu2lrGbZRwchhsJGe5aNaDAzpS5pD4c7PygiNO9ZaMJ2abGwbSqiQPda9V97usHiDkzYqjdinSS5YVg6C2Tt+L6LJa/trfUYVdS5O3lXUgDLh8kCY8GEW8abmhUAdsKTx4fO2u0Fn/X7GscJNutL/+BZLx/0p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+S2yrNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+S2yrNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FC2C433C7;
	Mon,  8 Apr 2024 13:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582121;
	bh=Yu+Gv2DWpbSluETMPwmlfZfQvKNRqiLvSQmjUaaUpos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+S2yrNJw5LOdihfz4P34IDHhv9y8E6ifV3g/7E+Nl7Qg3ufiFKCijsKmipNpJ5Q+
	 o8m7wfHqxVq8OBiCVfo312F+ScZ8xitpfeGtqsnTIlaQ+5dXCzOamXqqf3hXu6U3SN
	 rR6dKsKiYjBd0HP8fS9VbspF1diOg17Ur6IhnKRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 048/273] iommu: Validate the PASID in iommu_attach_device_pasid()
Date: Mon,  8 Apr 2024 14:55:23 +0200
Message-ID: <20240408125310.787610795@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

[ Upstream commit c404f55c26fc23c70a9f2262f3f36a69fc46289b ]

The SVA code checks that the PASID is valid for the device when assigning
the PASID to the MM, but the normal PAGING related path does not check it.

Devices that don't support PASID or PASID values too large for the device
should not invoke the driver callback. The drivers should rely on the
core code for this enforcement.

Fixes: 16603704559c7a68 ("iommu: Add attach/detach_dev_pasid iommu interfaces")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index cd1210026ac53..ad33161f2374b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3547,6 +3547,7 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 {
 	/* Caller must be a probed driver on dev */
 	struct iommu_group *group = dev->iommu_group;
+	struct group_device *device;
 	void *curr;
 	int ret;
 
@@ -3556,10 +3557,18 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	if (!group)
 		return -ENODEV;
 
-	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner)
+	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
+	    pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+	for_each_group_device(group, device) {
+		if (pasid >= device->dev->iommu->max_pasids) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+	}
+
 	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL, domain, GFP_KERNEL);
 	if (curr) {
 		ret = xa_err(curr) ? : -EBUSY;
-- 
2.43.0



