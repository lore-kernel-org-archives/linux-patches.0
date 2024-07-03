Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1DB174EFC;
	Wed,  3 Jul 2024 11:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005886; cv=none; b=u1ofqcBFGdOEEuJuKMAsUQ9j1SM8Lk6veW3jvo4VI9dFEUzEKdjC9egHWe4LlUML7qI93YT3HaQA39FfhJZvQEfL2+9PmFnaHIF/oF0U3mD3QggCFqTTv1zvxtJ6DkuVWHMrMpwWTCr355ws5rz1QZ8TMaR0shL0NcEXmAdsN5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005886; c=relaxed/simple;
	bh=7agZO2wlJV7vaMy3faERD2GRTShJ5wmnYRNo2ibeixs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAmHoTySyhyKYRjurvQZeh9zy6damDQxuAHpnCEDMyRrAt71jcFA6PE/KTHgpLfb7mccoqIZlXaiA9FcBCZ00w4amhMNwbha7rrepvkFwcZfAOWjHezCA+XJzTLsRCe3tvG8jyFTAyivqlXv9+y2nBEjc+0KJLB85MCOHGWT8is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EP1y3bXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EP1y3bXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBD7C2BD10;
	Wed,  3 Jul 2024 11:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005886;
	bh=7agZO2wlJV7vaMy3faERD2GRTShJ5wmnYRNo2ibeixs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EP1y3bXZf+oq2DPbpCpK1ltzNbhvFnWxZgNlD5yfpIzJRiW2OOacub+F/t+2nEedX
	 eepUh1q2EdhT/COl59JCxYeeUtNL1D5osuJFXXVBKLex+Df6sHDYeUSknDPo7Mo4c7
	 AtaDilA4TiJ4V6U+ealqzGjixVwJsOyI9bVJ5ijA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/356] dmaengine: ioatdma: Fix error path in ioat3_dma_probe()
Date: Wed,  3 Jul 2024 12:39:08 +0200
Message-ID: <20240703102921.128236126@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit f0dc9fda2e0ee9e01496c2f5aca3a831131fad79 ]

Make sure we are disabling interrupts and destroying DMA pool if
pcie_capability_read/write_word() call failed.

Fixes: 511deae0261c ("dmaengine: ioatdma: disable relaxed ordering for ioatdma")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240528-ioatdma-fixes-v2-2-a9f2fbe26ab1@yadro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index ed4910e3bc2ac..ceba1b4083a9d 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -534,18 +534,6 @@ static int ioat_probe(struct ioatdma_device *ioat_dma)
 	return err;
 }
 
-static int ioat_register(struct ioatdma_device *ioat_dma)
-{
-	int err = dma_async_device_register(&ioat_dma->dma_dev);
-
-	if (err) {
-		ioat_disable_interrupts(ioat_dma);
-		dma_pool_destroy(ioat_dma->completion_pool);
-	}
-
-	return err;
-}
-
 static void ioat_dma_remove(struct ioatdma_device *ioat_dma)
 {
 	struct dma_device *dma = &ioat_dma->dma_dev;
@@ -1180,9 +1168,9 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
 		       ioat_chan->reg_base + IOAT_DCACTRL_OFFSET);
 	}
 
-	err = ioat_register(ioat_dma);
+	err = dma_async_device_register(&ioat_dma->dma_dev);
 	if (err)
-		return err;
+		goto err_disable_interrupts;
 
 	ioat_kobject_add(ioat_dma, &ioat_ktype);
 
@@ -1191,20 +1179,29 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
 
 	/* disable relaxed ordering */
 	err = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &val16);
-	if (err)
-		return pcibios_err_to_errno(err);
+	if (err) {
+		err = pcibios_err_to_errno(err);
+		goto err_disable_interrupts;
+	}
 
 	/* clear relaxed ordering enable */
 	val16 &= ~PCI_EXP_DEVCTL_RELAX_EN;
 	err = pcie_capability_write_word(pdev, PCI_EXP_DEVCTL, val16);
-	if (err)
-		return pcibios_err_to_errno(err);
+	if (err) {
+		err = pcibios_err_to_errno(err);
+		goto err_disable_interrupts;
+	}
 
 	if (ioat_dma->cap & IOAT_CAP_DPS)
 		writeb(ioat_pending_level + 1,
 		       ioat_dma->reg_base + IOAT_PREFETCH_LIMIT_OFFSET);
 
 	return 0;
+
+err_disable_interrupts:
+	ioat_disable_interrupts(ioat_dma);
+	dma_pool_destroy(ioat_dma->completion_pool);
+	return err;
 }
 
 static void ioat_shutdown(struct pci_dev *pdev)
-- 
2.43.0



