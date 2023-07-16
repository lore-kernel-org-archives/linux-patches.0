Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60DA8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A349C433C8;
	Sun, 16 Jul 2023 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540349;
	bh=HahyngdU4YLH4XeS8W56X4Sk1hcu4TQrq9qe4pLGO1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlSNYRnOp1bsUSpYu6pDhZI+xdlzFuMR5gEVanTFwcSTHDN5uKvRDl/T7w1xj6+kD
	 /qbvJPy+VKy4Hv2DiEE/CveuMkJc9JlIirxukQE2u89YAnMHk1RFEzz+Gs6qH/Fp9U
	 UvMCG47F4JbiZ7pTbHJ7nu3bF9rGmSOxzHY9FYLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 331/591] PCI: endpoint: functions/pci-epf-test: Fix dma_chan direction
Date: Sun, 16 Jul 2023 21:47:50 +0200
Message-ID: <20230716194932.456890517@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 880d51c729a3fa944794feb19f605eefe55916fc ]

In pci_epf_test_init_dma_chan() epf_test->dma_chan_rx is assigned from
dma_request_channel() with DMA_DEV_TO_MEM as filter.dma_mask.

However, in pci_epf_test_data_transfer() if the dir is DMA_DEV_TO_MEM,
epf->dma_chan_rx should be used but instead we are using
epf_test->dma_chan_tx.

Fix it.

Link: https://lore.kernel.org/r/20230412063447.2841177-1-yoshihiro.shimoda.uh@renesas.com
Fixes: 8353813c88ef ("PCI: endpoint: Enable DMA tests for endpoints with DMA capabilities")
Tested-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 55283d2379a6a..f0c4d0f77453a 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -112,7 +112,7 @@ static int pci_epf_test_data_transfer(struct pci_epf_test *epf_test,
 				      size_t len, dma_addr_t dma_remote,
 				      enum dma_transfer_direction dir)
 {
-	struct dma_chan *chan = (dir == DMA_DEV_TO_MEM) ?
+	struct dma_chan *chan = (dir == DMA_MEM_TO_DEV) ?
 				 epf_test->dma_chan_tx : epf_test->dma_chan_rx;
 	dma_addr_t dma_local = (dir == DMA_MEM_TO_DEV) ? dma_src : dma_dst;
 	enum dma_ctrl_flags flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
-- 
2.39.2



