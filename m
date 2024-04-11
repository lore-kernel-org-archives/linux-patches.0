Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F5B145B06;
	Thu, 11 Apr 2024 10:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830040; cv=none; b=gE+GfCvd30UVitm7F81qsudjR4qFsjEeh/biqqtHT9Z+1H4dZ5tOF3FHKYWv7axr/Mlg98INH2VgLl+k+QUBJXE1BPeJVp2vQH4f+d/kN15Z1ikCvqRQbrPHGFR6QDwd8k80iNn4M25aXHlmLzH8ovna7q9jfxkVJHElj5sKdx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830040; c=relaxed/simple;
	bh=gGlz7krqbfAh5MEPedsHrl3c32TZ81GRJUq291awbSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/xdXBceKWMp5azYsw6u/nih42SfeRcYsFEMUdDpCT6PmT3FScocxP19M3QgflRcjApKOEpwhdL1Lhckpz8ma7/dbRul03471WQRq2G9Mc9g9J+jmVe3I0t64nOF+t5hwW6sZnqeueRGNfI5UhBKDjwtWkv9773JN+3vzhwdSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZzrsu4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZzrsu4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CDEC43390;
	Thu, 11 Apr 2024 10:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830039;
	bh=gGlz7krqbfAh5MEPedsHrl3c32TZ81GRJUq291awbSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZzrsu4UNeiuqbatiVo3iUT6GMQRPVuNPcr9S3M1sqU8ijQvxH/xXjiqaxGJj56JK
	 Yk8FBNj5+7395cVVrT3zqFVBV/ZCKbJlnqOL61KhRu3Kmd1BBWkoD/Yh4tOY6+59O3
	 Eaay/FbgF54UUmGzVZQxVaJh0QqR0hkTc6ayA2qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Werner <andre.werner@systec-electronic.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 007/143] net: phy: phy_device: Prevent nullptr exceptions on ISR
Date: Thu, 11 Apr 2024 11:54:35 +0200
Message-ID: <20240411095421.130770667@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Werner <andre.werner@systec-electronic.com>

[ Upstream commit 61c81872815f46006982bb80460c0c80a949b35b ]

If phydev->irq is set unconditionally, check
for valid interrupt handler or fall back to polling mode to prevent
nullptr exceptions in interrupt service routine.

Signed-off-by: Andre Werner <andre.werner@systec-electronic.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240129135734.18975-2-andre.werner@systec-electronic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6125418ca93f3..8efa2a136faa9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1413,6 +1413,11 @@ int phy_sfp_probe(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_sfp_probe);
 
+static bool phy_drv_supports_irq(struct phy_driver *phydrv)
+{
+	return phydrv->config_intr && phydrv->handle_interrupt;
+}
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1527,6 +1532,9 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	if (phydev->dev_flags & PHY_F_NO_IRQ)
 		phydev->irq = PHY_POLL;
 
+	if (!phy_drv_supports_irq(phydev->drv) && phy_interrupt_is_valid(phydev))
+		phydev->irq = PHY_POLL;
+
 	/* Port is set to PORT_TP by default and the actual PHY driver will set
 	 * it to different value depending on the PHY configuration. If we have
 	 * the generic PHY driver we can't figure it out, thus set the old
@@ -2992,11 +3000,6 @@ s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 }
 EXPORT_SYMBOL(phy_get_internal_delay);
 
-static bool phy_drv_supports_irq(struct phy_driver *phydrv)
-{
-	return phydrv->config_intr && phydrv->handle_interrupt;
-}
-
 static int phy_led_set_brightness(struct led_classdev *led_cdev,
 				  enum led_brightness value)
 {
-- 
2.43.0



