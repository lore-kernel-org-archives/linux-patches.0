Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F92F188012;
	Tue, 30 Jul 2024 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356615; cv=none; b=J7bDZadslMTjCs3aDGs9GI3aJAwOrNsfkc4kUh+/50GcI8cdEPFugJRoz5JI/1DnOhOmNGjDKLtClJjmyCkDuARP6tydDKr71yKNVZqlY+1OUMQm74GNjRu3x3fX4CAoIU19i+k9tNEhHL4yH2cX44rFGa6oiJQPKtNT5RRNG9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356615; c=relaxed/simple;
	bh=aIv9wj+SslTbieHsRshcqb2DLWzk/6uKgQgrYH9JmAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQINnLP6eh8E8wyXeU2jioeEN4eyVAgKulU5Cs/ncTdAaqB62yY/DAsCIGU3XRGLmInEnFBSskpA/ikSWZ5xLK4BjbvpaJXRNweUg9zlYf/Eo4le1qg7ULEApV2BJO6UC5cSE7Qs5ud+WE6Rp/LeGL2yWxXcGiiDMQS043l9wfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Akl2Oq0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Akl2Oq0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FE7C4AF10;
	Tue, 30 Jul 2024 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356615;
	bh=aIv9wj+SslTbieHsRshcqb2DLWzk/6uKgQgrYH9JmAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Akl2Oq0D+OPbFVwxlxbBlTxGY6LkWwyF4y8aXnW74PvCLxrZ8DbKg1sb/6NI8MmcD
	 LkWJO7CtwaKTXY2FhcCgpEuYaxgbXYpexnGmHDdKw4bee33uThNbGCU2iADZ/gul4O
	 xeycuTNEqxRbYvv5hTZTEgp9Tn8d9nqZZgp8JK78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 167/809] wifi: ath12k: fix invalid memory access while processing fragmented packets
Date: Tue, 30 Jul 2024 17:40:43 +0200
Message-ID: <20240730151731.204331133@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5ed06c0d90e2b..bff8cf97a18c6 100644
--- a/drivers/net/wireless/ath/ath12k/hw.c
+++ b/drivers/net/wireless/ath/ath12k/hw.c
@@ -544,9 +544,6 @@ static const struct ath12k_hw_ring_mask ath12k_hw_ring_mask_qcn9274 = {
 	},
 	.rx_mon_dest = {
 		0, 0, 0,
-		ATH12K_RX_MON_RING_MASK_0,
-		ATH12K_RX_MON_RING_MASK_1,
-		ATH12K_RX_MON_RING_MASK_2,
 	},
 	.rx = {
 		0, 0, 0, 0,
@@ -572,8 +569,7 @@ static const struct ath12k_hw_ring_mask ath12k_hw_ring_mask_qcn9274 = {
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



