Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7BE6CDA8;
	Mon,  8 Apr 2024 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581422; cv=none; b=fxKpdLqXeiv5ObgU8DPUfqo7YfFiZ0BdgGk7E/n5Hl9ck5/UgIaCW8HtI+7UmV90b53Kv7UaHku337cwOxHQZVGLPJgcuJSRMSbmJ567YW31cpWvbpAjfFk2VLlkCL+ZqrNbpZtZATHisAr3N740Q1t75qnvcPnuFUUO0O6m064=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581422; c=relaxed/simple;
	bh=csxZHofYfgG4soKkQR7XabC12xYM1UN6Zydqq/Ji8T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rkSldArYPquUrkzmSHl4cl4291AoLacbKKtsZL1mMeBHPyA+ewBFTqCPSSOHQZ0sYIDr21oXJMPtYZ0/46Vu2bJsCKxhbWL2U0/9WS5IvcsaXaZJcLR0CD+Pkb9YRkmdzIRhTqaiIOOi45QbJzIm6OG1SBYkm+WFo4UivbCV5kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6L9akTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6L9akTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318B9C433F1;
	Mon,  8 Apr 2024 13:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581422;
	bh=csxZHofYfgG4soKkQR7XabC12xYM1UN6Zydqq/Ji8T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6L9akTjGLT1lBsGw/tfCIaFmJPLkB6J/+/f5RJtgJ9uw3o2kY3mvmsJwIwl5OPNO
	 7YyRVP5+mQvNn8bVtkymu8TaQaX+g5b7Ih3Kc4ekVn4d1hHaxOVP9zc60JzDBt9aIx
	 Tzzfj/uNuoYqJJ0aoz1TctoHSn0fn/ROzrUHYUNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/252] drm/i915: Pre-populate the cursor physical dma address
Date: Mon,  8 Apr 2024 14:55:01 +0200
Message-ID: <20240408125306.722062553@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

[ Upstream commit 582dc04b0658ef3b90aeb49cbdd9747c2f1eccc3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cursor.c        |  4 +---
 drivers/gpu/drm/i915/display/intel_display_types.h |  1 +
 drivers/gpu/drm/i915/display/intel_fb_pin.c        | 10 ++++++++++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cursor.c b/drivers/gpu/drm/i915/display/intel_cursor.c
index 0d21c34f74990..61df6cd3f3778 100644
--- a/drivers/gpu/drm/i915/display/intel_cursor.c
+++ b/drivers/gpu/drm/i915/display/intel_cursor.c
@@ -34,12 +34,10 @@ static u32 intel_cursor_base(const struct intel_plane_state *plane_state)
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
 
diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index 7fc92b1474cc4..8b0dc2b75da4a 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -701,6 +701,7 @@ struct intel_plane_state {
 #define PLANE_HAS_FENCE BIT(0)
 
 	struct intel_fb_view view;
+	u32 phys_dma_addr; /* for cursor_needs_physical */
 
 	/* Plane pxp decryption state */
 	bool decrypt;
diff --git a/drivers/gpu/drm/i915/display/intel_fb_pin.c b/drivers/gpu/drm/i915/display/intel_fb_pin.c
index fffd568070d41..a131656757f2b 100644
--- a/drivers/gpu/drm/i915/display/intel_fb_pin.c
+++ b/drivers/gpu/drm/i915/display/intel_fb_pin.c
@@ -254,6 +254,16 @@ int intel_plane_pin_fb(struct intel_plane_state *plane_state)
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
 
-- 
2.43.0



