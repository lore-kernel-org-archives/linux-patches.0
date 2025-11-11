Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7804C97;
	Tue, 11 Nov 2025 00:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822543; cv=none; b=nfX581jX9E7dQ8fXmjLv4DHI4CEsdBzy2b+UHJ4n/YIjqNGtFJMGjPphPaiLfYWdn4prNxTS+Zi441pKTksOainYQ6eJoVBMtm5YulUeGXahCueWc1NRZ69elohgCJtTinNqtlk+vqSic/b51kyABuQZDH9dZrj0umBfhdwDY4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822543; c=relaxed/simple;
	bh=LsE2qmxSKAfA8bqdIpPJFa9TCPEF82XYH/Sk+c1duvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEyWEauG0EoZfZOGvsF1XQ10dI+NoOfUSJ6WPjeQtqNoUjH7LsV3B31TLSHQP3ZU7XWPy51+wVh8vY1aOBDIcDRBj6Gls5mMjSj227SBFCfHENYUfCCCRZ1/DdVwqnBWKv7iswSFhNCepflaxNQJMyBv0Zl88aCeQngC9BVgAMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/787uDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/787uDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1B5C4CEFB;
	Tue, 11 Nov 2025 00:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822543;
	bh=LsE2qmxSKAfA8bqdIpPJFa9TCPEF82XYH/Sk+c1duvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/787uDeZWU1HI9IarBh1Oky4KodYS77xgrdvfCrTYqyECi3rU58mBE/8bu+IeCps
	 94T4NRqexEjoUjaNNdkvkiwiy8DsIPxIjwDjbHLD74yUHLXOuvWys+28RblMfP81sO
	 Y6T+epQZbiwwyKScmOldS621gDAJEwOYvP8KgDsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peyton.Lee@amd.com,
	Sultan Alsawaf <sultan@kerneltoast.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 071/565] drm/amd: Check that VPE has reached DPM0 in idle handler
Date: Tue, 11 Nov 2025 09:38:47 +0900
Message-ID: <20251111004528.550064213@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -321,6 +321,26 @@ static int vpe_early_init(void *handle)
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
@@ -328,11 +348,17 @@ static void vpe_idle_work_handler(struct
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


