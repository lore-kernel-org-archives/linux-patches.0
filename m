Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2224A17E90E;
	Mon, 27 May 2024 19:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837215; cv=none; b=SQ34BE+rKsWHZvIJBL8ptialKrSemtCnDs/Y6DeGi4mP5KFiVyHNSe6krLIs535luCkYbSeT5O452Y4zY3wMyq5rXX0CXCLWrvB/JO2fnktWZY4+cpQc0ulSdzZDq34vgc2tJqjwh4BU6tmpke8nCjF/3tbcG0XnsErkkKUVKPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837215; c=relaxed/simple;
	bh=umYKObinYUHrICYhmQAIIVa7wE3teQYhlpgILj1eA8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE9rxsifK6KJcc3k/0h9eT6ZjfUomaBo9Q+G8x8Rezkpt0RMGr3TRN9WW/ejDMb5xNWLDgJ4K1/iit+lWZmbC40vbp8d26E/Q/q/1P7dvIrokU2hVCJONJx/NLZqaj1n3QRH0ZOzzBSX1j498YgFJQG7DWRootSgIJuT0za3BgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gspLKoa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gspLKoa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7F4C2BBFC;
	Mon, 27 May 2024 19:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837215;
	bh=umYKObinYUHrICYhmQAIIVa7wE3teQYhlpgILj1eA8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gspLKoa4DzOJX0RvJgK8zx1ae/AWiXn3BY0IO895i79n83r5vmjYY0c3jrnZDmTQF
	 zWzHN0+535oakIAUyO7F9MGTgtqxPFXDv23Dp2EIV3tPotlThyUQkVhwMPbcOg8k8P
	 zGeSpoXP2U0qbyTY1BXCpfddAX5WL/ICe/Y1QKVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 353/427] iommu: Undo pasid attachment only for the devices that have succeeded
Date: Mon, 27 May 2024 20:56:40 +0200
Message-ID: <20240527185633.537447296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit b025dea63cded0d82bccd591fa105d39efc6435d ]

There is no error handling now in __iommu_set_group_pasid(), it relies on
its caller to loop all the devices to undo the pasid attachment. This is
not self-contained and has drawbacks. It would result in unnecessary
remove_dev_pasid() calls on the devices that have not been attached to the
new domain. But the remove_dev_pasid() callback would get the new domain
from the group->pasid_array. So for such devices, the iommu driver won't
find the attachment under the domain, hence unable to do cleanup. This may
not be a real problem today. But it depends on the implementation of the
underlying iommu driver. e.g. the intel iommu driver would warn for such
devices. Such warnings are unnecessary.

To solve the above problem, it is necessary to handle the error within
__iommu_set_group_pasid(). It only loops the devices that have attached
to the new domain, and undo it.

Fixes: 16603704559c ("iommu: Add attach/detach_dev_pasid iommu interfaces")
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20240328122958.83332-2-yi.l.liu@intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index a95a483def2d2..659a77f7bb833 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3317,15 +3317,26 @@ EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
 				   struct iommu_group *group, ioasid_t pasid)
 {
-	struct group_device *device;
-	int ret = 0;
+	struct group_device *device, *last_gdev;
+	int ret;
 
 	for_each_group_device(group, device) {
 		ret = domain->ops->set_dev_pasid(domain, device->dev, pasid);
 		if (ret)
-			break;
+			goto err_revert;
 	}
 
+	return 0;
+
+err_revert:
+	last_gdev = device;
+	for_each_group_device(group, device) {
+		const struct iommu_ops *ops = dev_iommu_ops(device->dev);
+
+		if (device == last_gdev)
+			break;
+		ops->remove_dev_pasid(device->dev, pasid);
+	}
 	return ret;
 }
 
@@ -3383,10 +3394,8 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	}
 
 	ret = __iommu_set_group_pasid(domain, group, pasid);
-	if (ret) {
-		__iommu_remove_group_pasid(group, pasid);
+	if (ret)
 		xa_erase(&group->pasid_array, pasid);
-	}
 out_unlock:
 	mutex_unlock(&group->mutex);
 	return ret;
-- 
2.43.0



