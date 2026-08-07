Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBD72F1FDF;
	Fri,  7 Aug 2026 15:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115758; cv=none; b=N2JF5T8Xk4z2zC/nDMQcJB9gZ0VMdgnrPsDVI7NrsnyrEyPminUks8GhGUxFr2hjugp8CsPf8btV8/WXf7k6KvkSkli5+b75cHHZ0EuzDAtEfDcESD+p2Kr2R9iAxVVXdOpcvq35/NajXmBGSThRxgXjae429v1s3rDwwZoczmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115758; c=relaxed/simple;
	bh=CK48spu1Bwp94SM0RtEQG6Y50rzLE9VV0Seq6Alfp/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6FsZIvv4Po75Lppl4s6L5fboNWur5nIZ2wtpIKYWzAc0a9uc5/7nOHtAVhFdO1xrbEqt9er59jSS5WpupQ1BFEDjZqT2kFojobKOPCp7hbta8gOm+4w5AiezQnnETpaQFrLrLgf364Uka76mro5ALw3oxde/Q74wU2JO2XjHfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSEEj/yu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSEEj/yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871331F000E9;
	Fri,  7 Aug 2026 15:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115747;
	bh=cAZeplSQMUPVSMkjM2re15Sxt9kQIoIfwrHyGNox/cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSEEj/yu7ap56su2K3x90qrl2X+OsIIiv7aKGnspnDSnrLwMI2tVxAA4STNH1d1Iq
	 r2ka1GaTnUDGz2STPro0yvVbmTkDuGEEHbjvaIfNlHk/QwPRTyv/Ck0l3deCAF6axV
	 HrDmbPminOiJR7E+tmqiW27pQDs+Ip/C5twnGD/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Weber <weber.aulendorf@gmail.com>,
	Leo Li <sunpeng.li@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 378/396] drm/amd/display: Exit idle optimizations before programming
Date: Fri,  7 Aug 2026 16:38:58 +0200
Message-ID: <20260807143432.435666820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Li <sunpeng.li@amd.com>

[ Upstream commit 8419331e64d92a8de5fc4feef0e305f201fb8b33 ]

[Why]

We need to exit PSR/IPS before programming. Before calling DC for
programming in amdgpu_dm_commit_planes(), there's a
vblank_control_workqueue flush. This waits for IPS and PSR exit. (See
drm_vblank_on/off() > amdgpu_dm_crtc_set_vblank() --queue_work()->
amdgpu_dm_crtc_vblank_control_worker())

Prior to the tagged "Fixes:" change, drm_vblank_get() was called before
the workqueue flush. This ordering ensures that PSR exit occurred before
programming. After the "Fixes:" change, drm_vblank_get() is called after
the workqueue flush, leading to programming while idle optimizations are
still active. This can lead to incorrect flip_pending detection used by
vblank event delivery.

[How]

Split the vblank_get() component of `dm_arm_vblank_event()` into
`dm_arm_vblank_event_pre_programming()`, which is called before
programming. Call it before the vblank_control_workqueue flush.

Includes a drive-by cleanup of prepare_flip_isr(): the only caller is
dm_arm_vblank_event() and it's simple enough to roll-in.

v2: Fix checkpatch formatting warning on
    drm_arm_vblank_event_pre_programming() arg alignment.

Fixes: 48ab86360af1 ("drm/amd/display: check GRPH_FLIP status before sending event")
Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/4141#note_3583205
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5527
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Claude:opus-5
Suggested-by: David Weber <weber.aulendorf@gmail.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 05984e29520a28c27f5a2388742c957a6a87ee7a)
(cherry picked from commit 8419331e64d92a8de5fc4feef0e305f201fb8b33)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 78 +++++++++++--------
 1 file changed, 46 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index be267f5b9f8cc..4f53297786623 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9326,25 +9326,6 @@ static void remove_stream(struct amdgpu_device *adev,
 	acrtc->enabled = false;
 }
 
-static void prepare_flip_isr(struct amdgpu_crtc *acrtc)
-{
-
-	assert_spin_locked(&acrtc->base.dev->event_lock);
-	WARN_ON(acrtc->event);
-
-	acrtc->event = acrtc->base.state->event;
-
-	/* Set the flip status */
-	acrtc->pflip_status = AMDGPU_FLIP_SUBMITTED;
-
-	/* Mark this event as consumed */
-	acrtc->base.state->event = NULL;
-
-	drm_dbg_state(acrtc->base.dev,
-		      "crtc:%d, pflip_stat:AMDGPU_FLIP_SUBMITTED\n",
-		      acrtc->crtc_id);
-}
-
 static void update_freesync_state_on_stream(
 	struct amdgpu_display_manager *dm,
 	struct dm_crtc_state *new_crtc_state,
@@ -9692,17 +9673,47 @@ static void dm_arm_vblank_event(struct amdgpu_crtc *acrtc,
 		return;
 
 	if (pflip_update) {
-		drm_crtc_vblank_get(&acrtc->base);
 		WARN_ON(acrtc->pflip_status != AMDGPU_FLIP_NONE);
-		/* Arm flip completion handling and event delivery after programming. */
-		prepare_flip_isr(acrtc);
+		WARN_ON(acrtc->event);
+
+		acrtc->pflip_status = AMDGPU_FLIP_SUBMITTED;
+		acrtc->event = acrtc->base.state->event;
+		acrtc->base.state->event = NULL;
+
+		drm_dbg_state(acrtc->base.dev,
+			      "crtc:%d, pflip_stat:AMDGPU_FLIP_SUBMITTED\n",
+			      acrtc->crtc_id);
 	} else if (cursor_update) {
-		drm_crtc_vblank_get(&acrtc->base);
 		acrtc->event = acrtc->base.state->event;
 		acrtc->base.state->event = NULL;
 	}
 }
 
+/**
+ * dm_arm_vblank_event_pre_programming - Prepare for programming
+ * @acrtc: The amdgpu CRTC to prepare
+ * @acrtc_state: The new CRTC state
+ * @pflip_update: Whether a page flip is being programmed
+ * @cursor_update: Whether a cursor update is being programmed
+ *
+ * Grab a reference on the vblank counter if a page flip or cursor update is to
+ * be programmed. Do this before programming so the HW is not in any
+ * idle-optimized state (such as PSR).
+ */
+static void dm_arm_vblank_event_pre_programming(struct amdgpu_crtc *acrtc,
+						struct dm_crtc_state *acrtc_state,
+						bool pflip_update,
+						bool cursor_update)
+{
+	assert_spin_locked(&acrtc->base.dev->event_lock);
+
+	if (!acrtc->base.state->event || acrtc_state->active_planes == 0)
+		return;
+
+	if (pflip_update || cursor_update)
+		drm_crtc_vblank_get(&acrtc->base);
+}
+
 static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 				    struct drm_device *dev,
 				    struct amdgpu_display_manager *dm,
@@ -9969,16 +9980,19 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 		}
 	}
 
-	/*
-	 * DCE depends on a combination of GRPH_FLIP, VLINE0, and VUPDATE for
-	 * event delivery. Only GRPH_FLIP handler can send pflip events, and it
-	 * only fires if HW latched to the flip. Maintain legacy behavior by
-	 * arming event before programming.
-	 */
-	if (amdgpu_ip_version(dm->adev, DCE_HWIP, 0) == 0) {
-		scoped_guard(spinlock_irqsave, &pcrtc->dev->event_lock) {
+	scoped_guard(spinlock_irqsave, &pcrtc->dev->event_lock) {
+		dm_arm_vblank_event_pre_programming(acrtc_attach, acrtc_state,
+						    pflip_present,
+						    cursor_update);
+		/*
+		 * DCE depends on a combination of GRPH_FLIP, VLINE0, and
+		 * VUPDATE for event delivery. Only GRPH_FLIP handler can send
+		 * pflip events, and it only fires if HW latched to the flip.
+		 * Maintain legacy behavior by arming event before programming.
+		 */
+		if (amdgpu_ip_version(dm->adev, DCE_HWIP, 0) == 0) {
 			dm_arm_vblank_event(acrtc_attach, acrtc_state,
-					pflip_present, cursor_update);
+					    pflip_present, cursor_update);
 		}
 	}
 
-- 
2.53.0



