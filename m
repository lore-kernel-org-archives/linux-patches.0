Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590107;
	b=PAFsDFDBr0pg10BXHg+IjZlHRAsfZSiivdsYcGDl4w3jg4sYUQR1HXDGwfvn54d3KW1r
	 U6h8zw4S1c08aUR7eP/s89mZupkHcSqe9vcBiKOyePvCBm3OmlS45xrJlIbVeydFfFP6Q
	 guOkCtC+17CHs0Hc0Ex/cFkG33XshvQF7atnH9F3oGBuYBZdpCtj2r4AP6YT9NuoyNq7Y
	 /TMqxVTvnISzLBk08B1VsLwcCMmIvVF8rqtS/8t5ibql4TWZxeMlZrtEyWZrF4Q1xD4LO
	 w9KUr+QCFRG49gV8PqpzJFh/fSvwkyJBPhXiWVPhwvIHmcZHGdf/+zWAwYmDUPjnVow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4PPp/2Qk8UFFAa9lZiLtvWl2ZXhfEbRxA639djIpRCw=;
	b=A/4tmHsHpY4SBEFCRf04JgUXX1FgvE0eE7zl2rxaT9GVa2xIY+HDt5nUkByun9u+Gy0v
	 gPPcxFw6RCxa7Ki75L/0/0F2W1E6kjTAg/7Y2NSxgYVKuUbhmjDkKQivn60yIIta7h/cv
	 EoG8U68uSrZP0Pvl2TKdXMtyytEVPG/Hb+6+QzNnKaG8an9FZljGaSv5C1tFnrpiv25/G
	 MFw7aSGRHQ4nFOPKoIxNFLFuzjZkfZCvGBnOf78DjgOcF6E19nNwdrvmQo3AMKvSHG7Ly
	 1GDLIPtFhLv8RL6Pa0yzpptGR+GTlu905IXlU1NEWP0WgfsfH9ZOzLQIL6HDkvETkEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxPOEqOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00091606C0B9;
	Fri, 13 Nov 2026 17:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxPOEqOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03681F000C4;
	Fri, 13 Nov 2026 17:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590106;
	bh=4PPp/2Qk8UFFAa9lZiLtvWl2ZXhfEbRxA639djIpRCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxPOEqOd066qVyG3RdS36ChrkqDTVDIRKYTkN6L67qPigaehGyiYy2ITAL426u7m8
	 kotSdih+VTF5h/8zOEQ1+QTmBA9Mv3SGuXVsG3I2sdXHqNGrUIaRp/YPjzVyenUxMY
	 wMDoz3QLXFUHDOajxATZl4bmc+G0vSMHen2M3NAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/686] net: bgmac: enable interrupts only after NAPI is ready
Date: Fri, 13 Nov 2026 10:43:46 -0500
Message-ID: <20261113153824.019334983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ac1f6e58cb77bb66b8811f7d98703e0f076a8f65 ]

bgmac_open() calls bgmac_chip_init(), which unmasks the interrupts and
enables the MAC receiver, before request_irq() and napi_enable().
bgmac_enet_resume() also enables NAPI only after bgmac_chip_init().

When frames arrive in that window, the first RX interrupt masks all
interrupts in bgmac_interrupt() and calls napi_schedule() on a NAPI
instance that is still disabled, so nothing is scheduled. Nothing
unmasks the interrupts again, the RX ring fills up and the interface
stays deaf until it is brought down and up without traffic.

On an Asus RT-N16 (BCM4716) a single "ip link set eth0 down/up" while
a host sends UDP to the router left INT_MASK at 0, INT_STATUS with RX
pending and the RX DMA idle on a full ring, with the RX packet and
interrupt counters no longer moving. With this change, 10 of 10 such
cycles recovered on their own.

Request the IRQ and enable NAPI before the chip is initialized.

Fixes: dd4544f05469 ("bgmac: driver for GBit MAC core on BCMA bus")
Fixes: f3537b3494c0 ("net: ethernet: bgmac: driver power manangement")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261010070011.60403-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 3e9c57196a397..1835266fdd09f 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1183,9 +1183,6 @@ static int bgmac_open(struct net_device *net_dev)
 	if (err)
 		return err;
 
-	/* Specs say about reclaiming rings here, but we do that in DMA init */
-	bgmac_chip_init(bgmac);
-
 	err = request_irq(bgmac->irq, bgmac_interrupt, IRQF_SHARED,
 			  net_dev->name, net_dev);
 	if (err < 0) {
@@ -1195,6 +1192,9 @@ static int bgmac_open(struct net_device *net_dev)
 	}
 	napi_enable(&bgmac->napi);
 
+	/* Specs say about reclaiming rings here, but we do that in DMA init */
+	bgmac_chip_init(bgmac);
+
 	phy_start(net_dev->phydev);
 
 	netif_start_queue(net_dev);
@@ -1608,10 +1608,10 @@ int bgmac_enet_resume(struct bgmac *bgmac)
 	if (rc)
 		return rc;
 
-	bgmac_chip_init(bgmac);
-
 	napi_enable(&bgmac->napi);
 
+	bgmac_chip_init(bgmac);
+
 	netif_tx_lock(bgmac->net_dev);
 	netif_device_attach(bgmac->net_dev);
 	netif_tx_unlock(bgmac->net_dev);
-- 
2.53.0



