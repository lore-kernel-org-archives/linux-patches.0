Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E647E7868F;
	Mon,  4 Mar 2024 21:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588568; cv=none; b=a1tz1RQbC/i5cGi2zsPg21Z5s9pTYZ7fcaIiGaUmIMYId7YZUzBBV8vPxaRM3bzM0cCqF9DU/e67N5JLFxcq3/o3HaPTW1SpdYoKjDK+iZrMgeFrL4Eyo2zJprSTFtJOX4iuLrdsN7X9YjuHhVCSQQTSiJVu5h0oinQVk5vi6og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588568; c=relaxed/simple;
	bh=WfB/zP/onUdsxTVqGtx1bN3WbeWA+Fe9O54UmSyzyzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Osab6dAAyHRW1a3Oz/uKejMZlJ1ezvekRwkpF1hlr20LfeaOJBOA5RUrX8j96c1zyUurWvhoPnuX0niqntALf3QncZE5x1RLSwDIqX5Z0s/BD/HUxyO8O6x4XA419aJtOGNXJ7lxND7O4c4HCTPbCT5Dpnm4nA2qlleRr0HXJzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/eCMmEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/eCMmEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7898DC433F1;
	Mon,  4 Mar 2024 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588567;
	bh=WfB/zP/onUdsxTVqGtx1bN3WbeWA+Fe9O54UmSyzyzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/eCMmELloFGEpZ1SQf0K0++6ksMSdE9UGHj8K2f45cNLgtOeUlWHw7GJPuf8Q/0o
	 uHruFP1Qiq/QBUIhYm7edsvDwcA3GgQQ6JnpNRIliGKLdvNSZ7DoCMgLAdm3Z5T3+y
	 cI6JW19CgajLRFw3AEpIAw2JzzAQU5qda5UDaG74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Belin <nbelin@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/215] drm/meson: fix unbind path if HDMI fails to bind
Date: Mon,  4 Mar 2024 21:21:05 +0000
Message-ID: <20240304211557.074706993@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 6a044642988b5f8285f3173b8e88784bef2bc306 ]

If the case the HDMI controller fails to bind, we try to unbind
all components before calling drm_dev_put() which makes drm_bridge_detach()
crash because unbinding the HDMI controller frees the bridge memory.

The solution is the unbind all components at the end like in the remove
path.

Reviewed-by: Nicolas Belin <nbelin@baylibre.com>
Tested-by: Nicolas Belin <nbelin@baylibre.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230512-amlogic-v6-4-upstream-dsi-ccf-vim3-v5-8-56eb7a4d5b8e@linaro.org
Stable-dep-of: bd915ae73a2d ("drm/meson: Don't remove bridges which are created by other drivers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 119544d88b586..fbac39aa38cc4 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -316,32 +316,34 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 		goto exit_afbcd;
 
 	if (has_components) {
-		ret = component_bind_all(drm->dev, drm);
+		ret = component_bind_all(dev, drm);
 		if (ret) {
 			dev_err(drm->dev, "Couldn't bind all components\n");
+			/* Do not try to unbind */
+			has_components = false;
 			goto exit_afbcd;
 		}
 	}
 
 	ret = meson_encoder_hdmi_init(priv);
 	if (ret)
-		goto unbind_all;
+		goto exit_afbcd;
 
 	ret = meson_plane_create(priv);
 	if (ret)
-		goto unbind_all;
+		goto exit_afbcd;
 
 	ret = meson_overlay_create(priv);
 	if (ret)
-		goto unbind_all;
+		goto exit_afbcd;
 
 	ret = meson_crtc_create(priv);
 	if (ret)
-		goto unbind_all;
+		goto exit_afbcd;
 
 	ret = request_irq(priv->vsync_irq, meson_irq, 0, drm->driver->name, drm);
 	if (ret)
-		goto unbind_all;
+		goto exit_afbcd;
 
 	drm_mode_config_reset(drm);
 
@@ -359,15 +361,18 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 uninstall_irq:
 	free_irq(priv->vsync_irq, drm);
-unbind_all:
-	if (has_components)
-		component_unbind_all(drm->dev, drm);
 exit_afbcd:
 	if (priv->afbcd.ops)
 		priv->afbcd.ops->exit(priv);
 free_drm:
 	drm_dev_put(drm);
 
+	meson_encoder_hdmi_remove(priv);
+	meson_encoder_cvbs_remove(priv);
+
+	if (has_components)
+		component_unbind_all(dev, drm);
+
 	return ret;
 }
 
-- 
2.43.0



