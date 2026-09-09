Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F758FD1F;
	Wed,  9 Sep 2026 14:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964432; cv=none; b=nPahJ+aSJVOM7hw0x8yrTnyjEAMpmdYwERDldLDZZ3mk5MOzUDnbEU44k3JG7vOFQUJAfvjPXDE1xOnGFoX1boWnpI+vgBwolpo0qVoN4DkIb4tw8pRWL1bxdhv/uhdKj1kkrJr81golO6N0OVzs6cFW9aRBLDsu05i/bDVYv7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964432; c=relaxed/simple;
	bh=osvYI3uWXr+w61ImkW64CGGIo2hK8wmL+1g6iQfSB8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbqNfDXm/a82bhu52pRciqVvYRRdaXQ/3VjK9t0oIjsru1Qk+Sd4CGHSSQpD8PgywMURlNBsg30/r9asRvGUaZxnU2HU3QnwvVBHsDBwujZ15+AWvl0MPOUbgT340HmsI3VL9Clhj6+gt+GuGafG2nz7vrrE6Blgkhe1yjzT1qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AddohWsD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AddohWsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E881F00A3A;
	Wed,  9 Sep 2026 14:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964430;
	bh=DgnXoRTC3ylbzimpApEn18Nqyo7+u+y+2QPSHJVXpz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AddohWsDld9iNPtbdVZRbYZb/KhJ8L5ltUQ+UH8bp18/N6wX9V4n1Wc67FPeJFamR
	 P5P2YdlY0zL0y+/QWsXbxD4tOVHdXYhjphcsSTrfobpVgc19E5Rtbb/lpB7ITh8350
	 xkfTVuXTdWP0SN2qysaaB72rW1tigWv3GBG8x8WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 420/583] drm/nouveau/disp: fix head state readback on GB20x
Date: Wed,  9 Sep 2026 15:41:45 +0200
Message-ID: <20260909134252.525048587@linuxfoundation.org>
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

commit 9421dfe912e55360e6b9301a110acb00df7e7320 upstream.

The GSP path reads armed head state and the RG scanout position through
gv100_head_state() and gv100_head_rgpos() on every generation.
gv100_head_state() reads the core channel's state mirror at a 0x400
per-head stride, which NVD5.0 (GB20x) doubled. Per NVIDIA's published
CA7D class header every HEAD_SET method sits at 0x2000 + head * 0x800,
while the mirror bases are unchanged (assembly at 0x680000, armed at
+0x8000, per OpenRM's v03_00 channel-user-base HAL which is still used on
DISPv0502).

Add gb202_head_state(), the same readback at the 0x800 stride, and a
gb202_gsp_head table to supply it.
gv100_head_rgpos() is kept. The RG registers keep their per-head 0x800
stride on NVD5.0, and OpenRM's kdispReadRgLineCountAndFrameCount_v03_00
still reads NV_PDISP_RG_DPCA on DISPv0502.

Fixes: 6cc6e08d4542 ("drm/nouveau/kms: add support for GB20x")
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260825001408.14219-8-mohamedahmedegypt2001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../gpu/drm/nouveau/nvkm/engine/disp/gb202.c  | 51 ++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c
index face801af080..765c42039a47 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c
@@ -83,6 +83,55 @@ gb202_sor_hdmi_gcp(struct nvkm_ior *sor, int head, bool enable)
 	nvkm_mask(device, 0x6f0040 + hdmi, 0x00000001, 0x00000001);
 }
 
+/* Same core-channel state mirror as gv100_head_state() (assembly at 0x680000,
+ * armed at +0x8000, per-head method offsets unchanged), but NVD5.0 spaces
+ * heads 0x800 apart (see NVCA7D_HEAD_SET_*(a) in clca7d.h).
+ */
+static void
+gb202_head_state(struct nvkm_head *head, struct nvkm_head_state *state)
+{
+	struct nvkm_device *device = head->disp->engine.subdev.device;
+	const u32 hoff = (state == &head->arm) * 0x8000 + head->id * 0x800;
+	u32 data;
+
+	data = nvkm_rd32(device, 0x682064 + hoff);
+	state->vtotal = (data & 0xffff0000) >> 16;
+	state->htotal = (data & 0x0000ffff);
+	data = nvkm_rd32(device, 0x682068 + hoff);
+	state->vsynce = (data & 0xffff0000) >> 16;
+	state->hsynce = (data & 0x0000ffff);
+	data = nvkm_rd32(device, 0x68206c + hoff);
+	state->vblanke = (data & 0xffff0000) >> 16;
+	state->hblanke = (data & 0x0000ffff);
+	data = nvkm_rd32(device, 0x682070 + hoff);
+	state->vblanks = (data & 0xffff0000) >> 16;
+	state->hblanks = (data & 0x0000ffff);
+	/* Bit 31 is ADJ1000DIV1001, not a HERTZ bit. We don't have enough bits
+	 * to add the full clock in hz on Blackwell (35 bits), but state->hz
+	 * is unused and obsolete under GSP so this is fine.
+	 */
+	state->hz = nvkm_rd32(device, 0x68200c + hoff) & 0x7fffffff;
+
+	data = nvkm_rd32(device, 0x682004 + hoff);
+	switch ((data & 0x000000f0) >> 4) {
+	case 5: state->or.depth = 30; break;
+	case 4: state->or.depth = 24; break;
+	case 1: state->or.depth = 18; break;
+	default:
+		state->or.depth = 18;
+		WARN_ON(1);
+		break;
+	}
+}
+
+static const struct nvkm_head_func
+gb202_gsp_head = {
+	.state = gb202_head_state,
+	.rgpos = gv100_head_rgpos,
+	.vblank_get = tu102_head_vblank_get,
+	.vblank_put = tu102_head_vblank_put,
+};
+
 /* GB20x is GSP-only. This table supplies the register programming the
  * GSP-RM display path needs from the chip.
  */
@@ -91,7 +140,7 @@ gb202_gsp_disp = {
 	.uevent = &gv100_disp_chan_uevent,
 	.ramht_size = 0x2000,
 	.gsp.intr = tu102_disp_intr,
-	.gsp.head = &tu102_gsp_head,
+	.gsp.head = &gb202_gsp_head,
 	.gsp.hdmi_gcp = gb202_sor_hdmi_gcp,
 	/* The legacy AVI unit is unchanged on GB20x. */
 	.gsp.hdmi_infoframe_avi = gv100_sor_hdmi_infoframe_avi,
-- 
2.55.0



