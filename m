Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB05501295;
	Tue, 13 Oct 2026 12:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895769; cv=none; b=j410Z43dDO0K8mqqk69RkrU1Iki30AqNZABe39cSbIXfGI49o3xnOpzeqUQ/WJUGaYBfBYdNeIHiBUA0umWZ5KM8OC4b4nk1jCPJayarZ4SETgLnbBwn9peEJv8gnAsryO3EKCOmacohFYonURmN54fqZ4d4Ptt3vOZo/e7JFF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895769; c=relaxed/simple;
	bh=r1hyOOAF/dvmJPoizUpnx6oDvrgJ7MNWvyolni/BG8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehs4eSMe9hCsAavxKShg8T5GG0Gz7WXFXxCQFByn28PVxCCouPLkoaQzTMZV4F+iI8Rkkb/jMcmUD92PYKkllNFbWn/SQzMBxF/VVAZ3sPSyNTYgOKkDcbFBn63eZE9GHBiMgSBUtq4bAIwTKJhJqG6s9nWW22jZDses8J2L+QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fquPtoVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fquPtoVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE831F00893;
	Tue, 13 Oct 2026 12:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895767;
	bh=dalQsKk6I9qb/GNFWobNyR7YIP9lZ21QduPFWMC991A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fquPtoVIKZoC/0gYmSqOMiAnHz+0WuERkaNNAyZDO5A3By+pU4CMEhMxjL/9rorVC
	 huxOZQhRYZCK4AX76kKBx4z3RrTAqjTpBuXs+FG870YwSJ90qCIX7hGTtX/SdGgXqC
	 jNYsHFIuD6U4yzRk+AagbKzuBIQKVNMvA2rZKC5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 386/497] ibmveth: fix TX LTB and filter unwind on open-fail
Date: Tue, 13 Oct 2026 13:39:13 +0200
Message-ID: <20261013112917.056047268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -442,10 +442,15 @@ static void ibmveth_rxq_harvest_buffer(s
 
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
@@ -556,7 +561,7 @@ static int ibmveth_open(struct net_devic
 
 	for (i = 0; i < netdev->real_num_tx_queues; i++) {
 		if (ibmveth_allocate_tx_ltb(adapter, i))
-			goto out_free_tx_ltb;
+			goto out_unmap_filter_list;
 	}
 
 	adapter->rx_queue.index = 0;
@@ -634,10 +639,8 @@ out_unmap_filter_list:
 	dma_unmap_single(dev, adapter->filter_list_dma, 4096,
 			 DMA_BIDIRECTIONAL);
 
-out_free_tx_ltb:
-	while (--i >= 0) {
+	for (i = netdev->real_num_tx_queues - 1; i >= 0; i--)
 		ibmveth_free_tx_ltb(adapter, i);
-	}
 
 out_unmap_buffer_list:
 	dma_unmap_single(dev, adapter->buffer_list_dma, 4096,


