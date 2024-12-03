Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3DB1F756E;
	Tue,  3 Dec 2024 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237707; cv=none; b=OC0omF2Z6RCvgG95Py8wocn3igmkUQBdjiV4YhWZFOjLIpYDAlJhalqPM2SvGHZyobxV1Qn2hHcVe3DiGWfFSgN16JgLQ00nSWcf81MTe4eUFuvS0/Ta6TzlV1ufON6HOlQGmUozJtZtkdFVQUbhQKiZNTCcwL6Rt7uEM2o8VA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237707; c=relaxed/simple;
	bh=/EisSg5VA81U7NOQYivRZeETjA7lvw2HZU5sOk4T/t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdBPm1BnG6z4S0tpwOikB8sRw8Su78IZGqIBpXoDBUDgZFXnRwyaH7lFh2ODcmN42RO4IpafjwrqbXheLyvID9TzMz/lqhtoeYt0z9i8N2/DobjbnCVsAIUm+KfNkAoG5lC/90rWepN2e1ygegq4dNx6rxGHzfD/e2ygkKaN9bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoZ1SOWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoZ1SOWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709CBC4CECF;
	Tue,  3 Dec 2024 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237706;
	bh=/EisSg5VA81U7NOQYivRZeETjA7lvw2HZU5sOk4T/t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PoZ1SOWxbcoe00rZC3C4SVbY5aA/jRS9tvLHUXFf/pTutsCZHURoZ4Kg0/3unUbso
	 Zg5yqE+codj+TJyPVn8Yr890iHjdunT+930SEneMEw7vSlO4dmwM0vb/sZa8IDiw9j
	 GIlrJ2XWn50E/uCd5W+2NR2VRh11chCDqzT5aM4g=
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
Subject: [PATCH 6.11 047/817] drm/amd/display: Skip Invalid Streams from DSC Policy
Date: Tue,  3 Dec 2024 15:33:39 +0100
Message-ID: <20241203143957.499724170@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 905c11af01716..0fa922f60ac0a 100644
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



