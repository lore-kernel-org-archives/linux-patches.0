Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5264E246BD5;
	Mon, 23 Mar 2026 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278443; cv=none; b=usdvnKUKnMBds4ucf+khE+1VqPkK0/rK56bSk/TmjXpbA9bpdRbF/Q1glfSycsm8BE3NJ2LhXLckRbv7aDVFILz3Qsl1COLU7Uc3Xy4Ze9aERdH+2rcW36VfyMGzqEFxg4/DXFjZj3uGuhqtWhFhkbYGowCynDVLfzldrGb3t/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278443; c=relaxed/simple;
	bh=yWnt8I9Ae56AdmtFBj+rV2qtpd9C5TM81OoLscLq8jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edmkx4X20yZVRBhjyKCdsMlWsQMXvkTjsbFSo63L1hlfkxDaIg80ROnTOtMi5A7boY/QuIYSbt5iOfi+h2DJz2GqTNK/pqv2K9REZ1ofw748n6SOKUJqu6YKKGOLHyQKOjXMZ+2R279hzay5kJCQhB3E1Cr4DW7KfzJtjOBqZb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFTXZsiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFTXZsiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA7BC4CEF7;
	Mon, 23 Mar 2026 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278443;
	bh=yWnt8I9Ae56AdmtFBj+rV2qtpd9C5TM81OoLscLq8jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFTXZsiu9WB/K4jiC9vcQWCW6ZyhrXc3dW72a5qJGJQj8lK9SDHQiDSBeby49nYJs
	 F+2Xl0IGpBXJ6jTZ/N8GAyahvOm6YXtBe0kbVnSErKW3o7Dfi0WlYuJgn8CGBfSEXm
	 DhMEPklvdSYFr0+1Kbe4pyF2WyWPdKsulCasMPdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.6 308/567] drm/bridge: samsung-dsim: Fix memory leak in error path
Date: Mon, 23 Mar 2026 14:43:48 +0100
Message-ID: <20260323134541.444249313@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
@@ -1642,6 +1642,14 @@ static int samsung_dsim_register_te_irq(
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
@@ -1713,13 +1721,13 @@ of_find_panel_or_bridge:
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
@@ -1727,14 +1735,13 @@ of_find_panel_or_bridge:
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


