Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BACA12EBEA;
	Tue, 25 Jun 2024 09:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308533; cv=none; b=BRMMGQuqwhcoOQhABZiajpfBrVjzrTzf3lfdf3ydd7ywDrtvmR/dd78+t0J5Uq7j75I4/Y8KSih5kOUUZP/xNExM+c2tX86xI5cjM72SRz4Zy0wwSRg97InLBJgcvLHpT8uXBOg1Zq9saZfriMSaCsYlCbKnS0+7UfmVTfZh2Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308533; c=relaxed/simple;
	bh=vNGA+6uFx8oOz7fkdt9szo+ZPkYyA4f2JH+2OLkrmuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7VYlgBDF4xqdSz1DnAF2NdbFxh2mEDdRTUXmI07U1SGO3PzyTvCB6VTxdjnfJ1AMvE7NLqPSNV1Uygnobf408ArUXA70q16MlAZiP5hj3a+66FIlxGlOnhmuyB7VcKa5nTByXyB8V8RPdKwhjpxirQ6xvb5RjF57Gqdwt1zMvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZkPw/FO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZkPw/FO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4414C32781;
	Tue, 25 Jun 2024 09:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308533;
	bh=vNGA+6uFx8oOz7fkdt9szo+ZPkYyA4f2JH+2OLkrmuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZkPw/FOcO7wrVZsI1ZN/5SbgBPCROKY48njTrIldBTNOFel80dsZlvtwCnMGLoyq
	 cFMWvIy+kZdu7esCa8ETIOeEbPvgEz9uUucLAV4K2teuIwczl1qxT2CQxld0eGtIwF
	 67WkdrWqDoScuX5i5WHiAn3LRKv+zQxtV09XzLXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 153/250] dmaengine: ioatdma: Fix leaking on version mismatch
Date: Tue, 25 Jun 2024 11:31:51 +0200
Message-ID: <20240625085553.934052522@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9c364e92cb828..e76e507ae898c 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1350,6 +1350,7 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	void __iomem * const *iomap;
 	struct device *dev = &pdev->dev;
 	struct ioatdma_device *device;
+	u8 version;
 	int err;
 
 	err = pcim_enable_device(pdev);
@@ -1363,6 +1364,10 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!iomap)
 		return -ENOMEM;
 
+	version = readb(iomap[IOAT_MMIO_BAR] + IOAT_VER_OFFSET);
+	if (version < IOAT_VER_3_0)
+		return -ENODEV;
+
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err)
 		return err;
@@ -1373,16 +1378,14 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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



