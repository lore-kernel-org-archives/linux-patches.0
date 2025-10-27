Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680CC3081B0;
	Mon, 27 Oct 2025 19:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591966; cv=none; b=RoDoWdv5uyFnycTkYaSzb8GaLhZDtVrK9qrkEmwSCBL0VfKBWfZP821hp7D9MhywxNrdeJia2c/VrYxw8LLAl3+3XQPKt/L1IAejaaS7uee6T9h1wTfQB6FRziZFoyIrvQtEqRy73JFfdlF2tBM/U/7Hu3qat23KeFrX6aQrpXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591966; c=relaxed/simple;
	bh=ZC0vlYXxlxgicVipLALJFzA/GFFDqDj9C+n6fXiccrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrlwwYM5HYBm4AdZk7yQzV36/KbddKxgfNB6LnUV9wrs7oP3TXhcX98yaWhGH8YUUK5mRJXQ0LL6t+JLUmVj2hNhJcoxqk7bFyRVT0OlVRoG2alpMr0Z8Rv9mMoYx9selRe60tQrdTrojgdEn27f+Z2OH/enp3N87m6yAC1Z68c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9RSaj+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9RSaj+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED53DC4CEF1;
	Mon, 27 Oct 2025 19:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591966;
	bh=ZC0vlYXxlxgicVipLALJFzA/GFFDqDj9C+n6fXiccrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9RSaj+vJ8Mh3wnoeKVjKUhlsy3dq3lPPgPXRPOG23DB3SgOUPbFeEWgoR/4FmfWj
	 GkPGX1nMOqSh01SAsiuHMRPLqSLPmM7xH7004zy6zj1K+BCCl1N1tMtulXwZVsPcjn
	 gU7NqxQwHpFZiE5zg1cBlD5+g6HEdUuEWIo51JNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/123] net: usb: lan78xx: Add error handling to lan78xx_init_mac_address
Date: Mon, 27 Oct 2025 19:35:10 +0100
Message-ID: <20251027183447.204436405@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4be15489a2c2a..182a4dbd8cf26 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1773,13 +1773,19 @@ static const struct ethtool_ops lan78xx_ethtool_ops = {
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
@@ -1812,14 +1818,26 @@ static void lan78xx_init_mac_address(struct lan78xx_net *dev)
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
@@ -2718,7 +2736,9 @@ static int lan78xx_reset(struct lan78xx_net *dev)
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



