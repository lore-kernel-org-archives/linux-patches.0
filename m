Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E67E58FD18;
	Wed,  9 Sep 2026 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964426; cv=none; b=WUwBdmNb0MkgJALRQ1dhIH+ifpWe8tsLEqoo9vxs+P6I2NiZZDssj6JaCaVhRN5vtl6ooQXumaO+Vgma0DOF4Vi/tVtzs+ZjqoUr9317AXsxkz8jaLrW4emI1KtPMI0E8jBd6M64+qJbWIzFvQQS8Lr+ln7qde8lPh20ykhqXo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964426; c=relaxed/simple;
	bh=X5P8/dteiCkVuKYiKl1Y2R017dJtngrGJVlXALDrclo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KepWesi7ZE7hN5VK5WcDGfxEtBMob263s97hgOYUN0N5zC74hLiWng7P+Uw8nvxo8rHQ99sGAgjZtqKDa+CoSGbN4PQ5lFPhOqudvVFdW/ik0lvuafJElS3GEYjMKY4mStWEVDycbo1rltBZLyFOto/ut8tA2HWds9CU6Qx/jLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9+fNlsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9+fNlsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F1D1F00A3A;
	Wed,  9 Sep 2026 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964424;
	bh=8EWgn+StpJLmcQjXSEFgqeEDH0Mb3bsLV0p8S97uVMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9+fNlsPM5Z2LUL3bg5P1JkYMNbrmWlPGqiMfWPsHibg7Lh/GITtmOs4kITnnwd60
	 7eOEM/AaehE7TsIKETSu4zA7QsOIIq1xUvMwl7y5POheveQnj0WyG+Fx4dXzFfXKRp
	 0CVgIr7AVCTGiW1y0PahMuNkuN2Si4eUwMIV6Mso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 418/583] drm/nouveau/disp: fix HDMI vendor infoframes on GB20x
Date: Wed,  9 Sep 2026 15:41:43 +0200
Message-ID: <20260909134252.453664438@linuxfoundation.org>
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

commit 92f09dcb4e8473ab25764e950994ab7b6abce6dd upstream.

The GSP path reuses the GV100 direct-MMIO infoframe writers on every
chip. On GB20x that is only half right as while the legacy SF AVI unit is
unchanged, the legacy VSI unit at 0x6f0100 was removed, so
gv100_sor_hdmi_infoframe_vsi() writes into a reserved area and no vendor
infoframe ever reaches the HW. This affects HDMI-VIC signalling which
can impact some 4K modes for legacy HDMI 1.4 sinks.

GB20x (NVDisplay 5.0+) reorganised the SF HDMI packet units. Per NVIDIA's
published C971/CA71 DISP_SF_USER class headers, only three legacy units
remain (AVI at +0x000, GCP at +0x040, ACR at +0x080), and vendor
infoframes must instead be sent through the shared generic infoframe
units at +0x130, whose 9-dword packet slots are loaded through the
shared data port at +0x3f0/+0x3f4.

Add a VSI writer using the same programming sequence OpenRM uses on
these chips (nvhdmipkt_C971.c, programAdvancedInfoframeC971()): disable
the unit and wait for it to idle, clear the SENT status, write the packet
through the data port with a zero inserted in HB3 after the three header
bytes, then enable the unit for every-frame transmission during vblank.
Generic unit 1 is used for the VSI, matching the slot assignment in
NVIDIA's nvkms (NVHDMIPKT_TYPE_SHARED_GENERIC2, unit 0 is reserved
for extended metadata packets and unit 2 for the HDR DRM infoframe,
if those are wired up later).

GB20x so far shared GA10x's display entry point. Give it its own,
gb202_disp_new(), with a gb202_gsp_disp table that supplies the VSI
writer to the GSP path and otherwise carries the same hooks as GA10x.
The following fixes fill in the rest of the GB20x differences there.

Fixes: 6cc6e08d4542 ("drm/nouveau/kms: add support for GB20x")
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260825001408.14219-5-mohamedahmedegypt2001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/include/nvkm/engine/disp.h |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |   10 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/Kbuild    |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c   |   88 +++++++++++++++++++++
 4 files changed, 95 insertions(+), 5 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c

--- a/drivers/gpu/drm/nouveau/include/nvkm/engine/disp.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/engine/disp.h
@@ -87,4 +87,5 @@ int gp102_disp_new(struct nvkm_device *,
 int gv100_disp_new(struct nvkm_device *, enum nvkm_subdev_type, int inst, struct nvkm_disp **);
 int tu102_disp_new(struct nvkm_device *, enum nvkm_subdev_type, int inst, struct nvkm_disp **);
 int ga102_disp_new(struct nvkm_device *, enum nvkm_subdev_type, int inst, struct nvkm_disp **);
+int gb202_disp_new(struct nvkm_device *, enum nvkm_subdev_type, int inst, struct nvkm_disp **);
 #endif
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2844,7 +2844,7 @@ nv1b2_chipset = {
 	.pci      = { 0x00000001, gh100_pci_new },
 	.timer    = { 0x00000001, gk20a_timer_new },
 	.vfn      = { 0x00000001, ga100_vfn_new },
-	.disp     = { 0x00000001, ga102_disp_new },
+	.disp     = { 0x00000001, gb202_disp_new },
 	.fifo     = { 0x00000001, ga102_fifo_new },
 };
 
@@ -2860,7 +2860,7 @@ nv1b3_chipset = {
 	.pci      = { 0x00000001, gh100_pci_new },
 	.timer    = { 0x00000001, gk20a_timer_new },
 	.vfn      = { 0x00000001, ga100_vfn_new },
-	.disp     = { 0x00000001, ga102_disp_new },
+	.disp     = { 0x00000001, gb202_disp_new },
 	.fifo     = { 0x00000001, ga102_fifo_new },
 };
 
@@ -2876,7 +2876,7 @@ nv1b5_chipset = {
 	.pci      = { 0x00000001, gh100_pci_new },
 	.timer    = { 0x00000001, gk20a_timer_new },
 	.vfn      = { 0x00000001, ga100_vfn_new },
-	.disp     = { 0x00000001, ga102_disp_new },
+	.disp     = { 0x00000001, gb202_disp_new },
 	.fifo     = { 0x00000001, ga102_fifo_new },
 };
 
@@ -2892,7 +2892,7 @@ nv1b6_chipset = {
 	.pci      = { 0x00000001, gh100_pci_new },
 	.timer    = { 0x00000001, gk20a_timer_new },
 	.vfn      = { 0x00000001, ga100_vfn_new },
-	.disp     = { 0x00000001, ga102_disp_new },
+	.disp     = { 0x00000001, gb202_disp_new },
 	.fifo     = { 0x00000001, ga102_fifo_new },
 };
 
@@ -2908,7 +2908,7 @@ nv1b7_chipset = {
 	.pci      = { 0x00000001, gh100_pci_new },
 	.timer    = { 0x00000001, gk20a_timer_new },
 	.vfn      = { 0x00000001, ga100_vfn_new },
-	.disp     = { 0x00000001, ga102_disp_new },
+	.disp     = { 0x00000001, gb202_disp_new },
 	.fifo     = { 0x00000001, ga102_fifo_new },
 };
 
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/Kbuild
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/Kbuild
@@ -27,6 +27,7 @@ nvkm-y += nvkm/engine/disp/gp102.o
 nvkm-y += nvkm/engine/disp/gv100.o
 nvkm-y += nvkm/engine/disp/tu102.o
 nvkm-y += nvkm/engine/disp/ga102.o
+nvkm-y += nvkm/engine/disp/gb202.o
 
 nvkm-y += nvkm/engine/disp/udisp.o
 nvkm-y += nvkm/engine/disp/uconn.o
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright 2026 Valve Corp.
+ */
+#include "priv.h"
+#include "head.h"
+#include "ior.h"
+
+#include <subdev/timer.h>
+
+/* GB20x (NVD5.0) reorganised the SF HDMI packet units. The AVI unit is
+ * unchanged from GV100, but the legacy VSI unit is gone. Vendor infoframes
+ * are sent through the shared generic infoframe units instead. Register
+ * layout per NVIDIA's clc971.h/clca71.h, programming sequence per
+ * nvhdmipkt_C971.c:programAdvancedInfoframeC971().
+ */
+static void
+gb202_sor_hdmi_infoframe_vsi(struct nvkm_ior *ior, int head, void *data, u32 size)
+{
+	struct nvkm_device *device = ior->disp->engine.subdev.device;
+	const u32 hoff = head * 0x400;
+	/* Generic infoframe unit 1, the slot NVIDIA's driver uses for the VSI. */
+	const u32 ctrl = 0x6f0138 + hoff;
+	u8 buf[36] = {};
+	int i;
+
+	/* Disable the unit and wait for it to go idle. */
+	nvkm_mask(device, ctrl, 0x00000001, 0x00000000);
+	if (nvkm_msec(device, 2000,
+		if (!(nvkm_rd32(device, ctrl) & 0x00400000))
+			break;
+	) < 0)
+		return;
+
+	if (!size)
+		return;
+
+	/* Clear SENT status, and point the data port at unit 1's slot. */
+	nvkm_mask(device, ctrl, 0x00800000, 0x00800000);
+	nvkm_wr32(device, 0x6f03f0 + hoff, 0x00000001);
+
+	/* The data port takes the raw packet, except that a zero is inserted
+	 * in HB3 after the three header bytes. A slot is 9 dwords (HB0-3 plus
+	 * up to 32 payload bytes). An HDMI infoframe carries at most PB0-27,
+	 * so the tail stays zero, and we always write the whole slot.
+	 */
+	size = min_t(u32, size, 31);
+	memcpy(buf, data, min_t(u32, size, 3));
+	if (size > 3)
+		memcpy(&buf[4], (u8 *)data + 3, size - 3);
+
+	for (i = 0; i < 36; i += 4) {
+		nvkm_wr32(device, 0x6f03f4 + hoff, buf[i + 0] | buf[i + 1] << 8 |
+						   buf[i + 2] << 16 |
+						   (u32)buf[i + 3] << 24);
+	}
+
+	/* No flip ID or scanline matching. */
+	nvkm_wr32(device, 0x6f013c + hoff, 0x00000000);
+
+	/* ENABLE | RUN_MODE=ALWAYS | LOC=VBLANK | OFFSET=1 | SIZE=0. */
+	nvkm_wr32(device, ctrl, 0x00000041);
+
+	/* Audio priority low (the init value). */
+	nvkm_wr32(device, 0x6f03f8 + hoff, 0x00000002);
+}
+
+/* GB20x is GSP-only. This table supplies the register programming the
+ * GSP-RM display path needs from the chip.
+ */
+static const struct nvkm_disp_func
+gb202_gsp_disp = {
+	.uevent = &gv100_disp_chan_uevent,
+	.ramht_size = 0x2000,
+	.gsp.intr = tu102_disp_intr,
+	.gsp.head = &tu102_gsp_head,
+	.gsp.hdmi_gcp = tu102_sor_hdmi_gcp,
+	/* The legacy AVI unit is unchanged on GB20x. */
+	.gsp.hdmi_infoframe_avi = gv100_sor_hdmi_infoframe_avi,
+	.gsp.hdmi_infoframe_vsi = gb202_sor_hdmi_infoframe_vsi,
+};
+
+int
+gb202_disp_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst,
+	       struct nvkm_disp **pdisp)
+{
+	return r535_disp_new(&gb202_gsp_disp, device, type, inst, pdisp);
+}


