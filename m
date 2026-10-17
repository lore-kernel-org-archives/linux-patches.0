Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D033A59BC;
	Sat, 17 Oct 2026 16:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253298; cv=none; b=laSuOgxL+xO1FsDuasx8uM3oRqId+YGhSd5SqG0aStzbZlz8M/QP3d9kxd9NrJ0QsK8QSBxBpa4IBF8rCrjQbrXdP9CA/5Keg8MDlBRfHw3gz4bCp33Q1Cyai4VauzGlqLfJUzflLHUn2f9VAeC5hCs6i7WkaKIJX/FRlNHzmeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253298; c=relaxed/simple;
	bh=G+Chq4k8FN8FMQpAKJuEFuHtkWVr5BF8qVtsp813s54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5+RBr3b0a5bRJOnVxfW6Im8zVr/QfNe3Qt7gp34cmdYDop2SofSd0xCdiwSuFXuIDEMkoQVU+S6Kajzd6aa2e5pJbfbawX5EDPwstv+7s/pUL3rEmmEPfdYFhRtT5/chqRJHCWJqKgvOb2mjndhJQ9Yeycb9bhfnY35ofMqVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAbvG5wm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAbvG5wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46BD1F000C4;
	Sat, 17 Oct 2026 16:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253296;
	bh=Ya2I+u83Z7DoOkpl1Alos39YcJG9GWiVbkHb4hmNY8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAbvG5wm+cbkhY50tHN7ktMaMMphPCHu3lMTrYA54xnUKFpTapSGBptIBp+RSs/HL
	 yMoMTakJGShMISpGoPOiepuoi1cuD7TgUSZ4/Xn6EvUSKtOnKHjBcZHQ4o3rc247on
	 JkpjqpMrcFhPGB/I8Jhx36FgMREmTcdT3+NAiNtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/869] wifi: ath12k: Avoid memory leak while enabling statistics
Date: Sat, 17 Oct 2026 17:48:26 +0200
Message-ID: <20261017160038.691420801@linuxfoundation.org>
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

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit ecfc131389923405be8e7a6f4408fd9321e4d19b ]

Driver uses monitor destination rings for extended statistics mode and
standalone monitor mode. In extended statistics mode, TLVs are parsed from
the buffer received from the monitor destination ring and assigned to the
ppdu_info structure to update per-packet statistics. In standalone monitor
mode, along with per-packet statistics, the packet data (payload) is
captured, and the driver updates per MSDU to mac80211.

When the AP interface is enabled, only extended statistics mode is
activated. As part of enabling monitor rings for collecting statistics,
the driver subscribes to HAL_RX_MPDU_START TLV in the filter
configuration. This TLV is received from the monitor destination ring, and
kzalloc for the mon_mpdu object occurs, which is not freed, leading to a
memory leak. The kzalloc for the mon_mpdu object is only required while
enabling the standalone monitor interface. This causes a memory leak while
enabling extended statistics mode in the driver.

Fix this memory leak by removing the kzalloc for the mon_mpdu object in
the HAL_RX_MPDU_START TLV handling. Additionally, remove the standalone
monitor mode handlings in the HAL_MON_BUF_ADDR and HAL_RX_MSDU_END TLVs.
These TLV tags will be handled properly when enabling standalone monitor
mode in the future.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Link: https://patch.msgid.link/20241223060132.3506372-13-quic_ppranees@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 64 ++++--------------------
 drivers/net/wireless/ath/ath12k/hal_rx.h |  3 ++
 2 files changed, 12 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index bc24b8edfaea3..ad276f8605054 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -743,7 +743,6 @@ ath12k_dp_mon_rx_parse_status_tlv(struct ath12k_base *ab,
 	}
 	case HAL_RX_MPDU_START: {
 		const struct hal_rx_mpdu_start *mpdu_start = tlv_data;
-		struct dp_mon_mpdu *mon_mpdu = pmon->mon_mpdu;
 		u16 peer_id;
 
 		info[1] = __le32_to_cpu(mpdu_start->info1);
@@ -760,65 +759,17 @@ ath12k_dp_mon_rx_parse_status_tlv(struct ath12k_base *ab,
 				u32_get_bits(info[0], HAL_RX_MPDU_START_INFO0_PPDU_ID);
 		}
 
-		mon_mpdu = kzalloc(sizeof(*mon_mpdu), GFP_ATOMIC);
-		if (!mon_mpdu)
-			return HAL_RX_MON_STATUS_PPDU_NOT_DONE;
-
 		break;
 	}
 	case HAL_RX_MSDU_START:
 		/* TODO: add msdu start parsing logic */
 		break;
-	case HAL_MON_BUF_ADDR: {
-		struct dp_rxdma_mon_ring *buf_ring = &ab->dp.rxdma_mon_buf_ring;
-		const struct dp_mon_packet_info *packet_info = tlv_data;
-		int buf_id = u32_get_bits(packet_info->cookie,
-					  DP_RXDMA_BUF_COOKIE_BUF_ID);
-		struct sk_buff *msdu;
-		struct dp_mon_mpdu *mon_mpdu = pmon->mon_mpdu;
-		struct ath12k_skb_rxcb *rxcb;
-
-		spin_lock_bh(&buf_ring->idr_lock);
-		msdu = idr_remove(&buf_ring->bufs_idr, buf_id);
-		spin_unlock_bh(&buf_ring->idr_lock);
-
-		if (unlikely(!msdu)) {
-			ath12k_warn(ab, "monitor destination with invalid buf_id %d\n",
-				    buf_id);
-			return HAL_RX_MON_STATUS_PPDU_NOT_DONE;
-		}
-
-		rxcb = ATH12K_SKB_RXCB(msdu);
-		dma_unmap_single(ab->dev, rxcb->paddr,
-				 msdu->len + skb_tailroom(msdu),
-				 DMA_FROM_DEVICE);
-
-		if (mon_mpdu->tail)
-			mon_mpdu->tail->next = msdu;
-		else
-			mon_mpdu->tail = msdu;
-
-		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
-
-		break;
-	}
-	case HAL_RX_MSDU_END: {
-		const struct rx_msdu_end_qcn9274 *msdu_end = tlv_data;
-		bool is_first_msdu_in_mpdu;
-		u16 msdu_end_info;
-
-		msdu_end_info = __le16_to_cpu(msdu_end->info5);
-		is_first_msdu_in_mpdu = u32_get_bits(msdu_end_info,
-						     RX_MSDU_END_INFO5_FIRST_MSDU);
-		if (is_first_msdu_in_mpdu) {
-			pmon->mon_mpdu->head = pmon->mon_mpdu->tail;
-			pmon->mon_mpdu->tail = NULL;
-		}
-		break;
-	}
+	case HAL_MON_BUF_ADDR:
+		return HAL_RX_MON_STATUS_BUF_ADDR;
+	case HAL_RX_MSDU_END:
+		return HAL_RX_MON_STATUS_MSDU_END;
 	case HAL_RX_MPDU_END:
-		list_add_tail(&pmon->mon_mpdu->list, &pmon->dp_rx_mon_mpdu_list);
-		break;
+		return HAL_RX_MON_STATUS_MPDU_END;
 	case HAL_DUMMY:
 		return HAL_RX_MON_STATUS_BUF_DONE;
 	case HAL_RX_PPDU_END_STATUS_DONE:
@@ -1196,7 +1147,10 @@ ath12k_dp_mon_parse_rx_dest(struct ath12k_base *ab, struct ath12k_mon_data *pmon
 		if ((ptr - skb->data) >= DP_RX_BUFFER_SIZE)
 			break;
 
-	} while (hal_status == HAL_RX_MON_STATUS_PPDU_NOT_DONE);
+	} while ((hal_status == HAL_RX_MON_STATUS_PPDU_NOT_DONE) ||
+		 (hal_status == HAL_RX_MON_STATUS_BUF_ADDR) ||
+		 (hal_status == HAL_RX_MON_STATUS_MPDU_END) ||
+		 (hal_status == HAL_RX_MON_STATUS_MSDU_END));
 
 	return hal_status;
 }
diff --git a/drivers/net/wireless/ath/ath12k/hal_rx.h b/drivers/net/wireless/ath/ath12k/hal_rx.h
index e12734fd56bca..33fb765628c55 100644
--- a/drivers/net/wireless/ath/ath12k/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/hal_rx.h
@@ -108,6 +108,9 @@ enum hal_rx_mon_status {
 	HAL_RX_MON_STATUS_PPDU_NOT_DONE,
 	HAL_RX_MON_STATUS_PPDU_DONE,
 	HAL_RX_MON_STATUS_BUF_DONE,
+	HAL_RX_MON_STATUS_BUF_ADDR,
+	HAL_RX_MON_STATUS_MPDU_END,
+	HAL_RX_MON_STATUS_MSDU_END,
 };
 
 #define HAL_RX_MAX_MPDU		256
-- 
2.53.0



