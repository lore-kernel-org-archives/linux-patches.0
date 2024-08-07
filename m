Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0559585270;
	Wed,  7 Aug 2024 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043669; cv=none; b=e+I15NOjjOPRzgrwWsjDcM+XYDIJGXBLcWEiPo1I7fRLKoSjHd+f6qw3au85GBaR9cvFZxrYPJ0Ze2zb0FOA3VopuzHXIV+og809v59d7wFWiSWVDEyS4xnx2u3/ii5cRxhkju/WF71F9xhsU+qO3IJyuKuQGUvcq3NSCWOCB+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043669; c=relaxed/simple;
	bh=7zZFeAPEZzi70YYw7hXBI5/iFksfJjILxWB7dqZcnw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hE2K2zkC4ZGagovanydrYQnpOKLi94EJQKS8bl5eRMGVRfMOy2rL8So1IPT4dWiG8r4UqaUAqZsEDMtz4KabtJ3tPqk/uVgBLCGSVUEu79acyZ81/r1eWOWhHT45/7Iqaqv+9iKpW89Q41l2JlGqmFByc1py+l7h/ddAwjQQ8lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7I2nXU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7I2nXU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A818C32781;
	Wed,  7 Aug 2024 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043668;
	bh=7zZFeAPEZzi70YYw7hXBI5/iFksfJjILxWB7dqZcnw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7I2nXU0MD3a+jgzG2j5bTX2fdOCpjRu/CVPV48P1SWYodkEobpO9Nv3A7U0RilnP
	 Zd+qqxRClCuCy8MOxtTy/Pju4kQFath4ZUqXDv9UWgpxkSHJ3cgcMQAWD8YZflCVbb
	 LSaTXPZpdwZfpZbAj3dEOBEdlxNRnRfYgTtReOPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/86] drm/udl: Test pixel limit in mode-configs mode-valid function
Date: Wed,  7 Aug 2024 17:00:07 +0200
Message-ID: <20240807150040.163924276@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit c020f66013b6136a68a3a4ad74cc7af3b3310586 ]

The sku_pixel_limit is a per-device property, similar to the amount
of available video memory. Move the respective mode-valid test from
the connector to the mode-config structure.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221006095355.23579-3-tzimmermann@suse.de
Stable-dep-of: 5aed213c7c6c ("drm/udl: Remove DRM_CONNECTOR_POLL_HPD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/udl_connector.c | 14 --------------
 drivers/gpu/drm/udl/udl_modeset.c   | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index 3c80686263848..e9539829032c5 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -54,19 +54,6 @@ static int udl_get_modes(struct drm_connector *connector)
 	return 0;
 }
 
-static enum drm_mode_status udl_mode_valid(struct drm_connector *connector,
-			  struct drm_display_mode *mode)
-{
-	struct udl_device *udl = to_udl(connector->dev);
-	if (!udl->sku_pixel_limit)
-		return 0;
-
-	if (mode->vdisplay * mode->hdisplay > udl->sku_pixel_limit)
-		return MODE_VIRTUAL_Y;
-
-	return 0;
-}
-
 static enum drm_connector_status
 udl_detect(struct drm_connector *connector, bool force)
 {
@@ -97,7 +84,6 @@ static void udl_connector_destroy(struct drm_connector *connector)
 
 static const struct drm_connector_helper_funcs udl_connector_helper_funcs = {
 	.get_modes = udl_get_modes,
-	.mode_valid = udl_mode_valid,
 };
 
 static const struct drm_connector_funcs udl_connector_funcs = {
diff --git a/drivers/gpu/drm/udl/udl_modeset.c b/drivers/gpu/drm/udl/udl_modeset.c
index ec6876f449f31..c7adc29a53a18 100644
--- a/drivers/gpu/drm/udl/udl_modeset.c
+++ b/drivers/gpu/drm/udl/udl_modeset.c
@@ -407,8 +407,22 @@ static const struct drm_simple_display_pipe_funcs udl_simple_display_pipe_funcs
  * Modesetting
  */
 
+static enum drm_mode_status udl_mode_config_mode_valid(struct drm_device *dev,
+						       const struct drm_display_mode *mode)
+{
+	struct udl_device *udl = to_udl(dev);
+
+	if (udl->sku_pixel_limit) {
+		if (mode->vdisplay * mode->hdisplay > udl->sku_pixel_limit)
+			return MODE_MEM;
+	}
+
+	return MODE_OK;
+}
+
 static const struct drm_mode_config_funcs udl_mode_funcs = {
 	.fb_create = drm_gem_fb_create_with_dirty,
+	.mode_valid = udl_mode_config_mode_valid,
 	.atomic_check  = drm_atomic_helper_check,
 	.atomic_commit = drm_atomic_helper_commit,
 };
-- 
2.43.0



