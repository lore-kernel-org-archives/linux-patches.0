Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAE9291C10;
	Sun,  7 Jun 2026 11:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830138; cv=none; b=h7/IXoXI1RHjGIj4BrbrAEA6XlN22cfPE20D/oadkhuBre+iVIs3i+Lh6lv3JN6T1UEAXBh71HXNN9WapZdsT5x2vWa84TRajeo1KpK7kr6zYp/MUX9gPaIlh3M5NxUTctFb7amVeg3GBi9by1RszQRPQMHLuJu8lh45qpoGm0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830138; c=relaxed/simple;
	bh=jzeB4CrEB4qsqcrZpZYNV8ecwZjkv9IooQ5+yx7r12o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QlcNQI3DX+Q7lPfCoX8LoTlzhgdNQ4vcecAO0yGCruOTqKAVVdMGRXWR0jLoDA/SxOYooQVC+lOUAzjobNuzuglZe3bq8o4txGFX2QQIY7xzochacdbUSzR3kvvkzzMNmudKraiw3HPsY2PP+4hiu6l+a6KvdSZMi1AtDg/HplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gP4K0LHe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gP4K0LHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9DC1F00893;
	Sun,  7 Jun 2026 11:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830136;
	bh=GAmDCdEyDdr4qxpe7KajtayuwtIWA/FGVhJw4YnCaAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gP4K0LHebLx7droplyrZP9avTncnwUjzAEGRlwyqHcKlBX8QmWacUQTqW1nCPKJBm
	 gz54/+dIvL77LFBJxNVtFEnC/FUdtVhnJs0A8NJ73Y9t6oCv9xcIpVQsabIwZzU7/J
	 oCLzKdNcS2yUh4TSmECYDurQo+R2oP4K6O/mj4n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 314/315] drm/i915/psr: Use DC_OFF wake reference to block DC6 on vblank enable
Date: Sun,  7 Jun 2026 12:01:41 +0200
Message-ID: <20260607095739.156163880@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 3549a9649dc7c5fc586ab12f675279283cdcb2a7 ]

We are observing following warnings:

*ERROR* power well DC_off state mismatch (refcount 0/enabled 1)

gen9_dc_off_power_well_enabled is considering target state DC_STATE_DISABLE
as DC_OFF power well being enabled. Fix this by using wakeref for the
purpose.

To achieve this we need to modify notification code as well. Currently it
is possible that PSR gets notified vblank enable/disable twice on same
status. This is currently not a problem as it is just triggering call to
intel_display_power_set_target_dc_state with same target state as a
parameter. When using wakeref this becomes a problem due to reference
counting. Fix this storing vbank status on last notification and use that
to ensure there are no more than one notification with same vblank status.

v2: ensure there is no subsequent notifications with same status

Fixes: aa451abcffb5 ("drm/i915/display: Prevent DC6 while vblank is enabled for Panel Replay")
Cc: <stable@vger.kernel.org> # v6.13+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Michał Grzelak <michal.grzelak@intel.com>
Link: https://patch.msgid.link/20260520104944.239797-2-jouni.hogander@intel.com
(cherry picked from commit 35485ac56d878192a3829a58cb26503125ec7104)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_core.h  |    1 
 drivers/gpu/drm/i915/display/intel_display_irq.c   |    8 +++++--
 drivers/gpu/drm/i915/display/intel_display_types.h |    2 +
 drivers/gpu/drm/i915/display/intel_psr.c           |   24 +++++++--------------
 4 files changed, 18 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_core.h
+++ b/drivers/gpu/drm/i915/display/intel_display_core.h
@@ -472,6 +472,7 @@ struct intel_display {
 		u8 vblank_enabled;
 
 		int vblank_enable_count;
+		bool vblank_status_last_notified;
 
 		struct work_struct vblank_notify_work;
 
--- a/drivers/gpu/drm/i915/display/intel_display_irq.c
+++ b/drivers/gpu/drm/i915/display/intel_display_irq.c
@@ -1707,8 +1707,12 @@ static void intel_display_vblank_notify_
 	struct intel_display *display =
 		container_of(work, typeof(*display), irq.vblank_notify_work);
 	int vblank_enable_count = READ_ONCE(display->irq.vblank_enable_count);
+	bool vblank_status = !!vblank_enable_count;
 
-	intel_psr_notify_vblank_enable_disable(display, vblank_enable_count);
+	if (display->irq.vblank_status_last_notified != vblank_status) {
+		intel_psr_notify_vblank_enable_disable(display, vblank_status);
+		display->irq.vblank_status_last_notified = vblank_status;
+	}
 }
 
 int bdw_enable_vblank(struct drm_crtc *_crtc)
@@ -1721,10 +1725,10 @@ int bdw_enable_vblank(struct drm_crtc *_
 	if (gen11_dsi_configure_te(crtc, true))
 		return 0;
 
+	spin_lock_irqsave(&display->irq.lock, irqflags);
 	if (crtc->vblank_psr_notify && display->irq.vblank_enable_count++ == 0)
 		schedule_work(&display->irq.vblank_notify_work);
 
-	spin_lock_irqsave(&display->irq.lock, irqflags);
 	bdw_enable_pipe_irq(display, pipe, GEN8_PIPE_VBLANK);
 	spin_unlock_irqrestore(&display->irq.lock, irqflags);
 
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1690,6 +1690,8 @@ struct intel_psr {
 	bool pkg_c_latency_used;
 
 	u8 active_non_psr_pipes;
+
+	struct ref_tracker *vblank_wakeref;
 };
 
 struct intel_dp {
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -3982,14 +3982,20 @@ void intel_psr_notify_vblank_enable_disa
 					    bool enable)
 {
 	struct intel_encoder *encoder;
-	bool block_dc_states = false;
 
 	for_each_intel_encoder_with_psr(display->drm, encoder) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
 		mutex_lock(&intel_dp->psr.lock);
-		if (CAN_PANEL_REPLAY(intel_dp))
-			block_dc_states = true;
+		if (CAN_PANEL_REPLAY(intel_dp)) {
+			if (enable)
+				intel_dp->psr.vblank_wakeref =
+					intel_display_power_get(display,
+								POWER_DOMAIN_DC_OFF);
+			else
+				intel_display_power_put(display, POWER_DOMAIN_DC_OFF,
+							intel_dp->psr.vblank_wakeref);
+		}
 
 		if (intel_dp->psr.enabled && !intel_dp->psr.panel_replay_enabled &&
 		    intel_dp->psr.pkg_c_latency_used)
@@ -3997,18 +4003,6 @@ void intel_psr_notify_vblank_enable_disa
 
 		mutex_unlock(&intel_dp->psr.lock);
 	}
-
-	/*
-	 * NOTE: intel_display_power_set_target_dc_state is used
-	 * only by PSR code for DC3CO handling. DC3CO target
-	 * state is currently disabled in * PSR code. If DC3CO
-	 * is taken into use we need take that into account here
-	 * as well.
-	 */
-	if (block_dc_states)
-		intel_display_power_set_target_dc_state(display, enable ?
-							DC_STATE_DISABLE :
-							DC_STATE_EN_UPTO_DC6);
 }
 
 static void


