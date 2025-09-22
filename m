Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563CA2F1FDD;
	Mon, 22 Sep 2025 19:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569790; cv=none; b=VWPjv3/azx1FCipF7HPu/x7A9Bmu8/lxRVrEzi+QlHIU71ncD4eGRQ2/3jIIOxL3jkn4+dHikjHILZGJaRDakXW4u4OGwLfGAXZRnFgJdlH79fAZZnHMRGQ8DliYmjeQRFObTSdkQFnhBuYjBZgL3TEB+qp1F/w0Fu+kYjYQmU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569790; c=relaxed/simple;
	bh=mu6MInHChtZwsvyig1MNMJJFV+DIpAoMFsfixexogu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu9B2NWsJMyxicNDCykY9N9AxU19VjLAMnx89c9AmEGVNJLLDbgy7O/pJGYqFgzIC4mIIGjy4OSMzhEm6qC5ED0Vr6mwP+NKvJCidVeEoU2nwJsesbw2PgcyT8b91k/AibYUkJWgOSCAkNl0zr63Kx0pcF1os6mUCRxRunwaQ3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEFar+am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEFar+am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC4FC4CEF0;
	Mon, 22 Sep 2025 19:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569789;
	bh=mu6MInHChtZwsvyig1MNMJJFV+DIpAoMFsfixexogu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEFar+amrrMj0tMt0ZYHveD9Zqc6Bg6ZTcWjLsNUdFNzn5xRiNcqSZImLdeAiLIXy
	 qJSYcQRBsLcNfyRMTVO9hC1LRileqtZndfkgeovmm4/E9ubZzomcDFm5VCV+L6hNXa
	 QkVutBoKbzfQRVSYBwCDYUmAvTOxUIB9vVBCPKJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.6 57/70] vmxnet3: unregister xdp rxq info in the reset path
Date: Mon, 22 Sep 2025 21:29:57 +0200
Message-ID: <20250922192406.132680350@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>

commit 0dd765fae295832934bf28e45dd5a355e0891ed4 upstream.

vmxnet3 does not unregister xdp rxq info in the
vmxnet3_reset_work() code path as vmxnet3_rq_destroy()
is not invoked in this code path. So, we get below message with a
backtrace.

Missing unregister, handled but fix driver
WARNING: CPU:48 PID: 500 at net/core/xdp.c:182
__xdp_rxq_info_reg+0x93/0xf0

This patch fixes the problem by moving the unregister
code of XDP from vmxnet3_rq_destroy() to vmxnet3_rq_cleanup().

Fixes: 54f00cce1178 ("vmxnet3: Add XDP support.")
Signed-off-by: Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>
Signed-off-by: Ronak Doshi <ronak.doshi@broadcom.com>
Link: https://patch.msgid.link/20250320045522.57892-1-sankararaman.jayaraman@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Ajay: Modified to apply on v6.6, v6.12 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1981,6 +1981,11 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_que
 
 	rq->comp_ring.gen = VMXNET3_INIT_GEN;
 	rq->comp_ring.next2proc = 0;
+
+	if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
+		xdp_rxq_info_unreg(&rq->xdp_rxq);
+	page_pool_destroy(rq->page_pool);
+	rq->page_pool = NULL;
 }
 
 
@@ -2021,11 +2026,6 @@ static void vmxnet3_rq_destroy(struct vm
 		}
 	}
 
-	if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
-		xdp_rxq_info_unreg(&rq->xdp_rxq);
-	page_pool_destroy(rq->page_pool);
-	rq->page_pool = NULL;
-
 	if (rq->data_ring.base) {
 		dma_free_coherent(&adapter->pdev->dev,
 				  rq->rx_ring[0].size * rq->data_ring.desc_size,


