Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19771A6161;
	Tue, 30 Jul 2024 16:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356582; cv=none; b=eIdVyzoOmszmdE3GkEb6eDbTIo8LtQz4wgBQc+jfCffu/EGIn/3dpAnE2fbYqxT8zg9bAFOrr0tfHnykowqhtUlmMBc7qZcWM2DSnLPPqe/C2zLyh8+0Z47l2Don6u5LJ8Fys4Qu32oBKgAqdGD4tSCBjPyQWVwh7McV9/3blwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356582; c=relaxed/simple;
	bh=CK8wMBdIWqa1+1KZKABHCgt6t8y3mWGicgBxdo8XMW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxZqeCMjAYcROb7fAbk4p84sTe5qz8TL8SoMwE+dJ65/F3Iq3o1waqJJRXlTmdPl205gD2iQJv/foTQOqhQCLmDCJisoJuuGb1+QFt+oIDDib0kP4wuhxhf7qIU5gxnKn9pJMrSbib8MQy4TdsZKWbxcTJi7F69I+/dRtAyBgI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtk0kGjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtk0kGjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C15C32782;
	Tue, 30 Jul 2024 16:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356582;
	bh=CK8wMBdIWqa1+1KZKABHCgt6t8y3mWGicgBxdo8XMW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtk0kGjrcCZ1ilmeNoNInbYPrYZqQkhPDzXTzJWTUi3uSGkO8y5VCK9gnjK2cGGmU
	 W/mWJJW+JzY75S3uy4q79K/bwYbrccx6oTDASqQGLcMrCyUS6Zz1Jmdfng8HOroum4
	 ijDs9em7lCKjdlMS1Ubfna1MQ9h1mmWoOaMUw/iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 164/809] wifi: ath11k: refactor setting country code logic
Date: Tue, 30 Jul 2024 17:40:40 +0200
Message-ID: <20240730151731.085081301@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit b363614c0c80f9e2f3ffe8e77270e783a0fb8ab5 ]

ath11k_wmi_send_set_current_country_cmd() is called in several places
and all of them are just simply repeating the same logic.

Refactor to make code clean.

Compile tested only.

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240520024148.5472-2-quic_bqiang@quicinc.com
Stable-dep-of: 7f0343b7b871 ("wifi: ath11k: restore country code during resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 19 ++++++++-----------
 drivers/net/wireless/ath/ath11k/mac.c  | 13 +++----------
 drivers/net/wireless/ath/ath11k/reg.c  | 14 ++++++++++----
 drivers/net/wireless/ath/ath11k/reg.h  |  4 ++--
 4 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index b82e8fb285413..a14d0c65000ad 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1978,23 +1978,20 @@ static void ath11k_update_11d(struct work_struct *work)
 	struct ath11k_base *ab = container_of(work, struct ath11k_base, update_11d_work);
 	struct ath11k *ar;
 	struct ath11k_pdev *pdev;
-	struct wmi_set_current_country_params set_current_param = {};
 	int ret, i;
 
-	spin_lock_bh(&ab->base_lock);
-	memcpy(&set_current_param.alpha2, &ab->new_alpha2, 2);
-	spin_unlock_bh(&ab->base_lock);
-
-	ath11k_dbg(ab, ATH11K_DBG_WMI, "update 11d new cc %c%c\n",
-		   set_current_param.alpha2[0],
-		   set_current_param.alpha2[1]);
-
 	for (i = 0; i < ab->num_radios; i++) {
 		pdev = &ab->pdevs[i];
 		ar = pdev->ar;
 
-		memcpy(&ar->alpha2, &set_current_param.alpha2, 2);
-		ret = ath11k_wmi_send_set_current_country_cmd(ar, &set_current_param);
+		spin_lock_bh(&ab->base_lock);
+		memcpy(&ar->alpha2, &ab->new_alpha2, 2);
+		spin_unlock_bh(&ab->base_lock);
+
+		ath11k_dbg(ab, ATH11K_DBG_WMI, "update 11d new cc %c%c for pdev %d\n",
+			   ar->alpha2[0], ar->alpha2[1], i);
+
+		ret = ath11k_reg_set_cc(ar);
 		if (ret)
 			ath11k_warn(ar->ab,
 				    "pdev id %d failed set current country code: %d\n",
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 9b96dbb21d833..0c0444dc06f69 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8851,12 +8851,8 @@ ath11k_mac_op_reconfig_complete(struct ieee80211_hw *hw,
 		ieee80211_wake_queues(ar->hw);
 
 		if (ar->ab->hw_params.current_cc_support &&
-		    ar->alpha2[0] != 0 && ar->alpha2[1] != 0) {
-			struct wmi_set_current_country_params set_current_param = {};
-
-			memcpy(&set_current_param.alpha2, ar->alpha2, 2);
-			ath11k_wmi_send_set_current_country_cmd(ar, &set_current_param);
-		}
+		    ar->alpha2[0] != 0 && ar->alpha2[1] != 0)
+			ath11k_reg_set_cc(ar);
 
 		if (ab->is_reset) {
 			recovery_count = atomic_inc_return(&ab->recovery_count);
@@ -10325,11 +10321,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	}
 
 	if (ab->hw_params.current_cc_support && ab->new_alpha2[0]) {
-		struct wmi_set_current_country_params set_current_param = {};
-
-		memcpy(&set_current_param.alpha2, ab->new_alpha2, 2);
 		memcpy(&ar->alpha2, ab->new_alpha2, 2);
-		ret = ath11k_wmi_send_set_current_country_cmd(ar, &set_current_param);
+		ret = ath11k_reg_set_cc(ar);
 		if (ret)
 			ath11k_warn(ar->ab,
 				    "failed set cc code for mac register: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index 737fcd450d4bd..39232b8f52bae 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -49,7 +49,6 @@ ath11k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct wmi_init_country_params init_country_param;
-	struct wmi_set_current_country_params set_current_param = {};
 	struct ath11k *ar = hw->priv;
 	int ret;
 
@@ -83,9 +82,8 @@ ath11k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 	 * reg info
 	 */
 	if (ar->ab->hw_params.current_cc_support) {
-		memcpy(&set_current_param.alpha2, request->alpha2, 2);
-		memcpy(&ar->alpha2, &set_current_param.alpha2, 2);
-		ret = ath11k_wmi_send_set_current_country_cmd(ar, &set_current_param);
+		memcpy(&ar->alpha2, request->alpha2, 2);
+		ret = ath11k_reg_set_cc(ar);
 		if (ret)
 			ath11k_warn(ar->ab,
 				    "failed set current country code: %d\n", ret);
@@ -1017,3 +1015,11 @@ void ath11k_reg_free(struct ath11k_base *ab)
 		kfree(ab->new_regd[i]);
 	}
 }
+
+int ath11k_reg_set_cc(struct ath11k *ar)
+{
+	struct wmi_set_current_country_params set_current_param = {};
+
+	memcpy(&set_current_param.alpha2, ar->alpha2, 2);
+	return ath11k_wmi_send_set_current_country_cmd(ar, &set_current_param);
+}
diff --git a/drivers/net/wireless/ath/ath11k/reg.h b/drivers/net/wireless/ath/ath11k/reg.h
index 64edb794260ab..263ea90619483 100644
--- a/drivers/net/wireless/ath/ath11k/reg.h
+++ b/drivers/net/wireless/ath/ath11k/reg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #ifndef ATH11K_REG_H
@@ -45,5 +45,5 @@ ath11k_reg_ap_pwr_convert(enum ieee80211_ap_reg_power power_type);
 int ath11k_reg_handle_chan_list(struct ath11k_base *ab,
 				struct cur_regulatory_info *reg_info,
 				enum ieee80211_ap_reg_power power_type);
-
+int ath11k_reg_set_cc(struct ath11k *ar);
 #endif
-- 
2.43.0



