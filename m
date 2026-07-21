Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1CF46A5F8;
	Tue, 21 Jul 2026 15:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649443; cv=none; b=qE7UhMpydx8gEJ1TAPCdG4H8ZJrlwcqRXoyUUo1k2GVqqUbcKI75Er51zKutONo59PCtzXt9Ck+nqWL4k21YwEwaFx5BnPEBA5aR91AEX4I7Ij2KWaEea56GETGgYZYUt1ZNBBXMBMV3q1ZTwO/6a4+Ewt4OesJDx5bac3Eg1+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649443; c=relaxed/simple;
	bh=/Ek/Ez0KyY2CzfzisB698jZCgTgvhEeuSUnq9Y1frZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pxa5xuNOB9Gvcd3o4nryLjpTHZxHnmPsQx8XNNeoAnoxcbWl5l7FfrUm9ZEKODXckzjfj6svS0Xn/9b4gxOTmEAQiaWIuvBHvV3ZgwTSarR/EyAXUL3asqtN+SaeThIYibrrTViJNSKbLIruGYFYOwVFV+YPfNnj8SA1otxUM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cto5FYQy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cto5FYQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CDE1F000E9;
	Tue, 21 Jul 2026 15:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649442;
	bh=h0N9gVMA/IYKqmzugfWKg3WzM1WVewk0sVUrth+83LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cto5FYQyzDck5I4s0LFiBZQQyRhWwCoxgxtcHiJLolbuvr25WSnjisjH86oB159kL
	 y8xpDK91J3G26xOyF4cF2hRz696aWIp1SJTBeScL/3J39QCeyGwp+odZgwONgAuwHI
	 74xjgM3ni6ulKEkxSKfLzKk8YLgWdx2nUFt1raPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0579/2077] wifi: mt76: mt7921: fix resource leak in probe error path
Date: Tue, 21 Jul 2026 17:04:12 +0200
Message-ID: <20260721152606.466442557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 346dac35b1384af9338b34b6835e82e634ea4d2c ]

When pcim_iomap_region() or devm_kmemdup() fail, the code returns
directly without cleaning up previously allocated resources:
  - mt76_device allocated by mt76_alloc_device()
  - pci irq vectors allocated by pci_alloc_irq_vectors()
Fix this by jumping to the existing error cleanup path instead of
returning directly.

Fixes: ee5bb35d2b83 ("wifi: mt76: mt7921: Replace deprecated PCI function")
Fixes: 222606f43b58 ("wifi: mt76: mt7921: handle MT7902 irq_map quirk with mutable copy")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://patch.msgid.link/20260512065245.46496-1-zenghongling@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 7a790ddf43bb69..49a37185f0564e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -343,11 +343,14 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, mdev);
 
+	dev = container_of(mdev, struct mt792x_dev, mt76);
+
 	regs =  pcim_iomap_region(pdev, 0, pci_name(pdev));
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
+	if (IS_ERR(regs)) {
+		ret = PTR_ERR(regs);
+		goto err_free_dev;
+	}
 
-	dev = container_of(mdev, struct mt792x_dev, mt76);
 	dev->fw_features = features;
 	dev->hif_ops = &mt7921_pcie_ops;
 	dev->irq_map = &irq_map;
@@ -359,8 +362,10 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 		/* MT7902 needs a mutable copy because wm2_complete_mask differs */
 		map = devm_kmemdup(&pdev->dev, &irq_map,
 				   sizeof(irq_map), GFP_KERNEL);
-		if (!map)
-			return -ENOMEM;
+		if (!map) {
+			ret = -ENOMEM;
+			goto err_free_dev;
+		}
 
 		map->rx.wm2_complete_mask = 0;
 		dev->irq_map = map;
-- 
2.53.0



