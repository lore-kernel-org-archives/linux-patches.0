Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242ED14389C;
	Wed, 19 Jun 2024 13:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802730; cv=none; b=KD5EwPvjQ6iOZRNNaloF27IJuLUaitMuMmD58/lGmzACKI+58pPwb2exwRx761knDq/5xu8Ivif2I2GN3Oil3uA1zs1XBMz2W5CDIWzhvnTmSJwe1rsp4SGo7HEUEyG4Xwkm+2LjE3cxMinryV9C2H5CZR37vRLYpZPHdgYakow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802730; c=relaxed/simple;
	bh=TAZrouNyg7nlwLXd9SQvni8eJZhULbaXQNtODB6S4Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+ovEmXFvnt756mNAqfA+YCcPzUucpXFnMWfMqL3B/GKdDMPKdroqECNTgNXcsbtJ5RKmveMXs75Ap9UfLj6GfSlKWdH4SXF0uqJc0+RxXW4u1AhWSBAT/1d3BgUKwVCtr/kjRKofTnSIM2oGyzlTKvsyPZoV6lOX5cH1j5lc9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9Nyxy3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9Nyxy3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0583C2BBFC;
	Wed, 19 Jun 2024 13:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802730;
	bh=TAZrouNyg7nlwLXd9SQvni8eJZhULbaXQNtODB6S4Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9Nyxy3Ebp1seGnmmM244FCTdEtgec+BafkjJICrBJZmxqj8eZgfgXZFEapfxHlmh
	 U6ZR0FQKApzfkF79/PRqtNvKK0yhx96p+8OVCBpehM6KfhTpSEVnmcXBXyN6SZ9mpa
	 Wyz+amMvNv2gH40CV4GW9AYy3BeK8uygoHW35zzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 027/281] net: phy: micrel: fix KSZ9477 PHY issues after suspend/resume
Date: Wed, 19 Jun 2024 14:53:06 +0200
Message-ID: <20240619125610.890656649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit 6149db4997f582e958da675092f21c666e3b67b7 ]

When the PHY is powered up after powered down most of the registers are
reset, so the PHY setup code needs to be done again.  In addition the
interrupt register will need to be setup again so that link status
indication works again.

Fixes: 26dd2974c5b5 ("net: phy: micrel: Move KSZ9477 errata fixes to PHY driver")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 62 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 13370439a7cae..c2d99344ade41 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1858,7 +1858,7 @@ static const struct ksz9477_errata_write ksz9477_errata_writes[] = {
 	{0x1c, 0x20, 0xeeee},
 };
 
-static int ksz9477_config_init(struct phy_device *phydev)
+static int ksz9477_phy_errata(struct phy_device *phydev)
 {
 	int err;
 	int i;
@@ -1886,16 +1886,30 @@ static int ksz9477_config_init(struct phy_device *phydev)
 			return err;
 	}
 
+	err = genphy_restart_aneg(phydev);
+	if (err)
+		return err;
+
+	return err;
+}
+
+static int ksz9477_config_init(struct phy_device *phydev)
+{
+	int err;
+
+	/* Only KSZ9897 family of switches needs this fix. */
+	if ((phydev->phy_id & 0xf) == 1) {
+		err = ksz9477_phy_errata(phydev);
+		if (err)
+			return err;
+	}
+
 	/* According to KSZ9477 Errata DS80000754C (Module 4) all EEE modes
 	 * in this switch shall be regarded as broken.
 	 */
 	if (phydev->dev_flags & MICREL_NO_EEE)
 		phydev->eee_broken_modes = -1;
 
-	err = genphy_restart_aneg(phydev);
-	if (err)
-		return err;
-
 	return kszphy_config_init(phydev);
 }
 
@@ -2004,6 +2018,42 @@ static int kszphy_resume(struct phy_device *phydev)
 	return 0;
 }
 
+static int ksz9477_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	/* No need to initialize registers if not powered down. */
+	ret = phy_read(phydev, MII_BMCR);
+	if (ret < 0)
+		return ret;
+	if (!(ret & BMCR_PDOWN))
+		return 0;
+
+	genphy_resume(phydev);
+
+	/* After switching from power-down to normal mode, an internal global
+	 * reset is automatically generated. Wait a minimum of 1 ms before
+	 * read/write access to the PHY registers.
+	 */
+	usleep_range(1000, 2000);
+
+	/* Only KSZ9897 family of switches needs this fix. */
+	if ((phydev->phy_id & 0xf) == 1) {
+		ret = ksz9477_phy_errata(phydev);
+		if (ret)
+			return ret;
+	}
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
@@ -4980,7 +5030,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.resume		= ksz9477_resume,
 	.get_features	= ksz9477_get_features,
 } };
 
-- 
2.43.0



