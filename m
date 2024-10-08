Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433AB1DE8A0;
	Tue,  8 Oct 2024 13:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392799; cv=none; b=inaVzvGY64LJsuK2e5essjZxlrlVvqa08VZLYOIbKiA9phlTevf22aSNqmPgM2kFseuw34VkQXoPzr2egtTUi8cKxbNlIU5ORyAGOMQOrUQpem0FCI/6yIgesbD9VvgOIpp3Y9oNfPHC30QxJfVAYGOw8OtHduI+fUXphvxQiCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392799; c=relaxed/simple;
	bh=CsRRaEangYoKeh6yRixt2H83VFF2AsvVGPzmnXS8lqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etFknByegBdMWLsj5e7294Z+RBavoaz9+v8+LwKUNpyiz7s0nHYMeSvkF8zmJVnqAHngOoCEym06SYpLrXM7d3WCHNxmY4s3538952ceJ8f0nHr4l0XNst3THJ2JD5V+skPT/8MYyBD+nxg4k4xFmgNgO6ucyUyS+OgErTeIdZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7L15+JU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7L15+JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC945C4CEC7;
	Tue,  8 Oct 2024 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392799;
	bh=CsRRaEangYoKeh6yRixt2H83VFF2AsvVGPzmnXS8lqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7L15+JUuCLd2wqchVISC/CJOl0mEPc2w6eXXB8Xq5Tiq9AOYvigN+caHm0wyNCFF
	 gfNsA2xRQWAeNKZNThJNxV7o+yBao8pp4agV7AC+rq5DpMquZXXqumjMPSfLn7thE6
	 fMzIBlaccvkXVe8qVUGO/BYbYije6+3O/krmkKME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 524/558] drm/amd/display: Restore Optimized pbn Value if Failed to Disable DSC
Date: Tue,  8 Oct 2024 14:09:14 +0200
Message-ID: <20241008115722.850575871@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

commit d51160ab00969ee6758ed2dcbc0f81dd476a181c upstream.

Existing last step of dsc policy is to restore pbn value under minimum compression
when try to greedily disable dsc for a stream failed to fit in MST bw.
Optimized dsc params result from optimization step is not necessarily the minimum compression,
therefore it is not correct to restore the pbn under minimum compression rate.

Restore the pbn under minimum compression instead of the value from optimized pbn could result
in the dsc params not correct at the modeset where atomic_check failed due to not
enough bw. One or more monitors connected could not light up in such case.

Restore the optimized pbn value, instead of using the pbn value under minimum
compression.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 352c3165d2b75030169e012461a16bcf97f392fc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   17 +++++++++---
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1027,6 +1027,7 @@ static int try_disable_dsc(struct drm_at
 	int remaining_to_try = 0;
 	int ret;
 	uint16_t fec_overhead_multiplier_x1000 = get_fec_overhead_multiplier(dc_link);
+	int var_pbn;
 
 	for (i = 0; i < count; i++) {
 		if (vars[i + k].dsc_enabled
@@ -1057,13 +1058,18 @@ static int try_disable_dsc(struct drm_at
 			break;
 
 		DRM_DEBUG_DRIVER("MST_DSC index #%d, try no compression\n", next_index);
+		var_pbn = vars[next_index].pbn;
 		vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps, fec_overhead_multiplier_x1000);
 		ret = drm_dp_atomic_find_time_slots(state,
 						    params[next_index].port->mgr,
 						    params[next_index].port,
 						    vars[next_index].pbn);
-		if (ret < 0)
+		if (ret < 0) {
+			DRM_DEBUG_DRIVER("%s:%d MST_DSC index #%d, failed to set pbn to the state, %d\n",
+						__func__, __LINE__, next_index, ret);
+			vars[next_index].pbn = var_pbn;
 			return ret;
+		}
 
 		ret = drm_dp_mst_atomic_check(state);
 		if (ret == 0) {
@@ -1071,14 +1077,17 @@ static int try_disable_dsc(struct drm_at
 			vars[next_index].dsc_enabled = false;
 			vars[next_index].bpp_x16 = 0;
 		} else {
-			DRM_DEBUG_DRIVER("MST_DSC index #%d, restore minimum compression\n", next_index);
-			vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.max_kbps, fec_overhead_multiplier_x1000);
+			DRM_DEBUG_DRIVER("MST_DSC index #%d, restore optimized pbn value\n", next_index);
+			vars[next_index].pbn = var_pbn;
 			ret = drm_dp_atomic_find_time_slots(state,
 							    params[next_index].port->mgr,
 							    params[next_index].port,
 							    vars[next_index].pbn);
-			if (ret < 0)
+			if (ret < 0) {
+				DRM_DEBUG_DRIVER("%s:%d MST_DSC index #%d, failed to set pbn to the state, %d\n",
+							__func__, __LINE__, next_index, ret);
 				return ret;
+			}
 		}
 
 		tried[next_index] = true;


