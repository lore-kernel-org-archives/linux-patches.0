Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED95630FC24;
	Sat, 25 Oct 2025 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409680; cv=none; b=NEcBTn9XTI2wskB6z1BqnBhNZstVqUfX78dS7XcIR9PswI/f5MUb64++wL5SQhQBFXmb2Ij3Bn9x8TWPqj1Tfh3BDnOgCnmCOh5t4mGwcSc6taOEmHemUKGNroFNyR/l/aes/dGSXWm3VQfLWM6W+UnwaHlBC45dfXdmIVDnJug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409680; c=relaxed/simple;
	bh=HscsrvAnBHSyAfLTwiWwW6EJn6QP03MRZgL13EFw9TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5RIS956AlGeWCvB6Nkh+Dh1CWHnWDhYR+6hGbyNxpZ7F1ZsclUohyrBEv+neb3erL+GwRGUlZG44DV7kds1GmjmTkEVmo84tPnmlhSIJEAkHed1iibUJqWpqnDk7LkSBkaPtzR3Ea3CDXI7yD4a0RlCrfyhoJ7D+u2i+zXckc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1AvR6ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1AvR6ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B000C4CEF5;
	Sat, 25 Oct 2025 16:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409679;
	bh=HscsrvAnBHSyAfLTwiWwW6EJn6QP03MRZgL13EFw9TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1AvR6eyht6J23053b1c/ZCP4oj8YOPRpTHivt5+eAitqflrdCJ5lzAj4tVQ1SJ+6
	 muN7nhRFxBXb2daRWym44L+YG2ryInmMbWcx60Loat4T5lf4Q+XugEMJbpdYD+8ejp
	 iINCgsE0rElgKJk7JPeAjKua7p+DZSPq3TgDOwKgYt4ifhtgOl5FtcZe+u7rOPrXvb
	 zF5SaVIYRH5xQij1WfrL6JeECHK3kmWZiawYmpfik8budzjqP2IMNmocN4W3YXECpC
	 oDMBdp/5bphR89mttHq8iT94FnP9CotzQ/+nuD7Bn4f4SeLMkPSLvx7ug0KkDKRAo0
	 144UI4jvxcLYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vivek Pernamitta <quic_vpernami@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	mani@kernel.org,
	jeff.hugo@oss.qualcomm.com,
	quic_mattleun@quicinc.com,
	alexander.wilhelm@westermo.com,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	linux@treblig.org
Subject: [PATCH AUTOSEL 6.17-6.12] bus: mhi: core: Improve mhi_sync_power_up handling for SYS_ERR state
Date: Sat, 25 Oct 2025 12:00:49 -0400
Message-ID: <20251025160905.3857885-418-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vivek Pernamitta <quic_vpernami@quicinc.com>

[ Upstream commit aa1a0e93ed21a06acb7ca9d4a4a9fce75ea53d0c ]

Allow mhi_sync_power_up to handle SYS_ERR during power-up, reboot,
or recovery. This is to avoid premature exit when MHI_PM_IN_ERROR_STATE is
observed during above mentioned system states.

To achieve this, treat SYS_ERR as a valid state and let its handler process
the error and queue the next transition to Mission Mode instead of aborting
early.

Signed-off-by: Vivek Pernamitta <quic_vpernami@quicinc.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20250912-uevent_vdev_next-20250911-v4-5-fa2f6ccd301b@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – the change keeps `mhi_sync_power_up()` waiting through recoverable
SYS_ERR handling instead of aborting immediately, which fixes real
device bring-up failures without touching unrelated logic.

- `drivers/bus/mhi/host/pm.c:1287` now waits for
  `MHI_PM_FATAL_ERROR(pm_state)` instead of any `MHI_PM_IN_ERROR_STATE`,
  so the synchronous power-up path no longer bails as soon as the
  controller reports `SYS_ERR_DETECT`/`SYS_ERR_PROCESS`; that lets the
  existing SYS_ERR recovery workflow (`mhi_pm_sys_error_transition()` at
  `drivers/bus/mhi/host/pm.c:597`) drive the device back to mission mode
  instead of forcing an unnecessary tear-down (`mhi_power_down()` call
  that follows on timeout).
- `drivers/bus/mhi/host/internal.h:173` introduces
  `MHI_PM_FATAL_ERROR()` to classify only firmware-download failures and
  states ≥`MHI_PM_SYS_ERR_FAIL` as fatal. This mirrors the state-machine
  design where `SYS_ERR_DETECT/PROCESS` are transitional and should be
  handled, while `SYS_ERR_FAIL`, `SHUTDOWN_PROCESS`, and
  `LD_ERR_FATAL_DETECT` are terminal.
- Without this patch, any transient SYS_ERR during power-up/recovery
  causes `wait_event_timeout()` to return immediately, leading to
  `-ETIMEDOUT` and forced power-down; that breaks reboot/recovery flows
  for controllers that legitimately enter SYS_ERR before reinitialising.
  With the patch, fatal errors still short-circuit (so failure
  propagation is unchanged) and the normal timeout still protects
  against hangs, keeping risk minimal.
- Dependencies: it assumes the earlier addition of the
  `MHI_PM_SYS_ERR_FAIL` state (`drivers/bus/mhi/host/internal.h:152`),
  so stable trees lacking commit bce3f770684cc (Jan 2024) need that
  prerequisite; otherwise the fix is self-contained.

 drivers/bus/mhi/host/internal.h | 2 ++
 drivers/bus/mhi/host/pm.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/host/internal.h b/drivers/bus/mhi/host/internal.h
index 034be33565b78..9f815cfac763e 100644
--- a/drivers/bus/mhi/host/internal.h
+++ b/drivers/bus/mhi/host/internal.h
@@ -170,6 +170,8 @@ enum mhi_pm_state {
 							MHI_PM_IN_ERROR_STATE(pm_state))
 #define MHI_PM_IN_SUSPEND_STATE(pm_state)		(pm_state & \
 							(MHI_PM_M3_ENTER | MHI_PM_M3))
+#define MHI_PM_FATAL_ERROR(pm_state)			((pm_state == MHI_PM_FW_DL_ERR) || \
+							(pm_state >= MHI_PM_SYS_ERR_FAIL))
 
 #define NR_OF_CMD_RINGS					1
 #define CMD_EL_PER_RING					128
diff --git a/drivers/bus/mhi/host/pm.c b/drivers/bus/mhi/host/pm.c
index 33d92bf2fc3ed..31b20c07de9ee 100644
--- a/drivers/bus/mhi/host/pm.c
+++ b/drivers/bus/mhi/host/pm.c
@@ -1279,7 +1279,7 @@ int mhi_sync_power_up(struct mhi_controller *mhi_cntrl)
 		mhi_cntrl->ready_timeout_ms : mhi_cntrl->timeout_ms;
 	wait_event_timeout(mhi_cntrl->state_event,
 			   MHI_IN_MISSION_MODE(mhi_cntrl->ee) ||
-			   MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+			   MHI_PM_FATAL_ERROR(mhi_cntrl->pm_state),
 			   msecs_to_jiffies(timeout_ms));
 
 	ret = (MHI_IN_MISSION_MODE(mhi_cntrl->ee)) ? 0 : -ETIMEDOUT;
-- 
2.51.0

