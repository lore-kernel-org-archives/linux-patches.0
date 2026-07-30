Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D20367B67;
	Thu, 30 Jul 2026 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423797; cv=none; b=VtZTUOw7znnKi0hfxcTZFs5RFsw8onFv++ws+K747qQjdcbIwrZS6jIx0fyicapuL0gMwll4FSkWFlv7g2EyaZuQVMYkl715JebqPr5pJhTDO7IVxYaz5W4eUyaeFvYbhHZS5ffrzYayQza2ZzwvSBRCi0BfuS9SqVcNcEQ4pE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423797; c=relaxed/simple;
	bh=IgObL2njbxJeWR1/fazqiMmwKXMLaLSeZFJ0eimfxso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8kin6+d9gxxgWkATVVAX5Qky0oZRUBBMITiTL8dAQb3gJbXHP7LVX9O7uOHvZNGtqWlWFeRDN22WFZEXWHHXd12CCV5hu8q7C4SvdcIfB2dU3udkUnTAjKY1sODNjLg/xvxWhgeRf9WvTRt3yIb1JODz24RLyKytz5Gg7TG3gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOxQAF6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOxQAF6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A329A1F000E9;
	Thu, 30 Jul 2026 15:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423796;
	bh=Bbo0iVXLIVLhl3c3MCjCNQoqbvONdCldtQPMj3k5J2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOxQAF6B9A1P/TF5+tOCaZ91EuK32Dw5T2bcXqcshKYrVzflravAVQAl2l40U7Vdr
	 rAFyiwdv7jlf1e/1MJ0Ov7ARmPhgT3cEt3xIZQC1rjEADgGl5wIG6PTInMTSrF9k/S
	 U7aBqYB9rFkqVrLOuaDOJvtqtEfTQHaqxShynQJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaole Zhang <gaole.zhang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/675] wifi: ath11k: fix NULL pointer dereference in ath11k_hal_srng_access_begin
Date: Thu, 30 Jul 2026 16:08:17 +0200
Message-ID: <20260730141448.685540627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aea56c38bf8f38..f23d75c8ad6794 100644
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



