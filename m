Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D578F3B19B1;
	Sat, 12 Sep 2026 08:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201185; cv=none; b=a0a40zR9TGg1mBlEzVv/blrmr4Jw/o48iHe0tiU9aYVHGqVsf7ByeFrHxt31nTK2tuJdavTAV2d26MvpEFmZ4SBgPL9hwU9JTHrO5YLD1rBYHIVQ9Dch9GlhNhzlOxmpU54MSIidJ0z6MbXEvEcrubG/ZKrgCXKacFS2hSqS0BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201185; c=relaxed/simple;
	bh=C2L3xIu6hAcAapXc3xaAc73FNnph4xs85pfXuke7+K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqIerpw2fmTGFuw6e7NFzgXqQvric8wGo4Btr8IhvMWl/2BlLLHT1vMYZ3xBRRWZA/jeaDmQ6fQbeGK6izuTcRuFEZQXRYz+rBFzb7O6/pSq+tX7WDr12wwDEdY/lK1XhL8xWhNG1si02exYpOcetO67ke5K1S/GvUIsABpLUlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFMFgq/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFMFgq/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90741F000FF;
	Sat, 12 Sep 2026 08:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201183;
	bh=pRHkThVGxi4Uu0i7yOji0B0cipglOO8YbdKBmd1qRgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFMFgq/k83vSdXKqufJDqd6Bm6M+mt8t5re/Qxvwdcywf9nW8GnMoM0kR/avJV/tE
	 TaazY1uu+odQYEoTZPYeecaIFOIrwoOH35vyJrwXpeyR0a+zcFxhjfWuLyNWn+U5P+
	 5b0QsuMWIb9LVyJ6m0VIJ9XyyaS1m9/O405s8Rd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0943/1815] wifi: mt76: mt7915: release hif2 reference on probe IRQ failure
Date: Sat, 12 Sep 2026 08:44:53 +0200
Message-ID: <20260912065711.095819512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 8370aebd26a9dfa2e0de665e3ab504c0e97ee730 ]

The hif2 reference obtained by mt7915_pci_init_hif2() is only released on
error paths that key off dev->hif2, which is not assigned until after the
IRQ setup. If pci_alloc_irq_vectors() or the primary devm_request_irq()
fails, the reference leaks. Drop it explicitly on those paths via
mt7915_put_hif2().

Fixes: f68d67623dec ("mt76: mt7915: add Wireless Ethernet Dispatch support")
Link: https://patch.msgid.link/20260727150434.1778520-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index 12b3e2dd530ae..8007e620048b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -144,16 +144,20 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 		hif2 = mt7915_pci_init_hif2(pdev);
 
 		ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
-		if (ret < 0)
+		if (ret < 0) {
+			mt7915_put_hif2(hif2);
 			goto free_device;
+		}
 
 		irq = pdev->irq;
 	}
 
 	ret = devm_request_irq(mdev->dev, irq, mt7915_irq_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, dev);
-	if (ret)
+	if (ret) {
+		mt7915_put_hif2(hif2);
 		goto free_wed_or_irq_vector;
+	}
 
 	/* master switch of PCIe tnterrupt enable */
 	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
-- 
2.53.0



