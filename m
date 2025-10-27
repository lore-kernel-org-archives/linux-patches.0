Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791EC3328F8;
	Mon, 27 Oct 2025 18:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591577; cv=none; b=sWxDh1XAFFYccAEI3Tm5qRfyHQ0wN/h4nuGjp3xrfbKrDfYcBvyL5eO58fiseFSb7C4kntFWjVM7jxDDWR6ofgLM9FgeAd1imtQEnpMV1UHeoMDbQojtdeyMMZp+H1FTzk+iupOIxh9zDW1cJwhoD/zTSJonr4MkyMheAJxYvyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591577; c=relaxed/simple;
	bh=vSnoN2n2WriuWnV9opvM64+9cNH3KXP5SIwfuMOkc2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p30asesCE1qo4jqUf/BzwHw2kEwJmZ+ekqUHTj7St09Auylz3G0BbBmqWxB41dJq7gUmInp2uZvYH+odGDtYJnFJtYu9lXg4HoW12WyVIy77YXCo1ls+4TkACkumX3XSDWQ7/CSnJ0iuEVB3Ivoq1t9nIgjRCogVUdG+4sorjak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swRxJczA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swRxJczA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB90C4CEFD;
	Mon, 27 Oct 2025 18:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591577;
	bh=vSnoN2n2WriuWnV9opvM64+9cNH3KXP5SIwfuMOkc2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swRxJczAZ5PW1lMHK3B0nMZgwmemmj1IPNgRf3RG1F/bzWPH9p0VGgUMdZFyYmyag
	 FUC+17VUomqTVK7cpfGf/gk1rB9cCX27nVd8T5nKR5cLxxwn1WAKY62sLE9U4i6PPg
	 EvUWJ+ViTa2HNZAdJFXBViO0hb/cUZU20Cne+KiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/332] net: usb: lan78xx: Add error handling to lan78xx_init_mac_address
Date: Mon, 27 Oct 2025 19:35:03 +0100
Message-ID: <20251027183531.440273948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 6f31135894ec96481e2bda93a1da70712f5e57c1 ]

Convert `lan78xx_init_mac_address` to return error codes and handle
failures in register read and write operations. Update `lan78xx_reset`
to check for errors during MAC address initialization and propagate them
appropriately.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241209130751.703182-3-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8d93ff40d49d ("net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3e3c67dc6bf74..c3aa3f75ab914 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1710,13 +1710,19 @@ static const struct ethtool_ops lan78xx_ethtool_ops = {
 	.get_regs	= lan78xx_get_regs,
 };
 
-static void lan78xx_init_mac_address(struct lan78xx_net *dev)
+static int lan78xx_init_mac_address(struct lan78xx_net *dev)
 {
 	u32 addr_lo, addr_hi;
 	u8 addr[6];
+	int ret;
+
+	ret = lan78xx_read_reg(dev, RX_ADDRL, &addr_lo);
+	if (ret < 0)
+		return ret;
 
-	lan78xx_read_reg(dev, RX_ADDRL, &addr_lo);
-	lan78xx_read_reg(dev, RX_ADDRH, &addr_hi);
+	ret = lan78xx_read_reg(dev, RX_ADDRH, &addr_hi);
+	if (ret < 0)
+		return ret;
 
 	addr[0] = addr_lo & 0xFF;
 	addr[1] = (addr_lo >> 8) & 0xFF;
@@ -1749,14 +1755,26 @@ static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 			  (addr[2] << 16) | (addr[3] << 24);
 		addr_hi = addr[4] | (addr[5] << 8);
 
-		lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
-		lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
+		ret = lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
+		if (ret < 0)
+			return ret;
+
+		ret = lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
+		if (ret < 0)
+			return ret;
 	}
 
-	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
-	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
+	ret = lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
+	if (ret < 0)
+		return ret;
+
+	ret = lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
+	if (ret < 0)
+		return ret;
 
 	eth_hw_addr_set(dev->net, addr);
+
+	return 0;
 }
 
 /* MDIO read and write wrappers for phylib */
@@ -2655,7 +2673,9 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 		}
 	} while (buf & HW_CFG_LRST_);
 
-	lan78xx_init_mac_address(dev);
+	ret = lan78xx_init_mac_address(dev);
+	if (ret < 0)
+		return ret;
 
 	/* save DEVID for later usage */
 	ret = lan78xx_read_reg(dev, ID_REV, &buf);
-- 
2.51.0



