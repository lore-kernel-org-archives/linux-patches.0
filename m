Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CB0522A;
	Wed,  5 Feb 2025 14:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765188; cv=none; b=nPDEn/c2e7BYAvLMqAZgkW92ZND1teXlJK+WTEqOQS23LjQtZDZG5KTFNbCT0Wcy9RLGqwUagptLVfzpDGLoAbHgRXmUG9IGZDdJWPEB7abxgZS7U5jLeeBZi5wQqXx1ZlI0xbddi3XxVeB7B0HQWKTFbeZL3Y3kDZ45qaRPQT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765188; c=relaxed/simple;
	bh=Pzuw56eTaD55ijrOD6WxKEiiMHwhmCWUIH84t66yz+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqVmh99qfOudlpqM80uNKFf3T5XEmx979azoxtVSkg5qandaCUe3Y54LKnX3K7FE6sOGOUsPQC692XorWvBK1ZqbT/EkJmRjW3Xy/y5na2w5UDBvd8qgrDipPcGdE3s0U9e6ZkpsrV3jSPwb0mKEOyiMyRN+COu3npCbLHMXvhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+YsI+iY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+YsI+iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D7CC4CED1;
	Wed,  5 Feb 2025 14:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765187;
	bh=Pzuw56eTaD55ijrOD6WxKEiiMHwhmCWUIH84t66yz+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+YsI+iYSwo4Z2NS7GJ9h2aZKOPhJAozqOOT9wEPpPpcQUFrFShqVSTSk5f6jiyB1
	 oHG34elB7HMKJu5tL5daUSPOnk/snslX0hiLGbNaS/tUMw3jeiPHo7Xb8jlQR45QBv
	 k0rb6GbSc5OmKCW3b1BzFTD2J8ewAbu9tNdlyDKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 154/623] wifi: rtw89: fix proceeding MCC with wrong scanning state after sequence changes
Date: Wed,  5 Feb 2025 14:38:16 +0100
Message-ID: <20250205134502.127647940@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit e47f0a5898540eb19b953708707887d4b3020645 ]

When starting/proceeding MCC, it will abort an ongoing hw scan process.
In the proceeding cases, it unexpectedly tries to abort a non-exist hw
scan process. Then, a trace shown at the bottom will happen. This problem
is caused by a previous commit which changed some call sequence inside
rtw89_hw_scan_complete() to fix some coex problems. These changes lead
to our scanning flag was not cleared when proceeding MCC. To keep the
fixes on coex, and resolve the problem here, re-consider the related
call sequence.

The known sequence requirements are listed below.

* the old sequence:
	A. notify coex
	B. clear scanning flag
	C. proceed chanctx
		C-1. set channel
		C-2. proceed MCC
(the problem: A needs to be after C-1)

* the current sequence:
	C. proceed chanctx
		C-1. set channel
		C-2. proceed MCC
	A. notify coex
	B. clear scanning flag
(the problem: C-2 needs to be after B)

So, now let hw scan caller pass a callback to proceed chanctx if needed.
Then, the new sequence will be like the below.
	C-1. set channel
	A. notify coex
	B. clear scanning flag
	C-2. proceed MCC

The following is the kernel log for the problem in current sequence.

rtw89_8852be 0000:04:00.0: rtw89_hw_scan_offload failed ret -110
------------[ cut here ]------------
[...]
CPU: 2 PID: 3991 Comm: kworker/u16:0 Tainted: G           OE      6.6.17 #3
Hardware name: LENOVO 2356AD1/2356AD1, BIOS G7ETB3WW (2.73 ) 11/28/2018
Workqueue: events_unbound wiphy_work_cancel [cfg80211]
RIP: 0010:ieee80211_sched_scan_stopped+0xaea/0xd80 [mac80211]
Code: 9c 24 d0 11 00 00 49 39 dd 0f 85 46 ff ff ff 4c 89 e7 e8 09 2d
RSP: 0018:ffffb27783643d48 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8a2280964bc0 RSI: 0000000000000000 RDI: ffff8a23df580900
RBP: ffffb27783643d88 R08: 0000000000000001 R09: 0000000000000400
R10: 0000000000000000 R11: 0000000000008268 R12: ffff8a23df580900
R13: ffff8a23df581b00 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a258e680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f26a0654000 CR3: 000000002ea2e002 CR4: 00000000001706e0
Call Trace:
 <TASK>
 ? show_regs+0x68/0x70
 ? ieee80211_sched_scan_stopped+0xaea/0xd80 [mac80211]
 ? __warn+0x8f/0x150
 ? ieee80211_sched_scan_stopped+0xaea/0xd80 [mac80211]
 ? report_bug+0x1f5/0x200
 ? handle_bug+0x46/0x80
 ? exc_invalid_op+0x19/0x70
 ? asm_exc_invalid_op+0x1b/0x20
 ? ieee80211_sched_scan_stopped+0xaea/0xd80 [mac80211]
 ieee80211_scan_work+0x14a/0x650 [mac80211]
 ? __queue_work+0x10f/0x410
 wiphy_work_cancel+0x2fb/0x310 [cfg80211]
 process_scheduled_works+0x9d/0x390
 ? __pfx_worker_thread+0x10/0x10
 worker_thread+0x15b/0x2d0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x108/0x140
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x3c/0x60
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>
---[ end trace 0000000000000000 ]---

Fixes: f16c40acd319 ("wifi: rtw89: Fix TX fail with A2DP after scanning")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241231004811.8646-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/chan.c | 26 +++++++++++++--
 drivers/net/wireless/realtek/rtw89/chan.h |  9 ++++-
 drivers/net/wireless/realtek/rtw89/core.c |  2 +-
 drivers/net/wireless/realtek/rtw89/fw.c   | 40 +++++++++++++++++++----
 4 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index fb9449930c40a..abc78716596d0 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -2530,7 +2530,25 @@ void rtw89_chanctx_pause(struct rtw89_dev *rtwdev,
 	hal->entity_pause = true;
 }
 
-void rtw89_chanctx_proceed(struct rtw89_dev *rtwdev)
+static void rtw89_chanctx_proceed_cb(struct rtw89_dev *rtwdev,
+				     const struct rtw89_chanctx_cb_parm *parm)
+{
+	int ret;
+
+	if (!parm || !parm->cb)
+		return;
+
+	ret = parm->cb(rtwdev, parm->data);
+	if (ret)
+		rtw89_warn(rtwdev, "%s (%s): cb failed: %d\n", __func__,
+			   parm->caller ?: "unknown", ret);
+}
+
+/* pass @cb_parm if there is a @cb_parm->cb which needs to invoke right after
+ * call rtw89_set_channel() and right before proceed entity according to mode.
+ */
+void rtw89_chanctx_proceed(struct rtw89_dev *rtwdev,
+			   const struct rtw89_chanctx_cb_parm *cb_parm)
 {
 	struct rtw89_hal *hal = &rtwdev->hal;
 	enum rtw89_entity_mode mode;
@@ -2538,14 +2556,18 @@ void rtw89_chanctx_proceed(struct rtw89_dev *rtwdev)
 
 	lockdep_assert_held(&rtwdev->mutex);
 
-	if (!hal->entity_pause)
+	if (unlikely(!hal->entity_pause)) {
+		rtw89_chanctx_proceed_cb(rtwdev, cb_parm);
 		return;
+	}
 
 	rtw89_debug(rtwdev, RTW89_DBG_CHAN, "chanctx proceed\n");
 
 	hal->entity_pause = false;
 	rtw89_set_channel(rtwdev);
 
+	rtw89_chanctx_proceed_cb(rtwdev, cb_parm);
+
 	mode = rtw89_get_entity_mode(rtwdev);
 	switch (mode) {
 	case RTW89_ENTITY_MODE_MCC:
diff --git a/drivers/net/wireless/realtek/rtw89/chan.h b/drivers/net/wireless/realtek/rtw89/chan.h
index 2eb31dff20831..092a6f676894f 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.h
+++ b/drivers/net/wireless/realtek/rtw89/chan.h
@@ -38,6 +38,12 @@ enum rtw89_chanctx_pause_reasons {
 	RTW89_CHANCTX_PAUSE_REASON_ROC,
 };
 
+struct rtw89_chanctx_cb_parm {
+	int (*cb)(struct rtw89_dev *rtwdev, void *data);
+	void *data;
+	const char *caller;
+};
+
 struct rtw89_entity_weight {
 	unsigned int active_chanctxs;
 	unsigned int active_roles;
@@ -100,7 +106,8 @@ void rtw89_queue_chanctx_change(struct rtw89_dev *rtwdev,
 void rtw89_chanctx_track(struct rtw89_dev *rtwdev);
 void rtw89_chanctx_pause(struct rtw89_dev *rtwdev,
 			 enum rtw89_chanctx_pause_reasons rsn);
-void rtw89_chanctx_proceed(struct rtw89_dev *rtwdev);
+void rtw89_chanctx_proceed(struct rtw89_dev *rtwdev,
+			   const struct rtw89_chanctx_cb_parm *cb_parm);
 
 const struct rtw89_chan *__rtw89_mgnt_chan_get(struct rtw89_dev *rtwdev,
 					       const char *caller_message,
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index e5b2968c1431f..a524c3d06aeb2 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3257,7 +3257,7 @@ void rtw89_roc_end(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 
 	roc->state = RTW89_ROC_IDLE;
 	rtw89_config_roc_chandef(rtwdev, rtwvif_link->chanctx_idx, NULL);
-	rtw89_chanctx_proceed(rtwdev);
+	rtw89_chanctx_proceed(rtwdev, NULL);
 	ret = rtw89_core_send_nullfunc(rtwdev, rtwvif_link, true, false);
 	if (ret)
 		rtw89_debug(rtwdev, RTW89_DBG_TXRX,
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 2191c037d72e4..9146a7e1ed66a 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6780,22 +6780,25 @@ void rtw89_hw_scan_start(struct rtw89_dev *rtwdev,
 	rtw89_chanctx_pause(rtwdev, RTW89_CHANCTX_PAUSE_REASON_HW_SCAN);
 }
 
-void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev,
-			    struct rtw89_vif_link *rtwvif_link,
-			    bool aborted)
+struct rtw89_hw_scan_complete_cb_data {
+	struct rtw89_vif_link *rtwvif_link;
+	bool aborted;
+};
+
+static int rtw89_hw_scan_complete_cb(struct rtw89_dev *rtwdev, void *data)
 {
 	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
 	struct rtw89_hw_scan_info *scan_info = &rtwdev->scan_info;
+	struct rtw89_hw_scan_complete_cb_data *cb_data = data;
+	struct rtw89_vif_link *rtwvif_link = cb_data->rtwvif_link;
 	struct cfg80211_scan_info info = {
-		.aborted = aborted,
+		.aborted = cb_data->aborted,
 	};
 	struct rtw89_vif *rtwvif;
 	u32 reg;
 
 	if (!rtwvif_link)
-		return;
-
-	rtw89_chanctx_proceed(rtwdev);
+		return -EINVAL;
 
 	rtwvif = rtwvif_link->rtwvif;
 
@@ -6814,6 +6817,29 @@ void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev,
 	scan_info->last_chan_idx = 0;
 	scan_info->scanning_vif = NULL;
 	scan_info->abort = false;
+
+	return 0;
+}
+
+void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev,
+			    struct rtw89_vif_link *rtwvif_link,
+			    bool aborted)
+{
+	struct rtw89_hw_scan_complete_cb_data cb_data = {
+		.rtwvif_link = rtwvif_link,
+		.aborted = aborted,
+	};
+	const struct rtw89_chanctx_cb_parm cb_parm = {
+		.cb = rtw89_hw_scan_complete_cb,
+		.data = &cb_data,
+		.caller = __func__,
+	};
+
+	/* The things here needs to be done after setting channel (for coex)
+	 * and before proceeding entity mode (for MCC). So, pass a callback
+	 * of them for the right sequence rather than doing them directly.
+	 */
+	rtw89_chanctx_proceed(rtwdev, &cb_parm);
 }
 
 void rtw89_hw_scan_abort(struct rtw89_dev *rtwdev,
-- 
2.39.5



