Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903D4168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13465C433D2;
	Mon,  8 May 2023 09:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539622;
	bh=Kzdcvz3HMl6KJ7RfkBNscr+wcgTy5D1BSz/HqmmvRqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDmkFD6zZjIKJDeHpYgvzHgXXOOH96JsIZhIJfTt8B6ZVVuajLjAgeDSPkqJJDss6
	 crss9rcblzKwm2cSxopQHY1X39s6hVSB5jiJDWCVZH/tZC1BUGfZUClKhey91MnZUt
	 1geEH89ZdnPp2ZlO5f/BdC5lvOIQzlMpGhQXDVb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/611] drm/amd/display: fix PSR-SU/DSC interoperability support
Date: Mon,  8 May 2023 11:38:46 +0200
Message-Id: <20230508094424.841310758@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit 13b90cf900ab69dd5cab3cc5035bc7614037e64e ]

Currently, there are issues with enabling PSR-SU + DSC. This stems from
the fact that DSC imposes a slice height on transmitted video data and
we are not conforming to that slice height in PSR-SU regions. So, pass
slice_height into su_y_granularity to feed the DSC slice height into
PSR-SU code.

Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 0b5dfe12755f ("drm/amd/display: fix a divided-by-zero error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c |  3 ++
 .../amd/display/modules/power/power_helpers.c | 31 +++++++++++++++++++
 .../amd/display/modules/power/power_helpers.h |  3 ++
 3 files changed, 37 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
index 26291db0a3cf6..872d06fe14364 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -122,6 +122,9 @@ bool amdgpu_dm_link_setup_psr(struct dc_stream_state *stream)
 		psr_config.allow_multi_disp_optimizations =
 			(amdgpu_dc_feature_mask & DC_PSR_ALLOW_MULTI_DISP_OPT);
 
+		if (!psr_su_set_y_granularity(dc, link, stream, &psr_config))
+			return false;
+
 		ret = dc_link_setup_psr(link, stream, &psr_config, &psr_context);
 
 	}
diff --git a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
index 235259d6c5a16..01fc6a368d2e3 100644
--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
@@ -907,3 +907,34 @@ bool mod_power_only_edp(const struct dc_state *context, const struct dc_stream_s
 {
 	return context && context->stream_count == 1 && dc_is_embedded_signal(stream->signal);
 }
+
+bool psr_su_set_y_granularity(struct dc *dc, struct dc_link *link,
+			      struct dc_stream_state *stream,
+			      struct psr_config *config)
+{
+	uint16_t pic_height;
+	uint8_t slice_height;
+
+	if ((link->connector_signal & SIGNAL_TYPE_EDP) &&
+	    (!dc->caps.edp_dsc_support ||
+	    link->panel_config.dsc.disable_dsc_edp ||
+	    !link->dpcd_caps.dsc_caps.dsc_basic_caps.fields.dsc_support.DSC_SUPPORT ||
+	    !stream->timing.dsc_cfg.num_slices_v))
+		return true;
+
+	pic_height = stream->timing.v_addressable +
+		stream->timing.v_border_top + stream->timing.v_border_bottom;
+	slice_height = pic_height / stream->timing.dsc_cfg.num_slices_v;
+
+	if (slice_height) {
+		if (config->su_y_granularity &&
+		    (slice_height % config->su_y_granularity)) {
+			ASSERT(0);
+			return false;
+		}
+
+		config->su_y_granularity = slice_height;
+	}
+
+	return true;
+}
diff --git a/drivers/gpu/drm/amd/display/modules/power/power_helpers.h b/drivers/gpu/drm/amd/display/modules/power/power_helpers.h
index 316452e9dbc91..bb16b37b83da7 100644
--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.h
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.h
@@ -59,4 +59,7 @@ void mod_power_calc_psr_configs(struct psr_config *psr_config,
 		const struct dc_stream_state *stream);
 bool mod_power_only_edp(const struct dc_state *context,
 		const struct dc_stream_state *stream);
+bool psr_su_set_y_granularity(struct dc *dc, struct dc_link *link,
+			      struct dc_stream_state *stream,
+			      struct psr_config *config);
 #endif /* MODULES_POWER_POWER_HELPERS_H_ */
-- 
2.39.2



