Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373FB1C93AE;
	Tue, 27 Aug 2024 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772027; cv=none; b=mVb4dWfEP4QUkiJ8Ay/S6FIbeYCuU02k/oMAxRYRu8hgMs+XAqc1fd4PrwVhoJVlGg21Q864BM0y9wX52AzZKVaBG+UelXuiy2bLSs+690crZlOz+LT8473po3peQOQnjVGTW2r3GCVObfHsgcY82l7fP/0O+U4mf3AtZOlbpkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772027; c=relaxed/simple;
	bh=lHYUlYiIcBs8yJgl+IVX7nLBuPCP+QV/LDu4d5YcyIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwvIe+mrH2uxywqrYP3mbIoGKS/uRXdcikIVOeS4MJSm6OBNLqn6TAqdHz1Triq6VebX5NffNxhhn9/VSbgo986cK77brOpcRhDyVFOgbZhdqKIFeNWoHlXIdTXigpEWbzqTBNq4o+HFlHQzFPlH1t02OizdQRt1TcaBYvO+Rgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hsaYcST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hsaYcST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE02DC4DDF1;
	Tue, 27 Aug 2024 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772027;
	bh=lHYUlYiIcBs8yJgl+IVX7nLBuPCP+QV/LDu4d5YcyIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hsaYcST24tlg+ZrJ7s9QKFdmgy5NBGjQ/WxwOQwSuFVMAsWAorwAzSJNsC0Zd7oM
	 Oye8aPH+hzDgCZD44irZZth0S3gODXftUhnWujgVQ+cvw/1XD7ElTkiJZygHXQPjuL
	 riV/eSzVs5hS7ISeLQLtdwQMh9p3Lu5A5R7t+H8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/321] net: dsa: vsc73xx: check busy flag in MDIO operations
Date: Tue, 27 Aug 2024 16:36:39 +0200
Message-ID: <20240827143841.703765638@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 92087f9d73550..c8e9ca5d5c284 100644
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



