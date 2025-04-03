Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBBD250C0D;
	Thu,  3 Apr 2025 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693893; cv=none; b=bwjnCtDwg9hV9wshjnuicNM3bvLh+x5n63qGK1qsuk54Cxw9m617Ivq1PiZ2EzcDRGxv0Cn163F5WlpfYUjgO90AIyWwldM41wIrtvh2zGfaaUUgcpd4SPTIHhr5osQej281PO/Zc4/KwXNaKhkN1XH3mw5CVi35Zkp7Nvpo0mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693893; c=relaxed/simple;
	bh=fbX0CDd9uqFOBvFZ2DT9QH6z63fI0psyfNtQnD90VPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVvgclD9OFcTPw4Q8y1epuY3bcbl8xYlnXPZOc3MS4amXnlvBkvle8QHFHFh1PBl40uOTZyL/0EM3LcEcdk+dIVhwIwHqlafL3p9AEOFzy/h16OS66z5WX7zExu9EjUL8b28AxQD4bGEjTgQUkgw1zLKW92z7qPVoCStaNOWJXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+kJ8Wae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+kJ8Wae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25572C4CEE5;
	Thu,  3 Apr 2025 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693892;
	bh=fbX0CDd9uqFOBvFZ2DT9QH6z63fI0psyfNtQnD90VPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+kJ8WaefRpRi7bEtAOJmps7Y+WnwRCQvVg1AUZS1bVgioqwkw5R9oSlM+WRI2Q1H
	 YyE4qmUpMbFjnh+pVtapWL3bL6xFNKZ1mg6C4Xw4T5Q1ukduuF5mIPKaOdsCuOE38c
	 zdg/x/Dx/JgCUYRp3CcMac1jRrf13jKFfEsRCnmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.12 05/22] drm/amd/display: Dont write DP_MSTM_CTRL after LT
Date: Thu,  3 Apr 2025 16:20:15 +0100
Message-ID: <20250403151622.197488472@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
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

From: Wayne Lin <Wayne.Lin@amd.com>

commit bc068194f548ef1f230d96c4398046bf59165992 upstream.

[Why]
Observe after suspend/resme, we can't light up mst monitors under specific
mst hub. The reason is that driver still writes DPCD DP_MSTM_CTRL after LT.
It's forbidden even we write the same value for that dpcd register.

[How]
We already resume the mst branch device dpcd settings during
resume_mst_branch_status(). Leverage drm_dp_mst_topology_queue_probe() to
only probe the topology, not calling drm_dp_mst_topology_mgr_resume() which
will set DP_MSTM_CTRL as well.

Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3231,8 +3231,7 @@ static int dm_resume(void *handle)
 	struct dm_atomic_state *dm_state = to_dm_atomic_state(dm->atomic_obj.state);
 	enum dc_connection_type new_connection_type = dc_connection_none;
 	struct dc_state *dc_state;
-	int i, r, j, ret;
-	bool need_hotplug = false;
+	int i, r, j;
 	struct dc_commit_streams_params commit_params = {};
 
 	if (dm->dc->caps.ips_support) {
@@ -3427,23 +3426,16 @@ static int dm_resume(void *handle)
 		    aconnector->mst_root)
 			continue;
 
-		ret = drm_dp_mst_topology_mgr_resume(&aconnector->mst_mgr, true);
-
-		if (ret < 0) {
-			dm_helpers_dp_mst_stop_top_mgr(aconnector->dc_link->ctx,
-					aconnector->dc_link);
-			need_hotplug = true;
-		}
+		drm_dp_mst_topology_queue_probe(&aconnector->mst_mgr);
 	}
 	drm_connector_list_iter_end(&iter);
 
-	if (need_hotplug)
-		drm_kms_helper_hotplug_event(ddev);
-
 	amdgpu_dm_irq_resume_late(adev);
 
 	amdgpu_dm_smu_write_watermarks_table(adev);
 
+	drm_kms_helper_hotplug_event(ddev);
+
 	return 0;
 }
 


