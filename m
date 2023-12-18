Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD65722091;
	Mon, 18 Dec 2023 14:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wwa04Qns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347A1C433C8;
	Mon, 18 Dec 2023 14:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908418;
	bh=1huDvhIjScAu22KJewC4fN5f1drcV3396PN2ZPOG6gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wwa04Qnscy7YkxAfe6wx58qGzL0pmgsLjq15n3qKIcrDEXE3CY55uEYjfoaYALUs5
	 R5vWjAQfJDmStu91yPbFyt9gTvrHgY3Zi8yNNKjurjwZlWvDtXx1W9EYf/uAQjlX6s
	 uUKXl8WFot2F21z7h4CgN6RbEvBPGR0DMZFdpP64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 152/166] drm/i915: Fix remapped stride with CCS on ADL+
Date: Mon, 18 Dec 2023 14:51:58 +0100
Message-ID: <20231218135111.926079005@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 0ccd963fe555451b1f84e6d14d2b3ef03dd5c947 upstream.

On ADL+ the hardware automagically calculates the CCS AUX surface
stride from the main surface stride, so when remapping we can't
really play a lot of tricks with the main surface stride, or else
the AUX surface stride would get miscalculated and no longer
match the actual data layout in memory.

Supposedly we could remap in 256 main surface tile units
(AUX page(4096)/cachline(64)*4(4x1 main surface tiles per
AUX cacheline)=256 main surface tiles), but the extra complexity
is probably not worth the hassle.

So let's just make sure our mapping stride is calculated from
the full framebuffer stride (instead of the framebuffer width).
This way the stride we program into PLANE_STRIDE will be the
original framebuffer stride, and thus there will be no change
to the AUX stride/layout.

Cc: stable@vger.kernel.org
Cc: Imre Deak <imre.deak@intel.com>
Cc: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231205180308.7505-1-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 2c12eb36f849256f5eb00ffaee9bf99396fd3814)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_fb.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_fb.c
+++ b/drivers/gpu/drm/i915/display/intel_fb.c
@@ -1498,8 +1498,20 @@ static u32 calc_plane_remap_info(const s
 
 			size += remap_info->size;
 		} else {
-			unsigned int dst_stride = plane_view_dst_stride_tiles(fb, color_plane,
-									      remap_info->width);
+			unsigned int dst_stride;
+
+			/*
+			 * The hardware automagically calculates the CCS AUX surface
+			 * stride from the main surface stride so can't really remap a
+			 * smaller subset (unless we'd remap in whole AUX page units).
+			 */
+			if (intel_fb_needs_pot_stride_remap(fb) &&
+			    intel_fb_is_ccs_modifier(fb->base.modifier))
+				dst_stride = remap_info->src_stride;
+			else
+				dst_stride = remap_info->width;
+
+			dst_stride = plane_view_dst_stride_tiles(fb, color_plane, dst_stride);
 
 			assign_chk_ovf(i915, remap_info->dst_stride, dst_stride);
 			color_plane_info->mapping_stride = dst_stride *


