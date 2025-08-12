Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7313026A0EB;
	Tue, 12 Aug 2025 18:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023714; cv=none; b=Cy9Um007bhvaeLgAd2iZcFZILnl3xkQjHETbja5QFRwH7HoCe/fb+RA5g0+YXwXYqDQvSfPrgUtZ/0Yjgb9Q7pON5DYnfaCbVTssKR4IBCQpds23IaG7kjktPXREUpouu695lIrzeSZ5hglsS+1YcVnsZpfyQwVDJvVmFwjFyII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023714; c=relaxed/simple;
	bh=RszMg4lcSrFQNCTvC74U2tBW9O+6d8zKvK/iKaUHajw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p46Or0cx8tH/E5CxHXtkH1ogOIL2mptl4OrYfk+x0AtRJQnpRXy52siehZykzSPcew5ZCm4wHh5TLZ0xb3KtriP4mio2RYj69Cc9tK1BQk5klkqWIuh3/R+xXYG/+2RMAQLlGgRL1ChPyFMnb1VF19X+a8zfL8bohuAVoGUhwuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOGIncXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOGIncXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6257C4CEF0;
	Tue, 12 Aug 2025 18:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023714;
	bh=RszMg4lcSrFQNCTvC74U2tBW9O+6d8zKvK/iKaUHajw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOGIncXi3DWxoi4dhc2axqLRDYpNtbDPjiOLMJ0I6fJci2KDeFUTWK5EcAq7rDwoE
	 V7jfhMOvaHA4InOG0sVHKfzbazzJL8WFfM7oLuzbq7rhllE1A8kaJwLIfqBQNzn8uL
	 gw4SCyu82LpqZEniPlgmyI3SuojE7siDM+kFhm6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 160/627] wifi: ath12k: Pass ab pointer directly to ath12k_dp_tx_get_encap_type()
Date: Tue, 12 Aug 2025 19:27:35 +0200
Message-ID: <20250812173425.375541940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index b6816b6c2c04..075912eacfaa 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -13,10 +13,9 @@
 #include "mac.h"
 
 static enum hal_tcl_encap_type
-ath12k_dp_tx_get_encap_type(struct ath12k_link_vif *arvif, struct sk_buff *skb)
+ath12k_dp_tx_get_encap_type(struct ath12k_base *ab, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ath12k_base *ab = arvif->ar->ab;
 
 	if (test_bit(ATH12K_FLAG_RAW_MODE, &ab->dev_flags))
 		return HAL_TCL_ENCAP_TYPE_RAW;
@@ -305,7 +304,7 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_link_vif *arvif,
 			u32_encode_bits(mcbc_gsn, HTT_TCL_META_DATA_GLOBAL_SEQ_NUM);
 	}
 
-	ti.encap_type = ath12k_dp_tx_get_encap_type(arvif, skb);
+	ti.encap_type = ath12k_dp_tx_get_encap_type(ab, skb);
 	ti.addr_search_flags = arvif->hal_addr_search_flags;
 	ti.search_type = arvif->search_type;
 	ti.type = HAL_TCL_DESC_TYPE_BUFFER;
-- 
2.39.5



