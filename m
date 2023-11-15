Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7921C3A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlERZANi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24718C433C7;
	Wed, 15 Nov 2023 19:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077303;
	bh=Zo1UfXAkiVKpOeuWi5q7GFmMnvIXgiGpLpfIxXxH+wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlERZANiVoqvN8+2sP50wbSZTIEyPFdQbz2sV0tFVVgPXwpRWnNBwIgzhC1rXH06/
	 2WPV7KLk2bewrpw/G5OCzIQ0RNBRiLLgAoMMSPP8smtkTuBLhaUCxz7ywPAX4eD1nM
	 0oDhMpBCeaqlISEGQE9jD+61301K7ThQ2b9FyRkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/603] drm/rockchip: vop2: Add missing call to crtc reset helper
Date: Wed, 15 Nov 2023 14:12:46 -0500
Message-ID: <20231115191628.578024954@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 4d49d87b3606369c6e29b9d051892ee1a6fc4e75 ]

Add missing call to crtc reset helper to properly vblank reset.

Also move vop2_crtc_reset and call vop2_crtc_destroy_state to simplify
and remove duplicated code.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230621223311.2239547-6-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 31 +++++++++-----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index d843c19c146db..c306806aa3dea 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2079,23 +2079,6 @@ static const struct drm_crtc_helper_funcs vop2_crtc_helper_funcs = {
 	.atomic_disable = vop2_crtc_atomic_disable,
 };
 
-static void vop2_crtc_reset(struct drm_crtc *crtc)
-{
-	struct rockchip_crtc_state *vcstate = to_rockchip_crtc_state(crtc->state);
-
-	if (crtc->state) {
-		__drm_atomic_helper_crtc_destroy_state(crtc->state);
-		kfree(vcstate);
-	}
-
-	vcstate = kzalloc(sizeof(*vcstate), GFP_KERNEL);
-	if (!vcstate)
-		return;
-
-	crtc->state = &vcstate->base;
-	crtc->state->crtc = crtc;
-}
-
 static struct drm_crtc_state *vop2_crtc_duplicate_state(struct drm_crtc *crtc)
 {
 	struct rockchip_crtc_state *vcstate;
@@ -2122,6 +2105,20 @@ static void vop2_crtc_destroy_state(struct drm_crtc *crtc,
 	kfree(vcstate);
 }
 
+static void vop2_crtc_reset(struct drm_crtc *crtc)
+{
+	struct rockchip_crtc_state *vcstate =
+		kzalloc(sizeof(*vcstate), GFP_KERNEL);
+
+	if (crtc->state)
+		vop2_crtc_destroy_state(crtc, crtc->state);
+
+	if (vcstate)
+		__drm_atomic_helper_crtc_reset(crtc, &vcstate->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
+}
+
 static const struct drm_crtc_funcs vop2_crtc_funcs = {
 	.set_config = drm_atomic_helper_set_config,
 	.page_flip = drm_atomic_helper_page_flip,
-- 
2.42.0



