Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6881773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A17C433C8;
	Wed,  9 Aug 2023 11:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579896;
	bh=yHWbn/RL8yIza8MZ9dgybLm6YbLHKM42ZYXuDCIOum4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vo57yCAE5USbyvaxHgKgs1JuhqS+YqeQLjdKGNbXFmW5u7vHpYiK1aX1XnnWnCTgm
	 G0EKdINtPyqFvx1OZHEEM+vhfzvRBC3qw0bP59y+axuV1ltzjHMO7X8NpsiZ788JqF
	 FGNKu8d0mMBdju7fG8ZbXVR1zsdDJXXQiBt/t0M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 154/323] net: bcmgenet: Ensure MDIO unregistration has clocks enabled
Date: Wed,  9 Aug 2023 12:39:52 +0200
Message-ID: <20230809103705.205006474@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit 1b5ea7ffb7a3bdfffb4b7f40ce0d20a3372ee405 upstream.

With support for Ethernet PHY LEDs having been added, while
unregistering a MDIO bus and its child device liks PHYs there may be
"late" accesses to the MDIO bus. One typical use case is setting the PHY
LEDs brightness to OFF for instance.

We need to ensure that the MDIO bus controller remains entirely
functional since it runs off the main GENET adapter clock.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20230617155500.4005881-1-andrew@lunn.ch/
Fixes: 9a4e79697009 ("net: bcmgenet: utilize generic Broadcom UniMAC MDIO controller driver")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20230622103107.1760280-1-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -620,5 +620,7 @@ void bcmgenet_mii_exit(struct net_device
 	if (of_phy_is_fixed_link(dn))
 		of_phy_deregister_fixed_link(dn);
 	of_node_put(priv->phy_dn);
+	clk_prepare_enable(priv->clk);
 	platform_device_unregister(priv->mii_pdev);
+	clk_disable_unprepare(priv->clk);
 }


