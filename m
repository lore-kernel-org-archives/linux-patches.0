Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0C0334695;
	Sat, 30 May 2026 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162200; cv=none; b=JO5leKpgoOR8CKAADg3Nf7tEixelCAtkKakXICxvP4pKgF5d/pYOublZ/56R2jUb7gSVecanAK2tclSXlYF+gll1gDeFMW6O7dkqbJDHIVKU+8weQGO9m83JOlBvkjyhtdAT9BkulDZBklP7VJqdWRH2Bx2GSeDkP8KBxzlu1A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162200; c=relaxed/simple;
	bh=ct6lDLuZ7aLOUbeQhMAHzCTUZFRvGaugHzbJjqa7feI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1W8hkJXKat8vrdbwV1hBQJcpymUwxoE7PxurZRxp/7+doVPrH8GJvSIOfRWAqh0MQddPwTf9rD4Zfle/UiiYDnpicpBvLM87q/MoEoW+R5hh+9fLEV7/TtkldW6qjYqmeUQiaVkG6Nt2O5DbirQs84ACSdfqiolqHiHqWrkaak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=od4bPVE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="od4bPVE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A29C1F00893;
	Sat, 30 May 2026 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162199;
	bh=rv8AQkL6WSwPrEx3VAUc7q4g9sirOuy4x3+15sVBAVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=od4bPVE2SSqlfJo1OvTfWNE/BLlMdOxYg53oXz+VFmHev39msleanxHJ6VCgp4goX
	 EMP7A84/NiHJw7cJD8sewHYYyS7og6Cs4CO3e5Fw1uxzDYTH4ADbgmbhsjQ8C6rKzY
	 RSe+6GHspT9YmG7vAQngrNhW1GEmfyBBF2lA0/n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 850/969] net: bcmgenet: keep RBUF EEE/PM disabled
Date: Sat, 30 May 2026 18:06:14 +0200
Message-ID: <20260530160324.137300439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

commit 9a1730245e416d11ad5c0f2c100061d61cc43f60 upstream.

Setting RBUF_EEE_EN | RBUF_PM_EN in RBUF_ENERGY_CTRL breaks the RX
path on GENET hardware once MAC EEE becomes active. RX traffic stops
flowing while the link stays up and the usual descriptor/RX error
counters remain quiet. In that state the MAC still accepts frames
(rbuf_ovflow_cnt keeps climbing) but RBUF no longer forwards them to
DMA, so rx_packets is no longer incremented at the netdev level. On
some boards the corruption ends up as a paging fault in
skb_release_data via bcmgenet_rx_poll on an LPI exit.

Reproduced on Pi 4B (BCM2711 + BCM54213PE) and confirmed by Florian
Fainelli on an internal Broadcom 4908-family board with the same crash
signature. RBUF_PM_EN is not publicly documented.

This shows up more often now that phy_support_eee() enables EEE by
default, but it also affects older kernels as soon as TX LPI is
turned on via ethtool, so it is not specific to recent changes.

Always clear RBUF_EEE_EN | RBUF_PM_EN in bcmgenet_eee_enable_set so
the bits stay off across resets. UMAC and TBUF setup is left alone so
TX-side EEE keeps working.

Link: https://github.com/raspberrypi/linux/issues/7304
Fixes: 6ef398ea60d9 ("net: bcmgenet: add EEE support")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260520184320.652053-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1344,13 +1344,12 @@ void bcmgenet_eee_enable_set(struct net_
 		reg &= ~(TBUF_EEE_EN | TBUF_PM_EN);
 	bcmgenet_writel(reg, priv->base + off);
 
-	/* Do the same for thing for RBUF */
+	/* RBUF EEE/PM can break the RX path on GENET. Keep it disabled. */
 	reg = bcmgenet_rbuf_readl(priv, RBUF_ENERGY_CTRL);
-	if (enable)
-		reg |= RBUF_EEE_EN | RBUF_PM_EN;
-	else
+	if (reg & (RBUF_EEE_EN | RBUF_PM_EN)) {
 		reg &= ~(RBUF_EEE_EN | RBUF_PM_EN);
-	bcmgenet_rbuf_writel(priv, reg, RBUF_ENERGY_CTRL);
+		bcmgenet_rbuf_writel(priv, reg, RBUF_ENERGY_CTRL);
+	}
 
 	if (!enable && priv->clk_eee_enabled) {
 		clk_disable_unprepare(priv->clk_eee);


