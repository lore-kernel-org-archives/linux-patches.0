Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94EA1A6160;
	Tue, 30 Jul 2024 16:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356718; cv=none; b=e7ksyqHOdsBTtd3BCminQbZDIW10GCrruO6GYULWzDFWhjwuyAB4CaBvaecQMETHEmfj99a/C2X7oOiJ1BCvtTATCKGZUHDkr8oozTkj+c/HRPvkqTGidmVgGdLNwWd0Jc2NmNffXIG5IecjhAT4KoVqC/SmMeVTtMUQ526iuP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356718; c=relaxed/simple;
	bh=njzlPlunTj+ux/EiRfaDLyUKB2iuei0vGSk1jtg8mqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihrsgKLfveaKq5bq+dXob+9A5BaM3Y2//vMiKZhMBbcZr7yRTopCKyvd14HdGMOXsATS1WFhL2zuL5byJSZ3FShFcdJ5urLmj0TicBk95uvJFo1VvDBPL0dsJKXtILnTVq/1nsHyAsqmp43ezq/d7sd/nF7Jk4rhIIu6xfnZ/Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whsmKt9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whsmKt9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619F2C32782;
	Tue, 30 Jul 2024 16:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356718;
	bh=njzlPlunTj+ux/EiRfaDLyUKB2iuei0vGSk1jtg8mqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whsmKt9DvDxjXZsqT2SUpVrD2ySrPcA44H2IJvesN/YF/tXjhVcDG3UTJ5IjHbMpA
	 5Ehl8ThKCb1X60K9YeA1l61HOO/tr/LltjLsWE32ARcxE9ahdDnG3zYXVLVIRTFFrw
	 wGphbD5NNXZt7asvLEebv6XDK4vp9HQzWHqBMC0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faiz Abbas <faiz.abbas@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/568] drm/arm/komeda: Fix komeda probe failing if there are no links in the secondary pipeline
Date: Tue, 30 Jul 2024 17:44:43 +0200
Message-ID: <20240730151646.760405661@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Faiz Abbas <faiz.abbas@arm.com>

[ Upstream commit 9054c46d479b55768adae31031a1afa1b7d62228 ]

Since commit 4cfe5cc02e3f ("drm/arm/komeda: Remove component framework and
add a simple encoder"), the devm_drm_of_get_bridge() call happens
regardless of whether any remote nodes are available on the pipeline. Fix
this by moving the bridge attach to its own function and calling it
conditional on there being an output link.

Fixes: 4cfe5cc02e3f ("drm/arm/komeda: Remove component framework and add a simple encoder")
Signed-off-by: Faiz Abbas <faiz.abbas@arm.com>
[Corrected Commit-id of the fixed patch to match mainline]
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240219100915.192475-2-faiz.abbas@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/arm/display/komeda/komeda_crtc.c  | 43 ++++++++++++++-----
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
index 2c661f28410ed..b645c5998230b 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
@@ -5,6 +5,7 @@
  *
  */
 #include <linux/clk.h>
+#include <linux/of.h>
 #include <linux/pm_runtime.h>
 #include <linux/spinlock.h>
 
@@ -610,12 +611,34 @@ get_crtc_primary(struct komeda_kms_dev *kms, struct komeda_crtc *crtc)
 	return NULL;
 }
 
+static int komeda_attach_bridge(struct device *dev,
+				struct komeda_pipeline *pipe,
+				struct drm_encoder *encoder)
+{
+	struct drm_bridge *bridge;
+	int err;
+
+	bridge = devm_drm_of_get_bridge(dev, pipe->of_node,
+					KOMEDA_OF_PORT_OUTPUT, 0);
+	if (IS_ERR(bridge))
+		return dev_err_probe(dev, PTR_ERR(bridge), "remote bridge not found for pipe: %s\n",
+				     of_node_full_name(pipe->of_node));
+
+	err = drm_bridge_attach(encoder, bridge, NULL, 0);
+	if (err)
+		dev_err(dev, "bridge_attach() failed for pipe: %s\n",
+			of_node_full_name(pipe->of_node));
+
+	return err;
+}
+
 static int komeda_crtc_add(struct komeda_kms_dev *kms,
 			   struct komeda_crtc *kcrtc)
 {
 	struct drm_crtc *crtc = &kcrtc->base;
 	struct drm_device *base = &kms->base;
-	struct drm_bridge *bridge;
+	struct komeda_pipeline *pipe = kcrtc->master;
+	struct drm_encoder *encoder = &kcrtc->encoder;
 	int err;
 
 	err = drm_crtc_init_with_planes(base, crtc,
@@ -626,27 +649,25 @@ static int komeda_crtc_add(struct komeda_kms_dev *kms,
 
 	drm_crtc_helper_add(crtc, &komeda_crtc_helper_funcs);
 
-	crtc->port = kcrtc->master->of_output_port;
+	crtc->port = pipe->of_output_port;
 
 	/* Construct an encoder for each pipeline and attach it to the remote
 	 * bridge
 	 */
 	kcrtc->encoder.possible_crtcs = drm_crtc_mask(crtc);
-	err = drm_simple_encoder_init(base, &kcrtc->encoder,
-				      DRM_MODE_ENCODER_TMDS);
+	err = drm_simple_encoder_init(base, encoder, DRM_MODE_ENCODER_TMDS);
 	if (err)
 		return err;
 
-	bridge = devm_drm_of_get_bridge(base->dev, kcrtc->master->of_node,
-					KOMEDA_OF_PORT_OUTPUT, 0);
-	if (IS_ERR(bridge))
-		return PTR_ERR(bridge);
-
-	err = drm_bridge_attach(&kcrtc->encoder, bridge, NULL, 0);
+	if (pipe->of_output_links[0]) {
+		err = komeda_attach_bridge(base->dev, pipe, encoder);
+		if (err)
+			return err;
+	}
 
 	drm_crtc_enable_color_mgmt(crtc, 0, true, KOMEDA_COLOR_LUT_SIZE);
 
-	return err;
+	return 0;
 }
 
 int komeda_kms_add_crtcs(struct komeda_kms_dev *kms, struct komeda_dev *mdev)
-- 
2.43.0



