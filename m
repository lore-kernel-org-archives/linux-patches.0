Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF39431488;
	Thu, 30 Jul 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422322; cv=none; b=QPrmXsn4CymuDs/bJsZR9Gu7NRk6VBYwiMFOibruieej5GEJnaaPdck0FUwNNfKZJnjtTFu1jWWrPlkP8s+JbyzNl6bQvP8R4nEb7BW0DtDeOFVz50sG4w9ygprp/JsXUIYNa/VBXHpm5sfPCwYZ6ceiRuvOghHIyfqmL+8TosQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422322; c=relaxed/simple;
	bh=4nsKum6SmALdCGx8n8oXXBOamlnw6xNAS6H/kMn6wnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xk7szfMHpFS6iIgTW5wrwN++K7fZjGDjwX72FyOpVNGXGtN9SqOXs0EgTCD1C9iW4EYY90WjcZSjLx9HhLh4yutXeSbgygaV0dq2PvaiLGxR2gIByumkV6GzIHSLPJMXlcJA9ohphetLcxFZPZ/kWPDB9U9Y74lek1rUJBDSV/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqtRRUTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqtRRUTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8341F000E9;
	Thu, 30 Jul 2026 14:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422320;
	bh=TvhzCxf+OQp+yGj8GDkJ/ZBOpk5d3bPo4GcflB5zUPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqtRRUThiBzeSnP9IavwDqgrL5TZgXYso73S2VQse1sz0FoRrts2cDNA+E60Th6Vk
	 imAZ0dTTLNFDMjODajSma3xVFbyq+SijmZKm8HL71EX8W5sPD6inuGy+E7dUsAgizO
	 Ca/W5Jj946u7ZgmHLWct6l7RrRVaDMgf51wm+HWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>
Subject: [PATCH 7.1 397/744] drm/xe/display: skip FORCE_WC and vm_bound check for external dma-bufs
Date: Thu, 30 Jul 2026 16:11:10 +0200
Message-ID: <20260730141452.728020384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit d472497265374e895e31cf2af8a2c5f650019889 upstream.

Currently, xe_display_bo_framebuffer_init() unconditionally attempts to
apply XE_BO_FLAG_FORCE_WC to the buffer and rejects the FB creation with
-EINVAL if the BO is already VM_BINDed.

However, for imported dma-bufs (ttm_bo_type_sg), this check doesn't seem
to make much sense since CPU caching policy is entirely controlled by
the exporter. Plus there is no place to set this flag, in the first
place. Also this is not rejected if not yet vm_binded, but that seems
arbitrary since setting or not setting FORCE_WC should a noop either
way, at this stage, and whether it is currently VM_BINDed makes no
difference.

Currently if we run an app and offload rendering to an external dGPU,
like NV or another xe device, the dma-buf passed back to the compositor
(igpu) will be an actual external import from xe pov, and it will be
missing FORCE_WC, and if the compositor side did a VM_BIND before
turning into it into an fb the whole thing gets rejected.

So it looks like we either need to reject outright, no matter what, or
this usecase is valid and we need to loosen the restriction for sg
buffers.  Proposing here to loosen the restriction.

Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/7919
Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Maarten Lankhorst <dev@lankhorst.se>
Cc: <stable@vger.kernel.org> # v6.12+
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
Link: https://patch.msgid.link/20260612170501.550816-2-matthew.auld@intel.com
(cherry picked from commit 3e493f88c84088ccd7b53cdd23ac5c875c9a60dd)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/display/xe_display_bo.c |    3 ++-
 drivers/gpu/drm/xe/display/xe_fb_pin.c     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/display/xe_display_bo.c
+++ b/drivers/gpu/drm/xe/display/xe_display_bo.c
@@ -42,7 +42,8 @@ static int xe_display_bo_framebuffer_ini
 	if (ret)
 		goto err;
 
-	if (!(bo->flags & XE_BO_FLAG_FORCE_WC)) {
+	if (!(bo->flags & XE_BO_FLAG_FORCE_WC) &&
+	    bo->ttm.type != ttm_bo_type_sg) {
 		/*
 		 * XE_BO_FLAG_FORCE_WC should ideally be set at creation, or is
 		 * automatically set when creating FB. We cannot change caching
--- a/drivers/gpu/drm/xe/display/xe_fb_pin.c
+++ b/drivers/gpu/drm/xe/display/xe_fb_pin.c
@@ -481,7 +481,8 @@ int intel_plane_pin_fb(struct intel_plan
 		return 0;
 
 	/* We reject creating !SCANOUT fb's, so this is weird.. */
-	drm_WARN_ON(bo->ttm.base.dev, !(bo->flags & XE_BO_FLAG_FORCE_WC));
+	drm_WARN_ON(bo->ttm.base.dev, !(bo->flags & XE_BO_FLAG_FORCE_WC) &&
+		    bo->ttm.type != ttm_bo_type_sg);
 
 	vma = __xe_pin_fb_vma(intel_fb, &new_plane_state->view.gtt, alignment);
 


