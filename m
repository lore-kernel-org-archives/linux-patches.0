Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D543B7767;
	Sat, 17 Oct 2026 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258754; cv=none; b=KFcEwOc5Ef2H/r0jQ4ESAHMHqlz5oyg6OuC6M91UB0xlp+YTJI5Srlc2yuRgbHLIUj6tJ4AICFR7zTluiA0YTT3jXFXeVvqFk+EoP/7BX+xZQJWcZvCefyYbFjv1Hn+TtIXun6b1qXK+HNIlH5v32xyj/ek+I1Qdn+7xb/xW9IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258754; c=relaxed/simple;
	bh=VubfvyBgWOjSHEmRdeYzbynbXa8OYw8CzKj1p9zYxrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIEiYmpvBNPDn1QHZCN7avT9dCwMfib6z175B4xT+8E5RYqTmO3u/lf8fPDuO8vflYZqnorAu+mu/EPm9Z25n+VESFTfKIqV1dsYJhQERVEQSHRF4rAuN3uYqtLY1JkSYyl4+zrPISLfqyLZ8Pfy5g9LYyF3g1oOCxGDE0ENtgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9Czby7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9Czby7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E066E1F000C4;
	Sat, 17 Oct 2026 17:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258753;
	bh=V2FCReb92mzx20o6RQ4V4Rf9vxj2wA4RinPRK/06iDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9Czby7uJzz/ULlFtVhftEToURZtZaROFrOgjObjArD6hsnCEAn5OLH9lXJXJ86Sl
	 Re+g1EwXsHgJlLoaAenZX9Gm4JAmTX4SysORk00/W5o9AjVW4rkr+yK59F/CMyVrQP
	 2zNxbRPax4OHd9NzSkrvD3JMDBm7t85qG70763NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0989/1674] iommu/amd: Fix clone_alias() to use the original devices devid
Date: Sat, 17 Oct 2026 17:54:21 +0200
Message-ID: <20261017160456.505563431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 695cfb2e56aa7..c267dc7f92be5 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -217,10 +217,11 @@ static struct iommu_dev_data *search_dev_data(struct amd_iommu *iommu, u16 devid
 	return NULL;
 }
 
-static int clone_alias(struct pci_dev *pdev, u16 alias, void *data)
+static int clone_alias(struct pci_dev *pdev_origin, u16 alias, void *data)
 {
 	struct amd_iommu *iommu;
 	struct dev_table_entry *dev_table;
+	struct pci_dev *pdev = data;
 	u16 devid = pci_dev_id(pdev);
 
 	if (devid == alias)
@@ -252,9 +253,9 @@ static void clone_aliases(struct amd_iommu *iommu, struct device *dev)
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



