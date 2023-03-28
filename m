Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4448476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE19C433EF;
	Tue, 28 Mar 2023 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015246;
	bh=Z70HeDpY2yrkuH0yaRAn4s3A6cgnhnPqvmKeYQ87QwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPRLVoBSWB0sHKCdb/nkCg8dzaCbikhmxfc0maQ9I6WPkMxGo5e3iM+Kp6ujJ0pyp
	 7pfMX42Mq3fS1646sF1cIjsSyni4zSQdrM+jNWxDbNoNT2hFvnmjnu7vctJJrLTOBF
	 CfqnI/d07G3kzwFrP3UAbwrp/n906bKNe8X3EooI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.2 219/240] drm/meson: fix missing component unbind on bind errors
Date: Tue, 28 Mar 2023 16:43:02 +0200
Message-Id: <20230328142628.838258919@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit ba98413bf45edbf33672e2539e321b851b2cfbd1 upstream.

Make sure to unbind all subcomponents when binding the aggregate device
fails.

Fixes: a41e82e6c457 ("drm/meson: Add support for components")
Cc: stable@vger.kernel.org      # 4.12
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230306103533.4915-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/meson/meson_drv.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -325,23 +325,23 @@ static int meson_drv_bind_master(struct
 
 	ret = meson_encoder_hdmi_init(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_plane_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_overlay_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_crtc_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = request_irq(priv->vsync_irq, meson_irq, 0, drm->driver->name, drm);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	drm_mode_config_reset(drm);
 
@@ -359,6 +359,9 @@ static int meson_drv_bind_master(struct
 
 uninstall_irq:
 	free_irq(priv->vsync_irq, drm);
+unbind_all:
+	if (has_components)
+		component_unbind_all(drm->dev, drm);
 exit_afbcd:
 	if (priv->afbcd.ops)
 		priv->afbcd.ops->exit(priv);


