Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D9A21C187;
	Tue, 12 Aug 2025 19:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025813; cv=none; b=TAIWO5/ExRVORQiyLtF0FkpzwJbJ+7KskXt3jcT4Cy1TlKqcaSekVUmsJ2fOwhnNnyg0Snxb9EDPIIZb0NJTbk+GhGG1uwWKOFf32bfvEAlkzYrKalSexelmcOvvKz3SLipJVeZqApKyANibzk1Zud+yppgRjtbCuKZ9zCCjYmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025813; c=relaxed/simple;
	bh=US9FskHhmkNN4dyz5Zley2knsC4fY4H/hd53pD2taxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wt3T6O3ndGAExpO3UVsiUQ872UiP7a26+U9c43u9nh/d7tvhBvCiUbLhGcAFN0ATw3KTckR6nGhW0RCoe1DlHslVW7c3cGGhmifidoVYF8kwGastX2iU83dXDxKR78+OU2R6x52o2jqpv9essDgBmHOf9+hDfxAJ3og08MrW8AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8oa/oQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8oa/oQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EF0C4CEF0;
	Tue, 12 Aug 2025 19:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025813;
	bh=US9FskHhmkNN4dyz5Zley2knsC4fY4H/hd53pD2taxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8oa/oQKLbgOkrxtCCPjmAN7S7EnK6VdAamMGLacGT/hSyNid2ygQYw2FJ26p7TDn
	 Ppztzy9dL1iz1zgXDks4UD2XreA7PNebfk9FgOmIIkpJ+nPU5LlE37va0gFL2Rouoz
	 Hk97bAXLXZcBzYWSiObJe6dWOV7taOsSWAAvb1y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 118/480] wifi: ath12k: Pass ab pointer directly to ath12k_dp_tx_get_encap_type()
Date: Tue, 12 Aug 2025 19:45:26 +0200
Message-ID: <20250812174402.381441135@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>

[ Upstream commit 05062834350f0bf7ad1abcebc2807220e90220eb ]

In ath12k_dp_tx_get_encap_type(), the arvif parameter is only used to
retrieve the ab pointer. In vdev delete sequence the arvif->ar could
become NULL and that would trigger kernel panic.
Since the caller ath12k_dp_tx() already has a valid ab pointer, pass it
directly to avoid panic and unnecessary dereferencing.

PC points to "ath12k_dp_tx+0x228/0x988 [ath12k]"
LR points to "ath12k_dp_tx+0xc8/0x988 [ath12k]".
The Backtrace obtained is as follows:
ath12k_dp_tx+0x228/0x988 [ath12k]
ath12k_mac_tx_check_max_limit+0x608/0x920 [ath12k]
ieee80211_process_measurement_req+0x320/0x348 [mac80211]
ieee80211_tx_dequeue+0x9ac/0x1518 [mac80211]
ieee80211_tx_dequeue+0xb14/0x1518 [mac80211]
ieee80211_tx_prepare_skb+0x224/0x254 [mac80211]
ieee80211_xmit+0xec/0x100 [mac80211]
__ieee80211_subif_start_xmit+0xc50/0xf40 [mac80211]
ieee80211_subif_start_xmit+0x2e8/0x308 [mac80211]
netdev_start_xmit+0x150/0x18c
dev_hard_start_xmit+0x74/0xc0

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1

Fixes: e93bbd65547e ("wifi: ath12k: fix packets are sent in native wifi mode while we set raw mode")
Signed-off-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250606044936.3989400-1-tamizh.raja@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index f82d2c58eff3..faf58e91d3eb 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -12,10 +12,9 @@
 #include "mac.h"
 
 static enum hal_tcl_encap_type
-ath12k_dp_tx_get_encap_type(struct ath12k_link_vif *arvif, struct sk_buff *skb)
+ath12k_dp_tx_get_encap_type(struct ath12k_base *ab, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ath12k_base *ab = arvif->ar->ab;
 
 	if (test_bit(ATH12K_FLAG_RAW_MODE, &ab->dev_flags))
 		return HAL_TCL_ENCAP_TYPE_RAW;
@@ -302,7 +301,7 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_link_vif *arvif,
 			u32_encode_bits(mcbc_gsn, HTT_TCL_META_DATA_GLOBAL_SEQ_NUM);
 	}
 
-	ti.encap_type = ath12k_dp_tx_get_encap_type(arvif, skb);
+	ti.encap_type = ath12k_dp_tx_get_encap_type(ab, skb);
 	ti.addr_search_flags = arvif->hal_addr_search_flags;
 	ti.search_type = arvif->search_type;
 	ti.type = HAL_TCL_DESC_TYPE_BUFFER;
-- 
2.39.5



