Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D40311C33;
	Tue, 11 Nov 2025 01:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824916; cv=none; b=i1Su4x41w2UNo93Jcz4oViUC/sdDwoICzSojUDmmBGaO5lShZbIkbamzcm/GlN7mFDNucCb6R+2JvdQlgA6SqQIsEGhMcttN6WeffDWjV08pS9h7QHmquNY+Ae6ky9hzyUaOWUae1Y52N6zjVUp3ioDlCUzJqxuqj7bU05x4P2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824916; c=relaxed/simple;
	bh=67rD1WXet/MTv2EgzIFEMWxXf5y9LtaRC8VpJP0LlT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHhUIRK2jQEHIC5DzmYbP1wg5Jv6KAjbAPPnYAfOXmTAxhv26Yg4XkK15MTd0jRQWP7tGQN46KIlO17MaQ6rHelfoPD35/6+yoex/Wk8J8CPbLJ/5X3mj+kDlqRjI4f2VFMUWqYCuTGfqEQpTwhPIImvCmIB5m0nz0pUlowmYnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHJKlAyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHJKlAyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACD3C4CEFB;
	Tue, 11 Nov 2025 01:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824916;
	bh=67rD1WXet/MTv2EgzIFEMWxXf5y9LtaRC8VpJP0LlT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHJKlAyoTrpP2sHiJ2h6mLE20F+CRlyjinEhCBjYRhgn4EN4lLJrt/xB6lbkSshQ8
	 ZIDXimdKR18bRTeLEoKdx5JPVfKSZYlDWwXiBydVuri7Qtio2wyhpDPpSnLR2Xo7qM
	 pwtV7cNIOM0MA52uA9IM7/cvtTFKGAD5DgUV0e+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Pernamitta <quic_vpernami@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 597/849] bus: mhi: core: Improve mhi_sync_power_up handling for SYS_ERR state
Date: Tue, 11 Nov 2025 09:42:47 +0900
Message-ID: <20251111004550.853909406@linuxfoundation.org>
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



