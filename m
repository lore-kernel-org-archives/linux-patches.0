Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F333A275861;
	Tue, 21 Oct 2025 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077431; cv=none; b=TCEbC6/6/fDRJy5F+t7xq+NHURO7LQ/g8zACN/3srkMsqcU2uP3J2OGIxaFdcLTxXddXsfx1k2MLuLxViDUA+JHrWJsdiN/cS9by9zyo62k0ayPjZkN9RigRvYIAVda+lbihe8KmODJ8yTO2CalFA37UZ4mnJWKyEURE8XwLzjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077431; c=relaxed/simple;
	bh=XimFrROINM5e0vl04U2r8Fke20RxLLaDWO8mekCJhgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNP20UFK8efG/a+zXq3vc/r7P7Vt5HQUJdnrB6XQyxikFZeOKTOlCPfsVa/TZEzcs2UBkvadXX5oJFWuPJZHbKSyGxv8xDNAneEomtWMCzeg+Bq93wY23zzKSpoqDwc/eRRCLfJbRI5u63m8lGIcvcHBWCAw08c6wpMFjQAGT14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5tHmcp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5tHmcp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610B4C113D0;
	Tue, 21 Oct 2025 20:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077430;
	bh=XimFrROINM5e0vl04U2r8Fke20RxLLaDWO8mekCJhgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5tHmcp6IGkPf3Nfnj/no6QFwm9L5EzMWpiAWpHOYZHLzylbj6KgJaUE8w99svNJh
	 PRwQYVD8KfeUzZxtriUZUDjFv97I+Tm5OMy5vt6e4kwIhkI0/7ZLsDVU+iDb77ezKS
	 XMwminszQN20sN1dZac8BvLMXPcisja3iz6c2Z0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 104/159] drm/i915/fb: Fix the set_tiling vs. addfb race, again
Date: Tue, 21 Oct 2025 21:51:21 +0200
Message-ID: <20251021195045.682295352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 86af6b90e0556fcefbc6e98eb78bdce90327ee76 ]

intel_frontbuffer_get() is what locks out subsequent set_tiling
changes to the bo. Thus the fence vs. modifier check must be done
after intel_frontbuffer_get(), or else a concurrent set_tiling ioctl
might sneak in and change the fence after the check has been done.

Close the race again. See commit dd689287b977 ("drm/i915: Prevent
concurrent tiling/framebuffer modifications") for the previous
instance.

v2: Reorder intel_user_framebuffer_destroy() to match the unwind (Jani)

Cc: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Fixes: 10690b8a49bc ("drm/i915/display: Add intel_fb_bo_framebuffer_fini")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20251003145734.7634-3-ville.syrjala@linux.intel.com
(cherry picked from commit 1d1e4ded216017f8febd91332ee337f0e0e79285)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fb.c | 38 +++++++++++++------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fb.c b/drivers/gpu/drm/i915/display/intel_fb.c
index 0da842bd2f2f1..974e5b547d886 100644
--- a/drivers/gpu/drm/i915/display/intel_fb.c
+++ b/drivers/gpu/drm/i915/display/intel_fb.c
@@ -2111,10 +2111,10 @@ static void intel_user_framebuffer_destroy(struct drm_framebuffer *fb)
 	if (intel_fb_uses_dpt(fb))
 		intel_dpt_destroy(intel_fb->dpt_vm);
 
-	intel_frontbuffer_put(intel_fb->frontbuffer);
-
 	intel_fb_bo_framebuffer_fini(intel_fb_bo(fb));
 
+	intel_frontbuffer_put(intel_fb->frontbuffer);
+
 	kfree(intel_fb);
 }
 
@@ -2216,15 +2216,17 @@ int intel_framebuffer_init(struct intel_framebuffer *intel_fb,
 	int ret = -EINVAL;
 	int i;
 
+	/*
+	 * intel_frontbuffer_get() must be done before
+	 * intel_fb_bo_framebuffer_init() to avoid set_tiling vs. addfb race.
+	 */
+	intel_fb->frontbuffer = intel_frontbuffer_get(obj);
+	if (!intel_fb->frontbuffer)
+		return -ENOMEM;
+
 	ret = intel_fb_bo_framebuffer_init(fb, obj, mode_cmd);
 	if (ret)
-		return ret;
-
-	intel_fb->frontbuffer = intel_frontbuffer_get(obj);
-	if (!intel_fb->frontbuffer) {
-		ret = -ENOMEM;
-		goto err;
-	}
+		goto err_frontbuffer_put;
 
 	ret = -EINVAL;
 	if (!drm_any_plane_has_format(display->drm,
@@ -2233,7 +2235,7 @@ int intel_framebuffer_init(struct intel_framebuffer *intel_fb,
 		drm_dbg_kms(display->drm,
 			    "unsupported pixel format %p4cc / modifier 0x%llx\n",
 			    &mode_cmd->pixel_format, mode_cmd->modifier[0]);
-		goto err_frontbuffer_put;
+		goto err_bo_framebuffer_fini;
 	}
 
 	max_stride = intel_fb_max_stride(display, mode_cmd->pixel_format,
@@ -2244,7 +2246,7 @@ int intel_framebuffer_init(struct intel_framebuffer *intel_fb,
 			    mode_cmd->modifier[0] != DRM_FORMAT_MOD_LINEAR ?
 			    "tiled" : "linear",
 			    mode_cmd->pitches[0], max_stride);
-		goto err_frontbuffer_put;
+		goto err_bo_framebuffer_fini;
 	}
 
 	/* FIXME need to adjust LINOFF/TILEOFF accordingly. */
@@ -2252,7 +2254,7 @@ int intel_framebuffer_init(struct intel_framebuffer *intel_fb,
 		drm_dbg_kms(display->drm,
 			    "plane 0 offset (0x%08x) must be 0\n",
 			    mode_cmd->offsets[0]);
-		goto err_frontbuffer_put;
+		goto err_bo_framebuffer_fini;
 	}
 
 	drm_helper_mode_fill_fb_struct(display->drm, fb, info, mode_cmd);
@@ -2262,7 +2264,7 @@ int intel_framebuffer_init(struct intel_framebuffer *intel_fb,
 
 		if (mode_cmd->handles[i] != mode_cmd->handles[0]) {
 			drm_dbg_kms(display->drm, "bad plane %d handle\n", i);
-			goto err_frontbuffer_put;
+			goto err_bo_framebuffer_fini;
 		}
 
 		stride_alignment = intel_fb_stride_alignment(fb, i);
@@ -2270,7 +2272,7 @@ int intel_framebuffer_init(struct intel_framebuffer *intel_fb,
 			drm_dbg_kms(display->drm,
 				    "plane %d pitch (%d) must be at least %u byte aligned\n",
 				    i, fb->pitches[i], stride_alignment);
-			goto err_frontbuffer_put;
+			goto err_bo_framebuffer_fini;
 		}
 
 		if (intel_fb_is_gen12_ccs_aux_plane(fb, i)) {
@@ -2280,7 +2282,7 @@ int intel_framebuffer_init(struct intel_framebuffer *intel_fb,
 				drm_dbg_kms(display->drm,
 					    "ccs aux plane %d pitch (%d) must be %d\n",
 					    i, fb->pitches[i], ccs_aux_stride);
-				goto err_frontbuffer_put;
+				goto err_bo_framebuffer_fini;
 			}
 		}
 
@@ -2289,7 +2291,7 @@ int intel_framebuffer_init(struct intel_framebuffer *intel_fb,
 
 	ret = intel_fill_fb_info(display, intel_fb);
 	if (ret)
-		goto err_frontbuffer_put;
+		goto err_bo_framebuffer_fini;
 
 	if (intel_fb_uses_dpt(fb)) {
 		struct i915_address_space *vm;
@@ -2315,10 +2317,10 @@ int intel_framebuffer_init(struct intel_framebuffer *intel_fb,
 err_free_dpt:
 	if (intel_fb_uses_dpt(fb))
 		intel_dpt_destroy(intel_fb->dpt_vm);
+err_bo_framebuffer_fini:
+	intel_fb_bo_framebuffer_fini(obj);
 err_frontbuffer_put:
 	intel_frontbuffer_put(intel_fb->frontbuffer);
-err:
-	intel_fb_bo_framebuffer_fini(obj);
 	return ret;
 }
 
-- 
2.51.0



