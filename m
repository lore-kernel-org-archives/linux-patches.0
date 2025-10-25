Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A8D2F7ADB;
	Sat, 25 Oct 2025 16:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409353; cv=none; b=egTp4+Qbb51QrFnrgIBSiLxHlD+QFMcZNlbMuSt840MRn/nZAgg+0VHJE/oKLGFWLC32PiSrfhuVkGywpZpZ9gEJG0u+PN0RoB3Cu0MOql1UWGHm11LeptPH7+LMe38h13yBK4LNIVCcSWmcknBtgBL1BC7gjNbCjwjfdTULAVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409353; c=relaxed/simple;
	bh=+m2yLu5QtoYtTsD1302q9cvyH3RpYi8eSON4BZhwQBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7Gi6/2F49TPbDshfpY9dZv7piG0EMtKD6KDBnnNvl/yCIDPfKYs6kQ1kAbPpWQKTOrT4cg8NJaQ0Q5bPcPsLu3xDHWQ9bv3J5vLogOjjdzJM6EZlTzGIxtidt/R/xL7lf1hrbk8z6o/uY2JdtI7vtp68LAgQywOlIEsO354Hos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rp+q5j4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rp+q5j4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8DFC4CEF5;
	Sat, 25 Oct 2025 16:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409353;
	bh=+m2yLu5QtoYtTsD1302q9cvyH3RpYi8eSON4BZhwQBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rp+q5j4HW4TIMn5LwzZYnxDsQ7+p1+liIQy0FXNjSLDF97ukpYCZOqz2NlUgMM3DF
	 PBHD0mqHX6Gqw5t/4lx5aZBuYu/hyjqp7PxTAKFdQUl+M/UR1adMs8cWfOKq1m7jgn
	 XP+GSTQNsPGLkQJlbflQVXCH6SMMKI9zQdDmFNypq1LeC252F97c1hXUgnSrOLDCL+
	 z8EuS/b7jiT7/NMYwwS/1r8kEQ87aqv0vKKH8O9s30VC0bQ83GGTTmfwfllf2yYnL3
	 6O4coLq84b/bwoCzorxIm86c9QThi/R3cGmsGSAKOsDVfTA+4WiLskRP3e2VFyxAq7
	 Nb7/lELR5NkBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/pm: Increase SMC timeout on SI and warn (v3)
Date: Sat, 25 Oct 2025 11:58:38 -0400
Message-ID: <20251025160905.3857885-287-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

**Change Details**
- Increases SMC message polling timeout in `amdgpu_si_send_msg_to_smc`
  from the device default to longer, message-specific intervals:
  - Adds local `usec_timeout` and selects 1s for slow messages and 200ms
    for others in `drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c:175` and
    cases at `drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c:179`.
  - Applies the new timeout in the poll loop `for (i = 0; i <
    usec_timeout; i++)` at `drivers/gpu/drm/amd/pm/legacy-
    dpm/si_smc.c:196`.
  - Emits a warning on timeout to aid debugging at
    `drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c:203`.
- The messages given extended timeout are specifically the ones observed
  to be slow: `PPSMC_MSG_NoForcedLevel`, `PPSMC_MSG_SetEnabledLevels`,
  `PPSMC_MSG_SetForcedLevels`, `PPSMC_MSG_DisableULV`,
  `PPSMC_MSG_SwitchToSwState` (see switch at
  `drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c:179`; message IDs defined
  under `drivers/gpu/drm/amd/pm/legacy-dpm/ppsmc.h:79`,
  `drivers/gpu/drm/amd/pm/legacy-dpm/ppsmc.h:81`,
  `drivers/gpu/drm/amd/pm/legacy-dpm/ppsmc.h:99`,
  `drivers/gpu/drm/amd/pm/legacy-dpm/ppsmc.h:106`,
  `drivers/gpu/drm/amd/pm/legacy-dpm/ppsmc.h:107`).
- Prior behavior used the device default timeout `adev->usec_timeout`
  (100 ms) for all messages; that default is defined as
  `AMDGPU_MAX_USEC_TIMEOUT` at `drivers/gpu/drm/amd/amdgpu/amdgpu.h:280`
  and initialized in `drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:4414`.

**Backport Assessment**
- Fixes a user-visible bug: On SI (e.g., Tahiti), switching from lower
  to higher clocks timed out spuriously, causing failures in:
  - `si_restrict_performance_levels_before_switch` which sends
    `PPSMC_MSG_NoForcedLevel` and `PPSMC_MSG_SetEnabledLevels`
    (`drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c:3899` and following).
  - `si_set_sw_state`, which sends `PPSMC_MSG_SwitchToSwState`
    (`drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c:3949`).
- Scope is small and contained: one function in the SI legacy DPM SMC
  path only (`drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c`); no API/ABI
  changes; no architectural changes.
- Risk is minimal and bounded:
  - Only increases timeouts when sending SMC messages; does not alter
    state-machine logic.
  - Longest busy-wait increases from 100 ms to 1 s, but only for a
    narrow set of transitions; these are not hot paths and the long
    latency is needed for hardware that legitimately responds slowly.
  - Still finite (no indefinite waits) and adds `drm_warn` for
    diagnostics (`drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c:203`).
- Constrained impact: Applies only to amdgpu’s SI legacy DPM; other
  ASICs and paths unaffected. Other SMC waits (e.g.,
  `amdgpu_si_wait_for_smc_inactive`) still use the driver default
  timeout (`drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c:221`).
- Aligns with stable rules: important reliability fix without new
  features or architectural churn; low regression risk; confined to a
  subsystem.

Given the clear user impact, narrow scope, and low risk, this is a
strong candidate for stable backport in trees that include SI legacy
DPM.

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

