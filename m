Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B6012FB31;
	Wed, 19 Jun 2024 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802523; cv=none; b=EDAh4a0ThtPUcRHxzbU36CIZJy2SCnOuR3QoBlB+0p/L3cy8GWdy4k7uz/u1aAkJObYcnWBYSoiXpBU3A5YdOCBI1tjlNRqEdyu8GguTFJdMSj4ETCvxYiJX5iWZ42Sp7ONfgQ73f8YAfpfV02liPdU/3jnLDd2dyMqIPtLb/UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802523; c=relaxed/simple;
	bh=NY4vP88neayLIV3RLIpCxSWoaMqmB8d/LLyigu3sBEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XT/as/YU5bKJKGDAU/Bk48uVFsogqDraTQdxscbfITQLTqitAQd7Ayk/UpMXFb/p1TMSZekN8h7x8xTXpWF2PqrqK4kQkjn/vfbLEYDsMOTMC7iPTgKiqShmPQYqSWu9tEHMwncDGLCSRpHZapOwLC+tnm1vnGwX0s5SE7lQ4y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZY23MWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZY23MWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A08AC2BBFC;
	Wed, 19 Jun 2024 13:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802523;
	bh=NY4vP88neayLIV3RLIpCxSWoaMqmB8d/LLyigu3sBEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZY23MWvc5adUOn1ivxuBoBXLHxqk3GDKMEpZ3/Q4OhWWbYwag3FWvKBsOOiCa3X3
	 tvPsjVVzXNG2tnlZZF1jcuebXHrfQe2IIZziuyVo/Vvuvss5XyGa/mOR65bGbfpGL9
	 RpYvIyq8h+U1mxo/27BLLCqJE5UDN5f5T4N1irG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 218/267] drm/i915: Fix audio component initialization
Date: Wed, 19 Jun 2024 14:56:09 +0200
Message-ID: <20240619125614.693902728@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1251,17 +1251,6 @@ static const struct component_ops i915_a
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
@@ -1284,6 +1273,21 @@ static void i915_audio_component_init(st
 
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
@@ -1316,6 +1320,12 @@ void intel_audio_init(struct drm_i915_pr
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
 void intel_audio_sdp_split_update(struct intel_encoder *encoder,
 				  const struct intel_crtc_state *crtc_state);
--- a/drivers/gpu/drm/i915/display/intel_display_driver.c
+++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
@@ -386,6 +386,8 @@ void intel_display_driver_register(struc
 
 	intel_audio_init(i915);
 
+	intel_audio_register(i915);
+
 	intel_display_debugfs_register(i915);
 
 	/*


