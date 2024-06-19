Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014B9146016;
	Wed, 19 Jun 2024 13:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802677; cv=none; b=XLxjy5CHvkC+kuG25/TNxxXg2VOO/yvLONoU6bNhcGpTH4wVns1Onn/gW4WMGi1E38xoEM5RehHfUlEmGNPIA7melAHUM5QexINccn8xSEewvpfcEIVvAuheA0EO2AXBJg1zIFwE/kr74pup+5mkM/+iYWqh+MaZsuvbJQsTDyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802677; c=relaxed/simple;
	bh=D+llCH6L9lCFkxQt13Xcpckh4NbnvpfGvl+xLBVVn04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=We/rKO5D9aCdU7cl8DxDQo++8VbPcf+6HdD2rWsnopl2fPwkj6+3h1BkMHuG+Q5zLZd+gRahThlqA9dx/ZxE8KK5Z3p4E3fad7z6FjlS7TyePROWIk9yDAkwWb9mzEo1FpJ+HvfpEmyD1jvRA9o5/tLIL7tGv9rQb8NfszqxYFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eV3wi22o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eV3wi22o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728EDC2BBFC;
	Wed, 19 Jun 2024 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802676;
	bh=D+llCH6L9lCFkxQt13Xcpckh4NbnvpfGvl+xLBVVn04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eV3wi22oAn6PTtMn22UEjvnMeYyVSvhSx9Bb/50qDuF+d+bRm3GPw8Nh9Q0s6URDr
	 WgKaOccgEh7AKebTfXqHiNiivofo8DPyS+WjSSNfrbVOjDqxYbqdmYMr0BdoZq0B4b
	 qcr17MdgSjhX5xtXQ+Tequ2HBP+9vbWKE6K/muzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 002/281] wifi: ath11k: move power type check to ASSOC stage when connecting to 6 GHz AP
Date: Wed, 19 Jun 2024 14:52:41 +0200
Message-ID: <20240619125609.935225461@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 6e16782d6b4a724f9c9dcd49471219643593b60c ]

With commit bc8a0fac8677 ("wifi: mac80211: don't set bss_conf in parsing")
ath11k fails to connect to 6 GHz AP.

This is because currently ath11k checks AP's power type in
ath11k_mac_op_assign_vif_chanctx() which would be called in AUTH stage.
However with above commit power type is not available until ASSOC stage.
As a result power type check fails and therefore connection fails.

Fix this by moving power type check to ASSOC stage, also move regulatory
rules update there because it depends on power type.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Fixes: bc8a0fac8677 ("wifi: mac80211: don't set bss_conf in parsing")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240424064019.4847-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 38 ++++++++++++++++++---------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2fca415322aec..790277f547bb4 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -7889,8 +7889,6 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	struct ath11k_base *ab = ar->ab;
 	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
 	int ret;
-	struct cur_regulatory_info *reg_info;
-	enum ieee80211_ap_reg_power power_type;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -7901,17 +7899,6 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	if (ath11k_wmi_supports_6ghz_cc_ext(ar) &&
 	    ctx->def.chan->band == NL80211_BAND_6GHZ &&
 	    arvif->vdev_type == WMI_VDEV_TYPE_STA) {
-		reg_info = &ab->reg_info_store[ar->pdev_idx];
-		power_type = vif->bss_conf.power_type;
-
-		ath11k_dbg(ab, ATH11K_DBG_MAC, "chanctx power type %d\n", power_type);
-
-		if (power_type == IEEE80211_REG_UNSET_AP) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		ath11k_reg_handle_chan_list(ab, reg_info, power_type);
 		arvif->chanctx = *ctx;
 		ath11k_mac_parse_tx_pwr_env(ar, vif, ctx);
 	}
@@ -9525,6 +9512,8 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 	struct ath11k *ar = hw->priv;
 	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
 	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
+	enum ieee80211_ap_reg_power power_type;
+	struct cur_regulatory_info *reg_info;
 	struct ath11k_peer *peer;
 	int ret = 0;
 
@@ -9604,6 +9593,29 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 				ath11k_warn(ar->ab, "Unable to authorize peer %pM vdev %d: %d\n",
 					    sta->addr, arvif->vdev_id, ret);
 		}
+
+		if (!ret &&
+		    ath11k_wmi_supports_6ghz_cc_ext(ar) &&
+		    arvif->vdev_type == WMI_VDEV_TYPE_STA &&
+		    arvif->chanctx.def.chan &&
+		    arvif->chanctx.def.chan->band == NL80211_BAND_6GHZ) {
+			reg_info = &ar->ab->reg_info_store[ar->pdev_idx];
+			power_type = vif->bss_conf.power_type;
+
+			if (power_type == IEEE80211_REG_UNSET_AP) {
+				ath11k_warn(ar->ab, "invalid power type %d\n",
+					    power_type);
+				ret = -EINVAL;
+			} else {
+				ret = ath11k_reg_handle_chan_list(ar->ab,
+								  reg_info,
+								  power_type);
+				if (ret)
+					ath11k_warn(ar->ab,
+						    "failed to handle chan list with power type %d\n",
+						    power_type);
+			}
+		}
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
 		spin_lock_bh(&ar->ab->base_lock);
-- 
2.43.0



