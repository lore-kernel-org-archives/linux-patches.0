Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BC0343893;
	Sat, 12 Sep 2026 09:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205936; cv=none; b=Ge9BY6yKxRmoGi9NzVFbhsP0+QuvDP2XLP68upLiOmfMie5mLmgCEzM0xr6fYo+/KaOfCtABPF+S2VEPRcrStwcGO+QP7JHgHCyaMlN1C6EfuMsnVn5B+jW4U4ugxYYHrSd3VTCqI/bEwHh0dQQnsqFCa6vC0gm/O8O8wBLBFK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205936; c=relaxed/simple;
	bh=Vi90xkVlH9ncRPqtZ+E+CwuyH/tMO1dS69NvEw5kNgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLiI47iVLAiIl1sNqImhbQV3rZWd1QJd+fAYmi7Dzlummkvc27lx3TaiOjSh4hunx3w6WSCLRS7CX4fDTw97VyJEPV2FKqOfUHF9aiZMusqj12GfBhG9FdRZg/STSoyrHE1UI9Z/bkb4YsoSSH1YknTpA5SSpRqUXg+08f11d8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0n/o9HX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0n/o9HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2121F000FF;
	Sat, 12 Sep 2026 09:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205935;
	bh=XFxdqkvGyee3mUqYuhQF2BY35s1wYSSYPHObqdhG9z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0n/o9HXyL2x4WGpLDk39itF25irUS3zGbXVO/shuQPYQYfBMqI5XhQ7ZNj4JWawn
	 nfbB8uGxmdNblVXRgrhpLWUXsjgMFN+dSt8fbTrzet7lwq/9dRmo6oOIZjiSn7fzv1
	 8mUcldxuy/VFeTlHJRJ3sZaBLzQcO5ManhZo6nPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0104/1518] drm/bridge: display-connector: dont autoenable HPD IRQ
Date: Sat, 12 Sep 2026 08:37:53 +0200
Message-ID: <20260912065625.833547588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 8e9c475060bff87077cfa3bd42011edcb7fb3b0d ]

If HPD IRQ is enabled in the display_connector's probe, it can be
triggered too early, before the DRM connector is completely setup. Use
the enable_hpd / disable_hpd callbacks to control enablement of the HPD
IRQ.

Fixes: 0c275c30176b ("drm/bridge: Add bridge driver for display connectors")
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260528-dp-connector-hpd-v3-2-d656eb1079b7@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/display-connector.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/bridge/display-connector.c b/drivers/gpu/drm/bridge/display-connector.c
index 9a64fefbc903c..8b7b2036010c8 100644
--- a/drivers/gpu/drm/bridge/display-connector.c
+++ b/drivers/gpu/drm/bridge/display-connector.c
@@ -94,6 +94,20 @@ display_connector_bridge_detect(struct drm_bridge *bridge, struct drm_connector
 	return display_connector_detect(bridge);
 }
 
+static void display_connector_hpd_enable(struct drm_bridge *bridge)
+{
+	struct display_connector *conn = to_display_connector(bridge);
+
+	enable_irq(conn->hpd_irq);
+}
+
+static void display_connector_hpd_disable(struct drm_bridge *bridge)
+{
+	struct display_connector *conn = to_display_connector(bridge);
+
+	disable_irq(conn->hpd_irq);
+}
+
 static const struct drm_edid *display_connector_edid_read(struct drm_bridge *bridge,
 							  struct drm_connector *connector)
 {
@@ -186,6 +200,8 @@ static const struct drm_bridge_funcs display_connector_bridge_funcs = {
 	.attach = display_connector_attach,
 	.destroy = display_connector_destroy,
 	.detect = display_connector_bridge_detect,
+	.hpd_enable = display_connector_hpd_enable,
+	.hpd_disable = display_connector_hpd_disable,
 	.edid_read = display_connector_edid_read,
 	.atomic_get_output_bus_fmts = display_connector_get_output_bus_fmts,
 	.atomic_get_input_bus_fmts = display_connector_get_input_bus_fmts,
@@ -315,6 +331,7 @@ static int display_connector_probe(struct platform_device *pdev)
 						NULL, display_connector_hpd_irq,
 						IRQF_TRIGGER_RISING |
 						IRQF_TRIGGER_FALLING |
+						IRQF_NO_AUTOEN |
 						IRQF_ONESHOT,
 						"HPD", conn);
 		if (ret) {
-- 
2.53.0



