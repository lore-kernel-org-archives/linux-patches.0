Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECEB346FD4;
	Tue, 11 Nov 2025 01:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823731; cv=none; b=jW+yoaXXEMMjOmr1oTKJTm4ZXtLNZmYTUYK6eRp7molSNt9A++T/OJiEBh4yVPBhoc2QFgTrVPOIivyRSIlFVjWm5sg0pHixuRLHpghrc0S6Kpn3ESE/+NzyubplProkNAy+Fi1kIFi5eS8brbtnSPRi24+S0aiMlq3FIJkAXg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823731; c=relaxed/simple;
	bh=QM7ALa19JHZcOXaY2Blbs0J9ioHcTJ7VP6setV/4dgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeQg1dFoa8GwmyzYzYe4qkZUpcJr012KNlpCIU/WCOLPG1Cl1dBAdiF40mARCi1A0UXPKgArjhvmy/hVVNhcchRyTPw+1a2Cm9HaSOI1H8pC3937D5x1sdoeEFcXeA7Xd64casPyEoWmvaEQpEoEacdDRmtOyqOpX/sIFDToOIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wILd5U1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wILd5U1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1FDC113D0;
	Tue, 11 Nov 2025 01:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823730;
	bh=QM7ALa19JHZcOXaY2Blbs0J9ioHcTJ7VP6setV/4dgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wILd5U1qdhV5QXZvEEvFyvqcTZt/lyiECTJM/+s6qwNAPVs9AlY+/4aMWeFuKsYeP
	 GIfd3kqYm6UTVIR3utkwG/dyXlh/czqYbCLEnjmypOeB8LrTX/Xo4DP+ifp78dB75f
	 yEfkO99vi73YU4KpGj5AOWRonZo6+xPlVnqkYtLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/565] drm/amd/display: Fix pbn_div Calculation Error
Date: Tue, 11 Nov 2025 09:42:45 +0900
Message-ID: <20251111004533.836692948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 12cdfb61b32a7be581ec5932e0b6a482cb098204 ]

[Why]
dm_mst_get_pbn_divider() returns value integer coming from
the cast from fixed point, but the casted integer will then be used
in dfixed_const to be multiplied by 4096. The cast from fixed point to integer
causes the calculation error becomes bigger when multiplied by 4096.

That makes the calculated pbn_div value becomes smaller than
it should be, which leads to the req_slot number becomes bigger.

Such error is getting reflected in 8k30 timing,
where the correct and incorrect calculated req_slot 62.9 Vs 63.1.
That makes the wrong calculation failed to light up 8k30
after a dock under HBR3 x 4.

[How]
Restore the accuracy by keeping the fraction part
calculated for the left shift operation.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   |  2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 13 ++++++++++---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h |  2 +-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ffa0d7483ffc1..fd44d011ffd2d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7715,7 +7715,7 @@ static int dm_encoder_helper_atomic_check(struct drm_encoder *encoder,
 	if (IS_ERR(mst_state))
 		return PTR_ERR(mst_state);
 
-	mst_state->pbn_div.full = dfixed_const(dm_mst_get_pbn_divider(aconnector->mst_root->dc_link));
+	mst_state->pbn_div.full = dm_mst_get_pbn_divider(aconnector->mst_root->dc_link);
 
 	if (!state->duplicated) {
 		int max_bpc = conn_state->max_requested_bpc;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 92158009cfa73..a2a70c1e9afdc 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -816,13 +816,20 @@ void amdgpu_dm_initialize_dp_connector(struct amdgpu_display_manager *dm,
 	drm_connector_attach_dp_subconnector_property(&aconnector->base);
 }
 
-int dm_mst_get_pbn_divider(struct dc_link *link)
+uint32_t dm_mst_get_pbn_divider(struct dc_link *link)
 {
+	uint32_t pbn_div_x100;
+	uint64_t dividend, divisor;
+
 	if (!link)
 		return 0;
 
-	return dc_link_bandwidth_kbps(link,
-			dc_link_get_link_cap(link)) / (8 * 1000 * 54);
+	dividend = (uint64_t)dc_link_bandwidth_kbps(link, dc_link_get_link_cap(link)) * 100;
+	divisor = 8 * 1000 * 54;
+
+	pbn_div_x100 = div64_u64(dividend, divisor);
+
+	return dfixed_const(pbn_div_x100) / 100;
 }
 
 struct dsc_mst_fairness_params {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index 600d6e2210111..179f622492dbf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -59,7 +59,7 @@ enum mst_msg_ready_type {
 struct amdgpu_display_manager;
 struct amdgpu_dm_connector;
 
-int dm_mst_get_pbn_divider(struct dc_link *link);
+uint32_t dm_mst_get_pbn_divider(struct dc_link *link);
 
 void amdgpu_dm_initialize_dp_connector(struct amdgpu_display_manager *dm,
 				       struct amdgpu_dm_connector *aconnector,
-- 
2.51.0



