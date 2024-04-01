Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDBF1CA8F;
	Mon,  1 Apr 2024 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987603; cv=none; b=UDO0U2m5YY4j2bw/GLganQQf0EHYcMkRSd3pBUpVMwsRkb1gaUhXy1nt6vk9PmPOTwhxCJMVKMZIEEPEth8jvuld3mReQ3PXmOtj2frRCaIRaOCFZD8/V5ZsPaAswpHu4KRl+6jpCEYy9hUh3VbByTZicOegGCE/e2fS9R26c18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987603; c=relaxed/simple;
	bh=KJOnXaewG1/YM4DrcxzHlj9Uzc/WWvjt6sHgJkAKQtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tc0y5DR7Yiek+E+kpvraYy1uShGhFbYfAOlmLBO4T1l19FYz8ZYiznM1Ggl/WKLe5u9QUPJPvewiksrCNNpjd/qd/rf7WZZZStdhCvwCrM/kEzYdEl/1n9/OtB/dCK3TRF/grCqBb3ehExN86NAMEKUGoS8lWc5y+u+EpUqQS08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjMuX4Mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjMuX4Mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C676AC433C7;
	Mon,  1 Apr 2024 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987603;
	bh=KJOnXaewG1/YM4DrcxzHlj9Uzc/WWvjt6sHgJkAKQtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjMuX4MhyghHHo/m9x06JknImWK29XSl/8iKJDExY4jFj9qUUAuov1yQQqxwBoZD/
	 7V+WIVbKqiwfYKsmZ1W92nx7U3HOsOLTWe9F7+aJ9wJFfAWYUfX6tVS5iuFbmTFbk+
	 9xQjlp6xYLBECeapYX4Trj7vXSMZZl2IvuJJWveA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 337/399] drm/i915: Pre-populate the cursor physical dma address
Date: Mon,  1 Apr 2024 17:45:03 +0200
Message-ID: <20240401152559.234679113@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 582dc04b0658ef3b90aeb49cbdd9747c2f1eccc3 upstream.

Calling i915_gem_object_get_dma_address() from the vblank
evade critical section triggers might_sleep().

While we know that we've already pinned the framebuffer
and thus i915_gem_object_get_dma_address() will in fact
not sleep in this case, it seems reasonable to keep the
unconditional might_sleep() for maximum coverage.

So let's instead pre-populate the dma address during
fb pinning, which all happens before we enter the
vblank evade critical section.

We can use u32 for the dma address as this class of
hardware doesn't support >32bit addresses.

Cc: stable@vger.kernel.org
Fixes: 0225a90981c8 ("drm/i915: Make cursor plane registers unlocked")
Reported-by: Borislav Petkov <bp@alien8.de>
Closes: https://lore.kernel.org/intel-gfx/20240227100342.GAZd2zfmYcPS_SndtO@fat_crate.local/
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240325175738.3440-1-ville.syrjala@linux.intel.com
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
(cherry picked from commit c1289a5c3594cf04caa94ebf0edeb50c62009f1f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_cursor.c        |    4 +---
 drivers/gpu/drm/i915/display/intel_display_types.h |    1 +
 drivers/gpu/drm/i915/display/intel_fb_pin.c        |   10 ++++++++++
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_cursor.c
+++ b/drivers/gpu/drm/i915/display/intel_cursor.c
@@ -35,12 +35,10 @@ static u32 intel_cursor_base(const struc
 {
 	struct drm_i915_private *dev_priv =
 		to_i915(plane_state->uapi.plane->dev);
-	const struct drm_framebuffer *fb = plane_state->hw.fb;
-	struct drm_i915_gem_object *obj = intel_fb_obj(fb);
 	u32 base;
 
 	if (DISPLAY_INFO(dev_priv)->cursor_needs_physical)
-		base = i915_gem_object_get_dma_address(obj, 0);
+		base = plane_state->phys_dma_addr;
 	else
 		base = intel_plane_ggtt_offset(plane_state);
 
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -719,6 +719,7 @@ struct intel_plane_state {
 #define PLANE_HAS_FENCE BIT(0)
 
 	struct intel_fb_view view;
+	u32 phys_dma_addr; /* for cursor_needs_physical */
 
 	/* Plane pxp decryption state */
 	bool decrypt;
--- a/drivers/gpu/drm/i915/display/intel_fb_pin.c
+++ b/drivers/gpu/drm/i915/display/intel_fb_pin.c
@@ -255,6 +255,16 @@ int intel_plane_pin_fb(struct intel_plan
 			return PTR_ERR(vma);
 
 		plane_state->ggtt_vma = vma;
+
+		/*
+		 * Pre-populate the dma address before we enter the vblank
+		 * evade critical section as i915_gem_object_get_dma_address()
+		 * will trigger might_sleep() even if it won't actually sleep,
+		 * which is the case when the fb has already been pinned.
+		 */
+		if (phys_cursor)
+			plane_state->phys_dma_addr =
+				i915_gem_object_get_dma_address(intel_fb_obj(fb), 0);
 	} else {
 		struct intel_framebuffer *intel_fb = to_intel_framebuffer(fb);
 


