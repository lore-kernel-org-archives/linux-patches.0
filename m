Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75842274B35;
	Tue, 21 Oct 2025 20:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077332; cv=none; b=HL/j8mPKTmYXfL7W1TdHF45MzUC6vEojX9QHkxxvUb4F/NCtgfMEFYXHhfMH4m0acdkVK+ryBib9iiGTXstNW1KmcyE6TxlAT3DfUtp+SVDOdK8gwSxEoveby79wedkfCfHfdL5dYhEyT2h71yQyLzrvr17i3nrif5qs90cT+UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077332; c=relaxed/simple;
	bh=O8SifLQzVVWR7AAyoG3exJC4322XAD3bAoATqXEYd9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ghRRsUla7v2t/I4QIuTXK+tBy/9WiKf9zVbYlEiA27ZyT2zTXd6a4XJqhtJf1zSAWorVQZLkZXxceLpsNxdzxP5Ajizh5f6Bz6lEUvdXv9ekNypbxTBB/5Ny/aIslVWfTnqb35TL30Vt22IAVoYXlEVIQiCQePDd/1HxJ6CttYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmsvrtbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmsvrtbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2664C4CEF1;
	Tue, 21 Oct 2025 20:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077332;
	bh=O8SifLQzVVWR7AAyoG3exJC4322XAD3bAoATqXEYd9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmsvrtbQcFJxpa1cwIJgXyKjYhowBVK3qxTLuKTblGfgl7smq2kVPveL/YnGC72Qo
	 b/+I0TelS/+T8DMRMGT5CSNBaewPgYm3nq3hvKrAuZSc7gdnYapW/AU06nTP8F/WF7
	 NNr9+6LfdhvzcYbxy7Jt/SR3A2O5KWktbWiFazAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kamil=20Hor=C3=A1k=20-=202N?= <kamilh@axis.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 071/159] net: phy: bcm54811: Fix GMII/MII/MII-Lite selection
Date: Tue, 21 Oct 2025 21:50:48 +0200
Message-ID: <20251021195044.913196620@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamil Horák - 2N <kamilh@axis.com>

[ Upstream commit e4d0c909bf8328d986bf3aadba0c33a72b5ae30d ]

The Broadcom bcm54811 is hardware-strapped to select among RGMII and
GMII/MII/MII-Lite modes. However, the corresponding bit, RGMII Enable
in Miscellaneous Control Register must be also set to select desired
RGMII or MII(-lite)/GMII mode.

Fixes: 3117a11fff5af9e7 ("net: phy: bcm54811: PHY initialization")
Signed-off-by: Kamil Horák - 2N <kamilh@axis.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251009130656.1308237-2-kamilh@axis.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 20 +++++++++++++++++++-
 include/linux/brcmphy.h    |  1 +
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index a60e58ef90c4e..6884eaccc3e1d 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -407,7 +407,7 @@ static int bcm5481x_set_brrmode(struct phy_device *phydev, bool on)
 static int bcm54811_config_init(struct phy_device *phydev)
 {
 	struct bcm54xx_phy_priv *priv = phydev->priv;
-	int err, reg, exp_sync_ethernet;
+	int err, reg, exp_sync_ethernet, aux_rgmii_en;
 
 	/* Enable CLK125 MUX on LED4 if ref clock is enabled. */
 	if (!(phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED)) {
@@ -436,6 +436,24 @@ static int bcm54811_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	/* Enable RGMII if configured */
+	if (phy_interface_is_rgmii(phydev))
+		aux_rgmii_en = MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN |
+			       MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_SKEW_EN;
+	else
+		aux_rgmii_en = 0;
+
+	/* Also writing Reserved bits 6:5 because the documentation requires
+	 * them to be written to 0b11
+	 */
+	err = bcm54xx_auxctl_write(phydev,
+				   MII_BCM54XX_AUXCTL_SHDWSEL_MISC,
+				   MII_BCM54XX_AUXCTL_MISC_WREN |
+				   aux_rgmii_en |
+				   MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RSVD);
+	if (err < 0)
+		return err;
+
 	return bcm5481x_set_brrmode(phydev, priv->brr_mode);
 }
 
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 15c35655f4826..115a964f30069 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -137,6 +137,7 @@
 
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC			0x07
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN	0x0010
+#define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RSVD		0x0060
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN	0x0080
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_SKEW_EN	0x0100
 #define MII_BCM54XX_AUXCTL_MISC_FORCE_AMDIX		0x0200
-- 
2.51.0



