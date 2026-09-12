Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E14741B8CC;
	Sat, 12 Sep 2026 10:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208525; cv=none; b=DipAw5yXD64QaosGaRuORX+sIdvpfHRUx3ggHBj3eJbIu8nmjJUMDenVZ7UY6AthHD//clegwih6nDJkQwWO94AKnd+ZRII9OTs4RKDbmkGSVsDq1QTaSKfcxLZmZKyoJ0xoVUCbnV0pJVbnIhwr26W9IdwwlGPiV0CZpwX1DAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208525; c=relaxed/simple;
	bh=CmxbC27ZwWLc4Sef5MEbhk5G/UuZ8GhFT5mv0BVEoqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMWwgvieKag0EhvUgzlc6Kgl8Q183ToYBJ1JUZXQ0ZjAfyOk+7WYYvkC7BGfsRrD78KkYxvv2kOFV4/LOWmCRdFN4FYCCr0hInSGwnUiKuTf38leXsY3zbtTXs98KiAt1uKe2VX3xhdJQXxsQw2JSQ8VEqBkVwhHKTf8dx3DnGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8vbjSTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8vbjSTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320A11F00893;
	Sat, 12 Sep 2026 10:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208520;
	bh=/BMjgmJEGOhqnR8kJJ6pBrH06MZ3KCtu9U51vBjPQDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8vbjSTm/SowDvDNcX9S/AfxE4Wq6dfZSsGT0TGtez3mIK0s9idT+FoE+GcGsud4h
	 lJP3wcxkwOu6aNStNrILCScAwi88RA14Gb4iJ9gOEoF3m900Yy5327RW/Zrd+y7KWx
	 Sbp8UU27s27K0yUpa3CulHG7u6R67Ut3zhG5iAWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0633/1518] wifi: ath12k: validate TLV length in process_tpc_stats()
Date: Sat, 12 Sep 2026 08:46:42 +0200
Message-ID: <20260912065637.751325129@linuxfoundation.org>
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

[ Upstream commit 8e415b8068480d51a057197ded974e2637e8c42b ]

The outer skb->len guard only confirms the SKB is large enough
to hold the full fixed_param struct, but the TLV's own WMI_TLV_LEN
field is never checked. Firmware advertising a TLV length shorter
than sizeof(*fixed_param) causes reads of pdev_id and event_count
beyond the declared TLV payload.

Add a check that the TLV length is at least sizeof(*fixed_param)
before casting and dereferencing the pointer.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260726-ath12k_wmi_process_tpc_stats-len-check-v1-1-c4ba2f84d9c6@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 077154b564aeb..6221bf43936bc 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -9410,6 +9410,7 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 	void *ptr = skb->data;
 	struct ath12k *ar;
 	u16 tlv_tag;
+	u16 tlv_len;
 	u32 event_count;
 	int ret;
 
@@ -9425,6 +9426,7 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 
 	tlv = (struct wmi_tlv *)ptr;
 	tlv_tag = le32_get_bits(tlv->header, WMI_TLV_TAG);
+	tlv_len = le32_get_bits(tlv->header, WMI_TLV_LEN);
 	ptr += sizeof(*tlv);
 
 	if (tlv_tag != WMI_TAG_HALPHY_CTRL_PATH_EVENT_FIXED_PARAM) {
@@ -9432,6 +9434,12 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 		return;
 	}
 
+	if (tlv_len < sizeof(*fixed_param)) {
+		ath12k_warn(ab, "TPC stats fixed param tlv len %u too short\n",
+			    tlv_len);
+		return;
+	}
+
 	fixed_param = (struct ath12k_wmi_pdev_tpc_stats_event_fixed_params *)ptr;
 	rcu_read_lock();
 	ar = ath12k_mac_get_ar_by_pdev_id(ab, le32_to_cpu(fixed_param->pdev_id) + 1);
-- 
2.53.0



