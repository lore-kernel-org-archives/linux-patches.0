Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999C1FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD93C433EF;
	Mon, 15 May 2023 17:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170205;
	bh=foV8/GsyG0KK969gRK/mo9H5EAEPg8btge7wBdjgcIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZICLsco+lMhzmE5guwk9K4fbsPV9rXERUhyW3N8FODkqorlGL86VjzP0WUEEbe+O1
	 /fF0IFlC+gMx9+roVPjouVY2tDWBfzbaToRxo54B4FExgglcEDDs+l8VSbvbyZeyOd
	 agNsGWUj3VfXNtaR0urrSpztwqo0BTM1LBG7aWpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/239] drm/amd/display: Return error code on DSC atomic check failure
Date: Mon, 15 May 2023 18:24:52 +0200
Message-Id: <20230515161722.575138783@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit dd24662d9dfbad281bbf030f06d68c7938fa0c66 ]

[Why&How]
We were not returning -EINVAL on DSC atomic check fail. Add it.

Fixes: 71be4b16d39a ("drm/amd/display: dsc validate fail not pass to atomic check")
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           | 1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9f637e360755d..8584049158510 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9746,6 +9746,7 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		ret = compute_mst_dsc_configs_for_state(state, dm_state->context, vars);
 		if (ret) {
 			DRM_DEBUG_DRIVER("compute_mst_dsc_configs_for_state() failed\n");
+			ret = -EINVAL;
 			goto fail;
 		}
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index df74bc88e4600..e2f9141d6d938 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1368,6 +1368,7 @@ int pre_validate_dsc(struct drm_atomic_state *state,
 	ret = pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars);
 	if (ret != 0) {
 		DRM_INFO_ONCE("pre_compute_mst_dsc_configs_for_state() failed\n");
+		ret = -EINVAL;
 		goto clean_exit;
 	}
 
-- 
2.39.2



