Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD622321425;
	Mon, 18 Aug 2025 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525510; cv=none; b=l72kSoNBfZapqTsjdKdrfDMhGkAussjol/qGPjSuQFM7VevxrQWLt/y/SNMCL42F+MeIqtnAxoHLAAHhDXSqnnxay6/7a84AIDaF3CVqq14T9v78og0pOX04CWuXkpAOJKxE6bunaU9zLxRG6SJKOoJHo3Y9x4sD193gRx8Ar9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525510; c=relaxed/simple;
	bh=UkSa3f+1yAacqqO5cAC15H0goDhXmK9ZaPWatKiUMK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeSyZflOARnTlbSI9Cwu5G4lG1IX2sA1SSLJ2X9ve8UK3w4ibLqtB5EAAohZdTYTSggdkNDjtNnr2G2CJsikZ2zlSZbKb6wuYajj+X62dPM3twxKtZTcBP8uxJYwiWXspLAaT8HUX5OkZYBM7GAkJUoE7AAaku+T2ghM0hVYNpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yVjOhdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yVjOhdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426C6C4CEEB;
	Mon, 18 Aug 2025 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525510;
	bh=UkSa3f+1yAacqqO5cAC15H0goDhXmK9ZaPWatKiUMK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yVjOhdQKIjaaBFOZxjYJDV6DsL6j++DH0ei2AkjAPA1VdpRsZYSf4FX52Vyve+nM
	 Gibn6eNAd8Hp1DoilfdoTyOzPJ5i7WuY6hBskdEZ8ttUN/6+dqQs1g1oxLxpigC6iO
	 WU6z6qpFvntmmttc2BKcJxRwrsdxzca7+MuK+QlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lucien.Jheng" <lucienzx159@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 285/570] net: phy: air_en8811h: Introduce resume/suspend and clk_restore_context to ensure correct CKO settings after network interface reinitialization.
Date: Mon, 18 Aug 2025 14:44:32 +0200
Message-ID: <20250818124516.823231262@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucien.Jheng <lucienzx159@gmail.com>

[ Upstream commit 6b9c9def95cb402374730d51a1f44927f467b774 ]

If the user reinitializes the network interface, the PHY will reinitialize,
and the CKO settings will revert to their initial configuration(be enabled).
To prevent CKO from being re-enabled,
en8811h_clk_restore_context and en8811h_resume were added
to ensure the CKO settings remain correct.

Signed-off-by: Lucien.Jheng <lucienzx159@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250630154147.80388-1-lucienzx159@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/air_en8811h.c | 45 +++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/air_en8811h.c b/drivers/net/phy/air_en8811h.c
index 57fbd8df9438..badd65f0ccee 100644
--- a/drivers/net/phy/air_en8811h.c
+++ b/drivers/net/phy/air_en8811h.c
@@ -11,6 +11,7 @@
  * Copyright (C) 2023 Airoha Technology Corp.
  */
 
+#include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/phy.h>
 #include <linux/firmware.h>
@@ -157,6 +158,7 @@ struct en8811h_priv {
 	struct led		led[EN8811H_LED_COUNT];
 	struct clk_hw		hw;
 	struct phy_device	*phydev;
+	unsigned int		cko_is_enabled;
 };
 
 enum {
@@ -865,11 +867,30 @@ static int en8811h_clk_is_enabled(struct clk_hw *hw)
 	return (pbus_value & EN8811H_CLK_CGM_CKO);
 }
 
+static int en8811h_clk_save_context(struct clk_hw *hw)
+{
+	struct en8811h_priv *priv = clk_hw_to_en8811h_priv(hw);
+
+	priv->cko_is_enabled = en8811h_clk_is_enabled(hw);
+
+	return 0;
+}
+
+static void en8811h_clk_restore_context(struct clk_hw *hw)
+{
+	struct en8811h_priv *priv = clk_hw_to_en8811h_priv(hw);
+
+	if (!priv->cko_is_enabled)
+		en8811h_clk_disable(hw);
+}
+
 static const struct clk_ops en8811h_clk_ops = {
-	.recalc_rate	= en8811h_clk_recalc_rate,
-	.enable		= en8811h_clk_enable,
-	.disable	= en8811h_clk_disable,
-	.is_enabled	= en8811h_clk_is_enabled,
+	.recalc_rate		= en8811h_clk_recalc_rate,
+	.enable			= en8811h_clk_enable,
+	.disable		= en8811h_clk_disable,
+	.is_enabled		= en8811h_clk_is_enabled,
+	.save_context		= en8811h_clk_save_context,
+	.restore_context	= en8811h_clk_restore_context,
 };
 
 static int en8811h_clk_provider_setup(struct device *dev, struct clk_hw *hw)
@@ -1149,6 +1170,20 @@ static irqreturn_t en8811h_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static int en8811h_resume(struct phy_device *phydev)
+{
+	clk_restore_context();
+
+	return genphy_resume(phydev);
+}
+
+static int en8811h_suspend(struct phy_device *phydev)
+{
+	clk_save_context();
+
+	return genphy_suspend(phydev);
+}
+
 static struct phy_driver en8811h_driver[] = {
 {
 	PHY_ID_MATCH_MODEL(EN8811H_PHY_ID),
@@ -1159,6 +1194,8 @@ static struct phy_driver en8811h_driver[] = {
 	.get_rate_matching	= en8811h_get_rate_matching,
 	.config_aneg		= en8811h_config_aneg,
 	.read_status		= en8811h_read_status,
+	.resume			= en8811h_resume,
+	.suspend		= en8811h_suspend,
 	.config_intr		= en8811h_clear_intr,
 	.handle_interrupt	= en8811h_handle_interrupt,
 	.led_hw_is_supported	= en8811h_led_hw_is_supported,
-- 
2.39.5



