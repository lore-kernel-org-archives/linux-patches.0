Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065A31171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBDCC433C7;
	Mon, 21 Aug 2023 19:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647992;
	bh=LPjJnxqmyWsIG349aVwUxeMmqedEam3TdYDbVqcbNwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4NNcKZTLkvuPD9W7x2xP1KU9XHZt3iOzIJcIouIuI1kZv8T3q7eRWWt5hv+e8mAV
	 Bwf7aIR6zgfkRAbY2Ff/7CUYbDe3rpVMwkF4xvtQs2bnlOUiZ70scnabdhR2MhkVzM
	 SEaFBYiLxQ6eT0B66VVk8IRtrwlRBtAezlxY8Hng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 017/234] drm: rcar-du: remove R-Car H3 ES1.* workarounds
Date: Mon, 21 Aug 2023 21:39:40 +0200
Message-ID: <20230821194129.512417205@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 2da4b728f994a1f9189a8066b0be90b615768764 ]

R-Car H3 ES1.* was only available to an internal development group and
needed a lot of quirks and workarounds. These become a maintenance
burden now, so our development group decided to remove upstream support
for this SoC and prevent booting it. Public users only have ES2 onwards.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 37 ++------------------
 drivers/gpu/drm/rcar-du/rcar_du_drv.c  | 48 --------------------------
 drivers/gpu/drm/rcar-du/rcar_du_drv.h  |  2 --
 drivers/gpu/drm/rcar-du/rcar_du_regs.h |  3 +-
 4 files changed, 4 insertions(+), 86 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index d6d29be6b4f48..7e175dbfd8924 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -223,20 +223,6 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 		 * DU channels that have a display PLL can't use the internal
 		 * system clock, and have no internal clock divider.
 		 */
-
-		/*
-		 * The H3 ES1.x exhibits dot clock duty cycle stability issues.
-		 * We can work around them by configuring the DPLL to twice the
-		 * desired frequency, coupled with a /2 post-divider. Restrict
-		 * the workaround to H3 ES1.x as ES2.0 and all other SoCs have
-		 * no post-divider when a display PLL is present (as shown by
-		 * the workaround breaking HDMI output on M3-W during testing).
-		 */
-		if (rcdu->info->quirks & RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY) {
-			target *= 2;
-			div = 1;
-		}
-
 		extclk = clk_get_rate(rcrtc->extclock);
 		rcar_du_dpll_divider(rcrtc, &dpll, extclk, target);
 
@@ -245,30 +231,13 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 		       | DPLLCR_N(dpll.n) | DPLLCR_M(dpll.m)
 		       | DPLLCR_STBY;
 
-		if (rcrtc->index == 1) {
+		if (rcrtc->index == 1)
 			dpllcr |= DPLLCR_PLCS1
 			       |  DPLLCR_INCS_DOTCLKIN1;
-		} else {
-			dpllcr |= DPLLCR_PLCS0_PLL
+		else
+			dpllcr |= DPLLCR_PLCS0
 			       |  DPLLCR_INCS_DOTCLKIN0;
 
-			/*
-			 * On ES2.x we have a single mux controlled via bit 21,
-			 * which selects between DCLKIN source (bit 21 = 0) and
-			 * a PLL source (bit 21 = 1), where the PLL is always
-			 * PLL1.
-			 *
-			 * On ES1.x we have an additional mux, controlled
-			 * via bit 20, for choosing between PLL0 (bit 20 = 0)
-			 * and PLL1 (bit 20 = 1). We always want to use PLL1,
-			 * so on ES1.x, in addition to setting bit 21, we need
-			 * to set the bit 20.
-			 */
-
-			if (rcdu->info->quirks & RCAR_DU_QUIRK_H3_ES1_PLL)
-				dpllcr |= DPLLCR_PLCS0_H3ES1X_PLL1;
-		}
-
 		rcar_du_group_write(rcrtc->group, DPLLCR, dpllcr);
 
 		escr = ESCR_DCLKSEL_DCLKIN | div;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index b9a94c5260e9d..1ffde19cb87fe 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -16,7 +16,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
-#include <linux/sys_soc.h>
 #include <linux/wait.h>
 
 #include <drm/drm_atomic_helper.h>
@@ -387,43 +386,6 @@ static const struct rcar_du_device_info rcar_du_r8a7795_info = {
 	.dpll_mask =  BIT(2) | BIT(1),
 };
 
-static const struct rcar_du_device_info rcar_du_r8a7795_es1_info = {
-	.gen = 3,
-	.features = RCAR_DU_FEATURE_CRTC_IRQ
-		  | RCAR_DU_FEATURE_CRTC_CLOCK
-		  | RCAR_DU_FEATURE_VSP1_SOURCE
-		  | RCAR_DU_FEATURE_INTERLACED
-		  | RCAR_DU_FEATURE_TVM_SYNC,
-	.quirks = RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY
-		| RCAR_DU_QUIRK_H3_ES1_PLL,
-	.channels_mask = BIT(3) | BIT(2) | BIT(1) | BIT(0),
-	.routes = {
-		/*
-		 * R8A7795 has one RGB output, two HDMI outputs and one
-		 * LVDS output.
-		 */
-		[RCAR_DU_OUTPUT_DPAD0] = {
-			.possible_crtcs = BIT(3),
-			.port = 0,
-		},
-		[RCAR_DU_OUTPUT_HDMI0] = {
-			.possible_crtcs = BIT(1),
-			.port = 1,
-		},
-		[RCAR_DU_OUTPUT_HDMI1] = {
-			.possible_crtcs = BIT(2),
-			.port = 2,
-		},
-		[RCAR_DU_OUTPUT_LVDS0] = {
-			.possible_crtcs = BIT(0),
-			.port = 3,
-		},
-	},
-	.num_lvds = 1,
-	.num_rpf = 5,
-	.dpll_mask =  BIT(2) | BIT(1),
-};
-
 static const struct rcar_du_device_info rcar_du_r8a7796_info = {
 	.gen = 3,
 	.features = RCAR_DU_FEATURE_CRTC_IRQ
@@ -614,11 +576,6 @@ static const struct of_device_id rcar_du_of_table[] = {
 
 MODULE_DEVICE_TABLE(of, rcar_du_of_table);
 
-static const struct soc_device_attribute rcar_du_soc_table[] = {
-	{ .soc_id = "r8a7795", .revision = "ES1.*", .data = &rcar_du_r8a7795_es1_info },
-	{ /* sentinel */ }
-};
-
 const char *rcar_du_output_name(enum rcar_du_output output)
 {
 	static const char * const names[] = {
@@ -707,7 +664,6 @@ static void rcar_du_shutdown(struct platform_device *pdev)
 
 static int rcar_du_probe(struct platform_device *pdev)
 {
-	const struct soc_device_attribute *soc_attr;
 	struct rcar_du_device *rcdu;
 	unsigned int mask;
 	int ret;
@@ -725,10 +681,6 @@ static int rcar_du_probe(struct platform_device *pdev)
 
 	rcdu->info = of_device_get_match_data(rcdu->dev);
 
-	soc_attr = soc_device_match(rcar_du_soc_table);
-	if (soc_attr)
-		rcdu->info = soc_attr->data;
-
 	platform_set_drvdata(pdev, rcdu);
 
 	/* I/O resources */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
index acc3673fefe18..5cfa2bb7ad93d 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
@@ -34,8 +34,6 @@ struct rcar_du_device;
 #define RCAR_DU_FEATURE_NO_BLENDING	BIT(5)	/* PnMR.SPIM does not have ALP nor EOR bits */
 
 #define RCAR_DU_QUIRK_ALIGN_128B	BIT(0)	/* Align pitches to 128 bytes */
-#define RCAR_DU_QUIRK_H3_ES1_PCLK_STABILITY BIT(1)	/* H3 ES1 has pclk stability issue */
-#define RCAR_DU_QUIRK_H3_ES1_PLL	BIT(2)	/* H3 ES1 PLL setup differs from non-ES1 */
 
 enum rcar_du_output {
 	RCAR_DU_OUTPUT_DPAD0,
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_regs.h b/drivers/gpu/drm/rcar-du/rcar_du_regs.h
index 6c750fab6ebb7..391de6661d8bc 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_regs.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_regs.h
@@ -283,8 +283,7 @@
 #define DPLLCR			0x20044
 #define DPLLCR_CODE		(0x95 << 24)
 #define DPLLCR_PLCS1		(1 << 23)
-#define DPLLCR_PLCS0_PLL	(1 << 21)
-#define DPLLCR_PLCS0_H3ES1X_PLL1	(1 << 20)
+#define DPLLCR_PLCS0		(1 << 21)
 #define DPLLCR_CLKE		(1 << 18)
 #define DPLLCR_FDPLL(n)		((n) << 12)
 #define DPLLCR_N(n)		((n) << 5)
-- 
2.40.1



