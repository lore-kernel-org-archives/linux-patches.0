Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57406FAF;
	Tue,  5 Dec 2023 03:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppMIUYaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40644C433C7;
	Tue,  5 Dec 2023 03:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746686;
	bh=/f1L5bBqnxPU4nruoiQA/8d8JQEXrUzFIgvqwKrzXYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppMIUYaEtByWzsXUtspUnGecC0wLttMOMtVA+2VtxQuL/m2trjnkBbXAcBGjLNpkC
	 5lo7YUqRRiPxtxkmYAqyZLRuQGTx3ajPW5acyRSb9oe33oidWwXx1/f64vQv5OgbNq
	 qc2uoFK+6MRANWUv2BD+0xYimR3BD0M0+Ug1tc18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/134] iommu/vt-d: Make context clearing consistent with context mapping
Date: Tue,  5 Dec 2023 12:16:31 +0900
Message-ID: <20231205031543.015073341@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 9a16ab9d640274b20813d2d17475e18d3e99d834 ]

In the iommu probe_device path, domain_context_mapping() allows setting
up the context entry for a non-PCI device. However, in the iommu
release_device path, domain_context_clear() only clears context entries
for PCI devices.

Make domain_context_clear() behave consistently with
domain_context_mapping() by clearing context entries for both PCI and
non-PCI devices.

Fixes: 579305f75d34 ("iommu/vt-d: Update to use PCI DMA aliases")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20231114011036.70142-4-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 18fa71aadc903..4c3707384bd92 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3923,8 +3923,8 @@ static int domain_context_clear_one_cb(struct pci_dev *pdev, u16 alias, void *op
  */
 static void domain_context_clear(struct device_domain_info *info)
 {
-	if (!info->iommu || !info->dev || !dev_is_pci(info->dev))
-		return;
+	if (!dev_is_pci(info->dev))
+		domain_context_clear_one(info, info->bus, info->devfn);
 
 	pci_for_each_dma_alias(to_pci_dev(info->dev),
 			       &domain_context_clear_one_cb, info);
-- 
2.42.0



