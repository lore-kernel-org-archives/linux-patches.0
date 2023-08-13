Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66629443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB82C433C8;
	Sun, 13 Aug 2023 21:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961900;
	bh=vNJYFcOLkHuoMUtkQbX9/pPdw/1/ixpy1SWZ3ukjhrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1af5gM8mCCrT1sahjZ5oz2Klg5uk7w7C3x+9s89mwR2oRahAVeaD1IUrEHFXUL48
	 3fExChncqTK28wxWQm1oUusfRKDBIvsQ+1dmVtjvWMfEGqpnI9hnRMH7sd6P548b9e
	 RbSfDBHMNp9rP5HHcfA3nEkN22MbNhW05MRDzsz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 6.4 040/206] drm/nouveau/nvkm/dp: Add workaround to fix DP 1.3+ DPCD issues
Date: Sun, 13 Aug 2023 23:16:50 +0200
Message-ID: <20230813211726.142677210@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lyude Paul <lyude@redhat.com>

commit e4060dad253352382b20420d8ef98daab24dbc17 upstream.

Currently we use the drm_dp_dpcd_read_caps() helper in the DRM side of
nouveau in order to read the DPCD of a DP connector, which makes sure we do
the right thing and also check for extended DPCD caps. However, it turns
out we're not currently doing this on the nvkm side since we don't have
access to the drm_dp_aux structure there - which means that the DRM side of
the driver and the NVKM side can end up with different DPCD capabilities
for the same connector.

Ideally in order to fix this, we just want to use the
drm_dp_read_dpcd_caps() helper in nouveau. That's not currently possible
though, and is going to depend on having a bunch of the DP code moved out
of nvkm and into the DRM side of things as part of the GSP enablement work.

Until then however, let's workaround this problem by porting a copy of
drm_dp_read_dpcd_caps() into NVKM - which should fix this issue.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Link: https://gitlab.freedesktop.org/drm/nouveau/-/issues/211
Link: https://patchwork.freedesktop.org/patch/msgid/20230728225858.350581-1-lyude@redhat.com
(cherry picked from commit cc4adf3a7323212f303bc9ff0f96346c44fcba06 in drm-misc-next)
Cc: <stable@vger.kernel.org> # 6.3+
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c |   48 +++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
@@ -26,6 +26,8 @@
 #include "head.h"
 #include "ior.h"
 
+#include <drm/display/drm_dp.h>
+
 #include <subdev/bios.h>
 #include <subdev/bios/init.h>
 #include <subdev/gpio.h>
@@ -634,6 +636,50 @@ nvkm_dp_enable_supported_link_rates(stru
 	return outp->dp.rates != 0;
 }
 
+/* XXX: This is a big fat hack, and this is just drm_dp_read_dpcd_caps()
+ * converted to work inside nvkm. This is a temporary holdover until we start
+ * passing the drm_dp_aux device through NVKM
+ */
+static int
+nvkm_dp_read_dpcd_caps(struct nvkm_outp *outp)
+{
+	struct nvkm_i2c_aux *aux = outp->dp.aux;
+	u8 dpcd_ext[DP_RECEIVER_CAP_SIZE];
+	int ret;
+
+	ret = nvkm_rdaux(aux, DPCD_RC00_DPCD_REV, outp->dp.dpcd, DP_RECEIVER_CAP_SIZE);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Prior to DP1.3 the bit represented by
+	 * DP_EXTENDED_RECEIVER_CAP_FIELD_PRESENT was reserved.
+	 * If it is set DP_DPCD_REV at 0000h could be at a value less than
+	 * the true capability of the panel. The only way to check is to
+	 * then compare 0000h and 2200h.
+	 */
+	if (!(outp->dp.dpcd[DP_TRAINING_AUX_RD_INTERVAL] &
+	      DP_EXTENDED_RECEIVER_CAP_FIELD_PRESENT))
+		return 0;
+
+	ret = nvkm_rdaux(aux, DP_DP13_DPCD_REV, dpcd_ext, sizeof(dpcd_ext));
+	if (ret < 0)
+		return ret;
+
+	if (outp->dp.dpcd[DP_DPCD_REV] > dpcd_ext[DP_DPCD_REV]) {
+		OUTP_DBG(outp, "Extended DPCD rev less than base DPCD rev (%d > %d)\n",
+			 outp->dp.dpcd[DP_DPCD_REV], dpcd_ext[DP_DPCD_REV]);
+		return 0;
+	}
+
+	if (!memcmp(outp->dp.dpcd, dpcd_ext, sizeof(dpcd_ext)))
+		return 0;
+
+	memcpy(outp->dp.dpcd, dpcd_ext, sizeof(dpcd_ext));
+
+	return 0;
+}
+
 void
 nvkm_dp_enable(struct nvkm_outp *outp, bool auxpwr)
 {
@@ -689,7 +735,7 @@ nvkm_dp_enable(struct nvkm_outp *outp, b
 			memset(outp->dp.lttpr, 0x00, sizeof(outp->dp.lttpr));
 		}
 
-		if (!nvkm_rdaux(aux, DPCD_RC00_DPCD_REV, outp->dp.dpcd, sizeof(outp->dp.dpcd))) {
+		if (!nvkm_dp_read_dpcd_caps(outp)) {
 			const u8 rates[] = { 0x1e, 0x14, 0x0a, 0x06, 0 };
 			const u8 *rate;
 			int rate_max;


