Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19540569F19;
	Wed,  9 Sep 2026 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963144; cv=none; b=dnOflT4yCaAtIcsTPAvcJSEqaDXFsr8SJ5s9aNmxTokSMtj7J82nhXexnZl7/JIB6gwplUyVryXw+bYnGrRO+XeU6Wv+eut3lLQeb1DnrBknr9haOnL0N2qOP40RH333oxsitDkmmGnsMJtrQj2VzbG4HCECALh4wdPnPhhUr0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963144; c=relaxed/simple;
	bh=/+rVsyOYuJivh8cig9rPz8v8u/tUoRyvfl8isfaB0qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhPMbIn63v9ExeHiBexgGvQYhtoEQtJM+Ur5+X8pJS1lU5ON05ok5JJA2zXBLWmm4+Y/jkesA5vQDpv6Q88gxHEbz6MMWKmwLumafbKuH43Wnqp87q+Uvtrj+0kIdyaW2//caq7mQ2cRQzLuYbg2OT8o1VcDvZ2unwl9x1IYDHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmD93dsh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmD93dsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047101F00A3A;
	Wed,  9 Sep 2026 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963142;
	bh=c2pfqNa7Oul64rH4xWOrzeRbQat5pC9VImhOBPr0wlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmD93dsh0EG+kW0x2UPabRi2D1JBdnjtBWLYo/cL5pESYKsL9KteJxTRzEynxWbKA
	 GeIUeZyalRBS9ss3AKVmo2S1MCLQ+jHhQZ1srIJwQD8h7tRG3sLGfYX33oRqLUVFG1
	 3xdPn6KvWZzI2DFzWotWd6p5iVCzd+55bAkAz9kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.2 535/556] drm/nouveau/disp: move the GSP HDMI GCP AVMute write to engine/disp
Date: Wed,  9 Sep 2026 15:43:35 +0200
Message-ID: <20260909134249.218376110@linuxfoundation.org>
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

commit eb1ffc3dc72d379a41e367a44b99fb61a15bf8ba upstream.

r535_sor_hdmi_audio() pairs two RM controls (a SET_OD_PACKET carrying
the same General Control Packet, and the audio mute-stream toggle)
with a direct write of the GCP AVMute bit through the SF GCP unit.
The controls are RM and stay, but the direct write is register
programming and moves next to the other per-chip display code as
tu102_sor_hdmi_gcp(). No functional change.

Fixes: 6cc6e08d4542 ("drm/nouveau/kms: add support for GB20x")
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260825001408.14219-3-mohamedahmedegypt2001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/ior.h         |    1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c       |   15 +++++++++++++++
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c |    9 +--------
 3 files changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/ior.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/ior.h
@@ -194,6 +194,7 @@ void gv100_sor_dp_audio_sym(struct nvkm_
 void gv100_sor_dp_watermark(struct nvkm_ior *, int, u8);
 extern const struct nvkm_ior_func_hda gv100_sor_hda;
 
+void tu102_sor_hdmi_gcp(struct nvkm_ior *, int, bool);
 void tu102_sor_dp_vcpi(struct nvkm_ior *, int, u8, u8, u16, u16);
 
 int nv50_pior_cnt(struct nvkm_disp *, unsigned long *);
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c
@@ -30,6 +30,21 @@
 
 #include <nvif/class.h>
 
+/* General Control Packet: bracket an audio enable/disable with AVMute
+ * through the legacy GCP SF unit. Used by the GSP-RM path, which sends the
+ * equivalent packet via RM as well but keeps the direct write in sync.
+ */
+void
+tu102_sor_hdmi_gcp(struct nvkm_ior *sor, int head, bool enable)
+{
+	struct nvkm_device *device = sor->disp->engine.subdev.device;
+	const u32 hdmi = head * 0x400;
+
+	nvkm_mask(device, 0x6f00c0 + hdmi, 0x00000001, 0x00000000);
+	nvkm_wr32(device, 0x6f00cc + hdmi, !enable ? 0x00000001 : 0x00000010);
+	nvkm_mask(device, 0x6f00c0 + hdmi, 0x00000001, 0x00000001);
+}
+
 void
 tu102_sor_dp_vcpi(struct nvkm_ior *sor, int head, u8 slot, u8 slot_nr, u16 pbn, u16 aligned)
 {
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c
@@ -562,16 +562,9 @@ r535_sor_hdmi_ctrl_audio(struct nvkm_out
 static void
 r535_sor_hdmi_audio(struct nvkm_ior *sor, int head, bool enable)
 {
-	struct nvkm_device *device = sor->disp->engine.subdev.device;
-	const u32 hdmi = head * 0x400;
-
 	r535_sor_hdmi_ctrl_audio(sor->asy.outp, enable);
 	r535_sor_hdmi_ctrl_audio_mute(sor->asy.outp, !enable);
-
-	/* General Control (GCP). */
-	nvkm_mask(device, 0x6f00c0 + hdmi, 0x00000001, 0x00000000);
-	nvkm_wr32(device, 0x6f00cc + hdmi, !enable ? 0x00000001 : 0x00000010);
-	nvkm_mask(device, 0x6f00c0 + hdmi, 0x00000001, 0x00000001);
+	tu102_sor_hdmi_gcp(sor, head, enable);
 }
 
 static void


