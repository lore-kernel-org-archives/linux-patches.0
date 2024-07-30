Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FB41A6196;
	Tue, 30 Jul 2024 16:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356145; cv=none; b=W7N5QtrWMoPnp8QoByzFp3zUPIOo/IA/qp4L6Jdtjk2GNVr2qOHmmY0Rc4eE/zO9lN0MVwy6SiiQrPBYnHzFdI/D59riWbEwb9LxxUFzqYGxIN1HtefUG/WTsmmalS3qOVmUatKUPNIxSa75HQkS/0mYyu2EsKie7MUblJlcFbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356145; c=relaxed/simple;
	bh=Do16e63fqmgQvmft6doRJ2vyVXQKZy7smb0JIgetdO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AWY6Y54k4t/sgoqt+wa+tWf/4vX9QGKcX7Kvn+AN35yVNqUAEG9JZ/hTGvnTmXVlRn3U+C01VDmyRbLm6QQ4fCwHBb51oZrrFzQCOW6BmKHjDjthMoccxCqGagGRN0FlmYtuyG2Rjz75xboqk87RQHaxI2OszC28J+FNer8/Ho0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHCCbKh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHCCbKh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D91CC32782;
	Tue, 30 Jul 2024 16:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356145;
	bh=Do16e63fqmgQvmft6doRJ2vyVXQKZy7smb0JIgetdO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHCCbKh590+P7Ujv/EEPwzungGuLZngsiNJlJcpdcEw7lH8PWIYMm4PYt9NG+Xo6f
	 H91lNDPLTYDv73+29/Aa6i0H5gDYaHKK+L0365PhHGSuFaknd42JrI29oIxJrxHb/k
	 10X0RLLAJLnv0DzN/OZu/SGvpev4NBL2xdybq/sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/568] wifi: ath12k: fix firmware crash during reo reinject
Date: Tue, 30 Jul 2024 17:43:45 +0200
Message-ID: <20240730151644.485754804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit a57ab7cced454f69b8ee8aa5f5019ea8de4674da ]

When handling fragmented packets, the ath12k driver reassembles each
fragment into a normal packet and then reinjects it into the HW ring.
However, a firmware crash occurs during this reinjection process.
The issue arises because the driver populates peer metadata in
reo_ent_ring->queue_addr_lo, while the firmware expects the physical
address obtained from the corresponding peer’s queue descriptor. Fix it
by filling peer's queue descriptor's physical address in queue_addr_lo.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00209-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240520070045.631029-4-quic_ppranees@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index fb51cab23b623..2c17b1e7681a5 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2988,7 +2988,7 @@ static int ath12k_dp_rx_h_defrag_reo_reinject(struct ath12k *ar,
 	struct hal_srng *srng;
 	dma_addr_t link_paddr, buf_paddr;
 	u32 desc_bank, msdu_info, msdu_ext_info, mpdu_info;
-	u32 cookie, hal_rx_desc_sz, dest_ring_info0;
+	u32 cookie, hal_rx_desc_sz, dest_ring_info0, queue_addr_hi;
 	int ret;
 	struct ath12k_rx_desc_info *desc_info;
 	u8 dst_ind;
@@ -3080,13 +3080,11 @@ static int ath12k_dp_rx_h_defrag_reo_reinject(struct ath12k *ar,
 	reo_ent_ring->rx_mpdu_info.peer_meta_data =
 		reo_dest_ring->rx_mpdu_info.peer_meta_data;
 
-	/* Firmware expects physical address to be filled in queue_addr_lo in
-	 * the MLO scenario and in case of non MLO peer meta data needs to be
-	 * filled.
-	 * TODO: Need to handle for MLO scenario.
-	 */
-	reo_ent_ring->queue_addr_lo = reo_dest_ring->rx_mpdu_info.peer_meta_data;
-	reo_ent_ring->info0 = le32_encode_bits(dst_ind,
+	reo_ent_ring->queue_addr_lo = cpu_to_le32(lower_32_bits(rx_tid->paddr));
+	queue_addr_hi = upper_32_bits(rx_tid->paddr);
+	reo_ent_ring->info0 = le32_encode_bits(queue_addr_hi,
+					       HAL_REO_ENTR_RING_INFO0_QUEUE_ADDR_HI) |
+			      le32_encode_bits(dst_ind,
 					       HAL_REO_ENTR_RING_INFO0_DEST_IND);
 
 	reo_ent_ring->info1 = le32_encode_bits(rx_tid->cur_sn,
-- 
2.43.0



