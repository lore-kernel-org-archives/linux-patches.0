Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A7E248F62;
	Thu, 28 May 2026 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000250; cv=none; b=hV0+/+J6W7TmeHodcYcCgPyMZJCv7Hr5h5be62OtHaAx/dlYJe1Nw4R6PwsbpsS6URp2BTFIg/owR9NxK6bM6tnzq29InOOskp2Rj8q2m2dwmSzdBqIr5zYQO42X2JyE0gBlKjjZijhhXoUu8BPQtDgi7cZGM71+bg3kCPEOEVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000250; c=relaxed/simple;
	bh=JJ52T0OOMhWQz0LpPbZT+5LrulB83rDemtk6x9ppy58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPluWJuWTrMJVPIBdncY2Xu2YQc7PbMxvGqrDh8zQUB/KZ4duptWgQzImJQCeMGA5G9PfzFSVtXzx2Dim8Ep0X0EOD4wFBsPPrwIabh9KjeEzVQyi0nUwVqKBikGJIALD+U7M2TNXCJ3pAlZ8uncLP2D9UC/CjLQkRMPLyMT6+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNKxerBR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNKxerBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590941F000E9;
	Thu, 28 May 2026 20:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000248;
	bh=oGUQ4fjgFRNbaqu0AskLLeiWt0NkO1DPcAWCBSccu2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNKxerBRZi/d9taJfoNJDd1H3RHPNgchgdzAoVeehpRGB/Bd4pWNIWiS+pKMbFXQT
	 ZXuqVBM+mjqDmSRpNcnIwxLCR/izWbdKkOA3WxdeawMAW/LJZ2BxTXa1g+snVstyMo
	 a0mk7MmecXxoPiAUTMbZSOB9UrdBL7HzzT9b0kh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Matthew Leach <matthew.leach@collabora.com>,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 318/377] wifi: ath11k: fix peer resolution on rx path when peer_id=0
Date: Thu, 28 May 2026 21:49:16 +0200
Message-ID: <20260528194647.602618116@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Matthew Leach <matthew.leach@collabora.com>

[ Upstream commit 2a2451a34afdf563b3102d36a4b6cf335cf813e2 ]

It has been observed that on certain chipsets a peer can be assigned
peer_id=0. For reception of non-aggregated MPDUs this is fine as
ath11k_dp_rx_h_find_peer() has a fallback case where it locates the peer
based upon the source MAC address. On an aggregated link, the mpdu_start
header is only populated by hardware on the first sub-MSDU. This causes
the peer resolution to be skipped for the subsequent MSDUs and the
encryption type of these frames to be set to an incorrect value,
resulting in these MSDUs being dropped by ieee80211.

ath11k_pci 0000:03:00.0: data rx skb 000000002f4b704d len 1534 peer xx:xx:xx:xx:xx:xx 0 ucast sn 3063 he160 rate_idx 9 vht_nss 2 freq 5240 band 1 flag 0x40d1a fcs-err 0 mic-err 0 amsdu-more 0 peer_id 0 first_msdu 1 last_msdu 0
ath11k_pci 0000:03:00.0: data rx skb 0000000038acd580 len 1534 peer (null) 0 ucast sn 3063 he160 rate_idx 9 vht_nss 2 freq 5240 band 1 flag 0x40d00 fcs-err 0 mic-err 0 amsdu-more 0 peer_id 0 first_msdu 0 last_msdu 1

Remove the null peer_id checks in ath11k_dp_rx_h_find_peer() and
ath11k_hal_rx_parse_mon_status_tlv(), allowing peers with an assigned ID
of 0 to be resolved.

Tested-on: QCA2066 hw2.1 PCI WLAN.HSP.1.1-03926.13-QCAHSPSWPL_V2_SILICONZ_CE-2.52297.9

Fixes: 2167fa606c0f ("ath11k: Add support for RX decapsulation offload")
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Matthew Leach <matthew.leach@collabora.com>
Reviewed-by: P Praneesh <praneesh.p@oss.qualcomm.com>
Link: https://patch.msgid.link/20260424-ath11k-null-peerid-workaround-v4-1-252b224d3cf6@collabora.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c  | 3 +--
 drivers/net/wireless/ath/ath11k/hal_rx.c | 5 +----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 44eea682c297b..5666f66474455 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2214,8 +2214,7 @@ ath11k_dp_rx_h_find_peer(struct ath11k_base *ab, struct sk_buff *msdu)
 
 	lockdep_assert_held(&ab->base_lock);
 
-	if (rxcb->peer_id)
-		peer = ath11k_peer_find_by_id(ab, rxcb->peer_id);
+	peer = ath11k_peer_find_by_id(ab, rxcb->peer_id);
 
 	if (peer)
 		return peer;
diff --git a/drivers/net/wireless/ath/ath11k/hal_rx.c b/drivers/net/wireless/ath/ath11k/hal_rx.c
index 753bd93f02123..51e0840bc0d1e 100644
--- a/drivers/net/wireless/ath/ath11k/hal_rx.c
+++ b/drivers/net/wireless/ath/ath11k/hal_rx.c
@@ -1467,11 +1467,8 @@ ath11k_hal_rx_parse_mon_status_tlv(struct ath11k_base *ab,
 	case HAL_RX_MPDU_START: {
 		struct hal_rx_mpdu_info *mpdu_info =
 				(struct hal_rx_mpdu_info *)tlv_data;
-		u16 peer_id;
 
-		peer_id = ath11k_hal_rx_mpduinfo_get_peerid(ab, mpdu_info);
-		if (peer_id)
-			ppdu_info->peer_id = peer_id;
+		ppdu_info->peer_id = ath11k_hal_rx_mpduinfo_get_peerid(ab, mpdu_info);
 		break;
 	}
 	case HAL_RXPCU_PPDU_END_INFO: {
-- 
2.53.0



