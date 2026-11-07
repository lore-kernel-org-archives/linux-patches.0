Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063230;
	b=Sgmj66c3v6OL2VPBwRbDtfFlziD/FIwjIILFSAcAaNXqU13VIzhEGd9WEUxHDnITgsCI
	 t0arHs4sTmm9VakblLhtnkLIweVm0YXn4AdHpTg8613gwtXRdiCtXc9/iyrNZje5WD/si
	 5b/MWB395HuWw4C6VvwUcsxTmuxUdcvrsdzq8LrSkdSXG/PdWpw/gOdD1te7b/MfTf63T
	 WqYImoWLmbObUCYTTW7yWVGuyPSA3JOGC8240HnWCuTXm0x26jkIiTktH/HAi43WQ5W3M
	 pY9Fhy4f5gEp4p/dIvg44QsJXw6eSxYJA8OUuHIf54ox7E217PvM4RPT/wuhC9Ur46A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b55A0gktkxo7Jf3ehPXb+qmxKmhPG8qjPILijYBm+Uw=;
	b=M4Hu5DGM9MGatEObYe2pZ8fPr9cjPeOCQBDURf9+cJdROpS2ahL1P+1K0AyI3wqvSRFA
	 az0H6x7EYjuny+7mcGxCe9SjUJ6TNOzfNSWwgMuS+OpKjdyidQz8DSNHdCBg5fEAuXWr1
	 8/r4pXsEKdmzwcsugENktcQT+TriiddZx0HODPV6QOv6U/8vtTTu50TI7Jf7Ibj3AJSoc
	 ujRUhqJiutP4k2Yc4exkGl4j5EH4Cepx9xfMdbZ2Wh0EAUg5taGcp5SmkCSV1t84JUqml
	 AQoBrRrLXCb/unFE6xRuGa126rOSAp/D7NYqdq1FgKq9TBjuvjc/0wryFhHso9Rq03Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vr+Z7Fqx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2106606D82E;
	Sat,  7 Nov 2026 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vr+Z7Fqx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7201F008A2;
	Sat,  7 Nov 2026 14:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063229;
	bh=b55A0gktkxo7Jf3ehPXb+qmxKmhPG8qjPILijYBm+Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vr+Z7FqxfrPlImlrks5hv4SrbJ15RKj56othtKep5VEOxUEBP0sZXm4ayPXq8fMd5
	 EoXnrroTpmFbuX+asWaYt/56m4zwYihWqUk4HFrGVbkJ2uiCIKMhyHgva/AAHZy5N5
	 WNRps3BXS1sQHZYl/o7XaK4H4U/eCtzMr3Y7VmK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 399/869] wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory
Date: Sat,  7 Nov 2026 08:51:21 -0500
Message-ID: <20261107134906.928368498@linuxfoundation.org>
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

From: Eason Lai <eason.lai@mediatek.com>

[ Upstream commit f5dd4833463ed45794027e33928539b3c532f82d ]

Using __skb_pad() instead of skb_pad() in mt76_skb_adjust_pad()
to prevent double-free, as the caller handles cleanup.

Free the MCU message skb in __mt76x02u_mcu_send_msg() as well, which
relied on skb_pad() to release it.

Fixes: 808f2767d421 ("wifi: mt76: mt792x: Fix memory leak in SDIO TX path")
Cc: stable@vger.kernel.org
Closes: https://github.com/morrownr/mt76/issues/83
Co-developed-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Eason Lai <eason.lai@mediatek.com>
Link: https://patch.msgid.link/20260914021920.32246-2-eason.lai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/tx.c              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index b2cc449142945..d06cc5ee07b2b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -90,7 +90,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	       MT_MCU_MSG_TYPE_CMD;
 	ret = mt76x02u_skb_dma_info(skb, CPU_TX_PORT, info);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = mt76u_bulk_msg(dev, skb->data, skb->len, NULL, 500,
 			     MT_EP_OUT_INBAND_CMD);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 93275bb692fa5..3fef2ad45dee4 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -885,7 +885,7 @@ int mt76_skb_adjust_pad(struct sk_buff *skb, int pad)
 		}
 	}
 
-	if (skb_pad(last, pad))
+	if (__skb_pad(last, pad, false))
 		return -ENOMEM;
 
 	__skb_put(last, pad);
-- 
2.53.0



