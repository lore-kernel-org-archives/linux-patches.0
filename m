Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41382F2C
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6519FC4339E;
	Wed, 12 Apr 2023 08:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289242;
	bh=rRgptqMYEN69q+EEU/Yf+c5aCK4eMMT4HBdyj6VfjWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bpa563SickgSqv13VxRQz1Hemm7uByyjZcwyPYm1C7bbiYQbOxTBnxhYXoF107U9
	 6MOtURe2UGbCTQ6RJU+Ffcplh5xX9OqJEC9esRYHFCNNTBDCzFeB2I8pG5H6qCl3Fh
	 VSf0rNHlM7c9p9Cw5VTKZtg/MslYiCl4CrGduiAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manasi Navare <navaremanasi@google.com>,
	Drew Davenport <ddavenport@chromium.org>,
	Imre Deak <imre.deak@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 006/173] drm/i915: Add a .color_post_update() hook
Date: Wed, 12 Apr 2023 10:32:12 +0200
Message-Id: <20230412082838.391974076@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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

[ Upstream commit c880f855d1e240a956dcfce884269bad92fc849c ]

We're going to need stuff after the color management
register latching has happened. Add a corresponding hook.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-4-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 3962ca4e080a525fc9eae87aa6b2286f1fae351d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_color.c   | 13 +++++++++++++
 drivers/gpu/drm/i915/display/intel_color.h   |  1 +
 drivers/gpu/drm/i915/display/intel_display.c |  3 +++
 3 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index ff6b8aaaa2194..85a38d794dd9f 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -46,6 +46,11 @@ struct intel_color_funcs {
 	 * registers involved with the same commit.
 	 */
 	void (*color_commit_arm)(const struct intel_crtc_state *crtc_state);
+	/*
+	 * Perform any extra tasks needed after all the
+	 * double buffered registers have been latched.
+	 */
+	void (*color_post_update)(const struct intel_crtc_state *crtc_state);
 	/*
 	 * Load LUTs (and other single buffered color management
 	 * registers). Will (hopefully) be called during the vblank
@@ -1220,6 +1225,14 @@ void intel_color_commit_arm(const struct intel_crtc_state *crtc_state)
 	i915->display.funcs.color->color_commit_arm(crtc_state);
 }
 
+void intel_color_post_update(const struct intel_crtc_state *crtc_state)
+{
+	struct drm_i915_private *i915 = to_i915(crtc_state->uapi.crtc->dev);
+
+	if (i915->display.funcs.color->color_post_update)
+		i915->display.funcs.color->color_post_update(crtc_state);
+}
+
 void intel_color_prepare_commit(struct intel_crtc_state *crtc_state)
 {
 	intel_dsb_prepare(crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_color.h b/drivers/gpu/drm/i915/display/intel_color.h
index 0e85406036b54..0256f49c3910d 100644
--- a/drivers/gpu/drm/i915/display/intel_color.h
+++ b/drivers/gpu/drm/i915/display/intel_color.h
@@ -21,6 +21,7 @@ void intel_color_prepare_commit(struct intel_crtc_state *crtc_state);
 void intel_color_cleanup_commit(struct intel_crtc_state *crtc_state);
 void intel_color_commit_noarm(const struct intel_crtc_state *crtc_state);
 void intel_color_commit_arm(const struct intel_crtc_state *crtc_state);
+void intel_color_post_update(const struct intel_crtc_state *crtc_state);
 void intel_color_load_luts(const struct intel_crtc_state *crtc_state);
 void intel_color_get_config(struct intel_crtc_state *crtc_state);
 int intel_color_get_gamma_bit_precision(const struct intel_crtc_state *crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index ca76408b99b38..2d46dcf820a23 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1263,6 +1263,9 @@ static void intel_post_plane_update(struct intel_atomic_state *state,
 	if (needs_cursorclk_wa(old_crtc_state) &&
 	    !needs_cursorclk_wa(new_crtc_state))
 		icl_wa_cursorclkgating(dev_priv, pipe, false);
+
+	if (intel_crtc_needs_color_update(new_crtc_state))
+		intel_color_post_update(new_crtc_state);
 }
 
 static void intel_crtc_enable_flip_done(struct intel_atomic_state *state,
-- 
2.39.2



