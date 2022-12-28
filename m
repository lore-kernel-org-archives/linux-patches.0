Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0801875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8832AC433D2;
	Wed, 28 Dec 2022 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243220;
	bh=g5v0OlgzeQOaGOTUNW+bZSLeBXEvTLsWUFqBCLefFi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9G5rLaThdRtK+I/SKCCTcR9zj4uM5S/PpNfbkLHQTo3BzL51Fo58uwrt/zbrzaO5
	 bYF5zL7R8HP/C5KQhA95gKdpcNIzpFiM9lmtEqbh9Gy5N70TrKlP5xtnFDGo2iTk0j
	 jT3Bcme07awaCWRYP4dKyttG9Dt7Q+bIDa2mt+Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0464/1146] mt76: mt7915: Fix PCI device refcount leak in mt7915_pci_init_hif2()
Date: Wed, 28 Dec 2022 15:33:23 +0100
Message-Id: <20221228144342.789501462@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 5938196cc188ba4323bc6357f5ac55127d715888 ]

As comment of pci_get_device() says, it returns a pci_device with its
refcount increased. We need to call pci_dev_put() to decrease the
refcount. Save the return value of pci_get_device() and call
pci_dev_put() to decrease the refcount.

Fixes: 9093cfff72e3 ("mt76: mt7915: add support for using a secondary PCIe link for gen1")
Fixes: 2e30db0dde61 ("mt76: mt7915: add device id for mt7916")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index 728a879c3b00..3808ce1647d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -65,10 +65,17 @@ static void mt7915_put_hif2(struct mt7915_hif *hif)
 
 static struct mt7915_hif *mt7915_pci_init_hif2(struct pci_dev *pdev)
 {
+	struct pci_dev *tmp_pdev;
+
 	hif_idx++;
-	if (!pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x7916, NULL) &&
-	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x790a, NULL))
-		return NULL;
+
+	tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x7916, NULL);
+	if (!tmp_pdev) {
+		tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x790a, NULL);
+		if (!tmp_pdev)
+			return NULL;
+	}
+	pci_dev_put(tmp_pdev);
 
 	writel(hif_idx | MT_PCIE_RECOG_ID_SEM,
 	       pcim_iomap_table(pdev)[0] + MT_PCIE_RECOG_ID);
-- 
2.35.1



