Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B8C13F435;
	Tue, 15 Oct 2024 11:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992626; cv=none; b=BhqdULCbggz2ivKCfANfj5rKtpXHL1PwrzaYzhiAG9ZNIzc/eX0xyCjUiejbGHXk0La2CDAxkdIQrF84F+qo0eOtlxKtyyTfeWK9BKUuup/sKgTGpuCliwbWTDcTTuJnzSFzkfllwAise3kHoVLNDsa/wyjhd66zjtwOe2iJaDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992626; c=relaxed/simple;
	bh=MKbXN/oUa9n4+9anUzXXCECYBG/6rEaJow0Lv+DpnW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhVtBfP1Ss1igKoS4XGm7qtj0bjZxHNm19rOCAZPMlgRqwMt7kqrU1jR6RdRsdGEaNY2B9+Po1A+pyAbABzDP8KwBm40aOyu5Ag79ed+YlAOWnIpPCYK6JZvmxxxoPaPRwHDDSNXe3iTRGkIGyTl+BDNQ9dEI+AUE9ni0dgpbDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd6kzsQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd6kzsQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B07C4CEC6;
	Tue, 15 Oct 2024 11:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992626;
	bh=MKbXN/oUa9n4+9anUzXXCECYBG/6rEaJow0Lv+DpnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hd6kzsQu26dxdSX/sahEjNuwTEjB+f7aT2G1v1lt9qfhrqzXW38PO8vj+TSyrNl1K
	 KhRoQhskvUhzAxbBXNFJkR4assD3k9f0+h2zZJvwwQ1KjZWXkNfxd7nYHgdWqFqQ4o
	 TKHNpDMaPZKNnLyvpcI+SZ65MDC7r+P4JDR7e+xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/691] drm/bridge: lontium-lt8912b: Validate mode in drm_bridge_funcs::mode_valid()
Date: Tue, 15 Oct 2024 13:21:59 +0200
Message-ID: <20241015112447.153477178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6379d5c8edff1..9dd52282a055e 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -401,22 +401,6 @@ static const struct drm_connector_funcs lt8912_connector_funcs = {
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
 	struct edid *edid;
@@ -444,7 +428,6 @@ static int lt8912_connector_get_modes(struct drm_connector *connector)
 
 static const struct drm_connector_helper_funcs lt8912_connector_helper_funcs = {
 	.get_modes = lt8912_connector_get_modes,
-	.mode_valid = lt8912_connector_mode_valid,
 };
 
 static void lt8912_bridge_mode_set(struct drm_bridge *bridge,
@@ -590,6 +573,23 @@ static void lt8912_bridge_detach(struct drm_bridge *bridge)
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
@@ -620,6 +620,7 @@ static struct edid *lt8912_bridge_get_edid(struct drm_bridge *bridge,
 static const struct drm_bridge_funcs lt8912_bridge_funcs = {
 	.attach = lt8912_bridge_attach,
 	.detach = lt8912_bridge_detach,
+	.mode_valid = lt8912_bridge_mode_valid,
 	.mode_set = lt8912_bridge_mode_set,
 	.enable = lt8912_bridge_enable,
 	.detect = lt8912_bridge_detect,
-- 
2.43.0



