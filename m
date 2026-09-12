Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B830A3403F5;
	Sat, 12 Sep 2026 08:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200215; cv=none; b=cZvLYARjhtBMmcDqnLppnG+ypbchLyBhTbrHOqZMZotNp+CwwlCjibwqgKRMm8y5vLNCyPMwhnXZlygWENDBtQYM4Op6786m0RBblADp5RGZqt8FXuxxcARc6AnyxLGlmt8jgOXJLG5ArQ73e4MiPxY2GCUl3r6+FMRbmgDX8pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200215; c=relaxed/simple;
	bh=gzMyDN5j0DxZzP3xCS1mo1aGAdBZtOTp/8lOY2XvQVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCsYQv7DoAsGI0qRpsHb0eQNm4OPJxKBRNLWV4g39UgkKVfRAPgQsUqVfz5TGmxo56kVYoN8T2eCIX8sGCeqGhg5TqBGCMjoqoadtGONd3Hj+XWavY+valX4n2L8cjAJN+b+BOVjAQo1kjHmbr5iWDcEeiwIoLNgfM6D9bgJ/n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuT/+g2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuT/+g2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710E31F000FF;
	Sat, 12 Sep 2026 08:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200213;
	bh=m3Vh8XXljud1Qs2zPvLzVcU9iA6Xgv5K6AxajBm6cX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YuT/+g2/m3ruO55UXySC0y1evkDgoefVXciOEr2XCIEGDk3RBml0mBfjuzaQzxXyY
	 BekotjZbmtqhWT/F1PdLTY+MKAcWETL6ETfv8rhtZTUjjwjoxHR5JcT57ncZqu2YpX
	 +PgKN566P3nTUaLFIaq6nDCfOi4vcb/Y5lEQwByU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0745/1815] wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
Date: Sat, 12 Sep 2026 08:41:35 +0200
Message-ID: <20260912065706.395541934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 878654eb78c6aa0ff585baf1376567c775ca28ec ]

There is no policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT, so
the parse infrastructure does not enforce a minimum length for the event
struct. Additionally, the num_vdevs field is taken directly from firmware
and used as a loop bound over the vdev_ids array without checking that it
fits within the TLV payload. Either condition can cause an out-of-bounds
read.

Add a TLV policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT so
the parse infrastructure enforces a minimum length for the fixed-size event
struct. Add a helper ath12k_wmi_tlv_data_len() to recover the payload
length of a parsed TLV from the header preceding its data pointer. Use it
in ath12k_wmi_process_csa_switch_count_event() to bound num_vdevs before
the loop.

Compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-1-02a45d7246c0@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 9840dd950ac9f..fa10f4119ea59 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -207,6 +207,8 @@ static const struct ath12k_wmi_tlv_policy ath12k_wmi_tlv_policies[] = {
 		.min_len = sizeof(struct wmi_per_chain_rssi_stat_params) },
 	[WMI_TAG_OBSS_COLOR_COLLISION_EVT] = {
 		.min_len = sizeof(struct wmi_obss_color_collision_event) },
+	[WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT] = {
+		.min_len = sizeof(struct ath12k_wmi_pdev_csa_event) },
 };
 
 __le32 ath12k_wmi_tlv_hdr(u32 cmd, u32 len)
@@ -374,6 +376,13 @@ ath12k_wmi_tlv_parse(struct ath12k_base *ab, struct sk_buff *skb)
 	return tb;
 }
 
+static u32 ath12k_wmi_tlv_data_len(const void *data)
+{
+	const struct wmi_tlv *tlv = (const struct wmi_tlv *)data - 1;
+
+	return le32_get_bits(tlv->header, WMI_TLV_LEN);
+}
+
 static int ath12k_wmi_cmd_send_nowait(struct ath12k_wmi_pdev *wmi, struct sk_buff *skb,
 				      u32 cmd_id)
 {
@@ -9056,12 +9065,19 @@ ath12k_wmi_process_csa_switch_count_event(struct ath12k_base *ab,
 					  const u32 *vdev_ids)
 {
 	u32 current_switch_count = le32_to_cpu(ev->current_switch_count);
+	u32 vdev_ids_len = ath12k_wmi_tlv_data_len(vdev_ids);
 	u32 num_vdevs = le32_to_cpu(ev->num_vdevs);
 	struct ieee80211_bss_conf *conf;
 	struct ath12k_link_vif *arvif;
 	struct ath12k_vif *ahvif;
 	int i;
 
+	if (num_vdevs > vdev_ids_len / sizeof(*vdev_ids)) {
+		ath12k_warn(ab, "csa switch count num_vdevs %u exceeds tlv array length %u\n",
+			    num_vdevs, vdev_ids_len);
+		return;
+	}
+
 	rcu_read_lock();
 	for (i = 0; i < num_vdevs; i++) {
 		arvif = ath12k_mac_get_arvif_by_vdev_id(ab, vdev_ids[i]);
-- 
2.53.0



