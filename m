Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350A2264AB;
	Sat, 12 Sep 2026 16:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230596; cv=none; b=Sjt55+b8OBTY9OS4f89+YAqGpDgBqJ2llKsnuKN9Fgsnk0pf3Y2bVupIWbcX5tVNed3gMyzkcS0HuYWXnZvk5QGkI/9IYPc1ejdIIk7EptURbyulF4lSJuVUi1VmlaM4JIQvv1gFMnjB/9LLjHqaJFcwVh1Vh6aOyWzCgFrSHgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230596; c=relaxed/simple;
	bh=U2FjVDTn13TfniY4EkMR7lGML4B9dZgRxvQ02kIdWO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjY8viZP8x/0hQ4xBEZ9/2HF9rVbiANXh7AK0bx5Tvw0q9w7fboAEgBPaq1FZVvME9Qx7R+u42xD3DHnRkJujZUMz7ClN6TQoju4fDFahZv3a+4c1Cl/TUQ5ng4y+BaI6hhTM93+AzhzSFB7NA4xh5gj5CS/hKdysNfh/0eWMQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=039hHhKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="039hHhKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13231F000FF;
	Sat, 12 Sep 2026 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230595;
	bh=RFL8Z/KXAKzx9vbXF/i38E0U0u4n6UnQ8EGBbBR3OSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=039hHhKezpd4b3Uq57p2f8j/S6/ivJKgJmS8T6IsNjsoFxtVHrDx1b+ERwwaGUlzy
	 vi2EaqjuRPU+EnUoxJvrTTLyy9/q3JekF+eJifXy5+2po47lRFTBRLGRyGZ2QqNnWM
	 lm5zJKMKDkFcW0+/S6HikXfjYKvdMHlmsVLrPa+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0824/1191] wifi: mt76: mt7915: release hif2 reference on probe IRQ failure
Date: Sat, 12 Sep 2026 08:59:12 +0200
Message-ID: <20260912065606.773855563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8e125daa90747..e8b3dda2e2404 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -143,16 +143,20 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
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



