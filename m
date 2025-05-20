Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2602517B3;
	Tue, 20 May 2025 14:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750802; cv=none; b=BtckNDNq1rUZxZi18+MY28S2uwMtSey9rpek1Gu1XDeA1fY+6mfOUWv3R9E0dRR74cE9Hnp6LgFPbOpphoYjkWfguP9qrnwCmKs4/CGHuvkkKFsLRKpuAMo7+r2fIasJObjdmwRJJQuYulhY5kaloceqfmLrnynvlntaJMtQPWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750802; c=relaxed/simple;
	bh=JyreFUL1VL4yKE47wIVHN6HNWdiUeTjVFh5YyFxtegI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJ1glTMl3UQZ2Q8uTs2/f94V8eobfjAYRWMfu8RpaQCFFnbZucJtKAny147bzXSbM6F/F99LDJNPfV63mTBvnoi5+DY+gfgS/WQ4yfUwB9u11USi5uOKl+gb8pvkBefPfngpRILgsPLDXO5BD8Gf4VdcCa+prYn1kHTcnIFYC38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCT9zb9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCT9zb9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC65C4CEE9;
	Tue, 20 May 2025 14:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750801;
	bh=JyreFUL1VL4yKE47wIVHN6HNWdiUeTjVFh5YyFxtegI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCT9zb9z4Z6IemcyHcEXCC27k7kTj04nfve+qXEt6GFsTe8dP74EqE50x21NMTkvm
	 9GoMJC1Jyf5/govdCHflw65LVWRrHwn1EO7pfKWWQsXk26RXwed179cL3eS7vIau34
	 qKB9B324gyH9KPFXYywpPkwOd8hRSxEHnQuClVq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.14 126/145] dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy
Date: Tue, 20 May 2025 15:51:36 +0200
Message-ID: <20250520125815.482754841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4253,7 +4253,6 @@ static struct dma_chan *udma_of_xlate(st
 				      struct of_dma *ofdma)
 {
 	struct udma_dev *ud = ofdma->of_dma_data;
-	dma_cap_mask_t mask = ud->ddev.cap_mask;
 	struct udma_filter_param filter_param;
 	struct dma_chan *chan;
 
@@ -4285,7 +4284,7 @@ static struct dma_chan *udma_of_xlate(st
 		}
 	}
 
-	chan = __dma_request_channel(&mask, udma_dma_filter_fn, &filter_param,
+	chan = __dma_request_channel(&ud->ddev.cap_mask, udma_dma_filter_fn, &filter_param,
 				     ofdma->of_node);
 	if (!chan) {
 		dev_err(ud->dev, "get channel fail in %s.\n", __func__);


