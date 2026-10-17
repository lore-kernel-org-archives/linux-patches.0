Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EBF3BBFB3;
	Sat, 17 Oct 2026 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257215; cv=none; b=rUftKnyuNpWe0EcKCdXQKx6z50+0GwYWIqf+1I4H4FAoyv6sq6NR7/ORdBosA91w4IDXGoT+wIy+PgAgmg/HxPF7BG/nEgB8phCVQVTZfK/30DohSDvA59yQXvrJMvaRPS+YXC2wrAlJuPUlaPNvAjMDztDkRTL4cGIxc7WytmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257215; c=relaxed/simple;
	bh=sCaYxykDffECSP4cTK4Q5ZMENHDS30Phtrq10nxsBPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Whx3MtB95VcU2HA3XhOZJ3ao6XApZ3KnPQaa8v2dUR3k8XkfmEHeuD605CgFWnAkbcsgqunakiMhhVBiZJ5ClNXVRCPlFeRubukq6ibubeHQCQTLcQiOXhjI6S9lfgbHaX7Rx0VSoW9B65ERkrPAEuf9smzWaWPwzsTTgKrM8qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvFKhSOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvFKhSOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2D91F000C4;
	Sat, 17 Oct 2026 17:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257214;
	bh=U4gaB/EeHwIA6MhmAVwezDc/76ZE+sX+uKPjSv3fSg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvFKhSOhI6I3F4iLhkMTQdZDiw9hB42hPUOtBZhrc43cgWcEDVsEwxZP+o4UnOZ+s
	 uZh7Cgv+a7IP8ONcOZwEHl64RXPK6nFf2YidNj9O4dnKHNz9ivRh7JPhOV+jrxQXZZ
	 4vo3XoaUv4xHjh2yowvJGIxMuexrRA8xMYC4N+P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0489/1674] ibmveth: fix TX LTB and filter unwind on open-fail
Date: Sat, 17 Oct 2026 17:46:01 +0200
Message-ID: <20261017160443.664729730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingming Cao <mmc@linux.ibm.com>

commit 84bec0bf035258a1073ffd6f6dc8ea61806aa7d4 upstream.

out_free_buffer_pools reuses open()'s loop index for the TX LTB
walk. After the pool unwind i is -1, so the TX buffers allocated
earlier are leaked. request_irq() failure has the same leak.

The TX-fail goto on that walk also skips dma_unmap of the filter
list (pre-existing since the LTB was added). Rewrite the TX walk
to real_num_tx_queues with a pointer check, and unmap the filter
list before those frees.

Fixes: d926793c1de9 ("ibmveth: Implement multi queue on xmit")
Cc: stable@vger.kernel.org
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
Link: https://patch.msgid.link/d14314c2b10f125f5e578782484ba3cc50564d53.1790357373.git.mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -465,10 +465,15 @@ static void ibmveth_rxq_harvest_buffer(s
 
 static void ibmveth_free_tx_ltb(struct ibmveth_adapter *adapter, int idx)
 {
+	void *ptr = adapter->tx_ltb_ptr[idx];
+
+	if (!ptr)
+		return;
+
+	adapter->tx_ltb_ptr[idx] = NULL;
 	dma_unmap_single(&adapter->vdev->dev, adapter->tx_ltb_dma[idx],
 			 adapter->tx_ltb_size, DMA_TO_DEVICE);
-	kfree(adapter->tx_ltb_ptr[idx]);
-	adapter->tx_ltb_ptr[idx] = NULL;
+	kfree(ptr);
 }
 
 static int ibmveth_allocate_tx_ltb(struct ibmveth_adapter *adapter, int idx)
@@ -579,7 +584,7 @@ static int ibmveth_open(struct net_devic
 
 	for (i = 0; i < netdev->real_num_tx_queues; i++) {
 		if (ibmveth_allocate_tx_ltb(adapter, i))
-			goto out_free_tx_ltb;
+			goto out_unmap_filter_list;
 	}
 
 	adapter->rx_queue.index = 0;
@@ -657,10 +662,8 @@ out_unmap_filter_list:
 	dma_unmap_single(dev, adapter->filter_list_dma, 4096,
 			 DMA_BIDIRECTIONAL);
 
-out_free_tx_ltb:
-	while (--i >= 0) {
+	for (i = netdev->real_num_tx_queues - 1; i >= 0; i--)
 		ibmveth_free_tx_ltb(adapter, i);
-	}
 
 out_unmap_buffer_list:
 	dma_unmap_single(dev, adapter->buffer_list_dma, 4096,


