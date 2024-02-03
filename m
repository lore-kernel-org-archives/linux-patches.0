Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D981642F;
	Sat,  3 Feb 2024 04:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933851; cv=none; b=q/4qKLzhxyfTnRebY89bUR+Bo9m+h9AEbos0AjnLcF2aqhsxH8u+SaAjqOrHZeYH8Waf1EsdqE2MeGdkgxG9TBYGjXTNSIJfqAZ89H3ZpUWut0jBw6xI+CtCBdoffj4awBjo0HxDHT7kEpthMwijq46/nKAn05pRA03aUGqsNlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933851; c=relaxed/simple;
	bh=zhWdTJ4bZqyIID9jYKxLznfluPdnESPnYmZ/vtWLWqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNcCGeuthSAWvNRqNd4G1hQjiq48+sFvwFCZ40zQVS8BbuopsmMMOyhDu+fZQJZoTLpM+shxvrltNF4RfQwXN3R7X/pWqk8suZGRyIT2A5SSprCxxi55Fw1fxUwKf85zx9rQ/KMQ/1CgL+r5L6msOkdqss909GsV/oEdQM3TtW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRQ26YPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRQ26YPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02734C43390;
	Sat,  3 Feb 2024 04:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933851;
	bh=zhWdTJ4bZqyIID9jYKxLznfluPdnESPnYmZ/vtWLWqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRQ26YPk8UlEu4WPr+xi4U5rZX5Z6OcW1UNUKCc+/gWxV2suLujSgAeYuFNVwjDZ3
	 ACqKx2KH5fzNQUOXD+tdw/0Q1YR0E8/eeX8a1XWXupuNmSxaIuqh5NUOv+3Ae2OHvm
	 Cd+gQOGsRgfpDs9QSB0hOQTb9TZBIOMqZ0bMQ2YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Tony Lindgren <tony@atomide.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 181/353] drm/mipi-dsi: Fix detach call without attach
Date: Fri,  2 Feb 2024 20:04:59 -0800
Message-ID: <20240203035409.375304767@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 90d50b8d85834e73536fdccd5aa913b30494fef0 ]

It's been reported that DSI host driver's detach can be called without
the attach ever happening:

https://lore.kernel.org/all/20230412073954.20601-1-tony@atomide.com/

After reading the code, I think this is what happens:

We have a DSI host defined in the device tree and a DSI peripheral under
that host (i.e. an i2c device using the DSI as data bus doesn't exhibit
this behavior).

The host driver calls mipi_dsi_host_register(), which causes (via a few
functions) mipi_dsi_device_add() to be called for the DSI peripheral. So
now we have a DSI device under the host, but attach hasn't been called.

Normally the probing of the devices continues, and eventually the DSI
peripheral's driver will call mipi_dsi_attach(), attaching the
peripheral.

However, if the host driver's probe encounters an error after calling
mipi_dsi_host_register(), and before the peripheral has called
mipi_dsi_attach(), the host driver will do cleanups and return an error
from its probe function. The cleanups include calling
mipi_dsi_host_unregister().

mipi_dsi_host_unregister() will call two functions for all its DSI
peripheral devices: mipi_dsi_detach() and mipi_dsi_device_unregister().
The latter makes sense, as the device exists, but the former may be
wrong as attach has not necessarily been done.

To fix this, track the attached state of the peripheral, and only detach
from mipi_dsi_host_unregister() if the peripheral was attached.

Note that I have only tested this with a board with an i2c DSI
peripheral, not with a "pure" DSI peripheral.

However, slightly related, the unregister machinery still seems broken.
E.g. if the DSI host driver is unbound, it'll detach and unregister the
DSI peripherals. After that, when the DSI peripheral driver unbound
it'll call detach either directly or using the devm variant, leading to
a crash. And probably the driver will crash if it happens, for some
reason, to try to send a message via the DSI bus.

But that's another topic.

Tested-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230921-dsi-detach-fix-v1-1-d0de2d1621d9@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dsi.c | 17 +++++++++++++++--
 include/drm/drm_mipi_dsi.h     |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index 14201f73aab1..843a6dbda93a 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -347,7 +347,8 @@ static int mipi_dsi_remove_device_fn(struct device *dev, void *priv)
 {
 	struct mipi_dsi_device *dsi = to_mipi_dsi_device(dev);
 
-	mipi_dsi_detach(dsi);
+	if (dsi->attached)
+		mipi_dsi_detach(dsi);
 	mipi_dsi_device_unregister(dsi);
 
 	return 0;
@@ -370,11 +371,18 @@ EXPORT_SYMBOL(mipi_dsi_host_unregister);
 int mipi_dsi_attach(struct mipi_dsi_device *dsi)
 {
 	const struct mipi_dsi_host_ops *ops = dsi->host->ops;
+	int ret;
 
 	if (!ops || !ops->attach)
 		return -ENOSYS;
 
-	return ops->attach(dsi->host, dsi);
+	ret = ops->attach(dsi->host, dsi);
+	if (ret)
+		return ret;
+
+	dsi->attached = true;
+
+	return 0;
 }
 EXPORT_SYMBOL(mipi_dsi_attach);
 
@@ -386,9 +394,14 @@ int mipi_dsi_detach(struct mipi_dsi_device *dsi)
 {
 	const struct mipi_dsi_host_ops *ops = dsi->host->ops;
 
+	if (WARN_ON(!dsi->attached))
+		return -EINVAL;
+
 	if (!ops || !ops->detach)
 		return -ENOSYS;
 
+	dsi->attached = false;
+
 	return ops->detach(dsi->host, dsi);
 }
 EXPORT_SYMBOL(mipi_dsi_detach);
diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index c9df0407980c..c0aec0d4d664 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -168,6 +168,7 @@ struct mipi_dsi_device_info {
  * struct mipi_dsi_device - DSI peripheral device
  * @host: DSI host for this peripheral
  * @dev: driver model device node for this peripheral
+ * @attached: the DSI device has been successfully attached
  * @name: DSI peripheral chip type
  * @channel: virtual channel assigned to the peripheral
  * @format: pixel format for video mode
@@ -184,6 +185,7 @@ struct mipi_dsi_device_info {
 struct mipi_dsi_device {
 	struct mipi_dsi_host *host;
 	struct device dev;
+	bool attached;
 
 	char name[DSI_DEV_NAME_SIZE];
 	unsigned int channel;
-- 
2.43.0



