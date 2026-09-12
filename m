Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE0A472790;
	Sat, 12 Sep 2026 11:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210826; cv=none; b=HnYRMOwAVivw51xpGuAsFl+jh4Rf4inSravckFoGN8NHkQABPRUYQShO25b6gCXdyTfQbm9TowrKFJHUnUHsuuQgVviaGQtXC6YmF4uq0GQHSHvfbhhGeO1sRlRMBGy0EsTLoqbXU5nZMvngvfvdR7hISWUpwPHNN30pNXNwz2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210826; c=relaxed/simple;
	bh=A//1oNLNd+n0s0x4JAQOfgwFdG2PbhIjMU/MYcBY/CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0/y5DVmU7kYGq6d+VXoJe6CDN8k9FjleighmXdoVLZZo47a/5MteRjNx3td7/L18GSYoCikTUqyZNUJnLWDqjiiT2VwQaUor6Tt3MRPWWk/kS6pZ/8oTQHkECqwXbLI/k6u8meTcU9CCBPTMwzNsQWDAf4hPJcpdN04gr5tS54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwP7sGgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwP7sGgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0820D1F000FF;
	Sat, 12 Sep 2026 11:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210825;
	bh=TX6DVylv0ov8oV7F3WlEc++caCU2wgFCBKiaQ2+Bqoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwP7sGglpiQeYyWwBnEpKAU/YbAZMtT3lSu1RfDRHHCDzB2mJTida7zRfBxJu4qEt
	 KZJG/4IZb+rZDIc/nIaVQUvT2Q20GhsQbBKeHklQdpHOPJL8+r0+M2yBuo+eTs45Mc
	 kKO29teIaMZ/7ppo4d14uXL9Np+hoHI/nkfQQVlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1062/1518] iommu/dma: Restore locking around msi_page_list
Date: Sat, 12 Sep 2026 08:53:51 +0200
Message-ID: <20260912065647.474759069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <andrew.jones@oss.qualcomm.com>

[ Upstream commit 5a9e89ea34e0e34ac5d7e949042d665533549e40 ]

Unlike a group's default domain, which is always freshly allocated
and privately owned (iommu_group_alloc_default_domain()), VFIO type1's
legacy container merges any newly attached group into an existing
domain whenever their iommu_ops and cache-coherency enforcement match.

iommu_dma_get_msi_page() only asserts the caller's own group mutex is
held (iommu_group_mutex_assert()). On an IOMMU that publishes
IOMMU_RESV_SW_MSI, e.g. ARM SMMU, a VM with two such devices assigned
through the legacy container can have their guest drivers probe and
allocate MSIs in parallel; each host-side VFIO_DEVICE_SET_IRQS lands
on a different device fd and group mutex, but both devices' domains
are the same merged domain, so both can enter
iommu_dma_get_msi_page() concurrently and corrupt msi_page_list.

commit 288683c92b1a ("iommu: Make iommu_dma_prepare_msi() into a
generic operation") dropped the prior msi_prepare_lock on the
reasoning that "each iommu_domain is unique to a group," which holds
for default domains but not this VFIO type1 case. Restore the static
lock, since it's only guarding a corner case and will likely never
be contended.

iommufd avoids the equivalent problem by having its own callers
(iommufd_sw_map_msi()) take a ctx-wide sw_msi_lock before ever
reaching the shared list. VFIO type1 can't mirror that since it
dispatches to iommu_dma_sw_msi() which is outside VFIO's jurisdiction.

Fixes: 288683c92b1a ("iommu: Make iommu_dma_prepare_msi() into a generic operation")
Signed-off-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 3773984068684..039e84a452d77 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -2163,6 +2163,19 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 	dma_addr_t iova;
 	int prot = IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO;
 	size_t size = cookie_msi_granule(domain);
+	static DEFINE_MUTEX(msi_prepare_lock);
+
+	/*
+	 * Normally a device's default domain is only ever attached to that
+	 * device's own group, and the group mutex held by
+	 * iommu_group_mutex_assert()'s callers is enough on its own. A VFIO
+	 * type1 container is the one case that breaks that assumption: it
+	 * can merge devices from different groups onto one domain, so two
+	 * devices' group mutexes don't serialize each other here. A static
+	 * lock is sufficient due to the expectation that this is a corner
+	 * case that will never be contended in practice.
+	 */
+	guard(mutex)(&msi_prepare_lock);
 
 	msi_addr &= ~(phys_addr_t)(size - 1);
 	list_for_each_entry(msi_page, msi_page_list, list)
-- 
2.53.0



