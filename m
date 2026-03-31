Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C81A426681;
	Tue, 31 Mar 2026 16:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975130; cv=none; b=QuaOfMR0UUXx5YxYL6hI2+qE92LmkEs+xuY1zU7Z+Cqrjle5kPMIJOQ0sYQQkV+jw6ftMhtmUcu2gCXbjA4KyfTpVu7HLMDpt29InNlln/d1QXreF5Aa6lCRI1jPCymj6fJNsBhRiAnfx2CKmYM/hz/V4+VT8ICnl8UzB3FcgAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975130; c=relaxed/simple;
	bh=78osZbyrLtGC5OfBiAiEvynaTmLTOY5l8BADTCoTQBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lwce7CV9A0yGFTLq3DQAoHM3jcOkWruPITOtp6RK/fMC0MN/9aAt1a0Dgw/He+mRVtiLYTh0DjdfX+/BQ4nAfWdVLNZsdZUvDxHpiM67fKGPX7PSJDlyG7eWpEW/pZhZXIwlOj0EhrHSx1GPnWyFrcQwozGdMgibo3DK4qVVaAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KmF9DKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KmF9DKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012A1C2BCB1;
	Tue, 31 Mar 2026 16:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975130;
	bh=78osZbyrLtGC5OfBiAiEvynaTmLTOY5l8BADTCoTQBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KmF9DKobGy6/dUi7fhRZpmypuJDSr1mqobd1REeatULJ5cRbmg5OxHiPxKlnNxWy
	 65TMZdt0fPC3gAd6cT9LqkHxEeJdbAtt6zp+SF0d4FUaLAIsmWLHXurVhkyHJN0WET
	 8faKPc00FwIJcxbPdYwoKfC7QmVoVtWew15elf3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yussuf Khalil <dev@pp3345.net>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 176/342] drm/amd/display: Do not skip unrelated mode changes in DSC validation
Date: Tue, 31 Mar 2026 18:20:09 +0200
Message-ID: <20260331161805.484271706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 5a54d3f4a3de5..1430d18ae2c9e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12505,6 +12505,11 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
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
index beb0d04d3e682..dbc3db0d68292 100644
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



