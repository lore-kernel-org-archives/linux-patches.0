Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760D29446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3900C433C8;
	Sun, 13 Aug 2023 21:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963184;
	bh=aQuGPSP0X75QwvtN7mxx9co7HF1BCIffUkxoDOCGHWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrizguQXog/dU4bUZu7LymWlK5dLIn2uo6QN1cfooWCg10i3huGEIlOm2VdAvNfjg
	 +45iIeuh3iG2iKBD2cegerqIucvzBSpYbxVp0Hukw8rbAwISrB5ALSOW9nNH92qsN9
	 N70U/E9M0coThkMWk7sSOJmlgseyqrAxTDbA38Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Stone <daniels@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 55/89] drm/rockchip: Dont spam logs in atomic check
Date: Sun, 13 Aug 2023 23:19:46 +0200
Message-ID: <20230813211712.447912884@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Stone <daniels@collabora.com>

commit 43dae319b50fac075ad864f84501c703ef20eb2b upstream.

Userspace should not be able to trigger DRM_ERROR messages to spam the
logs; especially not through atomic commit parameters which are
completely legitimate for userspace to attempt.

Signed-off-by: Daniel Stone <daniels@collabora.com>
Fixes: 7707f7227f09 ("drm/rockchip: Add support for afbc")
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230808104405.522493-1-daniels@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -820,12 +820,12 @@ static int vop_plane_atomic_check(struct
 	 * need align with 2 pixel.
 	 */
 	if (fb->format->is_yuv && ((new_plane_state->src.x1 >> 16) % 2)) {
-		DRM_ERROR("Invalid Source: Yuv format not support odd xpos\n");
+		DRM_DEBUG_KMS("Invalid Source: Yuv format not support odd xpos\n");
 		return -EINVAL;
 	}
 
 	if (fb->format->is_yuv && new_plane_state->rotation & DRM_MODE_REFLECT_Y) {
-		DRM_ERROR("Invalid Source: Yuv format does not support this rotation\n");
+		DRM_DEBUG_KMS("Invalid Source: Yuv format does not support this rotation\n");
 		return -EINVAL;
 	}
 
@@ -833,7 +833,7 @@ static int vop_plane_atomic_check(struct
 		struct vop *vop = to_vop(crtc);
 
 		if (!vop->data->afbc) {
-			DRM_ERROR("vop does not support AFBC\n");
+			DRM_DEBUG_KMS("vop does not support AFBC\n");
 			return -EINVAL;
 		}
 
@@ -842,15 +842,16 @@ static int vop_plane_atomic_check(struct
 			return ret;
 
 		if (new_plane_state->src.x1 || new_plane_state->src.y1) {
-			DRM_ERROR("AFBC does not support offset display, xpos=%d, ypos=%d, offset=%d\n",
-				  new_plane_state->src.x1,
-				  new_plane_state->src.y1, fb->offsets[0]);
+			DRM_DEBUG_KMS("AFBC does not support offset display, " \
+				      "xpos=%d, ypos=%d, offset=%d\n",
+				      new_plane_state->src.x1, new_plane_state->src.y1,
+				      fb->offsets[0]);
 			return -EINVAL;
 		}
 
 		if (new_plane_state->rotation && new_plane_state->rotation != DRM_MODE_ROTATE_0) {
-			DRM_ERROR("No rotation support in AFBC, rotation=%d\n",
-				  new_plane_state->rotation);
+			DRM_DEBUG_KMS("No rotation support in AFBC, rotation=%d\n",
+				      new_plane_state->rotation);
 			return -EINVAL;
 		}
 	}


