Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447E22144C1;
	Wed,  7 May 2025 19:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644954; cv=none; b=Kr8ImuNf4oxgx4wS24VG1L0xCPLq6NQmkUtQ5yCSAkU3fSdF4BFK07PaLZV9zTpkb4odP5GnxcGNu2YYMJpjKlnmJHxSloVEro8etG+3he68WwlCaXnNxagYF6O4gkBoxAkIcGiaMSYbbA8pyfTu847yAZFUdIQP9ec9ZV0E6FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644954; c=relaxed/simple;
	bh=L+0qLxX0Phso5ZrUsELYM1FCnnYuS98Vx8AgNaRkMU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAy6b6LJoQapKxA22SEKXQz7DFIt1VEkXIx/TMFr1/oY7E4Ul9G2FHBMsq+QHURfqJgq8IYzDAd6dVqVIHj9lUum7zr8QukOMVboBl6eYrMcZx+HVRD3zltHafyLrqu644177Y+kZByAUZuzVylIgchcPT7lfFbhg3c4wcB1OgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTP7x5Tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTP7x5Tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BABC4CEE2;
	Wed,  7 May 2025 19:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644954;
	bh=L+0qLxX0Phso5ZrUsELYM1FCnnYuS98Vx8AgNaRkMU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTP7x5TmMRlPRSCsn30PnzbpF6clFF7QQORaMHjmjO3m/P9etYU5yG+SAXxr40J4m
	 8XMw0cYXSS0itisTE0o1bv008iJL0zg4/87c1jQwBkbujftzVjrVGt1aRLUGp0Zo06
	 9nnrGXpnT3xa212GjoYB9cCdH/vYQ4WGMuMyYKck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.6 046/129] iommu: Handle race with default domain setup
Date: Wed,  7 May 2025 20:39:42 +0200
Message-ID: <20250507183815.404972824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 drivers/iommu/iommu.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -566,6 +566,18 @@ int iommu_probe_device(struct device *de
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
+		if (!dev->iommu_group->default_domain &&
+		    !dev_iommu_ops(dev)->set_platform_dma_ops)
+			ret = -EPROBE_DEFER;
+		mutex_unlock(&dev->iommu_group->mutex);
+	}
 	if (ret)
 		return ret;
 
@@ -3149,6 +3161,12 @@ int iommu_device_use_default_domain(stru
 		return 0;
 
 	mutex_lock(&group->mutex);
+	/* We may race against bus_iommu_probe() finalising groups here */
+	if (IS_ENABLED(CONFIG_IOMMU_DMA) && !group->default_domain &&
+	    !dev_iommu_ops(dev)->set_platform_dma_ops) {
+		ret = -EPROBE_DEFER;
+		goto unlock_out;
+	}
 	if (group->owner_cnt) {
 		if (group->owner || !iommu_is_default_domain(group) ||
 		    !xa_empty(&group->pasid_array)) {


