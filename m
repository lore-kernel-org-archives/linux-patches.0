Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E852F290C;
	Fri, 10 Oct 2025 13:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102359; cv=none; b=KG2HCdWmATK/PrnAjhfw55ipXguYyJOrkRPOoE5K/SIuHDfCHzHzpb0Bke/DFNEX4u3/T7tru8MLCj6UtOXSjlW4ooGWFpnC1okcB8VOhxefGxGtQN+0+8p1h+HA57X3re7ypZ8Rnl5creyTHelJwi40sNNnVK7RfV8+Gbq1F1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102359; c=relaxed/simple;
	bh=V/XJScL6AOsC/noTDEs1STRFK5bDdweq8aKApXEBNZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOOYgWgC6gYiFEnisd3Oi31VqEqs3qqJ93qwJ4mYL7nvIW5U7ynorgNR/DwyXtX66F2iNp9yAK/j0F4JZlQcCVH8WSUt8JqKq6sa4pBEasGcVTimfeGLr4PaeMcPvEjpQbjqqnt/EDgDRVUuxN01lQol/WHFjp+cAdptRl4QnMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbeCJgd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbeCJgd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A201FC4CEF1;
	Fri, 10 Oct 2025 13:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102359;
	bh=V/XJScL6AOsC/noTDEs1STRFK5bDdweq8aKApXEBNZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbeCJgd4juzuwEanCQZcfkRO+qVF0MOoaVrsnPx4XYpBTHXCRwO8/l2XoQnBdZs3L
	 rX6crSsliulK/obPT+5ZuuE15BMOhx5xabcgrL4IivWpKqnn5/7sNcT3LGvdApO8yV
	 v9Cw8UdXpkKN3t5jplzaDC8J1TyGxcJZKZ+O+D4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 03/41] wifi: rtw89: mcc: stop TX during MCC prepare
Date: Fri, 10 Oct 2025 15:15:51 +0200
Message-ID: <20251010131333.546980346@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 182c7ff8b87e4edbb2227ede39ae0952da7a0f4a ]

Stop TX during the MCC configuration period to prevent packet leakage.
The stop time is defined as 'start_tsf - tsf', which means the duration
from when MCC configuration begins until MCC starts.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250610130034.14692-6-pkshih@realtek.com
Stable-dep-of: 3e31a6bc0731 ("wifi: rtw89: fix use-after-free in rtw89_core_tx_kick_off_and_wait()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/chan.c |   35 ++++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/chan.h |    2 +
 drivers/net/wireless/realtek/rtw89/core.c |    2 +
 drivers/net/wireless/realtek/rtw89/core.h |    2 +
 4 files changed, 41 insertions(+)

--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -1595,6 +1595,35 @@ static bool rtw89_mcc_duration_decision_
 	return false;
 }
 
+void rtw89_mcc_prepare_done_work(struct wiphy *wiphy, struct wiphy_work *work)
+{
+	struct rtw89_dev *rtwdev = container_of(work, struct rtw89_dev,
+						mcc_prepare_done_work.work);
+
+	lockdep_assert_wiphy(wiphy);
+
+	ieee80211_wake_queues(rtwdev->hw);
+}
+
+static void rtw89_mcc_prepare(struct rtw89_dev *rtwdev, bool start)
+{
+	struct rtw89_mcc_info *mcc = &rtwdev->mcc;
+	struct rtw89_mcc_config *config = &mcc->config;
+
+	if (start) {
+		ieee80211_stop_queues(rtwdev->hw);
+
+		wiphy_delayed_work_queue(rtwdev->hw->wiphy,
+					 &rtwdev->mcc_prepare_done_work,
+					 usecs_to_jiffies(config->prepare_delay));
+	} else {
+		wiphy_delayed_work_queue(rtwdev->hw->wiphy,
+					 &rtwdev->mcc_prepare_done_work, 0);
+		wiphy_delayed_work_flush(rtwdev->hw->wiphy,
+					 &rtwdev->mcc_prepare_done_work);
+	}
+}
+
 static int rtw89_mcc_fill_start_tsf(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_mcc_info *mcc = &rtwdev->mcc;
@@ -1630,6 +1659,8 @@ static int rtw89_mcc_fill_start_tsf(stru
 
 	config->start_tsf = start_tsf;
 	config->start_tsf_in_aux_domain = tsf_aux + start_tsf - tsf;
+	config->prepare_delay = start_tsf - tsf;
+
 	return 0;
 }
 
@@ -2219,6 +2250,8 @@ static int rtw89_mcc_start(struct rtw89_
 	rtw89_chanctx_notify(rtwdev, RTW89_CHANCTX_STATE_MCC_START);
 
 	rtw89_mcc_start_beacon_noa(rtwdev);
+
+	rtw89_mcc_prepare(rtwdev, true);
 	return 0;
 }
 
@@ -2307,6 +2340,8 @@ static void rtw89_mcc_stop(struct rtw89_
 	rtw89_chanctx_notify(rtwdev, RTW89_CHANCTX_STATE_MCC_STOP);
 
 	rtw89_mcc_stop_beacon_noa(rtwdev);
+
+	rtw89_mcc_prepare(rtwdev, false);
 }
 
 static int rtw89_mcc_update(struct rtw89_dev *rtwdev)
--- a/drivers/net/wireless/realtek/rtw89/chan.h
+++ b/drivers/net/wireless/realtek/rtw89/chan.h
@@ -129,6 +129,8 @@ const struct rtw89_chan *__rtw89_mgnt_ch
 #define rtw89_mgnt_chan_get(rtwdev, link_index) \
 	__rtw89_mgnt_chan_get(rtwdev, __func__, link_index)
 
+void rtw89_mcc_prepare_done_work(struct wiphy *wiphy, struct wiphy_work *work);
+
 int rtw89_chanctx_ops_add(struct rtw89_dev *rtwdev,
 			  struct ieee80211_chanctx_conf *ctx);
 void rtw89_chanctx_ops_remove(struct rtw89_dev *rtwdev,
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4816,6 +4816,7 @@ void rtw89_core_stop(struct rtw89_dev *r
 	wiphy_delayed_work_cancel(wiphy, &rtwdev->coex_bt_devinfo_work);
 	wiphy_delayed_work_cancel(wiphy, &rtwdev->coex_rfk_chk_work);
 	wiphy_delayed_work_cancel(wiphy, &rtwdev->cfo_track_work);
+	wiphy_delayed_work_cancel(wiphy, &rtwdev->mcc_prepare_done_work);
 	cancel_delayed_work_sync(&rtwdev->forbid_ba_work);
 	wiphy_delayed_work_cancel(wiphy, &rtwdev->antdiv_work);
 
@@ -5042,6 +5043,7 @@ int rtw89_core_init(struct rtw89_dev *rt
 	wiphy_delayed_work_init(&rtwdev->coex_bt_devinfo_work, rtw89_coex_bt_devinfo_work);
 	wiphy_delayed_work_init(&rtwdev->coex_rfk_chk_work, rtw89_coex_rfk_chk_work);
 	wiphy_delayed_work_init(&rtwdev->cfo_track_work, rtw89_phy_cfo_track_work);
+	wiphy_delayed_work_init(&rtwdev->mcc_prepare_done_work, rtw89_mcc_prepare_done_work);
 	INIT_DELAYED_WORK(&rtwdev->forbid_ba_work, rtw89_forbid_ba_work);
 	wiphy_delayed_work_init(&rtwdev->antdiv_work, rtw89_phy_antdiv_work);
 	rtwdev->txq_wq = alloc_workqueue("rtw89_tx_wq", WQ_UNBOUND | WQ_HIGHPRI, 0);
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5728,6 +5728,7 @@ struct rtw89_mcc_config {
 	struct rtw89_mcc_sync sync;
 	u64 start_tsf;
 	u64 start_tsf_in_aux_domain;
+	u64 prepare_delay;
 	u16 mcc_interval; /* TU */
 	u16 beacon_offset; /* TU */
 };
@@ -5858,6 +5859,7 @@ struct rtw89_dev {
 	struct wiphy_delayed_work coex_bt_devinfo_work;
 	struct wiphy_delayed_work coex_rfk_chk_work;
 	struct wiphy_delayed_work cfo_track_work;
+	struct wiphy_delayed_work mcc_prepare_done_work;
 	struct delayed_work forbid_ba_work;
 	struct wiphy_delayed_work antdiv_work;
 	struct rtw89_ppdu_sts_info ppdu_sts;


