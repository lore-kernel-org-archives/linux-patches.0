Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0777D30C63B;
	Mon, 13 Oct 2025 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369908; cv=none; b=rS5d9RbOuWKW5eFfzyIkX7XOrQKQg72w+hBp3YfCxhhBhpOjwhEunUWKLZb+1Dwq+COU7pxIDyqf+nsl/Xk72CU7gwKUzvkZrq0prcykG8UzwWjoefM0mw2IiJk/otCi/oKGS9XP72sThrtJjKReVTYfVWW1cKRGKp94CGbydoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369908; c=relaxed/simple;
	bh=ljtpRBAbq4TzdfP8NKtxGNCzm6mGqHV/o7LbIiQKn5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZyqYW9WReiYCiLRGgFoqb6mpG5Y7I5NySOVGabFTNVxoOcbtV0vnNE3jTo4NAq5xrLOEBtKHVx6MvDVd1ETYRtsWhjjmSQN/AEAWu4/NjgbQvzYnc1nQ+VOufcSbXKEfKdMResIB85FOeQyA0sd8OuBLs7vjaRxotOyFbTcUa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUY4mT7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUY4mT7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFA3C4CEE7;
	Mon, 13 Oct 2025 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369907;
	bh=ljtpRBAbq4TzdfP8NKtxGNCzm6mGqHV/o7LbIiQKn5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUY4mT7PtVNTNZgMDWCNgY256rE7hhJYkxLi61FYcriIGaCfb6UO+fR9mm081kYUm
	 aSRLxIR50Su1QBXTR/FY0jfDBdq6kue+JWgDNZF6Yo5+igqOwg6fhANc0ri2ghWHeM
	 rM3cinprIED28qCwOC9xI8ttr/CQHdb3ssKt4pR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Chandrakanthan <quic_haric@quicinc.com>,
	Aishwarya R <aishwarya.r@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 409/563] wifi: ath12k: Fix peer lookup in ath12k_dp_mon_rx_deliver_msdu()
Date: Mon, 13 Oct 2025 16:44:30 +0200
Message-ID: <20251013144426.103819933@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Chandrakanthan <quic_haric@quicinc.com>

[ Upstream commit 7ca61ed8b3f3fc9a7decd68039cb1d7d1238c566 ]

In ath12k_dp_mon_rx_deliver_msdu(), peer lookup fails because
rxcb->peer_id is not updated with a valid value. This is expected
in monitor mode, where RX frames bypass the regular RX
descriptor path that typically sets rxcb->peer_id.
As a result, the peer is NULL, and link_id and link_valid fields
in the RX status are not populated. This leads to a WARN_ON in
mac80211 when it receives data frame from an associated station
with invalid link_id.

Fix this potential issue by using ppduinfo->peer_id, which holds
the correct peer id for the received frame. This ensures that the
peer is correctly found and the associated link metadata is updated
accordingly.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: bd00cc7e8a4c ("wifi: ath12k: replace the usage of rx desc with rx_info")
Signed-off-by: Hari Chandrakanthan <quic_haric@quicinc.com>
Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250724040552.1170642-1-aishwarya.r@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index abd611ac37f06..009c495021489 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -2273,6 +2273,7 @@ static void ath12k_dp_mon_update_radiotap(struct ath12k *ar,
 
 static void ath12k_dp_mon_rx_deliver_msdu(struct ath12k *ar, struct napi_struct *napi,
 					  struct sk_buff *msdu,
+					  const struct hal_rx_mon_ppdu_info *ppduinfo,
 					  struct ieee80211_rx_status *status,
 					  u8 decap)
 {
@@ -2286,7 +2287,6 @@ static void ath12k_dp_mon_rx_deliver_msdu(struct ath12k *ar, struct napi_struct
 	struct ieee80211_sta *pubsta = NULL;
 	struct ath12k_peer *peer;
 	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(msdu);
-	struct ath12k_dp_rx_info rx_info;
 	bool is_mcbc = rxcb->is_mcbc;
 	bool is_eapol_tkip = rxcb->is_eapol;
 
@@ -2300,8 +2300,7 @@ static void ath12k_dp_mon_rx_deliver_msdu(struct ath12k *ar, struct napi_struct
 	}
 
 	spin_lock_bh(&ar->ab->base_lock);
-	rx_info.addr2_present = false;
-	peer = ath12k_dp_rx_h_find_peer(ar->ab, msdu, &rx_info);
+	peer = ath12k_peer_find_by_id(ar->ab, ppduinfo->peer_id);
 	if (peer && peer->sta) {
 		pubsta = peer->sta;
 		if (pubsta->valid_links) {
@@ -2394,7 +2393,7 @@ static int ath12k_dp_mon_rx_deliver(struct ath12k *ar,
 			decap = mon_mpdu->decap_format;
 
 		ath12k_dp_mon_update_radiotap(ar, ppduinfo, mon_skb, rxs);
-		ath12k_dp_mon_rx_deliver_msdu(ar, napi, mon_skb, rxs, decap);
+		ath12k_dp_mon_rx_deliver_msdu(ar, napi, mon_skb, ppduinfo, rxs, decap);
 		mon_skb = skb_next;
 	} while (mon_skb);
 	rxs->flag = 0;
-- 
2.51.0



