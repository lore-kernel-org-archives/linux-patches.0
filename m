Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6674086A;
	Tue, 11 Nov 2025 00:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822418; cv=none; b=j5aMjMdQgbzvEZGnkgQhvzbWUVP7ISZKA0TLgAlXGd7GQsf8Faaqt0zCgoRUaL+MgfkfxJA+8ZbP+0HSqumzobrM7f6lE1JNRQ7dFx6FmdAmeeeduDuOckqi9yFJr9HU52qu9FTm37gn81Q6hNQBQn/DJjoYOgTdynGWDlRgqss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822418; c=relaxed/simple;
	bh=SRIPdPswIFD0ENWZJFzxdQaNVmo3Ai6sFl6a7DhwhHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEWFv4kPwaVWPxBMHc4kziFAAZrnPGXU5UwV6LkuVb2zG7ZncJr3EDxLgxnXXfTgShmRhzJ4ZdlB/R43FA4c2VbdBGLLtxBzdtdwp26ii83fKuUu6Z3HsGbImHiSpTWcM9UDdiEAtdXjq9vj6C6zQPOZfJB7EakYTXdGYafdf5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMxz95TI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMxz95TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295F7C2BC87;
	Tue, 11 Nov 2025 00:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822418;
	bh=SRIPdPswIFD0ENWZJFzxdQaNVmo3Ai6sFl6a7DhwhHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMxz95TIHCpvBQVr3TzV2DxtQbhwf/aOy3DfutRDTvAJZcjGwESLDQjVCL4GiDGJK
	 jeoovJ0n99fNQzbNkcU1D7YJd768qoGGTi3pdi7Qzml5uIrxHsiKcSg4ya7XcJrC+w
	 KKpnliJbh4EO1wgy4opf8mzezaWmU1QjQCS9JEd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/565] wifi: ath11k: avoid bit operation on key flags
Date: Tue, 11 Nov 2025 09:37:59 +0900
Message-ID: <20251111004527.396038986@linuxfoundation.org>
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

From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

[ Upstream commit 9c78e747dd4fee6c36fcc926212e20032055cf9d ]

Bitwise operations with WMI_KEY_PAIRWISE (defined as 0) are ineffective
and misleading. This results in pairwise key validations added in
commit 97acb0259cc9 ("wifi: ath11k: fix group data packet drops
during rekey") to always evaluate false and clear key commands for
pairwise keys are not honored.

Since firmware supports overwriting the new key without explicitly
clearing the previous one, there is no visible impact currently.
However, to restore consistency with the previous behavior and improve
clarity, replace bitwise operations with direct assignments and
comparisons for key flags.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-wireless/aLlaetkalDvWcB7b@stanley.mountain
Fixes: 97acb0259cc9 ("wifi: ath11k: fix group data packet drops during rekey")
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251003092158.1080637-1-rameshkumar.sundaram@oss.qualcomm.com
[update copyright per current guidance]
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 3889f08822d41..419c9497800af 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <net/mac80211.h>
@@ -4407,9 +4407,9 @@ static int ath11k_mac_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 
 	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
-		flags |= WMI_KEY_PAIRWISE;
+		flags = WMI_KEY_PAIRWISE;
 	else
-		flags |= WMI_KEY_GROUP;
+		flags = WMI_KEY_GROUP;
 
 	ath11k_dbg(ar->ab, ATH11K_DBG_MAC,
 		   "%s for peer %pM on vdev %d flags 0x%X, type = %d, num_sta %d\n",
@@ -4446,7 +4446,7 @@ static int ath11k_mac_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	is_ap_with_no_sta = (vif->type == NL80211_IFTYPE_AP &&
 			     !arvif->num_stations);
-	if ((flags & WMI_KEY_PAIRWISE) || cmd == SET_KEY || is_ap_with_no_sta) {
+	if (flags == WMI_KEY_PAIRWISE || cmd == SET_KEY || is_ap_with_no_sta) {
 		ret = ath11k_install_key(arvif, key, cmd, peer_addr, flags);
 		if (ret) {
 			ath11k_warn(ab, "ath11k_install_key failed (%d)\n", ret);
@@ -4460,7 +4460,7 @@ static int ath11k_mac_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			goto exit;
 		}
 
-		if ((flags & WMI_KEY_GROUP) && cmd == SET_KEY && is_ap_with_no_sta)
+		if (flags == WMI_KEY_GROUP && cmd == SET_KEY && is_ap_with_no_sta)
 			arvif->reinstall_group_keys = true;
 	}
 
-- 
2.51.0



