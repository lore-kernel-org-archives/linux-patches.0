Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892E742FCD8;
	Thu, 30 Jul 2026 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421641; cv=none; b=nElzQj2VoHWGmR5IlN8DshCt5lUq+W7lHt7M3QRIJ6F8lbp0IOkOeFcpmqydSxhAdl7o+iRlG9MvHcEnXDZSY+GGQjuhBH2UHxwxZiEFImAioiFDO9p2BWfgetRi0l62U9k82YFI6LDBkbC3uq9CLEVXQw0hoG/+a/nTRW/Uxvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421641; c=relaxed/simple;
	bh=PHCKLhbE5+xNv07e8nB4Vr0PRqtjM1WZrpm/LobJkTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et9b5gbmZ1fK9tZw9bjxw62eaQf+A1O9TP1JDE4Mj2d6QrZ486r6bBy7aqgrafcn2UVDClRiZeD1rYusnhMWHbplpJvZJP4TINVXxlZdM7S9zOL20t0ZPGLqBMI0gVQ6WbNnOhf4xqAWHAaN0c/l/rn+pJ/WM5XpIOmhrzrWvdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIHvFrBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIHvFrBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE8D1F000E9;
	Thu, 30 Jul 2026 14:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421640;
	bh=e0JgwL6U8e1VHVg8iHK7guQhi6jGjJ6EqVzjUhQEYtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIHvFrBr2StPVzNOr76x9706s3JH5KYk93teCGs55h2sNIbCV3d8Eli5LWH5HdwDX
	 wG6CS67c8ttxAJ2l4u9NocSh/UkGKQoL2dpx0Rpdkm0B4qInACdqgfPkrn8W7ePpln
	 /As4aVMeUyv6LzR6nkzzn8YiYSJp+Bg4l0ZO9nlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaole Zhang <gaole.zhang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 170/744] wifi: ath11k: fix NULL pointer dereference in ath11k_hal_srng_access_begin
Date: Thu, 30 Jul 2026 16:07:23 +0200
Message-ID: <20260730141447.904763762@linuxfoundation.org>
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

From: Gaole Zhang <gaole.zhang@oss.qualcomm.com>

[ Upstream commit e8d85672dd7e2523f774caafba8f858384e18df7 ]

In ATH11K_QMI_EVENT_FW_READY, ATH11K_FLAG_REGISTERED is set
unconditionally even when ath11k_core_qmi_firmware_ready() fails.
This leaves the driver in an inconsistent state where
initialization is considered complete although the firmware ready
handling did not finish successfully. During the subsequent SSR,
the driver enters the restart path based on this incorrect state
and dereferences uninitialized srng members, resulting in a NULL
pointer dereference.

Call trace:
  ath11k_hal_srng_access_begin+0xc/0x60 [ath11k] (P)
  ath11k_ce_cleanup_pipes+0x17c/0x180 [ath11k]
  ath11k_core_restart+0x40/0x168 [ath11k]

Fix this by:
- skipping firmware_ready if ATH11K_FLAG_REGISTERED is already set
- setting ATH11K_FLAG_REGISTERED only when firmware_ready succeeds
- setting ATH11K_FLAG_QMI_FAIL and aborting the FW_READY handling
on error

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 6fe62a8cec51c ("wifi: ath11k: Add cold boot calibration support on WCN6750")
Signed-off-by: Gaole Zhang <gaole.zhang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260609090609.4041009-1-gaole.zhang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index feebbc30f3df32..a304feca70423e 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3295,9 +3295,14 @@ static void ath11k_qmi_driver_event_work(struct work_struct *work)
 			clear_bit(ATH11K_FLAG_CRASH_FLUSH,
 				  &ab->dev_flags);
 			clear_bit(ATH11K_FLAG_RECOVERY, &ab->dev_flags);
-			ath11k_core_qmi_firmware_ready(ab);
-			set_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags);
-
+			if (!test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
+				ret = ath11k_core_qmi_firmware_ready(ab);
+				if (ret) {
+					set_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags);
+					break;
+				}
+				set_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags);
+			}
 			break;
 		case ATH11K_QMI_EVENT_COLD_BOOT_CAL_DONE:
 			break;
-- 
2.53.0



