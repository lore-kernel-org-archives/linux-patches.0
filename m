Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFF64F3937;
	Tue, 13 Oct 2026 12:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892968; cv=none; b=UamX+nEIvC5RWnfnROk4u04oTQIX8QWUmaaLGNlCM5g9tv6hzT/+Nv2gBf/zvE5vcIJXAwm1KA0FiyJZURtazR7qswlRTzeA3X4ePYzSOxywpnWA14a9+jTtvrTPoD+qQkKrW810nIKxUgNSrldiNMg9XoabPzDFCxV2wwkITic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892968; c=relaxed/simple;
	bh=Fw3Uf/E/EfMnafMjSA8Oxv6GQ5J0q9XF9Mreh9rUA6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siIq9QQ+hO4jHtTK59oBuswQto82hGrFhKFKiOIX6U6jeVnl7/1mlF6HuVS/Y+COyEQxKcxZDJkcx+XGPtoKdI+tm7PGbvbA8oZsERDl5smSQ9ZN3gEDitKBhFmsqHOa8ZLAi9VjS4Mdole6aJA0pqYPCqF914b4BtF913dse8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2z82wQj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2z82wQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABB51F000FF;
	Tue, 13 Oct 2026 12:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892967;
	bh=9z+secRDk1Fju3EvxAptHjPssX9f/AtLJswTQh/nv5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2z82wQjbw78M2Kf8dCX+625+KekjvjdflHPgLCB1YL1EkaQi+FWstapBpT0y8LU6
	 KLTcUiR2Vey2HPlLQXDZBHMsS03aZtXA7eEQVTsjF5TNJSe3LKMVj9s0uNDRlCeL72
	 ebW6+WAxFEKWtlrAnJ/FeE/LnYX142Scl2n4OF4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 061/621] ibmveth: fix TX LTB and filter unwind on open-fail
Date: Tue, 13 Oct 2026 13:30:56 +0200
Message-ID: <20261013112922.310156419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
@@ -553,10 +553,15 @@ static int ibmveth_rxq_harvest_buffer(st
 
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
@@ -667,7 +672,7 @@ static int ibmveth_open(struct net_devic
 
 	for (i = 0; i < netdev->real_num_tx_queues; i++) {
 		if (ibmveth_allocate_tx_ltb(adapter, i))
-			goto out_free_tx_ltb;
+			goto out_unmap_filter_list;
 	}
 
 	adapter->rx_queue.index = 0;
@@ -745,10 +750,8 @@ out_unmap_filter_list:
 	dma_unmap_single(dev, adapter->filter_list_dma, 4096,
 			 DMA_BIDIRECTIONAL);
 
-out_free_tx_ltb:
-	while (--i >= 0) {
+	for (i = netdev->real_num_tx_queues - 1; i >= 0; i--)
 		ibmveth_free_tx_ltb(adapter, i);
-	}
 
 out_unmap_buffer_list:
 	dma_unmap_single(dev, adapter->buffer_list_dma, 4096,


