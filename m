Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D9F57267A;
	Wed,  9 Sep 2026 14:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964420; cv=none; b=lRUWKHAcV51LkTUTBNvKuzjMPlBWABwk9Noc+SSL3UZokJj8Rr5bbQk4UhVt6i5augsnhbibELDyElFRn6yghpReQHR6y/hkd0U2kuUpif1bZXpjTbkC1owctNbaTYDj6RHKTO5b45huoXVeKWKOZEasVTW9IKT1URVit2BeF2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964420; c=relaxed/simple;
	bh=pfThB44HAvibuvAFwsWWoid0PsS0PQc41yjmwMIfkM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJtVplQQAAHUwIjmqIoBjksaHbzfZqD26kEjhhdHFJBVz3xM0tFax0B9JFg5pngtA5/0kV4E635ml87OoQ0Xl6/14fQHDQe7gvLyLv1ylsKgLDXTsAYrxq99a+p4+afGg1lzKxfAKOpU/he3V7ZqwWy05STTEcN/Oo775V3RDQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5MYsNKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5MYsNKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBB41F00A3D;
	Wed,  9 Sep 2026 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964419;
	bh=a6782FgyY1HCva3lOVW4+NrSp/yoBEuWbR9i38WqhCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5MYsNKqJ4CU46l1RUxq/b2ulXPXv8IWj1cnUthM9zEe03f7HU8+5ey61DpMgsNNb
	 k7qGlYhid9DD1aNQopSqPs1wmlby15AlSislAEur8MtMne37f0LSZLMpb1lAr/6olS
	 BgdsQEJ28gHm7H5EcmQeAayEiwB8oSooBtzBH2qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 416/583] drm/nouveau/disp: move the GSP HDMI GCP AVMute write to engine/disp
Date: Wed,  9 Sep 2026 15:41:41 +0200
Message-ID: <20260909134252.386318302@linuxfoundation.org>
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


