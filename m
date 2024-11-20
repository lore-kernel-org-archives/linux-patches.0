Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB031DFEF;
	Wed, 20 Nov 2024 12:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107540; cv=none; b=k1mSEEVMAJvrAoqyYIWK6mOHhHYb/+2Ij2ccKmXr1CRjetWYiJDo709hCCfTjI5hh2TZ7eZHHGFktqlrgadN+Rj+1q3bXdvJbse5yal3xedk5MSUw99nSB8REQfTuayXzORaWd806Sqt1WLggTwBbH642egeVx4EJnujVQ6k6jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107540; c=relaxed/simple;
	bh=jD+cvABDb8sAX/pQ5jKk6vbjjiH2aLSpuhlgCEMECXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4WyChCSK1lZZxkyUln2tBP+HY1S8lwBLokkbbuG6CSWgYh//Iq2+A+MTjQDsGdpa4hMWM59ObFJ28EjnOI+mp8dDymK2q3DHJhMYlf69RaE7snmjvaW65VKa3FBT1Pb48gYIQGTrTg3uYrxo+RPtRGClbsYK6+2H7+H79kpoBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQkecq31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQkecq31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046BEC4CED1;
	Wed, 20 Nov 2024 12:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107540;
	bh=jD+cvABDb8sAX/pQ5jKk6vbjjiH2aLSpuhlgCEMECXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQkecq31gOjfdrVaqXQJGEE4/mhIOiqQIAedOEvWgXY+vna/S6FksT34NZoe4PuaC
	 /2DMDMW90m4HH4/b2KgjfWBK1zzcuZikVC9DTZ2DQ09kVrnYcwbn/EoP8M7+VpmEON
	 tt009Yx1lMQvaoOQMkA8w0nYdSuYoeoClNys+TFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Hickey <bugfood-c@fatooh.org>,
	James Courtier-Dutton <james.dutton@gmail.com>,
	Leo Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 038/107] drm/amd/display: Fix Panel Replay not update screen correctly
Date: Wed, 20 Nov 2024 13:56:13 +0100
Message-ID: <20241120125630.538701046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Tom Chung <chiahsuan.chung@amd.com>

commit bd8a9576617439bdc907c9ce0875909aea4221cb upstream.

[Why]
In certain use case such as KDE login screen, there will be no atomic
commit while do the frame update.
If the Panel Replay enabled, it will cause the screen not updated and
looks like system hang.

[How]
Delay few atomic commits before enabled the Panel Replay just like PSR.

Fixes: be64336307a6c ("drm/amd/display: Re-enable panel replay feature")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3686
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3682
Tested-By: Corey Hickey <bugfood-c@fatooh.org>
Tested-By: James Courtier-Dutton <james.dutton@gmail.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ca628f0eddd73adfccfcc06b2a55d915bca4a342)
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c      |  111 ++++++++---------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    5 
 2 files changed, 59 insertions(+), 57 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8830,6 +8830,56 @@ static void amdgpu_dm_update_cursor(stru
 	}
 }
 
+static void amdgpu_dm_enable_self_refresh(struct amdgpu_crtc *acrtc_attach,
+					  const struct dm_crtc_state *acrtc_state,
+					  const u64 current_ts)
+{
+	struct psr_settings *psr = &acrtc_state->stream->link->psr_settings;
+	struct replay_settings *pr = &acrtc_state->stream->link->replay_settings;
+	struct amdgpu_dm_connector *aconn =
+		(struct amdgpu_dm_connector *)acrtc_state->stream->dm_stream_context;
+
+	if (acrtc_state->update_type > UPDATE_TYPE_FAST) {
+		if (pr->config.replay_supported && !pr->replay_feature_enabled)
+			amdgpu_dm_link_setup_replay(acrtc_state->stream->link, aconn);
+		else if (psr->psr_version != DC_PSR_VERSION_UNSUPPORTED &&
+			     !psr->psr_feature_enabled)
+			if (!aconn->disallow_edp_enter_psr)
+				amdgpu_dm_link_setup_psr(acrtc_state->stream);
+	}
+
+	/* Decrement skip count when SR is enabled and we're doing fast updates. */
+	if (acrtc_state->update_type == UPDATE_TYPE_FAST &&
+	    (psr->psr_feature_enabled || pr->config.replay_supported)) {
+		if (aconn->sr_skip_count > 0)
+			aconn->sr_skip_count--;
+
+		/* Allow SR when skip count is 0. */
+		acrtc_attach->dm_irq_params.allow_sr_entry = !aconn->sr_skip_count;
+
+		/*
+		 * If sink supports PSR SU/Panel Replay, there is no need to rely on
+		 * a vblank event disable request to enable PSR/RP. PSR SU/RP
+		 * can be enabled immediately once OS demonstrates an
+		 * adequate number of fast atomic commits to notify KMD
+		 * of update events. See `vblank_control_worker()`.
+		 */
+		if (acrtc_attach->dm_irq_params.allow_sr_entry &&
+#ifdef CONFIG_DRM_AMD_SECURE_DISPLAY
+		    !amdgpu_dm_crc_window_is_activated(acrtc_state->base.crtc) &&
+#endif
+		    (current_ts - psr->psr_dirty_rects_change_timestamp_ns) > 500000000) {
+			if (pr->replay_feature_enabled && !pr->replay_allow_active)
+				amdgpu_dm_replay_enable(acrtc_state->stream, true);
+			if (psr->psr_version >= DC_PSR_VERSION_SU_1 &&
+			    !psr->psr_allow_active && !aconn->disallow_edp_enter_psr)
+				amdgpu_dm_psr_enable(acrtc_state->stream);
+		}
+	} else {
+		acrtc_attach->dm_irq_params.allow_sr_entry = false;
+	}
+}
+
 static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 				    struct drm_device *dev,
 				    struct amdgpu_display_manager *dm,
@@ -9158,9 +9208,12 @@ static void amdgpu_dm_commit_planes(stru
 			bundle->stream_update.abm_level = &acrtc_state->abm_level;
 
 		mutex_lock(&dm->dc_lock);
-		if ((acrtc_state->update_type > UPDATE_TYPE_FAST) &&
-				acrtc_state->stream->link->psr_settings.psr_allow_active)
-			amdgpu_dm_psr_disable(acrtc_state->stream);
+		if (acrtc_state->update_type > UPDATE_TYPE_FAST) {
+			if (acrtc_state->stream->link->replay_settings.replay_allow_active)
+				amdgpu_dm_replay_disable(acrtc_state->stream);
+			if (acrtc_state->stream->link->psr_settings.psr_allow_active)
+				amdgpu_dm_psr_disable(acrtc_state->stream);
+		}
 		mutex_unlock(&dm->dc_lock);
 
 		/*
@@ -9201,57 +9254,7 @@ static void amdgpu_dm_commit_planes(stru
 			dm_update_pflip_irq_state(drm_to_adev(dev),
 						  acrtc_attach);
 
-		if (acrtc_state->update_type > UPDATE_TYPE_FAST) {
-			if (acrtc_state->stream->link->replay_settings.config.replay_supported &&
-					!acrtc_state->stream->link->replay_settings.replay_feature_enabled) {
-				struct amdgpu_dm_connector *aconn =
-					(struct amdgpu_dm_connector *)acrtc_state->stream->dm_stream_context;
-				amdgpu_dm_link_setup_replay(acrtc_state->stream->link, aconn);
-			} else if (acrtc_state->stream->link->psr_settings.psr_version != DC_PSR_VERSION_UNSUPPORTED &&
-					!acrtc_state->stream->link->psr_settings.psr_feature_enabled) {
-
-				struct amdgpu_dm_connector *aconn = (struct amdgpu_dm_connector *)
-					acrtc_state->stream->dm_stream_context;
-
-				if (!aconn->disallow_edp_enter_psr)
-					amdgpu_dm_link_setup_psr(acrtc_state->stream);
-			}
-		}
-
-		/* Decrement skip count when SR is enabled and we're doing fast updates. */
-		if (acrtc_state->update_type == UPDATE_TYPE_FAST &&
-		    acrtc_state->stream->link->psr_settings.psr_feature_enabled) {
-			struct amdgpu_dm_connector *aconn =
-				(struct amdgpu_dm_connector *)acrtc_state->stream->dm_stream_context;
-
-			if (aconn->sr_skip_count > 0)
-				aconn->sr_skip_count--;
-
-			/* Allow SR when skip count is 0. */
-			acrtc_attach->dm_irq_params.allow_sr_entry = !aconn->sr_skip_count;
-
-			/*
-			 * If sink supports PSR SU/Panel Replay, there is no need to rely on
-			 * a vblank event disable request to enable PSR/RP. PSR SU/RP
-			 * can be enabled immediately once OS demonstrates an
-			 * adequate number of fast atomic commits to notify KMD
-			 * of update events. See `vblank_control_worker()`.
-			 */
-			if (acrtc_state->stream->link->psr_settings.psr_version >= DC_PSR_VERSION_SU_1 &&
-			    acrtc_attach->dm_irq_params.allow_sr_entry &&
-#ifdef CONFIG_DRM_AMD_SECURE_DISPLAY
-			    !amdgpu_dm_crc_window_is_activated(acrtc_state->base.crtc) &&
-#endif
-			    !acrtc_state->stream->link->psr_settings.psr_allow_active &&
-			    !aconn->disallow_edp_enter_psr &&
-			    (timestamp_ns -
-			    acrtc_state->stream->link->psr_settings.psr_dirty_rects_change_timestamp_ns) >
-			    500000000)
-				amdgpu_dm_psr_enable(acrtc_state->stream);
-		} else {
-			acrtc_attach->dm_irq_params.allow_sr_entry = false;
-		}
-
+		amdgpu_dm_enable_self_refresh(acrtc_attach, acrtc_state, timestamp_ns);
 		mutex_unlock(&dm->dc_lock);
 	}
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -266,11 +266,10 @@ static void amdgpu_dm_crtc_vblank_contro
 	 * where the SU region is the full hactive*vactive region. See
 	 * fill_dc_dirty_rects().
 	 */
-	if (vblank_work->stream && vblank_work->stream->link) {
+	if (vblank_work->stream && vblank_work->stream->link && vblank_work->acrtc) {
 		amdgpu_dm_crtc_set_panel_sr_feature(
 			vblank_work, vblank_work->enable,
-			vblank_work->acrtc->dm_irq_params.allow_sr_entry ||
-			vblank_work->stream->link->replay_settings.replay_feature_enabled);
+			vblank_work->acrtc->dm_irq_params.allow_sr_entry);
 	}
 
 	if (dm->active_vblank_irq_count == 0) {


