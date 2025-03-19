Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1226B1DF258;
	Wed, 19 Mar 2025 14:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395272; cv=none; b=NvSQ2l1YYwR43jodyas+vDoJiyEpAN1J1BsNZ/02ljkRB6X2d2lw8G9li1AMbOdQuPS/+GPm3h/NoFcYCie+JSNEeqXdhKjIt66SUTwhiW58+PXQU5CiXWHSDPeVy1FqTMWorvKrRGekc+BLb7vH3p0FjFE5oJWKv+0FQYdPM/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395272; c=relaxed/simple;
	bh=5sGY++zEAgsUpbl4knd0nRNa8bnSB+eIQkIcxHkDJjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSS9TM3Zx9Pi3g95xNFrQkhOqE2VipCre7r6pLPh0ylF516nyN7GdvT7jXpQaLLFiq1DGRgFYP/VGfsRKCsrAv5HUlP8FR31XvzHMp+PLsCCrlRC9o0aYZ3+cr2w5BGUup9/xuPazuu9+T6lsKow/SDG7kht//eF1tkFBAMnOJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3bDJuEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3bDJuEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E6AC4CEE4;
	Wed, 19 Mar 2025 14:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395271;
	bh=5sGY++zEAgsUpbl4knd0nRNa8bnSB+eIQkIcxHkDJjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3bDJuEuyJS/PGCpw8hU6vzAKfuWB+8ibLh1qmtE24eOgom1lnp9fBGxRCoVTwlP8
	 bR4CGg2pM4+ahItJCgYv4BvkWcKJxpXQ8B0GKPdGf8qOns8ppUfjHvUKlASHlK2w5b
	 1GEaqQ5ayeiEAZUnjNtS44GfdDzjpOAd3cfMLJsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.6 122/166] drm/dp_mst: Fix locking when skipping CSN before topology probing
Date: Wed, 19 Mar 2025 07:31:33 -0700
Message-ID: <20250319143023.319138983@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 12d8f318347b1d4feac48e8ac351d3786af39599 upstream.

The handling of the MST Connection Status Notify message is skipped if
the probing of the topology is still pending. Acquiring the
drm_dp_mst_topology_mgr::probe_lock for this in
drm_dp_mst_handle_up_req() is problematic: the task/work this function
is called from is also responsible for handling MST down-request replies
(in drm_dp_mst_handle_down_rep()). Thus drm_dp_mst_link_probe_work() -
holding already probe_lock - could be blocked waiting for an MST
down-request reply while drm_dp_mst_handle_up_req() is waiting for
probe_lock while processing a CSN message. This leads to the probe
work's down-request message timing out.

A scenario similar to the above leading to a down-request timeout is
handling a CSN message in drm_dp_mst_handle_conn_stat(), holding the
probe_lock and sending down-request messages while a second CSN message
sent by the sink subsequently is handled by drm_dp_mst_handle_up_req().

Fix the above by moving the logic to skip the CSN handling to
drm_dp_mst_process_up_req(). This function is called from a work
(separate from the task/work handling new up/down messages), already
holding probe_lock. This solves the above timeout issue, since handling
of down-request replies won't be blocked by probe_lock.

Fixes: ddf983488c3e ("drm/dp_mst: Skip CSN if topology probing is not done yet")
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org # v6.6+
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250307183152.3822170-1-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |   40 +++++++++++++++-----------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3959,6 +3959,22 @@ out:
 	return 0;
 }
 
+static bool primary_mstb_probing_is_done(struct drm_dp_mst_topology_mgr *mgr)
+{
+	bool probing_done = false;
+
+	mutex_lock(&mgr->lock);
+
+	if (mgr->mst_primary && drm_dp_mst_topology_try_get_mstb(mgr->mst_primary)) {
+		probing_done = mgr->mst_primary->link_address_sent;
+		drm_dp_mst_topology_put_mstb(mgr->mst_primary);
+	}
+
+	mutex_unlock(&mgr->lock);
+
+	return probing_done;
+}
+
 static inline bool
 drm_dp_mst_process_up_req(struct drm_dp_mst_topology_mgr *mgr,
 			  struct drm_dp_pending_up_req *up_req)
@@ -3989,8 +4005,12 @@ drm_dp_mst_process_up_req(struct drm_dp_
 
 	/* TODO: Add missing handler for DP_RESOURCE_STATUS_NOTIFY events */
 	if (msg->req_type == DP_CONNECTION_STATUS_NOTIFY) {
-		dowork = drm_dp_mst_handle_conn_stat(mstb, &msg->u.conn_stat);
-		hotplug = true;
+		if (!primary_mstb_probing_is_done(mgr)) {
+			drm_dbg_kms(mgr->dev, "Got CSN before finish topology probing. Skip it.\n");
+		} else {
+			dowork = drm_dp_mst_handle_conn_stat(mstb, &msg->u.conn_stat);
+			hotplug = true;
+		}
 	}
 
 	drm_dp_mst_topology_put_mstb(mstb);
@@ -4069,10 +4089,11 @@ static int drm_dp_mst_handle_up_req(stru
 	drm_dp_send_up_ack_reply(mgr, mst_primary, up_req->msg.req_type,
 				 false);
 
+	drm_dp_mst_topology_put_mstb(mst_primary);
+
 	if (up_req->msg.req_type == DP_CONNECTION_STATUS_NOTIFY) {
 		const struct drm_dp_connection_status_notify *conn_stat =
 			&up_req->msg.u.conn_stat;
-		bool handle_csn;
 
 		drm_dbg_kms(mgr->dev, "Got CSN: pn: %d ldps:%d ddps: %d mcs: %d ip: %d pdt: %d\n",
 			    conn_stat->port_number,
@@ -4081,16 +4102,6 @@ static int drm_dp_mst_handle_up_req(stru
 			    conn_stat->message_capability_status,
 			    conn_stat->input_port,
 			    conn_stat->peer_device_type);
-
-		mutex_lock(&mgr->probe_lock);
-		handle_csn = mst_primary->link_address_sent;
-		mutex_unlock(&mgr->probe_lock);
-
-		if (!handle_csn) {
-			drm_dbg_kms(mgr->dev, "Got CSN before finish topology probing. Skip it.");
-			kfree(up_req);
-			goto out_put_primary;
-		}
 	} else if (up_req->msg.req_type == DP_RESOURCE_STATUS_NOTIFY) {
 		const struct drm_dp_resource_status_notify *res_stat =
 			&up_req->msg.u.resource_stat;
@@ -4105,9 +4116,6 @@ static int drm_dp_mst_handle_up_req(stru
 	list_add_tail(&up_req->next, &mgr->up_req_list);
 	mutex_unlock(&mgr->up_req_lock);
 	queue_work(system_long_wq, &mgr->up_req_work);
-
-out_put_primary:
-	drm_dp_mst_topology_put_mstb(mst_primary);
 out_clear_reply:
 	memset(&mgr->up_req_recv, 0, sizeof(struct drm_dp_sideband_msg_rx));
 	return 0;


