Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72DE1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5391AC433C9;
	Fri, 21 Jul 2023 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956347;
	bh=R7Th58nYEbmyiqEVyhF9xHgupVq1sXc6HPxHALYivw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UesdVanK+CRhw8d5LaJXVhXQn7hif85VmI1s4g2htc7H7SHI8uXXmK0R7OTvb2olj
	 ILzl1nLnpKa6xzuJpfMI9gjX4EMkK9O11uyQvOrz741u3OReO//iNAoYEGQ19Zw35o
	 xx9XQrT5vPVxBcjZo93/K+87g5pHa3CKs1wH0AUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.4 175/292] PCI: epf-test: Fix DMA transfer completion detection
Date: Fri, 21 Jul 2023 18:04:44 +0200
Message-ID: <20230721160536.418301690@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

commit 933f31a2fe1f20e5b1ee065579f652cd1b317183 upstream.

pci_epf_test_data_transfer() and pci_epf_test_dma_callback() are not
handling DMA transfer completion correctly, leading to completion
notifications to the RC side that are too early. This problem can be
detected when the RC side is running an IOMMU with messages such as:

  pci-endpoint-test 0000:0b:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x001c address=0xfff00000 flags=0x0000]

When running the pcitest.sh tests: the address used for a previous
test transfer generates the above error while the next test transfer is
running.

Fix this by testing the DMA transfer status in pci_epf_test_dma_callback()
and notifying the completion only when the transfer status is DMA_COMPLETE
or DMA_ERROR. Furthermore, in pci_epf_test_data_transfer(), be paranoid and
check again the transfer status and always call dmaengine_terminate_sync()
before returning.

Link: https://lore.kernel.org/r/20230415023542.77601-5-dlemoal@kernel.org
Fixes: 8353813c88ef ("PCI: endpoint: Enable DMA tests for endpoints with DMA capabilities")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c |   36 ++++++++++++++++++--------
 1 file changed, 26 insertions(+), 10 deletions(-)

--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -54,6 +54,9 @@ struct pci_epf_test {
 	struct delayed_work	cmd_handler;
 	struct dma_chan		*dma_chan_tx;
 	struct dma_chan		*dma_chan_rx;
+	struct dma_chan		*transfer_chan;
+	dma_cookie_t		transfer_cookie;
+	enum dma_status		transfer_status;
 	struct completion	transfer_complete;
 	bool			dma_supported;
 	bool			dma_private;
@@ -85,8 +88,14 @@ static size_t bar_size[] = { 512, 512, 1
 static void pci_epf_test_dma_callback(void *param)
 {
 	struct pci_epf_test *epf_test = param;
+	struct dma_tx_state state;
 
-	complete(&epf_test->transfer_complete);
+	epf_test->transfer_status =
+		dmaengine_tx_status(epf_test->transfer_chan,
+				    epf_test->transfer_cookie, &state);
+	if (epf_test->transfer_status == DMA_COMPLETE ||
+	    epf_test->transfer_status == DMA_ERROR)
+		complete(&epf_test->transfer_complete);
 }
 
 /**
@@ -120,7 +129,6 @@ static int pci_epf_test_data_transfer(st
 	struct dma_async_tx_descriptor *tx;
 	struct dma_slave_config sconf = {};
 	struct device *dev = &epf->dev;
-	dma_cookie_t cookie;
 	int ret;
 
 	if (IS_ERR_OR_NULL(chan)) {
@@ -152,25 +160,33 @@ static int pci_epf_test_data_transfer(st
 	}
 
 	reinit_completion(&epf_test->transfer_complete);
+	epf_test->transfer_chan = chan;
 	tx->callback = pci_epf_test_dma_callback;
 	tx->callback_param = epf_test;
-	cookie = tx->tx_submit(tx);
+	epf_test->transfer_cookie = tx->tx_submit(tx);
 
-	ret = dma_submit_error(cookie);
+	ret = dma_submit_error(epf_test->transfer_cookie);
 	if (ret) {
-		dev_err(dev, "Failed to do DMA tx_submit %d\n", cookie);
-		return -EIO;
+		dev_err(dev, "Failed to do DMA tx_submit %d\n", ret);
+		goto terminate;
 	}
 
 	dma_async_issue_pending(chan);
 	ret = wait_for_completion_interruptible(&epf_test->transfer_complete);
 	if (ret < 0) {
-		dmaengine_terminate_sync(chan);
-		dev_err(dev, "DMA wait_for_completion_timeout\n");
-		return -ETIMEDOUT;
+		dev_err(dev, "DMA wait_for_completion interrupted\n");
+		goto terminate;
+	}
+
+	if (epf_test->transfer_status == DMA_ERROR) {
+		dev_err(dev, "DMA transfer failed\n");
+		ret = -EIO;
 	}
 
-	return 0;
+terminate:
+	dmaengine_terminate_sync(chan);
+
+	return ret;
 }
 
 struct epf_dma_filter {


