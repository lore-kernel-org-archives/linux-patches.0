Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE14361FFE;
	Wed, 20 May 2026 16:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295102; cv=none; b=uPxHAq5XkpfuSr1wdKJh1WJ9g19caHxd8mRCMV/p0Gk3db/k1/5/NfydUoLrGuoAG4y2la9N6wS++LGY8c41R7IJK6MlKmcfr4eCnsU2FZ42fnF+jt5WJqzy8ERWwEEDTRLoL7/Dage9EtnIzzP83LhEAKpo563jY1WN3L2LRaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295102; c=relaxed/simple;
	bh=j5xAfxZn3ZGyI2OWXh8POXxbPecU+7e1htkHYq6AeK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKdWGMjyqsbVM5UIB6D6zwSo/wy7PQDOseRRefH2TfxeMJcuVroH4pknM16hMB7uVUEbKgH9kvbRIbqCZNOQ3FM0aNZnKBeHDG7lIXhaR9nNa9D2CJhn8+jr69ZwNM/As+tc98EZVTm1fK6oT6wejBWZ3RTTcK8+XfTFxCOHSfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7NhgjXp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7NhgjXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6B71F000E9;
	Wed, 20 May 2026 16:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295100;
	bh=iJLlBoG4H4w9hKmUNqLMDoeOZ4DAdBfiTvk8qgjGdng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7NhgjXpNPzr0yz/8UzXoDITcMNxX5FxzChHjro4iK/eZwDQ9kGAzbMkaiRvrTM+S
	 hwDfnZFX038BrwQ80qT6x9rvovi+rmUXNfpIITyrPor5N78kcedKsVyfLSxIbADIIZ
	 LJPYyjxVjv0GainLujzkO+FuSLnaOzfH9ZOno2u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaxing Guo <guoyaxing@bosc.ac.cn>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0290/1146] iommu/riscv: Skip IRQ count check when using MSI interrupts
Date: Wed, 20 May 2026 18:09:00 +0200
Message-ID: <20260520162154.779716211@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yaxing Guo <guoyaxing@bosc.ac.cn>

[ Upstream commit 7217cee35aadbb07e12673bcf1dcf729e1b2f6c9 ]

In RISC-V IOMMU platform devices that use MSI interrupts (indicated by the
presence of 'msi-parent' in the device tree), there are no wired interrupt
lines, so calling platform_get_irq_count() returns 0 or -ENXIO, causing the
driver to fail during probe.

However, MSI interrupts are allocated dynamically via the MSI subsystem and
do not appear in the device tree 'interrupts' property. Therefore, the
driver should not require a non-zero IRQ count when 'msi-parent' is present.

This patch fixes the bug where probe fails when using MSI interrupts
 (which do not have an 'interrupts' property in the device tree)..

Fixes: <d5f88acdd6ff> ("iommu/riscv: Add support for platform msi")

Signed-off-by: Yaxing Guo <guoyaxing@bosc.ac.cn>
Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu-platform.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-platform.c b/drivers/iommu/riscv/iommu-platform.c
index 83a28c83f9914..8f15b06e84997 100644
--- a/drivers/iommu/riscv/iommu-platform.c
+++ b/drivers/iommu/riscv/iommu-platform.c
@@ -68,12 +68,7 @@ static int riscv_iommu_platform_probe(struct platform_device *pdev)
 	iommu->caps = riscv_iommu_readq(iommu, RISCV_IOMMU_REG_CAPABILITIES);
 	iommu->fctl = riscv_iommu_readl(iommu, RISCV_IOMMU_REG_FCTL);
 
-	iommu->irqs_count = platform_irq_count(pdev);
-	if (iommu->irqs_count <= 0)
-		return dev_err_probe(dev, -ENODEV,
-				     "no IRQ resources provided\n");
-	if (iommu->irqs_count > RISCV_IOMMU_INTR_COUNT)
-		iommu->irqs_count = RISCV_IOMMU_INTR_COUNT;
+	iommu->irqs_count = RISCV_IOMMU_INTR_COUNT;
 
 	igs = FIELD_GET(RISCV_IOMMU_CAPABILITIES_IGS, iommu->caps);
 	switch (igs) {
@@ -120,6 +115,13 @@ static int riscv_iommu_platform_probe(struct platform_device *pdev)
 		fallthrough;
 
 	case RISCV_IOMMU_CAPABILITIES_IGS_WSI:
+		iommu->irqs_count = platform_irq_count(pdev);
+		if (iommu->irqs_count <= 0)
+			return dev_err_probe(dev, -ENODEV,
+					     "no IRQ resources provided\n");
+		if (iommu->irqs_count > RISCV_IOMMU_INTR_COUNT)
+			iommu->irqs_count = RISCV_IOMMU_INTR_COUNT;
+
 		for (vec = 0; vec < iommu->irqs_count; vec++)
 			iommu->irqs[vec] = platform_get_irq(pdev, vec);
 
-- 
2.53.0



