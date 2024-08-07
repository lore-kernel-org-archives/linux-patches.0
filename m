Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43997F7F5;
	Wed,  7 Aug 2024 15:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043677; cv=none; b=WKbm16BBY4wRZsiMRALu53NqvGLUQ/ZylcLB7oncqMuPssmWKnSl3o8+kC3pX3sZkn1eMWKeLvexpasycCfybbZVvpUWFyR3ouS70DxbLvHPUY83nwRk1ASJ4+i8mqsDTklwcaaWBFkvkJDO38bIGqk5/4R84fYANvgTGn1NPWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043677; c=relaxed/simple;
	bh=IXfqJYruQXZZHt5fEry3XMQn/BKYSH7aahegucauQqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOitE7KYyXgEcMvTmHQCI3aZ+zVWF9A3j38FvzxXjecAARTeAATpSCo1OY0TMR/DJnv1SRKypvn6n52Btw7E6JKRZGu9e1Kz+Ujqs1psuZuyii+35bTOHArqv0UOZCXSGfwV1dlPUhXe44GSthcLMCRzI0r5dFqn8rfaQigeu2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iBYDKNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iBYDKNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760BEC4AF0D;
	Wed,  7 Aug 2024 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043676;
	bh=IXfqJYruQXZZHt5fEry3XMQn/BKYSH7aahegucauQqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iBYDKNVmCOtlcSTI+H8gX3KcE9iw6Yh14eLdVHgkuf6TLTWoWHNsx/xqBf3rj2lS
	 pnjtGCRzMKWDHLsdauZosFrFCexwHpuBDxERGbKFjJtF4bqB95yj/Bi4/AH2QZOGPI
	 OcJ+nUy8JouTkjZfxhRlyKyBOAoO5oroSWvw2uYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/86] drm/udl: Move connector to modesetting code
Date: Wed,  7 Aug 2024 17:00:10 +0200
Message-ID: <20240807150040.264845348@linuxfoundation.org>
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

[ Upstream commit 0862cfd3e22f3f936927f2f7381c2519ba034c6e ]

Move the connector next to the rest of the modesetting code. No
functional changes.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221006095355.23579-6-tzimmermann@suse.de
Stable-dep-of: 5aed213c7c6c ("drm/udl: Remove DRM_CONNECTOR_POLL_HPD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/Makefile        |   2 +-
 drivers/gpu/drm/udl/udl_connector.c | 132 ----------------------------
 drivers/gpu/drm/udl/udl_connector.h |  21 -----
 drivers/gpu/drm/udl/udl_drv.h       |  11 +++
 drivers/gpu/drm/udl/udl_modeset.c   | 122 +++++++++++++++++++++++++
 5 files changed, 134 insertions(+), 154 deletions(-)
 delete mode 100644 drivers/gpu/drm/udl/udl_connector.c
 delete mode 100644 drivers/gpu/drm/udl/udl_connector.h

diff --git a/drivers/gpu/drm/udl/Makefile b/drivers/gpu/drm/udl/Makefile
index 24d61f61d7db2..3f6db179455d1 100644
--- a/drivers/gpu/drm/udl/Makefile
+++ b/drivers/gpu/drm/udl/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-udl-y := udl_drv.o udl_modeset.o udl_connector.o udl_main.o udl_transfer.o
+udl-y := udl_drv.o udl_modeset.o udl_main.o udl_transfer.o
 
 obj-$(CONFIG_DRM_UDL) := udl.o
diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
deleted file mode 100644
index 538b47ffa67fa..0000000000000
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ /dev/null
@@ -1,132 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2012 Red Hat
- * based in parts on udlfb.c:
- * Copyright (C) 2009 Roberto De Ioris <roberto@unbit.it>
- * Copyright (C) 2009 Jaya Kumar <jayakumar.lkml@gmail.com>
- * Copyright (C) 2009 Bernie Thompson <bernie@plugable.com>
- */
-
-#include <drm/drm_atomic_state_helper.h>
-#include <drm/drm_edid.h>
-#include <drm/drm_crtc_helper.h>
-#include <drm/drm_probe_helper.h>
-
-#include "udl_connector.h"
-#include "udl_drv.h"
-
-static int udl_get_edid_block(void *data, u8 *buf, unsigned int block, size_t len)
-{
-	struct udl_device *udl = data;
-	struct drm_device *dev = &udl->drm;
-	struct usb_device *udev = udl_to_usb_device(udl);
-	u8 *read_buff;
-	int ret;
-	size_t i;
-
-	read_buff = kmalloc(2, GFP_KERNEL);
-	if (!read_buff)
-		return -ENOMEM;
-
-	for (i = 0; i < len; i++) {
-		int bval = (i + block * EDID_LENGTH) << 8;
-
-		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-				      0x02, (0x80 | (0x02 << 5)), bval,
-				      0xA1, read_buff, 2, USB_CTRL_GET_TIMEOUT);
-		if (ret < 0) {
-			drm_err(dev, "Read EDID byte %zu failed err %x\n", i, ret);
-			goto err_kfree;
-		} else if (ret < 1) {
-			ret = -EIO;
-			drm_err(dev, "Read EDID byte %zu failed\n", i);
-			goto err_kfree;
-		}
-
-		buf[i] = read_buff[1];
-	}
-
-	kfree(read_buff);
-
-	return 0;
-
-err_kfree:
-	kfree(read_buff);
-	return ret;
-}
-
-static int udl_connector_helper_get_modes(struct drm_connector *connector)
-{
-	struct udl_connector *udl_connector = to_udl_connector(connector);
-
-	drm_connector_update_edid_property(connector, udl_connector->edid);
-	if (udl_connector->edid)
-		return drm_add_edid_modes(connector, udl_connector->edid);
-
-	return 0;
-}
-
-static enum drm_connector_status udl_connector_detect(struct drm_connector *connector, bool force)
-{
-	struct udl_device *udl = to_udl(connector->dev);
-	struct udl_connector *udl_connector = to_udl_connector(connector);
-
-	/* cleanup previous EDID */
-	kfree(udl_connector->edid);
-
-	udl_connector->edid = drm_do_get_edid(connector, udl_get_edid_block, udl);
-	if (!udl_connector->edid)
-		return connector_status_disconnected;
-
-	return connector_status_connected;
-}
-
-static void udl_connector_destroy(struct drm_connector *connector)
-{
-	struct udl_connector *udl_connector = to_udl_connector(connector);
-
-	drm_connector_cleanup(connector);
-	kfree(udl_connector->edid);
-	kfree(udl_connector);
-}
-
-static const struct drm_connector_helper_funcs udl_connector_helper_funcs = {
-	.get_modes = udl_connector_helper_get_modes,
-};
-
-static const struct drm_connector_funcs udl_connector_funcs = {
-	.reset = drm_atomic_helper_connector_reset,
-	.detect = udl_connector_detect,
-	.fill_modes = drm_helper_probe_single_connector_modes,
-	.destroy = udl_connector_destroy,
-	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
-	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
-};
-
-struct drm_connector *udl_connector_init(struct drm_device *dev)
-{
-	struct udl_connector *udl_connector;
-	struct drm_connector *connector;
-	int ret;
-
-	udl_connector = kzalloc(sizeof(*udl_connector), GFP_KERNEL);
-	if (!udl_connector)
-		return ERR_PTR(-ENOMEM);
-
-	connector = &udl_connector->connector;
-	ret = drm_connector_init(dev, connector, &udl_connector_funcs, DRM_MODE_CONNECTOR_VGA);
-	if (ret)
-		goto err_kfree;
-
-	drm_connector_helper_add(connector, &udl_connector_helper_funcs);
-
-	connector->polled = DRM_CONNECTOR_POLL_HPD |
-			    DRM_CONNECTOR_POLL_CONNECT |
-			    DRM_CONNECTOR_POLL_DISCONNECT;
-
-	return connector;
-
-err_kfree:
-	kfree(udl_connector);
-	return ERR_PTR(ret);
-}
diff --git a/drivers/gpu/drm/udl/udl_connector.h b/drivers/gpu/drm/udl/udl_connector.h
deleted file mode 100644
index 74ad68fd3cc9f..0000000000000
--- a/drivers/gpu/drm/udl/udl_connector.h
+++ /dev/null
@@ -1,21 +0,0 @@
-#ifndef __UDL_CONNECTOR_H__
-#define __UDL_CONNECTOR_H__
-
-#include <linux/container_of.h>
-
-#include <drm/drm_connector.h>
-
-struct edid;
-
-struct udl_connector {
-	struct drm_connector connector;
-	/* last udl_detect edid */
-	struct edid *edid;
-};
-
-static inline struct udl_connector *to_udl_connector(struct drm_connector *connector)
-{
-	return container_of(connector, struct udl_connector, connector);
-}
-
-#endif //__UDL_CONNECTOR_H__
diff --git a/drivers/gpu/drm/udl/udl_drv.h b/drivers/gpu/drm/udl/udl_drv.h
index b4cc7cc568c74..d7a3d495f2e7e 100644
--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -46,6 +46,17 @@ struct urb_list {
 	size_t size;
 };
 
+struct udl_connector {
+	struct drm_connector connector;
+	/* last udl_detect edid */
+	struct edid *edid;
+};
+
+static inline struct udl_connector *to_udl_connector(struct drm_connector *connector)
+{
+	return container_of(connector, struct udl_connector, connector);
+}
+
 struct udl_device {
 	struct drm_device drm;
 	struct device *dev;
diff --git a/drivers/gpu/drm/udl/udl_modeset.c b/drivers/gpu/drm/udl/udl_modeset.c
index c7adc29a53a18..93e7554e83fa3 100644
--- a/drivers/gpu/drm/udl/udl_modeset.c
+++ b/drivers/gpu/drm/udl/udl_modeset.c
@@ -11,11 +11,13 @@
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_damage_helper.h>
+#include <drm/drm_edid.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_gem_shmem_helper.h>
 #include <drm/drm_modeset_helper_vtables.h>
+#include <drm/drm_probe_helper.h>
 #include <drm/drm_vblank.h>
 
 #include "udl_drv.h"
@@ -403,6 +405,126 @@ static const struct drm_simple_display_pipe_funcs udl_simple_display_pipe_funcs
 	DRM_GEM_SIMPLE_DISPLAY_PIPE_SHADOW_PLANE_FUNCS,
 };
 
+/*
+ * Connector
+ */
+
+static int udl_connector_helper_get_modes(struct drm_connector *connector)
+{
+	struct udl_connector *udl_connector = to_udl_connector(connector);
+
+	drm_connector_update_edid_property(connector, udl_connector->edid);
+	if (udl_connector->edid)
+		return drm_add_edid_modes(connector, udl_connector->edid);
+
+	return 0;
+}
+
+static const struct drm_connector_helper_funcs udl_connector_helper_funcs = {
+	.get_modes = udl_connector_helper_get_modes,
+};
+
+static int udl_get_edid_block(void *data, u8 *buf, unsigned int block, size_t len)
+{
+	struct udl_device *udl = data;
+	struct drm_device *dev = &udl->drm;
+	struct usb_device *udev = udl_to_usb_device(udl);
+	u8 *read_buff;
+	int ret;
+	size_t i;
+
+	read_buff = kmalloc(2, GFP_KERNEL);
+	if (!read_buff)
+		return -ENOMEM;
+
+	for (i = 0; i < len; i++) {
+		int bval = (i + block * EDID_LENGTH) << 8;
+
+		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+				      0x02, (0x80 | (0x02 << 5)), bval,
+				      0xA1, read_buff, 2, USB_CTRL_GET_TIMEOUT);
+		if (ret < 0) {
+			drm_err(dev, "Read EDID byte %zu failed err %x\n", i, ret);
+			goto err_kfree;
+		} else if (ret < 1) {
+			ret = -EIO;
+			drm_err(dev, "Read EDID byte %zu failed\n", i);
+			goto err_kfree;
+		}
+
+		buf[i] = read_buff[1];
+	}
+
+	kfree(read_buff);
+
+	return 0;
+
+err_kfree:
+	kfree(read_buff);
+	return ret;
+}
+
+static enum drm_connector_status udl_connector_detect(struct drm_connector *connector, bool force)
+{
+	struct udl_device *udl = to_udl(connector->dev);
+	struct udl_connector *udl_connector = to_udl_connector(connector);
+
+	/* cleanup previous EDID */
+	kfree(udl_connector->edid);
+
+	udl_connector->edid = drm_do_get_edid(connector, udl_get_edid_block, udl);
+	if (!udl_connector->edid)
+		return connector_status_disconnected;
+
+	return connector_status_connected;
+}
+
+static void udl_connector_destroy(struct drm_connector *connector)
+{
+	struct udl_connector *udl_connector = to_udl_connector(connector);
+
+	drm_connector_cleanup(connector);
+	kfree(udl_connector->edid);
+	kfree(udl_connector);
+}
+
+static const struct drm_connector_funcs udl_connector_funcs = {
+	.reset = drm_atomic_helper_connector_reset,
+	.detect = udl_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = udl_connector_destroy,
+	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
+	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
+};
+
+struct drm_connector *udl_connector_init(struct drm_device *dev)
+{
+	struct udl_connector *udl_connector;
+	struct drm_connector *connector;
+	int ret;
+
+	udl_connector = kzalloc(sizeof(*udl_connector), GFP_KERNEL);
+	if (!udl_connector)
+		return ERR_PTR(-ENOMEM);
+
+	connector = &udl_connector->connector;
+	ret = drm_connector_init(dev, connector, &udl_connector_funcs, DRM_MODE_CONNECTOR_VGA);
+	if (ret)
+		goto err_kfree;
+
+	drm_connector_helper_add(connector, &udl_connector_helper_funcs);
+
+	connector->polled = DRM_CONNECTOR_POLL_HPD |
+			    DRM_CONNECTOR_POLL_CONNECT |
+			    DRM_CONNECTOR_POLL_DISCONNECT;
+
+	return connector;
+
+err_kfree:
+	kfree(udl_connector);
+	return ERR_PTR(ret);
+}
+
 /*
  * Modesetting
  */
-- 
2.43.0



