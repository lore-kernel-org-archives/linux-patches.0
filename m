Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B19533FE26;
	Tue, 11 Nov 2025 01:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824022; cv=none; b=Si3lpq+OyAGlDnZ/JLeENsK0EPFV1qMMwiSLC1kOFVd10bWfgqVbdxsibYoIw3jYZGZLknbNmFjCmWRI9MmE4Nt1F5AVUkDAzGjXcJ+BGb3DXna3eLKSIq+JvWGLmkpn17+iwKIJ0XkXLVud2rElqBD3rH9m/Hzoh77SU3jCQNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824022; c=relaxed/simple;
	bh=ze5aSfWEj7ryxrxiSGj3VL1DqEU4hV8QT5V+z33NkAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ui7f3dW7t7dRp67Mtruu9T9GltDJkCz9SPUztSnUFUyL3Fyw8yTP6FhBs/ss9g2ZXAgOtynPSWn0Rf39JGmvW4GSPWLlIFyMFBIGUDutraBygL3E6PistI0VzaEmDbqM+0bJd3B4W+zKoNc49VSqTCqDEW1PBw3yCAkNx9aR6fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xh7gcBC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xh7gcBC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8B6C4CEFB;
	Tue, 11 Nov 2025 01:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824022;
	bh=ze5aSfWEj7ryxrxiSGj3VL1DqEU4hV8QT5V+z33NkAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xh7gcBC9YgYztTU4MDZ/s5sFen82uL+WT5k2ROrnKNL89Ti37yXzR5v4uVNC/txhw
	 sTktoLSeL4bLVr8DNAil67rShBG+usfKTsdT02MYzQintKfDlr2GLJ578tCyecogGU
	 72r8YmVqeBcRrKSXtkllR0pEDPMllM8lGiGLB2jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 422/849] drm/amd/pm: Increase SMC timeout on SI and warn (v3)
Date: Tue, 11 Nov 2025 09:39:52 +0900
Message-ID: <20251111004546.644639471@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 813d13524a3bdcc5f0253e06542440ca74c2653a ]

The SMC can take an excessive amount of time to process some
messages under some conditions.

Background:
Sending a message to the SMC works by writing the message into
the mmSMC_MESSAGE_0 register and its optional parameter into
the mmSMC_SCRATCH0, and then polling mmSMC_RESP_0. Previously
the timeout was AMDGPU_MAX_USEC_TIMEOUT, ie. 100 ms.

Increase the timeout to 200 ms for all messages and to 1 sec for
a few messages which I've observed to be especially slow:
PPSMC_MSG_NoForcedLevel
PPSMC_MSG_SetEnabledLevels
PPSMC_MSG_SetForcedLevels
PPSMC_MSG_DisableULV
PPSMC_MSG_SwitchToSwState

This fixes the following problems on Tahiti when switching
from a lower clock power state to a higher clock state, such
as when DC turns on a display which was previously turned off.

* si_restrict_performance_levels_before_switch would fail
  (if the user previously forced high clocks using sysfs)
* si_set_sw_state would fail (always)

It turns out that both of those failures were SMC timeouts and
that the SMC actually didn't fail or hang, just needs more time
to process those.

Add a warning when there is an SMC timeout to make it easier to
identify this type of problem in the future.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c | 26 ++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c
index 4e65ab9e931c9..281a5e377aee4 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c
@@ -172,20 +172,42 @@ PPSMC_Result amdgpu_si_send_msg_to_smc(struct amdgpu_device *adev,
 {
 	u32 tmp;
 	int i;
+	int usec_timeout;
+
+	/* SMC seems to process some messages exceptionally slowly. */
+	switch (msg) {
+	case PPSMC_MSG_NoForcedLevel:
+	case PPSMC_MSG_SetEnabledLevels:
+	case PPSMC_MSG_SetForcedLevels:
+	case PPSMC_MSG_DisableULV:
+	case PPSMC_MSG_SwitchToSwState:
+		usec_timeout = 1000000; /* 1 sec */
+		break;
+	default:
+		usec_timeout = 200000; /* 200 ms */
+		break;
+	}
 
 	if (!amdgpu_si_is_smc_running(adev))
 		return PPSMC_Result_Failed;
 
 	WREG32(mmSMC_MESSAGE_0, msg);
 
-	for (i = 0; i < adev->usec_timeout; i++) {
+	for (i = 0; i < usec_timeout; i++) {
 		tmp = RREG32(mmSMC_RESP_0);
 		if (tmp != 0)
 			break;
 		udelay(1);
 	}
 
-	return (PPSMC_Result)RREG32(mmSMC_RESP_0);
+	tmp = RREG32(mmSMC_RESP_0);
+	if (tmp == 0) {
+		drm_warn(adev_to_drm(adev),
+			"%s timeout on message: %x (SMC_SCRATCH0: %x)\n",
+			__func__, msg, RREG32(mmSMC_SCRATCH0));
+	}
+
+	return (PPSMC_Result)tmp;
 }
 
 PPSMC_Result amdgpu_si_wait_for_smc_inactive(struct amdgpu_device *adev)
-- 
2.51.0



