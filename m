Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042819;
	b=e1lu+e9FIEh7V01n34xtD2xAPw0jHwLAbV8Hqvb6sfxqYixmx342Nwpqf9DDcCXeSH8b
	 vGA9WCvdUt16qW74yvpdRpcsJPy9JNmrcSWoDI5TK0yb2Pk2bm6eOFi4/UKpjIAr+riih
	 1vjE9gHjVJ0vV80/Ye0BHgZSj2nnRbuumVxYNTA+opiuE/yNigMcqE8PrEsteFkJa6MMA
	 HKqEJPCOAIHWkNDhBhZdZlYPNbNNPiyxKSSAGfaUUKx1J3tXvm9TLjwNAlbxnQl4ZIa92
	 AjiS5C33ktDGnc/+X42s2IeA65BIxEU752VIhCP2wwlDjm4SUzY3/Xu8hVA0aRhHdjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wKGSGkgbRnLED6j8o6Vp8a1bjUeWGmk7SnO3tAx7NSg=;
	b=vaL2jRg3ZVTPtXPDDvWe08eRaNpKnoMFxc3mMMSHd5qN/CpuFTi2DSCp84FoPH9zEkEM
	 3YD9digIR4OIWPQ/1SOhWVYeCUJF66G2wgvO9eDh7OJ6jsljJgRJuDNqOi0rYrTf88u+R
	 wVuPDfr/l9T3AzF4m0IQWomjbqa4r51kVrX2YcpDY9IhlbQfvSYwRxkaOAiYCzlNFsVlA
	 CcETAwTKb+LAZ0nwYUa2ZTJzsJ4MIcK+t6mjJG+C8W5rTHoQJNIZjCXnjUWn9leMt6qVz
	 tLnqsQCZ1r/IE3Z33+CWUWY8lVDxvgprjHoa4e7hReONkS7A0dQzfCVxRUB01QrBbWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tDX6Gvkk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9105C606A335;
	Wed, 18 Nov 2026 23:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tDX6Gvkk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8529C1F000C4;
	Wed, 18 Nov 2026 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042819;
	bh=wKGSGkgbRnLED6j8o6Vp8a1bjUeWGmk7SnO3tAx7NSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tDX6GvkknRSn/bRdpBcXtn3C7R2Vtm2wkVBLZl/eoe3LqT/Cnp90qMI32vgCBx548
	 tkrN4sxHQFoqtMVKtXlTvixvFVs2H901Xoh8l2PfclNS4OBFcKg0ppNhsnrdO6iSe4
	 IW2MdwUQBS+37UpUjP6+49Dt0KttSDv7vnw2QWZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 3306/3318] net: bcmgenet: stop Tx NAPI before disabling the queues
Date: Wed, 18 Nov 2026 16:05:28 +0100
Message-ID: <20261118150458.768459364@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

commit 7e87508b5c4d81210d0a736ed01962e52f5c4c56 upstream.

bcmgenet_netif_stop() and the Wake-on-LAN branch of bcmgenet_suspend()
both disable the Tx queues first and stop Tx NAPI several steps later. A
completion in flight calls netif_tx_wake_queue() in between, and nothing
stops the queue again, so a transmit can reach the rings after they have
been freed.

Close is safe because dev_deactivate_many() stops the qdisc first.
bcmgenet_suspend() does not, so stop Tx NAPI before the queues on both
paths.

KASAN on a Raspberry Pi CM4, driven from an MTU change because suspend
freezes user space before the callback runs:

  BUG: KASAN: use-after-free in bcmgenet_xmit+0x17f8/0x2258
  Write of size 8 at addr ffffff8055844a68 by task ksoftirqd/0/14
   bcmgenet_xmit+0x17f8/0x2258
   dev_hard_start_xmit+0x13c/0x588
   sch_direct_xmit+0x108/0x340
   __dev_queue_xmit+0x1190/0x3848

Fixes: 254f3239dd07 ("net: bcmgenet: revise suspend/resume")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260922130639.1660797-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3360,6 +3360,8 @@ static void bcmgenet_netif_stop(struct n
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
+	/* Stop completion polling before it can wake a stopped queue */
+	bcmgenet_disable_tx_napi(priv);
 	netif_tx_disable(dev);
 
 	/* Disable MAC receive */
@@ -3374,7 +3376,6 @@ static void bcmgenet_netif_stop(struct n
 	/* Disable MAC transmit. TX DMA disabled must be done before this */
 	umac_enable_set(priv, CMD_TX_EN, false);
 
-	bcmgenet_disable_tx_napi(priv);
 	bcmgenet_disable_rx_napi(priv);
 	bcmgenet_intr_disable(priv);
 
@@ -4308,6 +4309,8 @@ static int bcmgenet_suspend(struct devic
 	netif_device_detach(dev);
 
 	if (device_may_wakeup(d) && priv->wolopts) {
+		/* Stop completion polling before it can wake a stopped queue */
+		bcmgenet_disable_tx_napi(priv);
 		netif_tx_disable(dev);
 
 		/* Suspend non-wake Rx data flows */
@@ -4317,7 +4320,6 @@ static int bcmgenet_suspend(struct devic
 			netdev_warn(priv->dev,
 				    "Timed out while disabling TX DMA\n");
 
-		bcmgenet_disable_tx_napi(priv);
 		bcmgenet_disable_rx_napi(priv);
 		disable_irq(priv->irq1);
 		bcmgenet_tx_reclaim_all(dev);


