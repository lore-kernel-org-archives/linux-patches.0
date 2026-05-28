Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7775934040F;
	Thu, 28 May 2026 19:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998089; cv=none; b=VcbaswkrZa2t9P0FnapV4q/DSC/nGJpazaVdlAb6CHfNBAS4ZUgB0oQIV0dCO8WDqErVSgchPNHFwa7B62FqJzNP5toF6UmLqHPf3nQ0SmBlubtMNKtcsLGgKWzIfoq/3PtL13t8mB4272ns2dMP11pcqLN4t5c16RKVKquRLNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998089; c=relaxed/simple;
	bh=3wV0JnxL+4OyWbgMc7IxYOSaV5EJdKA0hv0fXbroKA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6eLqOmBkPUCrwpuPhNKeoMuuY9b4qwLEus+BS1IL91XHkeRa4xrQnbeNeDMec4ybc23MRxXf1yS1VYtadhxmnYVsEYHXOsqx5zjRnpv6PjIsb7YkVg/1JVtqB2WKrR44C5Q32rqNWuil1V9ORp3tp3Cuquqi6RHw9MHYENxw7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V04DAVuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V04DAVuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F83F1F000E9;
	Thu, 28 May 2026 19:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998088;
	bh=F/QyKEa4GKiiCwEG7833K49CmC+GqgF5xvPukMHELug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V04DAVuEna3SfKhuk2/QurTLJH0Z33/xXB8f1650cTUlJZITkQ7SggDkKlNsuY7DU
	 8LMeUIfZCw1fKJrTi++9Ap+NngvG9W3ppFiBU3yZDSjGv6Iv0aqkgZ6X24UzYdtSqJ
	 SivFRQcDVPr2MKJthfU1tzvy5CVx1dkQSRUcaQ0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 050/461] net: bcmgenet: keep RBUF EEE/PM disabled
Date: Thu, 28 May 2026 21:42:59 +0200
Message-ID: <20260528194648.357214935@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1368,13 +1368,12 @@ void bcmgenet_eee_enable_set(struct net_
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


