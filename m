Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7919A4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0059FC433EF;
	Wed, 15 Mar 2023 12:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883190;
	bh=+Ivv/IDeFjAGOEFH/+ujPWc7GRrwzQ0jrwEFaB9GkB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZ1cVB3w2p/Hw0Voe50iKqjnKi9eHrK5DS5WwEV/z6HHPGzN9rLLbd056SelMObZA
	 Jo4iq9A0nAzl2YTj+xv/+WJvL5FDE21XadLWiWxfjOxO6sxkds7+D6p77cp7/paIMV
	 Mj9y5KcxZCKHfGp0AMST9rJwwSlOd2zqOUt9Y9tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Mason <jdmason@kudzu.us>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Leon Romanovsky <leonro@nvidia.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/145] bgmac: fix *initial* chip reset to support BCM5358
Date: Wed, 15 Mar 2023 13:11:56 +0100
Message-Id: <20230315115740.711760180@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit f99e6d7c4ed3be2531bd576425a5bd07fb133bd7 ]

While bringing hardware up we should perform a full reset including the
switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
specification says and what reference driver does.

This seems to be critical for the BCM5358. Without this hardware doesn't
get initialized properly and doesn't seem to transmit or receive any
packets.

Originally bgmac was calling bgmac_chip_reset() before setting
"has_robosw" property which resulted in expected behaviour. That has
changed as a side effect of adding platform device support which
regressed BCM5358 support.

Fixes: f6a95a24957a ("net: ethernet: bgmac: Add platform device support")
Cc: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230227091156.19509-1-zajec5@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac.c | 8 ++++++--
 drivers/net/ethernet/broadcom/bgmac.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index fa2a43d465db7..f8fd65ab663ee 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -890,13 +890,13 @@ static void bgmac_chip_reset_idm_config(struct bgmac *bgmac)
 
 		if (iost & BGMAC_BCMA_IOST_ATTACHED) {
 			flags = BGMAC_BCMA_IOCTL_SW_CLKEN;
-			if (!bgmac->has_robosw)
+			if (bgmac->in_init || !bgmac->has_robosw)
 				flags |= BGMAC_BCMA_IOCTL_SW_RESET;
 		}
 		bgmac_clk_enable(bgmac, flags);
 	}
 
-	if (iost & BGMAC_BCMA_IOST_ATTACHED && !bgmac->has_robosw)
+	if (iost & BGMAC_BCMA_IOST_ATTACHED && (bgmac->in_init || !bgmac->has_robosw))
 		bgmac_idm_write(bgmac, BCMA_IOCTL,
 				bgmac_idm_read(bgmac, BCMA_IOCTL) &
 				~BGMAC_BCMA_IOCTL_SW_RESET);
@@ -1490,6 +1490,8 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	struct net_device *net_dev = bgmac->net_dev;
 	int err;
 
+	bgmac->in_init = true;
+
 	bgmac_chip_intrs_off(bgmac);
 
 	net_dev->irq = bgmac->irq;
@@ -1542,6 +1544,8 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	/* Omit FCS from max MTU size */
 	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
 
+	bgmac->in_init = false;
+
 	err = register_netdev(bgmac->net_dev);
 	if (err) {
 		dev_err(bgmac->dev, "Cannot register net device\n");
diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index 110088e662eab..99a344175a751 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -474,6 +474,8 @@ struct bgmac {
 	int irq;
 	u32 int_mask;
 
+	bool in_init;
+
 	/* Current MAC state */
 	int mac_speed;
 	int mac_duplex;
-- 
2.39.2



