Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705C9FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B43C433D2;
	Mon, 15 May 2023 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170082;
	bh=4SuwmcSWB1flmA30J5wW2/YmqqveElN4doWVpqOjtbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9kFEJxc5OipjDW5an6gVfCxf7Kf1X3Nkfv/kpfbzVo7fi0pi3bkat2RVb6eh4bYR
	 up34BAgt+HmwB2k8yfDlT4UyM9N2Gklnx8UHw9an9xv0ZCJPldjg0O8WLM4ZNOPz+A
	 c0kwPoYdQT4y8kAFXoCZYBpE9VEmvMOj/MoJxrhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <Jerry.Zuo@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Ryan Lin <tsung-hua.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/239] drm/amd/display: Ext displays with dock cant recognized after resume
Date: Mon, 15 May 2023 18:24:42 +0200
Message-Id: <20230515161722.165487057@linuxfoundation.org>
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

From: Ryan Lin <tsung-hua.lin@amd.com>

[ Upstream commit 1e5d4d8eb8c0f15d90c50e7abd686c980e54e42e ]

[Why]
Needs to set the default value of the LTTPR timeout after resume.

[How]
Set the default (3.2ms) timeout at resuming if the sink supports
LTTPR

Reviewed-by: Jerry Zuo <Jerry.Zuo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Ryan Lin <tsung-hua.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 99b99f0b42c06..9f637e360755d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -39,6 +39,7 @@
 #include "dc/dc_edid_parser.h"
 #include "dc/dc_stat.h"
 #include "amdgpu_dm_trace.h"
+#include "dc/inc/dc_link_ddc.h"
 
 #include "vid.h"
 #include "amdgpu.h"
@@ -2254,6 +2255,14 @@ static void s3_handle_mst(struct drm_device *dev, bool suspend)
 		if (suspend) {
 			drm_dp_mst_topology_mgr_suspend(mgr);
 		} else {
+			/* if extended timeout is supported in hardware,
+			 * default to LTTPR timeout (3.2ms) first as a W/A for DP link layer
+			 * CTS 4.2.1.1 regression introduced by CTS specs requirement update.
+			 */
+			dc_link_aux_try_to_configure_timeout(aconnector->dc_link->ddc, LINK_AUX_DEFAULT_LTTPR_TIMEOUT_PERIOD);
+			if (!dp_is_lttpr_present(aconnector->dc_link))
+				dc_link_aux_try_to_configure_timeout(aconnector->dc_link->ddc, LINK_AUX_DEFAULT_TIMEOUT_PERIOD);
+
 			ret = drm_dp_mst_topology_mgr_resume(mgr, true);
 			if (ret < 0) {
 				dm_helpers_dp_mst_stop_top_mgr(aconnector->dc_link->ctx,
-- 
2.39.2



