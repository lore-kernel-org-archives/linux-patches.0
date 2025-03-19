Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A781DE2C0;
	Wed, 19 Mar 2025 14:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394953; cv=none; b=HtGYSrecY9YfWaCDREKovblhSlVN2nlB37uzVj10wcSKV4eH3kB6RA8sC85tfcicIg4A8tCYLsqmODaup6y5RYfvdisx7RaHUEgXxEnqTsDe52VocvdxQAcbv0KTvpRsIDb9lkRceljuTcfIfGH6zlWFIJKoMW/xsE6o2RegI8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394953; c=relaxed/simple;
	bh=IZodTY6UDA6L6CDoNf+atGwKtu2KkDRsoaudki4sr5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfEeB2lyD1WgXNvhpjrxV9WjYg06VBNj4vtcmnt1pJ0T6yjjcEi9XS/N7jUeEiFxA64GAULIHA+Zy2WAaNhp3a8q07+j3n9owPFwsozJNJJ9ppa8FNOW83rRpY4vK+Yu7JqpYk/kIEidezkXxPl+L50PTlShW9ZyFO4llBKDWnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOSN5ip0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOSN5ip0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72B9C4CEFA;
	Wed, 19 Mar 2025 14:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394952;
	bh=IZodTY6UDA6L6CDoNf+atGwKtu2KkDRsoaudki4sr5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOSN5ip078F1K3fVS6Bv1xZ1YvgVG3YtU44SVckjs5pkxY+12pOMuSl+WN0RFzsZr
	 8GY07PkIOIDOMm4k4CyxHeUFKB0ML38T/KuCROpOWCAUB+2yi4vDqfmrFHQV8UYuEK
	 fAGi0bfDvIORzyrrHi7eLIz5OkZYEclk7B9SNiEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.13 178/241] drm/dp_mst: Fix locking when skipping CSN before topology probing
Date: Wed, 19 Mar 2025 07:30:48 -0700
Message-ID: <20250319143032.135987100@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4035,6 +4035,22 @@ out:
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
@@ -4065,8 +4081,12 @@ drm_dp_mst_process_up_req(struct drm_dp_
 
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
@@ -4148,10 +4168,11 @@ static int drm_dp_mst_handle_up_req(stru
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
@@ -4160,16 +4181,6 @@ static int drm_dp_mst_handle_up_req(stru
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
@@ -4184,9 +4195,6 @@ static int drm_dp_mst_handle_up_req(stru
 	list_add_tail(&up_req->next, &mgr->up_req_list);
 	mutex_unlock(&mgr->up_req_lock);
 	queue_work(system_long_wq, &mgr->up_req_work);
-
-out_put_primary:
-	drm_dp_mst_topology_put_mstb(mst_primary);
 out_clear_reply:
 	reset_msg_rx_state(&mgr->up_req_recv);
 	return ret;


