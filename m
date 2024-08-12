Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C48186E38;
	Mon, 12 Aug 2024 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479130; cv=none; b=Ixl/4pLBqqOqQnxPLR60skFn4RaH8Gx67FGqhb3iyVtzKwZaLUB1JvljLFuOJgdSSwqP1x3dpb8XhfljHoG0BRHo9kYHpiRUeP+Ok5d/Dbo729Ji1/kYU+0+NvdW9+BYaDV0MUM3uCPp97wDYQ1wolceONL76wc0jM+lkun/hf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479130; c=relaxed/simple;
	bh=1ltYnoLP15R2KbHMMBy9zSF0rAay6F19b47OZyGLcB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VChxOpiDzOFy5+zQC6rqAX5kGW8bM041KQAMJu/JG1J2hyGbaqq1X64B3ocFVeuid8qBymS+52xMg3gmyKWcBrm7igCTBvPBuh4mYYKEWPxcWCgWcB5s4uozb/C16z41xmPKgoFmhVCuIjM1w81hyp1oAOOOzUlyqz/1TKa89T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVaHi7GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVaHi7GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE83AC4AF09;
	Mon, 12 Aug 2024 16:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479130;
	bh=1ltYnoLP15R2KbHMMBy9zSF0rAay6F19b47OZyGLcB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVaHi7GPFC5pWvyVU/2YdSG+abLWG1Sv8JMpEXGoWKJQ/BiOzso5d7VNetVNmlR3u
	 zXoUkK7jYCbQSiqISBrOhOQMt6v3kGq1BhUyrBNR//HZ9DIIYQyLm/4ji9/6XxSNzH
	 GbQAAAZCyCT0ZW7CjJccP46SC6JyLy3uVq0Cuojo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Harry Wentland <hwentlan@amd.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 6.1 125/150] drm/dp_mst: Skip CSN if topology probing is not done yet
Date: Mon, 12 Aug 2024 18:03:26 +0200
Message-ID: <20240812160129.986042836@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit ddf983488c3e8d30d5c2e2b315ae7d9cd87096ed upstream.

[Why]
During resume, observe that we receive CSN event before we start topology
probing. Handling CSN at this moment based on uncertain topology is
unnecessary.

[How]
Add checking condition in drm_dp_mst_handle_up_req() to skip handling CSN
if the topology is yet to be probed.

Cc: Lyude Paul <lyude@redhat.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240626084825.878565-3-Wayne.Lin@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -4024,6 +4024,7 @@ static int drm_dp_mst_handle_up_req(stru
 	if (up_req->msg.req_type == DP_CONNECTION_STATUS_NOTIFY) {
 		const struct drm_dp_connection_status_notify *conn_stat =
 			&up_req->msg.u.conn_stat;
+		bool handle_csn;
 
 		drm_dbg_kms(mgr->dev, "Got CSN: pn: %d ldps:%d ddps: %d mcs: %d ip: %d pdt: %d\n",
 			    conn_stat->port_number,
@@ -4032,6 +4033,16 @@ static int drm_dp_mst_handle_up_req(stru
 			    conn_stat->message_capability_status,
 			    conn_stat->input_port,
 			    conn_stat->peer_device_type);
+
+		mutex_lock(&mgr->probe_lock);
+		handle_csn = mgr->mst_primary->link_address_sent;
+		mutex_unlock(&mgr->probe_lock);
+
+		if (!handle_csn) {
+			drm_dbg_kms(mgr->dev, "Got CSN before finish topology probing. Skip it.");
+			kfree(up_req);
+			goto out;
+		}
 	} else if (up_req->msg.req_type == DP_RESOURCE_STATUS_NOTIFY) {
 		const struct drm_dp_resource_status_notify *res_stat =
 			&up_req->msg.u.resource_stat;


