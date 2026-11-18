Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046226;
	b=1q/FXcCL7JXjEHZLmhS9YUWM2ld8vZS+d9ZnIhXCkSJbvqMGhCvSF0VD5rEf430AjqTd
	 hpqWH5JuA5l7m8wTlU7d8tKREMUr82+s5bZZBHEld5Qhi4CcoYDXQ6uuHqhDKYXKcDntF
	 vGRUGqxX1xbtgOjtgm/TB4AL+eEH9L1tCchg7FAnhkHbBZHq3bMTjj5D3eiulDyXFxYF5
	 KjRT35fWAbQIg1+J2jAdgdzO6y4TJllFhB/BIbNX+22yceEOuVdoHLJ0HSfhOOvZLBnET
	 G1SCjzX8xLAQy967ItJUOJG9Y45L0hVOn0vdxOZLpbzgKtySmuq1Sm880nihsSji6sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GEah/4BJ06jmE6T7MqcCmE7WOxk6DqIIszN91KNcPnE=;
	b=pcL1EGom3twEJHlA64JS7S7QFjBVFqRqBppb51zbD6VP7d2mIgkidqqMcb2SQCoRueZ4
	 a7RgM2xp31TSLQNpJNVmZA7/JO+9qChm97r5OASer3sPhxletga/OLO/ydb+xYBCzfm1T
	 es/ErZ5pNkQccrEV/SEvcS89MFUnfQ+VdtcIXG3GxtBbUuMf3zOjUkbJ62fmgUj4VZeCl
	 ZrSHEbJ2j4xeMjZZHd/0hjM/vi794JnFB+qgQQlz23BxlW3StQJeOllMqkHXeH4gVwweO
	 VuKWkZzuaMlhEgzDv67shJyTnarpk+5/gb/d5cA8xo7ZGq7BGuUVz58uJ76zerBmSaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgw859Qh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015D4606A31C;
	Wed, 18 Nov 2026 23:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgw859Qh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5220A1F000C4;
	Wed, 18 Nov 2026 23:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046225;
	bh=GEah/4BJ06jmE6T7MqcCmE7WOxk6DqIIszN91KNcPnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgw859Qhdt1Q+OcVEmO81+y7gTsjDD/tdM9plfkYvUwmZdINbf9fECpKSrulvdb3D
	 /0xyKnQllSqqimsVfi+dwm6QxUFAStzExwx7iQX3+LHcPnUBFhB5AGx2uQ3Dry06sv
	 JgdcqkPgT0x58idIAn38i6l6PKZz7QW9tczLBVFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1165/2857] net: bgmac: enable interrupts only after NAPI is ready
Date: Wed, 18 Nov 2026 15:36:39 +0100
Message-ID: <20261118150243.536259643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 52ee3751187a2..37debd7abf267 100644
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
@@ -1609,10 +1609,10 @@ int bgmac_enet_resume(struct bgmac *bgmac)
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



