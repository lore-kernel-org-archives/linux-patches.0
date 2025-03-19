Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7421B1A841C;
	Wed, 19 Mar 2025 14:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395143; cv=none; b=tpizz2To3kXUwzWgC5hkikNs2ZVVJhA7sC9wFs+OlghQ4Gyo6QSFbhXNn+9vbVM/22kwHKw75Ua7NSe0cP4ack6ruelzCSlL+8tL8mKERY8kX9DsuDf4VP9DLJeS7Tfsb494rzUHadmkDB5C+HTqJDVRqZJfUO4YfT89cTMFOtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395143; c=relaxed/simple;
	bh=dkHILbvVyT/nvtuvIonUaheG++Stis2IJ4rPh7vx++I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkCz+eeUL/T9eS832GImLr9zWvuGTJLtrSaMq7s1GCg5U9TAffVAvcr6PZJ/Se+ucuCcfArVKIONoxQCSiFHiWUj/5a7oVTtQDOz0cuXVgy7Y38OHWnUQS8v0Oq9JTVKNsnW6yMX+htIz2Y16rduN+Jaqa0KYZWQZpgAuY4oV3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2tZtQER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2tZtQER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB6AC4CEEA;
	Wed, 19 Mar 2025 14:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395143;
	bh=dkHILbvVyT/nvtuvIonUaheG++Stis2IJ4rPh7vx++I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2tZtQERU/iGxXRmH8oSGf1jmaU89dzlnd3Sd5C29MnvN0xBXUnk6Jmh1X3H/FMtd
	 UYwH0Xr+53iHj2nFvb4USLJ67PG/o7s0FOpN+5G/jpkPQ4kPMZAY754xwS9udAbKpM
	 7f2BTu46B1rupfQzyV2oVnoR8bafhaq4kUXSohd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.12 173/231] drm/dp_mst: Fix locking when skipping CSN before topology probing
Date: Wed, 19 Mar 2025 07:31:06 -0700
Message-ID: <20250319143031.116498473@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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
@@ -4034,6 +4034,22 @@ out:
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
@@ -4064,8 +4080,12 @@ drm_dp_mst_process_up_req(struct drm_dp_
 
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
@@ -4144,10 +4164,11 @@ static int drm_dp_mst_handle_up_req(stru
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
@@ -4156,16 +4177,6 @@ static int drm_dp_mst_handle_up_req(stru
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
@@ -4180,9 +4191,6 @@ static int drm_dp_mst_handle_up_req(stru
 	list_add_tail(&up_req->next, &mgr->up_req_list);
 	mutex_unlock(&mgr->up_req_lock);
 	queue_work(system_long_wq, &mgr->up_req_work);
-
-out_put_primary:
-	drm_dp_mst_topology_put_mstb(mst_primary);
 out_clear_reply:
 	memset(&mgr->up_req_recv, 0, sizeof(struct drm_dp_sideband_msg_rx));
 	return 0;


