Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A791ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF2BC433C8;
	Fri, 21 Jul 2023 18:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965836;
	bh=82YgLRHTFuBKNbkIY4eunt2GzGRgyFrMHQKlcuEC2d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9Rg1w+1DT9TdO/qUGvOKLj2M6uw7Dcou7cpSDZxna8bb1XmdXJcJlV6UDcV/Vxna
	 PbdokEz4GDHskWN4c92pMqMNL1N+Knq8qo7iyTHwET/XFlWm0VDQiwsqdWpzv/eh0A
	 D8aYyxXhhsV/S4VGu2+hFNO8thMJabqtbKlYCfb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/532] drm/bridge: tc358768: Add atomic_get_input_bus_fmts() implementation
Date: Fri, 21 Jul 2023 18:00:07 +0200
Message-ID: <20230721160620.160572335@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit cec5ccef85bd0128cf895612de54a9d21d2015d0 ]

Add atomic_get_input_bus_fmts() implementation, tc358768 has a parallel
RGB input interface with the actual bus format depending on the amount
of parallel input data lines.

Without this change when the tc358768 is used with less than 24bit the
color mapping is completely wrong.

Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230330095941.428122-7-francesco@dolcini.it
Stable-dep-of: ee18698e212b ("drm/bridge: tc358768: fix TCLK_TRAILCNT computation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index fa06c06e41ebe..6e95dd4b7aef7 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -9,6 +9,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
+#include <linux/media-bus-format.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
@@ -871,6 +872,44 @@ static void tc358768_bridge_enable(struct drm_bridge *bridge)
 	}
 }
 
+#define MAX_INPUT_SEL_FORMATS	1
+
+static u32 *
+tc358768_atomic_get_input_bus_fmts(struct drm_bridge *bridge,
+				   struct drm_bridge_state *bridge_state,
+				   struct drm_crtc_state *crtc_state,
+				   struct drm_connector_state *conn_state,
+				   u32 output_fmt,
+				   unsigned int *num_input_fmts)
+{
+	struct tc358768_priv *priv = bridge_to_tc358768(bridge);
+	u32 *input_fmts;
+
+	*num_input_fmts = 0;
+
+	input_fmts = kcalloc(MAX_INPUT_SEL_FORMATS, sizeof(*input_fmts),
+			     GFP_KERNEL);
+	if (!input_fmts)
+		return NULL;
+
+	switch (priv->pd_lines) {
+	case 16:
+		input_fmts[0] = MEDIA_BUS_FMT_RGB565_1X16;
+		break;
+	case 18:
+		input_fmts[0] = MEDIA_BUS_FMT_RGB666_1X18;
+		break;
+	default:
+	case 24:
+		input_fmts[0] = MEDIA_BUS_FMT_RGB888_1X24;
+		break;
+	};
+
+	*num_input_fmts = MAX_INPUT_SEL_FORMATS;
+
+	return input_fmts;
+}
+
 static const struct drm_bridge_funcs tc358768_bridge_funcs = {
 	.attach = tc358768_bridge_attach,
 	.mode_valid = tc358768_bridge_mode_valid,
@@ -878,6 +917,11 @@ static const struct drm_bridge_funcs tc358768_bridge_funcs = {
 	.enable = tc358768_bridge_enable,
 	.disable = tc358768_bridge_disable,
 	.post_disable = tc358768_bridge_post_disable,
+
+	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
+	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
+	.atomic_reset = drm_atomic_helper_bridge_reset,
+	.atomic_get_input_bus_fmts = tc358768_atomic_get_input_bus_fmts,
 };
 
 static const struct drm_bridge_timings default_tc358768_timings = {
-- 
2.39.2



