Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186643D413D;
	Wed,  4 Feb 2026 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216836; cv=none; b=FM2y07TVawjStEcDUKgmyIaZn24fm6DSlWQxv5IvsaQtz1628hYlwLCysQduWAiBYDbmprc2OOtl1mK3i0sClwtgFvIQ6Tx7EvLFizG68LtvfI885ry4AHZR8RcowNs6/ZM5cwNiKh6pYIq59YScy7hLB5s9CaooBNDw39OQlUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216836; c=relaxed/simple;
	bh=+x07LyIQIgVHHZ9D2s/81TwwVIPITkDFyL8/VX21Zq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dj2YLdwO87UORVka1U8szmCN3w808Rk3grFWEY4FyPRPKNogGif9w5Lr8acWFpbPyImx+A3Q+nkr3cF9/MEqP30iXXRwx/qOHZ3HohBY6r+AATATxtn159tW1QFeW0D8u2dlbxtcLdOl5N10HoxyUAB7gbp/7YLBpgeK5qKVW/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysSt/WpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysSt/WpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822C9C4CEF7;
	Wed,  4 Feb 2026 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216836;
	bh=+x07LyIQIgVHHZ9D2s/81TwwVIPITkDFyL8/VX21Zq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysSt/WpX37atOdOCj3NC/0RDAtVyj/43LRdgo+Jqnfx6PyB5eNo7GKLvo931wgt5H
	 Lskr8bSxY7535jleKlnROad71YG9Pqxm1F8ARotTP2A6qmiXM2zSrqkEooKqb4AX2G
	 rjfS3IbDsJHci8qnSmVGcq+l8kjJ/LGVSs8nSdFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 045/206] dmaengine: at_hdmac: fix device leak on of_dma_xlate()
Date: Wed,  4 Feb 2026 15:37:56 +0100
Message-ID: <20260204143859.834305111@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit b9074b2d7a230b6e28caa23165e9d8bc0677d333 upstream.

Make sure to drop the reference taken when looking up the DMA platform
device during of_dma_xlate() when releasing channel resources.

Note that commit 3832b78b3ec2 ("dmaengine: at_hdmac: add missing
put_device() call in at_dma_xlate()") fixed the leak in a couple of
error paths but the reference is still leaking on successful allocation.

Fixes: bbe89c8e3d59 ("at_hdmac: move to generic DMA binding")
Fixes: 3832b78b3ec2 ("dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()")
Cc: stable@vger.kernel.org	# 3.10: 3832b78b3ec2
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-2-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1339,6 +1339,7 @@ static int atc_config(struct dma_chan *c
 		      struct dma_slave_config *sconfig)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma_slave	*atslave;
 
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
@@ -1598,8 +1599,12 @@ static void atc_free_chan_resources(stru
 	/*
 	 * Free atslave allocated in at_dma_xlate()
 	 */
-	kfree(chan->private);
-	chan->private = NULL;
+	atslave = chan->private;
+	if (atslave) {
+		put_device(atslave->dma_dev);
+		kfree(atslave);
+		chan->private = NULL;
+	}
 
 	dev_vdbg(chan2dev(chan), "free_chan_resources: done\n");
 }


