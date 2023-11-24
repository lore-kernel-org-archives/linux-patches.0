Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F5364C1;
	Fri, 24 Nov 2023 18:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkmNMZUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07158C433C8;
	Fri, 24 Nov 2023 18:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851568;
	bh=agN2MhSdkCDy6VZ4ZRF6xgiSPGw+2Pzk4c0Q1sglx8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkmNMZUt7ilHQdAYwJ3aHHFToTP2PPNUFoXHShefa4JUzWY6Qa/PsqLwdBF+IHmjD
	 8a4Nm2NdxS5An6I5TRcfNt67/fUZ0FnE4/nOIRSmWmo7mK0okGlaNwbHDuBT+RLsh3
	 cw3XqrV8n/NRSCyHCR0Cx0T28JLDmM1j6VwekMKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.5 486/491] drm/amd/display: Fix DSC not Enabled on Direct MST Sink
Date: Fri, 24 Nov 2023 17:52:02 +0000
Message-ID: <20231124172039.236447914@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <jerry.zuo@amd.com>

commit a58555359a9f870543aaddef277c3396159895ce upstream.

[WHY & HOW]
For the scenario when a dsc capable MST sink device is directly
connected, it needs to use max dsc compression as the link bw constraint.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Roman Li <roman.li@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   29 +++++-------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1591,31 +1591,31 @@ enum dc_status dm_dp_mst_is_port_support
 	unsigned int upper_link_bw_in_kbps = 0, down_link_bw_in_kbps = 0;
 	unsigned int max_compressed_bw_in_kbps = 0;
 	struct dc_dsc_bw_range bw_range = {0};
-	struct drm_dp_mst_topology_mgr *mst_mgr;
+	uint16_t full_pbn = aconnector->mst_output_port->full_pbn;
 
 	/*
-	 * check if the mode could be supported if DSC pass-through is supported
-	 * AND check if there enough bandwidth available to support the mode
-	 * with DSC enabled.
+	 * Consider the case with the depth of the mst topology tree is equal or less than 2
+	 * A. When dsc bitstream can be transmitted along the entire path
+	 *    1. dsc is possible between source and branch/leaf device (common dsc params is possible), AND
+	 *    2. dsc passthrough supported at MST branch, or
+	 *    3. dsc decoding supported at leaf MST device
+	 *    Use maximum dsc compression as bw constraint
+	 * B. When dsc bitstream cannot be transmitted along the entire path
+	 *    Use native bw as bw constraint
 	 */
 	if (is_dsc_common_config_possible(stream, &bw_range) &&
-	    aconnector->mst_output_port->passthrough_aux) {
-		mst_mgr = aconnector->mst_output_port->mgr;
-		mutex_lock(&mst_mgr->lock);
-
+	   (aconnector->mst_output_port->passthrough_aux ||
+	    aconnector->dsc_aux == &aconnector->mst_output_port->aux)) {
 		cur_link_settings = stream->link->verified_link_cap;
 
 		upper_link_bw_in_kbps = dc_link_bandwidth_kbps(aconnector->dc_link,
-							       &cur_link_settings
-							       );
-		down_link_bw_in_kbps = kbps_from_pbn(aconnector->mst_output_port->full_pbn);
+							       &cur_link_settings);
+		down_link_bw_in_kbps = kbps_from_pbn(full_pbn);
 
 		/* pick the bottleneck */
 		end_to_end_bw_in_kbps = min(upper_link_bw_in_kbps,
 					    down_link_bw_in_kbps);
 
-		mutex_unlock(&mst_mgr->lock);
-
 		/*
 		 * use the maximum dsc compression bandwidth as the required
 		 * bandwidth for the mode
@@ -1630,8 +1630,7 @@ enum dc_status dm_dp_mst_is_port_support
 		/* check if mode could be supported within full_pbn */
 		bpp = convert_dc_color_depth_into_bpc(stream->timing.display_color_depth) * 3;
 		pbn = drm_dp_calc_pbn_mode(stream->timing.pix_clk_100hz / 10, bpp, false);
-
-		if (pbn > aconnector->mst_output_port->full_pbn)
+		if (pbn > full_pbn)
 			return DC_FAIL_BANDWIDTH_VALIDATE;
 	}
 


