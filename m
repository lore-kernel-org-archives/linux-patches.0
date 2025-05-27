Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF12609F7;
	Tue, 27 May 2025 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364276; cv=none; b=Pz47TIMiCCnc2ZQQj0TL/womHptOizM9nxGmqT8lUP2rrFC2wKx1BpE1QpAjnmAV5qK9S8sY5lqVsf6cX6PtMTG2haYenVGSG9yIQcbsIhxvYGBt6sAXil1cyXP1p17hGoQogFjOX5s93OX7J8y9jDbL+S00UNgom/kSCwIjYC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364276; c=relaxed/simple;
	bh=5RkjCSxiT3gU3S4cUIYrCGbfV5zBwaLboP8vS4TT22Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAzU5veAJ3bbs6MFEorQJjcmEF3NA0gBjpZXFq9g64UPGp/8dVjRH7Y0UcM9+b9Zbk3uACCaN76thmb5TsNlKvP8T+9bHfGphyVYwOAt8S3oRPxSX2TNGqW6xNylat4Fe0zavksttOk/t9+ziXdD87lp0G8S4lyPKOyevgJMa6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jk/ZFkLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jk/ZFkLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAECCC4CEE9;
	Tue, 27 May 2025 16:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364276;
	bh=5RkjCSxiT3gU3S4cUIYrCGbfV5zBwaLboP8vS4TT22Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jk/ZFkLwWg40dmCbu6S9LUWXXX3HUpjCusrw+M2YUiDyHTEBTYloMU/mLD0l69Bsu
	 95mIX60pQlr8UMQXAFHNuMXClcpdKFBwFm6xhH4kPL0Bb2S5opu8/Pw+lAP27J1Y0s
	 VurrZyMqx8aiayauoZxe69s8w1i6SI7B+cRkZRpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	John Olender <john.olender@gmail.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/626] drm/amd/display: Defer BW-optimization-blocked DRR adjustments
Date: Tue, 27 May 2025 18:18:17 +0200
Message-ID: <20250527162445.230805752@linuxfoundation.org>
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

From: John Olender <john.olender@gmail.com>

[ Upstream commit 874697e127931bf50a37ce9d96ee80f3a08a0c38 ]

[Why & How]
Instead of dropping DRR updates, defer them. This fixes issues where
monitor continues to see incorrect refresh rate after VRR was turned off
by userspace.

Fixes: 32953485c558 ("drm/amd/display: Do not update DRR while BW optimizations pending")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3546
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: John Olender <john.olender@gmail.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 53761b7ecd83e6fbb9f2206f8c980a6aa308c844)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 ++
 drivers/gpu/drm/amd/display/dc/core/dc.c          | 10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ff33760aa4fae..17c03b89abb31 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -365,6 +365,8 @@ get_crtc_by_otg_inst(struct amdgpu_device *adev,
 static inline bool is_dc_timing_adjust_needed(struct dm_crtc_state *old_state,
 					      struct dm_crtc_state *new_state)
 {
+	if (new_state->stream->adjust.timing_adjust_pending)
+		return true;
 	if (new_state->freesync_config.state ==  VRR_STATE_ACTIVE_FIXED)
 		return true;
 	else if (amdgpu_dm_crtc_vrr_active(old_state) != amdgpu_dm_crtc_vrr_active(new_state))
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index a76e6fc3fef78..dd4b131fac6cb 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -438,9 +438,12 @@ bool dc_stream_adjust_vmin_vmax(struct dc *dc,
 	 * Don't adjust DRR while there's bandwidth optimizations pending to
 	 * avoid conflicting with firmware updates.
 	 */
-	if (dc->ctx->dce_version > DCE_VERSION_MAX)
-		if (dc->optimized_required || dc->wm_optimized_required)
+	if (dc->ctx->dce_version > DCE_VERSION_MAX) {
+		if (dc->optimized_required || dc->wm_optimized_required) {
+			stream->adjust.timing_adjust_pending = true;
 			return false;
+		}
+	}
 
 	dc_exit_ips_for_hw_access(dc);
 
@@ -2978,7 +2981,8 @@ static void copy_stream_update_to_stream(struct dc *dc,
 
 	if (update->crtc_timing_adjust) {
 		if (stream->adjust.v_total_min != update->crtc_timing_adjust->v_total_min ||
-			stream->adjust.v_total_max != update->crtc_timing_adjust->v_total_max)
+			stream->adjust.v_total_max != update->crtc_timing_adjust->v_total_max ||
+			stream->adjust.timing_adjust_pending)
 			update->crtc_timing_adjust->timing_adjust_pending = true;
 		stream->adjust = *update->crtc_timing_adjust;
 		update->crtc_timing_adjust->timing_adjust_pending = false;
-- 
2.39.5



