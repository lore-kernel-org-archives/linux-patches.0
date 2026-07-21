Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E20478861;
	Tue, 21 Jul 2026 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649441; cv=none; b=B3cz6kO8/PHOKrQ0KrU7d+knLkK3aSH3d2/QdM0uocUbklxi+VzqgAcZQEHNHu0G5MfwYLeLhab/uoSY/DByM/4kRbM+EuccRY4lDtrmmITYmDfsJkukjCK44Eb3kn8LBCzQkMLObiZVvKR0Dh6EQxPD41PofroHBwJwIDQ3vRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649441; c=relaxed/simple;
	bh=dbBFICrzxfXeYrbB8lNNBcTqkkHd7sKpAqylb6KlbTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTk+DDLzAtuuiUrUVLXbriir3oXca5BfqERrp0yllgms8OlpuHythsSwtUH4czet+Cidj9xj5FINbtWckTZJxES5Ng5YF6jgV7WySo1AzVZUIHPGcCSZ5+PeLAM18V+Tk/49kKob0+7FeG0WZ14zn8Y3NDSirIL6pUgFRU5+v5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQFiVihC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQFiVihC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8B81F000E9;
	Tue, 21 Jul 2026 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649440;
	bh=D1gDRf1c0VqRUsL6uh7ROQz2FCZYS4GdC3SKLkBvD44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQFiVihCXY8nJm2FY1npEd2dz6IX4sSXgaUS+GBxZB5HMp+cPeGYvDzRTSFZBrpza
	 uNN7xQB7QwjpPjtW9/mcLMqorKywQ/PAi+9mGGV9wCXmBeZ1GjZiGA/xAXgCipRn3H
	 hNhRWDEabIE688zVPr0KkNPOi+dl10tCh54wAbaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0578/2077] wifi: mt76: mt7925: clean up DMA on probe failure
Date: Tue, 21 Jul 2026 17:04:11 +0200
Message-ID: <20260721152606.440713705@linuxfoundation.org>
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
index c4161754c01df1..48837723024d7c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -415,10 +415,12 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 
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



