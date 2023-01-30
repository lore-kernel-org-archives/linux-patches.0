Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF5428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2BFC433D2;
	Mon, 30 Jan 2023 14:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087616;
	bh=7sCe5CcemCW/s7+ZnhGjqQB84qDkBBVOTW241vkao3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ln3Pk40dt7bnMR1WQmvie7hTB/ghKwxAvca7gFHZnT1rPzU7xchf/CAyjQkw/gFQL
	 8XuDkntiWbyDA5Zggjrpwb5KMTsyWllHsrPVcfXtHFTgPV0LQTE1oTjqvOjC6Ll93C
	 A48BRmoi9SpLwpgnx/ksxRV40alabCqeP4i05RDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Didier Raboud <odyx@debian.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 238/313] drm/amdgpu/display/mst: limit payload to be updated one by one
Date: Mon, 30 Jan 2023 14:51:13 +0100
Message-Id: <20230130134347.763927423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wayne Lin <Wayne.Lin@amd.com>

commit cb1e0b015f56b8f3c7f5ce33ff4b782ee5674512 upstream.

[Why]
amdgpu expects to update payload table for one stream one time
by calling dm_helpers_dp_mst_write_payload_allocation_table().
Currently, it get modified to try to update HW payload table
at once by referring mst_state.

[How]
This is just a quick workaround. Should find way to remove the
temporary struct dc_dp_mst_stream_allocation_table later if set
struct link_mst_stream_allocatio directly is possible.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Tested-by: Didier Raboud <odyx@debian.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |   51 ++++++++++----
 1 file changed, 39 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -120,23 +120,50 @@ enum dc_edid_status dm_helpers_parse_edi
 }
 
 static void
-fill_dc_mst_payload_table_from_drm(struct drm_dp_mst_topology_state *mst_state,
-				   struct amdgpu_dm_connector *aconnector,
+fill_dc_mst_payload_table_from_drm(struct dc_link *link,
+				   bool enable,
+				   struct drm_dp_mst_atomic_payload *target_payload,
 				   struct dc_dp_mst_stream_allocation_table *table)
 {
 	struct dc_dp_mst_stream_allocation_table new_table = { 0 };
 	struct dc_dp_mst_stream_allocation *sa;
-	struct drm_dp_mst_atomic_payload *payload;
+	struct link_mst_stream_allocation_table copy_of_link_table =
+										link->mst_stream_alloc_table;
+
+	int i;
+	int current_hw_table_stream_cnt = copy_of_link_table.stream_count;
+	struct link_mst_stream_allocation *dc_alloc;
+
+	/* TODO: refactor to set link->mst_stream_alloc_table directly if possible.*/
+	if (enable) {
+		dc_alloc =
+		&copy_of_link_table.stream_allocations[current_hw_table_stream_cnt];
+		dc_alloc->vcp_id = target_payload->vcpi;
+		dc_alloc->slot_count = target_payload->time_slots;
+	} else {
+		for (i = 0; i < copy_of_link_table.stream_count; i++) {
+			dc_alloc =
+			&copy_of_link_table.stream_allocations[i];
+
+			if (dc_alloc->vcp_id == target_payload->vcpi) {
+				dc_alloc->vcp_id = 0;
+				dc_alloc->slot_count = 0;
+				break;
+			}
+		}
+		ASSERT(i != copy_of_link_table.stream_count);
+	}
 
 	/* Fill payload info*/
-	list_for_each_entry(payload, &mst_state->payloads, next) {
-		if (payload->delete)
-			continue;
-
-		sa = &new_table.stream_allocations[new_table.stream_count];
-		sa->slot_count = payload->time_slots;
-		sa->vcp_id = payload->vcpi;
-		new_table.stream_count++;
+	for (i = 0; i < MAX_CONTROLLER_NUM; i++) {
+		dc_alloc =
+			&copy_of_link_table.stream_allocations[i];
+		if (dc_alloc->vcp_id > 0 && dc_alloc->slot_count > 0) {
+			sa = &new_table.stream_allocations[new_table.stream_count];
+			sa->slot_count = dc_alloc->slot_count;
+			sa->vcp_id = dc_alloc->vcp_id;
+			new_table.stream_count++;
+		}
 	}
 
 	/* Overwrite the old table */
@@ -185,7 +212,7 @@ bool dm_helpers_dp_mst_write_payload_all
 	 * AUX message. The sequence is slot 1-63 allocated sequence for each
 	 * stream. AMD ASIC stream slot allocation should follow the same
 	 * sequence. copy DRM MST allocation to dc */
-	fill_dc_mst_payload_table_from_drm(mst_state, aconnector, proposed_table);
+	fill_dc_mst_payload_table_from_drm(stream->link, enable, payload, proposed_table);
 
 	return true;
 }


