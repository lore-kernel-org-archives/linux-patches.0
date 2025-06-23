Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C12513A265;
	Mon, 23 Jun 2025 13:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684645; cv=none; b=Swj7eRZiRn4vo1pI5n7fMy4WGE1hpj9Ox066DhFbls5Ab7zX/s+ziP4rp42HmZrC8Ht6ATLjkUhQQtwd3buzlALrzHUCG/Fpsa2U0XuzwZfKz8EX7L2lW9mb3vhqBuyyArOXRM1RaEwjbZBbKsnDhReBt+cRiv1bxzsgv9DCguE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684645; c=relaxed/simple;
	bh=dxWVDMr46r+nQE+GvAUvfrMdb7ueITIdFQpnuoxdMxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCKA4p6I1VFpuS+BgDAVGTIdi0pmYhvMkmZmnzUm/87Tfqm88xWcUtm8fLHpB7UnitNsB6IOCKG/BZ3dvz2Pw0CZNxaQ08DELdVosv3zRq5n50vJVdUzEnmpZuKttSd63MbrAypDgBs+zrNdOLDO2uhMVImoSFlyR6FtQJ0Hu94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qb8s1t+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qb8s1t+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44F2C4CEF0;
	Mon, 23 Jun 2025 13:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684645;
	bh=dxWVDMr46r+nQE+GvAUvfrMdb7ueITIdFQpnuoxdMxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qb8s1t+ymFNi+q+Kl27+dtEa2XWTf7D09lWTk9zz4yDVkiV8bCib62Wvw4gw30cwI
	 Jxpw32kvpwNPFf5/o6byqR5tWLdb1rUZ/F/taJ6ZXrCNKPcZ1DXrBKA3SNHjSECaP3
	 u/ZGoeElzamYR6EbnvOlMGW/8N7nc1NSX0f2a29o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.15 146/592] iommu: Allow attaching static domains in iommu_attach_device_pasid()
Date: Mon, 23 Jun 2025 15:01:44 +0200
Message-ID: <20250623130703.753137692@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 6f7340120a0aa8b2eb29c826a4434e8b5c4e11d3 upstream.

The idxd driver attaches the default domain to a PASID of the device to
perform kernel DMA using that PASID. The domain is attached to the
device's PASID through iommu_attach_device_pasid(), which checks if the
domain->owner matches the iommu_ops retrieved from the device. If they
do not match, it returns a failure.

        if (ops != domain->owner || pasid == IOMMU_NO_PASID)
                return -EINVAL;

The static identity domain implemented by the intel iommu driver doesn't
specify the domain owner. Therefore, kernel DMA with PASID doesn't work
for the idxd driver if the device translation mode is set to passthrough.

Generally the owner field of static domains are not set because they are
already part of iommu ops. Add a helper domain_iommu_ops_compatible()
that checks if a domain is compatible with the device's iommu ops. This
helper explicitly allows the static blocked and identity domains associated
with the device's iommu_ops to be considered compatible.

Fixes: 2031c469f816 ("iommu/vt-d: Add support for static identity domain")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220031
Cc: stable@vger.kernel.org
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/linux-iommu/20250422191554.GC1213339@ziepe.ca/
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20250424034123.2311362-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2208,6 +2208,19 @@ static void *iommu_make_pasid_array_entr
 	return xa_tag_pointer(domain, IOMMU_PASID_ARRAY_DOMAIN);
 }
 
+static bool domain_iommu_ops_compatible(const struct iommu_ops *ops,
+					struct iommu_domain *domain)
+{
+	if (domain->owner == ops)
+		return true;
+
+	/* For static domains, owner isn't set. */
+	if (domain == ops->blocked_domain || domain == ops->identity_domain)
+		return true;
+
+	return false;
+}
+
 static int __iommu_attach_group(struct iommu_domain *domain,
 				struct iommu_group *group)
 {
@@ -2218,7 +2231,8 @@ static int __iommu_attach_group(struct i
 		return -EBUSY;
 
 	dev = iommu_group_first_dev(group);
-	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner)
+	if (!dev_has_iommu(dev) ||
+	    !domain_iommu_ops_compatible(dev_iommu_ops(dev), domain))
 		return -EINVAL;
 
 	return __iommu_group_set_domain(group, domain);
@@ -3456,7 +3470,8 @@ int iommu_attach_device_pasid(struct iom
 	    !ops->blocked_domain->ops->set_dev_pasid)
 		return -EOPNOTSUPP;
 
-	if (ops != domain->owner || pasid == IOMMU_NO_PASID)
+	if (!domain_iommu_ops_compatible(ops, domain) ||
+	    pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
@@ -3538,7 +3553,7 @@ int iommu_replace_device_pasid(struct io
 	if (!domain->ops->set_dev_pasid)
 		return -EOPNOTSUPP;
 
-	if (dev_iommu_ops(dev) != domain->owner ||
+	if (!domain_iommu_ops_compatible(dev_iommu_ops(dev), domain) ||
 	    pasid == IOMMU_NO_PASID || !handle)
 		return -EINVAL;
 


