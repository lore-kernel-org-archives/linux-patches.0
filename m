Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A071482F5;
	Wed,  7 May 2025 18:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644319; cv=none; b=UWDawVeAJQNI+paI98ZZw/g0C8YyhzFSBdNEWc481WMS4m7U1IfhFYR/T7Q4Lzanj4zP3iZJl7vh3aV33QfgxvdDRf/a4Hw7T5xnfAmCnUdQXAz3HETm8VwyX1s825qa/ZyqGw46HZDhf9Jodvse1ZyJGEXp488YxZzVPZVnnzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644319; c=relaxed/simple;
	bh=EfLdDO16BqQm0FBver6/nUyqJwQ2CnD81mPwIlw3TQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shdQ/2O5eIbHe/2pQtl9zbJYZ8lfeD5FlaT3cvQsOS5/h38nInHxAT7b+rhAtyb68y1+F0iqLVEVuxYBMD16jdCmk3N6585Ug1rH3Fvp06k3KiEFTW6gxgfZqF/9bzSOWp+Auwoj/UUnVCGDYTtpGFk1zflC7bBgIcJuE+CM614=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+uLmiOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+uLmiOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD9FC4CEE2;
	Wed,  7 May 2025 18:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644319;
	bh=EfLdDO16BqQm0FBver6/nUyqJwQ2CnD81mPwIlw3TQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+uLmiOxgKVXyCvlUEV0qHmj6toCvYKOcCNvTBqokQeSo6X7KW/JpLndrKqm1nTGa
	 sRhdM/GuJGU7G75fmWhyQatBIWu8lL47AeLkGNF8ZHoriEs6lvKvfVdYW2bmcyUV/+
	 WDGR3v5SXQZu9mZuJ0V6zBXrAbSmnBpnTKeNHR9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 181/183] drm/amd/display: Add scoped mutexes for amdgpu_dm_dhcp
Date: Wed,  7 May 2025 20:40:26 +0200
Message-ID: <20250507183832.193873315@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 6b675ab8efbf2bcee25be29e865455c56e246401 ]

[Why]
Guards automatically release mutex when it goes out of scope making
code easier to follow.

[How]
Replace all use of mutex_lock()/mutex_unlock() with guard(mutex).

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: be593d9d91c5 ("drm/amd/display: Fix slab-use-after-free in hdcp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_hdcp.c    | 37 +++++--------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index c0dc232440490..53796a74b7a65 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -172,7 +172,7 @@ void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 	struct mod_hdcp_display_adjustment display_adjust;
 	unsigned int conn_index = aconnector->base.index;
 
-	mutex_lock(&hdcp_w->mutex);
+	guard(mutex)(&hdcp_w->mutex);
 	hdcp_w->aconnector[conn_index] = aconnector;
 
 	memset(&link_adjust, 0, sizeof(link_adjust));
@@ -209,7 +209,6 @@ void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 	mod_hdcp_update_display(&hdcp_w->hdcp, conn_index, &link_adjust, &display_adjust, &hdcp_w->output);
 
 	process_output(hdcp_w);
-	mutex_unlock(&hdcp_w->mutex);
 }
 
 static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
@@ -220,7 +219,7 @@ static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
 	struct drm_connector_state *conn_state = aconnector->base.state;
 	unsigned int conn_index = aconnector->base.index;
 
-	mutex_lock(&hdcp_w->mutex);
+	guard(mutex)(&hdcp_w->mutex);
 	hdcp_w->aconnector[conn_index] = aconnector;
 
 	/* the removal of display will invoke auth reset -> hdcp destroy and
@@ -239,7 +238,6 @@ static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
 	mod_hdcp_remove_display(&hdcp_w->hdcp, aconnector->base.index, &hdcp_w->output);
 
 	process_output(hdcp_w);
-	mutex_unlock(&hdcp_w->mutex);
 }
 
 void hdcp_reset_display(struct hdcp_workqueue *hdcp_work, unsigned int link_index)
@@ -247,7 +245,7 @@ void hdcp_reset_display(struct hdcp_workqueue *hdcp_work, unsigned int link_inde
 	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
 	unsigned int conn_index;
 
-	mutex_lock(&hdcp_w->mutex);
+	guard(mutex)(&hdcp_w->mutex);
 
 	mod_hdcp_reset_connection(&hdcp_w->hdcp,  &hdcp_w->output);
 
@@ -259,8 +257,6 @@ void hdcp_reset_display(struct hdcp_workqueue *hdcp_work, unsigned int link_inde
 	}
 
 	process_output(hdcp_w);
-
-	mutex_unlock(&hdcp_w->mutex);
 }
 
 void hdcp_handle_cpirq(struct hdcp_workqueue *hdcp_work, unsigned int link_index)
@@ -277,7 +273,7 @@ static void event_callback(struct work_struct *work)
 	hdcp_work = container_of(to_delayed_work(work), struct hdcp_workqueue,
 				 callback_dwork);
 
-	mutex_lock(&hdcp_work->mutex);
+	guard(mutex)(&hdcp_work->mutex);
 
 	cancel_delayed_work(&hdcp_work->callback_dwork);
 
@@ -285,8 +281,6 @@ static void event_callback(struct work_struct *work)
 			       &hdcp_work->output);
 
 	process_output(hdcp_work);
-
-	mutex_unlock(&hdcp_work->mutex);
 }
 
 static void event_property_update(struct work_struct *work)
@@ -323,7 +317,7 @@ static void event_property_update(struct work_struct *work)
 			continue;
 
 		drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
-		mutex_lock(&hdcp_work->mutex);
+		guard(mutex)(&hdcp_work->mutex);
 
 		if (conn_state->commit) {
 			ret = wait_for_completion_interruptible_timeout(&conn_state->commit->hw_done,
@@ -355,7 +349,6 @@ static void event_property_update(struct work_struct *work)
 			drm_hdcp_update_content_protection(connector,
 							   DRM_MODE_CONTENT_PROTECTION_DESIRED);
 		}
-		mutex_unlock(&hdcp_work->mutex);
 		drm_modeset_unlock(&dev->mode_config.connection_mutex);
 	}
 }
@@ -368,7 +361,7 @@ static void event_property_validate(struct work_struct *work)
 	struct amdgpu_dm_connector *aconnector;
 	unsigned int conn_index;
 
-	mutex_lock(&hdcp_work->mutex);
+	guard(mutex)(&hdcp_work->mutex);
 
 	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX;
 	     conn_index++) {
@@ -408,8 +401,6 @@ static void event_property_validate(struct work_struct *work)
 			schedule_work(&hdcp_work->property_update_work);
 		}
 	}
-
-	mutex_unlock(&hdcp_work->mutex);
 }
 
 static void event_watchdog_timer(struct work_struct *work)
@@ -420,7 +411,7 @@ static void event_watchdog_timer(struct work_struct *work)
 				 struct hdcp_workqueue,
 				      watchdog_timer_dwork);
 
-	mutex_lock(&hdcp_work->mutex);
+	guard(mutex)(&hdcp_work->mutex);
 
 	cancel_delayed_work(&hdcp_work->watchdog_timer_dwork);
 
@@ -429,8 +420,6 @@ static void event_watchdog_timer(struct work_struct *work)
 			       &hdcp_work->output);
 
 	process_output(hdcp_work);
-
-	mutex_unlock(&hdcp_work->mutex);
 }
 
 static void event_cpirq(struct work_struct *work)
@@ -439,13 +428,11 @@ static void event_cpirq(struct work_struct *work)
 
 	hdcp_work = container_of(work, struct hdcp_workqueue, cpirq_work);
 
-	mutex_lock(&hdcp_work->mutex);
+	guard(mutex)(&hdcp_work->mutex);
 
 	mod_hdcp_process_event(&hdcp_work->hdcp, MOD_HDCP_EVENT_CPIRQ, &hdcp_work->output);
 
 	process_output(hdcp_work);
-
-	mutex_unlock(&hdcp_work->mutex);
 }
 
 void hdcp_destroy(struct kobject *kobj, struct hdcp_workqueue *hdcp_work)
@@ -479,7 +466,7 @@ static bool enable_assr(void *handle, struct dc_link *link)
 
 	dtm_cmd = (struct ta_dtm_shared_memory *)psp->dtm_context.context.mem_context.shared_buf;
 
-	mutex_lock(&psp->dtm_context.mutex);
+	guard(mutex)(&psp->dtm_context.mutex);
 	memset(dtm_cmd, 0, sizeof(struct ta_dtm_shared_memory));
 
 	dtm_cmd->cmd_id = TA_DTM_COMMAND__TOPOLOGY_ASSR_ENABLE;
@@ -494,8 +481,6 @@ static bool enable_assr(void *handle, struct dc_link *link)
 		res = false;
 	}
 
-	mutex_unlock(&psp->dtm_context.mutex);
-
 	return res;
 }
 
@@ -557,13 +542,11 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 			 (!!aconnector->base.state) ?
 			 aconnector->base.state->hdcp_content_type : -1);
 
-	mutex_lock(&hdcp_w->mutex);
+	guard(mutex)(&hdcp_w->mutex);
 
 	mod_hdcp_add_display(&hdcp_w->hdcp, link, display, &hdcp_w->output);
 
 	process_output(hdcp_w);
-	mutex_unlock(&hdcp_w->mutex);
-
 }
 
 /**
-- 
2.39.5



