Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC9B2110E;
	Tue, 27 May 2025 17:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365483; cv=none; b=eLvajlNzdksy30tNHK0M5vVXiMwzpVgLg2C1ukvl1Ed5wA5LsouqcTYN/hYbX8QhDbFmsQ9NxjiEaJbRRFldDoGpYQb2nsJV/B/Rs7MUBk2l5xiRhwVCFcajBN508Q+6yWVUJVusQdNTi3F0QWjBnSEg/BwAdxPgoEKlixa+wKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365483; c=relaxed/simple;
	bh=o9ypahR3DsGnGTEj9cghb8mxSEduyfpShcIx0rcA/TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgDOi1K1fx0Xsmjz4iU44ihe6rnvijGV983ClE+XvoML0MuAlOlXDWV3Wmj1kUaGpRkeTd92uTfhs+GcPoBh1CRC9GqUfow7xvS1JKE0WeNCy4WYzOatJ7VD6SDH+6N3x34S8YbQvY4kfMvLdGHVdufAOcjrTOmVguxoN4nNvgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bC8YV59V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bC8YV59V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28D3C4CEE9;
	Tue, 27 May 2025 17:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365483;
	bh=o9ypahR3DsGnGTEj9cghb8mxSEduyfpShcIx0rcA/TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bC8YV59V0FUqqRpYQmnjR+hgtTFoEz6rjZeWBJmFoRVAzuWXaWvcHc5mv7pLGWW4h
	 EB/NR5SXScnn9P96bInjUtDeB+ZuBPh+VCptOqpiSJab9M5Z68kOJ+Wi8f/tDuA98u
	 v0vJKUxKRSJJU9pfP965z6rnpN2V15BcwoU53fd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 391/626] drm/amd/display: Dont try AUX transactions on disconnected link
Date: Tue, 27 May 2025 18:24:44 +0200
Message-ID: <20250527162500.909386088@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit e8bffa52e0253cfd689813a620e64521256bc712 ]

[Why]
Setting link DPMS off in response to HPD disconnect creates AUX
transactions on a link that is supposed to be disconnected. This can
cause issues in some cases when the sink re-asserts HPD and expects
source to re-enable the link.

[How]
Avoid AUX transactions on disconnected link.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c   | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c
index bafa52a0165a0..17c57cf98ec5c 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c
@@ -75,7 +75,8 @@ void dp_disable_link_phy(struct dc_link *link,
 	struct dc  *dc = link->ctx->dc;
 
 	if (!link->wa_flags.dp_keep_receiver_powered &&
-		!link->skip_implict_edp_power_control)
+			!link->skip_implict_edp_power_control &&
+			link->type != dc_connection_none)
 		dpcd_write_rx_power_ctrl(link, false);
 
 	dc->hwss.disable_link_output(link, link_res, signal);
@@ -163,8 +164,9 @@ enum dc_status dp_set_fec_ready(struct dc_link *link, const struct link_resource
 	} else {
 		if (link->fec_state == dc_link_fec_ready) {
 			fec_config = 0;
-			core_link_write_dpcd(link, DP_FEC_CONFIGURATION,
-				&fec_config, sizeof(fec_config));
+			if (link->type != dc_connection_none)
+				core_link_write_dpcd(link, DP_FEC_CONFIGURATION,
+					&fec_config, sizeof(fec_config));
 
 			link_enc->funcs->fec_set_ready(link_enc, false);
 			link->fec_state = dc_link_fec_not_ready;
-- 
2.39.5



