Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415B046F4B3;
	Tue, 21 Jul 2026 19:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662120; cv=none; b=Zq1Q0uxdoNR/TlOENStukkLLwkglZ4AydO8A44wUDzYHHz3ZI5Hx+TfDdG1rZKeaBojiwBJol7KLoh43/7HmHGbjY4RMbpSfa6qneTWsVs9U6ti7YWGp2s16pQ27FL1ANsbJGfN7MjRW8dDp+wbUXGG2TvBxpR/4YAsEUqmtbN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662120; c=relaxed/simple;
	bh=WBzraXYuGdQ18+I1TwGQibpfV5iAeHwYjpiZIS0srcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO7Pwm8a7iJ/GRntKUpGjTHTE134dYbhGGpYiwr+hYxF6GzR5YKke/sWce3iIqgtaUfjqgalEzea1J7ZsJ1Mhg0qN0iF2JhEfaMrYireDEPG3XsPjqZLaeDct1cTYZqpFqBTuPqCNDe5R/TCQf88mOQfy6MhGB0KtmvDdrRdrpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8FaE5jL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8FaE5jL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B891F000E9;
	Tue, 21 Jul 2026 19:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662119;
	bh=RoafH/l7NZYOxrkysPvPXGhKJjsTXcRVpofJ2PJX3h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8FaE5jLXZCOyEOC7/LIjFPrsQxvXOSY/bUVw0WRWX3zmZhwsJEf27p+UhiW0veYE
	 I0iItvG4TemzMLkXpZ/LWzFOQyoXtesPV5lQ+NulmJyTdn6E+tbvNyUee9F1WM2Yh5
	 1s/5S1lB/7m+ct4C6mRJmeg+Z8X4ymgp6M97Fces=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0280/1276] wifi: mt76: mt7925: clean up DMA on probe failure
Date: Tue, 21 Jul 2026 17:12:03 +0200
Message-ID: <20260721152452.344524412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 9629f31f505d74e76ac0d7a9492fd06c0316fc5d ]

mt7925_pci_probe() initializes DMA before registering the device. If
mt7925_register_device() fails, probe returns through err_free_irq without
tearing down DMA state.

That leaves the TX NAPI instance enabled and skips the DMA queue cleanup
that the normal remove path performs through mt7925e_unregister_device().
Add a dedicated unwind label for failures after mt7925_dma_init() succeeds.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260426143728.41534-1-pakmyeonghun@bagmyeonghun-ui-MacBookPro.local
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index a90e90131276e1..eb4684f575aff2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -410,10 +410,12 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 
 	ret = mt7925_register_device(dev);
 	if (ret)
-		goto err_free_irq;
+		goto err_free_dma;
 
 	return 0;
 
+err_free_dma:
+	mt792x_dma_cleanup(dev);
 err_free_irq:
 	devm_free_irq(&pdev->dev, pdev->irq, dev);
 err_free_dev:
-- 
2.53.0



