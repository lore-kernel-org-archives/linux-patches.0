Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD62DFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F58AC433D2;
	Mon, 15 May 2023 17:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170651;
	bh=pVqg07gdpgIise+Um/2jKBpIYgaa3ToU/n0phW34iZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrgSsXQ8Sa/oZYf1bHoHLlstcm34YHyVYP4jCmGDL++RjcVDECe9kkM3fsng94usU
	 1D3lNpopgBfbBURTjkJPIZbRgPBS0NTQ50RvMFSZxf8FJnzrsvYxUcSLO7iY2/WV+5
	 6p7RVhnxwoJUenfQwt2hXp5IXjt34uP0JRRym6Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Zwisler <zwisler@google.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/239] drm/i915: Check pipe source size when using skl+ scalers
Date: Mon, 15 May 2023 18:27:41 +0200
Message-Id: <20230515161727.673150333@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit d944eafed618a8507270b324ad9d5405bb7f0b3e ]

The skl+ scalers only sample 12 bits of PIPESRC so we can't
do any plane scaling at all when the pipe source size is >4k.

Make sure the pipe source size is also below the scaler's src
size limits. Might not be 100% accurate, but should at least be
safe. We can refine the limits later if we discover that recent
hw is less restricted.

Cc: stable@vger.kernel.org
Tested-by: Ross Zwisler <zwisler@google.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8357
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230418175528.13117-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 691248d4135fe3fae64b4ee0676bc96a7fd6950c)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_scaler.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/skl_scaler.c b/drivers/gpu/drm/i915/display/skl_scaler.c
index e6ec5ed0d00ec..90f42f63128ec 100644
--- a/drivers/gpu/drm/i915/display/skl_scaler.c
+++ b/drivers/gpu/drm/i915/display/skl_scaler.c
@@ -105,6 +105,8 @@ skl_update_scaler(struct intel_crtc_state *crtc_state, bool force_detach,
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 	const struct drm_display_mode *adjusted_mode =
 		&crtc_state->hw.adjusted_mode;
+	int pipe_src_w = drm_rect_width(&crtc_state->pipe_src);
+	int pipe_src_h = drm_rect_height(&crtc_state->pipe_src);
 	int min_src_w, min_src_h, min_dst_w, min_dst_h;
 	int max_src_w, max_src_h, max_dst_w, max_dst_h;
 
@@ -196,6 +198,21 @@ skl_update_scaler(struct intel_crtc_state *crtc_state, bool force_detach,
 		return -EINVAL;
 	}
 
+	/*
+	 * The pipe scaler does not use all the bits of PIPESRC, at least
+	 * on the earlier platforms. So even when we're scaling a plane
+	 * the *pipe* source size must not be too large. For simplicity
+	 * we assume the limits match the scaler source size limits. Might
+	 * not be 100% accurate on all platforms, but good enough for now.
+	 */
+	if (pipe_src_w > max_src_w || pipe_src_h > max_src_h) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "scaler_user index %u.%u: pipe src size %ux%u "
+			    "is out of scaler range\n",
+			    crtc->pipe, scaler_user, pipe_src_w, pipe_src_h);
+		return -EINVAL;
+	}
+
 	/* mark this plane as a scaler user in crtc_state */
 	scaler_state->scaler_users |= (1 << scaler_user);
 	drm_dbg_kms(&dev_priv->drm, "scaler_user index %u.%u: "
-- 
2.39.2



