Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68C31EE033;
	Wed, 17 Sep 2025 12:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113046; cv=none; b=PoP+t2u/bBhLwBgvzUtScTRkBJzZNCaK9hROYZsRP/btut2N8pylzgVm3B84qUP3F8zRRkUxRxzBBzp0/Os+iI0fdYHRMhUIsIyNHi0hRo/s9A4OdsNtM3LT+mdj1sshD/RKXHz/zje3nxi/5NDj4cHgyhGvIBvYkjSTckfUhCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113046; c=relaxed/simple;
	bh=EHDHnq2YSsDxcC29f0n8PU7veUhyjmA34Rna2g37L+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfaNWZn0s6udGsxYXYfo6LYlAKPE7NRpDfRwY4gNLX2v1PQeO8P9m7b4NKrq9hT0bcqYE9jISX3KDxzZZiRbk9kaX0iwuajgzJmZai7zL423Honn+C9Cg04Lfw5et58GwrFzgunmIpBZIXaSZPXsmhjYIIfwgMc8fRmNFdwtxKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRvJjpoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRvJjpoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3844FC4CEF7;
	Wed, 17 Sep 2025 12:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113046;
	bh=EHDHnq2YSsDxcC29f0n8PU7veUhyjmA34Rna2g37L+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRvJjpohQIkhr399doQYbb/EqjKOJA8Bpj1/9IT7y/iUOJyLLs+aT664yFRy9aEti
	 a2D916hDnvgKnft4rEEE5aynoWpDCTI7r8IoeHk7y/WlK8x8e4sndQNUdtioSiXybz
	 JRLBfWBt6PLqDC8sG4TA6Di4UlmOgWD/MWj2HN1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 110/189] drm/amd/display: Destroy cached state in complete() callback
Date: Wed, 17 Sep 2025 14:33:40 +0200
Message-ID: <20250917123354.555573562@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 45cc102f8e6520ac07637c7e09f61dcc3772e125 ]

[Why]
When the suspend sequence has been aborted after prepare() but
before suspend() the resume() callback never gets called. The PM core
will call complete() when this happens. As the state has been cached
in prepare() it needs to be destroyed in complete() if it's still around.

[How]
Create a helper for destroying cached state and call it both in resume()
and complete() callbacks. If resume has been called the state will be
destroyed and it's a no-op for complete().  If resume hasn't been called
(such as an aborted suspend) then destroy the state in complete().

Fixes: 50e0bae34fa6 ("drm/amd/display: Add and use new dm_prepare_suspend() callback")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Link: https://lore.kernel.org/r/20250602014432.3538345-4-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 60f71f0db7b1 ("drm/amd/display: Drop dm_prepare_suspend() and dm_complete()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  100 +++++++++++++---------
 1 file changed, 60 insertions(+), 40 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3084,6 +3084,64 @@ static int dm_cache_state(struct amdgpu_
 	return adev->dm.cached_state ? 0 : r;
 }
 
+static void dm_destroy_cached_state(struct amdgpu_device *adev)
+{
+	struct amdgpu_display_manager *dm = &adev->dm;
+	struct drm_device *ddev = adev_to_drm(adev);
+	struct dm_plane_state *dm_new_plane_state;
+	struct drm_plane_state *new_plane_state;
+	struct dm_crtc_state *dm_new_crtc_state;
+	struct drm_crtc_state *new_crtc_state;
+	struct drm_plane *plane;
+	struct drm_crtc *crtc;
+	int i;
+
+	if (!dm->cached_state)
+		return;
+
+	/* Force mode set in atomic commit */
+	for_each_new_crtc_in_state(dm->cached_state, crtc, new_crtc_state, i) {
+		new_crtc_state->active_changed = true;
+		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
+		reset_freesync_config_for_crtc(dm_new_crtc_state);
+	}
+
+	/*
+	 * atomic_check is expected to create the dc states. We need to release
+	 * them here, since they were duplicated as part of the suspend
+	 * procedure.
+	 */
+	for_each_new_crtc_in_state(dm->cached_state, crtc, new_crtc_state, i) {
+		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
+		if (dm_new_crtc_state->stream) {
+			WARN_ON(kref_read(&dm_new_crtc_state->stream->refcount) > 1);
+			dc_stream_release(dm_new_crtc_state->stream);
+			dm_new_crtc_state->stream = NULL;
+		}
+		dm_new_crtc_state->base.color_mgmt_changed = true;
+	}
+
+	for_each_new_plane_in_state(dm->cached_state, plane, new_plane_state, i) {
+		dm_new_plane_state = to_dm_plane_state(new_plane_state);
+		if (dm_new_plane_state->dc_state) {
+			WARN_ON(kref_read(&dm_new_plane_state->dc_state->refcount) > 1);
+			dc_plane_state_release(dm_new_plane_state->dc_state);
+			dm_new_plane_state->dc_state = NULL;
+		}
+	}
+
+	drm_atomic_helper_resume(ddev, dm->cached_state);
+
+	dm->cached_state = NULL;
+}
+
+static void dm_complete(struct amdgpu_ip_block *ip_block)
+{
+	struct amdgpu_device *adev = ip_block->adev;
+
+	dm_destroy_cached_state(adev);
+}
+
 static int dm_prepare_suspend(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
@@ -3317,12 +3375,6 @@ static int dm_resume(struct amdgpu_ip_bl
 	struct amdgpu_dm_connector *aconnector;
 	struct drm_connector *connector;
 	struct drm_connector_list_iter iter;
-	struct drm_crtc *crtc;
-	struct drm_crtc_state *new_crtc_state;
-	struct dm_crtc_state *dm_new_crtc_state;
-	struct drm_plane *plane;
-	struct drm_plane_state *new_plane_state;
-	struct dm_plane_state *dm_new_plane_state;
 	struct dm_atomic_state *dm_state = to_dm_atomic_state(dm->atomic_obj.state);
 	enum dc_connection_type new_connection_type = dc_connection_none;
 	struct dc_state *dc_state;
@@ -3481,40 +3533,7 @@ static int dm_resume(struct amdgpu_ip_bl
 	}
 	drm_connector_list_iter_end(&iter);
 
-	/* Force mode set in atomic commit */
-	for_each_new_crtc_in_state(dm->cached_state, crtc, new_crtc_state, i) {
-		new_crtc_state->active_changed = true;
-		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
-		reset_freesync_config_for_crtc(dm_new_crtc_state);
-	}
-
-	/*
-	 * atomic_check is expected to create the dc states. We need to release
-	 * them here, since they were duplicated as part of the suspend
-	 * procedure.
-	 */
-	for_each_new_crtc_in_state(dm->cached_state, crtc, new_crtc_state, i) {
-		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
-		if (dm_new_crtc_state->stream) {
-			WARN_ON(kref_read(&dm_new_crtc_state->stream->refcount) > 1);
-			dc_stream_release(dm_new_crtc_state->stream);
-			dm_new_crtc_state->stream = NULL;
-		}
-		dm_new_crtc_state->base.color_mgmt_changed = true;
-	}
-
-	for_each_new_plane_in_state(dm->cached_state, plane, new_plane_state, i) {
-		dm_new_plane_state = to_dm_plane_state(new_plane_state);
-		if (dm_new_plane_state->dc_state) {
-			WARN_ON(kref_read(&dm_new_plane_state->dc_state->refcount) > 1);
-			dc_plane_state_release(dm_new_plane_state->dc_state);
-			dm_new_plane_state->dc_state = NULL;
-		}
-	}
-
-	drm_atomic_helper_resume(ddev, dm->cached_state);
-
-	dm->cached_state = NULL;
+	dm_destroy_cached_state(adev);
 
 	/* Do mst topology probing after resuming cached state*/
 	drm_connector_list_iter_begin(ddev, &iter);
@@ -3563,6 +3582,7 @@ static const struct amd_ip_funcs amdgpu_
 	.prepare_suspend = dm_prepare_suspend,
 	.suspend = dm_suspend,
 	.resume = dm_resume,
+	.complete = dm_complete,
 	.is_idle = dm_is_idle,
 	.wait_for_idle = dm_wait_for_idle,
 	.check_soft_reset = dm_check_soft_reset,


