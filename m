Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91162F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3273CC433D2;
	Wed, 12 Apr 2023 08:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288752;
	bh=5AKrIi4ev+rPGHtTQfYpbbV9C3MGCt13yZslhz9pflo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMWWCMzwSkQkw386g3tMxsTSX7/6nAPnACKSD04Hz9+PFayOsBfSch737fTBMjTbc
	 Xf4XSep5WjzpEujMJPJVp70sdn2qwX8WBBAkOZkOrY3DkOKYZRdNsMsFnSgw3auGQb
	 osUDLQSvo7snCLoS7/Vf1yGsGwHO5s2JXsc3DCLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.15 89/93] drm/nouveau/disp: Support more modes by checking with lower bpc
Date: Wed, 12 Apr 2023 10:34:30 +0200
Message-Id: <20230412082826.911050635@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karol Herbst <kherbst@redhat.com>

commit 7f67aa097e875c87fba024e850cf405342300059 upstream.

This allows us to advertise more modes especially on HDR displays.

Fixes using 4K@60 modes on my TV and main display both using a HDMI to DP
adapter. Also fixes similar issues for users running into this.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230330223938.4025569-1-kherbst@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c |   32 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_dp.c    |    8 +++++---
 2 files changed, 37 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -411,6 +411,35 @@ nv50_outp_atomic_check_view(struct drm_e
 	return 0;
 }
 
+static void
+nv50_outp_atomic_fix_depth(struct drm_encoder *encoder, struct drm_crtc_state *crtc_state)
+{
+	struct nv50_head_atom *asyh = nv50_head_atom(crtc_state);
+	struct nouveau_encoder *nv_encoder = nouveau_encoder(encoder);
+	struct drm_display_mode *mode = &asyh->state.adjusted_mode;
+	unsigned int max_rate, mode_rate;
+
+	switch (nv_encoder->dcb->type) {
+	case DCB_OUTPUT_DP:
+		max_rate = nv_encoder->dp.link_nr * nv_encoder->dp.link_bw;
+
+		/* we don't support more than 10 anyway */
+		asyh->or.bpc = min_t(u8, asyh->or.bpc, 10);
+
+		/* reduce the bpc until it works out */
+		while (asyh->or.bpc > 6) {
+			mode_rate = DIV_ROUND_UP(mode->clock * asyh->or.bpc * 3, 8);
+			if (mode_rate <= max_rate)
+				break;
+
+			asyh->or.bpc -= 2;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 static int
 nv50_outp_atomic_check(struct drm_encoder *encoder,
 		       struct drm_crtc_state *crtc_state,
@@ -429,6 +458,9 @@ nv50_outp_atomic_check(struct drm_encode
 	if (crtc_state->mode_changed || crtc_state->connectors_changed)
 		asyh->or.bpc = connector->display_info.bpc;
 
+	/* We might have to reduce the bpc */
+	nv50_outp_atomic_fix_depth(encoder, crtc_state);
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -220,8 +220,6 @@ void nouveau_dp_irq(struct nouveau_drm *
 }
 
 /* TODO:
- * - Use the minimum possible BPC here, once we add support for the max bpc
- *   property.
  * - Validate against the DP caps advertised by the GPU (we don't check these
  *   yet)
  */
@@ -233,7 +231,11 @@ nv50_dp_mode_valid(struct drm_connector
 {
 	const unsigned int min_clock = 25000;
 	unsigned int max_rate, mode_rate, ds_max_dotclock, clock = mode->clock;
-	const u8 bpp = connector->display_info.bpc * 3;
+	/* Check with the minmum bpc always, so we can advertise better modes.
+	 * In particlar not doing this causes modes to be dropped on HDR
+	 * displays as we might check with a bpc of 16 even.
+	 */
+	const u8 bpp = 6 * 3;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;


