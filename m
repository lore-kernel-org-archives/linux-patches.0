Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A565B1549A
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03789C433EF;
	Mon, 12 Jun 2023 10:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567119;
	bh=lMiMx5ITgFTg7Q7Ry/OBwKW9DOHE4UBKv6ncNMyHBKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8NYlXf6fLUTHElz3dO7m8ybe1juPV1n/RRq7t/8Vvnw7Ne6eWqZO+nm03oQlVasU
	 XjzP0YNe+89zkPASVchRRj+EoFFeEYMU15gUJvvFAMH/JBSK3XpjTverOHKurCb+lf
	 /E7hw6oNQqwGwq8aZSUHLuwP80ABP3QoEhUUf8z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.3 158/160] wifi: rtw89: correct PS calculation for SUPPORTS_DYNAMIC_PS
Date: Mon, 12 Jun 2023 12:28:10 +0200
Message-ID: <20230612101722.312844003@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ping-Ke Shih <pkshih@realtek.com>

commit 26a125f550a3bf86ac91d38752f4d446426dfe1c upstream.

This driver relies on IEEE80211_CONF_PS of hw->conf.flags to turn off PS or
turn on dynamic PS controlled by driver and firmware. Though this would be
incorrect, it did work before because the flag is always recalculated until
the commit 28977e790b5d ("wifi: mac80211: skip powersave recalc if driver SUPPORTS_DYNAMIC_PS")
is introduced by kernel 5.20 to skip to recalculate IEEE80211_CONF_PS
of hw->conf.flags if driver sets SUPPORTS_DYNAMIC_PS.

Correct this by doing recalculation while BSS_CHANGED_PS is changed and
interface is added or removed. For now, it is allowed to enter PS only if
single one station vif is working, and it could possible to have PS per
vif after firmware can support it. Without this fix, driver doesn't
enter PS anymore that causes higher power consumption.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230527082939.11206-3-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c |   16 +++++++---------
 drivers/net/wireless/realtek/rtw89/ps.c       |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/ps.h       |    1 +
 3 files changed, 34 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -79,15 +79,6 @@ static int rtw89_ops_config(struct ieee8
 	    !(hw->conf.flags & IEEE80211_CONF_IDLE))
 		rtw89_leave_ips(rtwdev);
 
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		if (hw->conf.flags & IEEE80211_CONF_PS) {
-			rtwdev->lps_enabled = true;
-		} else {
-			rtw89_leave_lps(rtwdev);
-			rtwdev->lps_enabled = false;
-		}
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		rtw89_config_entity_chandef(rtwdev, RTW89_SUB_ENTITY_0,
 					    &hw->conf.chandef);
@@ -147,6 +138,8 @@ static int rtw89_ops_add_interface(struc
 	rtw89_core_txq_init(rtwdev, vif->txq);
 
 	rtw89_btc_ntfy_role_info(rtwdev, rtwvif, NULL, BTC_ROLE_START);
+
+	rtw89_recalc_lps(rtwdev);
 out:
 	mutex_unlock(&rtwdev->mutex);
 
@@ -170,6 +163,8 @@ static void rtw89_ops_remove_interface(s
 	rtw89_mac_remove_vif(rtwdev, rtwvif);
 	rtw89_core_release_bit_map(rtwdev->hw_port, rtwvif->port);
 	list_del_init(&rtwvif->list);
+	rtw89_recalc_lps(rtwdev);
+
 	mutex_unlock(&rtwdev->mutex);
 }
 
@@ -425,6 +420,9 @@ static void rtw89_ops_bss_info_changed(s
 	if (changed & BSS_CHANGED_P2P_PS)
 		rtw89_process_p2p_ps(rtwdev, vif);
 
+	if (changed & BSS_CHANGED_PS)
+		rtw89_recalc_lps(rtwdev);
+
 	mutex_unlock(&rtwdev->mutex);
 }
 
--- a/drivers/net/wireless/realtek/rtw89/ps.c
+++ b/drivers/net/wireless/realtek/rtw89/ps.c
@@ -244,3 +244,29 @@ void rtw89_process_p2p_ps(struct rtw89_d
 	rtw89_p2p_disable_all_noa(rtwdev, vif);
 	rtw89_p2p_update_noa(rtwdev, vif);
 }
+
+void rtw89_recalc_lps(struct rtw89_dev *rtwdev)
+{
+	struct ieee80211_vif *vif, *found_vif = NULL;
+	struct rtw89_vif *rtwvif;
+	int count = 0;
+
+	rtw89_for_each_rtwvif(rtwdev, rtwvif) {
+		vif = rtwvif_to_vif(rtwvif);
+
+		if (vif->type != NL80211_IFTYPE_STATION) {
+			count = 0;
+			break;
+		}
+
+		count++;
+		found_vif = vif;
+	}
+
+	if (count == 1 && found_vif->cfg.ps) {
+		rtwdev->lps_enabled = true;
+	} else {
+		rtw89_leave_lps(rtwdev);
+		rtwdev->lps_enabled = false;
+	}
+}
--- a/drivers/net/wireless/realtek/rtw89/ps.h
+++ b/drivers/net/wireless/realtek/rtw89/ps.h
@@ -14,5 +14,6 @@ void rtw89_enter_ips(struct rtw89_dev *r
 void rtw89_leave_ips(struct rtw89_dev *rtwdev);
 void rtw89_set_coex_ctrl_lps(struct rtw89_dev *rtwdev, bool btc_ctrl);
 void rtw89_process_p2p_ps(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif);
+void rtw89_recalc_lps(struct rtw89_dev *rtwdev);
 
 #endif


