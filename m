Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288BF233731;
	Mon, 10 Mar 2025 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630514; cv=none; b=n6uWLiojlaebmD36dhbWpOX8RToO754RN9jR6EIPIS2wqaQL99nORgNVgXyv7kTppNCdNepFz9Ftd3yfB1wz9azW6fr4t2K9AI52mDnqiLvJfZUZXuy55QKIJ+ClfQL0ru13Ws5s/MPA3FKUVo4dBlKfS3B7NLBHvrZoM10bwkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630514; c=relaxed/simple;
	bh=qPb53tR3hvKanFtb93buM6wslZtw8yOstPsD4pkxZhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PW6n+ztzNPNZjmNmz04CCSVyh+gdHtDe/I0soW57ygvSJaCsm1AD+4Z5G9DpZT5sq/DjdQMofTmvzwAGBF26GIBftRqi1okVmhO+Y5qvoF0ohmAkYoBeKC/uS/Flin8Jvl4DBqfcNoUvfRqMssbA3VMugNqP0U65zVS7vnZuVZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jj1E3Vd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jj1E3Vd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10ADC4CEE5;
	Mon, 10 Mar 2025 18:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630514;
	bh=qPb53tR3hvKanFtb93buM6wslZtw8yOstPsD4pkxZhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jj1E3Vd/OT2yCRGPKvSOv+bwbPXVJ7YutLyTyNcl3o+oOej+VogBvqs9o2T0pDQVh
	 HbB8sbCQ+xX1MIR0w6sosKXdlhOlOo30e8UES+w8P1BH/2ay2EhHs0WNoid8PFXYJD
	 DlQk/e8nHI2rl0MMMx5c1fQxOieS33bRcFFesSuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <maxime@cerno.tech>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/620] drm/probe-helper: Create a HPD IRQ event helper for a single connector
Date: Mon, 10 Mar 2025 18:04:46 +0100
Message-ID: <20250310170602.967142262@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 0464ed1a79b818d5e3eda1ac3c23a057ac0cc7c3 ]

The drm_helper_hpd_irq_event() function is iterating over all the
connectors when an hotplug event is detected.

During that iteration, it will call each connector detect function and
figure out if its status changed.

Finally, if any connector changed, it will notify the user-space and the
clients that something changed on the DRM device.

This is supposed to be used for drivers that don't have a hotplug
interrupt for individual connectors. However, drivers that can use an
interrupt for a single connector are left in the dust and can either
reimplement the logic used during the iteration for each connector or
use that helper and iterate over all connectors all the time.

Since both are suboptimal, let's create a helper that will only perform
the status detection on a single connector.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210914101724.266570-2-maxime@cerno.tech
Stable-dep-of: 666e19604641 ("drm/rockchip: cdn-dp: Use drm_connector_helper_hpd_irq_event()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_probe_helper.c | 116 +++++++++++++++++++++--------
 include/drm/drm_probe_helper.h     |   1 +
 2 files changed, 86 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
index e79bb93072dd8..6776652ab1047 100644
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -805,6 +805,86 @@ void drm_kms_helper_poll_fini(struct drm_device *dev)
 }
 EXPORT_SYMBOL(drm_kms_helper_poll_fini);
 
+static bool check_connector_changed(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	enum drm_connector_status old_status;
+	u64 old_epoch_counter;
+
+	/* Only handle HPD capable connectors. */
+	drm_WARN_ON(dev, !(connector->polled & DRM_CONNECTOR_POLL_HPD));
+
+	drm_WARN_ON(dev, !mutex_is_locked(&dev->mode_config.mutex));
+
+	old_status = connector->status;
+	old_epoch_counter = connector->epoch_counter;
+	connector->status = drm_helper_probe_detect(connector, NULL, false);
+
+	if (old_epoch_counter == connector->epoch_counter) {
+		drm_dbg_kms(dev, "[CONNECTOR:%d:%s] Same epoch counter %llu\n",
+			    connector->base.id,
+			    connector->name,
+			    connector->epoch_counter);
+
+		return false;
+	}
+
+	drm_dbg_kms(dev, "[CONNECTOR:%d:%s] status updated from %s to %s\n",
+		    connector->base.id,
+		    connector->name,
+		    drm_get_connector_status_name(old_status),
+		    drm_get_connector_status_name(connector->status));
+
+	drm_dbg_kms(dev, "[CONNECTOR:%d:%s] Changed epoch counter %llu => %llu\n",
+		    connector->base.id,
+		    connector->name,
+		    old_epoch_counter,
+		    connector->epoch_counter);
+
+	return true;
+}
+
+/**
+ * drm_connector_helper_hpd_irq_event - hotplug processing
+ * @connector: drm_connector
+ *
+ * Drivers can use this helper function to run a detect cycle on a connector
+ * which has the DRM_CONNECTOR_POLL_HPD flag set in its &polled member.
+ *
+ * This helper function is useful for drivers which can track hotplug
+ * interrupts for a single connector. Drivers that want to send a
+ * hotplug event for all connectors or can't track hotplug interrupts
+ * per connector need to use drm_helper_hpd_irq_event().
+ *
+ * This function must be called from process context with no mode
+ * setting locks held.
+ *
+ * Note that a connector can be both polled and probed from the hotplug
+ * handler, in case the hotplug interrupt is known to be unreliable.
+ *
+ * Returns:
+ * A boolean indicating whether the connector status changed or not
+ */
+bool drm_connector_helper_hpd_irq_event(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	bool changed;
+
+	mutex_lock(&dev->mode_config.mutex);
+	changed = check_connector_changed(connector);
+	mutex_unlock(&dev->mode_config.mutex);
+
+	if (changed) {
+		drm_kms_helper_hotplug_event(dev);
+		drm_dbg_kms(dev, "[CONNECTOR:%d:%s] Sent hotplug event\n",
+			    connector->base.id,
+			    connector->name);
+	}
+
+	return changed;
+}
+EXPORT_SYMBOL(drm_connector_helper_hpd_irq_event);
+
 /**
  * drm_helper_hpd_irq_event - hotplug processing
  * @dev: drm_device
@@ -818,9 +898,10 @@ EXPORT_SYMBOL(drm_kms_helper_poll_fini);
  * interrupts for each connector.
  *
  * Drivers which support hotplug interrupts for each connector individually and
- * which have a more fine-grained detect logic should bypass this code and
- * directly call drm_kms_helper_hotplug_event() in case the connector state
- * changed.
+ * which have a more fine-grained detect logic can use
+ * drm_connector_helper_hpd_irq_event(). Alternatively, they should bypass this
+ * code and directly call drm_kms_helper_hotplug_event() in case the connector
+ * state changed.
  *
  * This function must be called from process context with no mode
  * setting locks held.
@@ -832,9 +913,7 @@ bool drm_helper_hpd_irq_event(struct drm_device *dev)
 {
 	struct drm_connector *connector;
 	struct drm_connector_list_iter conn_iter;
-	enum drm_connector_status old_status;
 	bool changed = false;
-	u64 old_epoch_counter;
 
 	if (!dev->mode_config.poll_enabled)
 		return false;
@@ -846,33 +925,8 @@ bool drm_helper_hpd_irq_event(struct drm_device *dev)
 		if (!(connector->polled & DRM_CONNECTOR_POLL_HPD))
 			continue;
 
-		old_status = connector->status;
-
-		old_epoch_counter = connector->epoch_counter;
-
-		DRM_DEBUG_KMS("[CONNECTOR:%d:%s] Old epoch counter %llu\n", connector->base.id,
-			      connector->name,
-			      old_epoch_counter);
-
-		connector->status = drm_helper_probe_detect(connector, NULL, false);
-		DRM_DEBUG_KMS("[CONNECTOR:%d:%s] status updated from %s to %s\n",
-			      connector->base.id,
-			      connector->name,
-			      drm_get_connector_status_name(old_status),
-			      drm_get_connector_status_name(connector->status));
-
-		DRM_DEBUG_KMS("[CONNECTOR:%d:%s] New epoch counter %llu\n",
-			      connector->base.id,
-			      connector->name,
-			      connector->epoch_counter);
-
-		/*
-		 * Check if epoch counter had changed, meaning that we need
-		 * to send a uevent.
-		 */
-		if (old_epoch_counter != connector->epoch_counter)
+		if (check_connector_changed(connector))
 			changed = true;
-
 	}
 	drm_connector_list_iter_end(&conn_iter);
 	mutex_unlock(&dev->mode_config.mutex);
diff --git a/include/drm/drm_probe_helper.h b/include/drm/drm_probe_helper.h
index 8d3ed2834d345..04c57564c397d 100644
--- a/include/drm/drm_probe_helper.h
+++ b/include/drm/drm_probe_helper.h
@@ -18,6 +18,7 @@ int drm_helper_probe_detect(struct drm_connector *connector,
 void drm_kms_helper_poll_init(struct drm_device *dev);
 void drm_kms_helper_poll_fini(struct drm_device *dev);
 bool drm_helper_hpd_irq_event(struct drm_device *dev);
+bool drm_connector_helper_hpd_irq_event(struct drm_connector *connector);
 void drm_kms_helper_hotplug_event(struct drm_device *dev);
 
 void drm_kms_helper_poll_disable(struct drm_device *dev);
-- 
2.39.5



