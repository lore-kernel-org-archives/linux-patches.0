Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA5F1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532CEC433C7;
	Tue, 25 Jul 2023 11:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284957;
	bh=ZGUqqsgD2DYVi7jT3d5v5n/Sw8SvMwZODIlfySPT2ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uufscgsNKTU0mZSdMHnB0Dus+q7vcHK1X8fAnGBK4aYt/LaOBHAizJjwOdc7G4uf2
	 depLVO1VMDWkzgssm8cUY39f4QDHdpYlYBBnhtNxOWcItwgosBJwbnihsHS3/trtSF
	 dLdsNBdrVX/f3F9Eh6UpUdVFVuWPdNSUysFHlYyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Mason <jdmason@kudzu.us>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Leon Romanovsky <leonro@nvidia.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 009/313] bgmac: fix *initial* chip reset to support BCM5358
Date: Tue, 25 Jul 2023 12:42:42 +0200
Message-ID: <20230725104521.587118780@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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

commit f99e6d7c4ed3be2531bd576425a5bd07fb133bd7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bgmac.c |    8 ++++++--
 drivers/net/ethernet/broadcom/bgmac.h |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -890,13 +890,13 @@ static void bgmac_chip_reset_idm_config(
 
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
@@ -1489,6 +1489,8 @@ int bgmac_enet_probe(struct bgmac *bgmac
 	struct net_device *net_dev = bgmac->net_dev;
 	int err;
 
+	bgmac->in_init = true;
+
 	bgmac_chip_intrs_off(bgmac);
 
 	net_dev->irq = bgmac->irq;
@@ -1538,6 +1540,8 @@ int bgmac_enet_probe(struct bgmac *bgmac
 	net_dev->hw_features = net_dev->features;
 	net_dev->vlan_features = net_dev->features;
 
+	bgmac->in_init = false;
+
 	err = register_netdev(bgmac->net_dev);
 	if (err) {
 		dev_err(bgmac->dev, "Cannot register net device\n");
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -511,6 +511,8 @@ struct bgmac {
 	int irq;
 	u32 int_mask;
 
+	bool in_init;
+
 	/* Current MAC state */
 	int mac_speed;
 	int mac_duplex;


