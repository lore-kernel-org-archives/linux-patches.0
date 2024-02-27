Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B23C54BD4;
	Tue, 27 Feb 2024 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042341; cv=none; b=jGZlAygjheWwTwfCWSkZQNJ8keKb6/nGa5brYUx+HvvEkdBmmpxcaaVgUqceNVIdXOuL58DbCA+J/r7q25DZR/Z4/ravl3a5YrCnaKRMg8SgMgifn8V7+wsENvKD8knRX/2wSWOF2zWSHpgCM7s7HP9fRh+XpZ50Jdz4PrN+RrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042341; c=relaxed/simple;
	bh=kLJ7U0J3fY9FM16+Gi9XqA3/DomgSDcceOdTxiuQ+s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESahPePuLv1Ybtvn4oXcl5R+XWmaHlwRFIeIIrZSanho5RNXj7BMtbqHEvOnqh7gkl7agGOo7t7v/nAiqQ9/IDGOmKJYBAlKSbkzZxG1g7TcZnHBRi/j+CoHg9H/qsQP9lgt1M6r2L1+P6qIyJhjtmf73q29o1iSHWk01vuEzdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYZuPGp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYZuPGp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE927C433F1;
	Tue, 27 Feb 2024 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042341;
	bh=kLJ7U0J3fY9FM16+Gi9XqA3/DomgSDcceOdTxiuQ+s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYZuPGp2yiyyPgHk23FIDAKv/v5skX0K63IwKJ8RdY4H0VeCsKvr5pIM+n9K8nZCg
	 AX9Fg6tGaSEoXk47KuFwYTYxmBi8MOGkRYM8iKXK8Z5U0SoL0V2KQh6zyJJzpC9z36
	 VJPNbmNgfwm8LvyzN5ySzS1Mb5b2/OPDX4uWSZ1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 261/299] drm/i915/tv: Fix TV mode
Date: Tue, 27 Feb 2024 14:26:12 +0100
Message-ID: <20240227131634.100768741@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit fb1e881273f432e593f8789f99e725b09304cc97 ]

Commit 1fd4a5a36f9f ("drm/connector: Rename legacy TV property") failed
to update all the users of the struct drm_tv_connector_state mode field,
which resulted in a build failure in i915.

However, a subsequent commit in the same series reintroduced a mode
field in that structure, with a different semantic but the same type,
with the assumption that all previous users were updated.

Since that didn't happen, the i915 driver now compiles, but mixes
accesses to the legacy_mode field and the newer mode field, but with the
previous semantics.

This obviously doesn't work very well, so we need to update the accesses
that weren't in the legacy renaming commit.

Fixes: 1fd4a5a36f9f ("drm/connector: Rename legacy TV property")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240220131251.453060-1-mripard@kernel.org
(cherry picked from commit bf7626f19d6ff14b9722273e23700400cc4d78ba)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_sdvo.c | 10 +++++-----
 drivers/gpu/drm/i915/display/intel_tv.c   | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index 0ce935efe5dfd..18ae41d5f4f98 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -1212,7 +1212,7 @@ static bool intel_sdvo_set_tv_format(struct intel_sdvo *intel_sdvo,
 	struct intel_sdvo_tv_format format;
 	u32 format_map;
 
-	format_map = 1 << conn_state->tv.mode;
+	format_map = 1 << conn_state->tv.legacy_mode;
 	memset(&format, 0, sizeof(format));
 	memcpy(&format, &format_map, min(sizeof(format), sizeof(format_map)));
 
@@ -2295,7 +2295,7 @@ static int intel_sdvo_get_tv_modes(struct drm_connector *connector)
 	 * Read the list of supported input resolutions for the selected TV
 	 * format.
 	 */
-	format_map = 1 << conn_state->tv.mode;
+	format_map = 1 << conn_state->tv.legacy_mode;
 	memcpy(&tv_res, &format_map,
 	       min(sizeof(format_map), sizeof(struct intel_sdvo_sdtv_resolution_request)));
 
@@ -2360,7 +2360,7 @@ intel_sdvo_connector_atomic_get_property(struct drm_connector *connector,
 		int i;
 
 		for (i = 0; i < intel_sdvo_connector->format_supported_num; i++)
-			if (state->tv.mode == intel_sdvo_connector->tv_format_supported[i]) {
+			if (state->tv.legacy_mode == intel_sdvo_connector->tv_format_supported[i]) {
 				*val = i;
 
 				return 0;
@@ -2416,7 +2416,7 @@ intel_sdvo_connector_atomic_set_property(struct drm_connector *connector,
 	struct intel_sdvo_connector_state *sdvo_state = to_intel_sdvo_connector_state(state);
 
 	if (property == intel_sdvo_connector->tv_format) {
-		state->tv.mode = intel_sdvo_connector->tv_format_supported[val];
+		state->tv.legacy_mode = intel_sdvo_connector->tv_format_supported[val];
 
 		if (state->crtc) {
 			struct drm_crtc_state *crtc_state =
@@ -3071,7 +3071,7 @@ static bool intel_sdvo_tv_create_property(struct intel_sdvo *intel_sdvo,
 		drm_property_add_enum(intel_sdvo_connector->tv_format, i,
 				      tv_format_names[intel_sdvo_connector->tv_format_supported[i]]);
 
-	intel_sdvo_connector->base.base.state->tv.mode = intel_sdvo_connector->tv_format_supported[0];
+	intel_sdvo_connector->base.base.state->tv.legacy_mode = intel_sdvo_connector->tv_format_supported[0];
 	drm_object_attach_property(&intel_sdvo_connector->base.base.base,
 				   intel_sdvo_connector->tv_format, 0);
 	return true;
diff --git a/drivers/gpu/drm/i915/display/intel_tv.c b/drivers/gpu/drm/i915/display/intel_tv.c
index d84a79491da23..042ed966807ed 100644
--- a/drivers/gpu/drm/i915/display/intel_tv.c
+++ b/drivers/gpu/drm/i915/display/intel_tv.c
@@ -949,7 +949,7 @@ intel_disable_tv(struct intel_atomic_state *state,
 
 static const struct tv_mode *intel_tv_mode_find(const struct drm_connector_state *conn_state)
 {
-	int format = conn_state->tv.mode;
+	int format = conn_state->tv.legacy_mode;
 
 	return &tv_modes[format];
 }
@@ -1710,7 +1710,7 @@ static void intel_tv_find_better_format(struct drm_connector *connector)
 			break;
 	}
 
-	connector->state->tv.mode = i;
+	connector->state->tv.legacy_mode = i;
 }
 
 static int
@@ -1865,7 +1865,7 @@ static int intel_tv_atomic_check(struct drm_connector *connector,
 	old_state = drm_atomic_get_old_connector_state(state, connector);
 	new_crtc_state = drm_atomic_get_new_crtc_state(state, new_state->crtc);
 
-	if (old_state->tv.mode != new_state->tv.mode ||
+	if (old_state->tv.legacy_mode != new_state->tv.legacy_mode ||
 	    old_state->tv.margins.left != new_state->tv.margins.left ||
 	    old_state->tv.margins.right != new_state->tv.margins.right ||
 	    old_state->tv.margins.top != new_state->tv.margins.top ||
@@ -1902,7 +1902,7 @@ static void intel_tv_add_properties(struct drm_connector *connector)
 	conn_state->tv.margins.right = 46;
 	conn_state->tv.margins.bottom = 37;
 
-	conn_state->tv.mode = 0;
+	conn_state->tv.legacy_mode = 0;
 
 	/* Create TV properties then attach current values */
 	for (i = 0; i < ARRAY_SIZE(tv_modes); i++) {
@@ -1916,7 +1916,7 @@ static void intel_tv_add_properties(struct drm_connector *connector)
 
 	drm_object_attach_property(&connector->base,
 				   i915->drm.mode_config.legacy_tv_mode_property,
-				   conn_state->tv.mode);
+				   conn_state->tv.legacy_mode);
 	drm_object_attach_property(&connector->base,
 				   i915->drm.mode_config.tv_left_margin_property,
 				   conn_state->tv.margins.left);
-- 
2.43.0



