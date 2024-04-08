Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1777C080;
	Mon,  8 Apr 2024 13:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582186; cv=none; b=qmrY4SJsXiagImMJT1IOS1Q4cK0eA1va0voGaK2qbIfYvlWgQ/tcKzsyPSPZ7Iozo/8c1lFGt5L96TYyn+b7StWW7/TBuWJwnM9a9UFOJ+EkARHCPrp1Uawqhunrc4rDcfidJ/D/if4ZHx3PT374r4ptGPYooegYMyjr4dlx4YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582186; c=relaxed/simple;
	bh=k3gdoISJAI+RLBPgcvpYZej4ViHGLFofaQlqoisOeZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UVDKWO9mOGqZ9y5NryccUP5y6KcDnYwzTk7kBEF1o+OEQlI+OyvWjhJbmZ69QEgpTuawyjQpAStGMjD3reiH9lZ0GuiSkUxAZpoOTzzgQiLleiSH3ZNTK+iHnV2ZV0Zthr5MqD1Zk4VHPbOXIbZJurpq4Bow2/MfLf5Kk9WwDRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwewdhJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwewdhJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B391C433C7;
	Mon,  8 Apr 2024 13:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582185;
	bh=k3gdoISJAI+RLBPgcvpYZej4ViHGLFofaQlqoisOeZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwewdhJay1e8ff6f3G5KbAHfAl3xtSBVLTGm2SQTAvqQh/bkqP5SotZUGmOPpewZq
	 kvCmUlwf22HpChemoeKzzRRZvPl82QK0+3/bJ7vwIkl6jHAhH9xMMq9TiViHiXskfM
	 vtJDLT9ZvkwEgncOkNyGDWi8bKXrT2fSdxQ4y2Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 053/273] drm/i915: Stop doing double audio enable/disable on SDVO and g4x+ DP
Date: Mon,  8 Apr 2024 14:55:28 +0200
Message-ID: <20240408125310.945918290@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

[ Upstream commit f378ab7870046704fb92e64d50a67dda2cae8420 ]

Looks like I misplaced a few hunks when I moved the audio
enable/disable out from the encoder enable/disable hooks.
So we are now doing a double audio enable/disable on SDVO
and g4x+ DP. Probably harmless as doing it twice shouldn't
really change anything, but let's do it just once, as intended.

Fixes: cff742cc6851 ("drm/i915: Hoist the encoder->audio_{enable,disable}() calls higher up")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240226193251.29619-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 315bd0a0825776d6c66d474bf572db64fa019ad8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/g4x_dp.c     | 2 --
 drivers/gpu/drm/i915/display/intel_sdvo.c | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/g4x_dp.c b/drivers/gpu/drm/i915/display/g4x_dp.c
index dfe0b07a122d1..06ec04e667e32 100644
--- a/drivers/gpu/drm/i915/display/g4x_dp.c
+++ b/drivers/gpu/drm/i915/display/g4x_dp.c
@@ -717,7 +717,6 @@ static void g4x_enable_dp(struct intel_atomic_state *state,
 {
 	intel_enable_dp(state, encoder, pipe_config, conn_state);
 	intel_edp_backlight_on(pipe_config, conn_state);
-	encoder->audio_enable(encoder, pipe_config, conn_state);
 }
 
 static void vlv_enable_dp(struct intel_atomic_state *state,
@@ -726,7 +725,6 @@ static void vlv_enable_dp(struct intel_atomic_state *state,
 			  const struct drm_connector_state *conn_state)
 {
 	intel_edp_backlight_on(pipe_config, conn_state);
-	encoder->audio_enable(encoder, pipe_config, conn_state);
 }
 
 static void g4x_pre_enable_dp(struct intel_atomic_state *state,
diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index 2915d7afe5ccc..cc978ee6d1309 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -1830,8 +1830,6 @@ static void intel_disable_sdvo(struct intel_atomic_state *state,
 	struct intel_crtc *crtc = to_intel_crtc(old_crtc_state->uapi.crtc);
 	u32 temp;
 
-	encoder->audio_disable(encoder, old_crtc_state, conn_state);
-
 	intel_sdvo_set_active_outputs(intel_sdvo, 0);
 	if (0)
 		intel_sdvo_set_encoder_power_state(intel_sdvo,
@@ -1923,8 +1921,6 @@ static void intel_enable_sdvo(struct intel_atomic_state *state,
 		intel_sdvo_set_encoder_power_state(intel_sdvo,
 						   DRM_MODE_DPMS_ON);
 	intel_sdvo_set_active_outputs(intel_sdvo, intel_sdvo_connector->output_flag);
-
-	encoder->audio_enable(encoder, pipe_config, conn_state);
 }
 
 static enum drm_mode_status
-- 
2.43.0



