Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DAF1DC1A7;
	Mon, 12 May 2025 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071133; cv=none; b=I37QvC/DPz5gRvP5yyXu1lbk4ZvfuXedGnHWzid2rOTU2LUpZTR1fMgU23B8K5Lo6L/3S61zOlBL9aILwVA67J0pj+scOu3a3lxLrXfFz4q9mr+QH9CQLs86HLbID5xoH6Nj3EzLK8M8xVtbqGMLByte/1QgVy23SkjmHCsj4dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071133; c=relaxed/simple;
	bh=1HExZfiJ53Vv5AwbOfioAMHr7hUtOP6Mr66dsHEltbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q843r4LyvcsPvEscmsLqJVHV05ncTECvBrZqjULZjre3KwS3PgljUS+IaThpDQ6fVLyefysVDLFwcmkO5GyEfZSaZXJSEGSyJJHDbEmskiMmFAsR9euIFRb5vpCvKNZuCgUYeLAm2cYGYDX3qJZrZbtE9JesmeSZTIbUACEQfRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mykR8MqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mykR8MqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C1CC4CEE7;
	Mon, 12 May 2025 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071133;
	bh=1HExZfiJ53Vv5AwbOfioAMHr7hUtOP6Mr66dsHEltbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mykR8MqV2vEnFv/5WvpmF935QNq0ZrGIsSgTnG/iK1LQOzPVBC+yZm50NSavzuvQ5
	 rA9aimRYxQCK0NIFyKVSEzUxR4eF3lU3birL3FWPNTPVsUzRxo5GE487gXUDVUQ8zf
	 Y/Z3F90V0mGUbdoxFPlfGh39+VbRCgMCG3TOD98Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Klute <fiona.klute@gmx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 51/54] Revert "net: phy: microchip: force IRQ polling mode for lan88xx"
Date: Mon, 12 May 2025 19:30:03 +0200
Message-ID: <20250512172017.696144288@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 853e14cf36f6b16a372444a1eff54a3d7c6c1268 which is
commit 30a41ed32d3088cd0d682a13d7f30b23baed7e93 upstream.

It is reported to cause NFS boot problems on a Raspberry Pi 3b so revert
it from this branch for now.

Cc: Fiona Klute <fiona.klute@gmx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/aB6uurX99AZWM9I1@finisterre.sirena.org.uk
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/microchip.c |   46 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -31,6 +31,47 @@ static int lan88xx_write_page(struct phy
 	return __phy_write(phydev, LAN88XX_EXT_PAGE_ACCESS, page);
 }
 
+static int lan88xx_phy_config_intr(struct phy_device *phydev)
+{
+	int rc;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		/* unmask all source and clear them before enable */
+		rc = phy_write(phydev, LAN88XX_INT_MASK, 0x7FFF);
+		rc = phy_read(phydev, LAN88XX_INT_STS);
+		rc = phy_write(phydev, LAN88XX_INT_MASK,
+			       LAN88XX_INT_MASK_MDINTPIN_EN_ |
+			       LAN88XX_INT_MASK_LINK_CHANGE_);
+	} else {
+		rc = phy_write(phydev, LAN88XX_INT_MASK, 0);
+		if (rc)
+			return rc;
+
+		/* Ack interrupts after they have been disabled */
+		rc = phy_read(phydev, LAN88XX_INT_STS);
+	}
+
+	return rc < 0 ? rc : 0;
+}
+
+static irqreturn_t lan88xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, LAN88XX_INT_STS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & LAN88XX_INT_STS_LINK_CHANGE_))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int lan88xx_suspend(struct phy_device *phydev)
 {
 	struct lan88xx_priv *priv = phydev->priv;
@@ -347,9 +388,8 @@ static struct phy_driver microchip_phy_d
 	.config_aneg	= lan88xx_config_aneg,
 	.link_change_notify = lan88xx_link_change_notify,
 
-	/* Interrupt handling is broken, do not define related
-	 * functions to force polling.
-	 */
+	.config_intr	= lan88xx_phy_config_intr,
+	.handle_interrupt = lan88xx_handle_interrupt,
 
 	.suspend	= lan88xx_suspend,
 	.resume		= genphy_resume,


