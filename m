Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E7779CD;
	Sat, 30 Dec 2023 12:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCildO1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0333C433C7;
	Sat, 30 Dec 2023 12:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937705;
	bh=btoI6Vk3OR0R1Jp4p8c8SJOGkopj3SLp5BnyKeFz7FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCildO1CbNccjfWX6Ep58V95vipHnmPt4Zu+r0KsLwKgOUOxRmG8bhjjqaBdzKukV
	 u1xlB1ePvw+XszU4swrjpsQ+oyAw59Sr1A90CQxD4wV5nlvx1Lg3Y+RQ6iJnUSxjEe
	 AEpWWeLOlAIRBWDmxvjx+V8jbOkUPzqKqnzeFiEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/156] drm/i915: Fix FEC state dump
Date: Sat, 30 Dec 2023 11:57:42 +0000
Message-ID: <20231230115812.622776245@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 3dfeb80b308882cc6e1f5f6c36fd9a7f4cae5fc6 ]

Stop dumping state while reading it out. We have a proper
place for that stuff.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230502143906.2401-7-ville.syrjala@linux.intel.com
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
Stable-dep-of: e6861d8264cd ("drm/i915/edp: don't write to DP_LINK_BW_SET when using rate select")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/display/intel_crtc_state_dump.c    |  2 ++
 drivers/gpu/drm/i915/display/intel_ddi.c            | 13 +++----------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c b/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c
index 8d4640d0fd346..8b34fa55fa1bd 100644
--- a/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c
+++ b/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c
@@ -258,6 +258,8 @@ void intel_crtc_state_dump(const struct intel_crtc_state *pipe_config,
 		intel_dump_m_n_config(pipe_config, "dp m2_n2",
 				      pipe_config->lane_count,
 				      &pipe_config->dp_m2_n2);
+		drm_dbg_kms(&i915->drm, "fec: %s\n",
+			    str_enabled_disabled(pipe_config->fec_enable));
 	}
 
 	drm_dbg_kms(&i915->drm, "framestart delay: %d, MSA timing delay: %d\n",
diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 84bbf854337aa..85e2263e688de 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3724,17 +3724,10 @@ static void intel_ddi_read_func_ctl(struct intel_encoder *encoder,
 		intel_cpu_transcoder_get_m2_n2(crtc, cpu_transcoder,
 					       &pipe_config->dp_m2_n2);
 
-		if (DISPLAY_VER(dev_priv) >= 11) {
-			i915_reg_t dp_tp_ctl = dp_tp_ctl_reg(encoder, pipe_config);
-
+		if (DISPLAY_VER(dev_priv) >= 11)
 			pipe_config->fec_enable =
-				intel_de_read(dev_priv, dp_tp_ctl) & DP_TP_CTL_FEC_ENABLE;
-
-			drm_dbg_kms(&dev_priv->drm,
-				    "[ENCODER:%d:%s] Fec status: %u\n",
-				    encoder->base.base.id, encoder->base.name,
-				    pipe_config->fec_enable);
-		}
+				intel_de_read(dev_priv,
+					      dp_tp_ctl_reg(encoder, pipe_config)) & DP_TP_CTL_FEC_ENABLE;
 
 		if (dig_port->lspcon.active && intel_dp_has_hdmi_sink(&dig_port->dp))
 			pipe_config->infoframes.enable |=
-- 
2.43.0



