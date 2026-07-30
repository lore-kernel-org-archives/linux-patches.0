Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A5541F5E6;
	Thu, 30 Jul 2026 14:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421606; cv=none; b=FB1OWlaTJZB74204NV59TUQVpcCZk1zL6CLzcLXkOIa2D31rVj0Ud1P4b0a3rliFutGixsvszaVha48xw/oIR/roH5mdwqd7yP6ZX7ubFnzVPPLT1epA//ZiQGmQ3BnDNWuutrXibAa9k7+849hSVIpEsAxg159wc+LP96BLc0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421606; c=relaxed/simple;
	bh=MeYEuno0kKqbrMieuwahT6wvrqBspGo/dxPos5aMoH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYH3Opb5e6trFoxqlS9/+WE1LRpdbjW1INNNUdIRyh0/d/qjeT1sxHLTqoTedodmc1XbyXcpriXFvtfSe3WPmA8LhsQMcOTOZZMkleweTg15PZNRyyZdvhrrcW3rH3lx6cH/FuDwqSlPrVLquD/PulLWw2OOJNYy5VQ6UvpvBYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQD4GBLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQD4GBLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CABB1F000E9;
	Thu, 30 Jul 2026 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421604;
	bh=55Eb+xc6Zw6x4zW0pZC2oLll1bIcNyHb1N7Uyk2kHGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQD4GBLfueV719T8KTZmBiTVqIxd2wTgVTwQF9+bjo3Y3WB7eqKzXodKFTRX2/uyA
	 3+tY9vBvHgepAfsP91gAzYYkGzJWkzZ5cFqPEHqNXMIlifsB7JD6fV8JoxlSGdgZL9
	 aLGzxnz+YM4budvpLYk1YNrzcmjkX+K0+FR2G73s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sun peng (Leo) Li" <sunpeng.li@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 159/744] drm/amd/display: Fix ISM dc_lock deadlock during suspend
Date: Thu, 30 Jul 2026 16:07:12 +0200
Message-ID: <20260730141447.673599722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ray Wu <ray.wu@amd.com>

[ Upstream commit 3714fe242592e3699ac5e2c19d68b275a210be7d ]

[Why]
System hang observed during suspend/resume while video is playing.
amdgpu_dm_ism_disable() is called under dc_lock and waits for ISM
delayed work via disable_delayed_work_sync(). The work handlers
themselves take dc_lock, producing an ABBA deadlock when a worker is
in flight at suspend time.

[How]
Split the disable path into two phases with opposite locking
contracts:
  1. amdgpu_dm_ism_disable() -- quiesces workers, must NOT hold
     dc_lock.
  2. amdgpu_dm_ism_force_full_power() (new) -- drives the ISM FSM
     back to FULL_POWER_RUNNING, must hold dc_lock.

Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 25 +++++++--
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_ism.c | 56 ++++++++++++++++---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_ism.h |  1 +
 3 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1ecd7bef9ed850..45951d47ed58c8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2260,9 +2260,16 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 		adev->dm.idle_workqueue = NULL;
 	}
 
-	/* Disable ISM before dc_destroy() invalidates dm->dc */
+	/*
+	 * Disable ISM before dc_destroy() invalidates dm->dc.
+	 *
+	 * Quiesce workers first without dc_lock (they take dc_lock
+	 * themselves, so syncing under it would deadlock), then drive the
+	 * FSM back to FULL_POWER_RUNNING under dc_lock.
+	 */
+	amdgpu_dm_ism_disable(&adev->dm);
 	scoped_guard(mutex, &adev->dm.dc_lock)
-		amdgpu_dm_ism_disable(&adev->dm);
+		amdgpu_dm_ism_force_full_power(&adev->dm);
 
 	amdgpu_dm_destroy_drm_device(&adev->dm);
 
@@ -3290,9 +3297,14 @@ static int dm_suspend(struct amdgpu_ip_block *ip_block)
 	if (amdgpu_in_reset(adev)) {
 		enum dc_status res;
 
+		/* Quiesce ISM workers before taking dc_lock (workers take
+		 * dc_lock themselves; syncing under it would deadlock).
+		 */
+		amdgpu_dm_ism_disable(dm);
+
 		mutex_lock(&dm->dc_lock);
 
-		amdgpu_dm_ism_disable(dm);
+		amdgpu_dm_ism_force_full_power(dm);
 		dc_allow_idle_optimizations(adev->dm.dc, false);
 
 		dm->cached_dc_state = dc_state_create_copy(dm->dc->current_state);
@@ -3326,8 +3338,13 @@ static int dm_suspend(struct amdgpu_ip_block *ip_block)
 
 	amdgpu_dm_irq_suspend(adev);
 
+	/*
+	 * Quiesce ISM workers before taking dc_lock (workers take dc_lock
+	 * themselves; syncing under it would deadlock).
+	 */
+	amdgpu_dm_ism_disable(dm);
 	scoped_guard(mutex, &dm->dc_lock)
-		amdgpu_dm_ism_disable(dm);
+		amdgpu_dm_ism_force_full_power(dm);
 
 	hpd_rx_irq_work_suspend(dm);
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.c
index a64e95860e99b3..b32c8d3ac15234 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.c
@@ -524,13 +524,20 @@ static void dm_ism_sso_delayed_work_func(struct work_struct *work)
 }
 
 /**
- * amdgpu_dm_ism_disable - Disable the ISM
+ * amdgpu_dm_ism_disable - Quiesce ISM workers
  *
  * @dm: The amdgpu display manager
  *
- * Disable the idle state manager by disabling any ISM work, canceling pending
- * work, and waiting for in-progress work to finish. After disabling, the system
- * is left in DM_ISM_STATE_FULL_POWER_RUNNING state.
+ * Cancels and disables any pending or in-flight ISM delayed work and waits
+ * for in-progress work to finish. After this returns, no ISM worker can run
+ * and subsequent mod_delayed_work() calls become no-ops via
+ * clear_pending_if_disabled().
+ *
+ * Must NOT be called with dc_lock held: the workers themselves take dc_lock,
+ * so a synchronous wait under dc_lock would deadlock.
+ *
+ * The caller is responsible for driving the FSM back to FULL_POWER_RUNNING
+ * (under dc_lock) by calling amdgpu_dm_ism_force_full_power().
  */
 void amdgpu_dm_ism_disable(struct amdgpu_display_manager *dm)
 {
@@ -538,21 +545,54 @@ void amdgpu_dm_ism_disable(struct amdgpu_display_manager *dm)
 	struct amdgpu_crtc *acrtc;
 	struct amdgpu_dm_ism *ism;
 
-	ASSERT(mutex_is_locked(&dm->dc_lock));
+	/*
+	 * Caller must NOT hold dc_lock: the ISM delayed work handlers
+	 * acquire dc_lock themselves, so waiting for them via
+	 * disable_delayed_work_sync() while holding dc_lock would
+	 * self-deadlock against an in-flight worker.
+	 */
+	lockdep_assert_not_held(&dm->dc_lock);
 
 	drm_for_each_crtc(crtc, dm->ddev) {
 		acrtc = to_amdgpu_crtc(crtc);
 		ism = &acrtc->ism;
 
-		/* Cancel and disable any pending work */
 		disable_delayed_work_sync(&ism->delayed_work);
 		disable_delayed_work_sync(&ism->sso_delayed_work);
+	}
+}
+
+/**
+ * amdgpu_dm_ism_force_full_power - Force every CRTC's ISM FSM to FULL_POWER
+ *
+ * @dm: The amdgpu display manager
+ *
+ * Sends DM_ISM_EVENT_EXIT_IDLE_REQUESTED to every CRTC's ISM, leaving each
+ * FSM in FULL_POWER_RUNNING. Intended to be paired with
+ * amdgpu_dm_ism_disable(): callers should first quiesce workers (without
+ * dc_lock), then take dc_lock and call this helper.
+ *
+ * Must be called with dc_lock held.
+ */
+void amdgpu_dm_ism_force_full_power(struct amdgpu_display_manager *dm)
+{
+	struct drm_crtc *crtc;
+	struct amdgpu_crtc *acrtc;
+
+	/*
+	 * Caller must hold dc_lock: commit_event() drives the FSM and
+	 * may touch dc state via dc_allow_idle_optimizations() etc.
+	 */
+	lockdep_assert_held(&dm->dc_lock);
+
+	drm_for_each_crtc(crtc, dm->ddev) {
+		acrtc = to_amdgpu_crtc(crtc);
 
 		/*
 		 * When disabled, leave in FULL_POWER_RUNNING state.
-		 * EXIT_IDLE will not queue any work
+		 * EXIT_IDLE will not queue any work.
 		 */
-		amdgpu_dm_ism_commit_event(ism,
+		amdgpu_dm_ism_commit_event(&acrtc->ism,
 					   DM_ISM_EVENT_EXIT_IDLE_REQUESTED);
 	}
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.h
index fde0ddc8d4e4bc..964408cd9a839c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.h
@@ -146,6 +146,7 @@ void amdgpu_dm_ism_fini(struct amdgpu_dm_ism *ism);
 void amdgpu_dm_ism_commit_event(struct amdgpu_dm_ism *ism,
 				enum amdgpu_dm_ism_event event);
 void amdgpu_dm_ism_disable(struct amdgpu_display_manager *dm);
+void amdgpu_dm_ism_force_full_power(struct amdgpu_display_manager *dm);
 void amdgpu_dm_ism_enable(struct amdgpu_display_manager *dm);
 
 #endif
-- 
2.53.0



