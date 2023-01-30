Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F14328F3
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7172C433EF;
	Mon, 30 Jan 2023 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087169;
	bh=GvCjlzqeA8wgR51UVUNVLk5fuzCR5BNYE1M4MkK+6BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e73X6DlU9XxcXPfoHLPnFFHhQdXkEqFx+Kq6eFQ/qGGJEVVk64PZCTxje2uc/mhAF
	 K0rmME1azedZXemmmEHq8dIfCH9K1re9AfCf4dou11U5SSaftEp2rBJ7yPP/DGr4cX
	 31Cbt+RVHccrEIxJrwLNbnYpsglC1vy7aa5oMPUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/313] dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()
Date: Mon, 30 Jan 2023 14:49:15 +0100
Message-Id: <20230130134342.251766831@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 596b53ccc36a546ab28e8897315c5b4d1d5a0200 ]

Since for_each_child_of_node() will increase the refcount of node, we need
to call of_node_put() manually when breaking out of the iteration.

Fixes: 9cd4360de609 ("dma: Add Xilinx AXI Video Direct Memory Access Engine driver support")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Link: https://lore.kernel.org/r/20221122021612.1908866-1-liushixin2@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 8cd4e69dc7b4..766017570488 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3141,8 +3141,10 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	/* Initialize the channels */
 	for_each_child_of_node(node, child) {
 		err = xilinx_dma_child_probe(xdev, child);
-		if (err < 0)
+		if (err < 0) {
+			of_node_put(child);
 			goto error;
+		}
 	}
 
 	if (xdev->dma_config->dmatype == XDMA_TYPE_VDMA) {
-- 
2.39.0



