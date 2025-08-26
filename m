Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EEA338F2B;
	Tue, 26 Aug 2025 11:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207718; cv=none; b=iRzUrAm63YZ0KEL6pPQDW3bflnUItbEBsy9YdIybLYgeVpcoTis+3PmjdafuAFa32Yte0N1Lbimsjk5GzIH95FCkAqjDjUiS6vXE9oT12zJ6wPK/D4ofKxpbl/TlBtklKXiA3TzpOR0nG5mxkd7CPR+/v1T2VEuTfROwRy67m7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207718; c=relaxed/simple;
	bh=JhONq3QSevt60GhPQcgdYd1POPxzEOeflbLzGot74LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjAt3JtBrPeA0tvG+MDcm2vOHG2LQViLicqq+OcfVeCWyyOEz139qdNo+vef84Hokcp47icJVnPV/b5QSG0dKAzwi8xnlwf43dAev7sX+1CMJs+SCnWTsiQWLgXuFXKR4E7jxDt6ZLcE4ynzIFtmcQx/jIE0Zo8ZdSF8OGbO8Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5K/Kmis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5K/Kmis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CCAC4CEF1;
	Tue, 26 Aug 2025 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207716;
	bh=JhONq3QSevt60GhPQcgdYd1POPxzEOeflbLzGot74LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5K/Kmisq6j1D6nFE7rYuS3T7IjOuYAnuzOKS8G3z+QMikROZ6HtcWbl6jwke8gVf
	 wexU6PfiGk/F9Xjto1PTGewQI/U/v+KCpGycJ+QONhn9tVgUAqV5dI+GKBEW28QNCY
	 Mktlc0PvdUNyzujd/UVcp+dHNvK/YDF0gqYDM6iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 291/457] iommu/virtio: Make instance lookup robust
Date: Tue, 26 Aug 2025 13:09:35 +0200
Message-ID: <20250826110944.574925253@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 72b6f7cd89cea8251979b65528d302f9c0ed37bf ]

Much like arm-smmu in commit 7d835134d4e1 ("iommu/arm-smmu: Make
instance lookup robust"), virtio-iommu appears to have the same issue
where iommu_device_register() makes the IOMMU instance visible to other
API callers (including itself) straight away, but internally the
instance isn't ready to recognise itself for viommu_probe_device() to
work correctly until after viommu_probe() has returned. This matters a
lot more now that bus_iommu_probe() has the DT/VIOT knowledge to probe
client devices the way that was always intended. Tweak the lookup and
initialisation in much the same way as for arm-smmu, to ensure that what
we register is functional and ready to go.

Cc: stable@vger.kernel.org
Fixes: bcb81ac6ae3c ("iommu: Get DT/ACPI parsing into the proper probe path")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/308911aaa1f5be32a3a709996c7bd6cf71d30f33.1755190036.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/virtio-iommu.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -998,8 +998,7 @@ static void viommu_get_resv_regions(stru
 	iommu_dma_get_resv_regions(dev, head);
 }
 
-static const struct iommu_ops viommu_ops;
-static struct virtio_driver virtio_iommu_drv;
+static const struct bus_type *virtio_bus_type;
 
 static int viommu_match_node(struct device *dev, const void *data)
 {
@@ -1008,8 +1007,9 @@ static int viommu_match_node(struct devi
 
 static struct viommu_dev *viommu_get_by_fwnode(struct fwnode_handle *fwnode)
 {
-	struct device *dev = driver_find_device(&virtio_iommu_drv.driver, NULL,
-						fwnode, viommu_match_node);
+	struct device *dev = bus_find_device(virtio_bus_type, NULL, fwnode,
+					     viommu_match_node);
+
 	put_device(dev);
 
 	return dev ? dev_to_virtio(dev)->priv : NULL;
@@ -1160,6 +1160,9 @@ static int viommu_probe(struct virtio_de
 	if (!viommu)
 		return -ENOMEM;
 
+	/* Borrow this for easy lookups later */
+	virtio_bus_type = dev->bus;
+
 	spin_lock_init(&viommu->request_lock);
 	ida_init(&viommu->domain_ids);
 	viommu->dev = dev;
@@ -1229,10 +1232,10 @@ static int viommu_probe(struct virtio_de
 	if (ret)
 		goto err_free_vqs;
 
-	iommu_device_register(&viommu->iommu, &viommu_ops, parent_dev);
-
 	vdev->priv = viommu;
 
+	iommu_device_register(&viommu->iommu, &viommu_ops, parent_dev);
+
 	dev_info(dev, "input address: %u bits\n",
 		 order_base_2(viommu->geometry.aperture_end));
 	dev_info(dev, "page mask: %#llx\n", viommu->pgsize_bitmap);


