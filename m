Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F552528E6;
	Mon, 12 May 2025 17:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072534; cv=none; b=r/fvgmFg6dMuUtwT6F+uKEL5/E/uFm9RTr8Y150LVliHGsvlMcGmRUs+HausS4kpl0UjoL9t/lxDiiiYMPSgKNoT2YC9xj5scAnAgSHBrKRw9NRNxf3TPU/PItuwkkcIzGq9L0bw1UD+cw0xk21MsPSu4HeUcNgTWAbJFvkFX58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072534; c=relaxed/simple;
	bh=Z0pp1w+oDbm9VTGXmy0J/hiTCKuKZcItt5spF+HK2Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAUBkr4sGBkW6GjmdMe3TG1ygX/PYIsQD/qBbeGuKz1o2vE2WLQPNeKfYrhbpKxyOmkjHw5Z1vQ9X4SQk4GnSN7rycHrofaRQl5bj5oeIy7v/32EGk6hS0mnDfsqHk8ejVa2kpegZQCp77E02vZAi1pEBweO5fEOUL6r+3YwrlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1C+W/WKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1C+W/WKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7342BC4CEE7;
	Mon, 12 May 2025 17:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072534;
	bh=Z0pp1w+oDbm9VTGXmy0J/hiTCKuKZcItt5spF+HK2Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1C+W/WKhFb2fXV7Akp/djDoh0TaqhdeSpRaG+VUg28ZfcqDhEmCCLUBj38LKDU/7T
	 3rpGYw3nC/qk92lklTLJ3aoc00Sp1AWmqfYPYkUmhdxcZDH6+kBD1AAaK8Sgt7+mRN
	 bAahb7PUGcktYcUsfUA+heNk2kVrGK05vRN8vowk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Klute <fiona.klute@gmx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 71/92] Revert "net: phy: microchip: force IRQ polling mode for lan88xx"
Date: Mon, 12 May 2025 19:45:46 +0200
Message-ID: <20250512172026.017190631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 9b89102fbb8fc5393e2a0f981aafdb3cf43591ee which is
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
@@ -351,9 +392,8 @@ static struct phy_driver microchip_phy_d
 	.config_aneg	= lan88xx_config_aneg,
 	.link_change_notify = lan88xx_link_change_notify,
 
-	/* Interrupt handling is broken, do not define related
-	 * functions to force polling.
-	 */
+	.config_intr	= lan88xx_phy_config_intr,
+	.handle_interrupt = lan88xx_handle_interrupt,
 
 	.suspend	= lan88xx_suspend,
 	.resume		= genphy_resume,


