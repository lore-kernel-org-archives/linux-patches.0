Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1307D3A0E85;
	Sat, 17 Oct 2026 16:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255145; cv=none; b=j8wwY3SzMotqFpn4GmqRrHoq4foQ5itOa8rwNhwmv6DuOdXLd4LhlnJBl1eoB7UtLUNvE2fOa+YF3SUZ+bzSfNd1dB2P3dVCJWjKRybxH5huhmAyL9EHwM1x3nD0R3se5MtuC/voYuVFm+KY+SvNiI8dQXVafKhjgyE8xh4/76w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255145; c=relaxed/simple;
	bh=bEGrByd/PySgmtsY+kgoKWcMU6NW/ozL/CCUkT432gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdE/wO1hZ6RIYd6bpISLMUyNNd7hlTUs9iHMOJ361tX9Z3Yt0Ys1IjiV6pIMIelSCrhmE7nIvftDrHvBaPxjMRTqUX44fTDCohUg7/0IuXxIHBRCokcxn/cJgkdC4jwY+Smh9kp0uuzbo+kSNhW0OCk4F5/o2IRTzNOj8RDt5c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuKZUiyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuKZUiyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B12B1F000C6;
	Sat, 17 Oct 2026 16:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255143;
	bh=sVS4+qU4LX71avK4eIetVzump6c2rGR0I48iVNwzX24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuKZUiyrktqvN/gT646BskHIYZcRFVk3W+OXYY0KhZqwDUTpKkYRhaNyyyg4jfFPb
	 8gjojse7pABaCYuC7DjYVyC+tIwJkACKVuEiIUOdqCcVSpR4IoAeW2vKSzrtBKKq4P
	 zNtuQSmruZNHre269V1fW6sbHnzSyXNeaDEpXmYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 679/869] wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
Date: Sat, 17 Oct 2026 17:58:40 +0200
Message-ID: <20261017160054.389242232@linuxfoundation.org>
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
 drivers/net/wireless/ath/ath12k/wmi.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 598a69f9e6df0..ca359eecb42a9 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -171,6 +171,8 @@ static const struct ath12k_wmi_tlv_policy ath12k_wmi_tlv_policies[] = {
 		.min_len = sizeof(struct ath12k_wmi_p2p_noa_info) },
 	[WMI_TAG_P2P_NOA_EVENT] = {
 		.min_len = sizeof(struct wmi_p2p_noa_event) },
+	[WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT] = {
+		.min_len = sizeof(struct ath12k_wmi_pdev_csa_event) },
 };
 
 static __le32 ath12k_wmi_tlv_hdr(u32 cmd, u32 len)
@@ -384,6 +386,13 @@ ath12k_wmi_tlv_parse_alloc(struct ath12k_base *ab,
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
@@ -6735,6 +6744,8 @@ ath12k_wmi_process_csa_switch_count_event(struct ath12k_base *ab,
 					  const struct ath12k_wmi_pdev_csa_event *ev,
 					  const u32 *vdev_ids)
 {
+	u32 vdev_ids_len = ath12k_wmi_tlv_data_len(vdev_ids);
+	u32 num_vdevs = le32_to_cpu(ev->num_vdevs);
 	int i;
 	struct ath12k_vif *arvif;
 
@@ -6742,8 +6753,14 @@ ath12k_wmi_process_csa_switch_count_event(struct ath12k_base *ab,
 	if (ev->current_switch_count)
 		return;
 
+	if (num_vdevs > vdev_ids_len / sizeof(*vdev_ids)) {
+		ath12k_warn(ab, "csa switch count num_vdevs %u exceeds tlv array length %u\n",
+			    num_vdevs, vdev_ids_len);
+		return;
+	}
+
 	rcu_read_lock();
-	for (i = 0; i < le32_to_cpu(ev->num_vdevs); i++) {
+	for (i = 0; i < num_vdevs; i++) {
 		arvif = ath12k_mac_get_arvif_by_vdev_id(ab, vdev_ids[i]);
 
 		if (!arvif) {
-- 
2.53.0



