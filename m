Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036350;
	b=bA7IKBeX8tYiwOYbCsribnqWFGQSBQJUZDvkhYxUZCfJR6GLmJuc5fegenZVk9eoTyVi
	 ycQbzMfPMNecBCLEML0QoJhisM2GV7fndtkaPAInUUN3FVn4sJroO5DC1U0UQ9Nd3CaPT
	 FlsLrJbGdG9ecZESPv4P2j1yuVH9yRQRbjkqF17drXBqjxfnGTiCACOEcvNbNSu5FFpih
	 O1lEamxnQBxPb0Ai7VRAK7HN4H4Cl13RRk5xRrtlR/onN/OGH0XyDdWIIkePkC7m499Bu
	 9F+I0nSSfTMtXIpiK+PV20mbdXilAb8NER8leyTFGRYNPVSmxLYG5cPtkACQdYzXCVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bioPyUeBo8L8tMJIxbE1/xlqEJmqq8WD7jpgdR+a0Q0=;
	b=xzoYBhq8kt1tY6Wyr5zkbJ8ipJNMkak5zRRlTWM8RoV/QjgPsv4sEU0Lzp5WHb6QTk9h
	 Kk1uyLNEg7sNCAPXz2t24zrM3AvFw6klpj8diyU3OxcaQFoGLx0RkuPDxBLbW6ZHIfFO9
	 3xogpeMdMxOu7NGEPr/4L1qgKIHFZOe6pb9PXgROaCsYlH/LPA/Fzd+QsbyXlWcAcQmF+
	 opVC4AbrASb8wDoM+kcU7HxaAG4uwq2AQ6I0eqN+0WkCKWaTUfk9tpYWvsv8m99NLeKf1
	 og+b4iUj8PjuC+ViH0qgeyz/wfKnA7eeVAY7IyrgzQi4bW9lxuqby16/cVLhIFPVkBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYPwkCkz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C1E606A335;
	Wed, 18 Nov 2026 21:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYPwkCkz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7908E1F000C7;
	Wed, 18 Nov 2026 21:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036350;
	bh=bioPyUeBo8L8tMJIxbE1/xlqEJmqq8WD7jpgdR+a0Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYPwkCkzUd/4xccBVgd90YUDHCceO1urval7HJNRx1XBRnAV0LWz7BE7DSAR1wrHf
	 mq9jWSrPTcC33cLucnIONt1pYKjG+/5siJS4u09T2lDP62689ew5zWEzG19aztPpj5
	 VIqr7BlZIEPhT5Q1TqsNyqQwUWyPy+uMUoSck6ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1029/3318] wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory
Date: Wed, 18 Nov 2026 15:27:31 +0100
Message-ID: <20261118150350.758948770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 02da543dfc5cf..b7162c2499c82 100644
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
index 28005f861f030..873d2f2bd840f 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -777,7 +777,7 @@ int mt76_skb_adjust_pad(struct sk_buff *skb, int pad)
 		}
 	}
 
-	if (skb_pad(last, pad))
+	if (__skb_pad(last, pad, false))
 		return -ENOMEM;
 
 	__skb_put(last, pad);
-- 
2.53.0



