Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CEA2836A0;
	Sun,  7 Sep 2025 20:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275754; cv=none; b=BlTjcACfBEKNjxqkTW+w6wWpzLJiPc2ND7qj0UNGBpf1gmt+dZMHCHmYiF2Bih9lN8zyCrEHpdeXXydSnN7szUHuBriPW8Pvm77gHB/iCPYxJytjxM3ikby7x4YoA7eZJslM6bMbituCAbn2kjDcuuUasz33yK7P/NCXMA7P9Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275754; c=relaxed/simple;
	bh=Z3h3XkNEoSCit2xQpEHJJJiBpzAs96sUlq9dlmXfn5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IShiN7UXyfDFFidDTQ0MvggObcL3zhObkzApMsBQiyNaODxcEOLPlcTOwqaDDlTsmgNmt8J88K3UiwUubOAPbc7MmEElQEEpL6aJEbPkuEi9gvJ4XxsRN0/+oNqK0iAi1ciHyQdvY1GIlr4n1mE8UJJLypo+Oy/OlDwjrwzWY/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tM/tIOXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tM/tIOXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68C7C4CEF0;
	Sun,  7 Sep 2025 20:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275754;
	bh=Z3h3XkNEoSCit2xQpEHJJJiBpzAs96sUlq9dlmXfn5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tM/tIOXh5ZCyZ5pOCvSlbRGoGVYqCc1hWV9/00/STdkuM5bLKZmjtMgPBE2vJTOM5
	 2hluNck2QBFFcgz/fBSFLY4rgOqJnkrwfKVZ8sji3yLv+H9fAJ23YtsIacnTyzWz6U
	 yHZjea3LONitofwC6lL160GoPfRM9S3sCK6bZNJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nisar Sayed <Nisar.Sayed@microchip.com>,
	Yuiko Oshino <yuiko.oshino@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/52] net: phy: microchip: implement generic .handle_interrupt() callback
Date: Sun,  7 Sep 2025 21:58:02 +0200
Message-ID: <20250907195603.189751318@linuxfoundation.org>
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

[ Upstream commit e01a3feb8f69ab620b0016498603cad364f65224 ]

In an attempt to actually support shared IRQs in phylib, we now move the
responsibility of triggering the phylib state machine or just returning
IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
3 different IRQ handling callbacks (.handle_interrupt(),
.did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
driver implement directly an IRQ handler like any other device driver.
Make this driver follow the new convention.

Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 30a41ed32d30 ("net: phy: microchip: force IRQ polling mode for lan88xx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/microchip.c    |   19 +++++++++++++++++++
 drivers/net/phy/microchip_t1.c |   19 +++++++++++++++++++
 2 files changed, 38 insertions(+)

--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -56,6 +56,24 @@ static int lan88xx_phy_ack_interrupt(str
 	return rc < 0 ? rc : 0;
 }
 
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
@@ -374,6 +392,7 @@ static struct phy_driver microchip_phy_d
 
 	.ack_interrupt	= lan88xx_phy_ack_interrupt,
 	.config_intr	= lan88xx_phy_config_intr,
+	.handle_interrupt = lan88xx_handle_interrupt,
 
 	.suspend	= lan88xx_suspend,
 	.resume		= genphy_resume,
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -203,6 +203,24 @@ static int lan87xx_phy_ack_interrupt(str
 	return rc < 0 ? rc : 0;
 }
 
+static irqreturn_t lan87xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (irq_status == 0)
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int lan87xx_config_init(struct phy_device *phydev)
 {
 	int rc = lan87xx_phy_init(phydev);
@@ -223,6 +241,7 @@ static struct phy_driver microchip_t1_ph
 
 		.ack_interrupt  = lan87xx_phy_ack_interrupt,
 		.config_intr    = lan87xx_phy_config_intr,
+		.handle_interrupt = lan87xx_handle_interrupt,
 
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,


