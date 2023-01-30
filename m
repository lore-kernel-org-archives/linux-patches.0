Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFD728EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00CAC433EF;
	Mon, 30 Jan 2023 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087054;
	bh=tKt6c7F6Gt94nTVTTVySBu2cyDoTV6dVAFtejkWda/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkB2O8QRx6pmDCCV+6ztGBDQfgwI0c3uqFLiHj0s42gip0R88OZeAxQkKFM7HkSsZ
	 38HVHKfrnvdcdKCD/E25ffI08YdCpFY4uZ+JyEQJ22Gn8ZJuIpdYv4cCaoEUWlzA5i
	 RXIodOo0lHjMWMxd7S1n5r6wMuJP52MEui0UbQcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/313] net: mdio: validate parameter addr in mdiobus_get_phy()
Date: Mon, 30 Jan 2023 14:48:38 +0100
Message-Id: <20230130134340.507280423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 867dbe784c5010a466f00a7d1467c1c5ea569c75 ]

The caller may pass any value as addr, what may result in an out-of-bounds
access to array mdio_map. One existing case is stmmac_init_phy() that
may pass -1 as addr. Therefore validate addr before using it.

Fixes: 7f854420fbfe ("phy: Add API for {un}registering an mdio device to a bus.")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/cdf664ea-3312-e915-73f8-021678d08887@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 1cd604cd1fa1..16e021b477f0 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -108,7 +108,12 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
-	struct mdio_device *mdiodev = bus->mdio_map[addr];
+	struct mdio_device *mdiodev;
+
+	if (addr < 0 || addr >= ARRAY_SIZE(bus->mdio_map))
+		return NULL;
+
+	mdiodev = bus->mdio_map[addr];
 
 	if (!mdiodev)
 		return NULL;
-- 
2.39.0



