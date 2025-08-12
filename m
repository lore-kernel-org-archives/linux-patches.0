Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609362FD1AD;
	Tue, 12 Aug 2025 18:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023992; cv=none; b=j1QRm5P3RMhZbGsGRkTbAa27DwkvvJUeldAm21rJBXjAovzKWpvzrefPXZ2B2K6ZO30vrLxGbgI4kbXu7DCPQ0ttQE9CCBsgk4RsUa39V7SW2rL700yVcWIXOQy7OjOlMz2Ezi90yPWqVNBNX+KpBI7BKT3D06OFCAkTSqHXnPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023992; c=relaxed/simple;
	bh=NDVw7GgWqO/wyQlYjIhIUVxMdrRZYJYXuXBTRcRu9Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUQPGWs98zIcbe9PlrqBDQSRyOE2BwkPY6hx7P+6aC3isLE7SuCGUh42Kwek3iQHWh43fy7+fkARs1+NEDxmGu6cc2Iy068pI1L5jw+FmKmwIb0YdO7NBoXDfFAOHROhmDDS0jNNN9bAbnUJgx4gESxbWE786+VIiDTiVSRunDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8iQBrwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8iQBrwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE702C4CEF0;
	Tue, 12 Aug 2025 18:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023992;
	bh=NDVw7GgWqO/wyQlYjIhIUVxMdrRZYJYXuXBTRcRu9Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8iQBrwKN7B3znMNTmUH1Ge3k8PlWPnLNSkhjlAu1dD/XAgoQPzYR0QSvMxSK3x5Y
	 Y/1Gp7R22swWONGwglHc7EvJHHVAXFLdDIbZSwydZDkMGUt8PGgqrUV8kMiJ0Wozhl
	 R5tjVhkU5JrTzC+FwY1qGLM/bvSl9MfufD2oggP4=
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
Subject: [PATCH 6.16 208/627] iommu/amd: Enable PASID and ATS capabilities in the correct order
Date: Tue, 12 Aug 2025 19:28:23 +0200
Message-ID: <20250812173427.194086906@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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
index 3117d99cf83d..8b8d3e843743 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -634,8 +634,8 @@ static inline void pdev_disable_cap_pasid(struct pci_dev *pdev)
 
 static void pdev_enable_caps(struct pci_dev *pdev)
 {
-	pdev_enable_cap_ats(pdev);
 	pdev_enable_cap_pasid(pdev);
+	pdev_enable_cap_ats(pdev);
 	pdev_enable_cap_pri(pdev);
 }
 
-- 
2.39.5



