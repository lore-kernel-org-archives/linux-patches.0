Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B11879DC;
	Sat, 30 Dec 2023 12:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJLMt3YB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85E5C433C8;
	Sat, 30 Dec 2023 12:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938228;
	bh=tkwdpAKeg/WH90Uqv60htuwpmPSRRvgASEYxWjATC6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJLMt3YBBZ81ME5l/cdcTvHDw9UXFI7dz8qRGTgchOzIacQ/M5ooBuk2/a8UZWFU8
	 w6bDf9B8lLR+FfzopW5GP7mVrWPxANC9Lgs4MEW0tdq/ucprQkhT/hYt7xFePu9EcF
	 BPjVW1IdR4Fr+jmrIrRdpk6H3vsXHYwX8SZvjfa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clint Taylor <clinton.a.taylor@intel.com>,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/112] drm/i915/mtl: Add MTL for remapping CCS FBs
Date: Sat, 30 Dec 2023 11:59:25 +0000
Message-ID: <20231230115808.382553981@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clint Taylor <clinton.a.taylor@intel.com>

[ Upstream commit 0da6bfe857ea9399498876cbe6ef428637b6e475 ]

Add support for remapping CCS FBs on MTL to remove the restriction
of the power-of-two sized stride and the 2MB surface offset alignment
for these FBs.

Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
Signed-off-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Reviewed-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230505144005.23480-2-nirmoy.das@intel.com
Stable-dep-of: 324b70e997aa ("drm/i915: Fix ADL+ tiled plane stride when the POT stride is smaller than the original")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fb.c b/drivers/gpu/drm/i915/display/intel_fb.c
index c22ca36a38a9d..583b3c0f96ddc 100644
--- a/drivers/gpu/drm/i915/display/intel_fb.c
+++ b/drivers/gpu/drm/i915/display/intel_fb.c
@@ -1176,7 +1176,8 @@ bool intel_fb_needs_pot_stride_remap(const struct intel_framebuffer *fb)
 {
 	struct drm_i915_private *i915 = to_i915(fb->base.dev);
 
-	return IS_ALDERLAKE_P(i915) && intel_fb_uses_dpt(&fb->base);
+	return (IS_ALDERLAKE_P(i915) || DISPLAY_VER(i915) >= 14) &&
+		intel_fb_uses_dpt(&fb->base);
 }
 
 static int intel_fb_pitch(const struct intel_framebuffer *fb, int color_plane, unsigned int rotation)
@@ -1312,9 +1313,10 @@ plane_view_scanout_stride(const struct intel_framebuffer *fb, int color_plane,
 			  unsigned int tile_width,
 			  unsigned int src_stride_tiles, unsigned int dst_stride_tiles)
 {
+	struct drm_i915_private *i915 = to_i915(fb->base.dev);
 	unsigned int stride_tiles;
 
-	if (IS_ALDERLAKE_P(to_i915(fb->base.dev)))
+	if (IS_ALDERLAKE_P(i915) || DISPLAY_VER(i915) >= 14)
 		stride_tiles = src_stride_tiles;
 	else
 		stride_tiles = dst_stride_tiles;
@@ -1520,7 +1522,8 @@ static void intel_fb_view_init(struct drm_i915_private *i915, struct intel_fb_vi
 	memset(view, 0, sizeof(*view));
 	view->gtt.type = view_type;
 
-	if (view_type == I915_GTT_VIEW_REMAPPED && IS_ALDERLAKE_P(i915))
+	if (view_type == I915_GTT_VIEW_REMAPPED &&
+	    (IS_ALDERLAKE_P(i915) || DISPLAY_VER(i915) >= 14))
 		view->gtt.remapped.plane_alignment = SZ_2M / PAGE_SIZE;
 }
 
-- 
2.43.0



