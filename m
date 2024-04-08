Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF527F499;
	Mon,  8 Apr 2024 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584973; cv=none; b=jJy4M87RbibK561Tqws/olPqxLqXu/VSCdxXIjx8b8j0wJPLysh+0Q4gF3dXI5m7T0MW6Rhnq8yKURIIQGP8PWajsGaIcerHP+eE9C11w33gCRENLgl9hI9duThjcFarfK15N4HFZyHeCSv8iFUTeUlGE6OAWoZwswU2qJOUQ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584973; c=relaxed/simple;
	bh=/TYVNtY1C1XGsRQZaaMq1IsN3METX0rWkMa2HOSKdX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N4SKb/LZsUeJrJf7NoXINWpHbY/otWOYFnDThCsjsxJmZ40V1k2vhJ/8SVLvQEKH7SajkqD6sLJZBKOAywZV5Np2txKmjkKrn7v+qXckvnfBDHnNbQmiN7fdds8R0OzkBr7JIu+/rIfBF+xqdBl053DDCCkd7dlSo2tXCRsL7eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1fl7M9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1fl7M9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB6EC433C7;
	Mon,  8 Apr 2024 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584973;
	bh=/TYVNtY1C1XGsRQZaaMq1IsN3METX0rWkMa2HOSKdX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1fl7M9EgXO2373a4h86f0lYcFZo3OpzLyMoQy8Tg00eTifgqYOuk5/gKmytydNvJ
	 xmjNLMPdMQWFVOayh8ZySScohCxTho09UHWml9G8Ne6+3geEMw+OYjOqd/bZKgNEkU
	 DZwfnWAZiswfuVfP4zXefsoBvbMcfjF8rOT4bYuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	amd-gfx@lists.freedesktop.org,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 579/690] drm/amdgpu: Use drm_mode_copy()
Date: Mon,  8 Apr 2024 14:57:25 +0200
Message-ID: <20240408125420.579306553@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 426c89aa203bcec9d9cf6eea36735eafa1b1f099 ]

struct drm_display_mode embeds a list head, so overwriting
the full struct with another one will corrupt the list
(if the destination mode is on a list). Use drm_mode_copy()
instead which explicitly preserves the list head of
the destination mode.

Even if we know the destination mode is not on any list
using drm_mode_copy() seems decent as it sets a good
example. Bad examples of not using it might eventually
get copied into code where preserving the list head
actually matters.

Obviously one case not covered here is when the mode
itself is embedded in a larger structure and the whole
structure is copied. But if we are careful when copying
into modes embedded in structures I think we can be a
little more reassured that bogus list heads haven't been
propagated in.

@is_mode_copy@
@@
drm_mode_copy(...)
{
...
}

@depends on !is_mode_copy@
struct drm_display_mode *mode;
expression E, S;
@@
(
- *mode = E
+ drm_mode_copy(mode, &E)
|
- memcpy(mode, E, S)
+ drm_mode_copy(mode, E)
)

@depends on !is_mode_copy@
struct drm_display_mode mode;
expression E;
@@
(
- mode = E
+ drm_mode_copy(&mode, &E)
|
- memcpy(&mode, E, S)
+ drm_mode_copy(&mode, E)
)

@@
struct drm_display_mode *mode;
@@
- &*mode
+ mode

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 79f3e38f60e5 ("drm/amd/display: Preserve original aspect ratio in create stream")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c    | 4 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index c777aff164b76..654f99f4107ea 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -625,7 +625,7 @@ amdgpu_connector_fixup_lcd_native_mode(struct drm_encoder *encoder,
 		if (mode->type & DRM_MODE_TYPE_PREFERRED) {
 			if (mode->hdisplay != native_mode->hdisplay ||
 			    mode->vdisplay != native_mode->vdisplay)
-				memcpy(native_mode, mode, sizeof(*mode));
+				drm_mode_copy(native_mode, mode);
 		}
 	}
 
@@ -634,7 +634,7 @@ amdgpu_connector_fixup_lcd_native_mode(struct drm_encoder *encoder,
 		list_for_each_entry_safe(mode, t, &connector->probed_modes, head) {
 			if (mode->hdisplay == native_mode->hdisplay &&
 			    mode->vdisplay == native_mode->vdisplay) {
-				*native_mode = *mode;
+				drm_mode_copy(native_mode, mode);
 				drm_mode_set_crtcinfo(native_mode, CRTC_INTERLACE_HALVE_V);
 				DRM_DEBUG_KMS("Determined LVDS native mode details from EDID\n");
 				break;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 7385efe699f88..9356decd14513 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6219,7 +6219,7 @@ get_highest_refresh_rate_mode(struct amdgpu_dm_connector *aconnector,
 		}
 	}
 
-	aconnector->freesync_vid_base = *m_pref;
+	drm_mode_copy(&aconnector->freesync_vid_base, m_pref);
 	return m_pref;
 }
 
@@ -6333,8 +6333,8 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 				 is_freesync_video_mode(&mode, aconnector);
 		if (recalculate_timing) {
 			freesync_mode = get_highest_refresh_rate_mode(aconnector, false);
-			saved_mode = mode;
-			mode = *freesync_mode;
+			drm_mode_copy(&saved_mode, &mode);
+			drm_mode_copy(&mode, freesync_mode);
 		} else {
 			decide_crtc_timing_for_drm_display_mode(
 				&mode, preferred_mode, scale);
-- 
2.43.0



