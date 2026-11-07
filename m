Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062229;
	b=w8rjM4XnmtgVwrTaLs3DHIxVvHHuZ0uIvmcOl08sRttDyy+s90iwjJa9whfkpMQnaOBj
	 opsTpRkUU8pvsPorRjl4EwK/M0kyswpgjniZWhQTf2cH9HprwNZ5o4gvgHCIBbKFhhEkO
	 E+BPyBipY4n6CYP1bXkaYBpdZIrxDv16aQHh4GtUnyh3z4mR7/XUkb3ahoc4K/SOcOdmA
	 3EqpvwsmhLivLymhn1Y41nvK/+AHskmhS3qOhxk11Z+VW4EhM5Ut9rGZ2QnhQZwUp30Qu
	 ZG5wRsDPfjM+YDpCnaHWKcJEuPPIjystvqeTs+mNnNVUzieKP4ZNjEhiWakOo5b4UDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/6jQ7IVRx7zA5eL4MUWYYwB9Z2W1uA+7uMTDYeEC1GI=;
	b=jLWPOnq32/iFW+R1HY1W8tg8202KXwkcgkpXwbP0cCzt+M4VaeHzWArDeb4D+GDsWxCi
	 zg6wcz8Lk97rjLzhwgSN3mpa/533kyv9Nf0Ja6dl/p9zcoV/vRIDRSyfHKyeFqm6tnp8E
	 YzXpUW3BnGEUYWGAotZ4rS6F5n3Tf93xY4+zxgyzU9luZeH6Fu871pLUAtl/Hmf4F0hdO
	 eFdGP2i6ag40IZznzPQouit9Lcufek3Xe5E5kMQmUWx9hkevjxhx8GJ5If0cgd46xqy5P
	 ovsfbAu5EsUEPnBo4DIjTHqt1y9YAPd3BL7fU8tT0CwFMVcO5wTu7sWii1Q2bK3+vww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PT7VYsA4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05AB606D827;
	Sat,  7 Nov 2026 14:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PT7VYsA4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAD01F008A2;
	Sat,  7 Nov 2026 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062228;
	bh=/6jQ7IVRx7zA5eL4MUWYYwB9Z2W1uA+7uMTDYeEC1GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PT7VYsA4VMpyqIIws2fORWSTSckbny7n/zLiKSZfS2jRwISU/DLIDKHREXYI/Aip6
	 Tao8XiCZye5alCKAf2Bueoc3kw5c8XtXDprxeQ9bm+PjvyNxCkqK+QJ5tSgPH5yQKd
	 +0asmSpEx4Up5NlE9xFK1S9m+a4c5JqTuZtd+Ka8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1180/1536] wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory
Date: Sat,  7 Nov 2026 08:53:16 -0500
Message-ID: <20261107135030.882020009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9cb00055ce302..ed1615192d644 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -792,7 +792,7 @@ int mt76_skb_adjust_pad(struct sk_buff *skb, int pad)
 		}
 	}
 
-	if (skb_pad(last, pad))
+	if (__skb_pad(last, pad, false))
 		return -ENOMEM;
 
 	__skb_put(last, pad);
-- 
2.53.0



