Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC7374C4;
	Tue,  8 Apr 2025 11:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110838; cv=none; b=FN4mS+DBCKrvJs2ca/VHOd5A5dlwvFdd5pn4noqAjvhG01S89tNc6ukB8HRVKsnQUk897Xpedjwue4PjG2g6P+dro1Mu9pUiKoo7JpKD6mbxDbuau3y1o9pRl3xb/9VNNqQfG87r9Cjpj+XmY6+dJO4trLVtN1AJgXo/s6/ZZ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110838; c=relaxed/simple;
	bh=IPF/lt6RHQxzM0haJEHO90BdpL/CuiVYtPKgHE+JxIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuWg0H33R0QTWhQdkTgwwHWNzjIHzf7W4XDq+Wpm0VGD3l3mzqVhNKZvaI93i5ZxyUR+4t/BYmvQ53mBJeYN/Q4uIW6Ifi2rGOqmBq24jmXtRSNqM9GjUUldtneVTxFw6TE3pIij0uzHIq+naF8SL/EDqhbhiASIDjMdUg1rPqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFAvb9so; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFAvb9so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6477EC4CEE5;
	Tue,  8 Apr 2025 11:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110838;
	bh=IPF/lt6RHQxzM0haJEHO90BdpL/CuiVYtPKgHE+JxIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFAvb9sotBMTqJwkGRBbfQ9bE6Phjz0E8PhshJn4IqriypzeXQ7wCJ1OLe2mjt0rR
	 0wMK71OwJcS6KGUY9+3l9KHaiq5zhNHfeKIZT/JwL0h3dM0tjT9NTiu1tMVa1fCdvc
	 Nnb5VUP/fqxyLKxUhWLaReL7MUNg+NlPFo86+nUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 174/731] iommu: Handle race with default domain setup
Date: Tue,  8 Apr 2025 12:41:11 +0200
Message-ID: <20250408104918.323333954@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit b46064a18810bad3aea089a79993ca5ea7a3d2b2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 60aed01e54f27..e3df1f06afbeb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3097,6 +3097,11 @@ int iommu_device_use_default_domain(struct device *dev)
 		return 0;
 
 	mutex_lock(&group->mutex);
+	/* We may race against bus_iommu_probe() finalising groups here */
+	if (!group->default_domain) {
+		ret = -EPROBE_DEFER;
+		goto unlock_out;
+	}
 	if (group->owner_cnt) {
 		if (group->domain != group->default_domain || group->owner ||
 		    !xa_empty(&group->pasid_array)) {
-- 
2.39.5



