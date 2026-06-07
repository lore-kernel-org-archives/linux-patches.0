Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB7F224D6;
	Sun,  7 Jun 2026 11:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830153; cv=none; b=L/zJu1s99F8eSUhod62Zo77byraMuHwxgmp1Uj8g1Aifyg+MBsLbM2L7VRuyYD+AS8lZsDFEiX+eyCDD91Px7i5OOOdXEYsdSOlK0usknyFTcnhrdCX/vUYSUQNEbO1HpCZxdWp1fjJZHsJE8UCDKGNmRfgTRqlCeXWga1oVTOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830153; c=relaxed/simple;
	bh=WYu3tDFAuLvCzYgUxI33sJSXqg2somN/90ZnIA2mpCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b62bLUbB38RDmbj0KgmIUfSD5A0pUfZjAoqek5+R9TWLxsRpB0YZNIbpjRim+mPsp2tMC7k8kGZZTEZOrAEoUnWwfLOCw9sdfMB3fL9Z47dtQU+rN0o3OvJEerqG9AnO045zLJX3d66JesqOBePd432a1Ezt7vuDzzf83pcQR+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIv0GWhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIv0GWhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF961F00893;
	Sun,  7 Jun 2026 11:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830151;
	bh=xjR2lF9yBXoxWX5YDS6mWH5iz+3wLfvNqNWsNXw/pFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIv0GWhPDz1U7s57sjQl3XZAkwb1BOl8asCY7Y7CBR5kfphfon2xBAZcPYjTWtyrG
	 7oR5iwhfG86HG1M7CjNbStqNaYfNzTJvfp0ZHcJcsGgUAaGkE+iPkEfp0H9ekuCMBG
	 zVcNfBaNvTixXfhwhrW3+2UDFF0j12sBenqfVN3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Dmitrii Chervov <fary.ru@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/307] iommu: Skip PASID validation for devices without PASID capability
Date: Sun,  7 Jun 2026 12:01:02 +0200
Message-ID: <20260607095737.436865478@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tushar Dave <tdave@nvidia.com>

[ Upstream commit b3f6fcd8404f9f92262303369bb877ec5d188a81 ]

Generally PASID support requires ACS settings that usually create
single device groups, but there are some niche cases where we can get
multi-device groups and still have working PASID support. The primary
issue is that PCI switches are not required to treat PASID tagged TLPs
specially so appropriate ACS settings are required to route all TLPs to
the host bridge if PASID is going to work properly.

pci_enable_pasid() does check that each device that will use PASID has
the proper ACS settings to achieve this routing.

However, no-PASID devices can be combined with PASID capable devices
within the same topology using non-uniform ACS settings. In this case
the no-PASID devices may not have strict route to host ACS flags and
end up being grouped with the PASID devices.

This configuration fails to allow use of the PASID within the iommu
core code which wrongly checks if the no-PASID device supports PASID.

Fix this by ignoring no-PASID devices during the PASID validation. They
will never issue a PASID TLP anyhow so they can be ignored.

Fixes: c404f55c26fc ("iommu: Validate the PASID in iommu_attach_device_pasid()")
Cc: stable@vger.kernel.org
Signed-off-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20250520011937.3230557-1-tdave@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>

[ Refactored to apply cleanly without support attaching PASID to the blocked domain ]
Signed-off-by: Dmitrii Chervov <fary.ru@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0ad55649e2d007..62e1d637250318 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3341,9 +3341,11 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
 	int ret;
 
 	for_each_group_device(group, device) {
-		ret = domain->ops->set_dev_pasid(domain, device->dev, pasid);
-		if (ret)
-			goto err_revert;
+		if (device->dev->iommu->max_pasids > 0) {
+			ret = domain->ops->set_dev_pasid(domain, device->dev, pasid);
+			if (ret)
+				goto err_revert;
+		}
 	}
 
 	return 0;
@@ -3355,7 +3357,8 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
 
 		if (device == last_gdev)
 			break;
-		ops->remove_dev_pasid(device->dev, pasid, domain);
+		if (device->dev->iommu->max_pasids > 0)
+			ops->remove_dev_pasid(device->dev, pasid, domain);
 	}
 	return ret;
 }
@@ -3368,8 +3371,10 @@ static void __iommu_remove_group_pasid(struct iommu_group *group,
 	const struct iommu_ops *ops;
 
 	for_each_group_device(group, device) {
-		ops = dev_iommu_ops(device->dev);
-		ops->remove_dev_pasid(device->dev, pasid, domain);
+		if (device->dev->iommu->max_pasids > 0) {
+			ops = dev_iommu_ops(device->dev);
+			ops->remove_dev_pasid(device->dev, pasid, domain);
+		}
 	}
 }
 
@@ -3403,7 +3408,13 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 
 	mutex_lock(&group->mutex);
 	for_each_group_device(group, device) {
-		if (pasid >= device->dev->iommu->max_pasids) {
+		/*
+		 * Skip PASID validation for devices without PASID support
+		 * (max_pasids = 0). These devices cannot issue transactions
+		 * with PASID, so they don't affect group's PASID usage.
+		 */
+		if ((device->dev->iommu->max_pasids > 0) &&
+		    (pasid >= device->dev->iommu->max_pasids)) {
 			ret = -EINVAL;
 			goto out_unlock;
 		}
-- 
2.53.0



