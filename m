Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F11F82495;
	Wed, 19 Jun 2024 13:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803415; cv=none; b=gryk/+WT0TkQag03jo0bNm6fn0MPD445YFPAuWLnX8pOJzn7JDNP9TtlQyckgwvnECWAAgdDm6/IaTfeWt2LEgBK4gsEHUM2nZy3JOqTeTgsM3ZbVJpMF2VcJU9T5L7G2KILS+HFSXFXgUZgToI7LscKcLSzFmgaU/R8e+1t0DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803415; c=relaxed/simple;
	bh=voP0DfBi9L5Y0lvTR4Fo1vM32uu3jlUgusMcvbg2yF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EajJv81mkeCGdJcZba5cQQUM0W2AiMBtRyfWNW2cKF19IDK7lc8g+/ovl1bR11OxVjNtOLp3bxw8L9AuIaLT0xksQQD2PGKrAau3OE0symarHc+o6e4z1jVV5k0idPwoViP/Flw3NkQ4JKbVKq4TxZ+9luvdm5M0DPmtpFtw93k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IqRd0sC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IqRd0sC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019DAC32786;
	Wed, 19 Jun 2024 13:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803415;
	bh=voP0DfBi9L5Y0lvTR4Fo1vM32uu3jlUgusMcvbg2yF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IqRd0sCU5+gW91U9K1JfyK6UZYGOi87pQYw61c8ButlnYsQOd3ua8zMuaYLGV480
	 dQ1fPUOmfr0q9es2YC1FWZOmmVpfAAFBWc2dUgYTH3fi6k7s2jACB0X6DhpAKuTcMp
	 cJnw4sXyMY4BkRIChHXlr5rWq3LqUgcfrzxNzCco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.9 260/281] drm/i915: Fix audio component initialization
Date: Wed, 19 Jun 2024 14:56:59 +0200
Message-ID: <20240619125619.984659783@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 75800e2e4203ea83bbc9d4f63ad97ea582244a08 upstream.

After registering the audio component in i915_audio_component_init()
the audio driver may call i915_audio_component_get_power() via the
component ops. This could program AUD_FREQ_CNTRL with an uninitialized
value if the latter function is called before display.audio.freq_cntrl
gets initialized. The get_power() function also does a modeset which in
the above case happens too early before the initialization step and
triggers the

"Reject display access from task"

error message added by the Fixes: commit below.

Fix the above issue by registering the audio component only after the
initialization step.

Fixes: 87c1694533c9 ("drm/i915: save AUD_FREQ_CNTRL state at audio domain suspend")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/10291
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240521143022.3784539-1-imre.deak@intel.com
(cherry picked from commit fdd0b80172758ce284f19fa8a26d90c61e4371d2)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_audio.c          |   32 +++++++++++++-------
 drivers/gpu/drm/i915/display/intel_audio.h          |    1 
 drivers/gpu/drm/i915/display/intel_display_driver.c |    2 +
 3 files changed, 24 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_audio.c
+++ b/drivers/gpu/drm/i915/display/intel_audio.c
@@ -1252,17 +1252,6 @@ static const struct component_ops i915_a
 static void i915_audio_component_init(struct drm_i915_private *i915)
 {
 	u32 aud_freq, aud_freq_init;
-	int ret;
-
-	ret = component_add_typed(i915->drm.dev,
-				  &i915_audio_component_bind_ops,
-				  I915_COMPONENT_AUDIO);
-	if (ret < 0) {
-		drm_err(&i915->drm,
-			"failed to add audio component (%d)\n", ret);
-		/* continue with reduced functionality */
-		return;
-	}
 
 	if (DISPLAY_VER(i915) >= 9) {
 		aud_freq_init = intel_de_read(i915, AUD_FREQ_CNTRL);
@@ -1285,6 +1274,21 @@ static void i915_audio_component_init(st
 
 	/* init with current cdclk */
 	intel_audio_cdclk_change_post(i915);
+}
+
+static void i915_audio_component_register(struct drm_i915_private *i915)
+{
+	int ret;
+
+	ret = component_add_typed(i915->drm.dev,
+				  &i915_audio_component_bind_ops,
+				  I915_COMPONENT_AUDIO);
+	if (ret < 0) {
+		drm_err(&i915->drm,
+			"failed to add audio component (%d)\n", ret);
+		/* continue with reduced functionality */
+		return;
+	}
 
 	i915->display.audio.component_registered = true;
 }
@@ -1317,6 +1321,12 @@ void intel_audio_init(struct drm_i915_pr
 		i915_audio_component_init(i915);
 }
 
+void intel_audio_register(struct drm_i915_private *i915)
+{
+	if (!i915->display.audio.lpe.platdev)
+		i915_audio_component_register(i915);
+}
+
 /**
  * intel_audio_deinit() - deinitialize the audio driver
  * @i915: the i915 drm device private data
--- a/drivers/gpu/drm/i915/display/intel_audio.h
+++ b/drivers/gpu/drm/i915/display/intel_audio.h
@@ -28,6 +28,7 @@ void intel_audio_codec_get_config(struct
 void intel_audio_cdclk_change_pre(struct drm_i915_private *dev_priv);
 void intel_audio_cdclk_change_post(struct drm_i915_private *dev_priv);
 void intel_audio_init(struct drm_i915_private *dev_priv);
+void intel_audio_register(struct drm_i915_private *i915);
 void intel_audio_deinit(struct drm_i915_private *dev_priv);
 void intel_audio_sdp_split_update(const struct intel_crtc_state *crtc_state);
 
--- a/drivers/gpu/drm/i915/display/intel_display_driver.c
+++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
@@ -542,6 +542,8 @@ void intel_display_driver_register(struc
 
 	intel_display_driver_enable_user_access(i915);
 
+	intel_audio_register(i915);
+
 	intel_display_debugfs_register(i915);
 
 	/*


