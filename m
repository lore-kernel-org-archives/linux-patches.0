Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1A827A462;
	Thu, 15 Jan 2026 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498636; cv=none; b=BFaHMAJOPLsL0+PhEakNMP1+/JwegMWNh0Tmqqzqo14CizxIP/hDgFMoFTqQAhjdS7HoeEVCNLjzrQQDLmWbWhU6wxVlc1gcJpFUvSWJutwF0RTPCn+qAX933CRoj2QUFUg/buCgBZL6ZSWeKHEaNI43p8gVVbVmpKNM0UzJor4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498636; c=relaxed/simple;
	bh=5qDZOPGacmfKkHxIZN3IbE5GCZiZ8Nqm1zmwDf4I/5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWALctI4CT6IyXm0/t9OJBvHvY+4tFD7Gs8ZUAJ1jrjNvEFz7CXqACNKKtAuRxhtmLDvW6Tw1b61/8ZWV5k6qEWDSdBPAVeN9OGjYiURjV5LJqps2sxq7rj2yfaVTEHjvxCqJCFHl78XQ2vYR2rcaMM7sFh83n4xd/FsAQWMwzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sE+53DrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sE+53DrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B7AC116D0;
	Thu, 15 Jan 2026 17:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498636;
	bh=5qDZOPGacmfKkHxIZN3IbE5GCZiZ8Nqm1zmwDf4I/5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sE+53DrVGQAEMbX7q9zGO1M83zKchrCc14MIPhLL5LXjpdavISVfgFyojU9eTkJzS
	 WSHBEnASlV9DglZu/eKWJVT/NJl5VyZdTj01uqkniXCoXz0qbxL1uIgOqprIxYi+BG
	 x+Nn9g9WmJgbRnDaNEtLCxofv15k5cBg915JsH2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 502/554] net: 3com: 3c59x: fix possible null dereference in vortex_probe1()
Date: Thu, 15 Jan 2026 17:49:28 +0100
Message-ID: <20260115164304.488460644@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1471,7 +1471,7 @@ static int vortex_probe1(struct device *
 		return 0;
 
 free_ring:
-	dma_free_coherent(&pdev->dev,
+	dma_free_coherent(gendev,
 		sizeof(struct boom_rx_desc) * RX_RING_SIZE +
 		sizeof(struct boom_tx_desc) * TX_RING_SIZE,
 		vp->rx_ring, vp->rx_ring_dma);


