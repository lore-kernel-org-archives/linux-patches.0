Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C8A340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301040; cv=none; b=u7tKr5k2WFKYCCfBt8O68S/b7gpOX4LfjTRTi8oJo9EUu2SLM3FeWvRg3qr0NPND66sxr6SAccTm2hl1U/8aRB5O8siJxftdJkjVa6WAEI7B06qmDQYFkDRSrsObCCY1U9gKG3qebXKx6F6f/dsAKmmKM0p2fNH4tdhiCbJkj4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301040; c=relaxed/simple;
	bh=2ckaNMhPtlImwhQLGZB6+hBV4x2buobKsepMjyUMgXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FeBEHrIvk3DxFi/e6IYmm/oSUn7CAKncypMcrvBNf+ljT2sQApSxCYZYevD7TN4FaoKCEAutO5bt7S3/GnNCl2kknx5diXMdqntzcAAP1Ysb9B3EXoVhqwgjqoyrCMwSPuYLNFFp2JK4u+UzDQcLebHKhsLrQtoZtf706JTYqeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9ZbIGOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9ZbIGOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DADC19423;
	Sat, 28 Feb 2026 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301040;
	bh=2ckaNMhPtlImwhQLGZB6+hBV4x2buobKsepMjyUMgXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9ZbIGOfsl1terWT3+UpcFQCGhsCt8xr7DDGWaGynDoNsHcyUMzChaPgJwGyE+xze
	 /1aw+o+HTXafAEiZOtMWFenRft6sJ1q0Izdi5FWKHNjJw2UGKYxDWxwfgGmMFFfvv+
	 4GFXSaJULvg2jciPpKggAkwYoxTVkEi2M718EvnFi3k7CXSkksL+UDzWfROIaKv0zq
	 c3rV87NHKcqUVWPy0xAHOcucmJOm8JOptwOkcx7nhDGYxD8gwvLNxq/fsG11KSAFSI
	 4qO/TWnb40XwIKM2V3vAkn5YV8CBi/sXoaQfxMT4mfD1/dLYQqdmk5TjhYIYEujNoR
	 OPamNGngdJktg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>,
	Manikandan Muralidharan <manikandan.m@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/752] drm/atmel-hlcdc: don't reject the commit if the src rect has fractional parts
Date: Sat, 28 Feb 2026 12:38:09 -0500
Message-ID: <20260228174750.1542406-178-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ludovic Desroches <ludovic.desroches@microchip.com>

[ Upstream commit 06682206e2a1883354ed758c09efeb51f435adbd ]

Don’t reject the commit when the source rectangle has fractional parts.
This can occur due to scaling: drm_atomic_helper_check_plane_state() calls
drm_rect_clip_scaled(), which may introduce fractional parts while
computing the clipped source rectangle. This does not imply the commit is
invalid, so we should accept it instead of discarding it.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Reviewed-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Link: https://patch.msgid.link/20251120-lcd_scaling_fix-v1-1-5ffc98557923@microchip.com
Signed-off-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c   | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index 410ec747cc7e0..caf6deda717ce 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -78,8 +78,6 @@ drm_plane_state_to_atmel_hlcdc_plane_state(struct drm_plane_state *s)
 	return container_of(s, struct atmel_hlcdc_plane_state, base);
 }
 
-#define SUBPIXEL_MASK			0xffff
-
 static uint32_t rgb_formats[] = {
 	DRM_FORMAT_C8,
 	DRM_FORMAT_XRGB4444,
@@ -744,24 +742,15 @@ static int atmel_hlcdc_plane_atomic_check(struct drm_plane *p,
 	if (ret || !s->visible)
 		return ret;
 
-	hstate->src_x = s->src.x1;
-	hstate->src_y = s->src.y1;
-	hstate->src_w = drm_rect_width(&s->src);
-	hstate->src_h = drm_rect_height(&s->src);
+	hstate->src_x = s->src.x1 >> 16;
+	hstate->src_y = s->src.y1 >> 16;
+	hstate->src_w = drm_rect_width(&s->src) >> 16;
+	hstate->src_h = drm_rect_height(&s->src) >> 16;
 	hstate->crtc_x = s->dst.x1;
 	hstate->crtc_y = s->dst.y1;
 	hstate->crtc_w = drm_rect_width(&s->dst);
 	hstate->crtc_h = drm_rect_height(&s->dst);
 
-	if ((hstate->src_x | hstate->src_y | hstate->src_w | hstate->src_h) &
-	    SUBPIXEL_MASK)
-		return -EINVAL;
-
-	hstate->src_x >>= 16;
-	hstate->src_y >>= 16;
-	hstate->src_w >>= 16;
-	hstate->src_h >>= 16;
-
 	hstate->nplanes = fb->format->num_planes;
 	if (hstate->nplanes > ATMEL_HLCDC_LAYER_MAX_PLANES)
 		return -EINVAL;
-- 
2.51.0

