Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56732528EC;
	Tue, 29 Apr 2025 18:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950809; cv=none; b=u/vE3Q8y5WT3HhvBsccTcDVmahpED1ayYNapcdW4k997jW8J6vlTborbItvmMCitGdOhLyydT6NFpDpNJagl1Wp9+fw5m2DjMovHZWK0PATc65k2ZRd4Szhoqmi5XnzcXV2TxNUpVyhoQp+3c+7ijujdfdlxQfv4DMUPHEKy6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950809; c=relaxed/simple;
	bh=BjD3zS6aQFG7qMJt0amkyc7E1dn5T0BHFq+IKC6yZLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGSoyA4zeu5Y9wdm1pnjJ9P611IgLmG9i9Ra0sSeue/sHwA0/+r6dhqPeorCA6A6I54ggwpfBmvt83YjUhMPX2fp1CsTBxQm0FdCqcGlhp5ayOiHMcqq0woMaIl0xiArnbTk6zrZ+tqybHiuXaVMUaQr0VVEbeZqqjBr2S+Ud0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fs+B+/xN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fs+B+/xN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CEBC4CEE3;
	Tue, 29 Apr 2025 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950809;
	bh=BjD3zS6aQFG7qMJt0amkyc7E1dn5T0BHFq+IKC6yZLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fs+B+/xNFjM4xl0Yqml0Vlw4+J8TsLyDjzVICalk+O+88aMQWslGqLmDNNyTDHHCE
	 Gq0sHeDPVqyileLiSkc2TSgewphuuCS4+6cUGN2Li0K8UZCuWTfikUOvJDULtkvtUC
	 6M2ZGG+IDKULeuowTFDk8l+4Vru1u+vII6xfn0zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.6 200/204] iommu: Handle race with default domain setup
Date: Tue, 29 Apr 2025 18:44:48 +0200
Message-ID: <20250429161107.563971924@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

commit b46064a18810bad3aea089a79993ca5ea7a3d2b2 upstream.

It turns out that deferred default domain creation leaves a subtle
race window during iommu_device_register() wherein a client driver may
asynchronously probe in parallel and get as far as performing DMA API
operations with dma-direct, only to be switched to iommu-dma underfoot
once the default domain attachment finally happens, with obviously
disastrous consequences. Even the wonky of_iommu_configure() path is at
risk, since iommu_fwspec_init() will no longer defer client probe as the
instance ops are (necessarily) already registered, and the "replay"
iommu_probe_device() call can see dev->iommu_group already set and so
think there's nothing to do either.

Fortunately we already have the right tool in the right place in the
form of iommu_device_use_default_domain(), which just needs to ensure
that said default domain is actually ready to *be* used. Deferring the
client probe shouldn't have too much impact, given that this only
happens while the IOMMU driver is probing, and thus due to kick the
deferred probe list again once it finishes.

Reported-by: Charan Teja Kalla <quic_charante@quicinc.com>
Fixes: 98ac73f99bc4 ("iommu: Require a default_domain for all iommu drivers")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/e88b94c9b575034a2c98a48b3d383654cbda7902.1740753261.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -566,6 +566,17 @@ int iommu_probe_device(struct device *de
 	mutex_lock(&iommu_probe_device_lock);
 	ret = __iommu_probe_device(dev, NULL);
 	mutex_unlock(&iommu_probe_device_lock);
+
+	/*
+	 * The dma_configure replay paths need bus_iommu_probe() to
+	 * finish before they can call arch_setup_dma_ops()
+	 */
+	if (IS_ENABLED(CONFIG_IOMMU_DMA) && !ret && dev->iommu_group) {
+		mutex_lock(&dev->iommu_group->mutex);
+		if (!dev->iommu_group->default_domain)
+			ret = -EPROBE_DEFER;
+		mutex_unlock(&dev->iommu_group->mutex);
+	}
 	if (ret)
 		return ret;
 
@@ -3149,6 +3160,11 @@ int iommu_device_use_default_domain(stru
 		return 0;
 
 	mutex_lock(&group->mutex);
+	/* We may race against bus_iommu_probe() finalising groups here */
+	if (IS_ENABLED(CONFIG_IOMMU_DMA) && !group->default_domain) {
+		ret = -EPROBE_DEFER;
+		goto unlock_out;
+	}
 	if (group->owner_cnt) {
 		if (group->owner || !iommu_is_default_domain(group) ||
 		    !xa_empty(&group->pasid_array)) {


