Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A30F158A19;
	Tue,  9 Jul 2024 11:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524205; cv=none; b=lhojZQxVnOLTt8u1gEGTvDNLcKFUFdU4k7m329idMjZZZI4cyQZrcSRzswhcLogKkKwzb2Ges39QbcCz1YYXIK4NaZkkZCWN6xx+0DuA74Km3mgx6Z1U4ONgwn/+i49GLqhuYxkBKIM9fVnQRRCw/KUH8Pm/ua6m+tddqt1oSDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524205; c=relaxed/simple;
	bh=TXYKLTsnpZ5xx5j45eLSMNAi3uket0Wv9EF+BxTtIEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D71hYXtfB9oyovH0bNU3gC7grP4t7CTjr/OSDjtpgvb5NJ427QieCRL4WShC/TROnwg5XrUPDxs7900pefr1mriuGqSLEZ7SabA9B1W1arkH+iRG3XqwmSH3EV4V0vzzk5hjkbwCc6c6AfAUVIWi5cRM6VV1iGCFdIy8ai7tGmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/0XBNO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/0XBNO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E690C3277B;
	Tue,  9 Jul 2024 11:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524204;
	bh=TXYKLTsnpZ5xx5j45eLSMNAi3uket0Wv9EF+BxTtIEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/0XBNO1TOQElUK8fDkCg9mqosFzvPTW5Umy6EpGJgSKevp8Z4YxkbyGoUxf2kGxq
	 1EBH8U1sX0zQRQ447RpYzQCOLUMOXMnH8Ha4V9lse6hC6v1Qbza4Wd27W+q+R0+vu9
	 qWceovY63NMG5RfOPHT+WDXkFVmFRh7+1NDEnI3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 106/197] net: txgbe: free isb resources at the right time
Date: Tue,  9 Jul 2024 13:09:20 +0200
Message-ID: <20240709110713.061160063@linuxfoundation.org>
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

[ Upstream commit 935124dd5883b5de68dc5a94f582480a10643dc9 ]

When using MSI/INTx interrupt, the shared interrupts are still being
handled in the device remove routine, before free IRQs. So isb memory
is still read after it is freed. Thus move wx_free_isb_resources()
from txgbe_close() to txgbe_remove(). And fix the improper isb free
action in txgbe_open() error handling path.

Fixes: aefd013624a1 ("net: txgbe: use irq_domain for interrupt controller")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c     | 4 +++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c   | 2 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 7 ++++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index bf02bd0f08407..88e5e390770b5 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2028,6 +2028,9 @@ int wx_setup_isb_resources(struct wx *wx)
 {
 	struct pci_dev *pdev = wx->pdev;
 
+	if (wx->isb_mem)
+		return 0;
+
 	wx->isb_mem = dma_alloc_coherent(&pdev->dev,
 					 sizeof(u32) * 4,
 					 &wx->isb_dma,
@@ -2387,7 +2390,6 @@ static void wx_free_all_tx_resources(struct wx *wx)
 
 void wx_free_resources(struct wx *wx)
 {
-	wx_free_isb_resources(wx);
 	wx_free_all_rx_resources(wx);
 	wx_free_all_tx_resources(wx);
 }
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index e894e01d030d1..af30ca0312b81 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -387,6 +387,7 @@ static int ngbe_open(struct net_device *netdev)
 err_free_irq:
 	wx_free_irq(wx);
 err_free_resources:
+	wx_free_isb_resources(wx);
 	wx_free_resources(wx);
 	return err;
 }
@@ -408,6 +409,7 @@ static int ngbe_close(struct net_device *netdev)
 
 	ngbe_down(wx);
 	wx_free_irq(wx);
+	wx_free_isb_resources(wx);
 	wx_free_resources(wx);
 	phylink_disconnect_phy(wx->phylink);
 	wx_control_hw(wx, false);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 76b5672c0a177..ca74d9422065a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -296,7 +296,7 @@ static int txgbe_open(struct net_device *netdev)
 
 	err = txgbe_request_queue_irqs(wx);
 	if (err)
-		goto err_free_isb;
+		goto err_free_resources;
 
 	/* Notify the stack of the actual queue counts. */
 	err = netif_set_real_num_tx_queues(netdev, wx->num_tx_queues);
@@ -313,8 +313,8 @@ static int txgbe_open(struct net_device *netdev)
 
 err_free_irq:
 	wx_free_irq(wx);
-err_free_isb:
-	wx_free_isb_resources(wx);
+err_free_resources:
+	wx_free_resources(wx);
 err_reset:
 	txgbe_reset(wx);
 
@@ -729,6 +729,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 
 	txgbe_remove_phy(txgbe);
 	txgbe_free_misc_irq(txgbe);
+	wx_free_isb_resources(wx);
 
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
-- 
2.43.0



