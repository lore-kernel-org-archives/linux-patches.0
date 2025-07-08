Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73611548C;
	Tue,  8 Jul 2025 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992474; cv=none; b=MS4qChHjdCRas8LyqDF14/hTCzMDF0yoiobOKY7wMQCFqTzqYVZSSbV94E6QL7YBxzm6/h1KZv+hdZsfAE1t7Vjs0zQpMbjbSJCJKSsFYNQuxUAI+bXDknC45XZRKdow/0lCHPDGfJyyoChZaARfD3M/cORZpoWinLg0zP/ncTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992474; c=relaxed/simple;
	bh=m6s4y94JehGZULxNk8kCzqH6QkE5gk8ulfjJLVzkJfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBiJosB+kwwX3OfB+O0Y+ww+JHyFpR+/hAAXD+MZ9OgdE2Rmzwicc8+4JNYjmBrs49/IWyFfpw2TAxm+pqSS0PRLWxjmGf7EioqCe9qfJPZVRaaIsqkczCLh1ZPzc+V1fUqCPENWv6lhXbC1R13GZrlKAo36zUQkupL2hBlku0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1Rm9hgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1Rm9hgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA7BC4CEF0;
	Tue,  8 Jul 2025 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992474;
	bh=m6s4y94JehGZULxNk8kCzqH6QkE5gk8ulfjJLVzkJfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1Rm9hgm53LtvG5vDtWW3iuyafCUABtWpH0mfIOfvEy1D/CxOup5BvPc0Nqs5j5Ed
	 Vr+03HVBJF4iY3SLlFK6D16CkBiu9sVQWvYaOO5GvOtPzmEHy4H/sb0J2VOgUtltHR
	 ve2yRqrmiaphPwRHmaOHFbi6gjL8v6DiIGAaICrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/132] iommu: Add IOMMU_DOMAIN_PLATFORM for S390
Date: Tue,  8 Jul 2025 18:23:34 +0200
Message-ID: <20250708162233.618770290@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit e04c7487a6655722172e93e8f36e51d6ab279f86 ]

The PLATFORM domain will be set as the default domain and attached as
normal during probe. The driver will ignore the initial attach from a NULL
domain to the PLATFORM domain.

After this, the PLATFORM domain's attach_dev will be called whenever we
detach from an UNMANAGED domain (eg for VFIO). This is the same time the
original design would have called op->detach_dev().

This is temporary until the S390 dma-iommu.c conversion is merged.

Tested-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/4-v8-81230027b2fa+9d-iommu_all_defdom_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 45537926dd2a ("s390/pci: Fix stale function handles in error handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/s390-iommu.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index fbf59a8db29b1..f0c867c57a5b9 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -142,14 +142,31 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	return 0;
 }
 
-static void s390_iommu_set_platform_dma(struct device *dev)
+/*
+ * Switch control over the IOMMU to S390's internal dma_api ops
+ */
+static int s390_iommu_platform_attach(struct iommu_domain *platform_domain,
+				      struct device *dev)
 {
 	struct zpci_dev *zdev = to_zpci_dev(dev);
 
+	if (!zdev->s390_domain)
+		return 0;
+
 	__s390_iommu_detach_device(zdev);
 	zpci_dma_init_device(zdev);
+	return 0;
 }
 
+static struct iommu_domain_ops s390_iommu_platform_ops = {
+	.attach_dev = s390_iommu_platform_attach,
+};
+
+static struct iommu_domain s390_iommu_platform_domain = {
+	.type = IOMMU_DOMAIN_PLATFORM,
+	.ops = &s390_iommu_platform_ops,
+};
+
 static void s390_iommu_get_resv_regions(struct device *dev,
 					struct list_head *list)
 {
@@ -428,12 +445,12 @@ void zpci_destroy_iommu(struct zpci_dev *zdev)
 }
 
 static const struct iommu_ops s390_iommu_ops = {
+	.default_domain = &s390_iommu_platform_domain,
 	.capable = s390_iommu_capable,
 	.domain_alloc = s390_domain_alloc,
 	.probe_device = s390_iommu_probe_device,
 	.release_device = s390_iommu_release_device,
 	.device_group = generic_device_group,
-	.set_platform_dma_ops = s390_iommu_set_platform_dma,
 	.pgsize_bitmap = SZ_4K,
 	.get_resv_regions = s390_iommu_get_resv_regions,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
-- 
2.39.5



