Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D2E27781E;
	Tue, 12 Aug 2025 19:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025925; cv=none; b=gwwVHPKhzhQ6RWvH5N6uxz9No7UW63VeVgLzUsSuXi1PYIDHrp+HNynlkU/TQ/VzPkfWH8x0b2Y8pJ/WL/AIS6orUQ+4CkY2pRCwIoSiesI67oi9vprczKv2MSSAuB2Eap7jr51pJG7jHd2t8BmPlG70kcPogAqsugTVznK0cV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025925; c=relaxed/simple;
	bh=3iZH1ZNfO90KH1rqcqeAVwlxcoFJXwibw/iCxRBDweU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTFMtTU0RwnKyNqu5UPejeLQWAvkCjXSn1AY/HUooXP1iqu9XIPCwWm7cNiWd1YCSDNXkzgzhcOHFzP6QiowFz+xtei0f0lSL5eHRq3NmeHbbD3bB2B33auEzxwIoRDY/i5KreKJNxiBT5en35WsWswCazkbCWZXDiVpEUUWnZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLtce+jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLtce+jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAAEC4CEF0;
	Tue, 12 Aug 2025 19:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025924;
	bh=3iZH1ZNfO90KH1rqcqeAVwlxcoFJXwibw/iCxRBDweU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLtce+jktz5rWOfaiL2Da0KyRntEbXXuVY70NlHfPD7QVB97zEfl/7CuQV4oqRSmK
	 i0QZCMjJLjbw7rrwWgpJBEuJtQpTfVONddHCRziIcPvNidsNmGc8sRzYh99N7NzyWZ
	 QrQI+Pb4m8FDeA7jn3os0fl0757tkqsEQAO5Qt5g=
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
Subject: [PATCH 6.15 152/480] iommu/amd: Enable PASID and ATS capabilities in the correct order
Date: Tue, 12 Aug 2025 19:46:00 +0200
Message-ID: <20250812174403.785561538@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 31f8d208dedb..cef1d2400d47 100644
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



