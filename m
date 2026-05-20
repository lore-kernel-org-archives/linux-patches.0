Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4BA3F8707;
	Wed, 20 May 2026 18:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300655; cv=none; b=Ew2XJgPYdtnnomR4JeommYJLp7SHtH5uugUIt1awoEn64Bt7Vl9hMTuVOUP0ROZb+CIpS/w7B/A1y8ssRfPcJlWmzgt95C9RcVsAfy5AeE5PwUXoaUC23ZKfcmfSl+CPb3D/FuoXSpJ2ZYbMxVVNy9lZuoaJWPVaoaJWcEAIiKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300655; c=relaxed/simple;
	bh=tEf6ogrzbu5AV0ONF5dWYUUhlfK8tliZANX710htPuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGEu7XxnjsymXk6x+PgA0YjVbfWBJznvJ7hHVvlKg8OWW+zFpcB/rJiVZb9sAwlINGCpRUCvhY7nSFmFvpyJdc4aymIukh5y9LIO+eDZxW5gm+DADKDEMBLDt6Fuq3cRFbZbIoWzXVrdY3s3KCne9LGURqSrHX2pqHF6Ad4U4fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOq0iDiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOq0iDiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A271F00894;
	Wed, 20 May 2026 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300653;
	bh=UZaRHUJEiwIYjde1l2AK0NfJUtyBnWGj8tJBAztR1Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOq0iDiY1AFpaSkjrMDbu9V8444tXRgu4hKGzNJWo5f3vuqXHOqBdLMUVG+aW3gAo
	 5+7v8wV6HbD2l9+CxmAYYNVFAdKuGbzO70+D+9t3GLxtTjaNpGaKeSie7NmWjAPZXX
	 mUalbHPLNYfrto4ymKq5ngGLmCFoaJC796GvQss8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/666] iommu/amd: Fix clone_alias() to use the original devices devid
Date: Wed, 20 May 2026 18:17:07 +0200
Message-ID: <20260520162115.891053190@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3e28aefdc6a02..a5adc4714f5c9 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -382,11 +382,12 @@ static struct iommu_dev_data *search_dev_data(struct amd_iommu *iommu, u16 devid
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
 
@@ -433,9 +434,9 @@ static void clone_aliases(struct amd_iommu *iommu, struct device *dev)
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



