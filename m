Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DB2274B46;
	Sat, 12 Sep 2026 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224120; cv=none; b=uvRUwoCxMvDUzKDdbzFMZqJegh15ynCF7MDDQLOAPa1xjd9f3gd/WNc4Fvdae9n4C8cV02/erVmw23p7i4KRJ7r4WaYQE5YW8x75Q7LhyhsXzosRYVe+wuzv2Z/zq8nm/7pJPc6zpfLsJraF5j/H4N4wUBKuZYbDzdQwnpr10xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224120; c=relaxed/simple;
	bh=Iq4kXWMS0W/3ddfDvbCPEV3vCyyspmcltRUpxHM12gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXtmH6ai41Bv0XdG11WajZdZBuZG+JDY8M0PvHSJJ3GsvCGzLmWvaOsgDPPBwWkFWjcTiAxjUz6oBEruNJcpWRWTO65vu3yPIE/W054a+JAF76s3GbvO1DqlTLkqzyWiIWXs0nF1lBcZZp2orTpFq8MUTrFRjLzUhoOXcO2zEHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEBn9dbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEBn9dbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157061F00893;
	Sat, 12 Sep 2026 14:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224118;
	bh=DWJZ+cUqtWLc8SsfW/zvlW66gD4Vv0PBjxYMLOyczjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEBn9dbxUPdNZ0Hi+uwVuK1rEPGtyaCN+k7tS48p695FlIXvnTDNebmii8Eonn/Cn
	 wUiZebGnWTSO1kFfxNuKFBt30MXSOrZwTFmBYEQ2ciLfn70B6itSKmEB7VjLEglQk1
	 iXmYKwjgVzzmCyfxdKxdWveyJHjYq3JpYsAhvSEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0928/1424] wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()
Date: Sat, 12 Sep 2026 08:56:00 +0200
Message-ID: <20260912065628.105898703@linuxfoundation.org>
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
index e7052c6f07368..03d5109de528f 100644
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
@@ -8260,15 +8269,23 @@ ath11k_wmi_process_csa_switch_count_event(struct ath11k_base *ab,
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



