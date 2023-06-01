Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D710CFBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6428DC433D2;
	Thu,  1 Jun 2023 13:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685626031;
	bh=WOs93kXykVaacUYA1ZnyRnPSg86coQKN0xmVM7ZBFzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSdC/V+6XJx3/BdvMZQnlUD/pZSLuN7YPLoQIDR4wMdxp/u3ycYHG/ojH5IXPXh0D
	 xOz1CsoQlr2Oy+lJ8z6rzO0VnG4l8tmgeOpD1YewcTD0M+AVZcI+t+X+fo0p6D/h2H
	 jXnZRwGGeZh4VVKOKX0mV0m4012juRDAyoSSwes0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 23/45] drm/i915: Fix PIPEDMC disabling for a bigjoiner configuration
Date: Thu,  1 Jun 2023 14:21:19 +0100
Message-Id: <20230601131939.760754008@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 45dfbd992923f4df174db4e23b96fca7e30d73e2 ]

For a bigjoiner configuration display->crtc_disable() will be called
first for the slave CRTCs and then for the master CRTC. However slave
CRTCs will be actually disabled only after the master CRTC is disabled
(from the encoder disable hooks called with the master CRTC state).
Hence the slave PIPEDMCs can be disabled only after the master CRTC is
disabled, make this so.

intel_encoders_post_pll_disable() must be called only for the master
CRTC, as for the other two encoder disable hooks. While at it fix this
up as well. This didn't cause a problem, since
intel_encoders_post_pll_disable() will call the corresponding hook only
for an encoder/connector connected to the given CRTC, however slave
CRTCs will have no associated encoder/connector.

Fixes: 3af2ff0840be ("drm/i915: Enable a PIPEDMC whenever its corresponding pipe is enabled")
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230510103131.1618266-2-imre.deak@intel.com
(cherry picked from commit 7eeef32719f6af935a1554813e6bc206446339cd)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 963680ea6fedd..c84b581c61c6b 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -2022,9 +2022,17 @@ static void hsw_crtc_disable(struct intel_atomic_state *state,
 
 	intel_disable_shared_dpll(old_crtc_state);
 
-	intel_encoders_post_pll_disable(state, crtc);
+	if (!intel_crtc_is_bigjoiner_slave(old_crtc_state)) {
+		struct intel_crtc *slave_crtc;
+
+		intel_encoders_post_pll_disable(state, crtc);
 
-	intel_dmc_disable_pipe(i915, crtc->pipe);
+		intel_dmc_disable_pipe(i915, crtc->pipe);
+
+		for_each_intel_crtc_in_pipe_mask(&i915->drm, slave_crtc,
+						 intel_crtc_bigjoiner_slave_pipes(old_crtc_state))
+			intel_dmc_disable_pipe(i915, slave_crtc->pipe);
+	}
 }
 
 static void i9xx_pfit_enable(const struct intel_crtc_state *crtc_state)
-- 
2.39.2



