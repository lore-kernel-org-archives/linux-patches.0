Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2E73C4B8D;
	Sat, 17 Oct 2026 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258411; cv=none; b=V4jEnmm3VHkOGucoEWhaUjDTvzRnBuzkpuQ6yXQ4X/a77cKZ/5SyI2ceZtZ+G83dqnCZ+GZrYu2ulnqwoptYEC1+rfDEP5y88S9YLQJPxX2vwnhhXQGS7xdFdlsraH0cmGlYpHmF+WQClSCHoqxLHMERTp5sZyms09pRc2Ak9K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258411; c=relaxed/simple;
	bh=LlE7MG3bEDy/zLjGUlK+WC9uSeUU9YOUlNTlQH5QCjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLZoeH5rLNk31EjgjbW8vQlT4/cdedfjXBt4+3r01LJ/hNjiL+DBBC1eY2ot04iVqXJVBmfwucUlzuso3nbTzpHQH3N4wxSVvYmuoZC4Wu0cjBTCCVhLa3/HrNpLUmRUShc1ZAfMgrbqL9s1klrvs6LGE3M3MLScGv4Wf9EftMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZSFkvEe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZSFkvEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307741F000C4;
	Sat, 17 Oct 2026 17:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258409;
	bh=W0th0QRTASfkz4/9jR76otIZixIe0HNethfyq5S2GFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZSFkvEelAK6DNMutjRlNaE61nPWgIFNxmWzDuM3OeVj3zfsdKHCvpv4G5yhkEH6q
	 CdoakA72VAOepvnHSBfjLSSDCz37N6O9ltaYDEY11454u1oRHYsu+91zF4zcMx/sPn
	 lpVvTqZYtS2uFDj/gASkoQdsAr7hsw2sa7Q/ecgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0874/1674] net: bcmasp: fix double free of WoL irq
Date: Sat, 17 Oct 2026 17:52:26 +0200
Message-ID: <20261017160453.548278100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit cbfa5be2bf64511d49b854a0f9fd6d0b5118621f ]

We do not need to free wol_irq since it was instantiated with
devm_request_irq(). So devres will free for us.

Fixes: a2f0751206b0 ("net: bcmasp: Add support for WoL magic packet")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260319234813.1937315-2-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c | 21 ---------------------
 drivers/net/ethernet/broadcom/asp2/bcmasp.h |  2 --
 2 files changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index d9e9ec2e8945d..a419e71608872 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -1118,12 +1118,6 @@ static void bcmasp_enable_wol_shared(struct bcmasp_intf *intf, bool en)
 	}
 }
 
-static void bcmasp_wol_irq_destroy_shared(struct bcmasp_priv *priv)
-{
-	if (priv->wol_irq > 0)
-		free_irq(priv->wol_irq, priv);
-}
-
 static void bcmasp_init_wol_per_intf(struct bcmasp_priv *priv)
 {
 	struct platform_device *pdev = priv->pdev;
@@ -1156,16 +1150,6 @@ static void bcmasp_enable_wol_per_intf(struct bcmasp_intf *intf, bool en)
 	device_set_wakeup_enable(dev, en);
 }
 
-static void bcmasp_wol_irq_destroy_per_intf(struct bcmasp_priv *priv)
-{
-	struct bcmasp_intf *intf;
-
-	list_for_each_entry(intf, &priv->intfs, list) {
-		if (intf->wol_irq > 0)
-			free_irq(intf->wol_irq, priv);
-	}
-}
-
 static struct bcmasp_hw_info v20_hw_info = {
 	.rx_ctrl_flush = ASP_RX_CTRL_FLUSH,
 	.umac2fb = UMAC2FB_OFFSET,
@@ -1177,7 +1161,6 @@ static struct bcmasp_hw_info v20_hw_info = {
 static const struct bcmasp_plat_data v20_plat_data = {
 	.init_wol = bcmasp_init_wol_per_intf,
 	.enable_wol = bcmasp_enable_wol_per_intf,
-	.destroy_wol = bcmasp_wol_irq_destroy_per_intf,
 	.hw_info = &v20_hw_info,
 };
 
@@ -1193,7 +1176,6 @@ static struct bcmasp_hw_info v21_hw_info = {
 static const struct bcmasp_plat_data v21_plat_data = {
 	.init_wol = bcmasp_init_wol_shared,
 	.enable_wol = bcmasp_enable_wol_shared,
-	.destroy_wol = bcmasp_wol_irq_destroy_shared,
 	.hw_info = &v21_hw_info,
 };
 
@@ -1267,7 +1249,6 @@ static int bcmasp_probe(struct platform_device *pdev)
 
 	priv->init_wol = pdata->init_wol;
 	priv->enable_wol = pdata->enable_wol;
-	priv->destroy_wol = pdata->destroy_wol;
 	priv->hw_info = pdata->hw_info;
 
 	/* Enable all clocks to ensure successful probing */
@@ -1331,7 +1312,6 @@ static int bcmasp_probe(struct platform_device *pdev)
 		if (ret) {
 			netdev_err(intf->ndev,
 				   "failed to register net_device: %d\n", ret);
-			priv->destroy_wol(priv);
 			bcmasp_remove_intfs(priv);
 			goto of_put_exit;
 		}
@@ -1352,7 +1332,6 @@ static int bcmasp_remove(struct platform_device *pdev)
 	if (!priv)
 		return 0;
 
-	priv->destroy_wol(priv);
 	bcmasp_remove_intfs(priv);
 
 	return 0;
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.h b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
index ec90add6b03e2..985a473339559 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.h
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
@@ -371,7 +371,6 @@ struct bcmasp_hw_info {
 struct bcmasp_plat_data {
 	void (*init_wol)(struct bcmasp_priv *priv);
 	void (*enable_wol)(struct bcmasp_intf *intf, bool en);
-	void (*destroy_wol)(struct bcmasp_priv *priv);
 	struct bcmasp_hw_info		*hw_info;
 };
 
@@ -389,7 +388,6 @@ struct bcmasp_priv {
 
 	void (*init_wol)(struct bcmasp_priv *priv);
 	void (*enable_wol)(struct bcmasp_intf *intf, bool en);
-	void (*destroy_wol)(struct bcmasp_priv *priv);
 
 	void __iomem			*base;
 	struct	bcmasp_hw_info		*hw_info;
-- 
2.53.0



