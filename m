Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B638526AC3;
	Tue, 11 Nov 2025 01:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824181; cv=none; b=pBTFex8zEWSsxgzse5f6S8otDR+wyAmuY9WfzpnKVQOjmN+KzoHSyLwpYgRVAtDZXoDXKH/qjC6M3g/t2QT17TGNOtEk93i1/3h3j1P2Sbuf1AkHJ61cr5xpWB0ipHS795iXt1eP4Ys9+N7bnJTJs8meS9Vfajz4FBFzT+n0qSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824181; c=relaxed/simple;
	bh=OzdyECXGHv10qXSQ/xA/NcxIXVK7XIG/0eAwlLsTYHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzF++Da7pyYxzY3502j41ayACK/iSImebrsPw2LXQn+xVPd/kW0Kvy/rgPO7vNsJmR9OlFr3DSp34WsQRAKTis80xEmuZLyENcsGiWW6T8xzMNY3m3at6WfKgiq8OvUIcylOeRaxtlO+HjZGvKwrnx1Va4Z1dSixZNnbtOlD+5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNPfaqwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNPfaqwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B77C116D0;
	Tue, 11 Nov 2025 01:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824181;
	bh=OzdyECXGHv10qXSQ/xA/NcxIXVK7XIG/0eAwlLsTYHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNPfaqwL6lDA2zjWeWVp0wyd81mrJ/7m7gqtVGVEr0LAAWgO4N0Suvv1ViLe+pe2d
	 rCvio7aCy9/scQfx2OiesnQ7J7eIlSDM94pkaBU5WS8F+cKld5qGnwc07upFFD7AQO
	 oPeH9iOwfnFEZ9Gtid8N8NyzbsVQK0LZq4Yeakig=
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
Subject: [PATCH 6.17 457/849] drm/amd/display: Fix pbn_div Calculation Error
Date: Tue, 11 Nov 2025 09:40:27 +0900
Message-ID: <20251111004547.478230959@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index aca57cc815514..afe3a8279c3a9 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7974,7 +7974,7 @@ static int dm_encoder_helper_atomic_check(struct drm_encoder *encoder,
 	if (IS_ERR(mst_state))
 		return PTR_ERR(mst_state);
 
-	mst_state->pbn_div.full = dfixed_const(dm_mst_get_pbn_divider(aconnector->mst_root->dc_link));
+	mst_state->pbn_div.full = dm_mst_get_pbn_divider(aconnector->mst_root->dc_link);
 
 	if (!state->duplicated) {
 		int max_bpc = conn_state->max_requested_bpc;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 77a9d2c7d3185..5412bf046062c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -822,13 +822,20 @@ void amdgpu_dm_initialize_dp_connector(struct amdgpu_display_manager *dm,
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



