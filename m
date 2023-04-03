Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33226FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FCFC433D2;
	Mon,  3 Apr 2023 14:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533255;
	bh=YrDgFLmFfvH+WFEX1x8mTzwDYf59WvtcW9Lgu6zuxVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1/dz1EczJHqNIZZO3/uyumrMebjMh+nmDluiCekx7ZkbEJDaE97lHMgD8EHK4Tpv
	 5dED041wcZymnFgIZi8Y9D1me47EIu/QqnjYSPmQrntgwjhmREWAmWmDbUyNWyJjbw
	 TL1k4XsQwkYfFmAGKNwhjiIhrnijS9MC7ZqwmZmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 112/187] drm/nouveau/kms: Fix backlight registration
Date: Mon,  3 Apr 2023 16:09:17 +0200
Message-Id: <20230403140419.658683061@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 30fb97ba4a8e082ba0a5432479d6995472edbd7b ]

The nouveau code used to call drm_fb_helper_initial_config() from
nouveau_fbcon_init() before calling drm_dev_register(). This would
probe all connectors so that drm_connector->status could be used during
backlight registration which runs from nouveau_connector_late_register().

After commit 4a16dd9d18a0 ("drm/nouveau/kms: switch to drm fbdev helpers")
the fbdev emulation code, which now is a drm-client, can only run after
drm_dev_register(). So during backlight registration the connectors are
not probed yet and the drm_connector->status == connected check in
nv50_backlight_init() would now always fail.

Replace the drm_connector->status == connected check with
a drm_helper_probe_detect() == connected check to fix nv_backlight
no longer getting registered because of this.

Fixes: 4a16dd9d18a0 ("drm/nouveau/kms: switch to drm fbdev helpers")
Link: https://gitlab.freedesktop.org/drm/nouveau/-/issues/202
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2181941
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230326205433.36485-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_backlight.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 40409a29f5b69..91b5ecc575380 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -33,6 +33,7 @@
 #include <linux/apple-gmux.h>
 #include <linux/backlight.h>
 #include <linux/idr.h>
+#include <drm/drm_probe_helper.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_reg.h"
@@ -299,8 +300,12 @@ nv50_backlight_init(struct nouveau_backlight *bl,
 	struct nouveau_drm *drm = nouveau_drm(nv_encoder->base.base.dev);
 	struct nvif_object *device = &drm->client.device.object;
 
+	/*
+	 * Note when this runs the connectors have not been probed yet,
+	 * so nv_conn->base.status is not set yet.
+	 */
 	if (!nvif_rd32(device, NV50_PDISP_SOR_PWM_CTL(ffs(nv_encoder->dcb->or) - 1)) ||
-	    nv_conn->base.status != connector_status_connected)
+	    drm_helper_probe_detect(&nv_conn->base, NULL, false) != connector_status_connected)
 		return -ENODEV;
 
 	if (nv_conn->type == DCB_CONNECTOR_eDP) {
-- 
2.39.2



