Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD6A3A1C4;
	Wed,  7 Aug 2024 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043674; cv=none; b=K8KC7tzZCuBQA2OXBVi+4KnXSOVGp+ihwZyhZtM2iR/vURv20qPbPphczi41Yt36vjrO80Gf64URGIdXNzwlMgakO9bnhB0RfSfbpLjSfFn3AKbpke4rU+Ap4w7WAv0oiXrt/6pLnye8pOcJdEAbDPulLHxnmstzNWy6plM4tPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043674; c=relaxed/simple;
	bh=c1atkGh9+dKIbRa73Sz3iCabppyCJtHOoHxQD8dU+DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZE3UpXsZEHJFa9Hck7LvDQyw6ZdCmqjULSz0loDjrLp7uM1LkaEnTo/ZjolWX9kyr5DmSO/vXVOO/JQOqWlwLdvdvJbvbQBI5tRsi1pGY7dzkkii8DCNLkPW18aXCEZkvhZ8YAx4xBfiDhL9AG85+ukUyFJa5dG3CE7hkRWq9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfszmJ+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfszmJ+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD91CC32781;
	Wed,  7 Aug 2024 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043674;
	bh=c1atkGh9+dKIbRa73Sz3iCabppyCJtHOoHxQD8dU+DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfszmJ+iItdDry4rcBROUriDrWC9f9SRImODZL/2aGmZbnwVLF68rXGKttq9iq750
	 uB97tNk0WmHSpr572+NJEcnSqITSGa2a1nUi36hEIMqaqdb5JJdbZ+g0hpnTcsg9Xm
	 hTvZQ2D33bhMEmBVwU30JSdaFNh5Y2ATOc5kQ/Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/86] drm/udl: Various improvements to the connector
Date: Wed,  7 Aug 2024 17:00:09 +0200
Message-ID: <20240807150040.233363955@linuxfoundation.org>
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

[ Upstream commit 43858eb41e0dde6e48565c13cdabac95b5d9df90 ]

Add style fixes, better error handling and reporting, and minor
clean-up changes to the connector code before moving the code to
the rest of the modesetting pipeline.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221006095355.23579-5-tzimmermann@suse.de
Stable-dep-of: 5aed213c7c6c ("drm/udl: Remove DRM_CONNECTOR_POLL_HPD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/udl_connector.c | 64 ++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index cb3d6820eaf93..538b47ffa67fa 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -15,56 +15,64 @@
 #include "udl_connector.h"
 #include "udl_drv.h"
 
-static int udl_get_edid_block(void *data, u8 *buf, unsigned int block,
-			       size_t len)
+static int udl_get_edid_block(void *data, u8 *buf, unsigned int block, size_t len)
 {
-	int ret, i;
-	u8 *read_buff;
 	struct udl_device *udl = data;
+	struct drm_device *dev = &udl->drm;
 	struct usb_device *udev = udl_to_usb_device(udl);
+	u8 *read_buff;
+	int ret;
+	size_t i;
 
 	read_buff = kmalloc(2, GFP_KERNEL);
 	if (!read_buff)
-		return -1;
+		return -ENOMEM;
 
 	for (i = 0; i < len; i++) {
 		int bval = (i + block * EDID_LENGTH) << 8;
+
 		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				      0x02, (0x80 | (0x02 << 5)), bval,
 				      0xA1, read_buff, 2, USB_CTRL_GET_TIMEOUT);
-		if (ret < 1) {
-			DRM_ERROR("Read EDID byte %d failed err %x\n", i, ret);
-			kfree(read_buff);
-			return -1;
+		if (ret < 0) {
+			drm_err(dev, "Read EDID byte %zu failed err %x\n", i, ret);
+			goto err_kfree;
+		} else if (ret < 1) {
+			ret = -EIO;
+			drm_err(dev, "Read EDID byte %zu failed\n", i);
+			goto err_kfree;
 		}
+
 		buf[i] = read_buff[1];
 	}
 
 	kfree(read_buff);
+
 	return 0;
+
+err_kfree:
+	kfree(read_buff);
+	return ret;
 }
 
-static int udl_get_modes(struct drm_connector *connector)
+static int udl_connector_helper_get_modes(struct drm_connector *connector)
 {
 	struct udl_connector *udl_connector = to_udl_connector(connector);
 
 	drm_connector_update_edid_property(connector, udl_connector->edid);
 	if (udl_connector->edid)
 		return drm_add_edid_modes(connector, udl_connector->edid);
+
 	return 0;
 }
 
-static enum drm_connector_status
-udl_detect(struct drm_connector *connector, bool force)
+static enum drm_connector_status udl_connector_detect(struct drm_connector *connector, bool force)
 {
 	struct udl_device *udl = to_udl(connector->dev);
 	struct udl_connector *udl_connector = to_udl_connector(connector);
 
-	/* cleanup previous edid */
-	if (udl_connector->edid != NULL) {
-		kfree(udl_connector->edid);
-		udl_connector->edid = NULL;
-	}
+	/* cleanup previous EDID */
+	kfree(udl_connector->edid);
 
 	udl_connector->edid = drm_do_get_edid(connector, udl_get_edid_block, udl);
 	if (!udl_connector->edid)
@@ -79,38 +87,46 @@ static void udl_connector_destroy(struct drm_connector *connector)
 
 	drm_connector_cleanup(connector);
 	kfree(udl_connector->edid);
-	kfree(connector);
+	kfree(udl_connector);
 }
 
 static const struct drm_connector_helper_funcs udl_connector_helper_funcs = {
-	.get_modes = udl_get_modes,
+	.get_modes = udl_connector_helper_get_modes,
 };
 
 static const struct drm_connector_funcs udl_connector_funcs = {
 	.reset = drm_atomic_helper_connector_reset,
-	.detect = udl_detect,
+	.detect = udl_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.destroy = udl_connector_destroy,
 	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
-	.atomic_destroy_state   = drm_atomic_helper_connector_destroy_state,
+	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
 struct drm_connector *udl_connector_init(struct drm_device *dev)
 {
 	struct udl_connector *udl_connector;
 	struct drm_connector *connector;
+	int ret;
 
 	udl_connector = kzalloc(sizeof(*udl_connector), GFP_KERNEL);
 	if (!udl_connector)
 		return ERR_PTR(-ENOMEM);
 
 	connector = &udl_connector->connector;
-	drm_connector_init(dev, connector, &udl_connector_funcs,
-			   DRM_MODE_CONNECTOR_VGA);
+	ret = drm_connector_init(dev, connector, &udl_connector_funcs, DRM_MODE_CONNECTOR_VGA);
+	if (ret)
+		goto err_kfree;
+
 	drm_connector_helper_add(connector, &udl_connector_helper_funcs);
 
 	connector->polled = DRM_CONNECTOR_POLL_HPD |
-		DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR_POLL_DISCONNECT;
+			    DRM_CONNECTOR_POLL_CONNECT |
+			    DRM_CONNECTOR_POLL_DISCONNECT;
 
 	return connector;
+
+err_kfree:
+	kfree(udl_connector);
+	return ERR_PTR(ret);
 }
-- 
2.43.0



