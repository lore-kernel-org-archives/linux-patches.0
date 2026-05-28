Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C801DE4E0;
	Thu, 28 May 2026 20:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001002; cv=none; b=Xqufb/uPvnzT1O7I4R+vrg83d7ozB+E60humnMuelYeye/ih/KIh6RRbmq6fd3GaOD0J7HsZgijuL/Q+xYoxST3LXta/3Wyt3F4n8mBWE4V5XiDfzkIyznq3pITq+k5fq4uv8zOTs1vysvp0Sx01NtEhhdmCnnCBJ/mmdwWtgK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001002; c=relaxed/simple;
	bh=YFBD36gT0+rFy1m5CHIQg4RBD4ajWlpY6inFsD6XnIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NL390oIs9p9Igdsmq6dUZiVQOdIhTJvSKjwfA/3ke0N/P9X7T9DAQlpKwI3PMy4m8OXoRnxpO9RoL9zw1jZfrAxOyUh4lf9PJ/kuO0tZYma6ICL+zCA8/danLz9jRv4bISN7XHyvJO9KDSHsPvmEDV7FSH+M2hUgz+8Fz/y4eTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUWx1RlV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUWx1RlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BACC1F000E9;
	Thu, 28 May 2026 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001001;
	bh=1Dypxq+kSlUI7in4I89ssLtvz5ZFn6VXC1zOIGbDe3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUWx1RlV4Pdhi/+BBhyo+O6l5pZR+eddVpEUVZ8A/rgjljBCvFBRz/3RjB6U3cr/b
	 iVBp+bxtOKNAs23/Q+fU3QJYCEo2Wd68zi/vjaFKhoDxh0vdPKFo8MC4JFTnyX+/do
	 Wn3nUD/DiBdQf8h4wjbkv/aRjeY5+Dn5C8WAIWQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/272] wifi: ath10k: skip WMI and beacon transmission when device is wedged
Date: Thu, 28 May 2026 21:49:42 +0200
Message-ID: <20260528194635.056902813@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit 54a5b38e4396530e5b2f12b54d3844e860ab6784 ]

In ath10k_wmi_cmd_send(), the current code detects ATH10K_STATE_WEDGED
and sets ret to -ESHUTDOWN, but still proceeds to transmit pending
beacons and calls ath10k_wmi_cmd_send_nowait().

This can lead to incorrect behavior, as WMI commands and beacons are
still sent after the device has been marked as wedged, and the original
-ESHUTDOWN return value may be overwritten by the result of the send
path.

The wedged state indicates the hardware is already unreliable, and no
further interaction with firmware is expected or meaningful in this
state.

Fix this by skipping beacon transmission and the WMI send path entirely
once ATH10K_STATE_WEDGED is detected, ensuring consistent return values
and avoiding unnecessary firmware interaction.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Fixes: c256a94d1b1b ("wifi: ath10k: shutdown driver when hardware is unreliable")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260428061737.37-1-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 408f062a4306f..c9f41309d18d4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
@@ -1947,15 +1946,15 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 			ret = -ESHUTDOWN;
 			ath10k_dbg(ar, ATH10K_DBG_WMI,
 				   "drop wmi command %d, hardware is wedged\n", cmd_id);
-		}
-		/* try to send pending beacons first. they take priority */
-		ath10k_wmi_tx_beacons_nowait(ar);
+		} else {
+			/* try to send pending beacons first. they take priority */
+			ath10k_wmi_tx_beacons_nowait(ar);
 
-		ret = ath10k_wmi_cmd_send_nowait(ar, skb, cmd_id);
-
-		if (ret && test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags))
-			ret = -ESHUTDOWN;
+			ret = ath10k_wmi_cmd_send_nowait(ar, skb, cmd_id);
 
+			if (ret && test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags))
+				ret = -ESHUTDOWN;
+		}
 		(ret != -EAGAIN);
 	}), 3 * HZ);
 
-- 
2.53.0



