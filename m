Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5E83BA235;
	Mon, 23 Mar 2026 14:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274405; cv=none; b=RreR4j8e5P3og2Ek521C1vEy3tIYPuBrtrrDjDGqkDomuIehXO/xTpi3tNBPI0YsEBExz2okxh80QaLHx5egbo9FXBAvYvvPT/1oOf14i8GogrMbmij0B2Qx1MmHAcVglf+tVSHEOrocI5kKL7XBnOrBYDt7Oxv1d4mrbtdj+Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274405; c=relaxed/simple;
	bh=UB2QMPaWYzT0kzkyfhKdLS3nUGijDQkfZKvz1u+uIS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAVcbD5LTCgldiIvu2RQGzM2PsS0eLg6gs2qoM6doRYu915hycu6iPWzjd7N/70FHBAtyDNaHXNCLRF+4jzQizdZp+Ok6KNA3XLH5O0HsRxORxQM+e9ShNHVYQxb9uS0sQlzQ5vlYM4cdX/5cggWxs90aqhBBWAugd6xr3vPITI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHGrFLDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHGrFLDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F376C4CEF7;
	Mon, 23 Mar 2026 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274405;
	bh=UB2QMPaWYzT0kzkyfhKdLS3nUGijDQkfZKvz1u+uIS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHGrFLDOB69AbIWAlm6yK244RYp/AxfkMjVoa0IhlLWf59bNkioL8QWM4gp96XNnI
	 5OvAusXYLU8kFZaor4K7CRtaF/8Hug1DbhnWWbepe5bHO0sGOV1z4RDat0DdiCUhY3
	 ZeILr0u8wNvDMjmExTuPcrT+3M1koQluyjFuwiVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 206/220] iommu: Fix mapping check for 0x0 to avoid re-mapping it
Date: Mon, 23 Mar 2026 14:46:23 +0100
Message-ID: <20260323134511.073155680@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 0a4d00e2e99a39a5698e4b63c394415dcbb39d90 ]

Commit 789a5913b29c ("iommu/amd: Use the generic iommu page table")
introduces the shared iommu page table for AMD IOMMU. Some bioses
contain an identity mapping for address 0x0, which is not parsed
properly (e.g., certain Strix Halo devices). This causes the DMA
components of the device to fail to initialize (e.g., the NVMe SSD
controller), leading to a failed post.

Specifically, on the GPD Win 5, the NVME and SSD GPU fail to mount,
making collecting errors difficult. While debugging, it was found that
a -EADDRINUSE error was emitted and its source was traced to
iommu_iova_to_phys(). After adding some debug prints, it was found that
phys_addr becomes 0, which causes the code to try to re-map the 0
address and fail, causing a cascade leading to a failed post. This is
because the GPD Win 5 contains a 0x0-0x1 identity mapping for DMA
devices, causing it to be repeated for each device.

The cause of this failure is the following check in
iommu_create_device_direct_mappings(), where address aliasing is handled
via the following check:

```
phys_addr = iommu_iova_to_phys(domain, addr);
if (!phys_addr) {
        map_size += pg_size;
        continue;
}
````

Obviously, the iommu_iova_to_phys() signature is faulty and aliases
unmapped and 0 together, causing the allocation code to try to
re-allocate the 0 address per device. However, it has too many
instantiations to fix. Therefore, use a ternary so that when addr
is 0, the check is done for address 1 instead.

Suggested-by: Robin Murphy <robin.murphy@arm.com>
Fixes: 789a5913b29c ("iommu/amd: Use the generic iommu page table")
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2ca990dfbb884..3a0c0e4b42fff 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1207,7 +1207,11 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
 			if (addr == end)
 				goto map_end;
 
-			phys_addr = iommu_iova_to_phys(domain, addr);
+			/*
+			 * Return address by iommu_iova_to_phys for 0 is
+			 * ambiguous. Offset to address 1 if addr is 0.
+			 */
+			phys_addr = iommu_iova_to_phys(domain, addr ? addr : 1);
 			if (!phys_addr) {
 				map_size += pg_size;
 				continue;
-- 
2.51.0



