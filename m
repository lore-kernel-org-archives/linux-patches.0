Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EE122DF87;
	Tue, 20 May 2025 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749889; cv=none; b=pqsAz/w+AI1fHSJrjiZLBjM8BhOpBxv7GevY7Zs7fOVsqh01HD1kVrOp6nW12Wbv3Bx7fHqbxd31DooKzKec0KL+8KlOkgrhnRJY8LUZZneUYQsrQkyU9ug91DM4gQaJd5HWFxuxH3Y8YKnGWuROcjqhyIjSeaFbx02v+c/7LRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749889; c=relaxed/simple;
	bh=simiqPMec3l/Lk2DWn8JJ+mU384xyIcGPzVQ6gr6lNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8Z/Io4ZzDizPTtM92L5+OZDEpJxra/h3KdQKLMRSynwusfJehjtdF8lDbzPkJ0YegySSislgC8dyqUaLFENDAtUi/K+Z4xIKBAYWzdBNp6+HGWDvsQPC10sKFXMPSwqdR0pAImd4E5agdPdny48dw7NqjYSwvfT7kni9V2t8iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f175cPes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f175cPes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA5FC4CEE9;
	Tue, 20 May 2025 14:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749889;
	bh=simiqPMec3l/Lk2DWn8JJ+mU384xyIcGPzVQ6gr6lNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f175cPesIZ+O9+U0dfAGe+brIx+JEMdc5RfvHOfyu+j8hEWIb3NSBA13XTjsmEgwW
	 D/k5ODzvUf6D6USOd7f/XtLwrPx7CFtjg4JNidy2OzEmqIApRqqn6aigw0ofZeMJbp
	 dPhJTNtU35R29mdFTCo8ZUOHUPrkJS0tj3sZk4HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 093/117] dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy
Date: Tue, 20 May 2025 15:50:58 +0200
Message-ID: <20250520125807.678525142@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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
@@ -4221,7 +4221,6 @@ static struct dma_chan *udma_of_xlate(st
 				      struct of_dma *ofdma)
 {
 	struct udma_dev *ud = ofdma->of_dma_data;
-	dma_cap_mask_t mask = ud->ddev.cap_mask;
 	struct udma_filter_param filter_param;
 	struct dma_chan *chan;
 
@@ -4253,7 +4252,7 @@ static struct dma_chan *udma_of_xlate(st
 		}
 	}
 
-	chan = __dma_request_channel(&mask, udma_dma_filter_fn, &filter_param,
+	chan = __dma_request_channel(&ud->ddev.cap_mask, udma_dma_filter_fn, &filter_param,
 				     ofdma->of_node);
 	if (!chan) {
 		dev_err(ud->dev, "get channel fail in %s.\n", __func__);


