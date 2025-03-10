Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1033E22D4C3;
	Mon, 10 Mar 2025 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627521; cv=none; b=OLcizsnIz+CyWFHAudI/fEyASn6vC+NLcgeWMniH2RMboqrfC19zmCNdSV6pkNAEQkKgfjoEvcFxes03VmX1r+Z1whlC/+qg24vrERnAOxQLSUnOnXIdZ1If9QgItR+Om3+0Sq64unykG4QYeTGY6nJsE7qTtwJxtf8iZ7PjoSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627521; c=relaxed/simple;
	bh=bQZgGTx1rGlzH2hLhUNkuy2rKdKKaDG4e+2ck/I25cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJKiKYIosF6IdevRrh4knIIN8A2KtVEvvpzcDXrqrSjEgzYWyBIhcHKxpKW86O3z223j95RwDiP9bY+u4qHKyaj5YbKr1LPngDOmy277qkJq2IkTWtqeTRPs6lTvWuArIrSv2+oksa22IXTy/tBl0sEwHNR9JtJy/+NwTOZDtec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOg61+ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOg61+ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89572C4CEE5;
	Mon, 10 Mar 2025 17:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627520;
	bh=bQZgGTx1rGlzH2hLhUNkuy2rKdKKaDG4e+2ck/I25cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOg61+jujow4zahKyUk2ft7b2RqfGFGZMf7V46uNFPT7m0//KGkkTpw8JlncZUFQt
	 iiwEUQ/pWCLHTI17ALAEcYHoTU4Hm9QLoiqN29gmRqaz5Ut40qSIZo/qLhnvv7OZ49
	 foRNoexeZ+x4V/8x1yea+U6IskL6tXmtaqAOefRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/269] drm: Add client-agnostic setup helper
Date: Mon, 10 Mar 2025 18:05:11 +0100
Message-ID: <20250310170504.021227426@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit d07fdf9225922d3e36ebd13ccab3df62b1ccdab3 ]

DRM may support multiple in-kernel clients that run as soon as a DRM
driver has been registered. To select the client(s) in a single place,
introduce drm_client_setup().

Drivers that call the new helper automatically instantiate the kernel's
configured default clients. Only fbdev emulation is currently supported.
Later versions can add support for DRM-based logging, a boot logo or even
a console.

Some drivers handle the color mode for clients internally. Provide the
helper drm_client_setup_with_color_mode() for them.

Using the new interface requires the driver to select
DRM_CLIENT_SELECTION in its Kconfig. For now this only enables the
client-setup helpers if the fbdev client has been configured by the
user. A future patchset will further modularize client support and
rework DRM_CLIENT_SELECTION to select the correct dependencies for
all its clients.

v5:
- add CONFIG_DRM_CLIENT_SELECTION und DRM_CLIENT_SETUP
v4:
- fix docs for drm_client_setup_with_fourcc() (Geert)
v3:
- fix build error
v2:
- add drm_client_setup_with_fourcc() (Laurent)
- push default-format handling into actual clients

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924071734.98201-5-tzimmermann@suse.de
Stable-dep-of: 6b481ab0e685 ("drm/nouveau: select FW caching")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig            | 12 ++++++
 drivers/gpu/drm/Makefile           |  2 +
 drivers/gpu/drm/drm_client_setup.c | 66 ++++++++++++++++++++++++++++++
 include/drm/drm_client_setup.h     | 26 ++++++++++++
 4 files changed, 106 insertions(+)
 create mode 100644 drivers/gpu/drm/drm_client_setup.c
 create mode 100644 include/drm/drm_client_setup.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 7408ea8caacc3..ae53f26da945f 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -211,6 +211,18 @@ config DRM_DEBUG_MODESET_LOCK
 
 	  If in doubt, say "N".
 
+config DRM_CLIENT_SELECTION
+	bool
+	depends on DRM
+	select DRM_CLIENT_SETUP if DRM_FBDEV_EMULATION
+	help
+	  Drivers that support in-kernel DRM clients have to select this
+	  option.
+
+config DRM_CLIENT_SETUP
+	bool
+	depends on DRM_CLIENT_SELECTION
+
 config DRM_FBDEV_EMULATION
 	bool "Enable legacy fbdev support for your modesetting driver"
 	depends on DRM
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index a1dd0909fa38b..1ec44529447a7 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -144,6 +144,8 @@ drm_kms_helper-y := \
 	drm_rect.o \
 	drm_self_refresh_helper.o \
 	drm_simple_kms_helper.o
+drm_kms_helper-$(CONFIG_DRM_CLIENT_SETUP) += \
+	drm_client_setup.o
 drm_kms_helper-$(CONFIG_DRM_PANEL_BRIDGE) += bridge/panel.o
 drm_kms_helper-$(CONFIG_DRM_FBDEV_EMULATION) += \
 	drm_fbdev_client.o \
diff --git a/drivers/gpu/drm/drm_client_setup.c b/drivers/gpu/drm/drm_client_setup.c
new file mode 100644
index 0000000000000..5969c4ffe31ba
--- /dev/null
+++ b/drivers/gpu/drm/drm_client_setup.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: MIT
+
+#include <drm/drm_client_setup.h>
+#include <drm/drm_device.h>
+#include <drm/drm_fbdev_client.h>
+#include <drm/drm_fourcc.h>
+#include <drm/drm_print.h>
+
+/**
+ * drm_client_setup() - Setup in-kernel DRM clients
+ * @dev: DRM device
+ * @format: Preferred pixel format for the device. Use NULL, unless
+ *          there is clearly a driver-preferred format.
+ *
+ * This function sets up the in-kernel DRM clients. Restore, hotplug
+ * events and teardown are all taken care of.
+ *
+ * Drivers should call drm_client_setup() after registering the new
+ * DRM device with drm_dev_register(). This function is safe to call
+ * even when there are no connectors present. Setup will be retried
+ * on the next hotplug event.
+ *
+ * The clients are destroyed by drm_dev_unregister().
+ */
+void drm_client_setup(struct drm_device *dev, const struct drm_format_info *format)
+{
+	int ret;
+
+	ret = drm_fbdev_client_setup(dev, format);
+	if (ret)
+		drm_warn(dev, "Failed to set up DRM client; error %d\n", ret);
+}
+EXPORT_SYMBOL(drm_client_setup);
+
+/**
+ * drm_client_setup_with_fourcc() - Setup in-kernel DRM clients for color mode
+ * @dev: DRM device
+ * @fourcc: Preferred pixel format as 4CC code for the device
+ *
+ * This function sets up the in-kernel DRM clients. It is equivalent
+ * to drm_client_setup(), but expects a 4CC code as second argument.
+ */
+void drm_client_setup_with_fourcc(struct drm_device *dev, u32 fourcc)
+{
+	drm_client_setup(dev, drm_format_info(fourcc));
+}
+EXPORT_SYMBOL(drm_client_setup_with_fourcc);
+
+/**
+ * drm_client_setup_with_color_mode() - Setup in-kernel DRM clients for color mode
+ * @dev: DRM device
+ * @color_mode: Preferred color mode for the device
+ *
+ * This function sets up the in-kernel DRM clients. It is equivalent
+ * to drm_client_setup(), but expects a color mode as second argument.
+ *
+ * Do not use this function in new drivers. Prefer drm_client_setup() with a
+ * format of NULL.
+ */
+void drm_client_setup_with_color_mode(struct drm_device *dev, unsigned int color_mode)
+{
+	u32 fourcc = drm_driver_color_mode_format(dev, color_mode);
+
+	drm_client_setup_with_fourcc(dev, fourcc);
+}
+EXPORT_SYMBOL(drm_client_setup_with_color_mode);
diff --git a/include/drm/drm_client_setup.h b/include/drm/drm_client_setup.h
new file mode 100644
index 0000000000000..46aab3fb46be5
--- /dev/null
+++ b/include/drm/drm_client_setup.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef DRM_CLIENT_SETUP_H
+#define DRM_CLIENT_SETUP_H
+
+#include <linux/types.h>
+
+struct drm_device;
+struct drm_format_info;
+
+#if defined(CONFIG_DRM_CLIENT_SETUP)
+void drm_client_setup(struct drm_device *dev, const struct drm_format_info *format);
+void drm_client_setup_with_fourcc(struct drm_device *dev, u32 fourcc);
+void drm_client_setup_with_color_mode(struct drm_device *dev, unsigned int color_mode);
+#else
+static inline void drm_client_setup(struct drm_device *dev,
+				    const struct drm_format_info *format)
+{ }
+static inline void drm_client_setup_with_fourcc(struct drm_device *dev, u32 fourcc)
+{ }
+static inline void drm_client_setup_with_color_mode(struct drm_device *dev,
+						    unsigned int color_mode)
+{ }
+#endif
+
+#endif
-- 
2.39.5



