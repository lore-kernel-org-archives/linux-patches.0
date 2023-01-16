Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CBE6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E54C433D2;
	Mon, 16 Jan 2023 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888966;
	bh=G+UxDmprDOMCoO0ThoUu+sNuKWioyzaglYr0k9cSS0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/uToQJDD2RUPDnMrttSTZjl0ykYAifLj0Lm4csH5HB3xAD2Wij+cYSudkO0MMYzd
	 uCQGg7qzaNzuCNtiVbn6soYzPzuL7io3e2rBP2uaNUi2oV8MDVEI2SIG/OfeY3Jr+a
	 8vyKm3y1yRYrjPOpXvEEjgaGsASLEa/x9H+y1q30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 206/338] mISDN: hfcpci: dont call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
Date: Mon, 16 Jan 2023 16:51:19 +0100
Message-Id: <20230116154829.968603277@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f0f596bd75a9d573ca9b587abb39cee0b916bb82 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

skb_queue_purge() is called under spin_lock_irqsave() in hfcpci_l2l1D(),
kfree_skb() is called in it, to fix this, use skb_queue_splice_init()
to move the dch->squeue to a free queue, also enqueue the tx_skb and
rx_skb, at last calling __skb_queue_purge() to free the SKBs afer unlock.

Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 3e73cb5b8304..e7ebc50788d0 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1631,16 +1631,19 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 		spin_lock_irqsave(&hc->lock, flags);
 		if (hc->hw.protocol == ISDN_P_NT_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			/* prepare deactivation */
 			Write_hfc(hc, HFCPCI_STATES, 0x40);
-			skb_queue_purge(&dch->squeue);
+			skb_queue_splice_init(&dch->squeue, &free_queue);
 			if (dch->tx_skb) {
-				dev_kfree_skb(dch->tx_skb);
+				__skb_queue_tail(&free_queue, dch->tx_skb);
 				dch->tx_skb = NULL;
 			}
 			dch->tx_idx = 0;
 			if (dch->rx_skb) {
-				dev_kfree_skb(dch->rx_skb);
+				__skb_queue_tail(&free_queue, dch->rx_skb);
 				dch->rx_skb = NULL;
 			}
 			test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
@@ -1653,10 +1656,12 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 			hc->hw.mst_m &= ~HFCPCI_MASTER;
 			Write_hfc(hc, HFCPCI_MST_MODE, hc->hw.mst_m);
 			ret = 0;
+			spin_unlock_irqrestore(&hc->lock, flags);
+			__skb_queue_purge(&free_queue);
 		} else {
 			ret = l1_event(dch->l1, hh->prim);
+			spin_unlock_irqrestore(&hc->lock, flags);
 		}
-		spin_unlock_irqrestore(&hc->lock, flags);
 		break;
 	}
 	if (!ret)
-- 
2.35.1



