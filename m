Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B6622A1E6;
	Mon,  2 Jun 2025 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875206; cv=none; b=E+8R3bkdxFy/GHuzeDGiYPWADy5g9q5Vi/1YF/INejqrMpoBE5jMLUIB1LBowK5xvwefN0zxFlwUE60SIkFE+GY2oJtCkLSxbT19tnMki/xREm1EbTwyLPKRFz9q73WY8q/N2Z/J+IvsOz+xAfx+sUP3BuIuBnvwy13Cs4pcNxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875206; c=relaxed/simple;
	bh=Afiko+hniFQoNWIUpoSUQcewR+ezzZYQsY9jXmFV0kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNjW8zA+NwZlBjWtBkHUirdkpDguMjGDQqyZKMrjTZVR1HbSerUz8SZ6CFf38kbbHbwGEGbB7NfB1ESVizcepyKH3lX8HO09Me3mwWYFIzTcyl6Atya2etE5yYJP7ziEU+tRzWHlnepFEMvxt2N9tCc3VWJH+fCrur14nyc7nx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYhi7ili; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYhi7ili"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4E2C4CEEB;
	Mon,  2 Jun 2025 14:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875205;
	bh=Afiko+hniFQoNWIUpoSUQcewR+ezzZYQsY9jXmFV0kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYhi7iliFEOdt4vRagE9SxPFusR7J/Ra1jefajJYCtavvw9WZFyu8jRfQdtjx/AUf
	 NGjRzjbqxwjXs5xHWEVLWuR0h3ksc5kDPvfg+MO1uMLFnZmFn80JTnQNZiMwhgRD/U
	 7gtoi3XFdLF9lnJEpfGKkRd+RdyOtlNUqQZD9H4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nisar Sayed <Nisar.Sayed@microchip.com>,
	Yuiko Oshino <yuiko.oshino@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/270] net: phy: microchip: implement generic .handle_interrupt() callback
Date: Mon,  2 Jun 2025 15:45:16 +0200
Message-ID: <20250602134308.472104908@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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
---
 drivers/net/phy/microchip.c    | 19 +++++++++++++++++++
 drivers/net/phy/microchip_t1.c | 19 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index 375bbd60b38af..a149d0ae58b02 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -56,6 +56,24 @@ static int lan88xx_phy_ack_interrupt(struct phy_device *phydev)
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
@@ -374,6 +392,7 @@ static struct phy_driver microchip_phy_driver[] = {
 
 	.ack_interrupt	= lan88xx_phy_ack_interrupt,
 	.config_intr	= lan88xx_phy_config_intr,
+	.handle_interrupt = lan88xx_handle_interrupt,
 
 	.suspend	= lan88xx_suspend,
 	.resume		= genphy_resume,
diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index fed3e395f18e1..553b391d1747a 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -203,6 +203,24 @@ static int lan87xx_phy_ack_interrupt(struct phy_device *phydev)
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
@@ -223,6 +241,7 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 
 		.ack_interrupt  = lan87xx_phy_ack_interrupt,
 		.config_intr    = lan87xx_phy_config_intr,
+		.handle_interrupt = lan87xx_handle_interrupt,
 
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
-- 
2.39.5



