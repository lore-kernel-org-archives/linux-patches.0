Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4171114EC4D;
	Tue,  9 Jul 2024 11:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524290; cv=none; b=OT+iT3lNqgALJgjFq7qTAZrD6E8rKBHAPNNDFrpWz2AQ2qz0gpCV/nVwydpMoAylFhSeoZlnodbHEI6He65LcX5v8O+6lQN7ocu5QdItPySfUGNSld0Wk8wT58PluXMjDr9JYi8wMrncgbx/RIaVQhBJZgKPEWKvjATdg/3a+0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524290; c=relaxed/simple;
	bh=+Ou/YOU3y8Oy4kikYYDIM+pkOVCxEuMF3KnnDt/U3jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxMrs0NP//4fGet9IPnTXza9aL7lJv1PvMJEPqyQwW0Qa9Rdqm09hJkixRxZnBuwABfInbl6yJpHc+VvnvVAYqB4D6+DenvEtPI43TC/H3VJ8jfpg4vWC87w1NfRu1wfpyUSF11iFXsgBlQLFkJInoqIhsWDFtnf9DBeWk0Hgow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N50Mdjb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N50Mdjb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA35EC3277B;
	Tue,  9 Jul 2024 11:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524290;
	bh=+Ou/YOU3y8Oy4kikYYDIM+pkOVCxEuMF3KnnDt/U3jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N50Mdjb9/z6J+8et5VCFzA26pErU6J5tKzYLRNJznCrvdGfr4fNQJP8t7p3+A8UJT
	 ldCThTtgvLi3tYpMZM9ehJC20m8dIb7dN0WdueagMivt6rsay3v45iK8jL+h3vX9BA
	 fzlxGefx58Az/z1M1POFMnzugLKHXtc57cMPBL0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 104/197] net: txgbe: remove separate irq request for MSI and INTx
Date: Tue,  9 Jul 2024 13:09:18 +0200
Message-ID: <20240709110712.983658781@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit bd07a98178462e7a02ed2bf7dec90a00944c1da5 ]

When using MSI or INTx interrupts, request_irq() for pdev->irq will
conflict with request_threaded_irq() for txgbe->misc.irq, to cause
system crash. So remove txgbe_request_irq() for MSI/INTx case, and
rename txgbe_request_msix_irqs() since it only request for queue irqs.

Add wx->misc_irq_domain to determine whether the driver creates an IRQ
domain and threaded request the IRQs.

Fixes: aefd013624a1 ("net: txgbe: use irq_domain for interrupt controller")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |  1 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   |  5 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_irq.c    | 80 ++-----------------
 .../net/ethernet/wangxun/txgbe/txgbe_irq.h    |  2 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  2 +-
 6 files changed, 15 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index c09a6f7445754..db640ea63f034 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1959,6 +1959,7 @@ int wx_sw_init(struct wx *wx)
 	}
 
 	bitmap_zero(wx->state, WX_STATE_NBITS);
+	wx->misc_irq_domain = false;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index b62b191cc146a..bf02bd0f08407 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1997,7 +1997,8 @@ void wx_free_irq(struct wx *wx)
 	int vector;
 
 	if (!(pdev->msix_enabled)) {
-		free_irq(pdev->irq, wx);
+		if (!wx->misc_irq_domain)
+			free_irq(pdev->irq, wx);
 		return;
 	}
 
@@ -2012,7 +2013,7 @@ void wx_free_irq(struct wx *wx)
 		free_irq(entry->vector, q_vector);
 	}
 
-	if (wx->mac.type == wx_mac_em)
+	if (!wx->misc_irq_domain)
 		free_irq(wx->msix_entry->vector, wx);
 }
 EXPORT_SYMBOL(wx_free_irq);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 5aaf7b1fa2db9..0df7f5712b6f7 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1058,6 +1058,7 @@ struct wx {
 	dma_addr_t isb_dma;
 	u32 *isb_mem;
 	u32 isb_tag[WX_ISB_MAX];
+	bool misc_irq_domain;
 
 #define WX_MAX_RETA_ENTRIES 128
 #define WX_RSS_INDIR_TBL_MAX 64
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
index b3e3605d1edb3..1490fd6ddbdf9 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
@@ -27,57 +27,19 @@ void txgbe_irq_enable(struct wx *wx, bool queues)
 }
 
 /**
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
+ * txgbe_request_queue_irqs - Initialize MSI-X queue interrupts
  * @wx: board private structure
  *
- * Allocate MSI-X vectors and request interrupts from the kernel.
+ * Allocate MSI-X queue vectors and request interrupts from the kernel.
  **/
-static int txgbe_request_msix_irqs(struct wx *wx)
+int txgbe_request_queue_irqs(struct wx *wx)
 {
 	struct net_device *netdev = wx->netdev;
 	int vector, err;
 
+	if (!wx->pdev->msix_enabled)
+		return 0;
+
 	for (vector = 0; vector < wx->num_q_vectors; vector++) {
 		struct wx_q_vector *q_vector = wx->q_vector[vector];
 		struct msix_entry *entry = &wx->msix_q_entries[vector];
@@ -110,34 +72,6 @@ static int txgbe_request_msix_irqs(struct wx *wx)
 	return err;
 }
 
-/**
- * txgbe_request_irq - initialize interrupts
- * @wx: board private structure
- *
- * Attempt to configure interrupts using the best available
- * capabilities of the hardware and kernel.
- **/
-int txgbe_request_irq(struct wx *wx)
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
 static int txgbe_request_gpio_irq(struct txgbe *txgbe)
 {
 	txgbe->gpio_irq = irq_find_mapping(txgbe->misc.domain, TXGBE_IRQ_GPIO);
@@ -256,6 +190,8 @@ int txgbe_setup_misc_irq(struct txgbe *txgbe)
 	if (err)
 		goto free_gpio_irq;
 
+	wx->misc_irq_domain = true;
+
 	return 0;
 
 free_gpio_irq:
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.h
index b77945e7a0f26..e6285b94625ea 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.h
@@ -2,6 +2,6 @@
 /* Copyright (c) 2015 - 2024 Beijing WangXun Technology Co., Ltd. */
 
 void txgbe_irq_enable(struct wx *wx, bool queues);
-int txgbe_request_irq(struct wx *wx);
+int txgbe_request_queue_irqs(struct wx *wx);
 void txgbe_free_misc_irq(struct txgbe *txgbe);
 int txgbe_setup_misc_irq(struct txgbe *txgbe);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 8c7a74981b907..76b5672c0a177 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -294,7 +294,7 @@ static int txgbe_open(struct net_device *netdev)
 
 	wx_configure(wx);
 
-	err = txgbe_request_irq(wx);
+	err = txgbe_request_queue_irqs(wx);
 	if (err)
 		goto err_free_isb;
 
-- 
2.43.0



