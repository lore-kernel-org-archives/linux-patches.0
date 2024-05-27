Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C404535A4;
	Mon, 27 May 2024 19:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838524; cv=none; b=b7l0Um7/hc8nXzpkLdcEX1L0A9d44VYbnbkUjwngB66Sp4f3gsnUHEzVtlOzCmLLKRYULMlP2tPg61mBDYKLPkZkvYIzQ0tLnNb9iLpzrzpLRXqdlIaUCb7vU32hz5+r0Gdwv4r+7iIpciRfFZNGZxboe2d/nOhY7rujm0QfkFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838524; c=relaxed/simple;
	bh=Qo2YHEZKJgmXlNhLGwCe+YhQsVO/hbDvJs+DcOTtEpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmuFWigbXZbvhXmoMva8OAjlTtiayoZ98SyElm8qF9Hqr8qF4abxVxvrhwVkT/uRaDZn0VOaXn7P/5brQ7K9x3GwMqcpLpX2nZ9K4KrrySOy9TG7UGi/sk4FOYj91NwJKN5WVjpzCqizlGNNBNJwvc/Jca7zyBv6Y0GIjMr0K4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gwn0aclx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gwn0aclx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0268DC2BBFC;
	Mon, 27 May 2024 19:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838524;
	bh=Qo2YHEZKJgmXlNhLGwCe+YhQsVO/hbDvJs+DcOTtEpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gwn0aclx+QoJsMY0B6aafLgNmdppwvPJEL4FILpCXCc6m2y4zeNVuDCi+h13ne9dL
	 FiBTBXHLTTBqrgKZF0L2OB22P0xTYyCzUBvWPqPetlvVUJRh73p5qhfVAxHVy+706a
	 qpm9tkHqkqtWXd4/MxuppP5ZLWBzv0gfBqElbnNM=
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
Subject: [PATCH 6.8 425/493] iommu: Undo pasid attachment only for the devices that have succeeded
Date: Mon, 27 May 2024 20:57:07 +0200
Message-ID: <20240527185644.195137786@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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
index ad33161f2374b..e606d250d1d55 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3510,15 +3510,26 @@ EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
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
 
@@ -3576,10 +3587,8 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
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



