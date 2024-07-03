Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6799617966F;
	Wed,  3 Jul 2024 11:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004888; cv=none; b=kEMql5DN2J90w9BZO28CharUjlcyGe7X6DYQC6VzDbtKHF6ON88JqzpoL+/+flyKcjg2IRg/HCqxb6cU9oXRxy5TG7TGH897sxARVPfqVSRfEyeuwQB6pw+6a9D3SxLBu/3ogTp/X/LJkkCy4RFjC6klR0pSI1M4PBJwqw9s0bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004888; c=relaxed/simple;
	bh=M7O83ZF/4HVwtdeEhpmkTkTljhPpOXYImpzwO5rD7Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ao43TC6j71b5l1HKnjFHBSxmicEAgBZcCqfUM7OLh5nERJVB295OmOAgaqoKgG2HzAKbWE2vMBp18h7mbS7WLwylHFaptb2O09lF3+KVpro9oA/L0uMPdbWa7AF9NJD0JuoiDmaTP6w/etSAwhkL/M1K0lz1TA/5qvs/fF5EVD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiInmWIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiInmWIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A5DC2BD10;
	Wed,  3 Jul 2024 11:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004888;
	bh=M7O83ZF/4HVwtdeEhpmkTkTljhPpOXYImpzwO5rD7Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiInmWIzPN4sRfbLfQ6TpBhwLErKsUXx3GNmgSaBaz6ZyzrG2hKPzuAKD/Jw+AIqn
	 QpoLLwD46ptEyFsErG3BN0k3Ygtruy0vz5CirG/hC7i1pEGffj7wQjaJgsk4rdz5Bx
	 CMYgd10gdSmbZLq2oZHOdJ/fHg4kZLR4FinMcUXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/290] dmaengine: ioatdma: Fix error path in ioat3_dma_probe()
Date: Wed,  3 Jul 2024 12:39:00 +0200
Message-ID: <20240703102910.185504958@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



