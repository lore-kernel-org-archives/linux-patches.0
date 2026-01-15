Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D852C028F;
	Thu, 15 Jan 2026 17:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496497; cv=none; b=XN/7Zf6WlPPACpIC3Qw6k7YPQRtmdV3W3a4ThYe1FfXMqbuTLSL+m7hzrZG+L7UGjAHE5PzjAuhaoa/p+aqH2QatvU+SYkNkN52vnFLULxgaXe/pRRalqpjemQL7+abjmCMAOneM8AP7/T8C5h9EC4ltbaMSqdCCjUG8H+oN7hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496497; c=relaxed/simple;
	bh=5K+L2CnkXqUldObtuZz6EJKM0WICZ9CUAfGrNwNXbrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkUVsC/h0ivhpNsXH/smLdoFWulVxiDRlebVQQHZxjXnTKV54v72XSFOL0sGxGkUBeW/kj6pNHcTCbeYHVCqu6h32TQ1ETfvRf4r/n+L8UUg2bOgtXGGvnPlwLjkgsIyoZzNuNQWhcJ9luvV+xYyqVodFg/126IeyxGmfflLhpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOqbe77f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOqbe77f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3935FC19422;
	Thu, 15 Jan 2026 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496497;
	bh=5K+L2CnkXqUldObtuZz6EJKM0WICZ9CUAfGrNwNXbrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOqbe77fqdYdZ0tbwPOWjrQan/3pTLpQdkMlGc/1e9FQSgc/oLiXrQrYWYvFjQ/w5
	 dzRBEHjRnWCUOauHjK4at1UmlvApad5ONcXdI0ci+CmDGXxDGdsN2ND4unNstfQx5U
	 kNDAqnn9EHvKNzE3TS7fOYA9Kt4PHSIrzV8pmwrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 008/119] net: 3com: 3c59x: fix possible null dereference in vortex_probe1()
Date: Thu, 15 Jan 2026 17:47:03 +0100
Message-ID: <20260115164152.258972547@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit a4e305ed60f7c41bbf9aabc16dd75267194e0de3 upstream.

pdev can be null and free_ring: can be called in 1297 with a null
pdev.

Fixes: 55c82617c3e8 ("3c59x: convert to generic DMA API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260106094731.25819-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/3com/3c59x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1473,7 +1473,7 @@ static int vortex_probe1(struct device *
 		return 0;
 
 free_ring:
-	dma_free_coherent(&pdev->dev,
+	dma_free_coherent(gendev,
 		sizeof(struct boom_rx_desc) * RX_RING_SIZE +
 		sizeof(struct boom_tx_desc) * TX_RING_SIZE,
 		vp->rx_ring, vp->rx_ring_dma);


