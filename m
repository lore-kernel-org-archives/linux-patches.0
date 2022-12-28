Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621221C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABF4C433D2;
	Wed, 28 Dec 2022 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246217;
	bh=ai9Dl+ViSUHNRfzUgoHRUybCXR2fgv0q8wVs0578jWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4vjkoZ/+dLNtawutxAp4s4PS48p6sECBVdx7iW7rRuqbX2topz2yso/b6hBFhNiW
	 h4W82R6YpR5LqE02YUzJYKdGvX7js13En63DeYPpj/rXka8REcedXrHOK7u5RU8Sva
	 +3Kr1uyvJPlIfNHQ0ulKv04876RsVFzUzCt9fLmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1004/1146] drm/sti: Use drm_mode_copy()
Date: Wed, 28 Dec 2022 15:42:23 +0100
Message-Id: <20221228144357.640008159@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 442cf8e22ba25a77cb9092d78733fdbac9844e50 ]

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

Cc: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221107192545.9896-8-ville.syrjala@linux.intel.com
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_dvo.c  | 2 +-
 drivers/gpu/drm/sti/sti_hda.c  | 2 +-
 drivers/gpu/drm/sti/sti_hdmi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_dvo.c b/drivers/gpu/drm/sti/sti_dvo.c
index b6ee8a82e656..f3a5616b7daf 100644
--- a/drivers/gpu/drm/sti/sti_dvo.c
+++ b/drivers/gpu/drm/sti/sti_dvo.c
@@ -288,7 +288,7 @@ static void sti_dvo_set_mode(struct drm_bridge *bridge,
 
 	DRM_DEBUG_DRIVER("\n");
 
-	memcpy(&dvo->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&dvo->mode, mode);
 
 	/* According to the path used (main or aux), the dvo clocks should
 	 * have a different parent clock. */
diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 03cc401ed593..ec6656b9ee7c 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -524,7 +524,7 @@ static void sti_hda_set_mode(struct drm_bridge *bridge,
 
 	DRM_DEBUG_DRIVER("\n");
 
-	memcpy(&hda->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&hda->mode, mode);
 
 	if (!hda_get_mode_idx(hda->mode, &mode_idx)) {
 		DRM_ERROR("Undefined mode\n");
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index cb82622877d2..fcc2194869d6 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -941,7 +941,7 @@ static void sti_hdmi_set_mode(struct drm_bridge *bridge,
 	DRM_DEBUG_DRIVER("\n");
 
 	/* Copy the drm display mode in the connector local structure */
-	memcpy(&hdmi->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&hdmi->mode, mode);
 
 	/* Update clock framerate according to the selected mode */
 	ret = clk_set_rate(hdmi->clk_pix, mode->clock * 1000);
-- 
2.35.1



