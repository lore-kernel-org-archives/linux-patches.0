Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CE161FDF;
	Mon, 27 May 2024 19:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838705; cv=none; b=YA9knLCDnh3gODNt3CTo5Ja1kk5fA9WNGAYIiuTEY16NzKbzwng2AX5ffp4r5DZ2aSztx5yEsQ/xZVCwc9LUu0D70LstAEN58QSO72AoboubPZXiMQBwNWjR8p6i5UjQ59ehgJqTR9Y9vTbBr4Tlu1j2C6DGCRBADRFzDpJzeX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838705; c=relaxed/simple;
	bh=Vj4Q5LStmDtxGgKHplMV/fxNpSKlTPQLRI1bKV5NO6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgIhfh1dY5DFv7cANSNre8mwCV7zYmkJK/s5ymKLE7IqXuYbxjlyjzEsJEXCOe09OGTdrUTKHn4ZZYqpPBWdH9MxE8eAcDcjLdhr7CDGvhXYdTPy3orV62YlrYRVjQhVa95E7sOT0XM38QQyYyO7FRw+5MUeUkjAZ1DalU2fyBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ygrn5aAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ygrn5aAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC8EC2BBFC;
	Mon, 27 May 2024 19:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838705;
	bh=Vj4Q5LStmDtxGgKHplMV/fxNpSKlTPQLRI1bKV5NO6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ygrn5aAMKpJ8haHWnXI5CcnfLHE/xoYGUM4PgLFY+G9oFzrkI+SWcpNGzzzdVe4L/
	 kV/pgQQ0LQp2qcDcXofdctpNZH8mmqH9zKxizPpaYcOclGMxb13PBPBbie+nXJudqn
	 C27kZkKxtYZp+ze2X5inKBOeQhMZXFZZjiZyt5KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 486/493] net: txgbe: move interrupt codes to a separate file
Date: Mon, 27 May 2024 20:58:08 +0200
Message-ID: <20240527185646.034120761@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 63aabc3ef1961a5eb3049d02a323b3b7fabb9a23 ]

In order to change the interrupt response structure, there will be a
lot of code added next. Move these interrupt codes to a new file, to
make the codes cleaner.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 1d3c6414950b ("net: txgbe: fix to control VLAN strip")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_irq.c    | 137 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_irq.h    |   5 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 128 +---------------
 4 files changed, 144 insertions(+), 127 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.h

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 7507f762edfe5..42718875277c8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_TXGBE) += txgbe.o
 txgbe-objs := txgbe_main.o \
               txgbe_hw.o \
               txgbe_phy.o \
+              txgbe_irq.o \
               txgbe_ethtool.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
new file mode 100644
index 0000000000000..d26ee4cb17678
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2024 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/pci.h>
+
+#include "../libwx/wx_type.h"
+#include "../libwx/wx_lib.h"
+#include "../libwx/wx_hw.h"
+#include "txgbe_type.h"
+#include "txgbe_irq.h"
+
+/**
+ * txgbe_irq_enable - Enable default interrupt generation settings
+ * @wx: pointer to private structure
+ * @queues: enable irqs for queues
+ **/
+void txgbe_irq_enable(struct wx *wx, bool queues)
+{
+	wr32(wx, WX_PX_MISC_IEN, TXGBE_PX_MISC_IEN_MASK);
+
+	/* unmask interrupt */
+	wx_intr_enable(wx, TXGBE_INTR_MISC);
+	if (queues)
+		wx_intr_enable(wx, TXGBE_INTR_QALL(wx));
+}
+
+/**
+ * txgbe_intr - msi/legacy mode Interrupt Handler
+ * @irq: interrupt number
+ * @data: pointer to a network interface device structure
+ **/
+static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
+{
+	struct wx_q_vector *q_vector;
+	struct wx *wx  = data;
+	struct pci_dev *pdev;
+	u32 eicr;
+
+	q_vector = wx->q_vector[0];
+	pdev = wx->pdev;
+
+	eicr = wx_misc_isb(wx, WX_ISB_VEC0);
+	if (!eicr) {
+		/* shared interrupt alert!
+		 * the interrupt that we masked before the ICR read.
+		 */
+		if (netif_running(wx->netdev))
+			txgbe_irq_enable(wx, true);
+		return IRQ_NONE;        /* Not our interrupt */
+	}
+	wx->isb_mem[WX_ISB_VEC0] = 0;
+	if (!(pdev->msi_enabled))
+		wr32(wx, WX_PX_INTA, 1);
+
+	wx->isb_mem[WX_ISB_MISC] = 0;
+	/* would disable interrupts here but it is auto disabled */
+	napi_schedule_irqoff(&q_vector->napi);
+
+	/* re-enable link(maybe) and non-queue interrupts, no flush.
+	 * txgbe_poll will re-enable the queue interrupts
+	 */
+	if (netif_running(wx->netdev))
+		txgbe_irq_enable(wx, false);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * txgbe_request_msix_irqs - Initialize MSI-X interrupts
+ * @wx: board private structure
+ *
+ * Allocate MSI-X vectors and request interrupts from the kernel.
+ **/
+static int txgbe_request_msix_irqs(struct wx *wx)
+{
+	struct net_device *netdev = wx->netdev;
+	int vector, err;
+
+	for (vector = 0; vector < wx->num_q_vectors; vector++) {
+		struct wx_q_vector *q_vector = wx->q_vector[vector];
+		struct msix_entry *entry = &wx->msix_q_entries[vector];
+
+		if (q_vector->tx.ring && q_vector->rx.ring)
+			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+				 "%s-TxRx-%d", netdev->name, entry->entry);
+		else
+			/* skip this unused q_vector */
+			continue;
+
+		err = request_irq(entry->vector, wx_msix_clean_rings, 0,
+				  q_vector->name, q_vector);
+		if (err) {
+			wx_err(wx, "request_irq failed for MSIX interrupt %s Error: %d\n",
+			       q_vector->name, err);
+			goto free_queue_irqs;
+		}
+	}
+
+	return 0;
+
+free_queue_irqs:
+	while (vector) {
+		vector--;
+		free_irq(wx->msix_q_entries[vector].vector,
+			 wx->q_vector[vector]);
+	}
+	wx_reset_interrupt_capability(wx);
+	return err;
+}
+
+/**
+ * txgbe_request_irq - initialize interrupts
+ * @wx: board private structure
+ *
+ * Attempt to configure interrupts using the best available
+ * capabilities of the hardware and kernel.
+ **/
+int txgbe_request_irq(struct wx *wx)
+{
+	struct net_device *netdev = wx->netdev;
+	struct pci_dev *pdev = wx->pdev;
+	int err;
+
+	if (pdev->msix_enabled)
+		err = txgbe_request_msix_irqs(wx);
+	else if (pdev->msi_enabled)
+		err = request_irq(wx->pdev->irq, &txgbe_intr, 0,
+				  netdev->name, wx);
+	else
+		err = request_irq(wx->pdev->irq, &txgbe_intr, IRQF_SHARED,
+				  netdev->name, wx);
+
+	if (err)
+		wx_err(wx, "request_irq failed, Error %d\n", err);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.h
new file mode 100644
index 0000000000000..02c536421f7df
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2024 Beijing WangXun Technology Co., Ltd. */
+
+void txgbe_irq_enable(struct wx *wx, bool queues);
+int txgbe_request_irq(struct wx *wx);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index c13c43e07a993..10388c2016031 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -17,6 +17,7 @@
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
 #include "txgbe_phy.h"
+#include "txgbe_irq.h"
 #include "txgbe_ethtool.h"
 
 char txgbe_driver_name[] = "txgbe";
@@ -76,133 +77,6 @@ static int txgbe_enumerate_functions(struct wx *wx)
 	return physfns;
 }
 
-/**
- * txgbe_irq_enable - Enable default interrupt generation settings
- * @wx: pointer to private structure
- * @queues: enable irqs for queues
- **/
-static void txgbe_irq_enable(struct wx *wx, bool queues)
-{
-	wr32(wx, WX_PX_MISC_IEN, TXGBE_PX_MISC_IEN_MASK);
-
-	/* unmask interrupt */
-	wx_intr_enable(wx, TXGBE_INTR_MISC);
-	if (queues)
-		wx_intr_enable(wx, TXGBE_INTR_QALL(wx));
-}
-
-/**
- * txgbe_intr - msi/legacy mode Interrupt Handler
- * @irq: interrupt number
- * @data: pointer to a network interface device structure
- **/
-static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
-{
-	struct wx_q_vector *q_vector;
-	struct wx *wx  = data;
-	struct pci_dev *pdev;
-	u32 eicr;
-
-	q_vector = wx->q_vector[0];
-	pdev = wx->pdev;
-
-	eicr = wx_misc_isb(wx, WX_ISB_VEC0);
-	if (!eicr) {
-		/* shared interrupt alert!
-		 * the interrupt that we masked before the ICR read.
-		 */
-		if (netif_running(wx->netdev))
-			txgbe_irq_enable(wx, true);
-		return IRQ_NONE;        /* Not our interrupt */
-	}
-	wx->isb_mem[WX_ISB_VEC0] = 0;
-	if (!(pdev->msi_enabled))
-		wr32(wx, WX_PX_INTA, 1);
-
-	wx->isb_mem[WX_ISB_MISC] = 0;
-	/* would disable interrupts here but it is auto disabled */
-	napi_schedule_irqoff(&q_vector->napi);
-
-	/* re-enable link(maybe) and non-queue interrupts, no flush.
-	 * txgbe_poll will re-enable the queue interrupts
-	 */
-	if (netif_running(wx->netdev))
-		txgbe_irq_enable(wx, false);
-
-	return IRQ_HANDLED;
-}
-
-/**
- * txgbe_request_msix_irqs - Initialize MSI-X interrupts
- * @wx: board private structure
- *
- * Allocate MSI-X vectors and request interrupts from the kernel.
- **/
-static int txgbe_request_msix_irqs(struct wx *wx)
-{
-	struct net_device *netdev = wx->netdev;
-	int vector, err;
-
-	for (vector = 0; vector < wx->num_q_vectors; vector++) {
-		struct wx_q_vector *q_vector = wx->q_vector[vector];
-		struct msix_entry *entry = &wx->msix_q_entries[vector];
-
-		if (q_vector->tx.ring && q_vector->rx.ring)
-			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
-				 "%s-TxRx-%d", netdev->name, entry->entry);
-		else
-			/* skip this unused q_vector */
-			continue;
-
-		err = request_irq(entry->vector, wx_msix_clean_rings, 0,
-				  q_vector->name, q_vector);
-		if (err) {
-			wx_err(wx, "request_irq failed for MSIX interrupt %s Error: %d\n",
-			       q_vector->name, err);
-			goto free_queue_irqs;
-		}
-	}
-
-	return 0;
-
-free_queue_irqs:
-	while (vector) {
-		vector--;
-		free_irq(wx->msix_q_entries[vector].vector,
-			 wx->q_vector[vector]);
-	}
-	wx_reset_interrupt_capability(wx);
-	return err;
-}
-
-/**
- * txgbe_request_irq - initialize interrupts
- * @wx: board private structure
- *
- * Attempt to configure interrupts using the best available
- * capabilities of the hardware and kernel.
- **/
-static int txgbe_request_irq(struct wx *wx)
-{
-	struct net_device *netdev = wx->netdev;
-	struct pci_dev *pdev = wx->pdev;
-	int err;
-
-	if (pdev->msix_enabled)
-		err = txgbe_request_msix_irqs(wx);
-	else if (pdev->msi_enabled)
-		err = request_irq(wx->pdev->irq, &txgbe_intr, 0,
-				  netdev->name, wx);
-	else
-		err = request_irq(wx->pdev->irq, &txgbe_intr, IRQF_SHARED,
-				  netdev->name, wx);
-
-	if (err)
-		wx_err(wx, "request_irq failed, Error %d\n", err);
-
-	return err;
-}
-
 static void txgbe_up_complete(struct wx *wx)
 {
 	struct net_device *netdev = wx->netdev;
-- 
2.43.0



