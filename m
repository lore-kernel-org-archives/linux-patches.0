Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E752D1DDC23;
	Wed,  7 May 2025 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643720; cv=none; b=WIfozmdUauBw5yClsK516Duf+wT2xSSz0yis25V/i0aMtHYOULHceJUAj7R8jV29n1+u5Xv31hlVyAuuDkGhawWChYoYXf70wVXKj7W2HVegvIZFIuyHyyRpgqdrmEU4A3kpTERTUrxSWrwaoRu05B4OyavkxVXW/yOOlE1IyvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643720; c=relaxed/simple;
	bh=KWipJT4aRvV6VPrH6V8g4UsomJabpaHYZ2e3FHVHMRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXdZhanFZNlB8YUr/AglSkP1pqV8YhAWGAdNBoqIAwakL81DOvWYFwddHQcqRVDTrxZT8nbdBWvkZ5bIzwO4qA0MWzaYS2h3t1R2YAtrfAyOJ2UNBEAeh4PGaWEpt9JxAUMrPEqRUEag/E6rsIbv/fKfxRXkeubX0LCBtpzF/w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOZBmVky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOZBmVky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA64AC4CEEB;
	Wed,  7 May 2025 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643719;
	bh=KWipJT4aRvV6VPrH6V8g4UsomJabpaHYZ2e3FHVHMRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOZBmVkyvOVSdEjBCa9HFRY4iOcXCei6xHEofQt+W2XYhk0XhJ9Vt6T32rwPVPEko
	 rpdX8dseJKf7WgqsJZQCstpzHLeoQ8k0XJhOS6oBI1n6XxQtiuoUcCwvqDdO62ZxXL
	 1wKdERJcTWShAiAjMJzqvHyV5sFYMD/FW4W2aVlo=
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
Subject: [PATCH 6.1 94/97] drm/amd/display: Add scoped mutexes for amdgpu_dm_dhcp
Date: Wed,  7 May 2025 20:40:09 +0200
Message-ID: <20250507183810.759887812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7c67bb771f996..6222d5a168832 100644
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
@@ -326,7 +320,7 @@ static void event_property_update(struct work_struct *work)
 			continue;
 
 		drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
-		mutex_lock(&hdcp_work->mutex);
+		guard(mutex)(&hdcp_work->mutex);
 
 		if (conn_state->commit) {
 			ret = wait_for_completion_interruptible_timeout(&conn_state->commit->hw_done,
@@ -358,7 +352,6 @@ static void event_property_update(struct work_struct *work)
 			drm_hdcp_update_content_protection(connector,
 							   DRM_MODE_CONTENT_PROTECTION_DESIRED);
 		}
-		mutex_unlock(&hdcp_work->mutex);
 		drm_modeset_unlock(&dev->mode_config.connection_mutex);
 	}
 }
@@ -371,7 +364,7 @@ static void event_property_validate(struct work_struct *work)
 	struct amdgpu_dm_connector *aconnector;
 	unsigned int conn_index;
 
-	mutex_lock(&hdcp_work->mutex);
+	guard(mutex)(&hdcp_work->mutex);
 
 	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX;
 	     conn_index++) {
@@ -415,8 +408,6 @@ static void event_property_validate(struct work_struct *work)
 			schedule_work(&hdcp_work->property_update_work);
 		}
 	}
-
-	mutex_unlock(&hdcp_work->mutex);
 }
 
 static void event_watchdog_timer(struct work_struct *work)
@@ -427,7 +418,7 @@ static void event_watchdog_timer(struct work_struct *work)
 				 struct hdcp_workqueue,
 				      watchdog_timer_dwork);
 
-	mutex_lock(&hdcp_work->mutex);
+	guard(mutex)(&hdcp_work->mutex);
 
 	cancel_delayed_work(&hdcp_work->watchdog_timer_dwork);
 
@@ -436,8 +427,6 @@ static void event_watchdog_timer(struct work_struct *work)
 			       &hdcp_work->output);
 
 	process_output(hdcp_work);
-
-	mutex_unlock(&hdcp_work->mutex);
 }
 
 static void event_cpirq(struct work_struct *work)
@@ -446,13 +435,11 @@ static void event_cpirq(struct work_struct *work)
 
 	hdcp_work = container_of(work, struct hdcp_workqueue, cpirq_work);
 
-	mutex_lock(&hdcp_work->mutex);
+	guard(mutex)(&hdcp_work->mutex);
 
 	mod_hdcp_process_event(&hdcp_work->hdcp, MOD_HDCP_EVENT_CPIRQ, &hdcp_work->output);
 
 	process_output(hdcp_work);
-
-	mutex_unlock(&hdcp_work->mutex);
 }
 
 void hdcp_destroy(struct kobject *kobj, struct hdcp_workqueue *hdcp_work)
@@ -486,7 +473,7 @@ static bool enable_assr(void *handle, struct dc_link *link)
 
 	dtm_cmd = (struct ta_dtm_shared_memory *)psp->dtm_context.context.mem_context.shared_buf;
 
-	mutex_lock(&psp->dtm_context.mutex);
+	guard(mutex)(&psp->dtm_context.mutex);
 	memset(dtm_cmd, 0, sizeof(struct ta_dtm_shared_memory));
 
 	dtm_cmd->cmd_id = TA_DTM_COMMAND__TOPOLOGY_ASSR_ENABLE;
@@ -501,8 +488,6 @@ static bool enable_assr(void *handle, struct dc_link *link)
 		res = false;
 	}
 
-	mutex_unlock(&psp->dtm_context.mutex);
-
 	return res;
 }
 
@@ -563,13 +548,11 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
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



