Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE1815CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581FBC433B5;
	Tue,  8 Nov 2022 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916382;
	bh=zJI2jWezCcD6OPCaq19VKMZ4TVut7o6Q0Uzck4bMnWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3eKiR+TyaetEKd11gKcFODnuzEl5h2dOEFOchi9ihZHIPgum7YoNzvb9/Cjfw8La
	 Sr8mP4vGhHHCUEDvEu77esa3G5Cv1At4N0w/OGxOVWqv9FCe9Y45yLEecpdxKZ3bGg
	 DeAwvhWspsf9UxG/k30/cgY2apdVhMcBFfPD2LOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 140/144] drm/rockchip: dsi: Clean up usage_mode when failing to attach
Date: Tue,  8 Nov 2022 14:40:17 +0100
Message-Id: <20221108133351.206695248@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Norris <briannorris@chromium.org>

commit 0be67e0556e469c57100ffe3c90df90abc796f3b upstream.

If we fail to attach the first time (especially: EPROBE_DEFER), we fail
to clean up 'usage_mode', and thus will fail to attach on any subsequent
attempts, with "dsi controller already in use".

Re-set to DW_DSI_USAGE_IDLE on attach failure.

This is especially common to hit when enabling asynchronous probe on a
duel-DSI system (such as RK3399 Gru/Scarlet), such that we're more
likely to fail dw_mipi_dsi_rockchip_find_second() the first time.

Fixes: 71f68fe7f121 ("drm/rockchip: dsi: add ability to work as a phy instead of full dsi")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221019170255.1.Ia68dfb27b835d31d22bfe23812baf366ee1c6eac@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -1027,23 +1027,31 @@ static int dw_mipi_dsi_rockchip_host_att
 	if (ret) {
 		DRM_DEV_ERROR(dsi->dev, "Failed to register component: %d\n",
 					ret);
-		return ret;
+		goto out;
 	}
 
 	second = dw_mipi_dsi_rockchip_find_second(dsi);
-	if (IS_ERR(second))
-		return PTR_ERR(second);
+	if (IS_ERR(second)) {
+		ret = PTR_ERR(second);
+		goto out;
+	}
 	if (second) {
 		ret = component_add(second, &dw_mipi_dsi_rockchip_ops);
 		if (ret) {
 			DRM_DEV_ERROR(second,
 				      "Failed to register component: %d\n",
 				      ret);
-			return ret;
+			goto out;
 		}
 	}
 
 	return 0;
+
+out:
+	mutex_lock(&dsi->usage_mutex);
+	dsi->usage_mode = DW_DSI_USAGE_IDLE;
+	mutex_unlock(&dsi->usage_mutex);
+	return ret;
 }
 
 static int dw_mipi_dsi_rockchip_host_detach(void *priv_data,


