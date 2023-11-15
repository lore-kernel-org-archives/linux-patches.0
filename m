Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE703BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sms25CUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B1BC433C8;
	Wed, 15 Nov 2023 19:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076100;
	bh=pzkhAJ+GM+XsZrtcJ2goX5XF1El2njevqUq8YfG9OyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sms25CUPSbn7H61grDHMCAXjyo57vYg91N9vZ31Hl2nNkmdEaHtHy/E3JZ0hV4Yq7
	 Ty2EzTtlLWoGX/9ld1aEqrqCNFSoFqRDXLQjT4CEqzMp3XhDVdK39Uda9ccK/gSQfo
	 2nqWtxHNOequCXOoCwrALcgly0Yh6/N8b6HG8TtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 076/550] wifi: ath12k: fix DMA unmap warning on NULL DMA address
Date: Wed, 15 Nov 2023 14:11:00 -0500
Message-ID: <20231115191605.972710982@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 9ae8c496d211155a3f220b63da364fba1a794292 ]

In ath12k_dp_tx(), if we reach fail_dma_unmap due to some errors,
current code does DMA unmap unconditionally on skb_cb->paddr_ext_desc.
However, skb_cb->paddr_ext_desc may be NULL and thus we get below
warning:

kernel: [ 8887.076212] WARNING: CPU: 3 PID: 0 at drivers/iommu/dma-iommu.c:1077 iommu_dma_unmap_page+0x79/0x90

Fix it by checking skb_cb->paddr_ext_desc before unmap it.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230830021131.5610-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index d3c7c76d6b75e..5d1be6451d587 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -330,8 +330,11 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_vif *arvif,
 
 fail_unmap_dma:
 	dma_unmap_single(ab->dev, ti.paddr, ti.data_len, DMA_TO_DEVICE);
-	dma_unmap_single(ab->dev, skb_cb->paddr_ext_desc,
-			 sizeof(struct hal_tx_msdu_ext_desc), DMA_TO_DEVICE);
+
+	if (skb_cb->paddr_ext_desc)
+		dma_unmap_single(ab->dev, skb_cb->paddr_ext_desc,
+				 sizeof(struct hal_tx_msdu_ext_desc),
+				 DMA_TO_DEVICE);
 
 fail_remove_tx_buf:
 	ath12k_dp_tx_release_txbuf(dp, tx_desc, pool_id);
-- 
2.42.0



