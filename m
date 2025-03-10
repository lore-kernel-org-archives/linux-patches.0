Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9384217CA12;
	Mon, 10 Mar 2025 17:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629029; cv=none; b=DFdfJVCh7leehp8ZzSuxFjfhWQVKeYsquI7gilQtgohZbEPcXulwEN9bWhJ8sOLdf9gk/MKosyDQL0EwgrTZRWt0MwrgWdEPtSf9LhaLJ6XzdVE50CSXCePSY3uvrrtAMAlzj6I5tnD6GQ3XyrVJSaZ3smtR7Izx4OeROuW8pa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629029; c=relaxed/simple;
	bh=4JkL20vtnwKFjxhGcaDiyFim8+P2kRcNMycc5bJG5aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXJPS/B+JLkxqEhUzodHYXAkS96s6HB25Q0an4f6/1iByWv0mmBWFikFcXfd+f56u8+cg2wubuYVXcnjjSQ1msgyyPLgPWAziXTMxQWdPhRBkZfWGpl47o2Cx/0h9PTK+uydfuHCvTBRddnRmAlX835+9sSRWClZS3rZp73srx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNserKBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNserKBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F53C4CEE5;
	Mon, 10 Mar 2025 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629029;
	bh=4JkL20vtnwKFjxhGcaDiyFim8+P2kRcNMycc5bJG5aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNserKBySVn7Bl8TBsPRd5EkZQumztVtcY/1nKW6LbWseQal8DBrpr5ufCOOWZ2XA
	 PBlS07/nV+ZioLEd1j/te3aS4EZnWxSddT84MRP4LlRFVdyKJm8Ua2pTUtxHIEuV3t
	 34CgKKNrWcM9MoLMJkYTrzBdwypriZYTZbBu0504=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/620] mtd: hyperbus: Make hyperbus_unregister_device() return void
Date: Mon, 10 Mar 2025 17:59:51 +0100
Message-ID: <20250310170551.329323847@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 0c90466a7985d39355f743e9cd2139da3e86c4d8 ]

The only thing that could theoretically fail in that function is
mtd_device_unregister(). However it's not supposed to fail and when
used correctly it doesn't. So wail loudly if it does anyhow.

This matches how other drivers (e.g. nand/raw/nandsim.c) use
mtd_device_unregister().

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220603210758.148493-2-u.kleine-koenig@pengutronix.de
Stable-dep-of: bf5821909eb9 ("mtd: hyperbus: hbmc-am654: fix an OF node reference leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/hbmc-am654.c    | 6 +++---
 drivers/mtd/hyperbus/hyperbus-core.c | 8 ++------
 drivers/mtd/hyperbus/rpc-if.c        | 5 +++--
 include/linux/mtd/hyperbus.h         | 4 +---
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/mtd/hyperbus/hbmc-am654.c b/drivers/mtd/hyperbus/hbmc-am654.c
index a3439b791eeb4..a6161ce340d4e 100644
--- a/drivers/mtd/hyperbus/hbmc-am654.c
+++ b/drivers/mtd/hyperbus/hbmc-am654.c
@@ -233,16 +233,16 @@ static int am654_hbmc_remove(struct platform_device *pdev)
 {
 	struct am654_hbmc_priv *priv = platform_get_drvdata(pdev);
 	struct am654_hbmc_device_priv *dev_priv = priv->hbdev.priv;
-	int ret;
 
-	ret = hyperbus_unregister_device(&priv->hbdev);
+	hyperbus_unregister_device(&priv->hbdev);
+
 	if (priv->mux_ctrl)
 		mux_control_deselect(priv->mux_ctrl);
 
 	if (dev_priv->rx_chan)
 		dma_release_channel(dev_priv->rx_chan);
 
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id am654_hbmc_dt_ids[] = {
diff --git a/drivers/mtd/hyperbus/hyperbus-core.c b/drivers/mtd/hyperbus/hyperbus-core.c
index 2f9fc4e17d53e..4d8047d43e48e 100644
--- a/drivers/mtd/hyperbus/hyperbus-core.c
+++ b/drivers/mtd/hyperbus/hyperbus-core.c
@@ -126,16 +126,12 @@ int hyperbus_register_device(struct hyperbus_device *hbdev)
 }
 EXPORT_SYMBOL_GPL(hyperbus_register_device);
 
-int hyperbus_unregister_device(struct hyperbus_device *hbdev)
+void hyperbus_unregister_device(struct hyperbus_device *hbdev)
 {
-	int ret = 0;
-
 	if (hbdev && hbdev->mtd) {
-		ret = mtd_device_unregister(hbdev->mtd);
+		WARN_ON(mtd_device_unregister(hbdev->mtd));
 		map_destroy(hbdev->mtd);
 	}
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(hyperbus_unregister_device);
 
diff --git a/drivers/mtd/hyperbus/rpc-if.c b/drivers/mtd/hyperbus/rpc-if.c
index dc164c18f8429..cd0e577684ff0 100644
--- a/drivers/mtd/hyperbus/rpc-if.c
+++ b/drivers/mtd/hyperbus/rpc-if.c
@@ -151,11 +151,12 @@ static int rpcif_hb_probe(struct platform_device *pdev)
 static int rpcif_hb_remove(struct platform_device *pdev)
 {
 	struct rpcif_hyperbus *hyperbus = platform_get_drvdata(pdev);
-	int error = hyperbus_unregister_device(&hyperbus->hbdev);
+
+	hyperbus_unregister_device(&hyperbus->hbdev);
 
 	rpcif_disable_rpm(&hyperbus->rpc);
 
-	return error;
+	return 0;
 }
 
 static struct platform_driver rpcif_platform_driver = {
diff --git a/include/linux/mtd/hyperbus.h b/include/linux/mtd/hyperbus.h
index 0ce612428aea2..bb6b7121a5427 100644
--- a/include/linux/mtd/hyperbus.h
+++ b/include/linux/mtd/hyperbus.h
@@ -89,9 +89,7 @@ int hyperbus_register_device(struct hyperbus_device *hbdev);
 /**
  * hyperbus_unregister_device - deregister HyperBus slave memory device
  * @hbdev: hyperbus_device to be unregistered
- *
- * Return: 0 for success, others for failure.
  */
-int hyperbus_unregister_device(struct hyperbus_device *hbdev);
+void hyperbus_unregister_device(struct hyperbus_device *hbdev);
 
 #endif /* __LINUX_MTD_HYPERBUS_H__ */
-- 
2.39.5



