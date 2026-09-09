Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEB6577E3A;
	Wed,  9 Sep 2026 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964429; cv=none; b=mIKEHCVqzt5lm376Bvq2oXXqL8CX48ed6YSioC1tFZv+XHFNrErcA/uOEFyShSKbR/fI7vp5H0pqagdhFlOGVHZ+WL6yDRg9e+y+WjiysXAwC7RIN8BS9YsRH8k0FDaIQIejX6k3koXMwQcTWgGIvy2YTtl+9GayJOTvhr95zbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964429; c=relaxed/simple;
	bh=YhBA1+MPGVvVN0FRN6TLCo7bRyXshiSBdlN9UhNf58s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEDbOkq/5B16wvpZK5Wytbna6KKRj8CaVf9Is6/o/J9f0hjU8Xcnn2dHt+3A8jLWmSTs1iRFdBVlCkEKR8ZwVCcUcG+2SDweJnDPsob2Z/baJieYhkriHmKEZH3i11zU5pVC5yocM59Ng9cGHm+fWMA8oA1760lZ1Uo4g8+SYtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZNNo4Lg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZNNo4Lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E721F00A3A;
	Wed,  9 Sep 2026 14:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964427;
	bh=UG/SW9CaHDlvcq7Z538UD4TeqZLeosZCk1UHY3EBV/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZNNo4Lg1uZUbG94HadT/Ad2oXHru75+swy4/mZCjY86/HwFtdND3ya/MO78flF9r
	 wPK9lm4s6YJTS86LOV6dP6/j/nQch0VVgxWOpoRVafdrV5v5qtzFMgqOr9YI6T0Ora
	 bxYNwujuA5hbFEeoOOC5Zf3llmpefZJKrnrFpVxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 419/583] drm/nouveau/disp: fix HDMI GCP AVMute register offsets on GB20x
Date: Wed,  9 Sep 2026 15:41:44 +0200
Message-ID: <20260909134252.489722795@linuxfoundation.org>
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

commit 764deff8450c9a83e335c17c32ea258ec25bb71e upstream.

The GSP path brackets audio enablement with a General Control Packet
AVMute toggle. r535_sor_hdmi_audio() calls the gsp.hdmi_gcp hook, which
every chip so far serves with tu102_sor_hdmi_gcp() and the legacy GCP
unit at 0x6f00c0/0x6f00cc. On GB20x the SF packet units were compacted
and the old generic and VSI units are gone (ACR keeps slot 2) and the
GCP unit moved from slot 3 to slot 1 (control 0x6f0040 and subpack
0x6f004c from NVIDIA's published clc971.h. The same offsets are also
used by OpenRM's hdmiWriteGeneralCtrlPacketC871() on these chips). The
old addresses are reserved on GB20x, so the AVMute writes were silent
no-ops and mitigated only by the equivalent GCP r535_sor_hdmi_audio()
already sends through the SET_OD_PACKET RM control.

Add a GB20x GCP writer using the new offsets and hook it into
gb202_gsp_disp, keeping the direct MMIO path in sync with the hardware
as on earlier chips.

Only SB0 (the AVMute bit) is written. On NVD5.0 the subpack register also
carries SB1_CTRL (bit 24), which selects where the deep-color CD/PP
fields are generated (hardware or from the driver, with the default being
HW). hdmiWriteGeneralCtrlPacketC871() likewise writes only SB0-SB2.

Fixes: 6cc6e08d4542 ("drm/nouveau/kms: add support for GB20x")
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260825001408.14219-6-mohamedahmedegypt2001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../gpu/drm/nouveau/nvkm/engine/disp/gb202.c  | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c
index 1e40de83e2bb..face801af080 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c
@@ -65,6 +65,24 @@ gb202_sor_hdmi_infoframe_vsi(struct nvkm_ior *ior, int head, void *data, u32 siz
 	nvkm_wr32(device, 0x6f03f8 + hoff, 0x00000002);
 }
 
+/* General Control Packet AVMute bracket. The GCP unit moved to slot 1 on
+ * NVD5.0. Only SB0 (the AVMute bit) is ours to write so we must not do a
+ * full write here: SB1 carries the deep-color CD/PP fields, and SB1_CTRL
+ * (bit 24, new with clc871.h) controls where their generation happens (HW
+ * or driver) on these chips, with the default being HW.
+ */
+static void
+gb202_sor_hdmi_gcp(struct nvkm_ior *sor, int head, bool enable)
+{
+	struct nvkm_device *device = sor->disp->engine.subdev.device;
+	const u32 hdmi = head * 0x400;
+
+	nvkm_mask(device, 0x6f0040 + hdmi, 0x00000001, 0x00000000);
+	nvkm_mask(device, 0x6f004c + hdmi, 0x000000ff, !enable ? 0x00000001 :
+								 0x00000010);
+	nvkm_mask(device, 0x6f0040 + hdmi, 0x00000001, 0x00000001);
+}
+
 /* GB20x is GSP-only. This table supplies the register programming the
  * GSP-RM display path needs from the chip.
  */
@@ -74,7 +92,7 @@ gb202_gsp_disp = {
 	.ramht_size = 0x2000,
 	.gsp.intr = tu102_disp_intr,
 	.gsp.head = &tu102_gsp_head,
-	.gsp.hdmi_gcp = tu102_sor_hdmi_gcp,
+	.gsp.hdmi_gcp = gb202_sor_hdmi_gcp,
 	/* The legacy AVI unit is unchanged on GB20x. */
 	.gsp.hdmi_infoframe_avi = gv100_sor_hdmi_infoframe_avi,
 	.gsp.hdmi_infoframe_vsi = gb202_sor_hdmi_infoframe_vsi,
-- 
2.55.0



