Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B7818E27;
	Sat,  3 Feb 2024 04:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933685; cv=none; b=GpU/G87WAPtN2NiRUzIGPStQsOMDCTQk+eP/JV3VMwUithL8i6YZ/zVMT2oYnS2AIfni2qr1r19HzKuCdFhWjBS1TOVtyr10UVDhbDvHD4SqvZzPTvfC8RETmUOybfMaTsIsYU2YlBWmhghh3UdVPqu0lcRnzifZWDurrsBWS5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933685; c=relaxed/simple;
	bh=w4iWHtTPodE9TM22TJ/Hz+l9GEqotChOhC0IAzMCuV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caHt7VPU9ARYmdrXrEwNuRiLgw5pGauBQH3mP6JG/hjOt1Lmbj8a0AASP5PEaDMhc9X8mWP3Fq79KLJZXHuCxGdfPNN9RBQsdWgpnTZnXijs81EO7aKdAzLlcUlK7DiduAaSn10xMznsq54PCRKXRGnk5DkfHsy87N2rL1QOjJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIjDKB8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIjDKB8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1EEC433B1;
	Sat,  3 Feb 2024 04:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933685;
	bh=w4iWHtTPodE9TM22TJ/Hz+l9GEqotChOhC0IAzMCuV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIjDKB8XVaTPKsh2AzWGiiCkU9hjH3VKSC1VpSSFYrzjAEKwYz75K/fm91EBG384X
	 Jx2M3YjtIfZHisU8hhy16wSrDghkO4v3pk3LdJitiO6Z4h6EeN6PzAKXry176Ilo1e
	 Mp7TPYUOUFE3tSsiCU+hXOWEWKwCv4MHR0zwhR1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/322] net: lan966x: Fix port configuration when using SGMII interface
Date: Fri,  2 Feb 2024 20:06:17 -0800
Message-ID: <20240203035408.142432715@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 62b4248105353e7d1debd30ca5c57ec5e5f28e35 ]

In case the interface between the MAC and the PHY is SGMII, then the bit
GIGA_MODE on the MAC side needs to be set regardless of the speed at
which it is running.

Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_port.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 92108d354051..2e83bbb9477e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -168,9 +168,10 @@ static void lan966x_port_link_up(struct lan966x_port *port)
 	lan966x_taprio_speed_set(port, config->speed);
 
 	/* Also the GIGA_MODE_ENA(1) needs to be set regardless of the
-	 * port speed for QSGMII ports.
+	 * port speed for QSGMII or SGMII ports.
 	 */
-	if (phy_interface_num_ports(config->portmode) == 4)
+	if (phy_interface_num_ports(config->portmode) == 4 ||
+	    config->portmode == PHY_INTERFACE_MODE_SGMII)
 		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA_SET(1);
 
 	lan_wr(config->duplex | mode,
-- 
2.43.0



