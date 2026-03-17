Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719E929D26C;
	Tue, 17 Mar 2026 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766980; cv=none; b=SazMzym5p2pJeNldi/ey29IyWufZXQ0NXJ6d7R8f7WQ9TJSsSwAoN+U2GjdAfgghY/Yya5ULwxe8JsuuEcX0DenjcSbqXVfs3gUcrJR+t3lh8CcF5CB+rPtFj7COotgLat9OjF96f30LS5C6Mv7T0VkSM4h+s+uSGcTzW9AiMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766980; c=relaxed/simple;
	bh=Z3YGmcxUbyh74a0Y7bwa5yttn5KgbQ1wrs4vxkIB4D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kM/dIS5WDDK6wthVPuLLb3DBghGqiXPNuNIyoPNu6c/UAiOMSXSAuRlPDdZ6WqN5ZkVhsVYWAYukuqCy1IV5cK2+YPwK27dVCahFAnPA72nL5R11tVWreyg45WsyTLoy/0aeslMP+OPONZFHGZ3ZvciGkRrCZfBK9MJtZS2aPbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYVjGbcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYVjGbcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D727EC4CEF7;
	Tue, 17 Mar 2026 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766980;
	bh=Z3YGmcxUbyh74a0Y7bwa5yttn5KgbQ1wrs4vxkIB4D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYVjGbcqKZZVFNc+AnDvaAlshz4M7AwNz69RLvm+nGtER9VdYAaEVDdndeBg47cpZ
	 73gLFfJOFYTQ/7a8YOnKNF+P9abJx6OCBjkA6+P4ojIzCR5gCAb9BWEOQj+0kyLnPr
	 nhtvAQzS61px2KxgVLf9IH9YW1+M/547IpfqxZbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.19 366/378] i3c: mipi-i3c-hci: Consolidate spinlocks
Date: Tue, 17 Mar 2026 17:35:23 +0100
Message-ID: <20260317163020.444119434@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit fa12bb903bc3ed1826e355d267fe134bde95e23c upstream.

The MIPI I3C HCI driver currently uses separate spinlocks for different
contexts (PIO vs. DMA rings).  This split is unnecessary and complicates
upcoming fixes.  The driver does not support concurrent PIO and DMA
operation, and it only supports a single DMA ring, so a single lock is
sufficient for all paths.

Introduce a unified spinlock in struct i3c_hci, switch both PIO and DMA
code to use it, and remove the per-context locks.

No functional change is intended in this patch.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-5-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c |    2 ++
 drivers/i3c/master/mipi-i3c-hci/dma.c  |   14 ++++++--------
 drivers/i3c/master/mipi-i3c-hci/hci.h  |    1 +
 drivers/i3c/master/mipi-i3c-hci/pio.c  |   16 +++++++---------
 4 files changed, 16 insertions(+), 17 deletions(-)

--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -631,6 +631,8 @@ static int i3c_hci_init(struct i3c_hci *
 	if (ret)
 		return ret;
 
+	spin_lock_init(&hci->lock);
+
 	/*
 	 * Now let's reset the hardware.
 	 * SOFT_RST must be clear before we write to it.
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -133,7 +133,6 @@ struct hci_rh_data {
 	unsigned int xfer_struct_sz, resp_struct_sz, ibi_status_sz, ibi_chunk_sz;
 	unsigned int done_ptr, ibi_chunk_ptr;
 	struct hci_xfer **src_xfers;
-	spinlock_t lock;
 	struct completion op_done;
 };
 
@@ -240,7 +239,6 @@ static int hci_dma_init(struct i3c_hci *
 			goto err_out;
 		rh = &rings->headers[i];
 		rh->regs = hci->base_regs + offset;
-		spin_lock_init(&rh->lock);
 		init_completion(&rh->op_done);
 
 		rh->xfer_entries = XFER_RING_ENTRIES;
@@ -470,12 +468,12 @@ static int hci_dma_queue_xfer(struct i3c
 	}
 
 	/* take care to update the hardware enqueue pointer atomically */
-	spin_lock_irq(&rh->lock);
+	spin_lock_irq(&hci->lock);
 	op1_val = rh_reg_read(RING_OPERATION1);
 	op1_val &= ~RING_OP1_CR_ENQ_PTR;
 	op1_val |= FIELD_PREP(RING_OP1_CR_ENQ_PTR, enqueue_ptr);
 	rh_reg_write(RING_OPERATION1, op1_val);
-	spin_unlock_irq(&rh->lock);
+	spin_unlock_irq(&hci->lock);
 
 	return 0;
 }
@@ -573,12 +571,12 @@ static void hci_dma_xfer_done(struct i3c
 	}
 
 	/* take care to update the software dequeue pointer atomically */
-	spin_lock(&rh->lock);
+	spin_lock(&hci->lock);
 	op1_val = rh_reg_read(RING_OPERATION1);
 	op1_val &= ~RING_OP1_CR_SW_DEQ_PTR;
 	op1_val |= FIELD_PREP(RING_OP1_CR_SW_DEQ_PTR, done_ptr);
 	rh_reg_write(RING_OPERATION1, op1_val);
-	spin_unlock(&rh->lock);
+	spin_unlock(&hci->lock);
 }
 
 static int hci_dma_request_ibi(struct i3c_hci *hci, struct i3c_dev_desc *dev,
@@ -759,12 +757,12 @@ static void hci_dma_process_ibi(struct i
 
 done:
 	/* take care to update the ibi dequeue pointer atomically */
-	spin_lock(&rh->lock);
+	spin_lock(&hci->lock);
 	op1_val = rh_reg_read(RING_OPERATION1);
 	op1_val &= ~RING_OP1_IBI_DEQ_PTR;
 	op1_val |= FIELD_PREP(RING_OP1_IBI_DEQ_PTR, deq_ptr);
 	rh_reg_write(RING_OPERATION1, op1_val);
-	spin_unlock(&rh->lock);
+	spin_unlock(&hci->lock);
 
 	/* update the chunk pointer */
 	rh->ibi_chunk_ptr += ibi_chunks;
--- a/drivers/i3c/master/mipi-i3c-hci/hci.h
+++ b/drivers/i3c/master/mipi-i3c-hci/hci.h
@@ -45,6 +45,7 @@ struct i3c_hci {
 	const struct hci_io_ops *io;
 	void *io_data;
 	const struct hci_cmd_ops *cmd;
+	spinlock_t lock;
 	atomic_t next_cmd_tid;
 	u32 caps;
 	unsigned int quirks;
--- a/drivers/i3c/master/mipi-i3c-hci/pio.c
+++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
@@ -124,7 +124,6 @@ struct hci_pio_ibi_data {
 };
 
 struct hci_pio_data {
-	spinlock_t lock;
 	struct hci_xfer *curr_xfer, *xfer_queue;
 	struct hci_xfer *curr_rx, *rx_queue;
 	struct hci_xfer *curr_tx, *tx_queue;
@@ -146,7 +145,6 @@ static int hci_pio_init(struct i3c_hci *
 		return -ENOMEM;
 
 	hci->io_data = pio;
-	spin_lock_init(&pio->lock);
 
 	size_val = pio_reg_read(QUEUE_SIZE);
 	dev_info(&hci->master.dev, "CMD/RESP FIFO = %ld entries\n",
@@ -609,7 +607,7 @@ static int hci_pio_queue_xfer(struct i3c
 		xfer[i].data_left = xfer[i].data_len;
 	}
 
-	spin_lock_irq(&pio->lock);
+	spin_lock_irq(&hci->lock);
 	prev_queue_tail = pio->xfer_queue;
 	pio->xfer_queue = &xfer[n - 1];
 	if (pio->curr_xfer) {
@@ -623,7 +621,7 @@ static int hci_pio_queue_xfer(struct i3c
 			pio_reg_read(INTR_STATUS),
 			pio_reg_read(INTR_SIGNAL_ENABLE));
 	}
-	spin_unlock_irq(&pio->lock);
+	spin_unlock_irq(&hci->lock);
 	return 0;
 }
 
@@ -694,14 +692,14 @@ static bool hci_pio_dequeue_xfer(struct
 	struct hci_pio_data *pio = hci->io_data;
 	int ret;
 
-	spin_lock_irq(&pio->lock);
+	spin_lock_irq(&hci->lock);
 	dev_dbg(&hci->master.dev, "n=%d status=%#x/%#x", n,
 		pio_reg_read(INTR_STATUS), pio_reg_read(INTR_SIGNAL_ENABLE));
 	dev_dbg(&hci->master.dev, "main_status = %#x/%#x",
 		readl(hci->base_regs + 0x20), readl(hci->base_regs + 0x28));
 
 	ret = hci_pio_dequeue_xfer_common(hci, pio, xfer, n);
-	spin_unlock_irq(&pio->lock);
+	spin_unlock_irq(&hci->lock);
 	return ret;
 }
 
@@ -994,13 +992,13 @@ static bool hci_pio_irq_handler(struct i
 	struct hci_pio_data *pio = hci->io_data;
 	u32 status;
 
-	spin_lock(&pio->lock);
+	spin_lock(&hci->lock);
 	status = pio_reg_read(INTR_STATUS);
 	dev_dbg(&hci->master.dev, "PIO_INTR_STATUS %#x/%#x",
 		status, pio->enabled_irqs);
 	status &= pio->enabled_irqs | STAT_LATENCY_WARNINGS;
 	if (!status) {
-		spin_unlock(&pio->lock);
+		spin_unlock(&hci->lock);
 		return false;
 	}
 
@@ -1036,7 +1034,7 @@ static bool hci_pio_irq_handler(struct i
 	pio_reg_write(INTR_SIGNAL_ENABLE, pio->enabled_irqs);
 	dev_dbg(&hci->master.dev, "PIO_INTR_STATUS %#x/%#x",
 		pio_reg_read(INTR_STATUS), pio_reg_read(INTR_SIGNAL_ENABLE));
-	spin_unlock(&pio->lock);
+	spin_unlock(&hci->lock);
 	return true;
 }
 


