Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21EE305E08;
	Tue, 12 Aug 2025 18:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022282; cv=none; b=YiOgQ0T6c68OolHKcUO0B863m4UnyCa0QURYxoOTwn07HMyLHSu3KUiL52YdaPeyV37KztOXqrOGBUm7GAuKbkyMiz83AaRqHCcJUdwUmZeL+G82mkKu421z2CcnrSe+f7SZaCfGuzOebv2hy67KfFV06ajIOFqCVnYdkCVMK2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022282; c=relaxed/simple;
	bh=7i8jc7EtDPqPkbh3/W523U8sKx379lJgDR6Yvzjxo04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOOYHFbSBpIWPuNJf+ap3k6/cr2rBTNvgYypvVVeDehCX9Y25Md17w28yhDZkDmgG5w8pSyZsLmK8l6o3v0+qoVHJnwZm4WrEkbHSObceMykpq4cWVRUpO0C/Y+AI9QEsr5S/A+t5Jsm92N6KwGvbMp696K6eRQU0gvHGA7ghpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDtAcOhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDtAcOhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F8EC4CEF0;
	Tue, 12 Aug 2025 18:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022282;
	bh=7i8jc7EtDPqPkbh3/W523U8sKx379lJgDR6Yvzjxo04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDtAcOhLTiKKsOIFy+YJxQcBfDMZkdckZfYlmVyMEhaqrRHaOdEay29Ax3inRz5VL
	 m0ATb79kKjl8AKchGO3tsb9xH3PBmGQU+ByXzXOCZbknycxWwSmmNDct4GFGE4YZt0
	 fOTlHnmII7fVaksEDJ+ABqpJKD9Om0hd/1tsM8pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/369] iommu/amd: Enable PASID and ATS capabilities in the correct order
Date: Tue, 12 Aug 2025 19:26:39 +0200
Message-ID: <20250812173018.612146413@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Easwar Hariharan <eahariha@linux.microsoft.com>

[ Upstream commit c694bc8b612ddd0dd70e122a00f39cb1e2e6927f ]

Per the PCIe spec, behavior of the PASID capability is undefined if the
value of the PASID Enable bit changes while the Enable bit of the
function's ATS control register is Set. Unfortunately,
pdev_enable_caps() does exactly that by ordering enabling ATS for the
device before enabling PASID.

Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Fixes: eda8c2860ab679 ("iommu/amd: Enable device ATS/PASID/PRI capabilities independently")
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250703155433.6221-1-eahariha@linux.microsoft.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 23e78a034da8..e315e3045a3d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -483,8 +483,8 @@ static inline void pdev_disable_cap_pasid(struct pci_dev *pdev)
 
 static void pdev_enable_caps(struct pci_dev *pdev)
 {
-	pdev_enable_cap_ats(pdev);
 	pdev_enable_cap_pasid(pdev);
+	pdev_enable_cap_ats(pdev);
 	pdev_enable_cap_pri(pdev);
 }
 
-- 
2.39.5



