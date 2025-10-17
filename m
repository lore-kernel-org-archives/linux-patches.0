Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0BB2F6932;
	Fri, 17 Oct 2025 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713933; cv=none; b=RR2r3ATXlvyocCU7Q+FI8OHyH95XMKvotxBzTpZiQJ03fPQ9ctHsuPhfxVz7xpkVBhOnfFeLJ+llPjlxHdfs7BoLXQ4xVU3lwAGRRNvIeV5bbAu+JiJg8HfP99m8pFvsJNb+zv3ejvba7L2HehWADgesxSg3tdP6HbP1QU5s418=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713933; c=relaxed/simple;
	bh=P9G7YyFHS46X4Don+1m3lIqGKJNjC2LtnPT7Yzfoftk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U73hXs/tJY/XnNKVmd2RXH2TcQmFjTr4PCw7jddtmlPb6QaUJhAr/k0ZqKfxkLDDq0aiQJQ0Q9dsdN2dopSzVmVUQWVgqaHOMrlwMV3Z/uQzxACfu798jwHhPLAhWLVeKO0uOvFwa2joiR2MSmzuYSBalBncZNnGj7M2tGsgX68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQHAmKT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQHAmKT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E2EC4CEE7;
	Fri, 17 Oct 2025 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713933;
	bh=P9G7YyFHS46X4Don+1m3lIqGKJNjC2LtnPT7Yzfoftk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQHAmKT5AhisV8/C+iHeOv/8jXDtGlItbGOBrK786v8UAd4crPqwBwTpKkzFx7esD
	 AmEWLtsB7GH6K/Y0rgc6twjMiNHc2KVAe7xMINznhwizx5MB8xJvcoDSN/euP8t/Gw
	 3Egeo5V9BUzmkNxV8AAeIvjd7ifHvCdeKQ/eXDU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/201] PCI: endpoint: pci-epf-test: Add NULL check for DMA channels before release
Date: Fri, 17 Oct 2025 16:53:51 +0200
Message-ID: <20251017145140.985649719@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 85afa9ea122dd9d4a2ead104a951d318975dcd25 ]

The fields dma_chan_tx and dma_chan_rx of the struct pci_epf_test can be
NULL even after EPF initialization. Then it is prudent to check that
they have non-NULL values before releasing the channels. Add the checks
in pci_epf_test_clean_dma_chan().

Without the checks, NULL pointer dereferences happen and they can lead
to a kernel panic in some cases:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000050
  Call trace:
   dma_release_channel+0x2c/0x120 (P)
   pci_epf_test_epc_deinit+0x94/0xc0 [pci_epf_test]
   pci_epc_deinit_notify+0x74/0xc0
   tegra_pcie_ep_pex_rst_irq+0x250/0x5d8
   irq_thread_fn+0x34/0xb8
   irq_thread+0x18c/0x2e8
   kthread+0x14c/0x210
   ret_from_fork+0x10/0x20

Fixes: 8353813c88ef ("PCI: endpoint: Enable DMA tests for endpoints with DMA capabilities")
Fixes: 5ebf3fc59bd2 ("PCI: endpoint: functions/pci-epf-test: Add DMA support to transfer data")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
[mani: trimmed the stack trace]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250916025756.34807-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -282,15 +282,20 @@ static void pci_epf_test_clean_dma_chan(
 	if (!epf_test->dma_supported)
 		return;
 
-	dma_release_channel(epf_test->dma_chan_tx);
-	if (epf_test->dma_chan_tx == epf_test->dma_chan_rx) {
+	if (epf_test->dma_chan_tx) {
+		dma_release_channel(epf_test->dma_chan_tx);
+		if (epf_test->dma_chan_tx == epf_test->dma_chan_rx) {
+			epf_test->dma_chan_tx = NULL;
+			epf_test->dma_chan_rx = NULL;
+			return;
+		}
 		epf_test->dma_chan_tx = NULL;
-		epf_test->dma_chan_rx = NULL;
-		return;
 	}
 
-	dma_release_channel(epf_test->dma_chan_rx);
-	epf_test->dma_chan_rx = NULL;
+	if (epf_test->dma_chan_rx) {
+		dma_release_channel(epf_test->dma_chan_rx);
+		epf_test->dma_chan_rx = NULL;
+	}
 }
 
 static void pci_epf_test_print_rate(struct pci_epf_test *epf_test,


