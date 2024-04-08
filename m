Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB466CDA8;
	Mon,  8 Apr 2024 13:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581202; cv=none; b=BaU7n+6mbKm5yEfsBmazb125YP5VaVQWZXA/GDpQwYnAbaddDxh38QWfX7FNjj5coMBdgUpvrtG/Jgg4cOMDva93kXwo5MublMQi771l9CaW9dLrH+BZe9SniHz4obN7a+LireVowQxN9PaAKLYIovK2UvIJgASfhRo4aHTSLYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581202; c=relaxed/simple;
	bh=/aqEehLvgzIdQHJzIl+pw06xgpRAPjZYADYJMfxi8jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iOLUfuEmMjitA3l5a2tj4ZjZyOEPkvusOsRDucrLP5ZVLnTfsA/g2OPW+2ftyhdOEiGblkLYXiwwojhDlOqI/aj1yE/zanlLRK63OGT5Sc7KCBoR0o1n01ILW1sxfcH8Lzc/YLJzAidO5uEoWU0yLKb/VckO+aKlMjy2ZAXzSn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTVNCU7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTVNCU7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3931C43394;
	Mon,  8 Apr 2024 13:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581202;
	bh=/aqEehLvgzIdQHJzIl+pw06xgpRAPjZYADYJMfxi8jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTVNCU7hbCHG3TkRk8Kbdmeph6+Vv33t2/K9s8lp2fz/f955YMrc7QNZcjWtpN6lV
	 5M2qTMbAPp3AVj3CnDXS8ra0Z23xflyXrB+BJjQ7cIvDtqdxqTyPBq7h5viejIQAg1
	 FVBQFvdFLArjcPS1SEKAkqUjsWhw2/cIQvGe9hrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/252] drm/i915/display: Use i915_gem_object_get_dma_address to get dma address
Date: Mon,  8 Apr 2024 14:55:00 +0200
Message-ID: <20240408125306.691460305@linuxfoundation.org>
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

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

[ Upstream commit 7054b551de18e9875fbdf8d4f3baade428353545 ]

Works better for xe like that. obj is no longer const.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231204134946.16219-1-maarten.lankhorst@linux.intel.com
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Stable-dep-of: 582dc04b0658 ("drm/i915: Pre-populate the cursor physical dma address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cursor.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cursor.c b/drivers/gpu/drm/i915/display/intel_cursor.c
index b342fad180ca5..0d21c34f74990 100644
--- a/drivers/gpu/drm/i915/display/intel_cursor.c
+++ b/drivers/gpu/drm/i915/display/intel_cursor.c
@@ -23,6 +23,8 @@
 #include "intel_psr.h"
 #include "skl_watermark.h"
 
+#include "gem/i915_gem_object.h"
+
 /* Cursor formats */
 static const u32 intel_cursor_formats[] = {
 	DRM_FORMAT_ARGB8888,
@@ -33,11 +35,11 @@ static u32 intel_cursor_base(const struct intel_plane_state *plane_state)
 	struct drm_i915_private *dev_priv =
 		to_i915(plane_state->uapi.plane->dev);
 	const struct drm_framebuffer *fb = plane_state->hw.fb;
-	const struct drm_i915_gem_object *obj = intel_fb_obj(fb);
+	struct drm_i915_gem_object *obj = intel_fb_obj(fb);
 	u32 base;
 
 	if (DISPLAY_INFO(dev_priv)->cursor_needs_physical)
-		base = sg_dma_address(obj->mm.pages->sgl);
+		base = i915_gem_object_get_dma_address(obj, 0);
 	else
 		base = intel_plane_ggtt_offset(plane_state);
 
-- 
2.43.0



