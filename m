Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9655B1EB5B;
	Sun,  1 Sep 2024 17:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210055; cv=none; b=WNPl2yjJdp8zvx41BdXPpdEuiIBtJH6PQVtNGHIBJ96NA1w6Sd5SUwBtJRrdMOz13iTpbRC0/Ik0VYiKZleYTjew+t8yh78a7nyE2KYl4RRKRxef75J0DYqEBd0czaE1yV3MJxelz+P4yIO4Dz1RFRrVq7Qkalu5j3AEq9IxBd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210055; c=relaxed/simple;
	bh=yNqgWO6Tj2fjHcroA+ftTKatklJZ0NtrwzbEYOULi6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lhc1gZrrZQIF/f0RlLKDwV6rDnpiyIuvnM1I2MyDDjySPbC+Ds9u91tP2ZX7EptYh6CTTj+Cwqo4aAuRmrrCeiVPeEy6vE2dCTA5jDScxRJudfFlPMMxtVBcpSvLj+3yHpFEaTZlU3nfOujmtqS0Q2i3dWXUPY6EHqpSKEt7qlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3rx12b2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3rx12b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3A6C4CEC3;
	Sun,  1 Sep 2024 17:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210055;
	bh=yNqgWO6Tj2fjHcroA+ftTKatklJZ0NtrwzbEYOULi6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3rx12b2nn+BMBsWJJmnRteZ8sEXExwNz0Pbn7+Brlw+PZyr/m2Yr8AZAZ13EUKiu
	 mCebVnmd6PjysjJ3aI0loa2xkfLPT9tGswRuVBDn+ElKXDMsiOYG1HPsUr3ZB4b8uR
	 XfIodFv2QAqh74MO8s3TUXnrEXhYji01DZ+z2Y90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/215] net: dsa: vsc73xx: check busy flag in MDIO operations
Date: Sun,  1 Sep 2024 18:15:45 +0200
Message-ID: <20240901160824.515136021@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Dembicki <paweldembicki@gmail.com>

[ Upstream commit fa63c6434b6f6aaf9d8d599dc899bc0a074cc0ad ]

The VSC73xx has a busy flag used during MDIO operations. It is raised
when MDIO read/write operations are in progress. Without it, PHYs are
misconfigured and bus operations do not work as expected.

Fixes: 05bd97fc559d ("net: dsa: Add Vitesse VSC73xx DSA router driver")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 37 +++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index ce1c6d6eeb606..592527f069446 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -39,6 +39,10 @@
 #define VSC73XX_BLOCK_ARBITER	0x5 /* Only subblock 0 */
 #define VSC73XX_BLOCK_SYSTEM	0x7 /* Only subblock 0 */
 
+/* MII Block subblock */
+#define VSC73XX_BLOCK_MII_INTERNAL	0x0 /* Internal MDIO subblock */
+#define VSC73XX_BLOCK_MII_EXTERNAL	0x1 /* External MDIO subblock */
+
 #define CPU_PORT	6 /* CPU port */
 
 /* MAC Block registers */
@@ -197,6 +201,8 @@
 #define VSC73XX_MII_CMD		0x1
 #define VSC73XX_MII_DATA	0x2
 
+#define VSC73XX_MII_STAT_BUSY	BIT(3)
+
 /* Arbiter block 5 registers */
 #define VSC73XX_ARBEMPTY		0x0c
 #define VSC73XX_ARBDISC			0x0e
@@ -271,6 +277,7 @@
 #define IS_739X(a) (IS_7395(a) || IS_7398(a))
 
 #define VSC73XX_POLL_SLEEP_US		1000
+#define VSC73XX_MDIO_POLL_SLEEP_US	5
 #define VSC73XX_POLL_TIMEOUT_US		10000
 
 struct vsc73xx_counter {
@@ -488,6 +495,22 @@ static int vsc73xx_detect(struct vsc73xx *vsc)
 	return 0;
 }
 
+static int vsc73xx_mdio_busy_check(struct vsc73xx *vsc)
+{
+	int ret, err;
+	u32 val;
+
+	ret = read_poll_timeout(vsc73xx_read, err,
+				err < 0 || !(val & VSC73XX_MII_STAT_BUSY),
+				VSC73XX_MDIO_POLL_SLEEP_US,
+				VSC73XX_POLL_TIMEOUT_US, false, vsc,
+				VSC73XX_BLOCK_MII, VSC73XX_BLOCK_MII_INTERNAL,
+				VSC73XX_MII_STAT, &val);
+	if (ret)
+		return ret;
+	return err;
+}
+
 static int vsc73xx_phy_read(struct dsa_switch *ds, int phy, int regnum)
 {
 	struct vsc73xx *vsc = ds->priv;
@@ -495,12 +518,20 @@ static int vsc73xx_phy_read(struct dsa_switch *ds, int phy, int regnum)
 	u32 val;
 	int ret;
 
+	ret = vsc73xx_mdio_busy_check(vsc);
+	if (ret)
+		return ret;
+
 	/* Setting bit 26 means "read" */
 	cmd = BIT(26) | (phy << 21) | (regnum << 16);
 	ret = vsc73xx_write(vsc, VSC73XX_BLOCK_MII, 0, 1, cmd);
 	if (ret)
 		return ret;
-	msleep(2);
+
+	ret = vsc73xx_mdio_busy_check(vsc);
+	if (ret)
+		return ret;
+
 	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_MII, 0, 2, &val);
 	if (ret)
 		return ret;
@@ -524,6 +555,10 @@ static int vsc73xx_phy_write(struct dsa_switch *ds, int phy, int regnum,
 	u32 cmd;
 	int ret;
 
+	ret = vsc73xx_mdio_busy_check(vsc);
+	if (ret)
+		return ret;
+
 	/* It was found through tedious experiments that this router
 	 * chip really hates to have it's PHYs reset. They
 	 * never recover if that happens: autonegotiation stops
-- 
2.43.0



