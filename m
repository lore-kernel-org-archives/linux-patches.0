Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8381A6189;
	Tue, 30 Jul 2024 16:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356135; cv=none; b=a7HAxozKKX7ADkRVZN3ihNNwDUeV03iyNaqqd1Y5fQbazXnr7joyRQ8JpXHJqEQ2AlUpezjzq7q2bqWNbMAb2TBB8nDPLtzL0og7Pn4IL0dAgQW89ui0uEgjnQi/LONXVlB1ZOVslqYPiUd7aw0ptecwdHzODscy0tVtX9qdFOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356135; c=relaxed/simple;
	bh=VoKOR1l6DmIlZreRY7lxldOD9UBSW+gOGDfr7sywx+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQ00Z5yaLGmwrNY+izaP8Ik73YJb9Gb/s3VzvZ+u0HeHLMz6hbUfA1ewYwG8uAOICwR+MBhJ9TmrK3RQkimi3AdCp7wrC2DtM4nbpNzchMeCHQZ/1aRZsrS6WqqTKdHLAPT5ggtZ/aIvOkrGr/WNMsVkt7JYwZEgDR/WZUtEFyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDcLOr3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDcLOr3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705FBC32782;
	Tue, 30 Jul 2024 16:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356134;
	bh=VoKOR1l6DmIlZreRY7lxldOD9UBSW+gOGDfr7sywx+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDcLOr3ipDGU7A8R3VfiEkxkWQS7QJ7ofZMH/uD0WTy6ANH6/0cINCwejX42a5dNv
	 V5/xCfqttsq4xQQ4yovufT6x5aiHTSX0tqApSCOrk9exUlmZAj1J8qwfN2W32NqwPJ
	 WPNare+C501KPvXAyo/fj4c63DbI3iQwoLPjssoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/568] wifi: ath12k: fix invalid memory access while processing fragmented packets
Date: Tue, 30 Jul 2024 17:43:44 +0200
Message-ID: <20240730151644.447208069@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 073f9f249eecd64ab9d59c91c4a23cfdcc02afe4 ]

The monitor ring and the reo reinject ring share the same ring mask index.
When the driver receives an interrupt for the reo reinject ring, the
monitor ring is also processed, leading to invalid memory access. Since
monitor support is not yet enabled in ath12k, the ring mask for the monitor
ring should be removed.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00209-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240520070045.631029-3-quic_ppranees@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hw.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.c b/drivers/net/wireless/ath/ath12k/hw.c
index 96ad8807a9a88..dafd7c34d7465 100644
--- a/drivers/net/wireless/ath/ath12k/hw.c
+++ b/drivers/net/wireless/ath/ath12k/hw.c
@@ -540,9 +540,6 @@ static const struct ath12k_hw_ring_mask ath12k_hw_ring_mask_qcn9274 = {
 	},
 	.rx_mon_dest = {
 		0, 0, 0,
-		ATH12K_RX_MON_RING_MASK_0,
-		ATH12K_RX_MON_RING_MASK_1,
-		ATH12K_RX_MON_RING_MASK_2,
 	},
 	.rx = {
 		0, 0, 0, 0,
@@ -568,8 +565,7 @@ static const struct ath12k_hw_ring_mask ath12k_hw_ring_mask_qcn9274 = {
 		ATH12K_HOST2RXDMA_RING_MASK_0,
 	},
 	.tx_mon_dest = {
-		ATH12K_TX_MON_RING_MASK_0,
-		ATH12K_TX_MON_RING_MASK_1,
+		0, 0, 0,
 	},
 };
 
-- 
2.43.0



