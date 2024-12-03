Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506BA1F7070;
	Tue,  3 Dec 2024 15:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238923; cv=none; b=UOc6V21B5WzES2G4UlZ6+O50yKtM90+fiZDxUkfYPYoAloYDj+DD/4/x0ScgWTZojjBdmv3tQLgvQx1YXRp0ujZFgKKPod95g6LfAvfnlBcuwRIjt0gol83K1bZONsQuX/GRabh4tmiqZ0d6BxzMxsNO2hptsRXOZQoIapXjX9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238923; c=relaxed/simple;
	bh=dCGyrrf8QD5GWV2/xiZQ7VCNUVMcEY63Lwzn5TgZky8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItUnIzhnaWAtfYxjE8MriAwWWO8m0CaHuz1+rnixxWzQ958K/+7JKwFIjLFALPvH6SojuXunLn4JtvzmDhg14hheAxPfexa1Je8kTpT1m+OtXQ/I7cVDNpMULc1dxiVuaAlDeGpijgMZ0Glxsb5RTDxTrdaNBKaV+WffGu9OBUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llV7qFmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llV7qFmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD066C4CECF;
	Tue,  3 Dec 2024 15:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238923;
	bh=dCGyrrf8QD5GWV2/xiZQ7VCNUVMcEY63Lwzn5TgZky8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llV7qFmS3GXcbf5o6wTnUtWdVNp/G+p8tjRyVQADM0sG2NAlSOTaY5JI0gNL7bpn6
	 vJvjrVdmE8AQotKAZNvJrWQtvb5d0IbrHY5flBcx0GMCNM3pov8RIevBPHrHj3KP2J
	 l/eFf/2Nigb4obu2YEmqUWmqKPNgImgqcaf8ZpP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 412/817] iommu/amd/pgtbl_v2: Take protection domain lock before invalidating TLB
Date: Tue,  3 Dec 2024 15:39:44 +0100
Message-ID: <20241203144011.962042776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 016991606aa01c4d92e6941be636c0c897aa05c7 ]

Commit c7fc12354be0 ("iommu/amd/pgtbl_v2: Invalidate updated page ranges
only") missed to take domain lock before calling
amd_iommu_domain_flush_pages(). Fix this by taking protection domain
lock before calling TLB invalidation function.

Fixes: c7fc12354be0 ("iommu/amd/pgtbl_v2: Invalidate updated page ranges only")
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241030063556.6104-2-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index afa5844495ca8..2c5db78065113 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -268,8 +268,11 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 out:
 	if (updated) {
 		struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
+		unsigned long flags;
 
+		spin_lock_irqsave(&pdom->lock, flags);
 		amd_iommu_domain_flush_pages(pdom, o_iova, size);
+		spin_unlock_irqrestore(&pdom->lock, flags);
 	}
 
 	if (mapped)
-- 
2.43.0



