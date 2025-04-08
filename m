Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72029374C4;
	Tue,  8 Apr 2025 11:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110538; cv=none; b=U/qrkkOQJntEwHqOIGHZsA4mtIAKfvh4XW488tsq+OVBv9H52Oozd4Zfd7gWywWRg+sYFcP+cHeGmS5z9/P3AgK+3Cye7UAKkbtchCnP90Q+/qsSoFCaqK7vz358g4mUUHcoP72R86OoTyEO6dO1FkmA8Efe+0Ra5iRHhDs/Eic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110538; c=relaxed/simple;
	bh=ZPyXMWujfNzFCLqLqc7RgHBq3AIZpoX3UNZW7y7zEZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAK0+VG5JhkhN/3N2XJiupT6U1HI9+CxSa02i5i/+281lSsE9M2vPoQAGVfXocrC+QgOJ+7u80JSNmIZuQYGBoVy3V6WFTU54f2AA5jT7h+W5AKfrI222Y7EK7TyPYxMt3oUY+bpgqwMq0dzQZ8b2opR6cs2XZRSWXyHn1voJgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMvn7uVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMvn7uVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DA6C4CEE7;
	Tue,  8 Apr 2025 11:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110538;
	bh=ZPyXMWujfNzFCLqLqc7RgHBq3AIZpoX3UNZW7y7zEZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMvn7uVGlnkkWu5coEcmVW4JtNxezq84o/fdcSXQE8v+srfsHGmzX76DCWuhIXLZv
	 IGQEEO8KM7NefOjGOw1yJ5nXxwPRwTooUt15dv9kYh7+IZYrgwTwKYCsGT8fw2xSuB
	 NUPczPBEKRlBsCu7V1Dj3pFM3+EiXNoN9ffJ70vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gong <quic_wgong@quicinc.com>,
	Kang Yang <quic_kangyang@quicinc.com>,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 084/731] wifi: ath11k: update channel list in reg notifier instead reg worker
Date: Tue,  8 Apr 2025 12:39:41 +0200
Message-ID: <20250408104916.224926328@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 933ab187e679e6fbdeea1835ae39efcc59c022d2 ]

Currently when ath11k gets a new channel list, it will be processed
according to the following steps:
1. update new channel list to cfg80211 and queue reg_work.
2. cfg80211 handles new channel list during reg_work.
3. update cfg80211's handled channel list to firmware by
ath11k_reg_update_chan_list().

But ath11k will immediately execute step 3 after reg_work is just
queued. Since step 2 is asynchronous, cfg80211 may not have completed
handling the new channel list, which may leading to an out-of-bounds
write error:
BUG: KASAN: slab-out-of-bounds in ath11k_reg_update_chan_list
Call Trace:
    ath11k_reg_update_chan_list+0xbfe/0xfe0 [ath11k]
    kfree+0x109/0x3a0
    ath11k_regd_update+0x1cf/0x350 [ath11k]
    ath11k_regd_update_work+0x14/0x20 [ath11k]
    process_one_work+0xe35/0x14c0

Should ensure step 2 is completely done before executing step 3. Thus
Wen raised patch[1]. When flag NL80211_REGDOM_SET_BY_DRIVER is set,
cfg80211 will notify ath11k after step 2 is done.

So enable the flag NL80211_REGDOM_SET_BY_DRIVER then cfg80211 will
notify ath11k after step 2 is done. At this time, there will be no
KASAN bug during the execution of the step 3.

[1] https://patchwork.kernel.org/project/linux-wireless/patch/20230201065313.27203-1-quic_wgong@quicinc.com/

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Fixes: f45cb6b29cd3 ("wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()")
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
Reviewed-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Link: https://patch.msgid.link/20250117061737.1921-2-quic_kangyang@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/reg.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index b0f289784dd3a..7bfe47ad62a07 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 #include <linux/rtnetlink.h>
 
@@ -55,6 +55,19 @@ ath11k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 	ath11k_dbg(ar->ab, ATH11K_DBG_REG,
 		   "Regulatory Notification received for %s\n", wiphy_name(wiphy));
 
+	if (request->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
+		ath11k_dbg(ar->ab, ATH11K_DBG_REG,
+			   "driver initiated regd update\n");
+		if (ar->state != ATH11K_STATE_ON)
+			return;
+
+		ret = ath11k_reg_update_chan_list(ar, true);
+		if (ret)
+			ath11k_warn(ar->ab, "failed to update channel list: %d\n", ret);
+
+		return;
+	}
+
 	/* Currently supporting only General User Hints. Cell base user
 	 * hints to be handled later.
 	 * Hints from other sources like Core, Beacons are not expected for
@@ -293,12 +306,6 @@ int ath11k_regd_update(struct ath11k *ar)
 	if (ret)
 		goto err;
 
-	if (ar->state == ATH11K_STATE_ON) {
-		ret = ath11k_reg_update_chan_list(ar, true);
-		if (ret)
-			goto err;
-	}
-
 	return 0;
 err:
 	ath11k_warn(ab, "failed to perform regd update : %d\n", ret);
@@ -977,6 +984,7 @@ void ath11k_regd_update_work(struct work_struct *work)
 void ath11k_reg_init(struct ath11k *ar)
 {
 	ar->hw->wiphy->regulatory_flags = REGULATORY_WIPHY_SELF_MANAGED;
+	ar->hw->wiphy->flags |= WIPHY_FLAG_NOTIFY_REGDOM_BY_DRIVER;
 	ar->hw->wiphy->reg_notifier = ath11k_reg_notifier;
 }
 
-- 
2.39.5



