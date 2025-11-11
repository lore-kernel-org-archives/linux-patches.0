Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932B84C97;
	Tue, 11 Nov 2025 00:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822430; cv=none; b=XkHPUy8eHTR25f7fPBrdWfGarhoMSM5LyLFF6G7aEapegGse4Mi9gDK3ciZFMN4CVfKzjVlNqYKSf5p7Ng72YRaKTydpWD9T5sljbbPF8MpZt7Gk/y/xR15wWGimYwublcf+zjVXWA7/AgKlczN6UyWFpwd9R1gSXcyWdeDnTQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822430; c=relaxed/simple;
	bh=M0AqXFJLcQrQnh/aCeXX01syfuPT5x4xZzhzsdJ8jfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMbe5O5GE4UyGbCYEZXJGhc/1KJ4Fgh6eaMhDAKzGSFzJo2/it7L8UmXl0gYRLeuOi8/K1EkO5LCKjmjUA4j739smdDPq2FItCy+KiiNzAr35g+3xg0azfD1tJaX2nzv5dJHP36YChzrkiH7OZvBPgVTlc24oW4lceiTN4HQvoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3Wr1Yb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3Wr1Yb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F394C16AAE;
	Tue, 11 Nov 2025 00:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822430;
	bh=M0AqXFJLcQrQnh/aCeXX01syfuPT5x4xZzhzsdJ8jfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3Wr1Yb4EDRcHL+bWzsgTOB/wnoLe6EgYC6Kifxzq4FDrJ4yiqxtmnmBoRo/PQS5v
	 1acv3Z1k23wERb4BuTFJEzy7USHb5bblB2D5nZqgOj2sbK/Iy5pYnAh6IhEdgC1aCY
	 dw6wf3UFLzV3SfDc99gWk38BjprgSqIZCirDCwbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peyton.Lee@amd.com,
	Sultan Alsawaf <sultan@kerneltoast.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 106/849] drm/amd: Check that VPE has reached DPM0 in idle handler
Date: Tue, 11 Nov 2025 09:34:36 +0900
Message-ID: <20251111004538.962749518@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit ba10f8d92a2c026b1052b4c0fa2cd7538838c965 upstream.

[Why]
Newer VPE microcode has functionality that will decrease DPM level
only when a workload has run for 2 or more seconds.  If VPE is turned
off before this DPM decrease and the PMFW doesn't reset it when
power gating VPE, the SOC can get stuck with a higher DPM level.

This can happen from amdgpu's ring buffer test because it's a short
quick workload for VPE and VPE is turned off after 1s.

[How]
In idle handler besides checking fences are drained check PMFW version
to determine if it will reset DPM when power gating VPE.  If PMFW will
not do this, then check VPE DPM level. If it is not DPM0 reschedule
delayed work again until it is.

v2: squash in return fix (Alex)

Cc: Peyton.Lee@amd.com
Reported-by: Sultan Alsawaf <sultan@kerneltoast.com>
Reviewed-by: Sultan Alsawaf <sultan@kerneltoast.com>
Tested-by: Sultan Alsawaf <sultan@kerneltoast.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4615
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3ac635367eb589bee8edcc722f812a89970e14b7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c |   34 ++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c
@@ -322,6 +322,26 @@ static int vpe_early_init(struct amdgpu_
 	return 0;
 }
 
+static bool vpe_need_dpm0_at_power_down(struct amdgpu_device *adev)
+{
+	switch (amdgpu_ip_version(adev, VPE_HWIP, 0)) {
+	case IP_VERSION(6, 1, 1):
+		return adev->pm.fw_version < 0x0a640500;
+	default:
+		return false;
+	}
+}
+
+static int vpe_get_dpm_level(struct amdgpu_device *adev)
+{
+	struct amdgpu_vpe *vpe = &adev->vpe;
+
+	if (!adev->pm.dpm_enabled)
+		return 0;
+
+	return RREG32(vpe_get_reg_offset(vpe, 0, vpe->regs.dpm_request_lv));
+}
+
 static void vpe_idle_work_handler(struct work_struct *work)
 {
 	struct amdgpu_device *adev =
@@ -329,11 +349,17 @@ static void vpe_idle_work_handler(struct
 	unsigned int fences = 0;
 
 	fences += amdgpu_fence_count_emitted(&adev->vpe.ring);
+	if (fences)
+		goto reschedule;
+
+	if (vpe_need_dpm0_at_power_down(adev) && vpe_get_dpm_level(adev) != 0)
+		goto reschedule;
+
+	amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VPE, AMD_PG_STATE_GATE);
+	return;
 
-	if (fences == 0)
-		amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VPE, AMD_PG_STATE_GATE);
-	else
-		schedule_delayed_work(&adev->vpe.idle_work, VPE_IDLE_TIMEOUT);
+reschedule:
+	schedule_delayed_work(&adev->vpe.idle_work, VPE_IDLE_TIMEOUT);
 }
 
 static int vpe_common_init(struct amdgpu_vpe *vpe)


