Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD5A6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D9DC433D2;
	Mon, 16 Jan 2023 17:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888961;
	bh=MrK5vpleQZZTtTWJEzwNl2vyk/lNqUyP7INMPV/lEcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOrNZbRabCFzGhgIa8OoEqSgan93Joc3wMD9JHI1WI6nIBivW08C4BJiAgpjg9Iib
	 m4Jokeg8RuUw1wxFfu//V0yQ+SLIRx6gWmm+pCGk78rrba810ounJBqnOHRq89XcZE
	 XhPH/Hpr+gCkYMUzomrLVcQLErwG9lQsl3QlhrxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 205/338] mISDN: hfcsusb: dont call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
Date: Mon, 16 Jan 2023 16:51:18 +0100
Message-Id: <20230116154829.927639240@linuxfoundation.org>
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

[ Upstream commit ddc9648db162eee556edd5222d2808fe33730203 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

skb_queue_purge() is called under spin_lock_irqsave() in hfcusb_l2l1D(),
kfree_skb() is called in it, to fix this, use skb_queue_splice_init()
to move the dch->squeue to a free queue, also enqueue the tx_skb and
rx_skb, at last calling __skb_queue_purge() to free the SKBs afer unlock.

In tx_iso_complete(), dev_kfree_skb() is called to consume the transmitted
SKB, so replace it with dev_consume_skb_irq().

Fixes: 69f52adb2d53 ("mISDN: Add HFC USB driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 87588198d68f..3be213750303 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -337,20 +337,24 @@ hfcusb_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 
 		if (hw->protocol == ISDN_P_NT_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			hfcsusb_ph_command(hw, HFC_L1_DEACTIVATE_NT);
 			spin_lock_irqsave(&hw->lock, flags);
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
 			spin_unlock_irqrestore(&hw->lock, flags);
+			__skb_queue_purge(&free_queue);
 #ifdef FIXME
 			if (test_and_clear_bit(FLG_L1_BUSY, &dch->Flags))
 				dchannel_sched_event(&hc->dch, D_CLEARBUSY);
@@ -1340,7 +1344,7 @@ tx_iso_complete(struct urb *urb)
 					printk("\n");
 				}
 
-				dev_kfree_skb(tx_skb);
+				dev_consume_skb_irq(tx_skb);
 				tx_skb = NULL;
 				if (fifo->dch && get_next_dframe(fifo->dch))
 					tx_skb = fifo->dch->tx_skb;
-- 
2.35.1



