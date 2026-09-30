Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86293C1D66;
	Wed, 30 Sep 2026 19:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796861; cv=none; b=DhXn/kk7oicBLi3J2rlSrPfVHv3KHcMsnMg2EfVrEqHOMmfiDJVYZhSrFp6MlawRCiXHdsszTBVSq/+kFd/hkxlKmEFY1JUrPT/P/mivc6hjb/wZCJBV9QlOrpSWZNqByBgy5/gzcjqwHEpEUaW+ySs+fOweaXoR80AS7UlcQIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796861; c=relaxed/simple;
	bh=87RkjWOdd8hWJOKu+/+ViUZsoq7a0c8jg7Os/ubZt1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grnGvpomlF+IiuGzmVklNx+VfB1WYr2lxTLUNWB5quHrPFrX7K7Bq2ML+Yy7ydJO3oubbNX8ifZGDHxeIrl5yceJEZdXCp3sROtuoZ4jm44Tk/97NQOjf2JiwuypMVF0gVHC2sJMvPaGp3m0U49dofAOYyTo17AkkZt9IsIk9kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFax2e/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFax2e/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B891F000FF;
	Wed, 30 Sep 2026 19:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796859;
	bh=hV+Ms74l7KJcnjCgxkzzaEdiijbWR5dB40NxRiXYauQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFax2e/CKHQFlvw8W7OmPRb6UhOkra6YeHqfLxm3SIqNfBystEBTeHU6cgw5WgkSa
	 dSgn2UF4WaEk/qN6OFWQ3WXwRItMMpR266F39+tOWVjK84bkvTXLYqfKxjxb/1O0iF
	 aUxh3CkvHOsvgAhw6lBOVJSJpe66OT0vbhLvF6m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1063/1193] net: bcmgenet: move bcmgenet_power_up into resume_noirq
Date: Wed, 30 Sep 2026 17:29:07 +0200
Message-ID: <20260930152457.841993472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit ffce2bedd361177718dc0c3787f4adb4785a0151 ]

The bcmgenet_power_up() function is moved from the resume method
to the resume_noirq method for symmetry with the suspend_noirq
method. This allows the wol_active flag to be removed.

The UMAC_IRQ_WAKE_EVENT interrupts that can be unmasked by the
bcmgenet_wol_power_down_cfg() function are now re-masked by the
bcmgenet_wol_power_up_cfg() function at the resume_noirq level
as well.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250306192643.2383632-13-opendmb@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cbbc1aee7776 ("net: bcmgenet: do not skip WoL power up on GENET V1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 24 +++++++++----------
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  1 -
 .../ethernet/broadcom/genet/bcmgenet_wol.c    |  8 +++----
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index c1eb5d99fe875..24689433c8725 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4147,8 +4147,20 @@ static int bcmgenet_resume_noirq(struct device *d)
 		reg = bcmgenet_intrl2_0_readl(priv, INTRL2_CPU_STAT);
 		if (reg & UMAC_IRQ_WAKE_EVENT)
 			pm_wakeup_event(&priv->pdev->dev, 0);
+
+		/* From WOL-enabled suspend, switch to regular clock */
+		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
 	}
 
+	/* If this is an internal GPHY, power it back on now, before UniMAC is
+	 * brought out of reset as absolutely no UniMAC activity is allowed
+	 */
+	if (priv->internal_phy)
+		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
+
+	/* take MAC out of reset */
+	bcmgenet_umac_reset(priv);
+
 	bcmgenet_intrl2_0_writel(priv, UMAC_IRQ_WAKE_EVENT, INTRL2_CPU_CLEAR);
 
 	return 0;
@@ -4165,18 +4177,6 @@ static int bcmgenet_resume(struct device *d)
 	if (!netif_running(dev))
 		return 0;
 
-	/* From WOL-enabled suspend, switch to regular clock */
-	if (device_may_wakeup(d) && priv->wolopts)
-		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
-
-	/* If this is an internal GPHY, power it back on now, before UniMAC is
-	 * brought out of reset as absolutely no UniMAC activity is allowed
-	 */
-	if (priv->internal_phy)
-		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
-
-	bcmgenet_umac_reset(priv);
-
 	init_umac(priv);
 
 	phy_init_hw(dev->phydev);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 94957dfa55b6f..bbbb4f317f9e0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -658,7 +658,6 @@ struct bcmgenet_priv {
 	struct clk *clk_wol;
 	u32 wolopts;
 	u8 sopass[SOPASS_MAX];
-	bool wol_active;
 
 	struct bcmgenet_mib_counters mib;
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 98358b71cef5c..d67f1cb14a800 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -199,7 +199,6 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 		  retries);
 
 	clk_prepare_enable(priv->clk_wol);
-	priv->wol_active = 1;
 
 	if (hfb_enable) {
 		bcmgenet_hfb_reg_writel(priv, hfb_enable,
@@ -238,13 +237,12 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 		return;
 	}
 
-	if (!priv->wol_active)
-		return;	/* failed to suspend so skip the rest */
-
-	priv->wol_active = 0;
 	clk_disable_unprepare(priv->clk_wol);
 	priv->crc_fwd_en = 0;
 
+	bcmgenet_intrl2_0_writel(priv, UMAC_IRQ_WAKE_EVENT,
+				 INTRL2_CPU_MASK_SET);
+
 	/* Disable Magic Packet Detection */
 	if (priv->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE)) {
 		reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
-- 
2.53.0



