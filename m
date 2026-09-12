Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9912E41D10B;
	Sat, 12 Sep 2026 09:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205942; cv=none; b=eWH8IhQYwoZ/TKXiYH7yFoCoLPgOO5eIrAKftENqQboSOGThvaGn62e4LT6hcqAi+2e7SzG7bE+Z5xuZkLIV2xg6YfqUWp1nFH5GKsxPH5gzfELmD7zBgFzyUlbaE1UotO8/SfZO/Gm/sqiX3ils7JdWC7Ys8EyhMJdeM7ddM8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205942; c=relaxed/simple;
	bh=UptTbTj4faT9lsakbkOKmhnf0p7K5vEnUULqyI+//G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIhkshVedqr15K3jIPRBuOSRxG2G4zJ3IzdYFPsNJ64S+8NqB+C7P7N/7LUzpWg2cXQflqaDHirFhxzTC7ROuO9xcjI9lMTFsHqAog0cFNBHDiRQ7F1P0/R+YTdBnkIHI0e64JL9wQcavTJF7lDjLRKM6sVDtdbM5VdmGzDF5KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSc7aDE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSc7aDE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFFF1F000FF;
	Sat, 12 Sep 2026 09:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205940;
	bh=UEx99OCmJurCKuH0okL6QX8L1fjrSNUZDbpl+2X7UFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSc7aDE2ZK+gbVCuhwvFHUf5MU2lhTuIpOybLm3kiGV5/8n6PosAXRiYu1AUUJBZE
	 M1qehCjINpvUYoyvTINb2u0jPCs6cBpBlEz9Yety450WlkR2OmGroCmtueA6n92RvM
	 HemsvXu5+JzV9BW2Th0SzY5WZUs6QfzZT6kEfbEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongxing Mou <yongxing.mou@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0105/1518] drm/bridge: display-connector: trigger initial HPD event for DP
Date: Sat, 12 Sep 2026 08:37:54 +0200
Message-ID: <20260912065625.855518185@linuxfoundation.org>
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

[ Upstream commit 60dc0946bbad3eef8bc66a5a8b09b98dbc6e09c0 ]

If the DisplayPort drivers use display-connector for the HPD detection,
the internal HPD state machine might be not active and thus the hardware
might be not able to handle cable detection correctly. Instead it will
depend on the external HPD notifications to set the cable state,
bypassing the internal HPD state machine (for example this is the case
for the msm DP driver).

However if the cable has been plugged before the HPD IRQ has been
enabled, there will be no HPD event coming. The drivers might fail
detection in such a case. Trigger the HPD notification after enabling
the HPD IRQ, propagating the cable insertion state.

Note, this issue only affects drivers which set OP_HPD but not OP_DETECT
(like dp-connector). Here DP differs from HDMI. For HDMI there is no
additional state or extra "bridge with no sinks plugged" cases. The HPD
pin state is equal to the display plugged state. Nor do we have an AUX
bus with timeouts, etc.

Fixes: 2e2bf3a5584d ("drm/bridge: display-connector: add DP support")
Reported-by: Yongxing Mou <yongxing.mou@oss.qualcomm.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://patch.msgid.link/20260528-dp-connector-hpd-v3-3-d656eb1079b7@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/display-connector.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/bridge/display-connector.c b/drivers/gpu/drm/bridge/display-connector.c
index 8b7b2036010c8..ba1d41816f3ec 100644
--- a/drivers/gpu/drm/bridge/display-connector.c
+++ b/drivers/gpu/drm/bridge/display-connector.c
@@ -12,6 +12,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
+#include <linux/workqueue.h>
 
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_bridge.h>
@@ -25,6 +26,8 @@ struct display_connector {
 
 	struct regulator	*supply;
 	struct gpio_desc	*ddc_en;
+
+	struct work_struct	hpd_work;
 };
 
 static inline struct display_connector *
@@ -99,15 +102,29 @@ static void display_connector_hpd_enable(struct drm_bridge *bridge)
 	struct display_connector *conn = to_display_connector(bridge);
 
 	enable_irq(conn->hpd_irq);
+
+	if (conn->bridge.type == DRM_MODE_CONNECTOR_DisplayPort)
+		schedule_work(&conn->hpd_work);
 }
 
 static void display_connector_hpd_disable(struct drm_bridge *bridge)
 {
 	struct display_connector *conn = to_display_connector(bridge);
 
+	if (conn->bridge.type == DRM_MODE_CONNECTOR_DisplayPort)
+		cancel_work_sync(&conn->hpd_work);
+
 	disable_irq(conn->hpd_irq);
 }
 
+static void display_connector_hpd_work(struct work_struct *work)
+{
+	struct display_connector *conn = container_of(work, struct display_connector, hpd_work);
+	struct drm_bridge *bridge = &conn->bridge;
+
+	drm_bridge_hpd_notify(bridge, display_connector_detect(bridge));
+}
+
 static const struct drm_edid *display_connector_edid_read(struct drm_bridge *bridge,
 							  struct drm_connector *connector)
 {
@@ -403,6 +420,8 @@ static int display_connector_probe(struct platform_device *pdev)
 		conn->bridge.ops |= DRM_BRIDGE_OP_DETECT;
 	if (conn->hpd_irq >= 0)
 		conn->bridge.ops |= DRM_BRIDGE_OP_HPD;
+	if (conn->hpd_irq >= 0 && type == DRM_MODE_CONNECTOR_DisplayPort)
+		INIT_WORK(&conn->hpd_work, display_connector_hpd_work);
 
 	dev_dbg(&pdev->dev,
 		"Found %s display connector '%s' %s DDC bus and %s HPD GPIO (ops 0x%x)\n",
-- 
2.53.0



