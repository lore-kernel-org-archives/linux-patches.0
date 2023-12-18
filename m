Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E602D129EF7;
	Mon, 18 Dec 2023 14:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QL5GIckT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE8EC433C7;
	Mon, 18 Dec 2023 14:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908497;
	bh=s7/hb4h5TNsN8mAb2xaitoeZhXtf1YSJIEQzaDU2n7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QL5GIckT//DblmX7GWQ4ZN6X14FYpvzXvVnEnT4ydRj4MWxDh2DORA56GcqWrbU0h
	 zS2GmKRzq6qWK0GIGZDYLZLA5aeH0bh5Uh5MtJBWV8+V3ZHiBkooEtu6XZKjWbwOxx
	 M90NtjWqBZuTVXRV4xfTKl9rbwXikAyyM3nZHrrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	"James (Qian) Wang" <james.qian.wang@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Mihail Atanassov <mihail.atanassov@arm.com>,
	Brian Starkey <brian.starkey@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Paul Cercueil <paul@crapouillou.net>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sandy Huang <hjc@rock-chips.com>,
	=?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/62] drm: Use state helper instead of CRTC state pointer
Date: Mon, 18 Dec 2023 14:51:55 +0100
Message-ID: <20231218135047.648422787@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 253f28b6237264216b052ac0848fd7fc917b5259 ]

Many drivers reference the crtc->pointer in order to get the current CRTC
state in their atomic_begin or atomic_flush hooks, which would be the new
CRTC state in the global atomic state since _swap_state happened when those
hooks are run.

Use the drm_atomic_get_new_crtc_state helper to get that state to make it
more obvious.

This was made using the coccinelle script below:

@ crtc_atomic_func @
identifier helpers;
identifier func;
@@

(
static struct drm_crtc_helper_funcs helpers = {
	...,
	.atomic_begin = func,
	...,
};
|
static struct drm_crtc_helper_funcs helpers = {
	...,
	.atomic_flush = func,
	...,
};
)

@@
identifier crtc_atomic_func.func;
identifier crtc, state;
symbol crtc_state;
expression e;
@@

  func(struct drm_crtc *crtc, struct drm_atomic_state *state) {
  ...
- struct tegra_dc_state *crtc_state = e;
+ struct tegra_dc_state *dc_state = e;
  <+...
-       crtc_state
+	dc_state
  ...+>
  }

@@
identifier crtc_atomic_func.func;
identifier crtc, state;
symbol crtc_state;
expression e;
@@

  func(struct drm_crtc *crtc, struct drm_atomic_state *state) {
  ...
- struct mtk_crtc_state *crtc_state = e;
+ struct mtk_crtc_state *mtk_crtc_state = e;
  <+...
-       crtc_state
+	mtk_crtc_state
  ...+>
  }

@ replaces_new_state @
identifier crtc_atomic_func.func;
identifier crtc, state, crtc_state;
@@

  func(struct drm_crtc *crtc, struct drm_atomic_state *state) {
  ...
- struct drm_crtc_state *crtc_state = crtc->state;
+ struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state, crtc);
  ...
 }

@@
identifier crtc_atomic_func.func;
identifier crtc, state, crtc_state;
@@

  func(struct drm_crtc *crtc, struct drm_atomic_state *state) {
  struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state, crtc);
  ...
- crtc->state
+ crtc_state
  ...
 }

@ adds_new_state @
identifier crtc_atomic_func.func;
identifier crtc, state;
@@

  func(struct drm_crtc *crtc, struct drm_atomic_state *state) {
+ struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state, crtc);
  ...
- crtc->state
+ crtc_state
  ...
 }

@ include depends on adds_new_state || replaces_new_state @
@@

 #include <drm/drm_atomic.h>

@ no_include depends on !include && (adds_new_state || replaces_new_state) @
@@

+ #include <drm/drm_atomic.h>
  #include <drm/...>

Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: "James (Qian) Wang" <james.qian.wang@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Mihail Atanassov <mihail.atanassov@arm.com>
Cc: Brian Starkey <brian.starkey@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sandy Huang <hjc@rock-chips.com>
Cc: "Heiko Stübner" <heiko@sntech.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201105164518.392891-1-maxime@cerno.tech
Stable-dep-of: fe4c5f662097 ("drm/mediatek: Add spinlock for setting vblank event in atomic_begin")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c |  4 +++-
 drivers/gpu/drm/armada/armada_crtc.c             |  8 ++++++--
 drivers/gpu/drm/ast/ast_mode.c                   |  4 +++-
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c        |  7 +++++--
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c          | 15 +++++++++------
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c      |  6 ++++--
 drivers/gpu/drm/tegra/dc.c                       |  8 +++++---
 drivers/gpu/drm/virtio/virtgpu_display.c         |  4 +++-
 8 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
index 3c77eeb0a7a0c..db995250cbff6 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
@@ -381,10 +381,12 @@ static void
 komeda_crtc_atomic_flush(struct drm_crtc *crtc,
 			 struct drm_atomic_state *state)
 {
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
 	struct drm_crtc_state *old = drm_atomic_get_old_crtc_state(state,
 								   crtc);
 	/* commit with modeset will be handled in enable/disable */
-	if (drm_atomic_crtc_needs_modeset(crtc->state))
+	if (drm_atomic_crtc_needs_modeset(crtc_state))
 		return;
 
 	komeda_crtc_do_flush(crtc, old);
diff --git a/drivers/gpu/drm/armada/armada_crtc.c b/drivers/gpu/drm/armada/armada_crtc.c
index 13c7c474fb26e..8b7cc7bc81ee4 100644
--- a/drivers/gpu/drm/armada/armada_crtc.c
+++ b/drivers/gpu/drm/armada/armada_crtc.c
@@ -429,11 +429,13 @@ static int armada_drm_crtc_atomic_check(struct drm_crtc *crtc,
 static void armada_drm_crtc_atomic_begin(struct drm_crtc *crtc,
 					 struct drm_atomic_state *state)
 {
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
 	struct armada_crtc *dcrtc = drm_to_armada_crtc(crtc);
 
 	DRM_DEBUG_KMS("[CRTC:%d:%s]\n", crtc->base.id, crtc->name);
 
-	if (crtc->state->color_mgmt_changed)
+	if (crtc_state->color_mgmt_changed)
 		armada_drm_update_gamma(crtc);
 
 	dcrtc->regs_idx = 0;
@@ -443,6 +445,8 @@ static void armada_drm_crtc_atomic_begin(struct drm_crtc *crtc,
 static void armada_drm_crtc_atomic_flush(struct drm_crtc *crtc,
 					 struct drm_atomic_state *state)
 {
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
 	struct armada_crtc *dcrtc = drm_to_armada_crtc(crtc);
 
 	DRM_DEBUG_KMS("[CRTC:%d:%s]\n", crtc->base.id, crtc->name);
@@ -453,7 +457,7 @@ static void armada_drm_crtc_atomic_flush(struct drm_crtc *crtc,
 	 * If we aren't doing a full modeset, then we need to queue
 	 * the event here.
 	 */
-	if (!drm_atomic_crtc_needs_modeset(crtc->state)) {
+	if (!drm_atomic_crtc_needs_modeset(crtc_state)) {
 		dcrtc->update_pending = true;
 		armada_drm_crtc_queue_state_event(crtc);
 		spin_lock_irq(&dcrtc->irq_lock);
diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 84c2e90d415f4..7f3f961035872 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -780,10 +780,12 @@ static void
 ast_crtc_helper_atomic_flush(struct drm_crtc *crtc,
 			     struct drm_atomic_state *state)
 {
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
 	struct drm_crtc_state *old_crtc_state = drm_atomic_get_old_crtc_state(state,
 									      crtc);
 	struct ast_private *ast = to_ast_private(crtc->dev);
-	struct ast_crtc_state *ast_crtc_state = to_ast_crtc_state(crtc->state);
+	struct ast_crtc_state *ast_crtc_state = to_ast_crtc_state(crtc_state);
 	struct ast_crtc_state *old_ast_crtc_state = to_ast_crtc_state(old_crtc_state);
 
 	/*
diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index 6d56b701118da..784a91d32bd1e 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -289,11 +289,13 @@ ingenic_drm_crtc_mode_valid(struct drm_crtc *crtc, const struct drm_display_mode
 static void ingenic_drm_crtc_atomic_begin(struct drm_crtc *crtc,
 					  struct drm_atomic_state *state)
 {
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
 	struct ingenic_drm *priv = drm_crtc_get_priv(crtc);
 	u32 ctrl = 0;
 
 	if (priv->soc_info->has_osd &&
-	    drm_atomic_crtc_needs_modeset(crtc->state)) {
+	    drm_atomic_crtc_needs_modeset(crtc_state)) {
 		/*
 		 * If IPU plane is enabled, enable IPU as source for the F1
 		 * plane; otherwise use regular DMA.
@@ -310,7 +312,8 @@ static void ingenic_drm_crtc_atomic_flush(struct drm_crtc *crtc,
 					  struct drm_atomic_state *state)
 {
 	struct ingenic_drm *priv = drm_crtc_get_priv(crtc);
-	struct drm_crtc_state *crtc_state = crtc->state;
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
 	struct drm_pending_vblank_event *event = crtc_state->event;
 
 	if (drm_atomic_crtc_needs_modeset(crtc_state)) {
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 067b4dc39f4f0..380b0b52d2c7a 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -11,6 +11,7 @@
 #include <asm/barrier.h>
 #include <soc/mediatek/smi.h>
 
+#include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
 #include <drm/drm_probe_helper.h>
@@ -580,17 +581,19 @@ static void mtk_drm_crtc_atomic_disable(struct drm_crtc *crtc,
 static void mtk_drm_crtc_atomic_begin(struct drm_crtc *crtc,
 				      struct drm_atomic_state *state)
 {
-	struct mtk_crtc_state *crtc_state = to_mtk_crtc_state(crtc->state);
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
+	struct mtk_crtc_state *mtk_crtc_state = to_mtk_crtc_state(crtc_state);
 	struct mtk_drm_crtc *mtk_crtc = to_mtk_crtc(crtc);
 
-	if (mtk_crtc->event && crtc_state->base.event)
+	if (mtk_crtc->event && mtk_crtc_state->base.event)
 		DRM_ERROR("new event while there is still a pending event\n");
 
-	if (crtc_state->base.event) {
-		crtc_state->base.event->pipe = drm_crtc_index(crtc);
+	if (mtk_crtc_state->base.event) {
+		mtk_crtc_state->base.event->pipe = drm_crtc_index(crtc);
 		WARN_ON(drm_crtc_vblank_get(crtc) != 0);
-		mtk_crtc->event = crtc_state->base.event;
-		crtc_state->base.event = NULL;
+		mtk_crtc->event = mtk_crtc_state->base.event;
+		mtk_crtc_state->base.event = NULL;
 	}
 }
 
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index b7eeb3183aa94..0a20fe4200b3d 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1257,6 +1257,8 @@ static void vop_crtc_gamma_set(struct vop *vop, struct drm_crtc *crtc,
 static void vop_crtc_atomic_begin(struct drm_crtc *crtc,
 				  struct drm_atomic_state *state)
 {
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
 	struct drm_crtc_state *old_crtc_state = drm_atomic_get_old_crtc_state(state,
 									      crtc);
 	struct vop *vop = to_vop(crtc);
@@ -1265,8 +1267,8 @@ static void vop_crtc_atomic_begin(struct drm_crtc *crtc,
 	 * Only update GAMMA if the 'active' flag is not changed,
 	 * otherwise it's updated by .atomic_enable.
 	 */
-	if (crtc->state->color_mgmt_changed &&
-	    !crtc->state->active_changed)
+	if (crtc_state->color_mgmt_changed &&
+	    !crtc_state->active_changed)
 		vop_crtc_gamma_set(vop, crtc, old_crtc_state);
 }
 
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index f1e8951fa86c4..093ac01ac3d90 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1945,15 +1945,17 @@ static void tegra_crtc_atomic_begin(struct drm_crtc *crtc,
 static void tegra_crtc_atomic_flush(struct drm_crtc *crtc,
 				    struct drm_atomic_state *state)
 {
-	struct tegra_dc_state *crtc_state = to_dc_state(crtc->state);
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
+	struct tegra_dc_state *dc_state = to_dc_state(crtc_state);
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	u32 value;
 
-	value = crtc_state->planes << 8 | GENERAL_UPDATE;
+	value = dc_state->planes << 8 | GENERAL_UPDATE;
 	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
 	value = tegra_dc_readl(dc, DC_CMD_STATE_CONTROL);
 
-	value = crtc_state->planes | GENERAL_ACT_REQ;
+	value = dc_state->planes | GENERAL_ACT_REQ;
 	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
 	value = tegra_dc_readl(dc, DC_CMD_STATE_CONTROL);
 }
diff --git a/drivers/gpu/drm/virtio/virtgpu_display.c b/drivers/gpu/drm/virtio/virtgpu_display.c
index fcbb0a6cdb173..9af912fc2426b 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -119,6 +119,8 @@ static int virtio_gpu_crtc_atomic_check(struct drm_crtc *crtc,
 static void virtio_gpu_crtc_atomic_flush(struct drm_crtc *crtc,
 					 struct drm_atomic_state *state)
 {
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
 	struct virtio_gpu_output *output = drm_crtc_to_virtio_gpu_output(crtc);
 
 	/*
@@ -127,7 +129,7 @@ static void virtio_gpu_crtc_atomic_flush(struct drm_crtc *crtc,
 	 * in the plane update callback, and here we just check
 	 * whenever we must force the modeset.
 	 */
-	if (drm_atomic_crtc_needs_modeset(crtc->state)) {
+	if (drm_atomic_crtc_needs_modeset(crtc_state)) {
 		output->needs_modeset = true;
 	}
 }
-- 
2.43.0



