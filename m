Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063189;
	b=bLQ7Q00MvrsYtZTq3jYwIKHXbPVR1Yr3ZQjHF24bwEdcMXnfc2zNpT7dwEHMT0NgncNQ
	 DSC85EwTMAZ2MS771F3Z1bzqcqjG5jVJfAxcRYoVz8Hrt113SYESJV+suJpICcJsWqDx3
	 +YFF3aYmI+deic146YJ07SyC0p8CD1PKhu6dVj3CX0ypMB3wEkFooWwRgR/9DRxjoga/X
	 lWTK8aAqNoPIcw5Kauz45GKSu89ohfgbP4ZKrOCI0tx5JQE16sPubdDscfUMtYMa2Pcy3
	 BCYwSxZIkvU+o4DwtM1/rLyhm64615oYEojwj3nS3LN0HFWvF1AISF1spucJOOVEZHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=No7+KB7BNcGvh/XisoCIf/KheAI7W4yT4l3k+rMxx54=;
	b=u3V+3rSZ+P73Qr4TZ3NVTmF/CavkyBvJiMlFN3q5GaVq4+TZ1yrRZ30IaN4NYprzAp5M
	 Ls+E6DjKX5E3EPGfuXDoY4nOua1iE5goEy8MnnI7FTauVrwE2p+PJHTefSNH67QcDihJA
	 s6IQ+f81z6VmmwDa8OLZj4fT3sMYJ4nqhWOjhv+O5Nto0L47oyBK1x6SG5MbmZjhj6RdV
	 /QVDpV2KUWFsTe0WzACh4JF1fLK3aPjntTRYHOQ8VycRxKlcltN0w6lBipLojIGXq3E7W
	 M7v7b/ypeEVvlURSHq56h4yBiAy4/BnojS0eHMWwqfc0XCu/ShbcOM0xI9g9ykZzTMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CnrpDWbW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CC5606D82E;
	Sat,  7 Nov 2026 14:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CnrpDWbW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0DC1F0089F;
	Sat,  7 Nov 2026 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063188;
	bh=No7+KB7BNcGvh/XisoCIf/KheAI7W4yT4l3k+rMxx54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnrpDWbW1/CaQc9PmdtZ1u7E6y0cu27KFd5am48vPg6ytIYFRNYDUB+VAEeHivcJQ
	 ZaRpHpwpjga8nKB5ItLOfZxv2C+2OEz4VYotwBWNNcDSVrdLjwXH4M3z4bG1rRNaIq
	 RZI+TP72189I2ghGzEizXAZQhiSrDzVvdpEWJBPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linlin Yang <yanglinlin@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 405/869] wifi: mt76: mt7996: fix PCI device reference leak in mt7996_pci_init_hif2()
Date: Sat,  7 Nov 2026 08:51:27 -0500
Message-ID: <20261107134907.101199479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linlin Yang <yanglinlin@kylinos.cn>

[ Upstream commit d92bac6b6af2602516ee82ae112709c71af27cf6 ]

pci_get_device() increments the reference count on the returned
struct pci_dev. In mt7996_pci_init_hif2(), three pci_get_device()
calls are made but their return values are only checked for NULL
and then discarded. pci_dev_put() is never called, causing a PCI
device reference count leak.

Fix this by storing the return value and calling pci_dev_put()
before returning, following the same pattern already used in the
sibling driver mt7915/pci.c.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Signed-off-by: Linlin Yang <yanglinlin@kylinos.cn>
Link: https://patch.msgid.link/20260824092937.683240-1-yanglinlin@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index 3f49bbbba3b9c..1d9102b5e556a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -63,12 +63,18 @@ static void mt7996_put_hif2(struct mt7996_hif *hif)
 
 static struct mt7996_hif *mt7996_pci_init_hif2(struct pci_dev *pdev)
 {
+	struct pci_dev *tmp_pdev;
+
 	hif_idx++;
 
-	if (!pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7996_DEVICE_ID_2, NULL) &&
-	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7992_DEVICE_ID_2, NULL) &&
-	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7990_DEVICE_ID_2, NULL))
+	tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7996_DEVICE_ID_2, NULL);
+	if (!tmp_pdev)
+		tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7992_DEVICE_ID_2, NULL);
+	if (!tmp_pdev)
+		tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7990_DEVICE_ID_2, NULL);
+	if (!tmp_pdev)
 		return NULL;
+	pci_dev_put(tmp_pdev);
 
 	writel(hif_idx | MT_PCIE_RECOG_ID_SEM,
 	       pcim_iomap_table(pdev)[0] + MT_PCIE_RECOG_ID);
-- 
2.53.0



