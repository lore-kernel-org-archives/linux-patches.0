Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C862E1C7C;
	Tue, 31 Mar 2026 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976613; cv=none; b=We5RURexG2EMoWSypkVPoU/wmdihT7StUaR0FNHo5YoCJ/MUCxUbRb+5tO/SrDn2bx3YR1BI7xxQdgrv586UrdZdb07zArIUazpxnXAG5lBySmhr6InKLgu5kN6kdI3zdOVURzZl9TV4mmJOWbT68FXOdM8q+5M+hNzINu8SQps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976613; c=relaxed/simple;
	bh=LATj+s/F751T4JIphJwc0INyemF3i7BnaIiP+s6Fvm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M59p2V3G6NfyraouDrM5VV95mw+2KI7J4oOqoQMHKNWumoJ45mod5XXTDVgwpzCTTCGExW54X2EBH29hBrzFqUbBV8LvybDZhzO6Fn6v+8hHxzxQB/Z/VEOcV25Gi9S1YbkFPo6gbJfXJ8uIg7um/0Q8Y077kLiHe/28/7ZDu/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMFL4MXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMFL4MXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CBCC19423;
	Tue, 31 Mar 2026 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976613;
	bh=LATj+s/F751T4JIphJwc0INyemF3i7BnaIiP+s6Fvm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMFL4MXvZ0HSuMwAIBzVkQ69oQ7eVzkBYEKV/k/RvCV7yVtETfkVJLB1MVEgJuGKM
	 4vJU1/HwUxjl4iVG8b6WqSzy4gLaLVXEsI+EsCjB91HfKrwjLIgcMWTFMAJIYE5Ae2
	 OeC1ej5BtPWH2bqytXg44TJWB4HtkeLqci2Tj3PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yussuf Khalil <dev@pp3345.net>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/309] drm/amd/display: Do not skip unrelated mode changes in DSC validation
Date: Tue, 31 Mar 2026 18:21:02 +0200
Message-ID: <20260331161759.319420541@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yussuf Khalil <dev@pp3345.net>

[ Upstream commit aed3d041ab061ec8a64f50a3edda0f4db7280025 ]

Starting with commit 17ce8a6907f7 ("drm/amd/display: Add dsc pre-validation in
atomic check"), amdgpu resets the CRTC state mode_changed flag to false when
recomputing the DSC configuration results in no timing change for a particular
stream.

However, this is incorrect in scenarios where a change in MST/DSC configuration
happens in the same KMS commit as another (unrelated) mode change. For example,
the integrated panel of a laptop may be configured differently (e.g., HDR
enabled/disabled) depending on whether external screens are attached. In this
case, plugging in external DP-MST screens may result in the mode_changed flag
being dropped incorrectly for the integrated panel if its DSC configuration
did not change during precomputation in pre_validate_dsc().

At this point, however, dm_update_crtc_state() has already created new streams
for CRTCs with DSC-independent mode changes. In turn,
amdgpu_dm_commit_streams() will never release the old stream, resulting in a
memory leak. amdgpu_dm_atomic_commit_tail() will never acquire a reference to
the new stream either, which manifests as a use-after-free when the stream gets
disabled later on:

BUG: KASAN: use-after-free in dc_stream_release+0x25/0x90 [amdgpu]
Write of size 4 at addr ffff88813d836524 by task kworker/9:9/29977

Workqueue: events drm_mode_rmfb_work_fn
Call Trace:
 <TASK>
 dump_stack_lvl+0x6e/0xa0
 print_address_description.constprop.0+0x88/0x320
 ? dc_stream_release+0x25/0x90 [amdgpu]
 print_report+0xfc/0x1ff
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __virt_addr_valid+0x225/0x4e0
 ? dc_stream_release+0x25/0x90 [amdgpu]
 kasan_report+0xe1/0x180
 ? dc_stream_release+0x25/0x90 [amdgpu]
 kasan_check_range+0x125/0x200
 dc_stream_release+0x25/0x90 [amdgpu]
 dc_state_destruct+0x14d/0x5c0 [amdgpu]
 dc_state_release.part.0+0x4e/0x130 [amdgpu]
 dm_atomic_destroy_state+0x3f/0x70 [amdgpu]
 drm_atomic_state_default_clear+0x8ee/0xf30
 ? drm_mode_object_put.part.0+0xb1/0x130
 __drm_atomic_state_free+0x15c/0x2d0
 atomic_remove_fb+0x67e/0x980

Since there is no reliable way of figuring out whether a CRTC has unrelated
mode changes pending at the time of DSC validation, remember the value of the
mode_changed flag from before the point where a CRTC was marked as potentially
affected by a change in DSC configuration. Reset the mode_changed flag to this
earlier value instead in pre_validate_dsc().

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5004
Fixes: 17ce8a6907f7 ("drm/amd/display: Add dsc pre-validation in atomic check")
Signed-off-by: Yussuf Khalil <dev@pp3345.net>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cc7c7121ae082b7b82891baa7280f1ff2608f22b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           | 5 +++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h           | 1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 77840b6cb2065..82a74e2cd721d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12268,6 +12268,11 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	}
 
 	if (dc_resource_is_dsc_encoding_supported(dc)) {
+		for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
+			dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
+			dm_new_crtc_state->mode_changed_independent_from_dsc = new_crtc_state->mode_changed;
+		}
+
 		for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 			if (drm_atomic_crtc_needs_modeset(new_crtc_state)) {
 				ret = add_affected_mst_dsc_crtcs(state, crtc);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index adcd7ea696719..cd362d22a2774 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -965,6 +965,7 @@ struct dm_crtc_state {
 
 	bool freesync_vrr_info_changed;
 
+	bool mode_changed_independent_from_dsc;
 	bool dsc_force_changed;
 	bool vrr_supported;
 	struct mod_freesync_config freesync_config;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 5e92eaa67aa33..2e0895f4f9b10 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1744,9 +1744,11 @@ int pre_validate_dsc(struct drm_atomic_state *state,
 			int ind = find_crtc_index_in_state_by_stream(state, stream);
 
 			if (ind >= 0) {
+				struct dm_crtc_state *dm_new_crtc_state = to_dm_crtc_state(state->crtcs[ind].new_state);
+
 				DRM_INFO_ONCE("%s:%d MST_DSC no mode changed for stream 0x%p\n",
 						__func__, __LINE__, stream);
-				state->crtcs[ind].new_state->mode_changed = 0;
+				dm_new_crtc_state->base.mode_changed = dm_new_crtc_state->mode_changed_independent_from_dsc;
 			}
 		}
 	}
-- 
2.53.0



