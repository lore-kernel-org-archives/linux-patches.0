Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDA242885F;
	Sat, 12 Sep 2026 10:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208521; cv=none; b=ajckovbMVsnKJsgZ0bcS595lrtkaILXGXwWG7Cvd74V0d7NHZWcNeSdFBnq0btZTN4bBqPovz32tQhwSfE7oemGVJO7JpZW967mE1HhTATmKQHxFKAb3J7AnnfCrEzzOkqOxM1T2XLSvT7KVLtXaW1q722eoM+lGKL2NHXIwayw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208521; c=relaxed/simple;
	bh=P4QEFwoMv3zmZvWiRcb2YVKSUIjWxoOf2BDVxQU4FfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQtOU5KPyLPs8r9EvWATwO9FFRNIbFa6qhBeKjUwkrLx+RkDx+6TXgjus3Oav2S0c12LpYol3LC6bWsnO2LllgHoU+z17thZfNVIFD0AxqAsQ0t02hSe7tqIJ69e9V5CipxME0rjMr2yAzku6XRLmfFUrJRxd8qLqHFkUc02AF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSRC2nYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSRC2nYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03D81F00898;
	Sat, 12 Sep 2026 10:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208515;
	bh=9W9uXtegdmE4gJT+k8iak9XPHD3F6T6EUlykYYZEAFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSRC2nYltDNxo1Xs0Qbg9ikuag8BWz/1n1ngs+NbHOUrPekqiYGtV9VmzIWZWDiFT
	 Pek2OR2ZfriyVpNTjoXY+74OcXbumbX0+EM8mxJAd31itwz5w+FZc40PrGqNsEVVMo
	 KExfLxLnUvAbBNtemZLivw7zTC/8XZhhbGNPNxVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0632/1518] wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()
Date: Sat, 12 Sep 2026 08:46:41 +0200
Message-ID: <20260912065637.728443514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 208d7fdb85976a737a715b81d54efaff6703880c ]

There is no policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT, so
the parse infrastructure does not enforce a minimum length for the event
struct. Additionally, the num_vdevs field is taken directly from firmware
and used as a loop bound over the vdev_ids array without checking that it
fits within the TLV payload. Either condition can cause an out-of-bounds
read.

Add a TLV policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT so
the parse infrastructure enforces a minimum length for the fixed-size event
struct. Add a helper ath11k_wmi_tlv_data_len() to recover the payload
length of a parsed TLV from the header preceding its data pointer. Use it
in ath11k_wmi_process_csa_switch_count_event() to bound num_vdevs before
the loop.

Compile tested only.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-2-02a45d7246c0@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 1303931f97663..8fb91586abd5e 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -159,6 +159,8 @@ static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 		.min_len = sizeof(struct ath11k_wmi_p2p_noa_info) },
 	[WMI_TAG_P2P_NOA_EVENT] = {
 		.min_len = sizeof(struct wmi_p2p_noa_event) },
+	[WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT] = {
+		.min_len = sizeof(struct wmi_pdev_csa_switch_ev) },
 };
 
 #define PRIMAP(_hw_mode_) \
@@ -262,6 +264,13 @@ const void **ath11k_wmi_tlv_parse_alloc(struct ath11k_base *ab,
 	return tb;
 }
 
+static u32 ath11k_wmi_tlv_data_len(const void *data)
+{
+	const struct wmi_tlv *tlv = (const struct wmi_tlv *)data - 1;
+
+	return FIELD_GET(WMI_TLV_LEN, tlv->header);
+}
+
 static int ath11k_wmi_cmd_send_nowait(struct ath11k_pdev_wmi *wmi, struct sk_buff *skb,
 				      u32 cmd_id)
 {
@@ -8302,15 +8311,23 @@ ath11k_wmi_process_csa_switch_count_event(struct ath11k_base *ab,
 					  const struct wmi_pdev_csa_switch_ev *ev,
 					  const u32 *vdev_ids)
 {
-	int i;
+	u32 vdev_ids_len = ath11k_wmi_tlv_data_len(vdev_ids);
+	u32 num_vdevs = ev->num_vdevs;
 	struct ath11k_vif *arvif;
+	int i;
 
 	/* Finish CSA once the switch count becomes NULL */
 	if (ev->current_switch_count)
 		return;
 
+	if (num_vdevs > vdev_ids_len / sizeof(*vdev_ids)) {
+		ath11k_warn(ab, "csa switch count num_vdevs %u exceeds tlv array length %u\n",
+			    num_vdevs, vdev_ids_len);
+		return;
+	}
+
 	rcu_read_lock();
-	for (i = 0; i < ev->num_vdevs; i++) {
+	for (i = 0; i < num_vdevs; i++) {
 		arvif = ath11k_mac_get_arvif_by_vdev_id(ab, vdev_ids[i]);
 
 		if (!arvif) {
-- 
2.53.0



