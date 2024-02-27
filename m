Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFEC13B2B8;
	Tue, 27 Feb 2024 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043628; cv=none; b=pldKPXukiPXiPCcK5WE/YFaXH7QDK2wu5EGB1elhn6sYyJx97IJbgbod7YiLd36ygQ3VB04kB/oUQkdiUGKIk+v/0/DwiWLECkD+L+gAaQDa8/dCMGom3+c6yS/ntTCQyI5RzNWTWE6HLr1X0TKXRtXKKoR4aufBCNWmaCPGFrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043628; c=relaxed/simple;
	bh=b2pmgYAsu6UN2sRO+d/ztErlMZik29j5S7eIWiof2+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvcBgeGU4uUcyUCIBen7dH2uHUzEPLKcbWCHB7CQUpXhDMaQor8vK832dFaiC+1OmHf5rOgtBbV+zFHvHzqnC4BrM4O9dkRCx8mQB0eIg9UifXvv3uCI+fYHpn66uZnai5FQrdhQOBDIp+s/QE/wqCIYf/xWywrVQj57awvRmZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g79ZG1NK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g79ZG1NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461C0C433C7;
	Tue, 27 Feb 2024 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043627;
	bh=b2pmgYAsu6UN2sRO+d/ztErlMZik29j5S7eIWiof2+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g79ZG1NKrU26WHOVglR4oCp/7H8YtaiwYdcBSVynwA/g2EBgAb33wzY4zgblpoQfo
	 AYm0YbJZnTsYeI0yyWA21petF5b4diuG1Y9MLFSECX6jqRBBTjqhEVkFHSry+rA2Hc
	 bq8KB2TTz5DXZaNOLQmBChK9dk9brZx7kdwHISMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/195] net: sparx5: Add spinlock for frame transmission from CPU
Date: Tue, 27 Feb 2024 14:27:18 +0100
Message-ID: <20240227131616.247542040@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 603ead96582d85903baec2d55f021b8dac5c25d2 ]

Both registers used when doing manual injection or fdma injection are
shared between all the net devices of the switch. It was noticed that
when having two process which each of them trying to inject frames on
different ethernet ports, that the HW started to behave strange, by
sending out more frames then expected. When doing fdma injection it is
required to set the frame in the DCB and then make sure that the next
pointer of the last DCB is invalid. But because there is no locks for
this, then easily this pointer between the DCB can be broken and then it
would create a loop of DCBs. And that means that the HW will
continuously transmit these frames in a loop. Until the SW will break
this loop.
Therefore to fix this issue, add a spin lock for when accessing the
registers for manual or fdma injection.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Link: https://lore.kernel.org/r/20240219080043.1561014-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c   | 1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_main.h   | 1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 3423c95cc84ae..7031f41287e09 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -744,6 +744,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, sparx5);
 	sparx5->pdev = pdev;
 	sparx5->dev = &pdev->dev;
+	spin_lock_init(&sparx5->tx_lock);
 
 	/* Do switch core reset if available */
 	reset = devm_reset_control_get_optional_shared(&pdev->dev, "switch");
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 7a83222caa737..cb3173d2b0e8d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -278,6 +278,7 @@ struct sparx5 {
 	int xtr_irq;
 	/* Frame DMA */
 	int fdma_irq;
+	spinlock_t tx_lock; /* lock for frame transmission */
 	struct sparx5_rx rx;
 	struct sparx5_tx tx;
 	/* PTP */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 6db6ac6a3bbc2..ac7e1cffbcecf 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -244,10 +244,12 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	skb_tx_timestamp(skb);
+	spin_lock(&sparx5->tx_lock);
 	if (sparx5->fdma_irq > 0)
 		ret = sparx5_fdma_xmit(sparx5, ifh, skb);
 	else
 		ret = sparx5_inject(sparx5, ifh, skb, dev);
+	spin_unlock(&sparx5->tx_lock);
 
 	if (ret == -EBUSY)
 		goto busy;
-- 
2.43.0



