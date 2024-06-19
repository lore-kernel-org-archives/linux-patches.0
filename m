Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482DF13D525;
	Wed, 19 Jun 2024 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801960; cv=none; b=aDQHnu8qh8vh5r00vUlU2FdBLiOgwUgf0SOKHJhpZbznPzKM8cJUWiJc9SH6q/HSmrhxldHwYB51UOEjI6yXyRBgd/6Bgx4CVD4U9MTJ3GzKbCP+AgigLrvju2N7Jv8ZDINPdPdyhYkivaFSaCQDvPG+OHnlPutw12U9GAqKkTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801960; c=relaxed/simple;
	bh=m+1Xkca1c0pv4QZOYYQGil3wL6g04NgVVzG1XieBn14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3WdUGzCc9XvQeizANIYwXGj9fHwEZv30/aq+3Hrf1wYjSKLAHX67jsH193JeIo0v/Jbg7CMGmj3Hnp6W6qfwbpngP2vlD/Ou6ZL3CJnn+FCJ1nhi1mz/4ys59FIxkJ76Mo+4rseelvE/Y7NUGYVZUIIQXSv/gpm/D6qeY3clf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ABf5TDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ABf5TDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFCDC2BBFC;
	Wed, 19 Jun 2024 12:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801960;
	bh=m+1Xkca1c0pv4QZOYYQGil3wL6g04NgVVzG1XieBn14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ABf5TDaWk7DfONbPKNUvR0EpVAOS6xNirKN7OmAeUaNKlQN/HQwQj27uVdJMN4ss
	 0MpCg/aYDPRZzFt3LrNsNeJDxCAqBeV0i0fjZKOTEEMRM29qATnRQmFYtvX87D+xP2
	 R4VwZhd7DW2d0Q5bSI+NWzgfoviUGKcAiCWuxLx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/267] net: phy: Micrel KSZ8061: fix errata solution not taking effect problem
Date: Wed, 19 Jun 2024 14:53:05 +0200
Message-ID: <20240619125607.674491704@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit 0a8d3f2e3e8d8aea8af017e14227b91d5989b696 ]

KSZ8061 needs to write to a MMD register at driver initialization to fix
an errata.  This worked in 5.0 kernel but not in newer kernels.  The
issue is the main phylib code no longer resets PHY at the very beginning.
Calling phy resuming code later will reset the chip if it is already
powered down at the beginning.  This wipes out the MMD register write.
Solution is to implement a phy resume function for KSZ8061 to take care
of this problem.

Fixes: 232ba3a51cc2 ("net: phy: Micrel KSZ8061: link failure after cable connect")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 42 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 048704758b150..366ae22534373 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -770,6 +770,17 @@ static int ksz8061_config_init(struct phy_device *phydev)
 {
 	int ret;
 
+	/* Chip can be powered down by the bootstrap code. */
+	ret = phy_read(phydev, MII_BMCR);
+	if (ret < 0)
+		return ret;
+	if (ret & BMCR_PDOWN) {
+		ret = phy_write(phydev, MII_BMCR, ret & ~BMCR_PDOWN);
+		if (ret < 0)
+			return ret;
+		usleep_range(1000, 2000);
+	}
+
 	ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_DEVID1, 0xB61A);
 	if (ret)
 		return ret;
@@ -2017,6 +2028,35 @@ static int ksz9477_resume(struct phy_device *phydev)
 	return 0;
 }
 
+static int ksz8061_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	/* This function can be called twice when the Ethernet device is on. */
+	ret = phy_read(phydev, MII_BMCR);
+	if (ret < 0)
+		return ret;
+	if (!(ret & BMCR_PDOWN))
+		return 0;
+
+	genphy_resume(phydev);
+	usleep_range(1000, 2000);
+
+	/* Re-program the value after chip is reset. */
+	ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_DEVID1, 0xB61A);
+	if (ret)
+		return ret;
+
+	/* Enable PHY Interrupts */
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->interrupts = PHY_INTERRUPT_ENABLED;
+		if (phydev->drv->config_intr)
+			phydev->drv->config_intr(phydev);
+	}
+
+	return 0;
+}
+
 static int kszphy_probe(struct phy_device *phydev)
 {
 	const struct kszphy_type *type = phydev->drv->driver_data;
@@ -4812,7 +4852,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= kszphy_suspend,
-	.resume		= kszphy_resume,
+	.resume		= ksz8061_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
 	.phy_id_mask	= 0x000ffffe,
-- 
2.43.0



