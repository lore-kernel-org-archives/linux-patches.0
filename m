Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327EA3E6385;
	Wed, 20 May 2026 17:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297303; cv=none; b=MRDTtlaJfxqRKJVWFVjkX5N1HtRco6Dnp4bQZp2RYQAiQGFHzkktNHeWpwntQ1b/3bW42IEucey2ZC7Aq8HiKzbAXStdKMHjOTNDuA2qk00faHiFkfR0z+ZjM/iFwsQeYq/3gdDEbncL20+5VXtWjKIbMLhES1bA9J4DjuOFePw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297303; c=relaxed/simple;
	bh=tHVk5pvOzn6LyFpSGHOp/1v1rDaoRmk0p6aF0i3qHEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqPVBzuixR1d4Hz9Ufdot7V5ldU7HUDfOHq7G7ecrkbwUfQDyeHNjLKUQo0OCwyIKLxHApvWQarNvf+UqFcm3Tc2cBI6P/6Admp0if95tHd7x5/wFrIy1+cnQe3vGDWJJ0hH06sn9mPZBdkEcMsKvUzs6ypB6QC13kKg56s1X18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYesiGwV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYesiGwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BA11F000E9;
	Wed, 20 May 2026 17:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297301;
	bh=rKubk8PR2XWijCZE0mPl1qeaFUYSpwmNUgT8qSf0Nkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYesiGwViJnYio4mXqHBj3ANtQpngt1BusgVksE5DiV7eonu9S7DtG4KRXr8Znz7e
	 +KHJbmDel3t0mloAJ9CHKWqHxcWpEgqM9bDgWRGjTvG0Q5/N/6a5LBfLAIIvB3FRBO
	 pyzw3AqhxiPMPSqHuGRkEKXi8wdq4xcWiky8Rs6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.0 1126/1146] iommu: Fix nested pci_dev_reset_iommu_prepare/done()
Date: Wed, 20 May 2026 18:22:56 +0200
Message-ID: <20260520162213.728055130@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 0d5fd7a9323ce6bedd170e21e1e90b8904917c75 upstream.

Shuai found that cxl_reset_bus_function() calls pci_reset_bus_function()
internally while both are calling pci_dev_reset_iommu_prepare/done().

As pci_dev_reset_iommu_prepare() doesn't support re-entry, the inner call
will trigger a WARN_ON and return -EBUSY, resulting in failing the entire
device reset.

On the other hand, removing the outer calls in the PCI callers is unsafe.
As pointed out by Kevin, device-specific quirks like reset_hinic_vf_dev()
execute custom firmware waits after their inner pcie_flr() completes. If
the IOMMU protection relies solely on the inner reset, the IOMMU will be
unblocked prematurely while the device is still resetting.

Instead, fix this by making pci_dev_reset_iommu_prepare/done() reentrant.

Introduce gdev->reset_depth to handle the re-entries on the same device.

Fixes: c279e83953d9 ("iommu: Introduce pci_dev_reset_iommu_prepare/done()")
Cc: stable@vger.kernel.org
Reported-by: Shuai Xue <xueshuai@linux.alibaba.com>
Closes: https://lore.kernel.org/all/absKsk7qQOwzhpzv@Asurada-Nvidia/
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -82,6 +82,7 @@ struct group_device {
 	 *  - Device is undergoing a reset
 	 */
 	bool blocked;
+	unsigned int reset_depth;
 };
 
 /* Iterate over each struct group_device in a struct iommu_group */
@@ -4015,20 +4016,23 @@ int pci_dev_reset_iommu_prepare(struct p
 	if (WARN_ON(!gdev))
 		return -ENODEV;
 
-	/* Re-entry is not allowed */
-	if (WARN_ON(gdev->blocked))
-		return -EBUSY;
+	if (gdev->reset_depth++)
+		return 0;
 
 	ret = __iommu_group_alloc_blocking_domain(group);
-	if (ret)
+	if (ret) {
+		gdev->reset_depth--;
 		return ret;
+	}
 
 	/* Stage RID domain at blocking_domain while retaining group->domain */
 	if (group->domain != group->blocking_domain) {
 		ret = __iommu_attach_device(group->blocking_domain, &pdev->dev,
 					    group->domain);
-		if (ret)
+		if (ret) {
+			gdev->reset_depth--;
 			return ret;
+		}
 	}
 
 	/*
@@ -4088,7 +4092,10 @@ void pci_dev_reset_iommu_done(struct pci
 	if (WARN_ON(!gdev))
 		return;
 
-	if (!gdev->blocked)
+	/* Unbalanced done() calls would underflow the counter */
+	if (WARN_ON(gdev->reset_depth == 0))
+		return;
+	if (--gdev->reset_depth)
 		return;
 
 	if (WARN_ON(!group->blocking_domain))


