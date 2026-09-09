Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068965616DD;
	Wed,  9 Sep 2026 14:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964423; cv=none; b=OBhx5MamhUT7Q3OoGsIR8UvJnUl9JxzPab6hd3IFcyIhk0cnpkfIXuUQTW0KpEyZ+LbcScWreKzGUp7sbRiGfAp0DD0n7vVMhRl3qzdwZRT70Ya3MYTc4n1mMGi4KfXYb+uOjICblOUmUMBO44+vHduxO8idf1/T12HcQQtDs3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964423; c=relaxed/simple;
	bh=xDmOxPDksfjUq5Gw7pc73v+3ObQCu76loNAW4Vk2EmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lc5kHjOo3cU+4+xHVGNq8VgvA4jszxxK18Qiqyfojz1QYRAyP5bHUZ5I9Xc3KjKUIEEh3HmZqXye6xBjg97/QLXff3bQmNnX7/zYJK2UUft7wbXiTn6NfNQD9+NiRi5BHmzI2gP326NQKwWClv45jRcYjsrz3s73UBf6w44CSn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKYnhLU+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKYnhLU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB841F00A3A;
	Wed,  9 Sep 2026 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964421;
	bh=eSDiSlmX6kZvXYm1L8cF5wczacs3SZopwfRail8XqBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKYnhLU+LzElngxiR6BtBRDQBRQcFDOGkC/Z6g3/27LYmAedCkRfGX7h+sW7moPPE
	 0WUxFago1P6roX5GVzyav6p9Mf/SLk8CaNcEJhyOo19+qpSKtDQdi0RprwxfkjHTZs
	 48k63zeGFHak5N4WndCsWD7+0Z7vJyfmgI+gwqdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 417/583] drm/nouveau/disp: route GSP-RM display MMIO through nvkm_disp_func hooks
Date: Wed,  9 Sep 2026 15:41:42 +0200
Message-ID: <20260909134252.417543153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>

commit 9886aad51f4b5e7082209a153e404bcd8101356c upstream.

The GSP-RM display code in rm/r535/disp.c borrows a few
register-programming routines from engine/disp (the head-timing
interrupt handler, vblank enables, armed head state and scanout position
readback, the AVI/VSI infoframe writers and the GCP AVMute write) and so
far picked them by name, which means it has to know which chip it runs
on the moment a generation changes any of them.

Give nvkm_disp_func a .gsp table that each chip fills with exactly those
hooks, add tu102_gsp_disp (TU1xx) and ga102_gsp_disp (GA10x onwards)
carrying the current functions, hand them to r535_disp_new() instead of
the full hardware tables, and make rm/r535/disp.c call through the
hooks. The head hooks are a whole nvkm_head_func, so r535_head goes away
and the chip's own table is handed to nvkm_head_new_(). r535_sor_hdmi
gets infoframe forwarders, r535_sor_hdmi_audio() calls the GCP hook, and
the interrupt handler comes from the table. The tables are per chip even
though the two currently coincide, so a generation that changes a hook
only touches its own file.
rm/r535/disp.c no longer contains chip-specific register code, and a new
display generation only has to provide its own table. No functional
change.

Fixes: 6cc6e08d4542 ("drm/nouveau/kms: add support for GB20x")
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260825001408.14219-4-mohamedahmedegypt2001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/ga102.c       |   13 ++++++-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h        |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/priv.h        |   14 +++++++
 drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c       |   21 ++++++++++-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c |   31 +++++++++--------
 5 files changed, 65 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/ga102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/ga102.c
@@ -144,12 +144,23 @@ ga102_disp = {
 	},
 };
 
+static const struct nvkm_disp_func
+ga102_gsp_disp = {
+	.uevent = &gv100_disp_chan_uevent,
+	.ramht_size = 0x2000,
+	.gsp.intr = tu102_disp_intr,
+	.gsp.head = &tu102_gsp_head,
+	.gsp.hdmi_gcp = tu102_sor_hdmi_gcp,
+	.gsp.hdmi_infoframe_avi = gv100_sor_hdmi_infoframe_avi,
+	.gsp.hdmi_infoframe_vsi = gv100_sor_hdmi_infoframe_vsi,
+};
+
 int
 ga102_disp_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst,
 	       struct nvkm_disp **pdisp)
 {
 	if (nvkm_gsp_rm(device->gsp))
-		return r535_disp_new(&ga102_disp, device, type, inst, pdisp);
+		return r535_disp_new(&ga102_gsp_disp, device, type, inst, pdisp);
 
 	return nvkm_disp_new_(&ga102_disp, device, type, inst, pdisp);
 }
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h
@@ -58,6 +58,7 @@ void gv100_head_rgpos(struct nvkm_head *
 
 void tu102_head_vblank_get(struct nvkm_head *);
 void tu102_head_vblank_put(struct nvkm_head *);
+extern const struct nvkm_head_func tu102_gsp_head;
 
 #define HEAD_MSG(h,l,f,a...) do {                                              \
 	struct nvkm_head *_h = (h);                                            \
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/priv.h
@@ -5,6 +5,8 @@
 #include <engine/disp.h>
 #include <core/enum.h>
 struct nvkm_head;
+struct nvkm_head_func;
+struct nvkm_ior;
 struct nvkm_outp;
 struct dcb_output;
 
@@ -34,6 +36,18 @@ struct nvkm_disp_func {
 		int (*new)(struct nvkm_disp *, int id);
 	} wndw, head, dac, sor, pior;
 
+	/* Register programming that the GSP-RM display path (rm/r535) needs from
+	 * the chip, everything else on that path goes through RM. The hooks are
+	 * called unconditionally and the head table is handed to nvkm_head_new_().
+	 */
+	struct {
+		irqreturn_t (*intr)(struct nvkm_inth *);
+		const struct nvkm_head_func *head;
+		void (*hdmi_gcp)(struct nvkm_ior *, int head, bool enable);
+		void (*hdmi_infoframe_avi)(struct nvkm_ior *, int head, void *data, u32 size);
+		void (*hdmi_infoframe_vsi)(struct nvkm_ior *, int head, void *data, u32 size);
+	} gsp;
+
 	u16 ramht_size;
 
 	struct nvkm_sclass root;
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c
@@ -140,6 +140,14 @@ tu102_head_vblank_get(struct nvkm_head *
 	nvkm_mask(device, 0x611d80 + (head->id * 4), 0x00000002, 0x00000002);
 }
 
+const struct nvkm_head_func
+tu102_gsp_head = {
+	.state = gv100_head_state,
+	.rgpos = gv100_head_rgpos,
+	.vblank_get = tu102_head_vblank_get,
+	.vblank_put = tu102_head_vblank_put,
+};
+
 static void
 tu102_disp_intr_head_timing(struct nvkm_disp *disp, int head)
 {
@@ -295,12 +303,23 @@ tu102_disp = {
 	},
 };
 
+static const struct nvkm_disp_func
+tu102_gsp_disp = {
+	.uevent = &gv100_disp_chan_uevent,
+	.ramht_size = 0x2000,
+	.gsp.intr = tu102_disp_intr,
+	.gsp.head = &tu102_gsp_head,
+	.gsp.hdmi_gcp = tu102_sor_hdmi_gcp,
+	.gsp.hdmi_infoframe_avi = gv100_sor_hdmi_infoframe_avi,
+	.gsp.hdmi_infoframe_vsi = gv100_sor_hdmi_infoframe_vsi,
+};
+
 int
 tu102_disp_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst,
 	       struct nvkm_disp **pdisp)
 {
 	if (nvkm_gsp_rm(device->gsp))
-		return r535_disp_new(&tu102_disp, device, type, inst, pdisp);
+		return r535_disp_new(&tu102_gsp_disp, device, type, inst, pdisp);
 
 	return nvkm_disp_new_(&tu102_disp, device, type, inst, pdisp);
 }
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c
@@ -564,7 +564,19 @@ r535_sor_hdmi_audio(struct nvkm_ior *sor
 {
 	r535_sor_hdmi_ctrl_audio(sor->asy.outp, enable);
 	r535_sor_hdmi_ctrl_audio_mute(sor->asy.outp, !enable);
-	tu102_sor_hdmi_gcp(sor, head, enable);
+	sor->disp->func->gsp.hdmi_gcp(sor, head, enable);
+}
+
+static void
+r535_sor_hdmi_infoframe_avi(struct nvkm_ior *sor, int head, void *data, u32 size)
+{
+	sor->disp->func->gsp.hdmi_infoframe_avi(sor, head, data, size);
+}
+
+static void
+r535_sor_hdmi_infoframe_vsi(struct nvkm_ior *sor, int head, void *data, u32 size)
+{
+	sor->disp->func->gsp.hdmi_infoframe_vsi(sor, head, data, size);
 }
 
 static void
@@ -592,8 +604,8 @@ r535_sor_hdmi = {
 	.ctrl = r535_sor_hdmi_ctrl,
 	.scdc = r535_sor_hdmi_scdc,
 	/*TODO: SF_USER -> KMS. */
-	.infoframe_avi = gv100_sor_hdmi_infoframe_avi,
-	.infoframe_vsi = gv100_sor_hdmi_infoframe_vsi,
+	.infoframe_avi = r535_sor_hdmi_infoframe_avi,
+	.infoframe_vsi = r535_sor_hdmi_infoframe_vsi,
 	.audio = r535_sor_hdmi_audio,
 };
 
@@ -618,14 +630,6 @@ r535_sor_cnt(struct nvkm_disp *disp, uns
 	return 4;
 }
 
-static const struct nvkm_head_func
-r535_head = {
-	.state = gv100_head_state,
-	.rgpos = gv100_head_rgpos,
-	.vblank_get = tu102_head_vblank_get,
-	.vblank_put = tu102_head_vblank_put,
-};
-
 static struct nvkm_conn *
 r535_conn_new(struct nvkm_disp *disp, u32 id)
 {
@@ -1623,7 +1627,7 @@ r535_disp_oneinit(struct nvkm_disp *disp
 		nvkm_gsp_rm_ctrl_done(&disp->rm.objcom, ctrl);
 
 		for_each_set_bit(i, &disp->head.mask, disp->head.nr) {
-			ret = nvkm_head_new_(&r535_head, disp, i);
+			ret = nvkm_head_new_(disp->func->gsp.head, disp, i);
 			if (ret)
 				return ret;
 		}
@@ -1672,7 +1676,7 @@ r535_disp_oneinit(struct nvkm_disp *disp
 		return ret;
 
 	ret = nvkm_inth_add(&device->vfn->intr, ret, NVKM_INTR_PRIO_NORMAL, &disp->engine.subdev,
-			    tu102_disp_intr, &disp->engine.subdev.inth);
+			    disp->func->gsp.intr, &disp->engine.subdev.inth);
 	if (ret)
 		return ret;
 
@@ -1704,6 +1708,7 @@ r535_disp_new(const struct nvkm_disp_fun
 	rm->uevent = hw->uevent;
 	rm->sor.cnt = r535_sor_cnt;
 	rm->sor.new = r535_sor_new;
+	rm->gsp = hw->gsp;
 	rm->ramht_size = hw->ramht_size;
 
 	rm->root.oclass = gpu->disp.class.root;


