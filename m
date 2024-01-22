Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5CD7E560;
	Tue, 23 Jan 2024 02:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975737; cv=none; b=hvUhasvGiDqT4CemI6RR9eM/1tkTAzgtXhpM4+5Kmb9MOpplqu7iWjYwK2IjvUJK3ga5JBJdNvaEmcOhcQvavTUAS2XlHsUz7dYvcW7PnKxVaCDHbCzAcCQrlriUhi/Q7iKJJva2hmkfqRa+7/4kpw65V3PGXQQHLrPeyvv+Unc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975737; c=relaxed/simple;
	bh=MJpWfcsQRfy1Wi2m/mXLdTzu91yTcaucPTRtUj1if34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZTsZGNoT+xpwKIjxmBLb5FtyKfZ10W3Hylp014DMyawIw/BZaAXFqp4I9l5BVNIL7hJVjngV+TiVorD0P/5AIMb1vwxAb7evFcmyDrJT0QXhGKfZKCiYh9pwkXMlTch57QwKx5fTfh8F4GVc5SctU18wWJx8b1JM4S69/ZIYgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiSc9mWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiSc9mWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404FAC433C7;
	Tue, 23 Jan 2024 02:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975737;
	bh=MJpWfcsQRfy1Wi2m/mXLdTzu91yTcaucPTRtUj1if34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiSc9mWAtitZ2X1hWeIffT6DE0UaE2sy9zzHLsy766Iq7OpwvKUYx0nFUNi9RJbL2
	 0rH/P7eb2JwEJT/ZSlywiN31gyT4yF6iJiUKYxpFKzJ3Z/bdMhZY73iJOJZsMRKWIC
	 oYY9sMDYMJF0GPEJphI3GYUCjB08DQyQkNCkQng8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Mhetre <amhetre@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 499/583] iommu: Dont reserve 0-length IOVA region
Date: Mon, 22 Jan 2024 15:59:10 -0800
Message-ID: <20240122235827.308394680@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Mhetre <amhetre@nvidia.com>

[ Upstream commit bb57f6705960bebeb832142ce9abf43220c3eab1 ]

When the bootloader/firmware doesn't setup the framebuffers, their
address and size are 0 in "iommu-addresses" property. If IOVA region is
reserved with 0 length, then it ends up corrupting the IOVA rbtree with
an entry which has pfn_hi < pfn_lo.
If we intend to use display driver in kernel without framebuffer then
it's causing the display IOMMU mappings to fail as entire valid IOVA
space is reserved when address and length are passed as 0.
An ideal solution would be firmware removing the "iommu-addresses"
property and corresponding "memory-region" if display is not present.
But the kernel should be able to handle this by checking for size of
IOVA region and skipping the IOVA reservation if size is 0. Also, add
a warning if firmware is requesting 0-length IOVA region reservation.

Fixes: a5bf3cfce8cb ("iommu: Implement of_iommu_get_resv_regions()")
Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20231205065656.9544-1-amhetre@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/of_iommu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index 47302b637cc0..42cffb0ee5e2 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -264,6 +264,10 @@ void of_iommu_get_resv_regions(struct device *dev, struct list_head *list)
 					prot |= IOMMU_CACHE;
 
 				maps = of_translate_dma_region(np, maps, &iova, &length);
+				if (length == 0) {
+					dev_warn(dev, "Cannot reserve IOVA region of 0 size\n");
+					continue;
+				}
 				type = iommu_resv_region_get_type(dev, &phys, iova, length);
 
 				region = iommu_alloc_resv_region(iova, length, prot, type,
-- 
2.43.0



