Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978BE47CC87;
	Tue, 21 Jul 2026 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656473; cv=none; b=Msh04Yt8A8aInj07KeIzyyiEJ1VzEkC2dUmsAkyLxdNzmms9+E3+/iXopzjmZEsF5IfPUf3t0fNV1eBTUQUK33fKWlKoNN+k4nv0zi7uj1t/m2D7vnmC7T1hs1iRV/3jdUgaBc/J0i+WsmHqnr3UegHmD3uyGBm7CCc9TlCNqhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656473; c=relaxed/simple;
	bh=JfbhdXNjkkCmnhqAaukk7BWt9QF8X4bbZ3gwTL8ZFXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2BwGOU6i64enTV7guiQShdYh2Gt8vi3xP8eurE1IIA1BmkYh5udMknkbIbUE3V/W/j7cEMwX2VXog7T5hveL8zmY50ZbhZmzaVyCXgoE5MJJHWNow7DhgMmyLtWJB+6HeCvcSaA7j5e/THJRHnCm+r2RgOS+udLulfqWEawXnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XY+uFZd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XY+uFZd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28A71F000E9;
	Tue, 21 Jul 2026 17:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656471;
	bh=ejL6F+WJQ+0plGjkm0qB6Z6ghfYhOnRkoUG+OetBqzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XY+uFZd9Kug1YscLm+TIzE1eHr0DbA6jq8ZIO684AV9g9ctCT6h6wQV5J0eRbi35q
	 favhB5FtImww/SSpJuEjitV7nQwxo3KP0NkK7BXPp7WYC+6w0PatieCwXT38PQ+9P8
	 VmUYkWANUtv9kkIQ7TZohw8X7MPMCupGIg+Zk3zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0400/1611] wifi: mt76: mt7925: clean up DMA on probe failure
Date: Tue, 21 Jul 2026 17:08:36 +0200
Message-ID: <20260721152524.229988714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 8eb1fe1082d155..d6732f50784cfa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -414,10 +414,12 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 
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



