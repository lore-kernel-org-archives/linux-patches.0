Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C170EEB9;
	Tue, 23 Jan 2024 00:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969541; cv=none; b=DnH3CCx9Siyew8oNg0O2IM/k1np9aCbi8lCjvelfSOnoAw7sRiFmpdeHR4aIbZUQaoCt5i8o/kuqQy2Yy886LEwo2zIKwEv6RSD+PvQxiTFcAmMANLW1tOycJ8EngjqSgmTkcfNjj4/78ZAS3bqmTJDVmr/PNseyWXCqt+NFn+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969541; c=relaxed/simple;
	bh=l9KH4Y8S7qNjsIYQjyYoqdHPvjUecMN610aMiwlAG9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctgb+t01w4PN3Y5kp0M7xYFPzxZKxOUioUtB8uTgLIiSBJPVkE/9yHiA4x2rBTdCwPFrbjmgwkqPH3aaqctWDnr1OeHO6z9v/6vpTYLdaFSkr7HvlJe5tXgNbE+2dA4jru8Cwnnz6CQ+lZ6IHxk6aaXVZwnkzEM2zXlemLWUDxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivju4Hzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivju4Hzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ADDC433F1;
	Tue, 23 Jan 2024 00:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969541;
	bh=l9KH4Y8S7qNjsIYQjyYoqdHPvjUecMN610aMiwlAG9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivju4HzpSWnJnjawkEOiq2G2/aqSMWUPxCNGgoBNT6AVBS5EZuF1qM0Irwak8azDZ
	 10auT9mfgZNXBLXiRRTVtFcy7vfczQ0SE4LlcI5cSoSIL3SsoBwwfnMHKuTV6qCFqt
	 FZQzd8Vh55aEtSjR+l/RoL5mETAgEpC+29JAzkj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 291/641] drm/amd/display: Return drm_connector from find_first_crtc_matching_connector
Date: Mon, 22 Jan 2024 15:53:15 -0800
Message-ID: <20240122235827.002294112@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit 748b091d641638e68330b1b24195eaba9aadf997 ]

[WHY]
We will be dealing with two types of connector: amdgpu_dm_connector
and drm_writeback_connector.

[HOW]
We want to find both and then cast to the appriopriate type afterwards.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: dbf5d3d02987 ("drm/amd/display: Check writeback connectors in create_validate_stream_for_sink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c         | 8 +++++---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h         | 2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c   | 4 +++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d8c967cee498..5cf919a489a1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2660,7 +2660,7 @@ static int dm_suspend(void *handle)
 	return 0;
 }
 
-struct amdgpu_dm_connector *
+struct drm_connector *
 amdgpu_dm_find_first_crtc_matching_connector(struct drm_atomic_state *state,
 					     struct drm_crtc *crtc)
 {
@@ -2673,7 +2673,7 @@ amdgpu_dm_find_first_crtc_matching_connector(struct drm_atomic_state *state,
 		crtc_from_state = new_con_state->crtc;
 
 		if (crtc_from_state == crtc)
-			return to_amdgpu_dm_connector(connector);
+			return connector;
 	}
 
 	return NULL;
@@ -9354,6 +9354,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	 * update changed items
 	 */
 	struct amdgpu_crtc *acrtc = NULL;
+	struct drm_connector *connector = NULL;
 	struct amdgpu_dm_connector *aconnector = NULL;
 	struct drm_connector_state *drm_new_conn_state = NULL, *drm_old_conn_state = NULL;
 	struct dm_connector_state *dm_new_conn_state = NULL, *dm_old_conn_state = NULL;
@@ -9363,7 +9364,8 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	dm_old_crtc_state = to_dm_crtc_state(old_crtc_state);
 	dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
 	acrtc = to_amdgpu_crtc(crtc);
-	aconnector = amdgpu_dm_find_first_crtc_matching_connector(state, crtc);
+	connector = amdgpu_dm_find_first_crtc_matching_connector(state, crtc);
+	aconnector = to_amdgpu_dm_connector(connector);
 
 	/* TODO This hack should go away */
 	if (aconnector && enable) {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 3d480be802cb..3710f4d0f2cb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -834,7 +834,7 @@ struct dc_stream_state *
 int dm_atomic_get_state(struct drm_atomic_state *state,
 			struct dm_atomic_state **dm_state);
 
-struct amdgpu_dm_connector *
+struct drm_connector *
 amdgpu_dm_find_first_crtc_matching_connector(struct drm_atomic_state *state,
 					     struct drm_crtc *crtc);
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 9b71643d8a89..602a2ab98abf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1500,14 +1500,16 @@ int pre_validate_dsc(struct drm_atomic_state *state,
 		int ind = find_crtc_index_in_state_by_stream(state, stream);
 
 		if (ind >= 0) {
+			struct drm_connector *connector;
 			struct amdgpu_dm_connector *aconnector;
 			struct drm_connector_state *drm_new_conn_state;
 			struct dm_connector_state *dm_new_conn_state;
 			struct dm_crtc_state *dm_old_crtc_state;
 
-			aconnector =
+			connector =
 				amdgpu_dm_find_first_crtc_matching_connector(state,
 									     state->crtcs[ind].ptr);
+			aconnector = to_amdgpu_dm_connector(connector);
 			drm_new_conn_state =
 				drm_atomic_get_new_connector_state(state,
 								   &aconnector->base);
-- 
2.43.0



