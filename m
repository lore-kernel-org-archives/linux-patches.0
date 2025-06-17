Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5632FA630;
	Tue, 17 Jun 2025 16:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179080; cv=none; b=ric0wE+IMf8qWAnTsW+4G2MOvxr4zwQsJ2ZPbGfCDlWnx9sNgsTRozzR/WBVTBfoSMI/qCwvQSb+p4aBN/mWhLyUwAlP3iXlTyHVqfI8/zgzY+bKn2wa5kNVRTSXMRbdJaIxSRU7VeIDY6BOEMadTUCexkt31imx4QKVfHdzCYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179080; c=relaxed/simple;
	bh=bjaaHzcaeCllaBZzG56xeZHo7uJSKzjumVgDy+Ru7kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFglnSvtz+8EYAT5z/rklc3CC9/dFULzGaQ4NNn4NOqCr/r8c/uTvF2ypc1Uh5O2O0k04N8F7BYswOwfcddMsQEHPQAjl1wFBHEfH0pzKREVgjIlZKbLEvTB/Yftn3Zn1MWXB61VxzI35fQYSQs+OiMi29yR90M1+1mcTLjKILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdnyR6GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdnyR6GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B65BC4CEE3;
	Tue, 17 Jun 2025 16:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179080;
	bh=bjaaHzcaeCllaBZzG56xeZHo7uJSKzjumVgDy+Ru7kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdnyR6GUbJwey0maQMKPFozTOZDje+iVbmvnaHChlCClWnmdk8OwkV07xifLU/dpU
	 zY1lqxOf6JRcTRk/tHjNCaiIyDdekpIKR4vTFGMR2Q7aq0US+Vx6yrO2AaR7ABmmtR
	 kTbjTwuho8pK5osjeYO501MVrd48vu/0JXeqLzDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 613/780] net: dsa: b53: do not configure bcm63xxs IMP port interface
Date: Tue, 17 Jun 2025 17:25:21 +0200
Message-ID: <20250617152516.448116638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 75f4f7b2b13008803f84768ff90396f9d7553221 ]

The IMP port is not a valid RGMII interface, but hard wired to internal,
so we shouldn't touch the undefined register B53_RGMII_CTRL_IMP.

While this does not seem to have any side effects, let's not touch it at
all, so limit RGMII configuration on bcm63xx to the actual RGMII ports.

Fixes: ce3bf94871f7 ("net: dsa: b53: add support for BCM63xx RGMIIs")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250602193953.1010487-4-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index c186ee3fb28df..3f4934f974c81 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -22,6 +22,7 @@
 #include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/math.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/platform_data/b53.h>
 #include <linux/phy.h>
@@ -1322,24 +1323,17 @@ static void b53_adjust_63xx_rgmii(struct dsa_switch *ds, int port,
 				  phy_interface_t interface)
 {
 	struct b53_device *dev = ds->priv;
-	u8 rgmii_ctrl = 0, off;
+	u8 rgmii_ctrl = 0;
 
-	if (port == dev->imp_port)
-		off = B53_RGMII_CTRL_IMP;
-	else
-		off = B53_RGMII_CTRL_P(port);
-
-	b53_read8(dev, B53_CTRL_PAGE, off, &rgmii_ctrl);
+	b53_read8(dev, B53_CTRL_PAGE, B53_RGMII_CTRL_P(port), &rgmii_ctrl);
 	rgmii_ctrl &= ~(RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
 
-	if (port != dev->imp_port) {
-		if (is63268(dev))
-			rgmii_ctrl |= RGMII_CTRL_MII_OVERRIDE;
+	if (is63268(dev))
+		rgmii_ctrl |= RGMII_CTRL_MII_OVERRIDE;
 
-		rgmii_ctrl |= RGMII_CTRL_ENABLE_GMII;
-	}
+	rgmii_ctrl |= RGMII_CTRL_ENABLE_GMII;
 
-	b53_write8(dev, B53_CTRL_PAGE, off, rgmii_ctrl);
+	b53_write8(dev, B53_CTRL_PAGE, B53_RGMII_CTRL_P(port), rgmii_ctrl);
 
 	dev_dbg(ds->dev, "Configured port %d for %s\n", port,
 		phy_modes(interface));
@@ -1484,7 +1478,7 @@ static void b53_phylink_mac_config(struct phylink_config *config,
 	struct b53_device *dev = ds->priv;
 	int port = dp->index;
 
-	if (is63xx(dev) && port >= B53_63XX_RGMII0)
+	if (is63xx(dev) && in_range(port, B53_63XX_RGMII0, 4))
 		b53_adjust_63xx_rgmii(ds, port, interface);
 
 	if (mode == MLO_AN_FIXED) {
-- 
2.39.5



