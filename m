Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375FD79DC;
	Sat, 30 Dec 2023 12:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC9Ur/nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB62C433C8;
	Sat, 30 Dec 2023 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937650;
	bh=mt+RDhVkwVPW4X5LRtr6G22nbNkFNAmMmpwaLPfSfTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DC9Ur/nmpiKgxep0xcGyI24Y005AvrdZGYM/ZuGJw4tS/l/YGSIxKSlrzQ2LzA1C5
	 uQf+L5m5ti5T9AIeQ3eFfYtZ2mFIdD2Dmt3SGxZReKfT6jg39XC4sEozB/gr9jglyL
	 HGismKdrJnrJTm3E2V6SqnVjlJ1LjmfPSLOFyoGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Animesh Manna <animesh.manna@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/156] drm/i915/edp: dont write to DP_LINK_BW_SET when using rate select
Date: Sat, 30 Dec 2023 11:57:44 +0000
Message-ID: <20231230115812.701902401@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit e6861d8264cd43c5eb20196e53df36fd71ec5698 ]

The eDP 1.5 spec adds a clarification for eDP 1.4x:

> For eDP v1.4x, if the Source device chooses the Main-Link rate by way
> of DPCD 00100h, the Sink device shall ignore DPCD 00115h[2:0].

We write 0 to DP_LINK_BW_SET (DPCD 100h) even when using
DP_LINK_RATE_SET (DPCD 114h). Stop doing that, as it can cause the panel
to ignore the rate set method.

Moreover, 0 is a reserved value for DP_LINK_BW_SET, and should not be
used.

v2: Improve the comments (Ville)

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9081
Tested-by: Animesh Manna <animesh.manna@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231205180551.2476228-1-jani.nikula@intel.com
(cherry picked from commit 23b392b94acb0499f69706c5808c099f590ebcf4)
Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/i915/display/intel_dp_link_training.c | 31 +++++++++++++------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index d09e43a38fa61..a62bca622b0a1 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -650,19 +650,30 @@ intel_dp_update_link_bw_set(struct intel_dp *intel_dp,
 			    const struct intel_crtc_state *crtc_state,
 			    u8 link_bw, u8 rate_select)
 {
-	u8 link_config[2];
+	u8 lane_count = crtc_state->lane_count;
 
-	/* Write the link configuration data */
-	link_config[0] = link_bw;
-	link_config[1] = crtc_state->lane_count;
 	if (crtc_state->enhanced_framing)
-		link_config[1] |= DP_LANE_COUNT_ENHANCED_FRAME_EN;
-	drm_dp_dpcd_write(&intel_dp->aux, DP_LINK_BW_SET, link_config, 2);
+		lane_count |= DP_LANE_COUNT_ENHANCED_FRAME_EN;
+
+	if (link_bw) {
+		/* DP and eDP v1.3 and earlier link bw set method. */
+		u8 link_config[] = { link_bw, lane_count };
 
-	/* eDP 1.4 rate select method. */
-	if (!link_bw)
-		drm_dp_dpcd_write(&intel_dp->aux, DP_LINK_RATE_SET,
-				  &rate_select, 1);
+		drm_dp_dpcd_write(&intel_dp->aux, DP_LINK_BW_SET, link_config,
+				  ARRAY_SIZE(link_config));
+	} else {
+		/*
+		 * eDP v1.4 and later link rate set method.
+		 *
+		 * eDP v1.4x sinks shall ignore DP_LINK_RATE_SET if
+		 * DP_LINK_BW_SET is set. Avoid writing DP_LINK_BW_SET.
+		 *
+		 * eDP v1.5 sinks allow choosing either, and the last choice
+		 * shall be active.
+		 */
+		drm_dp_dpcd_writeb(&intel_dp->aux, DP_LANE_COUNT_SET, lane_count);
+		drm_dp_dpcd_writeb(&intel_dp->aux, DP_LINK_RATE_SET, rate_select);
+	}
 }
 
 /*
-- 
2.43.0



