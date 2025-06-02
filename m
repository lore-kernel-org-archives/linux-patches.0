Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF97221F3E;
	Mon,  2 Jun 2025 14:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875336; cv=none; b=uKbuRLQD4CoSdo9PvdM9/0VE9vCqioU2QZST7GH8B2cwRxCO3TlhyGYHOpDoFNbNmm4T9cKgvkVxQ1MctdtIvLeZMOmG0Iq13onmjPz+YGXpGFiHs3XDs0Sl6Rg/zrw8RG6SKWaYFI9SGGHUOHkn+t7wBdZTA7AcRJaW5+3wghE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875336; c=relaxed/simple;
	bh=lZTwK7Gs7NmzzHGA1xN8NLtgl2hvZtnpyRT0tu1apcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoN/+sCNL4HCRkQcDwoSkl9T4ViGS+sOE32ozCKPkKzdq+SxQPGO9/SSakSFL1HRK7Y2MhDOkvB66McU/hMCoTLWDyq7/cfnhRVQGqIieXkARSpUNgToW+FzA+LkGi7UO+ucMWa6F9rPykwZM/QHmUSDd324CU9gAyzmoJvE3bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBkJSBdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBkJSBdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B604C4CEEB;
	Mon,  2 Jun 2025 14:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875336;
	bh=lZTwK7Gs7NmzzHGA1xN8NLtgl2hvZtnpyRT0tu1apcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBkJSBdVHyekMmEEIYIO4bilJ+LYhbKm66Uf3CnB+q/bRKMYQllf/SZxOpsz4ERHI
	 0wAlUOEOFo7YWFDnZXbJVmIDd3/Fwb/NsunrxZJ8CwPUjwFHRz4cksGg+1FHIZnMZL
	 BPpKFfOT4Cw59PIYMHJ73cx5kNTWFVQTpG1vWE2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 103/270] dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy
Date: Mon,  2 Jun 2025 15:46:28 +0200
Message-ID: <20250602134311.442978267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

commit 8ca9590c39b69b55a8de63d2b21b0d44f523b43a upstream.

Currently, a local dma_cap_mask_t variable is used to store device
cap_mask within udma_of_xlate(). However, the DMA_PRIVATE flag in
the device cap_mask can get cleared when the last channel is released.
This can happen right after storing the cap_mask locally in
udma_of_xlate(), and subsequent dma_request_channel() can fail due to
mismatch in the cap_mask. Fix this by removing the local dma_cap_mask_t
variable and directly using the one from the dma_device structure.

Fixes: 25dcb5dd7b7c ("dmaengine: ti: New driver for K3 UDMA")
Cc: stable@vger.kernel.org
Signed-off-by: Vaishnav Achath <vaishnav.a@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Link: https://lore.kernel.org/r/20250417075521.623651-1-y-abhilashchandra@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3082,7 +3082,6 @@ static struct dma_chan *udma_of_xlate(st
 				      struct of_dma *ofdma)
 {
 	struct udma_dev *ud = ofdma->of_dma_data;
-	dma_cap_mask_t mask = ud->ddev.cap_mask;
 	struct udma_filter_param filter_param;
 	struct dma_chan *chan;
 
@@ -3095,7 +3094,7 @@ static struct dma_chan *udma_of_xlate(st
 	else
 		filter_param.atype = 0;
 
-	chan = __dma_request_channel(&mask, udma_dma_filter_fn, &filter_param,
+	chan = __dma_request_channel(&ud->ddev.cap_mask, udma_dma_filter_fn, &filter_param,
 				     ofdma->of_node);
 	if (!chan) {
 		dev_err(ud->dev, "get channel fail in %s.\n", __func__);


