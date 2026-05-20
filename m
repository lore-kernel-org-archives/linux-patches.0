Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D733C870E;
	Wed, 20 May 2026 17:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298134; cv=none; b=dKvTrnFoIIFycPtu846LZrEe6v+ApYnHEsHg9BPeyvUqaRtRfIEVGZ1w1ABxwjDKtYZjryj4hQ3fQ2Xd8kBZbycJ9YZlZuP2n6vzKVx/+08hwTfX1YwlYNBUZhVWvv/F7/8wr9ZLJc8IYc9MP/IT73aSmLgR52rwsgaB+dfqbik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298134; c=relaxed/simple;
	bh=9JVDEeTqHJy9azlKZRnYQD1bUvMJBVvXSFTHA7Mrke8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyQOkdSt5/tuexilVE4OvzotIsmvFD8q3OtbSmRhZH4Mt3+5Yjvrr/kYVLUXP5HSs78hfJpXAVArC1i8nKumpCD7g2IxpXCrM1ew/kpRsYdloU25miocRGGzT4ZIhTDcm4FaUgbRpeUhoC5WdJKStNGIkSpuSgQ1VwL3ynCePvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/dlaBZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/dlaBZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260DB1F000E9;
	Wed, 20 May 2026 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298133;
	bh=cFb3UQk623rhhmMlZULpKUpHevfv8QacbPoukC10ifw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/dlaBZtotqh5CDPXlM5KME33xwroLQQK6ebFWW+2ZmWr/7LkX8bSirz1lZ9QdRxK
	 T9oonOlFEj0CQWAzU8g7FGyUFsIBIBBGg6v6oAqGW1TiBGxV++ht0Xj9bsp0uXieWJ
	 3AE06TRYAbBojdfgtOIh5o8KrU6yCnDENCPGuuTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 294/957] iommu/amd: Fix clone_alias() to use the original devices devid
Date: Wed, 20 May 2026 18:12:57 +0200
Message-ID: <20260520162140.912535079@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit faad224fe0f0857a04ff2eb3c90f0de57f47d0f3 ]

Currently clone_alias() assumes first argument (pdev) is always the
original device pointer. This function is called by
pci_for_each_dma_alias() which based on topology decides to send
original or alias device details in first argument.

This meant that the source devid used to look up and copy the DTE
may be incorrect, leading to wrong or stale DTE entries being
propagated to alias device.

Fix this by passing the original pdev as the opaque data argument to
both the direct clone_alias() call and pci_for_each_dma_alias(). Inside
clone_alias(), retrieve the original device from data and compute devid
from it.

Fixes: 3332364e4ebc ("iommu/amd: Support multiple PCI DMA aliases in device table")
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4beef73139611..5afd1621d715e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -381,11 +381,12 @@ struct iommu_dev_data *search_dev_data(struct amd_iommu *iommu, u16 devid)
 	return NULL;
 }
 
-static int clone_alias(struct pci_dev *pdev, u16 alias, void *data)
+static int clone_alias(struct pci_dev *pdev_origin, u16 alias, void *data)
 {
 	struct dev_table_entry new;
 	struct amd_iommu *iommu;
 	struct iommu_dev_data *dev_data, *alias_data;
+	struct pci_dev *pdev = data;
 	u16 devid = pci_dev_id(pdev);
 	int ret = 0;
 
@@ -432,9 +433,9 @@ static void clone_aliases(struct amd_iommu *iommu, struct device *dev)
 	 * part of the PCI DMA aliases if it's bus differs
 	 * from the original device.
 	 */
-	clone_alias(pdev, iommu->pci_seg->alias_table[pci_dev_id(pdev)], NULL);
+	clone_alias(pdev, iommu->pci_seg->alias_table[pci_dev_id(pdev)], pdev);
 
-	pci_for_each_dma_alias(pdev, clone_alias, NULL);
+	pci_for_each_dma_alias(pdev, clone_alias, pdev);
 }
 
 static void setup_aliases(struct amd_iommu *iommu, struct device *dev)
-- 
2.53.0



