Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FBB46AA9D;
	Tue, 21 Jul 2026 15:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648446; cv=none; b=hdE5vCIA31qGIT3gxn4w1otfel7aAsEbcw4jNPVG8SR49HxmbX+Q7RpWUdeuh3dAXzD+uN+LrUuWC5vKHqqxOWvULv9hXPGks6ooNDgWyP+hhUDrJBfny15QizS+cU59l5ELKTnW0+f8S5PZ8bY4TmuzMt++ZWfTmdVDEy8BPpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648446; c=relaxed/simple;
	bh=D7cEoN8wJqzl5uYuoSIrDUOzOynr9ugBgH5MKFpw0fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEo+SV/BxQ0DGbEcO4plIweUVRjsgNoUJD6q/KmAgX9fyxOlxcZBJnk6cq5SPef6WGc0f5hwhy79iAQrCFA/UNxc+W8aHhafIYxofZiV6ymyc2hDfW+Eds/mCyZm3MxMVOkUYfpY8z2wJUX1/8LRwXJq1cV9PCWnY6V6G7gPYkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBHyj0/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBHyj0/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0834F1F000E9;
	Tue, 21 Jul 2026 15:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648444;
	bh=cKoDt9UMR13S53itP6w028BndZDUEq9G8vqd4RfwyMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBHyj0/qCiQfjOpPpKRefy/cBfI/oz/AiwSdpDcZ7Wrf9LeWcwFlksTuHPNznkwan
	 XiPHGtN8q/iJpzb11hQxCumhEf+a+UXG2UgLrAate+v14MU72uq5n454uIFmeKS+Fm
	 1X8x4nTRKLcIWRUIuVOnU5aw7Oc4dGkYjVt2tmyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lin He <helin52@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0202/2077] drm/hisilicon/hibmc: fix no showing when no connectors connected
Date: Tue, 21 Jul 2026 16:57:55 +0200
Message-ID: <20260721152557.446441105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin He <helin52@huawei.com>

[ Upstream commit 4110e29a7c384f1ff21d6b187b6a1772f6e17b23 ]

Our chip support KVM over IP feature, so hibmc driver need to support
displaying without any connectors plugged in. If no connectors are
connected, the vdac connector status should be set to 'connected' to
ensure proper KVM display functionality. Additionally, for
previous-generation products that may lack hardware link support and
thus cannot detect the monitor, the same approach should be applied
to ensure VGA display functionality.

* Add phys_state in the struct of dp and vdac to check physical outputs.

* The 'epoch_counter' of the vdac connector is incremented when the
physical status changes.

For get_modes: using BMC modes for connector if no display is attached to
phys VGA cable, otherwise use EDID modes by drm_connector_helper_get_modes,
because KVM doesn't provide EDID reads.

The polling mechanism for the KMS helper is enabled.

Fixes: 4c962bc929f1 ("drm/hisilicon/hibmc: Add vga connector detect functions")
Reported-by: Thomas Zimmermann <tzimmermann@suse.de>
Closes: https://lore.kernel.org/all/0eb5c509-2724-4c57-87ad-74e4270d5a5a@suse.de/
Signed-off-by: Lin He <helin52@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260509032302.2057227-3-shiyongbang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h    |  1 +
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c    | 33 ++++++++----
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c   |  3 ++
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h   |  1 +
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c  | 53 +++++++++++++------
 5 files changed, 64 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h
index 31316fe1ea8dbf..0f3662d8737e99 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h
@@ -55,6 +55,7 @@ struct hibmc_dp {
 	struct drm_dp_aux aux;
 	struct hibmc_dp_cbar_cfg cfg;
 	u32 irq_status;
+	int phys_status;
 };
 
 int hibmc_dp_hw_init(struct hibmc_dp *dp);
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
index 35dff7bfbf76f3..596c5bfe32d8e7 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
@@ -61,27 +61,38 @@ static int hibmc_dp_detect(struct drm_connector *connector,
 {
 	struct hibmc_dp *dp = to_hibmc_dp(connector);
 	struct hibmc_dp_dev *dp_dev = dp->dp_dev;
-	int ret;
+	int ret = connector_status_disconnected;
 
 	if (dp->irq_status) {
-		if (dp_dev->hpd_status != HIBMC_HPD_IN)
-			return connector_status_disconnected;
+		if (dp_dev->hpd_status != HIBMC_HPD_IN) {
+			ret = connector_status_disconnected;
+			goto exit;
+		}
 	}
 
-	if (!hibmc_dp_get_dpcd(dp_dev))
-		return connector_status_disconnected;
+	if (!hibmc_dp_get_dpcd(dp_dev)) {
+		ret = connector_status_disconnected;
+		goto exit;
+	}
 
-	if (!dp_dev->is_branch)
-		return connector_status_connected;
+	if (!dp_dev->is_branch) {
+		ret = connector_status_connected;
+		goto exit;
+	}
 
 	if (drm_dp_read_sink_count_cap(connector, dp_dev->dpcd, &dp_dev->desc) &&
 	    dp_dev->downstream_ports[0] & DP_DS_PORT_HPD) {
 		ret = drm_dp_read_sink_count(dp_dev->aux);
-		if (ret > 0)
-			return connector_status_connected;
+		if (ret > 0) {
+			ret = connector_status_connected;
+			goto exit;
+		}
 	}
 
-	return connector_status_disconnected;
+exit:
+	dp->phys_status = ret;
+
+	return ret;
 }
 
 static int hibmc_dp_mode_valid(struct drm_connector *connector,
@@ -243,5 +254,7 @@ int hibmc_dp_init(struct hibmc_drm_private *priv)
 
 	connector->polled = DRM_CONNECTOR_POLL_HPD;
 
+	dp->phys_status = connector_status_disconnected;
+
 	return 0;
 }
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
index 289304500ab097..481e5e62c30bf1 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -24,6 +24,7 @@
 #include <drm/drm_managed.h>
 #include <drm/drm_module.h>
 #include <drm/drm_vblank.h>
+#include <drm/drm_probe_helper.h>
 
 #include "hibmc_drm_drv.h"
 #include "hibmc_drm_regs.h"
@@ -355,6 +356,8 @@ static int hibmc_load(struct drm_device *dev)
 	/* reset all the states of crtc/plane/encoder/connector */
 	drm_mode_config_reset(dev);
 
+	drmm_kms_helper_poll_init(dev);
+
 	return 0;
 
 err:
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
index ca8502e2760c12..cd3a3fca1fe60a 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
@@ -31,6 +31,7 @@ struct hibmc_vdac {
 	struct drm_connector connector;
 	struct i2c_adapter adapter;
 	struct i2c_algo_bit_data bit_data;
+	int phys_status;
 };
 
 struct hibmc_drm_private {
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
index 841e81f47b6862..2fcfa3246fd124 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
@@ -24,28 +24,21 @@
 
 static int hibmc_connector_get_modes(struct drm_connector *connector)
 {
+	struct drm_mode_config *mode_config = &connector->dev->mode_config;
 	struct hibmc_vdac *vdac = to_hibmc_vdac(connector);
-	const struct drm_edid *drm_edid;
 	int count;
 
-	drm_edid = drm_edid_read_ddc(connector, &vdac->adapter);
-
-	drm_edid_connector_update(connector, drm_edid);
-
-	if (drm_edid) {
-		count = drm_edid_connector_add_modes(connector);
+	if (vdac->phys_status == connector_status_connected) {
+		count = drm_connector_helper_get_modes(connector);
+	} else {
+		drm_edid_connector_update(connector, NULL);
+		count = drm_add_modes_noedid(connector,
+					     mode_config->max_width,
+					     mode_config->max_height);
 		if (count)
-			goto out;
+			drm_set_preferred_mode(connector, 1024, 768);
 	}
 
-	count = drm_add_modes_noedid(connector,
-				     connector->dev->mode_config.max_width,
-				     connector->dev->mode_config.max_height);
-	drm_set_preferred_mode(connector, 1024, 768);
-
-out:
-	drm_edid_free(drm_edid);
-
 	return count;
 }
 
@@ -57,10 +50,34 @@ static void hibmc_connector_destroy(struct drm_connector *connector)
 	drm_connector_cleanup(connector);
 }
 
+static int hibmc_vdac_detect(struct drm_connector *connector,
+			     struct drm_modeset_acquire_ctx *ctx,
+			     bool force)
+{
+	struct hibmc_drm_private *priv = to_hibmc_drm_private(connector->dev);
+	int status = drm_connector_helper_detect_from_ddc(connector, ctx,
+							 force);
+	struct hibmc_vdac *vdac = to_hibmc_vdac(connector);
+
+	if (priv->dp.phys_status == connector_status_connected) {
+		vdac->phys_status = status;
+		return status;
+	}
+
+	if (status != vdac->phys_status)
+		++connector->epoch_counter;
+	vdac->phys_status = status;
+
+	/* When both the DP and VDAC physical status are disconnected,
+	 * the "connected" status is returned to support KVM display.
+	 */
+	return connector_status_connected;
+}
+
 static const struct drm_connector_helper_funcs
 	hibmc_connector_helper_funcs = {
 	.get_modes = hibmc_connector_get_modes,
-	.detect_ctx = drm_connector_helper_detect_from_ddc,
+	.detect_ctx = hibmc_vdac_detect,
 };
 
 static const struct drm_connector_funcs hibmc_connector_funcs = {
@@ -130,6 +147,8 @@ int hibmc_vdac_init(struct hibmc_drm_private *priv)
 
 	connector->polled = DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR_POLL_DISCONNECT;
 
+	vdac->phys_status = connector_status_disconnected;
+
 	return 0;
 
 err:
-- 
2.53.0



