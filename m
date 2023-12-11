Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DE551C37;
	Mon, 11 Dec 2023 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7bhlqVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8765C433C7;
	Mon, 11 Dec 2023 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320795;
	bh=GBBanfGrPibinXgODNc9nRM7YQ/BcdEOJVZUsXJJTIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7bhlqVZT5SWLanJ3colhLSCO6zDl+djT5rmay7aa2vtudzEzb2X+c0rAN7bm8tAJ
	 a6RGYO72EoiGSiwbVJJJuLf8J1s0AO8lBwO4gxpXjgJwbYMf31PbGMyOzojzYPh9gw
	 szoAudJ66cDWX07Ac4tTwD6mRd0BDoM9b5P0BJGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/194] drm/i915/sdvo: stop caching has_hdmi_monitor in struct intel_sdvo
Date: Mon, 11 Dec 2023 19:23:03 +0100
Message-ID: <20231211182045.318966195@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit f2f9c8cb6421429ef166d6404426693212d0ca07 ]

Use the information stored in display info.

Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/3e9e1dcd554d470bdf474891a431b15e1880f9a0.1685437500.git.jani.nikula@intel.com
Stable-dep-of: 20c2dbff342a ("drm/i915: Skip some timing checks on BXT/GLK DSI transcoders")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_sdvo.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index 2c2e0f041f869..c1a85128911e1 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -115,7 +115,6 @@ struct intel_sdvo {
 
 	enum port port;
 
-	bool has_hdmi_monitor;
 	bool has_hdmi_audio;
 
 	/* DDC bus used by this SDVO encoder */
@@ -1278,10 +1277,13 @@ static void i9xx_adjust_sdvo_tv_clock(struct intel_crtc_state *pipe_config)
 	pipe_config->clock_set = true;
 }
 
-static bool intel_has_hdmi_sink(struct intel_sdvo *sdvo,
+static bool intel_has_hdmi_sink(struct intel_sdvo_connector *intel_sdvo_connector,
 				const struct drm_connector_state *conn_state)
 {
-	return sdvo->has_hdmi_monitor &&
+	struct drm_connector *connector = conn_state->connector;
+
+	return intel_sdvo_connector->is_hdmi &&
+		connector->display_info.is_hdmi &&
 		READ_ONCE(to_intel_digital_connector_state(conn_state)->force_audio) != HDMI_AUDIO_OFF_DVI;
 }
 
@@ -1360,7 +1362,7 @@ static int intel_sdvo_compute_config(struct intel_encoder *encoder,
 	pipe_config->pixel_multiplier =
 		intel_sdvo_get_pixel_multiplier(adjusted_mode);
 
-	pipe_config->has_hdmi_sink = intel_has_hdmi_sink(intel_sdvo, conn_state);
+	pipe_config->has_hdmi_sink = intel_has_hdmi_sink(intel_sdvo_connector, conn_state);
 
 	if (pipe_config->has_hdmi_sink) {
 		if (intel_sdvo_state->base.force_audio == HDMI_AUDIO_AUTO)
@@ -1875,7 +1877,7 @@ intel_sdvo_mode_valid(struct drm_connector *connector,
 	struct intel_sdvo_connector *intel_sdvo_connector =
 		to_intel_sdvo_connector(connector);
 	int max_dotclk = to_i915(connector->dev)->max_dotclk_freq;
-	bool has_hdmi_sink = intel_has_hdmi_sink(intel_sdvo, connector->state);
+	bool has_hdmi_sink = intel_has_hdmi_sink(intel_sdvo_connector, connector->state);
 	int clock = mode->clock;
 
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
@@ -2064,7 +2066,6 @@ intel_sdvo_tmds_sink_detect(struct drm_connector *connector)
 		if (edid->input & DRM_EDID_INPUT_DIGITAL) {
 			status = connector_status_connected;
 			if (intel_sdvo_connector->is_hdmi) {
-				intel_sdvo->has_hdmi_monitor = drm_detect_hdmi_monitor(edid);
 				intel_sdvo->has_hdmi_audio = drm_detect_monitor_audio(edid);
 			}
 		} else
@@ -2116,7 +2117,6 @@ intel_sdvo_detect(struct drm_connector *connector, bool force)
 
 	intel_sdvo->attached_output = response;
 
-	intel_sdvo->has_hdmi_monitor = false;
 	intel_sdvo->has_hdmi_audio = false;
 
 	if ((intel_sdvo_connector->output_flag & response) == 0)
-- 
2.42.0



