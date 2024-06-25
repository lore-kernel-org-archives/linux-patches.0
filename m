Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380AC6CDBA;
	Tue, 25 Jun 2024 10:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309630; cv=none; b=orMWsnOvB3m+FNrV7bvE5vxUe/p2t3lWYYHoQFk7u2UNgFfHl+bhOj/8L5SzkwDOBzUbZBZgI/dYq3d3MJbxQrrHKleOnG7W9PpWhjobbzlPeVSMmyFGF7vnYlGO8Ij+IgE7oJqkFQkL4knP+COo1ECrNcV0zqHYpCfcp2h2MDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309630; c=relaxed/simple;
	bh=bm/fk8No7e2ioyS/w6OfcEkmaFyV8PlxInjzNsTFngc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/9WAfOidz8QpvzC9u114/xEyzrIfhT+iKlMLY+jAE6asbXPg+Pyko7UYuzcCO1SKMGu8ffxjoCE0o9EZsea3OBpsnFBsk849gEpSef/s1bS5oChlKGpMDvWSQxhEG6u0pDvGKwKjLftTtnV7DJqeViraWXepiRPDaKioIDo7WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+9Uyi0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+9Uyi0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A86EC32781;
	Tue, 25 Jun 2024 10:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309629;
	bh=bm/fk8No7e2ioyS/w6OfcEkmaFyV8PlxInjzNsTFngc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+9Uyi0UZmfeGwG2Pmpa/hUEH6HLkbr45NJi1k8lMCW62V6ELNJZ9kChdVXlnk+Ha
	 q6a2sbOqN8pjrZhNQ0AvNgQNeb3V8X5S93kuqvVK+t2EvO5x54fVGj1ua7o9aMJ5H9
	 8sCVi9j/VwzSlNQ75AZvMdej3Q7r2jRSRYhQEj2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/131] dmaengine: ioatdma: Fix leaking on version mismatch
Date: Tue, 25 Jun 2024 11:33:56 +0200
Message-ID: <20240625085529.021834161@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 1b11b4ef6bd68591dcaf8423c7d05e794e6aec6f ]

Fix leaking ioatdma_device if I/OAT version is less than IOAT_VER_3_0.

Fixes: bf453a0a18b2 ("dmaengine: ioat: Support in-use unbind")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240528-ioatdma-fixes-v2-1-a9f2fbe26ab1@yadro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 6ca62edf47bd7..79dcd2061b023 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1349,6 +1349,7 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	void __iomem * const *iomap;
 	struct device *dev = &pdev->dev;
 	struct ioatdma_device *device;
+	u8 version;
 	int err;
 
 	err = pcim_enable_device(pdev);
@@ -1362,6 +1363,10 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!iomap)
 		return -ENOMEM;
 
+	version = readb(iomap[IOAT_MMIO_BAR] + IOAT_VER_OFFSET);
+	if (version < IOAT_VER_3_0)
+		return -ENODEV;
+
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err)
 		return err;
@@ -1372,16 +1377,14 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 	pci_set_drvdata(pdev, device);
 
-	device->version = readb(device->reg_base + IOAT_VER_OFFSET);
+	device->version = version;
 	if (device->version >= IOAT_VER_3_4)
 		ioat_dca_enabled = 0;
-	if (device->version >= IOAT_VER_3_0) {
-		if (is_skx_ioat(pdev))
-			device->version = IOAT_VER_3_2;
-		err = ioat3_dma_probe(device, ioat_dca_enabled);
-	} else
-		return -ENODEV;
 
+	if (is_skx_ioat(pdev))
+		device->version = IOAT_VER_3_2;
+
+	err = ioat3_dma_probe(device, ioat_dca_enabled);
 	if (err) {
 		dev_err(dev, "Intel(R) I/OAT DMA Engine init failed\n");
 		return -ENODEV;
-- 
2.43.0



