Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4A428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B1CC433F0;
	Mon, 12 Dec 2022 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852825;
	bh=bTEqz/kWG0BSM5vbDXObsmDMqkOyijuaHXYk35zUPDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iW+g5ROa627qiN3xQTkuaBsf1soZYWZjOzGZOW37pzXwruUirb6ue1g/i22IwT4VJ
	 QaFqDHQzKP1wni16uMkSYhaKY6E8BdQ+CosK6iwsI4Hyl/S2ib2dX9M04wTpZooHRR
	 CK1+vwMuknYF6SsInYkd0Pv1OLIpXu1RJ89ERafI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 149/157] net: dsa: mv88e6xxx: accept phy-mode = "internal" for internal PHY ports
Date: Mon, 12 Dec 2022 14:18:17 +0100
Message-Id: <20221212130941.197162885@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 87a39882b5ab3127700ac4b9277608075f98eda2 ]

The ethernet-controller dt-schema, mostly pushed forward by Linux, has
the "internal" PHY mode for denoting MAC connections to an internal PHY.

U-Boot may provide device tree blobs where this phy-mode is specified,
so make the Linux driver accept them.

It appears that the current behavior with phy-mode = "internal" was
introduced when mv88e6xxx started reporting supported_interfaces to
phylink. Prior to that, I don't think it would have any issues accepting
this phy-mode.

Fixes: d4ebf12bcec4 ("net: dsa: mv88e6xxx: populate supported_interfaces and mac_capabilities")
Link: https://lore.kernel.org/linux-arm-kernel/20221205172709.kglithpbhdbsakvd@skbuf/T/
Reported-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Tim Harvey <tharvey@gateworks.com> # imx6q-gw904.dts
Link: https://lore.kernel.org/r/20221205194845.2131161-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 07e9a4da924c..546d90dae933 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -825,10 +825,13 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 
 	chip->info->ops->phylink_get_caps(chip, port, config);
 
-	/* Internal ports need GMII for PHYLIB */
-	if (mv88e6xxx_phy_is_internal(ds, port))
+	if (mv88e6xxx_phy_is_internal(ds, port)) {
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+		/* Internal ports with no phy-mode need GMII for PHYLIB */
 		__set_bit(PHY_INTERFACE_MODE_GMII,
 			  config->supported_interfaces);
+	}
 }
 
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
-- 
2.35.1



