Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2651F3925D
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9737BC4339E;
	Wed,  7 Jun 2023 20:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169496;
	bh=++zG4nm3ZrekF/0hccfq0iAd466/21eDd9X1I9BiucY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9bcYK6QaIxSexV7VmnivdWfZH3Ikkj9gtKRV07/842IHunTfulYCjwudD2uI2YfI
	 EBqO8JCl+OOK/Q9C4vLPayVIQn6P/vvd69KeCB0cc+x+ZgyJ8MIHb0g9x+yd+6p1ce
	 JDsy2knv3gsVpDVXy3mfsBof1Fvn4DBvftsPkL7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Liang <lxu@maxlinear.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 073/286] net: phy: mxl-gpy: extend interrupt fix to all impacted variants
Date: Wed,  7 Jun 2023 22:12:52 +0200
Message-ID: <20230607200925.469902328@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Liang <lxu@maxlinear.com>

[ Upstream commit 519d6487640835d19461817c75907e6308074a73 ]

The interrupt fix in commit 97a89ed101bb should be applied on all variants
of GPY2xx PHY and GPY115C.

Fixes: 97a89ed101bb ("net: phy: mxl-gpy: disable interrupts on GPY215 by default")
Signed-off-by: Xu Liang <lxu@maxlinear.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230531074822.39136-1-lxu@maxlinear.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mxl-gpy.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index e5972b4ef6e8f..4041ebd7ad9b3 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -267,13 +267,6 @@ static int gpy_config_init(struct phy_device *phydev)
 	return ret < 0 ? ret : 0;
 }
 
-static bool gpy_has_broken_mdint(struct phy_device *phydev)
-{
-	/* At least these PHYs are known to have broken interrupt handling */
-	return phydev->drv->phy_id == PHY_ID_GPY215B ||
-	       phydev->drv->phy_id == PHY_ID_GPY215C;
-}
-
 static int gpy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -293,8 +286,7 @@ static int gpy_probe(struct phy_device *phydev)
 	phydev->priv = priv;
 	mutex_init(&priv->mbox_lock);
 
-	if (gpy_has_broken_mdint(phydev) &&
-	    !device_property_present(dev, "maxlinear,use-broken-interrupts"))
+	if (!device_property_present(dev, "maxlinear,use-broken-interrupts"))
 		phydev->dev_flags |= PHY_F_NO_IRQ;
 
 	fw_version = phy_read(phydev, PHY_FWV);
@@ -652,11 +644,9 @@ static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
 	 * frame. Therefore, polling is the best we can do and won't do any more
 	 * harm.
 	 * It was observed that this bug happens on link state and link speed
-	 * changes on a GPY215B and GYP215C independent of the firmware version
-	 * (which doesn't mean that this list is exhaustive).
+	 * changes independent of the firmware version.
 	 */
-	if (gpy_has_broken_mdint(phydev) &&
-	    (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC))) {
+	if (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC)) {
 		reg = gpy_mbox_read(phydev, REG_GPIO0_OUT);
 		if (reg < 0) {
 			phy_error(phydev);
-- 
2.39.2



