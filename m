Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3F63B813A;
	Sat, 12 Sep 2026 07:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196964; cv=none; b=dHh5Ropz7+hup189T82PiDOIVTNQICQArVcZruDCDgN/tl4wAsJ/54icAuD2OXTZULraf5DgxQ1/y8NH+jxj5m1iMH3eRkVjE10JXH7pUF8X/bosYjBfu4OAwx3BxAcTxx6oDLbnwPkWBWq7C6wm72KkuAbcHipsPCYqYOfLTsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196964; c=relaxed/simple;
	bh=vman/CPvD2DOIUq0MogBG2rG8MCOc31mGpDHVAf6nWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+SY1wkoVKoKsSrIccKdDTa2Xnp5uyTX9kMGNmOHhqz0svURAKe0z83DdfFMYaOR6MViH3m+gsQEf8hXe28Q11yyLoUN+Q0ZVHXCFb60FQNoGkonRxXw0yY7OmnT4hueWjrtRV8+WUIWmEWOfje4HDtMiLjTQoiqpjnjHKVffJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcIXgh7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcIXgh7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B001F000FF;
	Sat, 12 Sep 2026 07:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196962;
	bh=h7GiI31v+raVSRtqOjp+EI+WJp4xMCQ3ho7ngqZPXEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OcIXgh7i2KnS+6YqbJoECEuxaJ6hXUoDuTq887hiSHJVhl0A77PcDp5a7JjlXRI9E
	 swNisMGOtYDtoSK4rxMwYWajqjK+f9DsjOFn5jFVNDvJJXKzJLMS7sRzl1hINB9Nbq
	 XEgQ6ZfO514o0QiPquu0j1l+/ZVPSDrydXGSBfgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0046/1815] drm/bridge: display-connector: dont autoenable HPD IRQ
Date: Sat, 12 Sep 2026 08:29:56 +0200
Message-ID: <20260912065650.101002255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6b128fabe3a97..4567e402f2224 100644
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



