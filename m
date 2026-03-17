Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086C1191F94;
	Tue, 17 Mar 2026 17:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767916; cv=none; b=SnKALnH+cl0gpZktc9Btc08Xf+d/WBQjy4VDA/jKDpCZGKuDgmOIeVPiRBTKm6/YxtN0ycqcM879IbyMGp2oIpYuVAdS++qQCs5WW5Nf/XVK9XWy5EcHwFmtiqQUD8mEb5Ld7V4UOc3BizOl5R0iyvAT3S5vHuIOLL/Rv4ei+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767916; c=relaxed/simple;
	bh=VpxgT6OGpoFQCGo/qUIznmRu8Laxm1GNkOorxK+nfr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdW0/vdxfRVOGS3l1+5ixcsyz0YyCNfTGbGJdelc6a9ZFBz/rVeDCGp/7XlnyR2RwQBmd0GCtFn2WGrMUkMonlpPtx9LR24Z8ijYCDMelcPKGtlUiKN5lpSj4323F/kqY6HhMfqEi3qjhk/EaWGMxWrPIkkzodz7XEFTUxvllkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgzL+mg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgzL+mg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CAAC4CEF7;
	Tue, 17 Mar 2026 17:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767915;
	bh=VpxgT6OGpoFQCGo/qUIznmRu8Laxm1GNkOorxK+nfr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgzL+mg2b/fIUZ3yDR2L6osbBmTAjD1cb/CZYJym+rpQ3JorsbuzhOG2uKhpmHgtM
	 01LKN4+Mq2t/vNOmWJUySypRe4CUJhUuTffaAhLlu1ISZCyTNAZ2vEDxf1pzJ8f77l
	 OopmBoxUcg91ncym0mqCMDqicC9hSsodIXmlV3Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.18 189/333] drm/bridge: samsung-dsim: Fix memory leak in error path
Date: Tue, 17 Mar 2026 17:33:38 +0100
Message-ID: <20260317163006.365769336@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 803ec1faf7c1823e6e3b1f2aaa81be18528c9436 upstream.

In samsung_dsim_host_attach(), drm_bridge_add() is called to add the
bridge. However, if samsung_dsim_register_te_irq() or
pdata->host_ops->attach() fails afterwards, the function returns
without removing the bridge, causing a memory leak.

Fix this by adding proper error handling with goto labels to ensure
drm_bridge_remove() is called in all error paths. Also ensure that
samsung_dsim_unregister_te_irq() is called if the attach operation
fails after the TE IRQ has been registered.

samsung_dsim_unregister_te_irq() function is moved without changes
to be before samsung_dsim_host_attach() to avoid forward declaration.

Fixes: e7447128ca4a ("drm: bridge: Generalize Exynos-DSI driver into a Samsung DSIM bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260209184115.10937-1-osama.abdelkader@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/samsung-dsim.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/bridge/samsung-dsim.c
+++ b/drivers/gpu/drm/bridge/samsung-dsim.c
@@ -1881,6 +1881,14 @@ static int samsung_dsim_register_te_irq(
 	return 0;
 }
 
+static void samsung_dsim_unregister_te_irq(struct samsung_dsim *dsi)
+{
+	if (dsi->te_gpio) {
+		free_irq(gpiod_to_irq(dsi->te_gpio), dsi);
+		gpiod_put(dsi->te_gpio);
+	}
+}
+
 static int samsung_dsim_host_attach(struct mipi_dsi_host *host,
 				    struct mipi_dsi_device *device)
 {
@@ -1955,13 +1963,13 @@ of_find_panel_or_bridge:
 	if (!(device->mode_flags & MIPI_DSI_MODE_VIDEO)) {
 		ret = samsung_dsim_register_te_irq(dsi, &device->dev);
 		if (ret)
-			return ret;
+			goto err_remove_bridge;
 	}
 
 	if (pdata->host_ops && pdata->host_ops->attach) {
 		ret = pdata->host_ops->attach(dsi, device);
 		if (ret)
-			return ret;
+			goto err_unregister_te_irq;
 	}
 
 	dsi->lanes = device->lanes;
@@ -1969,14 +1977,13 @@ of_find_panel_or_bridge:
 	dsi->mode_flags = device->mode_flags;
 
 	return 0;
-}
 
-static void samsung_dsim_unregister_te_irq(struct samsung_dsim *dsi)
-{
-	if (dsi->te_gpio) {
-		free_irq(gpiod_to_irq(dsi->te_gpio), dsi);
-		gpiod_put(dsi->te_gpio);
-	}
+err_unregister_te_irq:
+	if (!(device->mode_flags & MIPI_DSI_MODE_VIDEO))
+		samsung_dsim_unregister_te_irq(dsi);
+err_remove_bridge:
+	drm_bridge_remove(&dsi->bridge);
+	return ret;
 }
 
 static int samsung_dsim_host_detach(struct mipi_dsi_host *host,


