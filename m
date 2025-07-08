Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED19B2E041C;
	Tue,  8 Jul 2025 16:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992645; cv=none; b=rO4lt0G7Vv6MZhPpJkd14nPxUsCY0EHbJb9TxktGE9ddZqs1YcIbcDlmcLXDxQBZ96BjHTEsS+k7H5batQ7iU7bkA8Y7SdrNZbU0XAkmWmjgdHD/2bNIgRihMPPpKkb6Dp/756pSAn8srthza6SkYm8AJs6q+OTID6Yf1UPH9GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992645; c=relaxed/simple;
	bh=4jzMJ22TmJi1dgpBN9ok9xdVgAvvJ9PMYH3tIvnfoss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaXDBJQqWFkU/yJFxz6WCNqRNBV0q9HhCmWWeEHQknzQGdDFRl7C9iKxp00vJ8tuDoLvGiGF8XlbVGGl1iMAYhrWkMUGV9hGyEP/iymwzMS6vYCQkrhcF1jQQDGQQYqYMFBGslDMuNCQpqebNnILp56WL4i5etT0ysbAFdpaltw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmtKUVDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmtKUVDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1217CC4CEED;
	Tue,  8 Jul 2025 16:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992644;
	bh=4jzMJ22TmJi1dgpBN9ok9xdVgAvvJ9PMYH3tIvnfoss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmtKUVDpGddbs+8KrNvOT9/1cm18KlqZ3uIVJydjpmdNc3cVoc57TfJbMcIMXNO+4
	 J3ZzCQePnSrsk4DJvvv5SfJ6m0+J5uFJh1FK04J6K0M4TWaLD4lqwp2KzPG1D9rCPx
	 p+9c9vbHPMerm/j63IUhk/agzeLDVjen3w1FCUpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 008/232] net: txgbe: request MISC IRQ in ndo_open
Date: Tue,  8 Jul 2025 18:20:04 +0200
Message-ID: <20250708162241.649993830@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit cc9f7f65cd2f31150b10e6956f1f0882e1bbae49 upstream.

Move the creating of irq_domain for MISC IRQ from .probe to .ndo_open,
and free it in .ndo_stop, to maintain consistency with the queue IRQs.
This it for subsequent adjustments to the IRQ vectors.

Fixes: aefd013624a1 ("net: txgbe: use irq_domain for interrupt controller")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250701063030.59340-2-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c  |    2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c |   22 ++++++++++------------
 2 files changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
@@ -68,7 +68,6 @@ free_queue_irqs:
 		free_irq(wx->msix_q_entries[vector].vector,
 			 wx->q_vector[vector]);
 	}
-	wx_reset_interrupt_capability(wx);
 	return err;
 }
 
@@ -169,6 +168,7 @@ void txgbe_free_misc_irq(struct txgbe *t
 	free_irq(txgbe->link_irq, txgbe);
 	free_irq(txgbe->misc.irq, txgbe);
 	txgbe_del_irq_domain(txgbe);
+	txgbe->wx->misc_irq_domain = false;
 }
 
 int txgbe_setup_misc_irq(struct txgbe *txgbe)
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -308,10 +308,14 @@ static int txgbe_open(struct net_device
 
 	wx_configure(wx);
 
-	err = txgbe_request_queue_irqs(wx);
+	err = txgbe_setup_misc_irq(wx->priv);
 	if (err)
 		goto err_free_resources;
 
+	err = txgbe_request_queue_irqs(wx);
+	if (err)
+		goto err_free_misc_irq;
+
 	/* Notify the stack of the actual queue counts. */
 	err = netif_set_real_num_tx_queues(netdev, wx->num_tx_queues);
 	if (err)
@@ -327,6 +331,9 @@ static int txgbe_open(struct net_device
 
 err_free_irq:
 	wx_free_irq(wx);
+err_free_misc_irq:
+	txgbe_free_misc_irq(wx->priv);
+	wx_reset_interrupt_capability(wx);
 err_free_resources:
 	wx_free_resources(wx);
 err_reset:
@@ -365,6 +372,7 @@ static int txgbe_close(struct net_device
 
 	txgbe_down(wx);
 	wx_free_irq(wx);
+	txgbe_free_misc_irq(wx->priv);
 	wx_free_resources(wx);
 	txgbe_fdir_filter_exit(wx);
 	wx_control_hw(wx, false);
@@ -410,7 +418,6 @@ static void txgbe_shutdown(struct pci_de
 int txgbe_setup_tc(struct net_device *dev, u8 tc)
 {
 	struct wx *wx = netdev_priv(dev);
-	struct txgbe *txgbe = wx->priv;
 
 	/* Hardware has to reinitialize queues and interrupts to
 	 * match packet buffer alignment. Unfortunately, the
@@ -421,7 +428,6 @@ int txgbe_setup_tc(struct net_device *de
 	else
 		txgbe_reset(wx);
 
-	txgbe_free_misc_irq(txgbe);
 	wx_clear_interrupt_scheme(wx);
 
 	if (tc)
@@ -430,7 +436,6 @@ int txgbe_setup_tc(struct net_device *de
 		netdev_reset_tc(dev);
 
 	wx_init_interrupt_scheme(wx);
-	txgbe_setup_misc_irq(txgbe);
 
 	if (netif_running(dev))
 		txgbe_open(dev);
@@ -677,13 +682,9 @@ static int txgbe_probe(struct pci_dev *p
 
 	txgbe_init_fdir(txgbe);
 
-	err = txgbe_setup_misc_irq(txgbe);
-	if (err)
-		goto err_release_hw;
-
 	err = txgbe_init_phy(txgbe);
 	if (err)
-		goto err_free_misc_irq;
+		goto err_release_hw;
 
 	err = register_netdev(netdev);
 	if (err)
@@ -711,8 +712,6 @@ static int txgbe_probe(struct pci_dev *p
 
 err_remove_phy:
 	txgbe_remove_phy(txgbe);
-err_free_misc_irq:
-	txgbe_free_misc_irq(txgbe);
 err_release_hw:
 	wx_clear_interrupt_scheme(wx);
 	wx_control_hw(wx, false);
@@ -746,7 +745,6 @@ static void txgbe_remove(struct pci_dev
 	unregister_netdev(netdev);
 
 	txgbe_remove_phy(txgbe);
-	txgbe_free_misc_irq(txgbe);
 	wx_free_isb_resources(wx);
 
 	pci_release_selected_regions(pdev,


