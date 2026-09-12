Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8D43546E1;
	Sat, 12 Sep 2026 10:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209306; cv=none; b=pgkpNXNiIiYgD2sOEpV7vw5LiHEJV674ey+P5Q09NxBSj5zoxNaYfXWlRpPC1r7VmLuJ+m7waUiwmJX1+EkLqWP4Kc6gdG9AUqRnC38a1twDI96bmG5BsbRZoPYy0++QOtnJy7oRpoghDwZVWuln1xZ2VsIETBFmKLt/NXkWdbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209306; c=relaxed/simple;
	bh=z3Oy84S3x5/orJFajSLww4tUsaw35Fv7EWQVEsQyp0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJKg9FBqAKvLk/IeIPzLyjWQAswiY0AzNNi44uK6w3n7M0Nbvdg67M7auG5nap7SPCoBNNKmfcRTWZhmdDwbc16VVbei1Ny/Qi/9XKJVFdNCjRlZ5hP9xdl7sS6jeVKnKz99+MlwBl84gd1GjBS576ZwqXYRl8h2QLQhqJ3PmWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aON88Rq9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aON88Rq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636121F00898;
	Sat, 12 Sep 2026 10:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209305;
	bh=jdW5di8WOXJgF3hUGFnN5tADkY5UcGaD3++aD2A8DJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aON88Rq9pQcSAzKf/NUBtP7UCL6rcO6wyAahbAmtMyC34zUzIZg/apEJq5K5in9lb
	 LXPWnfMpN/OAyniM5y1VZ7IniDJLCewxYXiaAOgtGpAQsSQ82VnceBaayPeILJSsF4
	 JJlfi0t9Zozz09jsAsHhMfWVcns2/G3BDjMg0dQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0795/1518] wifi: mt76: mt7915: release hif2 reference on probe IRQ failure
Date: Sat, 12 Sep 2026 08:49:24 +0200
Message-ID: <20260912065641.417376433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5a0c9eeb2c4e2..c24f1b12f064f 100644
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



