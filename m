Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B441CB31A;
	Thu,  6 Jun 2024 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683753; cv=none; b=nZfeNsDWck4uRe8tkjRxzCs1Z5fQ0uye93O1vvdNUt1WYpgf3ueyBhGrTNfGEnSY7PxY9gF4wKWWnwUiM6r6895oSeNQb0QGfRd9vxYCSkLmw1bFcz52OeEsBqsw8uCh5dJtkeGP0NcFscoUOss0vL0RSNN8U2EyXiTnMte5OO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683753; c=relaxed/simple;
	bh=3i4W3Y2q7spMEcyh7Nv1BdVIxRRMfUvVtAKNyo/JTAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2+Zwk0MrbVBzCWZgYWMZkD4vwIGg0A8sbafHWTM7AJVLkDPDIheQkaP+8PpX4NILjiSU5ILQIwMPRlTSwl/B3ENlhK/E8cI59Dg3zJAiEyMU1WQ7IabdI2+QcPN1o/P97HYIyJbMOavyCDKM3KrqPA9oxHvxmtLMFW2kSqEfIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACqR8Q0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACqR8Q0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C7CC32781;
	Thu,  6 Jun 2024 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683753;
	bh=3i4W3Y2q7spMEcyh7Nv1BdVIxRRMfUvVtAKNyo/JTAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACqR8Q0qGhBY79BD5m8D5s1Z+9VyX2CYvl3wU+p10lnaaHexxlXBYsEfosWyfXNGx
	 grOAOJyAcYLzh6wbxvp8HDavWgLJ6SSyatN9f4DwQppawQtkDivRVDKilCG2S5OCwv
	 lDH0f9eK6GropUL+p89pUJsSxw/o7ftqYD9rsUtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 725/744] net: ena: Fix redundant device NUMA node override
Date: Thu,  6 Jun 2024 16:06:37 +0200
Message-ID: <20240606131755.722926625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shay Agroskin <shayagr@amazon.com>

[ Upstream commit 2dc8b1e7177d4f49f492ce648440caf2de0c3616 ]

The driver overrides the NUMA node id of the device regardless of
whether it knows its correct value (often setting it to -1 even though
the node id is advertised in 'struct device'). This can lead to
suboptimal configurations.

This patch fixes this behavior and makes the shared memory allocation
functions use the NUMA node id advertised by the underlying device.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Link: https://lore.kernel.org/r/20240528170912.1204417-1-shayagr@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index e733419dd3f49..276f6a8631fb1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -312,7 +312,6 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 			      struct ena_com_io_sq *io_sq)
 {
 	size_t size;
-	int dev_node = 0;
 
 	memset(&io_sq->desc_addr, 0x0, sizeof(io_sq->desc_addr));
 
@@ -325,12 +324,9 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 	size = io_sq->desc_entry_size * io_sq->q_depth;
 
 	if (io_sq->mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_HOST) {
-		dev_node = dev_to_node(ena_dev->dmadev);
-		set_dev_node(ena_dev->dmadev, ctx->numa_node);
 		io_sq->desc_addr.virt_addr =
 			dma_alloc_coherent(ena_dev->dmadev, size, &io_sq->desc_addr.phys_addr,
 					   GFP_KERNEL);
-		set_dev_node(ena_dev->dmadev, dev_node);
 		if (!io_sq->desc_addr.virt_addr) {
 			io_sq->desc_addr.virt_addr =
 				dma_alloc_coherent(ena_dev->dmadev, size,
@@ -354,10 +350,7 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 		size = (size_t)io_sq->bounce_buf_ctrl.buffer_size *
 			io_sq->bounce_buf_ctrl.buffers_num;
 
-		dev_node = dev_to_node(ena_dev->dmadev);
-		set_dev_node(ena_dev->dmadev, ctx->numa_node);
 		io_sq->bounce_buf_ctrl.base_buffer = devm_kzalloc(ena_dev->dmadev, size, GFP_KERNEL);
-		set_dev_node(ena_dev->dmadev, dev_node);
 		if (!io_sq->bounce_buf_ctrl.base_buffer)
 			io_sq->bounce_buf_ctrl.base_buffer =
 				devm_kzalloc(ena_dev->dmadev, size, GFP_KERNEL);
@@ -397,7 +390,6 @@ static int ena_com_init_io_cq(struct ena_com_dev *ena_dev,
 			      struct ena_com_io_cq *io_cq)
 {
 	size_t size;
-	int prev_node = 0;
 
 	memset(&io_cq->cdesc_addr, 0x0, sizeof(io_cq->cdesc_addr));
 
@@ -409,11 +401,8 @@ static int ena_com_init_io_cq(struct ena_com_dev *ena_dev,
 
 	size = io_cq->cdesc_entry_size_in_bytes * io_cq->q_depth;
 
-	prev_node = dev_to_node(ena_dev->dmadev);
-	set_dev_node(ena_dev->dmadev, ctx->numa_node);
 	io_cq->cdesc_addr.virt_addr =
 		dma_alloc_coherent(ena_dev->dmadev, size, &io_cq->cdesc_addr.phys_addr, GFP_KERNEL);
-	set_dev_node(ena_dev->dmadev, prev_node);
 	if (!io_cq->cdesc_addr.virt_addr) {
 		io_cq->cdesc_addr.virt_addr =
 			dma_alloc_coherent(ena_dev->dmadev, size, &io_cq->cdesc_addr.phys_addr,
-- 
2.43.0



