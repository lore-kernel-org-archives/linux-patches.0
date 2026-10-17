Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23EF3515E7;
	Sat, 17 Oct 2026 16:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253322; cv=none; b=sdSe3L1xr7EgKibLD+1NajYhd1x0HkOHYSFYTCketskv+493oFBXfPLkop7ZJacAtXfijU5wMEtXDREczmJ0WyVCx71z7KVhX0V4jlU2i9md2i+KwKCewBijKZmfCWF/lumXGSOXSO8qvKkS9Jl/AH1puxJJOZHzQj6TDM8DH0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253322; c=relaxed/simple;
	bh=HsKJ6ekaJfTeaErUbdWKtQGps9p0wudwrLhKcTpUK8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQjzB3dVew35PqIDLLatiB6WetXioKJDkNSXuGlZ4QP0BQzvBStMVKWH9EZ271UEkKV2ujQDTMSU1HM0U8Qwpu2QX0cfu5Wa5UtxET0dfc3gqdNrlEe025M+jjq1X33WdPoivOd5VX8ztkTQt+pQUe3fPr/Ei4EOBKrWiqHNk5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1md5zSNM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1md5zSNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71FE1F000C4;
	Sat, 17 Oct 2026 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253321;
	bh=4Ror5KU6ACnhYwctO5rnLACBZJRr/LhO/2scaIVkbHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1md5zSNMcvcT8N8RYEuo8RtPOFaPnRbNY2V8flCdv6pyTeCf52A0+WYtzBXo5c4sP
	 0JNJYjeQKk+Ba2X1Smah4TPNR3Jb22DxswAEXJoyJ3ZUUTJX5tvhuBI3RFoj2gqkqz
	 OfE8PyvUMbe0JewEDM9K86832VbyJDAONXjU/K8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/869] wifi: ath12k: ath12k_mac_op_sta_state(): clean up update_wk cancellation
Date: Sat, 17 Oct 2026 17:48:42 +0200
Message-ID: <20261017160039.105001031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kalle Valo <quic_kvalo@quicinc.com>

[ Upstream commit e805272f8c2dee280e2fa1c1a454517df17f1261 ]

Now that we have switched to using wiphy_lock() there's no need to have
update_wk cancel call separately, for consistency move it to the rest of code
handling IEEE80211_STA_NONE state.

No functional changes.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20241007165932.78081-7-kvalo@kernel.org
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Stable-dep-of: c426497fa205 ("wifi: ath12k: Fix memory leak due to multiple rx_stats allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index e5d3cfade4e1f..f3785bc0f4c8e 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4583,11 +4583,6 @@ static int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 	struct ath12k_peer *peer;
 	int ret = 0;
 
-	/* cancel must be done outside the mutex to avoid deadlock */
-	if ((old_state == IEEE80211_STA_NONE &&
-	     new_state == IEEE80211_STA_NOTEXIST))
-		wiphy_work_cancel(hw->wiphy, &arsta->update_wk);
-
 	ar = ath12k_get_ar_by_vif(hw, vif);
 	if (!ar) {
 		WARN_ON_ONCE(1);
@@ -4608,6 +4603,8 @@ static int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 				    sta->addr, arvif->vdev_id);
 	} else if ((old_state == IEEE80211_STA_NONE &&
 		    new_state == IEEE80211_STA_NOTEXIST)) {
+		wiphy_work_cancel(hw->wiphy, &arsta->update_wk);
+
 		if (arvif->vdev_type == WMI_VDEV_TYPE_STA) {
 			ath12k_bss_disassoc(ar, arvif);
 			ret = ath12k_mac_vdev_stop(arvif);
-- 
2.53.0



