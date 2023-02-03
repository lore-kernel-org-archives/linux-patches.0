Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2941FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E677EC433EF;
	Fri,  3 Feb 2023 10:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419573;
	bh=kAmwKKv6PwOnZevaeXSMnkcJRQxGEcdLvHzMv46LsRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w39s189b79CpnNRcGj+4kBRotiESjNxL+pocNyK3qm5O5LsM4n40Sp0i0VmfOyeYm
	 Y3rgFj0FdMKuMY2zlVPy9Oi1Xz1Lcfvnj6MULO7YtWkYrCfrx5zUkms3V5Ad5l6pS3
	 3eLtOdE+F7V+gnlJcM5OujO0qNK1bq7oiy5o4ZSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/80] net: mdio: validate parameter addr in mdiobus_get_phy()
Date: Fri,  3 Feb 2023 11:12:11 +0100
Message-Id: <20230203101015.934621944@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
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
index 1d1fbd7bd6fc..550806351049 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -103,7 +103,12 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 
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



