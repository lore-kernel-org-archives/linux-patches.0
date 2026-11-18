Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033395;
	b=QZ8PdbYBzdBh3j2TpT3R0Qjg9EFLA2EmT0rgVyaVq8oAfmPlhT1ThgOhvouqlqFe+SWB
	 a9JSapgXlJrWh8v2gHnq1SCiSWeCCdTFpVxI3KK0YlEBqd2nXbLi4dvdoGJkkSAfgrxIZ
	 Hm3dNre2HDJvSe65bq3zHPoPLJGkL88pnK2dHvx4E4ALGwOHEqAddHzrRLutCXTxj4uSF
	 W+qnmY3YoJi/1ao3CGJNPlDh51k48ziPseu0namNSpeWnu4hjxFlSsZiB+MQKgll0frB2
	 FHAOsbjm6gDfeKTZxJ0+f9Enk6w6MwvClvo2hN58GsSm1ygO1KGp6ETqJlZuZojB00A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2vVyQabnt/CzEyeZY0e5Bteavs5N/4g3fngM2TFqLkM=;
	b=2QKpTnfEeu/ECpz9GOB8g2JiwHirrny3+XyD38T2mfB5OjLwUT9EHYprFeNhenIizN21
	 7iqODNZjW6r14WhGgxtpUuqtB8tBSGtuoUQ70V8AD93GG+ZXab5bfNsmgB67YO2PDDdPB
	 ha7hRicjkH2v2eR7EUJatGljksi/4rdRBXpkOe8ywJAtR+4Vxv/MYt752s5vch7tcCQr3
	 G6739i42vC92t+fLFBXLK6il8gt9FbFzRfMB17fcsy484Rac+ZBGy+Q8jjxyp8kpMUnMA
	 v8wh2EEBKjN9pN2YZVKuOVUhz9eNWeL73x0Qb1hFcW6//vLv6LvVf1fuLppc+WUiqqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pKfC7Q2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE6960A260C;
	Wed, 18 Nov 2026 20:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pKfC7Q2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC451F000CE;
	Wed, 18 Nov 2026 20:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033395;
	bh=2vVyQabnt/CzEyeZY0e5Bteavs5N/4g3fngM2TFqLkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKfC7Q2KJZCwETTIu1Hn5iJ8h5qeCxJ3tCu3HnWyL+5NVm3i1mvzs72U3CstbbrQ+
	 GRptc6LUnD9b8dB3Ryz8rEDY1geikGEfK+NX3nZLAIMZEhrleWWB2XQ4er1S9QCvJg
	 82BcLZEbAgLNvDjMeIir0Im2797/Cw6yC2oD2OKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1754/1756] net: bcmgenet: stop Tx NAPI before disabling the queues
Date: Wed, 18 Nov 2026 16:04:41 +0100
Message-ID: <20261118150119.357686193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
@@ -3351,6 +3351,8 @@ static void bcmgenet_netif_stop(struct n
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
+	/* Stop completion polling before it can wake a stopped queue */
+	bcmgenet_disable_tx_napi(priv);
 	netif_tx_disable(dev);
 
 	/* Disable MAC receive */
@@ -3365,7 +3367,6 @@ static void bcmgenet_netif_stop(struct n
 	/* Disable MAC transmit. TX DMA disabled must be done before this */
 	umac_enable_set(priv, CMD_TX_EN, false);
 
-	bcmgenet_disable_tx_napi(priv);
 	bcmgenet_disable_rx_napi(priv);
 	bcmgenet_intr_disable(priv);
 
@@ -4297,6 +4298,8 @@ static int bcmgenet_suspend(struct devic
 	netif_device_detach(dev);
 
 	if (device_may_wakeup(d) && priv->wolopts) {
+		/* Stop completion polling before it can wake a stopped queue */
+		bcmgenet_disable_tx_napi(priv);
 		netif_tx_disable(dev);
 
 		/* Suspend non-wake Rx data flows */
@@ -4306,7 +4309,6 @@ static int bcmgenet_suspend(struct devic
 			netdev_warn(priv->dev,
 				    "Timed out while disabling TX DMA\n");
 
-		bcmgenet_disable_tx_napi(priv);
 		bcmgenet_disable_rx_napi(priv);
 		disable_irq(priv->irq1);
 		bcmgenet_tx_reclaim_all(dev);


