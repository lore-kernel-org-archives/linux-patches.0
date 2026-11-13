Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591357;
	b=T8hsLA9KNgYlVvLk3uO78FR2BNtNoORmhmc3OfzDDbNPXHwVJyHokNfIoS96c6qiFCzf
	 SQHHInJiJLXAi3vTdtANOvgVpr2RsFlJ/pHS4eN2x6xESZ/CLS98hPfHe9iFy5e5S531y
	 aoPYXb35xAU1FXin5oqUWEYbb1CkdLq0IXsGKz4Xbu/BAQDBQc4YzhXPnXSYxXNQX0M1o
	 NpGH2R1LtAExAtcV4FzOJ1D9V9OsMho7yiRCvBHbG/7eqbleabg9i0RiCVlS8e3U5Ufog
	 1POavaYqWDeQh4iy2/5fz4oUHI0vgVXOrSysMbkGVDRVIgY0Er3Xhjrdo4QiB0216hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qi+ysH0jiNSI9PojvOXDRGozurb4jQ3MUwvoiLENTzA=;
	b=zoLvIaHEQvvR7MkDPrI1x3YMQwSvJ5YM7Kz8W9xPCq9LtMiAwBwN6MOXFmmdHnOgNx9i
	 XVLRPU8QGiZ7NrvUiNGCbygwotG3rFKK22B0dad1D6asxVyF3RGZeA2PaKwKbHIYC4t1l
	 5B35MKjUFU60V8BT4wpEjfg26ea5EWCQUs5hl6pm0Bm52vCrD5OuQ8icQoYxxdUz4mxeX
	 KTE3fxIIrx4KRDRAdpqe1ResmU5/qfmNh+DcIduMi+ZOy79+KQky8RgZZHcPa+HqfZOiI
	 HQ3htFdvBr24VSGnVirtgMzuS/aJNT6Tbp3OrXYv6Jx5x5QOmN98VHzhZCG7YcMokZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoxSap5V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C411A606B229;
	Fri, 13 Nov 2026 17:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoxSap5V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4498D1F000C5;
	Fri, 13 Nov 2026 17:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591357;
	bh=qi+ysH0jiNSI9PojvOXDRGozurb4jQ3MUwvoiLENTzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UoxSap5VNh96qbCCfC0mZVWVQYn16Giv9qYvv0dd9aJCc+LiEwKc4YfHcra4LUnTh
	 V0UvyfbAjmjLMIAqzsJDcNrxkZuJUWB+J5N6YuE2UeG1FPd+ydnk70mnDxpf3R+LzE
	 wwT/qN2D/mlzFKLvD/J/S8sYr6QldMXRMPeKD/iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Anusha Srivatsa <asrivats@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 462/670] drm/panel: Add new helpers for refcounted panel allocatons
Date: Fri, 13 Nov 2026 10:50:26 -0500
Message-ID: <20261113153827.616155163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anusha Srivatsa <asrivats@redhat.com>

[ Upstream commit ed9c594d495deb676825489032cee0a03ce29bf9 ]

Introduce reference counted allocations for panels to avoid
use-after-free. The patch adds the macro devm_drm_bridge_alloc()
to allocate a new refcounted panel. Followed the documentation for
drmm_encoder_alloc() and devm_drm_dev_alloc and other similar
implementations for this purpose.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Anusha Srivatsa <asrivats@redhat.com>
Link: https://lore.kernel.org/r/20250331-b4-panel-refcounting-v4-1-dad50c60c6c9@redhat.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Stable-dep-of: 4eeeac9d7c36 ("drm/panel: ebbg-ft8719: Set prepare_prev_first")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel.c | 25 +++++++++++++++++++++++++
 include/drm/drm_panel.h     | 22 ++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index fd8fa2e0ef6fa..4d45b61e9a93a 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -354,6 +354,31 @@ struct drm_panel *of_drm_find_panel(const struct device_node *np)
 }
 EXPORT_SYMBOL(of_drm_find_panel);
 
+void *__devm_drm_panel_alloc(struct device *dev, size_t size, size_t offset,
+			     const struct drm_panel_funcs *funcs,
+			     int connector_type)
+{
+	void *container;
+	struct drm_panel *panel;
+
+	if (!funcs) {
+		dev_warn(dev, "Missing funcs pointer\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	container = devm_kzalloc(dev, size, GFP_KERNEL);
+	if (!container)
+		return ERR_PTR(-ENOMEM);
+
+	panel = container + offset;
+	panel->funcs = funcs;
+
+	drm_panel_init(panel, dev, funcs, connector_type);
+
+	return container;
+}
+EXPORT_SYMBOL(__devm_drm_panel_alloc);
+
 /**
  * of_drm_get_panel_orientation - look up the orientation of the panel through
  * the "rotation" binding from a device tree node
diff --git a/include/drm/drm_panel.h b/include/drm/drm_panel.h
index 10015891b056f..daaa259ef898f 100644
--- a/include/drm/drm_panel.h
+++ b/include/drm/drm_panel.h
@@ -269,6 +269,28 @@ struct drm_panel {
 	bool enabled;
 };
 
+void *__devm_drm_panel_alloc(struct device *dev, size_t size, size_t offset,
+			     const struct drm_panel_funcs *funcs,
+			     int connector_type);
+
+/**
+ * devm_drm_panel_alloc - Allocate and initialize a refcounted panel.
+ *
+ * @dev: struct device of the panel device
+ * @type: the type of the struct which contains struct &drm_panel
+ * @member: the name of the &drm_panel within @type
+ * @funcs: callbacks for this panel
+ * @connector_type: the connector type (DRM_MODE_CONNECTOR_*) corresponding to
+ * the panel interface
+ *
+ * Returns:
+ * Pointer to container structure embedding the panel, ERR_PTR on failure.
+ */
+#define devm_drm_panel_alloc(dev, type, member, funcs, connector_type) \
+	((type *)__devm_drm_panel_alloc(dev, sizeof(type), \
+					offsetof(type, member), funcs, \
+					connector_type))
+
 void drm_panel_init(struct drm_panel *panel, struct device *dev,
 		    const struct drm_panel_funcs *funcs,
 		    int connector_type);
-- 
2.53.0



