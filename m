Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113C52836A0;
	Sun,  7 Sep 2025 20:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275758; cv=none; b=S/rsB/waP/aYMvWcYpusTq/jEz8ICGydps1XwRsnfTbLQ/Z6kc4GsOgt2T3P8KErSgjtUFIhWfpuQ4fR2K1xmhUx1u0DgyeYqsH2masK8pYF64ODS8XSNbzmBg+nE8VJBHkKQx3WiYg9CW5zW1QeppTzCcxDepSskBlWOPAyF0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275758; c=relaxed/simple;
	bh=zhkXpSbj09LHgwDcxHqnu/U4k+naMzHJ5ZfnPq2LGbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEuPmcLfshZ/cgxI/BL2Z+cO6EZ7a4KwRfUipAcwAUhSFu+SlPiSeFi4gNK7JxMmVFDLshPV0uvfbV4v3Egru92ch6sLXC4ZkVvX2Y72J/mAllnNxeQzRP2s+ReLSeQMRs8euPgjFOfWNFKr3DXxnKPW57/o0b1xy/vjvIWCfhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZesomPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZesomPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9973C4CEF0;
	Sun,  7 Sep 2025 20:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275757;
	bh=zhkXpSbj09LHgwDcxHqnu/U4k+naMzHJ5ZfnPq2LGbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZesomPHdYrhjmvqA0gVhODaxaQpmhPjqpr3yodO4TLWrgmfzTv5apb9QbwgszOhe
	 HhcjiBtp9iaMgNqV0/yR6gXfQWM41dvLGUpc3E0Ccmb2Y+GZg297duJxRjxuXfkT8k
	 EOqogIabzNGxDEG5quUgh2mHf8ZE24WR08hFvNxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nisar Sayed <Nisar.Sayed@microchip.com>,
	Yuiko Oshino <yuiko.oshino@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/52] net: phy: microchip: remove the use of .ack_interrupt()
Date: Sun,  7 Sep 2025 21:58:03 +0200
Message-ID: <20250907195603.217225445@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit cf499391982d877e9313d2adeedcf5f1ffe05d6e ]

In preparation of removing the .ack_interrupt() callback, we must replace
its occurrences (aka phy_clear_interrupt), from the 2 places where it is
called from (phy_enable_interrupts and phy_disable_interrupts), with
equivalent functionality.

This means that clearing interrupts now becomes something that the PHY
driver is responsible of doing, before enabling interrupts and after
clearing them. Make this driver follow the new contract.

Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 30a41ed32d30 ("net: phy: microchip: force IRQ polling mode for lan88xx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/microchip.c    |   13 +++++--------
 drivers/net/phy/microchip_t1.c |   17 +++++++----------
 2 files changed, 12 insertions(+), 18 deletions(-)

--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -44,14 +44,12 @@ static int lan88xx_phy_config_intr(struc
 			       LAN88XX_INT_MASK_LINK_CHANGE_);
 	} else {
 		rc = phy_write(phydev, LAN88XX_INT_MASK, 0);
-	}
-
-	return rc < 0 ? rc : 0;
-}
+		if (rc)
+			return rc;
 
-static int lan88xx_phy_ack_interrupt(struct phy_device *phydev)
-{
-	int rc = phy_read(phydev, LAN88XX_INT_STS);
+		/* Ack interrupts after they have been disabled */
+		rc = phy_read(phydev, LAN88XX_INT_STS);
+	}
 
 	return rc < 0 ? rc : 0;
 }
@@ -390,7 +388,6 @@ static struct phy_driver microchip_phy_d
 	.config_aneg	= lan88xx_config_aneg,
 	.link_change_notify = lan88xx_link_change_notify,
 
-	.ack_interrupt	= lan88xx_phy_ack_interrupt,
 	.config_intr	= lan88xx_phy_config_intr,
 	.handle_interrupt = lan88xx_handle_interrupt,
 
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -189,16 +189,14 @@ static int lan87xx_phy_config_intr(struc
 		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, 0x7FFF);
 		rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
 		val = LAN87XX_MASK_LINK_UP | LAN87XX_MASK_LINK_DOWN;
-	}
-
-	rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
-
-	return rc < 0 ? rc : 0;
-}
+		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
+	} else {
+		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
+		if (rc)
+			return rc;
 
-static int lan87xx_phy_ack_interrupt(struct phy_device *phydev)
-{
-	int rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
+		rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
+	}
 
 	return rc < 0 ? rc : 0;
 }
@@ -239,7 +237,6 @@ static struct phy_driver microchip_t1_ph
 		.config_init	= lan87xx_config_init,
 		.config_aneg    = genphy_config_aneg,
 
-		.ack_interrupt  = lan87xx_phy_ack_interrupt,
 		.config_intr    = lan87xx_phy_config_intr,
 		.handle_interrupt = lan87xx_handle_interrupt,
 


