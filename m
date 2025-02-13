Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC4126B086;
	Thu, 13 Feb 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458923; cv=none; b=mzMxVI/UFF7r7qRDyefY8HIxzcOGVQkCLnblUo16MSO9HKVFziZf2QS+W+QZZANhCQ5AQuMyLdsGsAuA/pnmQprSBGldoCw+V/+YVj9oxhFPYzByFcSrlt4Wow6QzzLVsBZkY4XTdEK8u5TJR/AjobwE3b9ybm/2kvUhuq8Ar+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458923; c=relaxed/simple;
	bh=f48UdBgLcVJQyU1VVe5NYmpGtKqi/T522WzULcIkiPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+KI4aBKZJu0ZLY9mI6x4la7PmQ/CMzElj2VzmklPmuvA2dmX4X8VBVQFkBEWtSkYB6R6SPcaFmFK5DAn5ZYkpucxd1Ox0FWbwCqZS/sy28pkARJh1pgJGtf2V9LtQQt/XvN6+1Nxzz1XWuGx4QLqbK6kdyvn5pVYPeCeh2If58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfuIdWgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfuIdWgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68C6C4CED1;
	Thu, 13 Feb 2025 15:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458923;
	bh=f48UdBgLcVJQyU1VVe5NYmpGtKqi/T522WzULcIkiPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfuIdWgOB780MNCFYy81NnPVZT6cuSfutPvcYfzqgg1YNWNSwvMZUOCQeuGElBUg2
	 9f4n6u59D1oLXWucUrw8z/J+dBb1v9vyHtmVOO8I6X3A9JIk/uOAcK3zhLYfmtPfvV
	 PcWKzbW5BhAA7YrYgwKtr1poWtCgMkvDdiZqCgwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 117/443] vmxnet3: Fix tx queue race condition with XDP
Date: Thu, 13 Feb 2025 15:24:42 +0100
Message-ID: <20250213142445.126993265@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>

[ Upstream commit 3f1baa91a1fdf3de9dbad4bd615b35fab347874b ]

If XDP traffic runs on a CPU which is greater than or equal to
the number of the Tx queues of the NIC, then vmxnet3_xdp_get_tq()
always picks up queue 0 for transmission as it uses reciprocal scale
instead of simple modulo operation.

vmxnet3_xdp_xmit() and vmxnet3_xdp_xmit_frame() use the above
returned queue without any locking which can lead to race conditions
when multiple XDP xmits run in parallel on different CPU's.

This patch uses a simple module scheme when the current CPU equals or
exceeds the number of Tx queues on the NIC. It also adds locking in
vmxnet3_xdp_xmit() and vmxnet3_xdp_xmit_frame() functions.

Fixes: 54f00cce1178 ("vmxnet3: Add XDP support.")
Signed-off-by: Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>
Signed-off-by: Ronak Doshi <ronak.doshi@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250131042340.156547-1-sankararaman.jayaraman@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_xdp.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.c b/drivers/net/vmxnet3/vmxnet3_xdp.c
index 1341374a4588a..616ecc38d1726 100644
--- a/drivers/net/vmxnet3/vmxnet3_xdp.c
+++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
@@ -28,7 +28,7 @@ vmxnet3_xdp_get_tq(struct vmxnet3_adapter *adapter)
 	if (likely(cpu < tq_number))
 		tq = &adapter->tx_queue[cpu];
 	else
-		tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
+		tq = &adapter->tx_queue[cpu % tq_number];
 
 	return tq;
 }
@@ -124,6 +124,7 @@ vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
 	u32 buf_size;
 	u32 dw2;
 
+	spin_lock_irq(&tq->tx_lock);
 	dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
 	dw2 |= xdpf->len;
 	ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
@@ -134,6 +135,7 @@ vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
 
 	if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
 		tq->stats.tx_ring_full++;
+		spin_unlock_irq(&tq->tx_lock);
 		return -ENOSPC;
 	}
 
@@ -142,8 +144,10 @@ vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
 		tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
 					       xdpf->data, buf_size,
 					       DMA_TO_DEVICE);
-		if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr))
+		if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr)) {
+			spin_unlock_irq(&tq->tx_lock);
 			return -EFAULT;
+		}
 		tbi->map_type |= VMXNET3_MAP_SINGLE;
 	} else { /* XDP buffer from page pool */
 		page = virt_to_page(xdpf->data);
@@ -182,6 +186,7 @@ vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
 	dma_wmb();
 	gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
 						  VMXNET3_TXD_GEN);
+	spin_unlock_irq(&tq->tx_lock);
 
 	/* No need to handle the case when tx_num_deferred doesn't reach
 	 * threshold. Backend driver at hypervisor side will poll and reset
@@ -225,6 +230,7 @@ vmxnet3_xdp_xmit(struct net_device *dev,
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(dev);
 	struct vmxnet3_tx_queue *tq;
+	struct netdev_queue *nq;
 	int i;
 
 	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
@@ -236,6 +242,9 @@ vmxnet3_xdp_xmit(struct net_device *dev,
 	if (tq->stopped)
 		return -ENETDOWN;
 
+	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
+
+	__netif_tx_lock(nq, smp_processor_id());
 	for (i = 0; i < n; i++) {
 		if (vmxnet3_xdp_xmit_frame(adapter, frames[i], tq, true)) {
 			tq->stats.xdp_xmit_err++;
@@ -243,6 +252,7 @@ vmxnet3_xdp_xmit(struct net_device *dev,
 		}
 	}
 	tq->stats.xdp_xmit += i;
+	__netif_tx_unlock(nq);
 
 	return i;
 }
-- 
2.39.5



