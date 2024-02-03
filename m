Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E878B11738;
	Sat,  3 Feb 2024 04:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933965; cv=none; b=oB+tTnc8UqD679m/B866q7AyJQrSnFAilR3jReACJOLqBDSOnWSwYT12tiASn1YYnLvKaRSE5g2bxAaKyQh3p2oGCis3H1xYRTq/nXV6R5qNfmPL8A6BuK9tLgQGhmnDw6HApmztnv6UFLG5SySbAaNGxc59SZVeJ3kxTxCfv6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933965; c=relaxed/simple;
	bh=pDL+dMXmKoC5eKXNIsBFl1nT4kpb4Ye4LH+i0DkzOdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYLLNccvbGHtWBNW4RNJmb04eDHew31nvb15wYzKCrrZED4xBVcDfjQa9ClXR++La8zVO0f730oRq7ZY6fjGczw+hozkSTJp2O5+dwSfeYoJtHLjlX7XjM6qniDt4uiXjssquqkczABhTYqijGFxeXtT5x5dUBeeNAeZqjfJ7tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0RsZqSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0RsZqSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CB5C433C7;
	Sat,  3 Feb 2024 04:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933964;
	bh=pDL+dMXmKoC5eKXNIsBFl1nT4kpb4Ye4LH+i0DkzOdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0RsZqSzzGNhqx+C3ALRY+5Y8mL3qabQEZ8ec1o+aPnCnGpgy5vZQp4EwAxVctoIw
	 oC3cmRuA20IDuGPyacLwLxH6Th+xpIBFeihd5wXeVzwAFOpG1GZQTnVckKoumdwIJx
	 cmQ6I0iZE/etwwcXb9VAwjAb8LUx0h04xERd5y6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 310/353] net: lan966x: Fix port configuration when using SGMII interface
Date: Fri,  2 Feb 2024 20:07:08 -0800
Message-ID: <20240203035413.646644595@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



