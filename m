Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1775D30B500;
	Mon, 13 Oct 2025 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369535; cv=none; b=gek0VQ55t04e3BeC0rUyIeyesLvJsBMW54OO1rNpwpgCzJHzua9pSYFan/W7C8+ZKsVHWVzTcxw2h20GmwLOHgfygvVQG5Jgegano0HVxggUjI+JMD9ehEnpCvBoCs4nOFHnqoA17tAiMWrtSEObHNHEEERajwjvQay76h0ukdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369535; c=relaxed/simple;
	bh=nDakJrTCBcsSfTLq3OafhSR9wrh9/0AAGub+AINbTOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpsbx4aonrlZSHiTNQxPUucazU6G4g8q9EX9D5lToAJQGYT9TqrsJRi93CS1IHMb9F9Se/F0qbwfz4z4oMaYFSJe2bANHQaQZGsgFy/MuOFUo8fnFdFktjZuneadayavIQLzIxoFruaPcCo2Vgddnq4MLD1iobonrD8gYIsgyhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8ogMmdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8ogMmdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96456C4CEE7;
	Mon, 13 Oct 2025 15:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369535;
	bh=nDakJrTCBcsSfTLq3OafhSR9wrh9/0AAGub+AINbTOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8ogMmdOoZ923d9ml8TPuYlVckeZ7NM8pXP7UvzpXAIb2DoHT8AW0sAfvGGuQoBpY
	 2OCgBehwn9/rXuaqCZK6CZcNK2nn1vJ9bCCOwQnd+3bVGbaePB7YXd6R/Yt8FfEzrt
	 4rOnxltMqVEZMbCRndY7WaqED/Yq/00b9jdPdD9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 281/563] drm/amdgpu: Check vcn state before profile switch
Date: Mon, 13 Oct 2025 16:42:22 +0200
Message-ID: <20251013144421.451236851@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 9c0442286f84a5036958b3d8eb00bf0bb070dbd1 ]

The patch uses power state of VCN instances for requesting video
profile.

In idle worker of a vcn instance, when there is no outstanding
submisssion or fence, the instance is put to power gated state. When
all instances are powered off that means video profile is no longer
required. A request is made to turn off video profile.

A job submission starts with begin_use of ring, and at that time
vcn instance state is changed to power on. Subsequently a check is
made for active video profile, and if not active, a request is made.

Fixes: 3b669df92c85 ("drm/amdgpu/vcn: adjust workload profile handling")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c | 80 ++++++++++++++++---------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h |  3 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c   | 27 +--------
 3 files changed, 56 insertions(+), 54 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
index e965b624efdb1..e5e40d10bb14b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -410,6 +410,54 @@ int amdgpu_vcn_resume(struct amdgpu_device *adev, int i)
 	return 0;
 }
 
+void amdgpu_vcn_get_profile(struct amdgpu_device *adev)
+{
+	int r;
+
+	mutex_lock(&adev->vcn.workload_profile_mutex);
+
+	if (adev->vcn.workload_profile_active) {
+		mutex_unlock(&adev->vcn.workload_profile_mutex);
+		return;
+	}
+	r = amdgpu_dpm_switch_power_profile(adev, PP_SMC_POWER_PROFILE_VIDEO,
+					    true);
+	if (r)
+		dev_warn(adev->dev,
+			 "(%d) failed to enable video power profile mode\n", r);
+	else
+		adev->vcn.workload_profile_active = true;
+	mutex_unlock(&adev->vcn.workload_profile_mutex);
+}
+
+void amdgpu_vcn_put_profile(struct amdgpu_device *adev)
+{
+	bool pg = true;
+	int r, i;
+
+	mutex_lock(&adev->vcn.workload_profile_mutex);
+	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
+		if (adev->vcn.inst[i].cur_state != AMD_PG_STATE_GATE) {
+			pg = false;
+			break;
+		}
+	}
+
+	if (pg) {
+		r = amdgpu_dpm_switch_power_profile(
+			adev, PP_SMC_POWER_PROFILE_VIDEO, false);
+		if (r)
+			dev_warn(
+				adev->dev,
+				"(%d) failed to disable video power profile mode\n",
+				r);
+		else
+			adev->vcn.workload_profile_active = false;
+	}
+
+	mutex_unlock(&adev->vcn.workload_profile_mutex);
+}
+
 static void amdgpu_vcn_idle_work_handler(struct work_struct *work)
 {
 	struct amdgpu_vcn_inst *vcn_inst =
@@ -417,7 +465,6 @@ static void amdgpu_vcn_idle_work_handler(struct work_struct *work)
 	struct amdgpu_device *adev = vcn_inst->adev;
 	unsigned int fences = 0, fence[AMDGPU_MAX_VCN_INSTANCES] = {0};
 	unsigned int i = vcn_inst->inst, j;
-	int r = 0;
 
 	if (adev->vcn.harvest_config & (1 << i))
 		return;
@@ -446,15 +493,8 @@ static void amdgpu_vcn_idle_work_handler(struct work_struct *work)
 		mutex_lock(&vcn_inst->vcn_pg_lock);
 		vcn_inst->set_pg_state(vcn_inst, AMD_PG_STATE_GATE);
 		mutex_unlock(&vcn_inst->vcn_pg_lock);
-		mutex_lock(&adev->vcn.workload_profile_mutex);
-		if (adev->vcn.workload_profile_active) {
-			r = amdgpu_dpm_switch_power_profile(adev, PP_SMC_POWER_PROFILE_VIDEO,
-							    false);
-			if (r)
-				dev_warn(adev->dev, "(%d) failed to disable video power profile mode\n", r);
-			adev->vcn.workload_profile_active = false;
-		}
-		mutex_unlock(&adev->vcn.workload_profile_mutex);
+		amdgpu_vcn_put_profile(adev);
+
 	} else {
 		schedule_delayed_work(&vcn_inst->idle_work, VCN_IDLE_TIMEOUT);
 	}
@@ -464,30 +504,11 @@ void amdgpu_vcn_ring_begin_use(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_vcn_inst *vcn_inst = &adev->vcn.inst[ring->me];
-	int r = 0;
 
 	atomic_inc(&vcn_inst->total_submission_cnt);
 
 	cancel_delayed_work_sync(&vcn_inst->idle_work);
 
-	/* We can safely return early here because we've cancelled the
-	 * the delayed work so there is no one else to set it to false
-	 * and we don't care if someone else sets it to true.
-	 */
-	if (adev->vcn.workload_profile_active)
-		goto pg_lock;
-
-	mutex_lock(&adev->vcn.workload_profile_mutex);
-	if (!adev->vcn.workload_profile_active) {
-		r = amdgpu_dpm_switch_power_profile(adev, PP_SMC_POWER_PROFILE_VIDEO,
-						    true);
-		if (r)
-			dev_warn(adev->dev, "(%d) failed to switch to video power profile mode\n", r);
-		adev->vcn.workload_profile_active = true;
-	}
-	mutex_unlock(&adev->vcn.workload_profile_mutex);
-
-pg_lock:
 	mutex_lock(&vcn_inst->vcn_pg_lock);
 	vcn_inst->set_pg_state(vcn_inst, AMD_PG_STATE_UNGATE);
 
@@ -515,6 +536,7 @@ void amdgpu_vcn_ring_begin_use(struct amdgpu_ring *ring)
 		vcn_inst->pause_dpg_mode(vcn_inst, &new_state);
 	}
 	mutex_unlock(&vcn_inst->vcn_pg_lock);
+	amdgpu_vcn_get_profile(adev);
 }
 
 void amdgpu_vcn_ring_end_use(struct amdgpu_ring *ring)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
index b3fb1d0e43fc9..6d9acd36041d0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -565,4 +565,7 @@ int amdgpu_vcn_reg_dump_init(struct amdgpu_device *adev,
 			     const struct amdgpu_hwip_reg_entry *reg, u32 count);
 void amdgpu_vcn_dump_ip_state(struct amdgpu_ip_block *ip_block);
 void amdgpu_vcn_print_ip_state(struct amdgpu_ip_block *ip_block, struct drm_printer *p);
+void amdgpu_vcn_get_profile(struct amdgpu_device *adev);
+void amdgpu_vcn_put_profile(struct amdgpu_device *adev);
+
 #endif
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index bc30a5326866c..f13ed3c1e29c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -116,7 +116,6 @@ static void vcn_v2_5_idle_work_handler(struct work_struct *work)
 	struct amdgpu_device *adev = vcn_inst->adev;
 	unsigned int fences = 0, fence[AMDGPU_MAX_VCN_INSTANCES] = {0};
 	unsigned int i, j;
-	int r = 0;
 
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		struct amdgpu_vcn_inst *v = &adev->vcn.inst[i];
@@ -149,15 +148,7 @@ static void vcn_v2_5_idle_work_handler(struct work_struct *work)
 	if (!fences && !atomic_read(&adev->vcn.inst[0].total_submission_cnt)) {
 		amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VCN,
 						       AMD_PG_STATE_GATE);
-		mutex_lock(&adev->vcn.workload_profile_mutex);
-		if (adev->vcn.workload_profile_active) {
-			r = amdgpu_dpm_switch_power_profile(adev, PP_SMC_POWER_PROFILE_VIDEO,
-							    false);
-			if (r)
-				dev_warn(adev->dev, "(%d) failed to disable video power profile mode\n", r);
-			adev->vcn.workload_profile_active = false;
-		}
-		mutex_unlock(&adev->vcn.workload_profile_mutex);
+		amdgpu_vcn_put_profile(adev);
 	} else {
 		schedule_delayed_work(&adev->vcn.inst[0].idle_work, VCN_IDLE_TIMEOUT);
 	}
@@ -167,7 +158,6 @@ static void vcn_v2_5_ring_begin_use(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_vcn_inst *v = &adev->vcn.inst[ring->me];
-	int r = 0;
 
 	atomic_inc(&adev->vcn.inst[0].total_submission_cnt);
 
@@ -177,20 +167,6 @@ static void vcn_v2_5_ring_begin_use(struct amdgpu_ring *ring)
 	 * the delayed work so there is no one else to set it to false
 	 * and we don't care if someone else sets it to true.
 	 */
-	if (adev->vcn.workload_profile_active)
-		goto pg_lock;
-
-	mutex_lock(&adev->vcn.workload_profile_mutex);
-	if (!adev->vcn.workload_profile_active) {
-		r = amdgpu_dpm_switch_power_profile(adev, PP_SMC_POWER_PROFILE_VIDEO,
-						    true);
-		if (r)
-			dev_warn(adev->dev, "(%d) failed to switch to video power profile mode\n", r);
-		adev->vcn.workload_profile_active = true;
-	}
-	mutex_unlock(&adev->vcn.workload_profile_mutex);
-
-pg_lock:
 	mutex_lock(&adev->vcn.inst[0].vcn_pg_lock);
 	amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VCN,
 					       AMD_PG_STATE_UNGATE);
@@ -218,6 +194,7 @@ static void vcn_v2_5_ring_begin_use(struct amdgpu_ring *ring)
 		v->pause_dpg_mode(v, &new_state);
 	}
 	mutex_unlock(&adev->vcn.inst[0].vcn_pg_lock);
+	amdgpu_vcn_get_profile(adev);
 }
 
 static void vcn_v2_5_ring_end_use(struct amdgpu_ring *ring)
-- 
2.51.0



