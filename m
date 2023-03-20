Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F211C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A665C433EF;
	Mon, 20 Mar 2023 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325449;
	bh=gVDUWofQpGjrvDcWpgA6d4EKOgvTcNdL4WkyriL8SBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbkmjU09z7vridkDHxj4a7s5IzQbafSjiVH8JNP5BimifUIFcolfS/JQ+u3Z+oxuz
	 DgyO4ZshV+0K1TcaG6tNZPmeJy0YzwyneF6ldCo5Dm7yO5FxghQRIrgyYt5jlkhNcl
	 Z7lF+mH/b0Bnf69332p13Fve7swZkmwsDvcshSLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/198] i825xx: sni_82596: use eth_hw_addr_set()
Date: Mon, 20 Mar 2023 15:53:44 +0100
Message-Id: <20230320145511.143174676@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit f38373345c65529639a01fba3675eb8cb4c579c3 ]

netdev->dev_addr is now const, we can't write to it directly.
Copy scrambled mac address octects into an array then eth_hw_addr_set().

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://lore.kernel.org/r/20230315134117.79511-1-tsbogend@alpha.franken.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/sni_82596.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
index daec9ce04531b..54bb4d9a0d1ea 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -78,6 +78,7 @@ static int sni_82596_probe(struct platform_device *dev)
 	void __iomem *mpu_addr;
 	void __iomem *ca_addr;
 	u8 __iomem *eth_addr;
+	u8 mac[ETH_ALEN];
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	ca = platform_get_resource(dev, IORESOURCE_MEM, 1);
@@ -109,12 +110,13 @@ static int sni_82596_probe(struct platform_device *dev)
 		goto probe_failed;
 
 	/* someone seems to like messed up stuff */
-	netdevice->dev_addr[0] = readb(eth_addr + 0x0b);
-	netdevice->dev_addr[1] = readb(eth_addr + 0x0a);
-	netdevice->dev_addr[2] = readb(eth_addr + 0x09);
-	netdevice->dev_addr[3] = readb(eth_addr + 0x08);
-	netdevice->dev_addr[4] = readb(eth_addr + 0x07);
-	netdevice->dev_addr[5] = readb(eth_addr + 0x06);
+	mac[0] = readb(eth_addr + 0x0b);
+	mac[1] = readb(eth_addr + 0x0a);
+	mac[2] = readb(eth_addr + 0x09);
+	mac[3] = readb(eth_addr + 0x08);
+	mac[4] = readb(eth_addr + 0x07);
+	mac[5] = readb(eth_addr + 0x06);
+	eth_hw_addr_set(netdevice, mac);
 	iounmap(eth_addr);
 
 	if (netdevice->irq < 0) {
-- 
2.39.2



