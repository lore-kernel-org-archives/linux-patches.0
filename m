Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0927B1F9EAC;
	Tue,  3 Dec 2024 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240091; cv=none; b=q1d8NF8guaktiZvsDl/20p+XoTc3mxArdwphG27oTPA84jPCp7kWCtY6eRUEYby337Ru2vYVX+sRLgW45TWo02+688iNpRTH8L1VVbVbLKKqZa2dycmgVz0ClGoRTfHNHIKCms6G9jd9u6ObmRohl0bmfuiFb7ERUH7iPuLGIgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240091; c=relaxed/simple;
	bh=j6G6qJzVtWim7O+pyJCOy7DhUKQWPnmkUsOUPJZW3zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsDT4h17kZdiRp2zaH8PpSvl3VwlZBiqP/DIN+nc0LzoWjUFh0T+H7JXh2uHLAsZnm6t5CGf9M4Xbb/y71xm+bQ/POZZCUiFyem3DqT1LOC1TQNRO+HLOY+Nos1u9cZu7nCNFAn9wpg479os+DEOjuVYHVGZgI/eZ4TR8PQBfrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaM3cm/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaM3cm/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B384C4CECF;
	Tue,  3 Dec 2024 15:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240090;
	bh=j6G6qJzVtWim7O+pyJCOy7DhUKQWPnmkUsOUPJZW3zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaM3cm/D+tYkyavAkbxVX9BW2TiPMBi0M5Hx/qr7qGhSN3/T/z5VdRjCHtg+PPN5V
	 QBWN7PGZSteMaETdTen6/o4ljr0cz6vEpOZ5U+uVDZl6K+ujZZ8+S+hO2nzZPyN/kQ
	 KzroqNJDu5jj/eMjiGmFY0T2PoLZJRGSy3fMNtQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/826] drm/amd/display: Skip Invalid Streams from DSC Policy
Date: Tue,  3 Dec 2024 15:35:29 +0100
Message-ID: <20241203144743.537483702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 9afeda04964281e9f708b92c2a9c4f8a1387b46e ]

Streams with invalid new connector state should be elimiated from
dsc policy.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index a08e8a0b696c6..f756640048fee 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1120,6 +1120,7 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 	int i, k, ret;
 	bool debugfs_overwrite = false;
 	uint16_t fec_overhead_multiplier_x1000 = get_fec_overhead_multiplier(dc_link);
+	struct drm_connector_state *new_conn_state;
 
 	memset(params, 0, sizeof(params));
 
@@ -1127,7 +1128,7 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 		return PTR_ERR(mst_state);
 
 	/* Set up params */
-	DRM_DEBUG_DRIVER("%s: MST_DSC Set up params for %d streams\n", __func__, dc_state->stream_count);
+	DRM_DEBUG_DRIVER("%s: MST_DSC Try to set up params from %d streams\n", __func__, dc_state->stream_count);
 	for (i = 0; i < dc_state->stream_count; i++) {
 		struct dc_dsc_policy dsc_policy = {0};
 
@@ -1143,6 +1144,14 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 		if (!aconnector->mst_output_port)
 			continue;
 
+		new_conn_state = drm_atomic_get_new_connector_state(state, &aconnector->base);
+
+		if (!new_conn_state) {
+			DRM_DEBUG_DRIVER("%s:%d MST_DSC Skip the stream 0x%p with invalid new_conn_state\n",
+					__func__, __LINE__, stream);
+			continue;
+		}
+
 		stream->timing.flags.DSC = 0;
 
 		params[count].timing = &stream->timing;
@@ -1175,6 +1184,8 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 		count++;
 	}
 
+	DRM_DEBUG_DRIVER("%s: MST_DSC Params set up for %d streams\n", __func__, count);
+
 	if (count == 0) {
 		ASSERT(0);
 		return 0;
-- 
2.43.0



