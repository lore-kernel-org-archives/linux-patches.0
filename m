Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743061FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F291BC433A0;
	Fri,  3 Feb 2023 10:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419510;
	bh=T9VIyIm1xO5cjFvakPl7Bn+647iGGVdR06RocoiRhtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nt9sOsgWVzxmY8cmuD7SMBa1b6FycWFK2gPN84HpNrGQ4HjEulnwPy7Y/mx2tzOHk
	 zR6Y9oDYg5uF9qdxTuhxDJMw78SAROQ9PuPAsM4wtNrNm0FroM4hmAQfiY0dCcyWT+
	 ovWLYd1mEscsgzHRkgnI/Xdi0GzeHPj923QNdKZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/80] dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()
Date: Fri,  3 Feb 2023 11:12:22 +0100
Message-Id: <20230203101016.370368918@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
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
index c56ce7cd1f6f..5f9945651e95 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2759,8 +2759,10 @@ static int xilinx_dma_probe(struct platform_device *pdev)
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



