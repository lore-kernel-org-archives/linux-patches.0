Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85DD273DA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKDjD7eY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06198C433C7;
	Mon, 16 Oct 2023 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467594;
	bh=uSNxhRvw7aGXxbb3sMd/pBW5RCZxa7ZM9tMBX28e/6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKDjD7eY4HYDXJW+PETqXBHRiC5TJAtKedh6Q2reqvrvJxgD3AXsOjQuImeopi5uc
	 IcJWumnNJiV1lxzM6Tfqasx/icMRpQU2cQ/o7qhtq0R8m3Nf7uZMNQTKRrwuIul4X6
	 2KYm6mfeMEV4Lwb9ETwqTR7N88dXBWpJbDTgrpKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 052/191] phy: lynx-28g: serialize concurrent phy_set_mode_ext() calls to shared registers
Date: Mon, 16 Oct 2023 10:40:37 +0200
Message-ID: <20231016084016.621292633@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 139ad1143151a07be93bf741d4ea7c89e59f89ce ]

The protocol converter configuration registers PCC8, PCCC, PCCD
(implemented by the driver), as well as others, control protocol
converters from multiple lanes (each represented as a different
struct phy). So, if there are simultaneous calls to phy_set_mode_ext()
to lanes sharing the same PCC register (either for the "old" or for the
"new" protocol), corruption of the values programmed to hardware is
possible, because lynx_28g_rmw() has no locking.

Add a spinlock in the struct lynx_28g_priv shared by all lanes, and take
the global spinlock from the phy_ops :: set_mode() implementation. There
are no other callers which modify PCC registers.

Fixes: 8f73b37cf3fb ("phy: add support for the Layerscape SerDes 28G")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-lynx-28g.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/phy/freescale/phy-fsl-lynx-28g.c b/drivers/phy/freescale/phy-fsl-lynx-28g.c
index d49aa59c7d812..0a8b40edc3f31 100644
--- a/drivers/phy/freescale/phy-fsl-lynx-28g.c
+++ b/drivers/phy/freescale/phy-fsl-lynx-28g.c
@@ -126,6 +126,10 @@ struct lynx_28g_lane {
 struct lynx_28g_priv {
 	void __iomem *base;
 	struct device *dev;
+	/* Serialize concurrent access to registers shared between lanes,
+	 * like PCCn
+	 */
+	spinlock_t pcc_lock;
 	struct lynx_28g_pll pll[LYNX_28G_NUM_PLL];
 	struct lynx_28g_lane lane[LYNX_28G_NUM_LANE];
 
@@ -396,6 +400,8 @@ static int lynx_28g_set_mode(struct phy *phy, enum phy_mode mode, int submode)
 	if (powered_up)
 		lynx_28g_power_off(phy);
 
+	spin_lock(&priv->pcc_lock);
+
 	switch (submode) {
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
@@ -412,6 +418,8 @@ static int lynx_28g_set_mode(struct phy *phy, enum phy_mode mode, int submode)
 	lane->interface = submode;
 
 out:
+	spin_unlock(&priv->pcc_lock);
+
 	/* Power up the lane if necessary */
 	if (powered_up)
 		lynx_28g_power_on(phy);
@@ -595,6 +603,7 @@ static int lynx_28g_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, priv);
 
+	spin_lock_init(&priv->pcc_lock);
 	INIT_DELAYED_WORK(&priv->cdr_check, lynx_28g_cdr_lock_check);
 
 	queue_delayed_work(system_power_efficient_wq, &priv->cdr_check,
-- 
2.40.1



