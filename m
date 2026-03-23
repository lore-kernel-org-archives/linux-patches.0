Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8303E286417;
	Mon, 23 Mar 2026 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275041; cv=none; b=ex2D6hDeKP0z0CrcoCNbQ6LfWB4jeQpLCGyVliOGCXUU5TxE88P/9LJs3hrQ/FITK9yXiDy4DwbqLmG6wXhQSmKAp2iLsZCqiVFqPi3auitNi0HyTXYm2yFEBnq6kzg+k5b4hpwXHLXNXfwET3dlNcVtyXM0A7wez1FJfXO26/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275041; c=relaxed/simple;
	bh=guCbcVhY/clzBgURMbmNrP2yFcLyziaFYmnKtOT+AfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVgrEuCyBGqVXVcAu9TH5kmuaN3xELqLvumYwOyS9CKwF2Lya/K5KqqmRxD0oO2K0HFot6JMxaT2X2iS83PtwHIOU7b1BD84nrChiZT9AyLvEnCDmWFoqp2QVWJhtvoJGoeyH9IGqwXUROgExpDyKgpl2UhrHJzFRvJMriw46zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDrh3Z6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDrh3Z6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AC8C4CEF7;
	Mon, 23 Mar 2026 14:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275041;
	bh=guCbcVhY/clzBgURMbmNrP2yFcLyziaFYmnKtOT+AfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDrh3Z6hAMy1joOuWEpxFYHFBB2LSg1auVEDju5CE9G0Sv6SFtJy28rtLFL/LbH7T
	 3QRu7FA29tb6ZVTMLygglZL95QydxwwZfIcq4RGQhoi67a9VqE02BniGax6xv7E+8j
	 geHK3ab+rUTYOfGqtIdDjMFOaQLAUQjYmteh8rc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/212] iommu/sva: Fix crash in iommu_sva_unbind_device()
Date: Mon, 23 Mar 2026 14:47:02 +0100
Message-ID: <20260323134510.141122535@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 06e14c36e20b48171df13d51b89fe67c594ed07a ]

domain->mm->iommu_mm can be freed by iommu_domain_free():
  iommu_domain_free()
    mmdrop()
      __mmdrop()
        mm_pasid_drop()
After iommu_domain_free() returns, accessing domain->mm->iommu_mm may
dereference a freed mm structure, leading to a crash.

Fix this by moving the code that accesses domain->mm->iommu_mm to before
the call to iommu_domain_free().

Fixes: e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries for kernel address space")
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu-sva.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index e1e63c2be82b2..fd735aaae9e3f 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -182,13 +182,13 @@ void iommu_sva_unbind_device(struct iommu_sva *handle)
 	iommu_detach_device_pasid(domain, dev, iommu_mm->pasid);
 	if (--domain->users == 0) {
 		list_del(&domain->next);
-		iommu_domain_free(domain);
-	}
+		if (list_empty(&iommu_mm->sva_domains)) {
+			list_del(&iommu_mm->mm_list_elm);
+			if (list_empty(&iommu_sva_mms))
+				iommu_sva_present = false;
+		}
 
-	if (list_empty(&iommu_mm->sva_domains)) {
-		list_del(&iommu_mm->mm_list_elm);
-		if (list_empty(&iommu_sva_mms))
-			iommu_sva_present = false;
+		iommu_domain_free(domain);
 	}
 
 	mutex_unlock(&iommu_sva_lock);
-- 
2.51.0



