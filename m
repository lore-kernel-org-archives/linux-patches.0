Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E691474BC;
	Wed,  2 Oct 2024 14:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879526; cv=none; b=MCjNKn4zNHsrgyJxyLg/BDTMhU2bVLOERIuSluEoSn89AWbOxwhNW+Vzthv5hnzGDAwr21BJ+Qa/iht7e1jdurpuPmG0YkO8WLvII8F4vYC7i3oqFx7wPQVf+Kt+tHP4flROtO9XDomHUebX4y5DEs9p3SGpc0GMko71mMqC1A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879526; c=relaxed/simple;
	bh=Ry+RnAG/FsM3VA8Aq6FSBvoL2NIAigWvk9EySoH6BWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Evu4nOZ1CVv4tdOX3edZjCefahr4E7sxdipD5JcXcXut34NQbu1XQ08+9rG1C2w0zr88OdB4mbR02slnR9lgluvEdWWd1wq/mIv8sEmvOTqcaHhEaqTJ+gv7rEK1i638dmrUkWGWJJHFvu9zTbwmZH0svuAVfurZFz0V5avjWe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvZTYcyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvZTYcyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3A3C4CEC2;
	Wed,  2 Oct 2024 14:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879526;
	bh=Ry+RnAG/FsM3VA8Aq6FSBvoL2NIAigWvk9EySoH6BWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvZTYcycoSP4A361Qii6yULdAUt/1nklkmMmEJqPSSsuvQ3pN/ZxxBFqf9E9pYxeH
	 ol+isN3tD11dBspv3jzogu5ijDGzn/msM9O+WfxIjvNOhSY82/IeNHEQ63RRoEXoai
	 C07WH7aZ9fS85h5X7TFHuWH85LRHanssnvHQn5nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/538] drm/bridge: lontium-lt8912b: Validate mode in drm_bridge_funcs::mode_valid()
Date: Wed,  2 Oct 2024 14:56:28 +0200
Message-ID: <20241002125758.135904111@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit fe828fbd87786238b30f44cafd698d975d956c97 ]

If the bridge is attached with the DRM_BRIDGE_ATTACH_NO_CONNECTOR flag set,
this driver won't initialize a connector and hence display mode won't be
validated in drm_connector_helper_funcs::mode_valid().  So, move the mode
validation from drm_connector_helper_funcs::mode_valid() to
drm_bridge_funcs::mode_valid(), because the mode validation is always done
for the bridge.

Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240813091637.1054586-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 35 ++++++++++++------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 0efcbc73f2a43..5e43a40a5d522 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -411,22 +411,6 @@ static const struct drm_connector_funcs lt8912_connector_funcs = {
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
-static enum drm_mode_status
-lt8912_connector_mode_valid(struct drm_connector *connector,
-			    struct drm_display_mode *mode)
-{
-	if (mode->clock > 150000)
-		return MODE_CLOCK_HIGH;
-
-	if (mode->hdisplay > 1920)
-		return MODE_BAD_HVALUE;
-
-	if (mode->vdisplay > 1080)
-		return MODE_BAD_VVALUE;
-
-	return MODE_OK;
-}
-
 static int lt8912_connector_get_modes(struct drm_connector *connector)
 {
 	const struct drm_edid *drm_edid;
@@ -452,7 +436,6 @@ static int lt8912_connector_get_modes(struct drm_connector *connector)
 
 static const struct drm_connector_helper_funcs lt8912_connector_helper_funcs = {
 	.get_modes = lt8912_connector_get_modes,
-	.mode_valid = lt8912_connector_mode_valid,
 };
 
 static void lt8912_bridge_mode_set(struct drm_bridge *bridge,
@@ -594,6 +577,23 @@ static void lt8912_bridge_detach(struct drm_bridge *bridge)
 		drm_bridge_hpd_disable(lt->hdmi_port);
 }
 
+static enum drm_mode_status
+lt8912_bridge_mode_valid(struct drm_bridge *bridge,
+			 const struct drm_display_info *info,
+			 const struct drm_display_mode *mode)
+{
+	if (mode->clock > 150000)
+		return MODE_CLOCK_HIGH;
+
+	if (mode->hdisplay > 1920)
+		return MODE_BAD_HVALUE;
+
+	if (mode->vdisplay > 1080)
+		return MODE_BAD_VVALUE;
+
+	return MODE_OK;
+}
+
 static enum drm_connector_status
 lt8912_bridge_detect(struct drm_bridge *bridge)
 {
@@ -624,6 +624,7 @@ static struct edid *lt8912_bridge_get_edid(struct drm_bridge *bridge,
 static const struct drm_bridge_funcs lt8912_bridge_funcs = {
 	.attach = lt8912_bridge_attach,
 	.detach = lt8912_bridge_detach,
+	.mode_valid = lt8912_bridge_mode_valid,
 	.mode_set = lt8912_bridge_mode_set,
 	.enable = lt8912_bridge_enable,
 	.detect = lt8912_bridge_detect,
-- 
2.43.0



