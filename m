Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F3E274B46;
	Sat, 12 Sep 2026 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224110; cv=none; b=lSv5cmoUU6kqSBGfS8Zhou0EOZtF0IWLbbaf/PhgMxzei6NQDXqUNcgG6hrtZ0e8GDV+vmEhPSwAMEawRomQ4fQLCDIvDMATobDDmdbfOcsc2mPBc8Sr53UVgNYc9g1sZ3Tm23IFrTQ8B6fBBEEILiVhNU7wguAuT+z7L5EOZw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224110; c=relaxed/simple;
	bh=Nul9sseF1OiGFVTULY3nibgjMW3iF1nN48wU76DfMNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZAFI1Pnu3gEs/J37qHLhtbDu4bSL3qrrTm3cVHM0JsHrzAofUKDUQEVXsINtVvD/CzhlJ2bWTEIZ5lklZKu2xljlaTOZTwcOPG74CtPVFkdhqB0TtKE3S4kfe9kiCKgR1sw/nqZkk9kSiYkanAeI3l9CzMjejJEtjcsP2LPOsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFjw2E+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFjw2E+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3F41F000FF;
	Sat, 12 Sep 2026 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224108;
	bh=HQSCka33/21mNKIWO4H93Yvsy5UWYlnfEaJuxbGzi0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFjw2E+cm+wRQTrzVWcuIZ0kL9Xd8pMzbXeer0NtQee3OJ5XzTsc0jdsTX1Tf/MUP
	 C4R6yqmnahTz4WChm/vBQoEPLI7iOOjWVMkmHTkmJtx67g6acGE48zDFUO6t3TLQ7U
	 aUp0IXIS7nkIcHFVtLd183NW614La6O+6ZvzoNc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0926/1424] wifi: ath11k: refactor ath11k_wmi_tlv_parse_alloc()
Date: Sat, 12 Sep 2026 08:55:58 +0200
Message-ID: <20260912065628.062249755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit f5e6c0c4b0877e0ec0221df6c0041c0f39b6ce0f ]

Since 'ath11k_wmi_tlv_parse_alloc()' always operates on
'skb->data, skb->len' tuple, it may be simplified to pass
the only 'skb' argument instead (which also implies
refactoring of 'ath11k_pull_bcn_tx_status_ev()' and
'ath11k_pull_chan_info_ev()' in the same way). Compile
tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20231214161117.75145-1-dmantipov@yandex.ru
Stable-dep-of: 208d7fdb8597 ("wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/testmode.c |  2 +-
 drivers/net/wireless/ath/ath11k/wmi.c      | 73 +++++++++++-----------
 drivers/net/wireless/ath/ath11k/wmi.h      |  4 +-
 3 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/testmode.c b/drivers/net/wireless/ath/ath11k/testmode.c
index b9f0ef458988c..7aa62a7d9a272 100644
--- a/drivers/net/wireless/ath/ath11k/testmode.c
+++ b/drivers/net/wireless/ath/ath11k/testmode.c
@@ -198,7 +198,7 @@ static void ath11k_tm_wmi_event_segmented(struct ath11k_base *ab, u32 cmd_id,
 	u16 length;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse ftm event tlv: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index aa6f89ccfeae4..538ac38aaf0bd 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -238,8 +238,8 @@ static int ath11k_wmi_tlv_parse(struct ath11k_base *ar, const void **tb,
 				   (void *)tb);
 }
 
-const void **ath11k_wmi_tlv_parse_alloc(struct ath11k_base *ab, const void *ptr,
-					size_t len, gfp_t gfp)
+const void **ath11k_wmi_tlv_parse_alloc(struct ath11k_base *ab,
+					struct sk_buff *skb, gfp_t gfp)
 {
 	const void **tb;
 	int ret;
@@ -248,7 +248,7 @@ const void **ath11k_wmi_tlv_parse_alloc(struct ath11k_base *ab, const void *ptr,
 	if (!tb)
 		return ERR_PTR(-ENOMEM);
 
-	ret = ath11k_wmi_tlv_parse(ab, tb, ptr, len);
+	ret = ath11k_wmi_tlv_parse(ab, tb, skb->data, skb->len);
 	if (ret) {
 		kfree(tb);
 		return ERR_PTR(ret);
@@ -3933,7 +3933,7 @@ ath11k_wmi_obss_color_collision_event(struct ath11k_base *ab, struct sk_buff *sk
 	struct ath11k_vif *arvif;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -5006,7 +5006,7 @@ static int ath11k_pull_vdev_start_resp_tlv(struct ath11k_base *ab, struct sk_buf
 	const struct wmi_vdev_start_resp_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -5105,7 +5105,7 @@ static int ath11k_pull_reg_chan_list_update_ev(struct ath11k_base *ab,
 
 	ath11k_dbg(ab, ATH11K_DBG_WMI, "processing regulatory channel list\n");
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -5281,7 +5281,7 @@ static int ath11k_pull_reg_chan_list_ext_update_ev(struct ath11k_base *ab,
 
 	ath11k_dbg(ab, ATH11K_DBG_WMI, "processing regulatory ext channel list\n");
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -5636,7 +5636,7 @@ static int ath11k_pull_peer_del_resp_ev(struct ath11k_base *ab, struct sk_buff *
 	const struct wmi_peer_delete_resp_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -5668,7 +5668,7 @@ static int ath11k_pull_vdev_del_resp_ev(struct ath11k_base *ab,
 	const struct wmi_vdev_delete_resp_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -5688,15 +5688,15 @@ static int ath11k_pull_vdev_del_resp_ev(struct ath11k_base *ab,
 	return 0;
 }
 
-static int ath11k_pull_bcn_tx_status_ev(struct ath11k_base *ab, void *evt_buf,
-					u32 len, u32 *vdev_id,
-					u32 *tx_status)
+static int ath11k_pull_bcn_tx_status_ev(struct ath11k_base *ab,
+					struct sk_buff *skb,
+					u32 *vdev_id, u32 *tx_status)
 {
 	const void **tb;
 	const struct wmi_bcn_tx_status_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, evt_buf, len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -5724,7 +5724,7 @@ static int ath11k_pull_vdev_stopped_param_tlv(struct ath11k_base *ab, struct sk_
 	const struct wmi_vdev_stopped_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -5881,7 +5881,7 @@ static int ath11k_pull_mgmt_tx_compl_param_tlv(struct ath11k_base *ab,
 	const struct wmi_mgmt_tx_compl_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -6057,7 +6057,7 @@ static int ath11k_pull_scan_ev(struct ath11k_base *ab, struct sk_buff *skb,
 	const struct wmi_scan_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -6090,7 +6090,7 @@ static int ath11k_pull_peer_sta_kickout_ev(struct ath11k_base *ab, struct sk_buf
 	const struct wmi_peer_sta_kickout_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -6117,7 +6117,7 @@ static int ath11k_pull_roam_ev(struct ath11k_base *ab, struct sk_buff *skb,
 	const struct wmi_roam_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -6158,14 +6158,14 @@ static int freq_to_idx(struct ath11k *ar, int freq)
 	return idx;
 }
 
-static int ath11k_pull_chan_info_ev(struct ath11k_base *ab, u8 *evt_buf,
-				    u32 len, struct wmi_chan_info_event *ch_info_ev)
+static int ath11k_pull_chan_info_ev(struct ath11k_base *ab, struct sk_buff *skb,
+				    struct wmi_chan_info_event *ch_info_ev)
 {
 	const void **tb;
 	const struct wmi_chan_info_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, evt_buf, len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -6204,7 +6204,7 @@ ath11k_pull_pdev_bss_chan_info_ev(struct ath11k_base *ab, struct sk_buff *skb,
 	const struct wmi_pdev_bss_chan_info_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -6244,7 +6244,7 @@ ath11k_pull_vdev_install_key_compl_ev(struct ath11k_base *ab, struct sk_buff *sk
 	const struct wmi_vdev_install_key_compl_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -6275,7 +6275,7 @@ static int ath11k_pull_peer_assoc_conf_ev(struct ath11k_base *ab, struct sk_buff
 	const struct wmi_peer_assoc_conf_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -7000,7 +7000,7 @@ static int ath11k_reg_11d_new_cc_event(struct ath11k_base *ab, struct sk_buff *s
 	const void **tb;
 	int ret, i;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -7391,8 +7391,7 @@ static void ath11k_bcn_tx_status_event(struct ath11k_base *ab, struct sk_buff *s
 	struct ath11k_vif *arvif;
 	u32 vdev_id, tx_status;
 
-	if (ath11k_pull_bcn_tx_status_ev(ab, skb->data, skb->len,
-					 &vdev_id, &tx_status) != 0) {
+	if (ath11k_pull_bcn_tx_status_ev(ab, skb, &vdev_id, &tx_status) != 0) {
 		ath11k_warn(ab, "failed to extract bcn tx status");
 		return;
 	}
@@ -7423,7 +7422,7 @@ static void ath11k_wmi_event_peer_sta_ps_state_chg(struct ath11k_base *ab,
 	enum ath11k_wmi_peer_ps_state peer_previous_ps_state;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -7891,7 +7890,7 @@ static void ath11k_chan_info_event(struct ath11k_base *ab, struct sk_buff *skb)
 	/* HW channel counters frequency value in hertz */
 	u32 cc_freq_hz = ab->cc_freq_hz;
 
-	if (ath11k_pull_chan_info_ev(ab, skb->data, skb->len, &ch_info_ev) != 0) {
+	if (ath11k_pull_chan_info_ev(ab, skb, &ch_info_ev) != 0) {
 		ath11k_warn(ab, "failed to extract chan info event");
 		return;
 	}
@@ -8223,7 +8222,7 @@ static void ath11k_pdev_ctl_failsafe_check_event(struct ath11k_base *ab,
 	const struct wmi_pdev_ctl_failsafe_chk_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -8288,7 +8287,7 @@ ath11k_wmi_pdev_csa_switch_count_status_event(struct ath11k_base *ab,
 	const u32 *vdev_ids;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -8322,7 +8321,7 @@ ath11k_wmi_pdev_dfs_radar_detected_event(struct ath11k_base *ab, struct sk_buff
 	struct ath11k *ar;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -8376,7 +8375,7 @@ ath11k_wmi_pdev_temperature_event(struct ath11k_base *ab,
 	const struct wmi_pdev_temperature_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
@@ -8416,7 +8415,7 @@ static void ath11k_fils_discovery_event(struct ath11k_base *ab,
 	const struct wmi_fils_discovery_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab,
@@ -8448,7 +8447,7 @@ static void ath11k_probe_resp_tx_status_event(struct ath11k_base *ab,
 	const struct wmi_probe_resp_tx_status_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab,
@@ -8574,7 +8573,7 @@ static void ath11k_wmi_twt_add_dialog_event(struct ath11k_base *ab,
 	const struct wmi_twt_add_dialog_event *ev;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab,
@@ -8611,7 +8610,7 @@ static void ath11k_wmi_gtk_offload_status_event(struct ath11k_base *ab,
 	u64    replay_ctr;
 	int ret;
 
-	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
 		ret = PTR_ERR(tb);
 		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index fa3b480b9d24f..9f6280d87b898 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -6320,8 +6320,8 @@ enum wmi_sta_keepalive_method {
 #define WMI_STA_KEEPALIVE_INTERVAL_DEFAULT	30
 #define WMI_STA_KEEPALIVE_INTERVAL_DISABLE	0
 
-const void **ath11k_wmi_tlv_parse_alloc(struct ath11k_base *ab, const void *ptr,
-					size_t len, gfp_t gfp);
+const void **ath11k_wmi_tlv_parse_alloc(struct ath11k_base *ab,
+					struct sk_buff *skb, gfp_t gfp);
 int ath11k_wmi_cmd_send(struct ath11k_pdev_wmi *wmi, struct sk_buff *skb,
 			u32 cmd_id);
 struct sk_buff *ath11k_wmi_alloc_skb(struct ath11k_wmi_base *wmi_sc, u32 len);
-- 
2.53.0



