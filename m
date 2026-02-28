Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748B93E9F93
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301089; cv=none; b=f/uyqTvS8RErPHc/a5/7+olOzUoeQ4beFX5bDZOpotv4qKdT1Cy5KI2+tl33ps8XiLqil+2wgy/MX+1CsobvVTS0WO28owzEMaPNo1bzMM7NiCylK4HAcBQhVI4biKgHcCkjI8gGO/F7NK2alh8lSDy9+B2NOmcR+3AXdPfqZNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301089; c=relaxed/simple;
	bh=CgdJkVn+mWXtfvFOcJ9EKUqPHf17hvlYvkTrqvxh6AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHXIMqRDf6D7geQ15iOfh+KvvSiNG/kKyEUZ0SvLliTYtS6S8v44TOMe78YkBwXgaWHKIkWBHMKw0UmvNNjEEVeoVKmFdi+UlkxwOyuXC8zKoOrnjXaE5TKHu1xHrMdh8dAB8YTS33UXj6jjm5xiqbSjx96ZRDuQ0yN5HuNCw1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PdyfyFAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PdyfyFAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED4FC19423;
	Sat, 28 Feb 2026 17:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301089;
	bh=CgdJkVn+mWXtfvFOcJ9EKUqPHf17hvlYvkTrqvxh6AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdyfyFAm/Vwc/Iqj1Vo1f5ld9IkvA07YgkIP9cRqTGkk7nya/o4bF0MX7kqAPpMeU
	 2xEEgI+AhA2NACAtps20xo4rK2XRuY214nSYvG0sgrpPHI1cTm9LorDsejnG1oXyu1
	 A/veame6FJCgtTmQlpYdcoyoltwuK5rK/Co/rfUU/I9bVylVBFEewcxr4oEvm6XyV8
	 VRi/YfaRIDZuaJJNCBMkbC/55s/s/DURNnPN3fMnkkUTDDmrsIs/Vk9EegPaLJbQl6
	 kYeZWXiQQ9qqZf+42OiE7KrjBu80cXWZkWNzSrsyo3Q/lGoPIa47Uu+QSiWGv3NDBV
	 SUiP+nw4qrSjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Qian Zhang <qian.zhang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 239/752] wifi: ath11k: Fix failure to connect to a 6 GHz AP
Date: Sat, 28 Feb 2026 12:39:10 -0500
Message-ID: <20260228174750.1542406-239-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Qian Zhang <qian.zhang@oss.qualcomm.com>

[ Upstream commit 0bc8c48de6f06c0cac52dde024ffda4433de6234 ]

STA fails to connect to a 6 GHz AP with the following errors:
 ath11k_pci 0000:01:00.0: failed to handle chan list with power type 1
 wlp1s0: deauthenticating from c8:a3:e8:dd:41:e3 by local choice (Reason: 3=DEAUTH_LEAVING)

ath11k_reg_handle_chan_list() treats the update as redundant and
returns -EINVAL. That causes the connection attempt to fail.

Avoid unnecessary validation during association. Apply the regulatory
redundant check only when the power type is IEEE80211_REG_UNSET_AP,
which only occurs during core initialization.

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

Signed-off-by: Qian Zhang <qian.zhang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260108034607.812885-1-qian.zhang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/reg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index d62a2014315a0..49b79648752cf 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 #include <linux/rtnetlink.h>
 
@@ -926,8 +926,11 @@ int ath11k_reg_handle_chan_list(struct ath11k_base *ab,
 	 */
 	if (ab->default_regd[pdev_idx] && !ab->new_regd[pdev_idx] &&
 	    !memcmp((char *)ab->default_regd[pdev_idx]->alpha2,
-		    (char *)reg_info->alpha2, 2))
-		goto retfail;
+		    (char *)reg_info->alpha2, 2) &&
+	    power_type == IEEE80211_REG_UNSET_AP) {
+		ath11k_reg_reset_info(reg_info);
+		return 0;
+	}
 
 	/* Intersect new rules with default regd if a new country setting was
 	 * requested, i.e a default regd was already set during initialization
-- 
2.51.0

