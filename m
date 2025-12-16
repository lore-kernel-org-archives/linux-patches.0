Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE9D34F250;
	Tue, 16 Dec 2025 12:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887222; cv=none; b=gzNJG4v6hJziPriwuCfov1lgkEIaJ1zEF1+wqfhbAW0jG0h+5Linkz//bxQ1fT/EwG6pXFUyYlgs8qmXopC+c4I0ET0fQMGhNvyxpnxfxRMBu4fXHR+Y+WKebWKlF9ZFaRcAYVFTvCKHzSBXTGKq9A2wsq0KdvVWvmyYs+2DXZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887222; c=relaxed/simple;
	bh=BFg1+nRWeYzKjq81wm7C7Rg4TkA13rnPigBIGNCrmh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4sZKM1kmUAALOsqlA/mS40YJ1mwJyUPMz1BJ2kZ7eLC+X3RhuYXBpsCuSUZcliOCqIMzCI3Lpxst6hDIsRCktPqcUfUovAg3Tr7gnYkYeua+94jF9I68DDrYZDVFFNRIjmVjKeNDXpT3HeuVRy8KBSb2oYHp9KbSkJOQsh0B0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGla1tgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGla1tgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBDFC4CEF1;
	Tue, 16 Dec 2025 12:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887221;
	bh=BFg1+nRWeYzKjq81wm7C7Rg4TkA13rnPigBIGNCrmh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGla1tgw2T4TTL6NQgrdnyCCPKzeI9XYVTFuHg6Hd7B2f68rCwBx9ZKX8M9SPlEHW
	 8PoZuhYYSTRvlYiwB/uD9zFfmoOipn7bRyRlEcvJwGxx+I9uZwIQ6exhefTc94PMul
	 PujJXCBx7uAlw5lYiuUfOkRgrloJHYskVqnmP+cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/614] wifi: ath12k: enforce vdev limit in ath12k_mac_vdev_create()
Date: Tue, 16 Dec 2025 12:08:50 +0100
Message-ID: <20251216111407.242056923@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

[ Upstream commit 448bf7b51426bcca54b5ac1ddd1045a36c9d1dea ]

Currently, vdev limit check is performed only in
ath12k_mac_assign_vif_to_vdev(). If the host has already created
maximum number of vdevs for the radio (ar) and a scan request
arrives for the same radio, ath12k_mac_initiate_hw_scan() attempts
to create a vdev without checking the limit, causing firmware asserts.

Centralize the vdev limit guard by moving the check into
ath12k_mac_vdev_create() so that all callers obey the limit.
While doing this, update the condition from
`num_created_vdevs > (TARGET_NUM_VDEVS(ab) - 1)` to
`num_created_vdevs >= TARGET_NUM_VDEVS(ab)` for clarity and to
eliminate unnecessary arithmetic.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: 0d6e6736ed9f ("wifi: ath12k: scan statemachine changes for single wiphy")
Fixes: 4938ba733ee2 ("wifi: ath12k: modify remain on channel for single wiphy")
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251026182254.1399650-2-rameshkumar.sundaram@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 0cec6c47fca29..8f139505019c4 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9687,6 +9687,12 @@ int ath12k_mac_vdev_create(struct ath12k *ar, struct ath12k_link_vif *arvif)
 	if (vif->type == NL80211_IFTYPE_MONITOR && ar->monitor_vdev_created)
 		return -EINVAL;
 
+	if (ar->num_created_vdevs >= TARGET_NUM_VDEVS(ab)) {
+		ath12k_warn(ab, "failed to create vdev, reached max vdev limit %d\n",
+			    TARGET_NUM_VDEVS(ab));
+		return -ENOSPC;
+	}
+
 	link_id = arvif->link_id;
 
 	if (link_id < IEEE80211_MLD_MAX_NUM_LINKS) {
@@ -10046,12 +10052,6 @@ static struct ath12k *ath12k_mac_assign_vif_to_vdev(struct ieee80211_hw *hw,
 	if (arvif->is_created)
 		goto flush;
 
-	if (ar->num_created_vdevs > (TARGET_NUM_VDEVS(ab) - 1)) {
-		ath12k_warn(ab, "failed to create vdev, reached max vdev limit %d\n",
-			    TARGET_NUM_VDEVS(ab));
-		goto unlock;
-	}
-
 	ret = ath12k_mac_vdev_create(ar, arvif);
 	if (ret) {
 		ath12k_warn(ab, "failed to create vdev %pM ret %d", vif->addr, ret);
-- 
2.51.0



