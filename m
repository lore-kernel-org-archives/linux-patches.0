Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77E854B1C6;
	Wed,  9 Sep 2026 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963162; cv=none; b=HjBs/MhmPkCTRUzxP++yhUdJYSIE2eUpoSaVqIMsS+yb9clj1HGtaGlVAt04el4hzB3cd7ARFqdWvzfBZmsqQjQU6GvHkkXrCedB1jtd9o7qnCfikwj++JTAMQaNfsf09H07W5g2shWB6iuTLbZY0YqFRvDpzhsbAE9mPD9TRnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963162; c=relaxed/simple;
	bh=uiMT1ufeSAHmU8v2OiPM4ekJ8DHOCzooE0DmB85pE38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3XQzKVkxK+jXvLNyLlIcYKPlD2HUKBAlEjsXw0l3J0J72jqxmxElOSH3u5jdbhL8BXLHAamKYKUS9s3sQY3A0m5Ot7+qYROi4RgovLd+6kMLe/4imaXppSSp1T/watJZgYSQqAgI82T1bLDxBFoSrbZHLeipb8qYw964hOst6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZk7cEHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZk7cEHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DACE1F00A3A;
	Wed,  9 Sep 2026 14:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963160;
	bh=9u4H/IGkJMhRZV1lEV8YAF7Ntuk8rCl5wTKOFbhipoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZk7cEHbPnisMFDuGnthfYkczOxII6mvYv+ko9/cLr7dSmZ+28159N1ftKUPfTmy+
	 zP5CbJfQhilqEwDaYWQ8+tIJYOSYy3BCazAkJ4QfoR44VshslML+pbJ2G5IHmpEoKf
	 P5OaPpqjS49zT/4PYN+speH8+VyxU/uPBp4xBL3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.2 540/556] drm/nouveau/gsp: fix vblank interrupts on GB20x
Date: Wed,  9 Sep 2026 15:43:40 +0200
Message-ID: <20260909134249.392181667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>

commit 5bb489b333237c1bf63a891a4362986253a0060a upstream.

The GSP path programs per-head timing (vblank) interrupts the same way on
every generation. NVD5.0 (GB20x) reworked the FE interrupt frontend
around four message-based kernel vectors (high latency, low latency, PMU,
and GSP) and moved RM head-timing interrupts to the dedicated low-latency
vector:

 - The enable is NV_PDISP_FE_RM_INTR_EN1_HEAD_TIMING, 0x611ef0 +
   head*4 (570.144 kernel_head_0501.c, renamed kernel_head_0502.c from
   575.51.02 on, and v05_01 dev_disp.h).

 - The vector is reported as a separate interrupt table entry,
   MC_ENGINE_IDX_DISP_LOW (intr_gb202.c, intrCacheDispIntrVectors).

 - The vector must be re-armed through NV_PDISP_FE_INTR_RETRIGGER(1)
   at 0x611f34 after servicing (kdispServiceInterrupt ->
   kdispIntrRetrigger_v05_01).

The event latch (0x611800), per-head status (0x611c00), and dispatch
summary (0x611ec0) the interrupt handler uses are unchanged on GB20x
(kheadReadPendingVblank_v03_00 and kheadResetPendingLastData_v03_00
remain for DISPv0502+).

On GB20x the old code enables head timing onto the legacy vector, leaves
its handler there, and never re-arms the message-based vectors. Page
flips still complete (nv50 sends those events from the commit path), so
the desktop looks fine while DRM vblank waits and vblank sequence queries
are affected.

Supply GB20x vblank enables and an interrupt handler that re-arms the
vector after servicing through gb202_gsp_disp, translate the low-latency
interrupt table entry as a second NVKM_ENGINE_DISP instance, and add a
gsp.intr_low_latency flag so r535_disp_oneinit() attaches the handler to
that instance. GB20x was the last cross-file user of the TU1xx vblank
enables, so make those static and drop their head.h prototypes.

Fixes: 6cc6e08d4542 ("drm/nouveau/kms: add support for GB20x")
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260825001408.14219-9-mohamedahmedegypt2001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c       |   42 +++++++++++++++--
 drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h        |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/priv.h        |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c       |    4 -
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c |   10 +++-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c  |    9 +++
 6 files changed, 61 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c
@@ -124,12 +124,46 @@ gb202_head_state(struct nvkm_head *head,
 	}
 }
 
+/* NVD5.0 (GB20x and later) moved the RM head-timing interrupt enable to
+ * the low-latency vector's EN1 block. The event latch is unchanged.
+ */
+static void
+gb202_head_vblank_put(struct nvkm_head *head)
+{
+	struct nvkm_device *device = head->disp->engine.subdev.device;
+
+	nvkm_mask(device, 0x611ef0 + (head->id * 4), 0x00000002, 0x00000000);
+}
+
+static void
+gb202_head_vblank_get(struct nvkm_head *head)
+{
+	struct nvkm_device *device = head->disp->engine.subdev.device;
+
+	nvkm_wr32(device, 0x611800 + (head->id * 4), 0x00000002);
+	nvkm_mask(device, 0x611ef0 + (head->id * 4), 0x00000002, 0x00000002);
+}
+
+static irqreturn_t
+gb202_disp_intr(struct nvkm_inth *inth)
+{
+	struct nvkm_disp *disp = container_of(inth, typeof(*disp), engine.subdev.inth);
+	irqreturn_t ret = tu102_disp_intr(inth);
+
+	/* The FE interrupt vectors are message-based on NVD5.0. Re-arm the
+	 * low-latency vector so it fires again for any event that latched
+	 * while we were servicing.
+	 */
+	nvkm_wr32(disp->engine.subdev.device, 0x611f34, 0x00000001);
+	return ret;
+}
+
 static const struct nvkm_head_func
 gb202_gsp_head = {
 	.state = gb202_head_state,
 	.rgpos = gv100_head_rgpos,
-	.vblank_get = tu102_head_vblank_get,
-	.vblank_put = tu102_head_vblank_put,
+	.vblank_get = gb202_head_vblank_get,
+	.vblank_put = gb202_head_vblank_put,
 };
 
 /* GB20x is GSP-only. This table supplies the register programming the
@@ -139,7 +173,9 @@ static const struct nvkm_disp_func
 gb202_gsp_disp = {
 	.uevent = &gv100_disp_chan_uevent,
 	.ramht_size = 0x2000,
-	.gsp.intr = tu102_disp_intr,
+	/* Head timing arrives on the dedicated low-latency vector. */
+	.gsp.intr = gb202_disp_intr,
+	.gsp.intr_low_latency = true,
 	.gsp.head = &gb202_gsp_head,
 	.gsp.hdmi_gcp = gb202_sor_hdmi_gcp,
 	/* The legacy AVI unit is unchanged on GB20x. */
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h
@@ -56,8 +56,6 @@ int gv100_head_new(struct nvkm_disp *, i
 void gv100_head_state(struct nvkm_head *head, struct nvkm_head_state *state);
 void gv100_head_rgpos(struct nvkm_head *head, u16 *hline, u16 *vline);
 
-void tu102_head_vblank_get(struct nvkm_head *);
-void tu102_head_vblank_put(struct nvkm_head *);
 extern const struct nvkm_head_func tu102_gsp_head;
 
 #define HEAD_MSG(h,l,f,a...) do {                                              \
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/priv.h
@@ -42,6 +42,8 @@ struct nvkm_disp_func {
 	 */
 	struct {
 		irqreturn_t (*intr)(struct nvkm_inth *);
+		/* Head-timing interrupts arrive on a second DISP vector. */
+		bool intr_low_latency;
 		const struct nvkm_head_func *head;
 		void (*hdmi_gcp)(struct nvkm_ior *, int head, bool enable);
 		void (*hdmi_infoframe_avi)(struct nvkm_ior *, int head, void *data, u32 size);
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c
@@ -123,7 +123,7 @@ tu102_sor_new(struct nvkm_disp *disp, in
  * enables to us. These program the RM head-timing line (bit 1 of the
  * per-head enable, not the bit nvkm's own gv100 path uses).
  */
-void
+static void
 tu102_head_vblank_put(struct nvkm_head *head)
 {
 	struct nvkm_device *device = head->disp->engine.subdev.device;
@@ -131,7 +131,7 @@ tu102_head_vblank_put(struct nvkm_head *
 	nvkm_mask(device, 0x611d80 + (head->id * 4), 0x00000002, 0x00000000);
 }
 
-void
+static void
 tu102_head_vblank_get(struct nvkm_head *head)
 {
 	struct nvkm_device *device = head->disp->engine.subdev.device;
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c
@@ -1671,7 +1671,15 @@ r535_disp_oneinit(struct nvkm_disp *disp
 	if (ret)
 		return ret;
 
-	ret = nvkm_gsp_intr_stall(gsp, disp->engine.subdev.type, disp->engine.subdev.inst);
+	/* Chips that raise head-timing interrupts on a separate low-latency
+	 * vector report it as a second DISP interrupt table entry, exposed
+	 * as instance 1 by the RM engine-index translation (see
+	 * r570_gsp_xlat_mc_engine_idx()). Their high-latency vector
+	 * (instance 0) is left unhandled as no event nouveau enables is
+	 * routed to it, and without a handler it stays masked.
+	 */
+	ret = nvkm_gsp_intr_stall(gsp, disp->engine.subdev.type,
+				  disp->func->gsp.intr_low_latency ? 1 : disp->engine.subdev.inst);
 	if (ret < 0)
 		return ret;
 
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c
@@ -44,6 +44,15 @@ r570_gsp_xlat_mc_engine_idx(u32 mc_engin
 		*ptype = NVKM_ENGINE_DISP;
 		*pinst = 0;
 		return true;
+	case MC_ENGINE_IDX_DISP_LOW:
+		/* GB20x+ report a separate low-latency display vector, used
+		 * for head-timing interrupts. Expose it as a second DISP
+		 * interrupt instance. r535_disp_oneinit() attaches the
+		 * handler to it when the chip's gsp.intr_low_latency is set.
+		 */
+		*ptype = NVKM_ENGINE_DISP;
+		*pinst = 1;
+		return true;
 	case MC_ENGINE_IDX_CE0 ... MC_ENGINE_IDX_CE19:
 		*ptype = NVKM_ENGINE_CE;
 		*pinst = mc_engine_idx - MC_ENGINE_IDX_CE0;


