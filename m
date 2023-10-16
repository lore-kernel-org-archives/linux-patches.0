Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588D81798F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnksSauq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385C3C433C8;
	Mon, 16 Oct 2023 08:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446754;
	bh=g6aRA6U3ucKWEJJ7agQ0eHILKxOjbQ+dUxvajoKduGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnksSauqp4OOjlc+l9YoiyXzWFz332wcwV5UfNI0UM53tifFBdrc15jo9Z5dvCQbR
	 SyUApCEDqhAwHiezO5wmOW5lPCxdOCjr8MjNVbWcL2c7/U5OS2XLk4tAxEABIAZSP1
	 7iGfKRIuJhvoun0d5VKd6Whp5pjAvmon8nXYU4eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/131] phy: lynx-28g: cancel the CDR check work item on the remove path
Date: Mon, 16 Oct 2023 10:40:22 +0200
Message-ID: <20231016084001.044035662@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit f200bab3756fe81493a1b280180dafa1d9ccdcf7 ]

The blamed commit added the CDR check work item but didn't cancel it on
the remove path. Fix this by adding a remove function which takes care
of it.

Fixes: 8f73b37cf3fb ("phy: add support for the Layerscape SerDes 28G")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-lynx-28g.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/phy/freescale/phy-fsl-lynx-28g.c b/drivers/phy/freescale/phy-fsl-lynx-28g.c
index 569f12af2aafa..9d55dbee2e0a5 100644
--- a/drivers/phy/freescale/phy-fsl-lynx-28g.c
+++ b/drivers/phy/freescale/phy-fsl-lynx-28g.c
@@ -603,6 +603,14 @@ static int lynx_28g_probe(struct platform_device *pdev)
 	return PTR_ERR_OR_ZERO(provider);
 }
 
+static void lynx_28g_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct lynx_28g_priv *priv = dev_get_drvdata(dev);
+
+	cancel_delayed_work_sync(&priv->cdr_check);
+}
+
 static const struct of_device_id lynx_28g_of_match_table[] = {
 	{ .compatible = "fsl,lynx-28g" },
 	{ },
@@ -611,6 +619,7 @@ MODULE_DEVICE_TABLE(of, lynx_28g_of_match_table);
 
 static struct platform_driver lynx_28g_driver = {
 	.probe	= lynx_28g_probe,
+	.remove_new = lynx_28g_remove,
 	.driver	= {
 		.name = "lynx-28g",
 		.of_match_table = lynx_28g_of_match_table,
-- 
2.40.1



